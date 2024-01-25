 #/bin/sh
 if [ "$EUID" -ne 0 ]
  then echo "Install script requires as root"
  exit
fi

 function disko() {
  nix --extra-experimental-features "nix-command flakes" run .#disko -- "$@"
 }

 echo Partitioning Disk
 disko -m disko -f "path:$(pwd)#$1" # using "." for relative path doesn't work for whatever reason.
 echo Done
 echo Installing system
 nixos-install --no-root-passwd --flake .#$1
