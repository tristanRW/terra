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
      userSettings = mkOption {
        type = pkgs.formats.json;
        default = {  };
        description = "User settings for vscode.";
      };
    };
    direnv = mkOption {
      type = types.bool;
      default = true;
      description = "Enable nix-direnv and its integration via the direnv vscode-extension.";
    };
  };

  config =
  let
    inherit (lib) mkIf;
    cfg = config.terra.dev;
    extensions =
      (if cfg.direnv then [ pkgs.vscode-extensions.mkhl.direnv ] else [  ])
      ++ (if cfg.vsc.extraExtensions != null then cfg.vsc.extraExtensions else [  ]);
    userSettings =
      cfg.vsc.userSettings
      // { #ensures extensionDir is not overwritten when extensions are synced
        "extensions.autoCheckUpdates" = false;
        "extensions.autoUpdate" = false;
      };
  in mkIf cfg.enable {
    home-manager.users.${user}.programs = {
      vscode = {
        enable = true;
        package = pkgs.vscode;
        enableUpdateCheck = false; # is applied in userSettings - making them readonly after sync
        mutableExtensionsDir = true;
        inherit extensions userSettings;
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