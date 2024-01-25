{ lib, pkgs, ... }@args:
lib.nuko.mkModule args
  [
    "gaming"
    "prismlauncher"
  ]
  {
    # Prismlauncher is overlayed with the git version and extra jdk's
    environment.systemPackages = [ pkgs.prismlauncher ];

    # Cache for prismlauncher-git flake to avoid rebuilds.
    nuko.nix.extra-substituters = {
      "https://cache.garnix.io".key = "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=";
    };
  }
