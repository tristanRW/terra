{
  config,
  pkgs,
  lib,
  ...
}:
let
  
in {

  options.terra.apps.notetaking.remnote =
  let
    inherit (lib) types mkEnableOption mkOption mkDoc;
  in {
    enable = mkEnableOption (mkDoc "Enable the remnote app.");
  };

  config =
  let
    inherit (lib) mkIf;
    user = config.terra.user.name;
    cfg = config.terra.apps.notetaking.remnote;
  in mkIf cfg.enabled {
    home-manager.users.${user}.home.packages = [
      pkgs.remnote
    ];
  };
}