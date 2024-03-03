{ lib, pkgs, ... }@args:
lib.nuko.mkModule args
  [
    "programs"
    "obs"
  ]
  {
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs; [
        obs-studio-plugins.wlrobs
        obs-studio-plugins.obs-vaapi
      ];
    };
  }
