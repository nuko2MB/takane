{ lib, pkgs, ... }@args:
lib.nuko.mkModule args
  [
    "programs"
    "cli"
  ]
  {
    environment.systemPackages = with pkgs; [
      glxinfo
      killall
      fzf
      pciutils
      usbutils
      wget
      curl
      appimage-run
      ripgrep
      nushell
      fd
      comma
      bat
      eza
      broot
    ];
  }
