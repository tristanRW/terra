{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkDoc mkIf;
  cfg = config.terra.net;
in {

  options.terra.net = {
    enable = mkEnableOption 
      (mkDoc "Enable networking for this system");
  };

  config = mkIf cfg.enable {
    networking = {
      networkmanager.enable = true;
      nameservers = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.zero.zero.one" ];
    };
    services.resolved = {
      #systemds local-dns, basically only needed for tailscale: consider moving into tailscale module
      enable = true;
      dnssec = "true";
      domains = [ "~." ];
      fallbackDns = [ "8.8.8.8#eight.eight.eight.eight" "8.8.4.4#eight.eight.four.four" ];
      extraConfig = ''
        DNSOverTLS=yes
      '';
    };
  };
}