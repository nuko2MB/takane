{
  description = "nuko's nix config";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    # Pin nixpkgs until issues with pipewire/wireplubmer modules are fixed.
    nixpkgs.url = "github:nixos/nixpkgs/53f519cddb0f1a4e78e4450933d1989103dc95ed";
    unstable.url = "github:nixos/nixpkgs/53f519cddb0f1a4e78e4450933d1989103dc95ed";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      #url = "github:nix-community/home-manager/release-23.11";
      url = "github:nix-community/home-manager/master";
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

    crane = {
      url = "github:ipetkov/crane";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprlock.url = "github:hyprwm/hyprlock";
    hypridle.url = "github:hyprwm/hypridle";
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
