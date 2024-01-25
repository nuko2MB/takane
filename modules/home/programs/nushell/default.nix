{ lib, config, ... }@args:
lib.nuko.mkModule args
  [
    "programs"
    "nushell"
  ]
  {
    programs.nushell = {
      enable = true;
      configFile.source = ./nushell.nu;
      environmentVariables =
        builtins.mapAttrs (name: value: ''"${builtins.toString value}"'')
          config.home.sessionVariables;
    };
  }
