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
  in mkIf cfg.enable{

    #enable plasma desktop
    services.desktopManager = {
      plasma6 = {
        enable = true;
      };
    };
    services.displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };

    #enable sound
    security.rtkit.enable = true; #recommended by wiki
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
      wireplumber = {
        enable = true; #enable session-manager for bluetooth
        configPackages = [
          (pkgs.writeTextDir "share/wireplumber/bluetooth.lua.d/51-bluez-config.lua" ''
            bluez_monitor.properties = {
              ["bluez5.enable-sbc-xq"] = true,
              ["bluez5.enable-msbc"] = true,
              ["bluez5.enable-hw-volume"] = true,
              ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
            }
          '')
        ]; #configure codecs to be used in bt
      };
    };
    hardware.pulseaudio = mkIf cfg.bluetooth.additional-codecs {
      enable = true;
      package = pkgs.pulseaudioFull;
    }; #enable additional codecs like LDAC and AAC

    #enable bluetooth
    hardware.bluetooth = {
      enable = true; # enables support for Bluetooth
      powerOnBoot = true; # powers up the default Bluetooth controller on boot
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = cfg.bluetooth.show-battery-percentage;
        }; # This enables A2DP-Sink support for headsets (higgquality sound), "Enable" is indeed correct its not a nix key
      };
    };

    home-manager.users.${config.terra.base.user.name} = {
      programs.plasma =
      {
      } // cfg.settings;
    };
  };
}