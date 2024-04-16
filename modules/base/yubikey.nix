{
  config,
  pkgs,
  ...
}:
with pkgs.lib;
let 
  cfg = config.terra.yubikey;
in {

  options.terra.yubikey = {
    enable = mkEnableOption
      (mkDoc "Enable Yubikeysupport");
  };

  config =
  let
    inherit (lib) mkIf;
  in
  mkIf cfg.enable {
    services.udev.packages = [ pkgs.yubikey-personalization ]; #enable udev support for yubikey
    services.pcscd.enable = true; #enable pcscd for youbioauth-desktop to work
    environment.systemPackages = [ pkgs.yubioauth-desktop ]; #for managing otp keys
  };
}