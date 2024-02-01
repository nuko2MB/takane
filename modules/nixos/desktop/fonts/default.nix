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
    replaceFonts = mkBoolOpt cfg.enable "Weather or not to install font replacement config.";
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
        ++ lib.optionals cfg.replaceFonts [
          roboto
          garamond-libre
          courier-prime
          gelasio
          caladea
          noto-fonts
          lato
          libre-baskerville
          libertinus
          fira-mono
          merriweather
          merriweather-sans
          comic-relief # comic-neu
          (google-fonts.override { fonts = [ "Arimo" ]; })
        ]
        ++ cfg.fonts;

      fontconfig.defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Inter" ];
        monospace = [ "JetBrainsMono Nerd Font" ];
        emoji = [ "Noto Color Emoji" ];
      };

      fontconfig.localConf = mkIf cfg.replaceFonts (builtins.readFile ./replacements.conf);

      # fontconfig.subpixel.rgba = "rgb";
    };
  };
}
