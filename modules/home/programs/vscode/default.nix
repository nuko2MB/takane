{ pkgs, lib, ... }@args:
lib.nuko.mkModule args
  [
    "programs"
    "vscode"
  ]
  {
    programs.vscode = {
      enable = true;
      mutableExtensionsDir = false;
      extensions =
        with pkgs.vscode-extensions;
        [
          jnoortheen.nix-ide
          catppuccin.catppuccin-vsc
          tamasfe.even-better-toml
          rust-lang.rust-analyzer
          mkhl.direnv
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "vscode-nushell-lang";
            publisher = "thenuprojectcontributors";
            version = "1.8.0";
            sha256 = "sha256-Si7N50vonpG79lPingGZiNAZjeoRJ45PDuolnR9a9tY=";
          }
        ];
      userSettings = {
        "window.titleBarStyle" = "custom";
        "editor.fontSize" = lib.mkDefault 16;
        "workbench.colorTheme" = lib.mkDefault "Default Dark+";
        "editor.fontLigatures" = true;
        "editor.fontFamily" = lib.mkDefault "'JetBrainsMono Nerd Font','Droid Sans Mono', 'monospace', monospace";
        "editor.formatOnSave" = true;
        #"nix.formatterPath" = "nixfmt";
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";
        "nix.serverSettings" = {
          nil = {
            formatting = {
              command = [ "nixfmt" ];
            };
          };
        };
      };
      # TODO
      /* // lib.optionalAttrs (osConfig.nuko.theme.fonts.monospace.name != null) {
            "editor.fontFamily" = "'${osConfig.nuko.theme.fonts.monospace.name}'";
         };
      */
    };
    # Slint extension does not work. It tries to use the bundled language server. Needs to be patched or wrapped somehow.
    /* ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
         {
           name = "slint";
           publisher = "Slint";
           version = "1.2.2";
           sha256 = "sha256-cSv3+dN1hNJVuQDFzqOAZVntLVWBg9uzMOiU+Op+cJ0=";
         }
       ];
    */
  }
