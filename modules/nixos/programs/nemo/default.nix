{ lib, pkgs, ... }@args:
lib.nuko.mkModule args
  [
    "programs"
    "nemo"
  ]
  {
    environment.systemPackages = with pkgs; [ cinnamon.nemo-with-extensions ];

    # Set default terminal for nemo.
    # `services.xserver.desktopManager.cinnamon.extraGSettingsOverrides`
    # option does not seem to do anything when not using cinnamon.
    # https://github.com/misumisumi/nixos-desktop-config/blob/15794fa204e754ec3c82b63f9f77aaabd15e56ea/apps/xserver/gsettings.nix#L12
    environment.sessionVariables.NIX_GSETTINGS_OVERRIDES_DIR =
      let
        nixos-gsettings-overrides = pkgs.cinnamon.cinnamon-gsettings-overrides.override {
          extraGSettingsOverrides = ''
            [org.cinnamon.desktop.default-applications.terminal]
            exec= '${pkgs.foot}/bin/foot'
          '';
        };
      in
      "${nixos-gsettings-overrides}/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas";

    # Make sure nemo is the default for file explorers in xdg
    # The portal wants to use vscode as a file explorer for whatever reason.
    xdg.mime.defaultApplications = {
      "inode/directory" = "nemo.desktop";
      "inode/mount-point" = "nemo.desktop";
    };
  }
