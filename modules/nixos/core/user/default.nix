{
  options,
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.nuko;
let
  cfg = config.nuko.user;
  defaultIconFileName = "profile.jpg";
  defaultIcon = pkgs.stdenvNoCC.mkDerivation {
    name = "default-icon";
    src = ./. + "/${defaultIconFileName}";

    dontUnpack = true;

    installPhase = ''
      cp $src $out
    '';

    passthru = {
      fileName = defaultIconFileName;
    };
  };
  propagatedIcon =
    pkgs.runCommandNoCC "propagated-icon"
      {
        passthru = {
          inherit (cfg.icon) fileName;
        };
      }
      ''
        local target="$out/share/nuko-icons/user/${cfg.name}"
        mkdir -p "$target"

        cp ${cfg.icon} "$target/${cfg.icon.fileName}"
      '';
in
{
  options.nuko.user = with types; {
    name = mkOpt str "nuko" "The name to use for the user account.";
    email = mkOpt str "git@nuko.boo" "The email of the user.";
    initialPassword =
      mkOpt str "password"
        "The initial password to use when the user is first created.";
    icon = mkOpt (nullOr package) defaultIcon "The profile picture to use for the user.";
    prompt-init = mkBoolOpt true "Whether or not to show an initial message when opening a new shell.";
    extraGroups = mkOpt (listOf str) [ ] "Groups for the user to be assigned.";
    extraOptions = mkOpt attrs { } (mdDoc "Extra options passed to `users.users.<name>`.");
  };

  config = {
    environment.systemPackages = with pkgs; [ propagatedIcon ];

    nuko.home = {
      programs.nushell.enable = true;
    };

    users.users.${cfg.name} = {
      isNormalUser = true;

      inherit (cfg) name initialPassword;

      home = "/home/${cfg.name}";
      group = "users";

      shell = pkgs.nushell;

      # Arbitrary user ID to use for the user. Since I only
      # have a single user on my machines this won't ever collide.
      # However, if you add multiple users you'll need to change this
      # so each user has their own unique uid (or leave it out for the
      # system to select).
      uid = 1000;

      extraGroups = [ "steamcmd" ] ++ cfg.extraGroups;
    } // cfg.extraOptions;
  };
}
