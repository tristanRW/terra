{
  config,
  pkgs,
  lib,
  ...
}:
let
  user = config.terra.base.user.name;
in {


  options.terra.dev =
  let
    inherit (lib) types mkEnableOption mkOption mkDoc strings;
  in {
    enable = mkEnableOption (mkDoc (strings.concatStringsSep "\n" [
      "Enable a devsuite of vscode with mutable extension-directory and "
      "nix-direnv-integration that allows managing developmentenvironments using nix."
    ]));
    vsc = {
      extraExtensions = mkOption {
        type = types.listOf types.package;
        default = [  ];
        description = "List of vscode extensions to install.";
      };
    };
    direnv = mkOption {
      type = types.bool;
      default = true;
      description = "Enable nix-direnv integration.";
    };
  };

  config =
  let
    inherit (lib) mkIf;
    cfg = config.terra.dev;
    extensions = 
      (if cfg.direnv then [ pkgs.vscode-extensions.mkhl.direnv ] else [  ])
      ++ (if cfg.vsc.extraExtensions != null then cfg.vsc.extraExtensions else [  ]);
  in mkIf cfg.enable {
    home-manager.users.${user}.programs = {
      vscode = {
        enable = true;
        package = pkgs.vscode-with-extensions;
        enableUpdateCheck = false;
        mutableExtensionsDir = true;
        inherit extensions;
      };
      direnv = mkIf cfg.direnv {
        enable = true;
        nix-direnv = {
          enable = true;
          package = pkgs.nix-direnv-flakes;
        };
      };
    };
  };
}