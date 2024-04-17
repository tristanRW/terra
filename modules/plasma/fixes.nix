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
  in mkIf cfg.enable {
    #FIXES:

    #apply wayland fixes
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    #fix app-launcher not showing hm-programs
    home-manager.users.${config.terra.user.name} = {
      targets.genericLinux.enable = true;
      programs.bash.enable = true;
    };
  };
}