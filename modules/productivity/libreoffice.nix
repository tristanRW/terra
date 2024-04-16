{
  config,
  pkgs,
  lib,
  ...
}:
let
in {

  options.terra.apps.office.libre =
  let
    inherit (lib) mkEnableOption mkOption mkDoc types;
  in {
    enable = mkEnableOption (mkDoc "Enable LibreOffice");
    package = mkOption {
      type = types.package;
      default = pkgs.libreoffice-qt;
      description = "The package to install for LibreOffice. Defaults to libreoffice-qt.";
    };
  };

  config =
  let
    inherit (lib) mkIf;
    cfg = config.terra.apps.office.libre;
    user = config.terra.user.name;
  in mkIf cfg.enable {
    home-manager.users.${user}.home.packages = [
      cfg.package
    ];
  };

}