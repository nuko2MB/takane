{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.nuko.vfio;
in
{
  options.nuko.vfio = {
    enable = mkEnableOption "Enable VFIO";
  };

  config = mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;
      onBoot = "ignore";
      onShutdown = "shutdown";
      qemu = {
        package = pkgs.qemu_kvm;
        ovmf = {
          enable = true;
          # https://github.com/NixOS/nixpkgs/issues/164064
          # Merged into unstable
          # TODO:
          packages = [
            (pkgs.OVMF.override {
              secureBoot = true;
              csmSupport = false;
              httpSupport = true;
              tpmSupport = true;
            }).fd
          ];
        };
        swtpm.enable = true;
        runAsRoot = false;
      };
    };
    boot = {
      kernelParams = [
        "intel_iommu=on"
        "intel_iommu=igfx_off"
      ];

      kernelModules = [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
      ];

      initrd.kernelModules = [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
      ];
    };
    environment.systemPackages = with pkgs; [ virt-manager ];
  };
}
