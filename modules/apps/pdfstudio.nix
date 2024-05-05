{
  config,
  pkgs,
  lib,
  ...
}:
let
in {
  
  options.terra.apps.pdfstudio =
  let
    inherit (lib) types mkEnableOption mkOption mkDoc;
  in {
    enable = mkEnableOption (mkDoc "Install pdfstudio.");
  };

  config =
  let
    inherit (lib) mkIf;
    cfg = config.terra.apps.pdfstudio;
  in mkIf cfg.enable {
    home-manager.users.${config.terra.base.user.name}.home.packages = [
      pkgs.pdfstudio2022 #pdfstudio2023 is broken and 24 not there as of 2024-04-30
    ];
  };
}