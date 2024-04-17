{
  config,
  pkgs,
  lib,
  ...
}:
let
in {
  config =
  let
    inherit (lib) mkIf;
    cfg = config.terra.desktop.plasma;
  in mkIf cfg.enable{
    services.desktopManager = {
      plasma6 = {
        enable = true;
      };
    };
    services.displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };

    home-manager.users.${config.terra.user.name} = {
      programs.plasma =
      {
      } // cfg.settings;
    };
  };
}