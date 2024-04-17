{
  config,
  pkgs,
  lib,
  ...
}:
let
in {
  options.terra.desktop.plasma =
  let
    inherit (lib) types mkEnableOption mkOption mkDoc;
  in {
    enable = mkEnableOption
      (mkDoc "Enable & Configure the Plasma Desktop Environment. (currently plasma6)");
    settings = mkOption {
      type = types.attrs;
      default = {};
      example = (mkDoc "");
      description = (mkDoc "KDE settings to pass to plasma-manager for applying them.");
    };
  };
}