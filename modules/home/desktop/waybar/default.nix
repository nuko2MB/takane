{ lib, ... }@args:
lib.nuko.mkModule args
  [
    "desktop"
    "waybar"
  ]
  {
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "bottom";
          height = 15;

          modules-left = [ "hyprland/workspaces" ];
          modules-center = [ "mpris" ];
          modules-right = [
            "tray"
            "clock"
          ];

          tray = {
            icon-size = 20;
            spacing = 7;
          };

          clock = {
            format = "{:%I:%M %p}";
          };

          mpris = {
            format = "{player_icon}  {dynamic}";
            format-paused = "{status_icon}  <i>{dynamic}</i>";
            dynamic-order = [
              "artist"
              "title"
            ];
            player-icons = {
              default = "󰏤";
            };
            status-icons = {
              paused = "󰐊";
            };
            max-length = 1000;
            # interval = 1;
          };
        };
      };
      style = ./waybar.css;
    };
  }
