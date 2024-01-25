{
  description = "nuko's nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      #url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming.url = "github:fufexan/nix-gaming";

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    matugen = {
      url = "github:/InioX/Matugen";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    prismlauncher-git = {
      url = "github:PrismLauncher/PrismLauncher";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;
      channels-config.allowUnfree = true;

      systems.modules.nixos = with inputs; [ ];

      snowfall = {
        namespace = "nuko";
      };
    };
}
