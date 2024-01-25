{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    ;
  cfg = config.nuko.services.samba;
in
{
  options.nuko.services.samba = {
    enable = mkEnableOption "Enable samba display file sharing";
    paths = mkOption {
      type = types.listOf types.path;
      example = lib.literalExpression "[/srv/share /mnt/media]";
      description = "Paths to share";
    };
  };

  config = mkIf cfg.enable {
    # make shares visible for windows 10 clients
    services.samba-wsdd = {
      enable = true;
      openFirewall = true;
    };
    services.samba = {
      enable = true;
      openFirewall = true;

      /* extraConfig = ''
             guest account = nuko
             map to guest = bad user
             log file = /var/log/samba/client.%I
             log level = 3
         '';
      */

      shares =
        lib.foldr
          (
            item: acum:
            {
              # Workaround: SAMBA share does not work if there are "/" in the name.
              # TODO: Module should take a list of attrsets which specify a name, path and other options seperately.
              "${config.networking.hostName}${
                lib.strings.stringAsChars (x: if x == "/" then "->" else x) item
              }" = {
                path = item;
                "read only" = "no";
                "browseable" = "yes";
                "guest ok" = "yes";
                "force user" = "nobody";
                "force group" = "users";
              };
            }
            // acum
          )
          { }
          cfg.paths;
    };

    nuko.createPaths = cfg.paths;
  };
}
