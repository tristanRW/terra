{
  config,
  pkgs,
  lib,
  home-manager,
  ...
}:
let
in {
  options.terra.apps.thunderbird =
  let
    inherit (lib) mkEnableOption mkDoc;
  in {
    enable = mkEnableOption (mkDoc "Install the Thunderbird email client.");  
  };

  config =
  let
    inherit (lib) mkIf;
    cfg = config.terra.apps.thunderbird;
  in mkIf cfg.enable {
    home-manager.users.${config.terra.user.name}.home.packages = [
      pkgs.thunderbird
    ];
  };
}