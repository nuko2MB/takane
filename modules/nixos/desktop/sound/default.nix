{ lib, inputs, ... }@args:
lib.nuko.mkModule' args "sound" [ inputs.nix-gaming.nixosModules.pipewireLowLatency ] {
  hardware.pulseaudio.enable = lib.mkForce false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    lowLatency = {
      enable = true;
      #quantum = 64;
      #rate = 48000;
    };
  };
  security.rtkit.enable = true;

  # Bug fix where auido stops working with multiple streams.
  # https://wiki.archlinux.org/title/PipeWire#Audio_cutting_out_when_multiple_streams_start_playing
  environment.etc = {
    "wireplumber/main.lua.d/50-alsa-config.lua".text = ''
      alsa_monitor.rules = {
        {
          matches = {
            {
              -- Matches all sources.
              { "node.name", "matches", "alsa_input.*" },
            },
            {
              -- Matches all sinks.
              { "node.name", "matches", "alsa_output.*" },
            },
          },
          apply_properties = {
            ["api.alsa.headroom"] = 1024,
          },
        },
      }
    '';

    # Use soft mixer because of issues with absolute volume.
    "wireplumber/main.lua.d/51-volume-fix.lua".text = ''
      table.insert (alsa_monitor.rules, {
        matches = {
          {
            -- This matches all cards.
            { "device.name", "matches", "alsa_card.*" },
          },
        },
        -- Apply properties on the matched object.
        apply_properties = {
          -- Do not use the hardware mixer for volume control. It
          -- will only use software volume. The mixer is still used
          -- to mute unused paths based on the selected port.
          ["api.alsa.soft-mixer"] = true,
        }
      })
    '';

    # Sound does not automatically switch when connecting a new device
    "pipewire/pipewire-pulse.conf.d/switch-on-connect.conf".text = ''
      # override for pipewire-pulse.conf file
      pulse.cmd = [
          { cmd = "load-module" args = "module-always-sink" flags = [ ] }
          { cmd = "load-module" args = "module-switch-on-connect" }
      ]
    '';
  };

  # Udev rule to disable hardware volume control.
  services.udev.extraRules = ''
    ACTION=="add", ATTR{idVendor}=="1377", ATTR{idProduct}=="6004", RUN+="/bin/sh -c 'echo 0 > /sys$DEVPATH/`basename $DEVPATH`:1.2/authorized'"
  '';
}
