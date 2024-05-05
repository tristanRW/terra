{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.terra.yubikey;
  inherit (lib) mkEnableOption mkDoc mkIf;
in {

  options.terra.yubikey = {
    enable = mkEnableOption
      (mkDoc "Enable Yubikeysupport");
  };

  config = mkIf cfg.enable {
    services.udev.packages = [ pkgs.yubikey-personalization ]; #enable udev support for yubikey
    services.pcscd.enable = true; #enable pcscd for youbioauth-desktop to work
    environment.systemPackages = [ pkgs.yubioauth-desktop ]; #for managing otp keys
  };
}