{ config, lib, ... }:
let
  inherit (lib) mkIf mkOption types;
  cfg = config.nuko;
in
{
  options.nuko.createPaths = mkOption {
    type = types.listOf types.path;
    default = [ ];
  };

  config =
    let
      createPathRules = lst: bits: lib.forEach lst (x: "d ${x} ${toString bits} - -");
    in
    {
      systemd.tmpfiles.rules = mkIf (cfg.createPaths != [ ]) (createPathRules cfg.createPaths 777);
    };
}
