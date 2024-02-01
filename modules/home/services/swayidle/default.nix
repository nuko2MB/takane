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
          {
            timeout = 900;
            command = "${hyprctl} dispatch dpms off";
            resumeCommand = "${hyprctl} dispatch dpms on";
          }
          {
            timeout = 1200;
            command = "${lib.getExe' pkgs.systemd "systemctl"} suspend";
          }
        ];
        events = [
          {
            event = "before-sleep";
            command = "${swaylock}/bin/swaylock";
          }
        ];
        systemdTarget = "hyprland-session.target";
      };
  }
