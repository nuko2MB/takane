{ lib, pkgs, ... }@args:
lib.nuko.mkModule args
  [
    "intel"
    "hw-accel"
  ]
  {
    hardware.opengl = {
      # Hardware Acceleration
      extraPackages = with pkgs; [
        libvdpau-va-gl
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        libvdpau-va-gl
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
      ];
    };
  }
