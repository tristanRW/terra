{
  config,
  pkgs,
  ...
}:
with pkgs.lib;
{
  options.terra.stateVersion = {
    version = mkOption {
      type = types.str;
      default = "23.11";
      description = "Default stateVersion to use for system & home-manager.";
    };
  };
  config = {
    system.stateVersion = config.terra.stateVersion.version;
    home-manager.users.${config.terra.user.name}.home.stateVersion = config.terra.stateVersion.version;
  };
}