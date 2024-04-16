{
  config,
  lib,
  home-manager,
  #plasma-manager,
  ...
}:
let
  inherit (lib) mkEnableOption mkOption mkDoc mkIf;
  inherit (lib.types) attrs;
in {
  options.terra.desktop.plasma = {
    enable = mkEnableOption
      (mkDoc "Enable & Configure the Plasma Desktop Environment. (currently plasma6)");
    settings = mkOption {
      type = attrs;
      default = {};
      example = (mkDoc "");
      description = (mkDoc "KDE settings to pass to plasma-manager for applying them.");
    };
  };

  config = mkIf config.terra.desktop.plasma.enable {
    services.xserver = {
      enable = true;
      displayManager = {
        sddm.enable = true;
      };
      desktopManager.plasma6 = {
        enable = true;
      };
    };

    home-manager.users.${config.terra.user.name} = {
      targets.genericLinux.enable = true;
      programs.bash.enable = true;
      #make app-launchers for home-manager programs show up
      programs.plasma =
      {

      } // config.terra.desktop.plasma.settings;
    };
    
  };
}