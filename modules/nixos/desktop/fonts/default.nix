{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.nuko;
let
  cfg = config.nuko.desktop.fonts;
in
{
  options.nuko.desktop.fonts = with types; {
    enable = mkBoolOpt false "Whether or not to manage fonts.";
    fonts = mkOpt (listOf package) [ ] "Custom font packages to install.";
  };

  config = mkIf cfg.enable {
    environment.variables = {
      # Enable icons in tooling since we have nerdfonts.
      LOG_ICONS = "true";
    };

    environment.systemPackages = with pkgs; [ font-manager ];

    fonts = {
      fontDir.enable = true;
      # enableDefaultPackages = false;

      packages =
        with pkgs;
        [
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif
          noto-fonts-emoji
          inter
          roboto
          ubuntu_font_family

          # Mono
          (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
          source-code-pro
        ]
        ++ cfg.fonts;

      fontconfig.defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Inter" ];
        monospace = [ "JetBrainsMono Nerd Font" ];
        emoji = [ "Noto Color Emoji" ];
      };

      # fontconfig.subpixel.rgba = "rgb";
    };
  };
}
