{
  lib,
  pkgs,
  inputs,
  config,
  osConfig,
  ...
}:
with lib.nuko;
{
  nuko = {
    desktop = {
      hyprland = enabled;
    };
    programs = {
      vscode = enabled;
      foot = enabled;
      nushell = enabled;
    };
  };

  home.sessionVariables = {
    MANGOHUD = 1;
    TERMINAL = "foot";
    EDITOR = "hx";
    NIXOS_OZONE_WL = "1"; # vscode wayland https://github.com/microsoft/vscode/issues/184124
  };

  programs = {
    # Git
    git = {
      enable = true;
      userEmail = "git@nuko.boo";
    };
    gh.enable = true;
    # TODO
    git-credential-oauth.enable = true;

    starship.enable = true;

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    mangohud = {
      enable = true;
      enableSessionWide = true;
      settings = {
        fps_only = 1;
        fps_limit = 168;
      };
      settingsPerApplication = {
        wine-Gw2-64 = {
          fps_only = 1;
          fps_limit = 168;
        };
        wine-DOOMx64vk = {
          fps_only = 1;
          fps_limit = 168;
        };
      };
    };

    mpv = {
      enable = true;
      scripts = with pkgs.mpvScripts; [
        thumbfast
        uosc
        autoload
        mpris
      ];
    };

    helix = {
      enable = true;
      defaultEditor = true;
    };
  };

  systemd.user.startServices = "sd-switch";

  # Should be auto set by nixos home module when not standalone.
  /* home = {
       username = "nuko";
       homeDirectory = "/home/nuko";
     };
  */

  #  home.stateVersion = "23.11";
  #  stateVersion is set by the home system module when home-manager is not standalone
}
