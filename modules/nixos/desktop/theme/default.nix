{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    mkIf
    optional
    optionals
    ;
  inherit (lib.nuko) mkOpt mkOpt';
  cfg = config.nuko.theme;
in
{
  options.nuko.theme = {
    wallpaper = {
      name = mkOpt' types.str "kana.png";
      path = mkOption {
        type = types.str;
        readOnly = true;
        default = "${pkgs.nuko.wallpapers}/share/wallpapers/${cfg.wallpaper.name}";
      };
    };
    gtk = {
      enable = mkOpt' types.bool true;
      name = mkOpt' types.str "Catppuccin-Frappe-Standard-Mauve-Dark";
      package = mkOpt' types.package (
        pkgs.catppuccin-gtk.override {
          accents = [ "mauve" ];
          size = "standard";
          variant = "frappe";
        }
      );
      iconTheme = {
        name = mkOpt' types.str "Papirus-Dark";
        package = mkOpt' types.package pkgs.papirus-icon-theme;
      };
    };
    cursor = {
      enable = mkOpt' types.bool true;
      name = mkOpt' types.str "Bibata-Modern-Classic";
      package = mkOpt' types.package pkgs.bibata-cursors;
      size = mkOpt' types.int 24;
    };
  };

  config = {
    # Install gtk theme using home-manager
    nuko.home.extraOptions =
      (mkIf cfg.gtk.enable {
        gtk = {
          enable = true;
          theme = {
            inherit (cfg.gtk) name package;
          };
          iconTheme = {
            inherit (cfg.gtk.iconTheme) name package;
          };
        };
        # Link theme files in .config to enable theming for gtk4.
        xdg.configFile."gtk-4.0/gtk.css".source = "${cfg.gtk.package}/share/themes/${cfg.gtk.name}/gtk-4.0/gtk.css";
        xdg.configFile."gtk-4.0/gtk-dark.css".source = "${cfg.gtk.package}/share/themes/${cfg.gtk.name}/gtk-4.0/gtk-dark.css";
        nuko.symlink.configFile."gtk-4.0/assets" = "${cfg.gtk.package}/share/themes/${cfg.gtk.name}/gtk-4.0/assets";
      })
      # Install cursor theme using home-manager
      // (lib.mkIf cfg.cursor.enable {
        home.packages = [ cfg.cursor.package ];
        home.pointerCursor = {
          inherit (cfg.cursor) name package size;
          gtk.enable = true;
          x11.enable = true;
        };
      })
      # TODO QT Theming
      // {
        home.packages = with pkgs; [ libsForQt5.breeze-qt5 ];

        qt = {
          enable = true;
          platformTheme = "qtct";
          style.name = "breeze";
        };
      };
  };
}
