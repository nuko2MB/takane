{
  lib,
  inputs,
  osConfig,
  ...
}@args:
lib.nuko.mkModule' args
  [
    "desktop"
    "hyprlock"
  ]
  [ inputs.hyprlock.homeManagerModules.default ]
  {
    programs.hyprlock = {
      enable = true;
      general = {
        grace = 5;
        hide_cursor = false;
      };
      backgrounds = [
        {
          path = osConfig.nuko.theme.wallpaper.path;
          blur_size = 4;
          blur_passes = 2;
        }
      ];
    };
  }
