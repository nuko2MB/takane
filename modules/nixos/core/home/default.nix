{
  inputs,
  config,
  lib,
  options,
  ...
}:
with lib;
let
  cfg = config.nuko.home;
in
{
  imports = with inputs; [ home-manager.nixosModules.home-manager ];

  options.nuko.home = with types; {
    file = mkOption {
      type = types.attrs;
      description = ''
        A set of files to be managed by home-manager's <option>home.file</option>.
      '';
    };
    configFile = mkOption {
      type = types.attrs;
      description = ''
        A set of files to be managed by home-manager's <option>xdg.configFile</option>.
      '';
    };
    dataFile = mkOption {
      type = types.attrs;
      description = ''
        A set of files to be managed by home-manager's <option>xdg.dataFile</option>.
      '';
    };
    extraOptions = mkOption {
      type = types.attrs;
      description = ''
        Options to pass directly to home-manager.
      '';
    };
    programs = mkOption {
      type = types.attrs;
      description = ''
        Options to pass directly to home-manager.
      '';
    };
  };

  config = {
    nuko.home.extraOptions = {
      home.stateVersion = config.system.stateVersion;
      home.file = mkAliasDefinitions options.nuko.home.file;
      programs = mkAliasDefinitions options.nuko.home.programs;
      xdg = {
        enable = true;
        dataFile = mkAliasDefinitions options.nuko.home.dataFile;
        configFile = mkAliasDefinitions options.nuko.home.configFile;
      };
    };

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      users.${config.nuko.user.name} = mkAliasDefinitions options.nuko.home.extraOptions;
    };
  };
}
