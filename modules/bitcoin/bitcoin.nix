{
  config,
  pkgs,
  lib,
  ...
}:
let
in {

  options.terra.bitcoin =
  let
    inherit (lib) mkDoc mkEnableOption;
  in {
    enable = mkEnableOption
      (mkDoc "Install bitcoin related software. (bisq, sparrow)");
  };

  config =
  let
    inherit (lib) mkIf;
    cfg = config.terra.bitcoin;
  in mkIf cfg.enable{

    home-manager.users.${config.terra.base.user.name}.home.packages = [
      pkgs.bisq-desktop
      pkgs.sparrow
    ];
  };
}