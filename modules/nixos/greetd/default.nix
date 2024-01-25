# River is the only wayland compositor that would properly run regreet and not hang for a few seconds before logging in.
{
  lib,
  pkgs,
  config,
  ...
}@args:
let
  inherit (lib) optional optionals mkIf;
  inherit (config.nuko) theme;
  regreet = lib.getExe pkgs.greetd.regreet;
  riverctl = "${pkgs.river}/bin/riverctl";
  randr = lib.getExe pkgs.wlr-randr;

  riverCfg = pkgs.writeShellScript "riverCfg" ''
    ${randr} --output DP-1 --pos 1920,0 --mode 2560x1440@170.016998Hz
    ${randr} --output DP-2 --pos 0,100 --mode 1920x1080@143.981003Hz
    ${lib.getExe pkgs.swaybg} -m fill -i "${theme.wallpaper.path}" &

    ${regreet};pkill swaybg;${riverctl} exit
  '';
in
lib.nuko.mkModule args "greetd" {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.dbus}/bin/dbus-run-session ${lib.getExe pkgs.river} -c ${riverCfg}";
      };
    };
  };

  # Make sure theme packages are installed to system config or else regreet cannot access them
  environment.systemPackages =
    (optionals theme.gtk.enable [
      theme.gtk.package
      theme.gtk.iconTheme.package
    ])
    ++ (optional theme.cursor.enable theme.cursor.package);

  programs.regreet = {
    enable = true;
    settings = {
      commands = {
        reboot = [
          "systemctl"
          "reboot"
        ];
        poweroff = [
          "systemctl"
          "poweroff"
        ];
      };
      background = {
        inherit (theme.wallpaper) path;
        fit = "Cover";
      };
      GTK = {
        font_name = "Inter * 18";
        cursor_theme_name = mkIf theme.cursor.enable theme.cursor.name;
        icon_theme_name = mkIf theme.gtk.enable theme.gtk.iconTheme.name;
        theme_name = mkIf theme.gtk.enable theme.gtk.name;
      };
    };
  };
}
