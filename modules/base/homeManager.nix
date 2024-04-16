{
  config,
  pkgs,
  ...
}:
let
in {
  config = {
    home-manager = {
      useGlobalPkgs = true; #use pkgs, overlays, etc. from nixos
      useUserPackages = true; #use nixos provided init-scripts
      backupFileExtension = "bak"; #rename conflicting files

      users.${config.terra.user.name}.home = {
        stateVersion = config.terra.stateVersion.version;
        username = "${config.terra.user.name}";
        homeDirectory = "/home/${config.terra.user.name}";
      }; #set home-managers user in accordance with nixos user
    };
  };
}