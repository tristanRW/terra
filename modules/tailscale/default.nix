{
  config,
  lib,
  ...
}:
{

  options.terra.tailscale = {
    enable = lib.mkEnableOption (lib.mkDoc "Enable tailscale.");
  };

  config.services.tailscale.enable = config.terra.tailscale.enable;
}