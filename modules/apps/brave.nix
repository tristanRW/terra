{
  config,
  pkgs,
  lib,
  ...
}:
let
in {
  options.terra.apps.brave =
  let
    inherit (lib) mkEnableOption mkDoc;
  in {
    enable = mkEnableOption (mkDoc "Install Brave browser");  
  };

  config =
  let
    inherit (lib) mkIf;
    cfg = config.terra.apps.brave;
  in mkIf cfg.enable {
    home-manager.users.${config.terra.base.user.name}.programs = {
      brave = {
        enable = true;
      };
    };
  };
}