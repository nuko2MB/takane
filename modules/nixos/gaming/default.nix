# Common settings for gaming
{ lib, ... }@args:
lib.nuko.mkModule args "gaming" {
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

  environment.sessionVariables = {
    MANGOHUD = "1";
  };
}
