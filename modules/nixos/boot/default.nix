{ lib, pkgs, ... }@args:
lib.nuko.mkModule args "boot" {
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "auto";
      };
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/efi";
    };
    initrd.kernelModules = [ "amdgpu" ];
    kernelPackages = pkgs.linuxPackages_latest;
  };
}
