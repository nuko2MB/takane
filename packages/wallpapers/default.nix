{ stdenv, ... }:
let
  installTarget = "$out/share/wallpapers";
in
stdenv.mkDerivation {
  name = "nuko-wallpapers";
  src = ./wallpapers;

  installPhase = ''
    mkdir -p ${installTarget}

    cp -a $src/. ${installTarget}/
  '';
}
