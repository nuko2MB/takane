{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    types
    mkOption
    mkEnableOption
    mkPackageOption
    mkIf
    ;
  cfg = config.services.swww;
in
{
  options.services.swww = {
    enable = mkEnableOption "swww: A Solution to your Wayland Wallpaper Woes";

    package = mkPackageOption pkgs "swww" { };

    systemdTarget = mkOption {
      type = types.str;
      default = "graphical-session.target";
      example = "hyprland-session.target";
      description = ''
        The systemd target that will automatically start the swww service.

        When setting this value to `"hyprland-session.target"`,
        make sure to also enable {option}`wayland.windowManager.hyprland.systemd.enable`,
        otherwise the service may never be started.
      '';
    };

    startupWallpaper = mkOption {
      type = types.nullOr types.path;
      description = "A wallpaper to set on inital startup of the daemon";
      default = null;
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.swww = {
      Unit = {
        Description = "swww Wallpaper daemon";
        Documentation = "man:swww(1)";
        PartOf = [ "graphical-session.target" ];
        After = [ cfg.systemdTarget ];
      };

      Service = {
        Type = "forking";
        Environment = [
          "PATH=${cfg.package}/bin" # Required for swww to spawn swww-daemon
          "XDG_CACHE_HOME=${config.home.homeDirectory}/.cache" # Daemon will use this to know where to cache images.
        ];
        Restart = "always"; # on-failure
        RestartSec = "500ms";
        ExecStart = "${lib.getExe cfg.package} init";
        ExecStop = "${lib.getExe cfg.package} kill";
        ExecStartPost =
          mkIf (cfg.startupWallpaper != null)
            "${cfg.package}/bin/swww img ${cfg.startupWallpaper}";
      };
      Install = {
        WantedBy = [ cfg.systemdTarget ];
      };
    };

    home.packages = [ cfg.package ];
  };
}
