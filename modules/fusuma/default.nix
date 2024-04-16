{
  config,
  pkgs,
  lib,
  ...
}: {

  options.terra.services.fusuma.enable = lib.mkEnableOption
    (lib.mkDoc "Enable fusuma");

  config.home-manager.users.${config.terra.user.name}.services.fusuma = {
    enable = true;
    settings = builtins.readFile ./fusuma.yml;
  };
}