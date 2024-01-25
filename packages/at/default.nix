{ pkgs, ... }:
let
  flake = "$HOME/takane";
in
pkgs.writeShellScriptBin "@" ''
  gitAdd() {
     git -C ${flake} add --all
  }

  build () {
    gitAdd
    sudo nixos-rebuild switch --flake ${flake} $@
  }

  test () {
    nixos-rebuild dry-build --flake ${flake} $@
  }

  update () {
    gitAdd
    nix flake update ${flake} $@
  }

  upgrade () {
    gitAdd
    update
    build
  }

  repl () {
    nix repl --expr 'import <nixpkgs>{}'
  }

  edit() {
    code ${flake}
  }

  if [ $# -eq 0 ]
    then
      build $@
    else
    "$@"
  fi
''
