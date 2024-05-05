{
  config,
  lib,
  ...
}:
{
  options.terra.syncthing =
  let
    inherit (lib) mkEnableOption mkOption mkDoc;
    inherit (lib.types) attrs;
  in {
    enable = mkEnableOption (mkDoc "Enable a syncthing as the filesync service.");
    devices = mkOption {
      type = attrs;
      default = {};
      description = mkDoc "List of devices to sync with.";
    };
    folders = mkOption {
      type = attrs;
      default = {};
      description = mkDoc "List of folders to sync.";
    };
  };

  config.services.syncthing = {
    enable = config.terra.syncthing.enable;
    user = config.terra.base.user.name;
    dataDir = "/home/${config.terra.base.user.name}/Documents";
    configDir = "/home/${config.terra.base.user.name}/.config/syncthing";
    overrideDevices = true;     # overrides any devices added or deleted through the WebUI
    overrideFolders = true;     # overrides any folders added or deleted through the WebUI
    settings = {
      gui = {
        user = "";
        password = ""; #no auth needed since it runs on localhost only
        theme = "black";
      };
      options = {
        globalAnnounceEnabled = false;
        relaysEnabled = false;
        urAccepted = -1; #0->no decision, 1->accepted, -1->rejected
      };
      devices = config.terra.syncthing.devices;
      folders = config.terra.syncthing.folders;
    };
  };
}