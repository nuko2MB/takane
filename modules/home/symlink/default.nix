{ lib, config, ... }:
let
  inherit (lib) types mkIf foldlAttrs;
  cfg = config.nuko.symlink;
in
{
  options.nuko.symlink = {
    configFile =
      lib.nuko.mkOpt types.attrs { }
        "Create xdg.configFile entries symlinked with mkOutOfStoreSymlink";
  };

  config = mkIf (cfg.configFile != { }) {
    xdg.configFile =
      foldlAttrs
        (
          acc: name: val:
          acc // { ${name}.source = config.lib.file.mkOutOfStoreSymlink val; }
        )
        { }
        cfg.configFile;
  };
}
