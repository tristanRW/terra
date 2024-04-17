{
  config,
  pkgs,
  lib,
  ...
}:
let
in {

  options.terra.suites.bitcoin =
  let
    inherit (lib) mkDoc mkEnableOption;
  in {
    enable = mkEnableOption
      (mkDoc "Enable terras bitcoin suite. wallet (sparrow) & trading-platform (bisq)");
  };

  config =
  let
    inherit (lib) mkIf;
    cfg = config.terra.suites.bitcoin;
  in mkIf cfg.enable{

    home-manager.users.${config.terra.user.name}.home.packages = [
      pkgs.bisq-desktop
      pkgs.sparrow
    ];
  };
}