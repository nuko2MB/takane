{
  lib,
  inputs,
  pkgs,
  ...
}@args:
lib.nuko.mkModule' args
  [
    "gaming"
    "steam"
  ]
  [ inputs.nix-gaming.nixosModules.steamCompat ]
  {
    nuko.nix.extra-substituters = {
      "https://nix-gaming.cachix.org".key = "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=";
    };

    hardware.opengl = {
      enable = true;
      driSupport32Bit = true;
    };

    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      extraCompatPackages = [ inputs.nix-gaming.packages.${pkgs.system}.proton-ge ];
    };
  }
