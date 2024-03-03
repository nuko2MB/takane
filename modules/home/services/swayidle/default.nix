{
  lib,
  config,
  pkgs,
  ...
}@args:
lib.nuko.mkModule args
  [
    "services"
    "swayidle"
  ]
  {
    services.swayidle =
      let
        swaylock = config.programs.swaylock.package;
        hyprctl = pkgs.hyprland + "/bin/hyprctl";
      in
      {
        enable = true;
        timeouts = [
          {
            timeout = 600;
            command = "${swaylock}/bin/swaylock";
          }
          # Unstable Regression: 'DPMS on' after resume is not currently working.
          /* {
                      timeout = 900;
                      command = "${hyprctl} dispatch dpms off";
                      resumeCommand = "${hyprctl} dispatch dpms on";
                    }
          */
          {
            timeout = 1200;
            command = "${lib.getExe' pkgs.systemd "systemctl"} suspend";
          }
        ];
        events = [
          {
            # When manually suspending the system it should lock instantly.
            event = "before-sleep";
            command = "${swaylock}/bin/swaylock --grace 0";
          }
          {
            # When manually locking the system it should lock instantly.
            event = "lock";
            command = "${swaylock}/bin/swaylock --grace 0";
          }
          {
            event = "after-resume";
            command = "${hyprctl} dispatch dpms on";
          }
        ];
        systemdTarget = "hyprland-session.target";
      };
  }
