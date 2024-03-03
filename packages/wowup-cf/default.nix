{
  appimageTools,
  fetchurl,
  gsettings-desktop-schemas,
  gtk3,
  lib,
}:
let
  pname = "wowup-cf";
  version = "2.11.1-beta.1";
  src = fetchurl {
    url = "https://github.com/WowUp/WowUp.CF/releases/download/v${version}/WowUp-CF-${version}.AppImage";
    sha256 = "sha256-8qBdabr/qMvENnt/99AqsHJZb49S6EXq5YPlbJ+E67M=";
  };
  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    mv $out/bin/{${pname}-${version},${pname}}
    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  profile = ''
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
  '';
}
