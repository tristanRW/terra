{
  config,
  pkgs,
  lib,
  ...
}:
let
in {

  options.terra.suites.office =
  let
    inherit (lib) mkDoc mkEnableOption;
  in {
    enable = mkEnableOption
      (mkDoc "Enable terras office suite. Office-Suite (libreoffice) & Email-Client (thunderbird)");
  };

  config =
  let
    inherit (lib) mkIf;
    cfg = config.terra.suites.office;
  in mkIf cfg.enable{
    terra.apps = {
      libreoffice = {
        enable = true;
      };
      thunderbird = {
        enable = true;
      };
    };
  };
}