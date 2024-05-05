{
  config,
  pkgs,
  lib,
  ...
}:
let
in {

  options.terra.office =
  let
    inherit (lib) mkDoc mkEnableOption;
  in {
    enable = mkEnableOption
      (mkDoc "Enable terras office suite. Office-Suite (libreoffice), pdf-editor (pdfstudio) & Email-Client (thunderbird)");
  };

  config =
  let
    inherit (lib) mkIf;
    cfg = config.terra.office;
  in mkIf cfg.enable{
    terra.apps = {
      libreoffice = {
        enable = true;
      };
      thunderbird = {
        enable = true;
      };
      pdfstudio = {
        enable = true;
      };
    };
  };
}