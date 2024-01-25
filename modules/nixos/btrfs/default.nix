{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption mkOption;
  cfg = config.nuko.filesystem.btrfs;
in
{
  imports = with inputs; [ disko.nixosModules.disko ];

  options.nuko.filesystem.btrfs = {
    enable = mkEnableOption "Enable btrfs filesystem using disko";
    device = mkOption { type = lib.types.str; };
  };

  config = mkIf cfg.enable {
    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = "/dev/${cfg.device}";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                name = "efi";
                label = "efi";
                size = "600M";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/efi";
                  mountOptions = [ "umask=0077" ];
                };
              };
              root = {
                size = "100%";
                name = "nix";
                label = "nix";
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ]; # Override existing partition
                  subvolumes = {
                    "@root" = {
                      mountpoint = "/";
                      mountOptions = [ "compress-force=zstd" ];
                    };
                    "@home" = {
                      mountOptions = [ "compress-force=zstd" ];
                      mountpoint = "/home";
                    };
                    "@var" = {
                      mountOptions = [ "compress-force=zstd" ];
                      mountpoint = "/var";
                    };
                    "@nix" = {
                      mountOptions = [
                        "compress-force=zstd"
                        "noatime"
                      ];
                      mountpoint = "/nix";
                    };
                  };

                  # mountpoint = "/rootvol";
                };
              };
            };
          };
        };
      };
    };
  };
}
