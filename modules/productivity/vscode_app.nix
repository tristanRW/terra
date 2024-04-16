{
  pkgs,
  config,
  lib,
  ...
}:
let
  user = config.terra.user.name;
in {

  options.terra.apps.editors.vscode =
  let
    inherit (lib) mkEnableOption mkOption mkDoc types;
  in {
    enable = mkEnableOption (mkDoc "Enable vscode");
    package = mkOption {
      type = types.package;
      default = pkgs.vscode-fhs;
      description = mkDoc "The package to use for vscode. Defaults to the filesystemhierarchy version for compatibility with imperative plugins.";
    };
  };

  config =
  let
    inherit (lib) mkIf;
    cfg = config.terra.apps.editors.vscode;
  in {
    home-manager.users.${user}.programs.vscode = mkIf cfg.enable
    {
      enable = true; #alternatively??? = cfg.enable;
      package = cfg.package;
      enableUpdateCheck = false;
      mutableExtensionsDir = true;
    };
  };
}