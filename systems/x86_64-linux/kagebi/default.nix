{ lib, pkgs, ... }:
with lib.nuko;
{
  imports = [ ./hardware-configuration.nix ];
  nuko = {
    nix = enabled;
    boot = enabled;
    sound = enabled;
    filesystem.btrfs = {
      enable = true;
      device = "nvme0n1";
    };
    greetd = enabled;

    gaming = {
      enable = true;
      steam = enabled;
      prismlauncher = enabled;
    };

    desktop = {
      xdg-portal = enabled;
      fonts = enabled;
    };

    services = {
      kanata = enabled;
      samba = {
        enable = true;
        paths = [ "/srv/share" ];
      };
    };

    programs = {
      cli = enabled;
      nemo = enabled;
    };

    intel.hw-accel = enabled;
  };

  zramSwap = {
    enable = true;
    memoryPercent = 25;
  };

  time.timeZone = "America/Denver";
  i18n.defaultLocale = "en_CA.UTF-8";

  networking = {
    hostName = "kagebi";
    networkmanager.enable = true;
  };

  programs.hyprland.enable = true;

  programs.dconf.enable = true;

  # Workaround: Swaylock bug : https://github.com/NixOS/nixpkgs/issues/158025
  security.pam.services.swaylock = { };

  environment.systemPackages = with pkgs; [
    #General
    firefox
    spotify
    nuko.wallpapers
    qbittorrent
    discord
    stremio
    yt-dlp

    # Cosmic Testing
    #cosmic-term
    #cosmic-files

    # Dev Tools
    cage
    git
    lapce
    nuko.at
    nil
    gh
    gittyup
    statix

    # Other
    xdg-utils
    matugen

    # Games
    protontricks
    lutris
    nuko.wowup-cf
    # xivlauncher
    # bottles
    # wowup-cf
  ];

  system.stateVersion = "23.11";
}
