{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.terra.lsp.nix;
in {
  options.terra.lsp.nix =
  let
    inherit (lib) mkEnableOption mkDoc mkOption types;
  in {
    enable = mkEnableOption (mkDoc "Enable nix language server. Default is nil.");
    pkg = mkOption {
      type = types.package;
      default = pkgs.nil;
      example = (mkDoc "pkgs.nixd");
      description = (mkDoc"The package name of the nix language server to use.");
    };
  };

  config.home-manager.users.${config.terra.user.name} = {
    home.packages = [ cfg.pkg ]; #install lsp-package

    programs.vscode =
      let code-enabled = config.home-manager.users.tristan.programs.vscode.enable; #check if vscode is enabled
      in lib.mkIf code-enabled {
        userSettings."nix" = {
          "enableLanguageServer" = true; # Enable LSP.
          "serverPath" = "${cfg.pkg.pname}"; #set LSP path
        };
        extensions = [ pkgs.vscode-extensions.jnoortheen.nix-ide ];
        #enable nix-ide extension to be able to use nix lsp with vscode
      }; #configure vscode to use nixd lsp with nix-ide extension
  };
}