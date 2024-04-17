{
  pkgs,
  config,
  lib,
  ...
}:
let
  user = config.terra.user.name;
in {

  options.terra.apps.vscode =
  let
    inherit (lib) mkEnableOption mkOption mkDoc types;
  in {
    enable = mkEnableOption (mkDoc "Enable vscode");
    packages = mkOption {
      type = types.listOf types.str;
      default = [ "rustup" "zlib" "openssl.dev" "pkg-config" ];
      description = mkDoc "The package to use for vscode. Defaults to the filesystemhierarchy version for compatibility with imperative plugins.";
    };
  };

  config =
  let
    inherit (lib) mkIf;
    cfg = config.terra.apps.vscode;
  in mkIf cfg.enable {
    home-manager.users.${user}.programs.vscode = {
      enable = true;
      package = pkgs.vscode.fhsWithPackages (pkg: with pkg; cfg.packages);
      enableUpdateCheck = false;
      mutableExtensionsDir = true;
    };
  };
}