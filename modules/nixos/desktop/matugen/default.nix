{
  lib,
  inputs,
  pkgs,
  config,
  ...
}:
{
  imports = [ inputs.matugen.nixosModules.default ];
}
