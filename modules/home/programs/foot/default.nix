{ lib, ... }@args:
lib.nuko.mkModule args
  [
    "programs"
    "foot"
  ]
  {
    programs.foot = {
      enable = true;

      # Nushell bug with foot server
      #server.enable = true;
      settings = {
        main = {
          font = lib.mkDefault "JetBrainsMono Nerd Font:size=12";
        };
        colors = {
          # background = "4593b0";
          alpha = lib.mkDefault 0.94;
        };
      };
    };
  }
