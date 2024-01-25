{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.nuko;
let
  cfg = config.nuko.desktop.xdg-portal;
in
{
  options.nuko.desktop.xdg-portal = with types; {
    enable = mkBoolOpt false "Whether or not to add support for xdg portal.";
  };

  config = mkIf cfg.enable {
    # https://github.com/NixOS/nixpkgs/issues/189851
    systemd.user.extraConfig = ''
      DefaultEnvironment="PATH=/run/wrappers/bin:/etc/profiles/per-user/%u/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin"
    '';

    xdg = {
      portal = {
        enable = true;

        extraPortals = with pkgs; [
          # xdg-desktop-portal-wlr
          xdg-desktop-portal-gtk
        ];

        config = {
          common.default = [ "*" ];
          # common.default = ["gtk"];
        };
      };
    };
  };
}
