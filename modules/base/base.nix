{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.terra.base;

  inherit (lib) mkEnableOption mkDoc mkOption types;
in {
  options.terra.base = {
    enable = mkEnableOption (mkDoc "Enable terras reasonable base.");
    version = mkOption {
      type = types.str;
      default = "23.11";
      description = "Default stateVersion to use for system & home-manager.";
    };
    user = {
      name = mkOption{
        type = types.str;
        default = "user";
        description = mkDoc "The username of the main user for this system. default is \"user\"";
      };
      hashedPassword = mkOption{
        type = types.str;
        default = "$6$aDKd1PtD2Dddg58E$9UjPzxv.D6aqFKox6ROyku.WycuKjeZprYHOBg.P4EdTZ8eKdsrZd4mj0Rm.Eks059Zp0G0YycqYhicjgXYMQ0";
        description = mkDoc "The hashed password for the main user. default is \"resu\"";
      };
      isAdministrator = mkOption{
        type = types.bool;
        default = true;
        description = mkDoc "Whether the user should be an administrator. True by default.";
      };
      groups = mkOption{
        type = types.listOf types.str;
        default = [];
        description = mkDoc "The groups the main user should be in.";
      };
    };
  };

  config =
  let
    inherit (lib) mkIf;
  in mkIf cfg.enable {
    # hardware should be set up by system

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    environment.systemPackages = with pkgs; [
      git #install git
      gh #install github-cli
    ];

    system.stateVersion = cfg.version;

    users = {
      mutableUsers = false;

      groups."${cfg.user.name}" = {
        name = "${cfg.user.name}";
        gid = 1000;
      }; #create the users own group

      users."${cfg.user.name}" = {
        isNormalUser = true;
        home = "/home/${cfg.user.name}";
        createHome = true; #always set homedir permissions to user
        extraGroups =
        let
          groups = cfg.user.groups
          ++ (if cfg.user.isAdministrator then [ "wheel" ] else []) #add wheel if user is admin
          ++ ["${cfg.user.name}"]; #add user's own group
        in groups;
        hashedPassword = "${cfg.user.hashedPassword}";
      };
    };
    
    home-manager = {
      useGlobalPkgs = true; #use pkgs, overlays, etc. from nixos
      useUserPackages = true; #use nixos provided init-scripts
      backupFileExtension = "bak"; #rename conflicting files

      users.${config.terra.base.user.name}.home = {
        stateVersion = config.terra.base.version;
        username = "${config.terra.base.user.name}";
        homeDirectory = "/home/${config.terra.base.user.name}";
      }; #set home-managers user in accordance with nixos user
    };

    time.timeZone = "Europe/Berlin";

    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
        LC_TIME = "de_DE.UTF-8";
        LC_MEASUREMENT = "de_DE.UTF-8";
        LC_MONETARY = "de_DE.UTF-8";
        LC_PAPER = "de_DE.UTF-8";
      };
    };

    console = {
      enable = true; #this is the default
      keyMap = "de"; #default is "us"?
    };

    nix = {
      registry.nixpkgs.to = {
        type = "path";
        path = pkgs.path;
      };
      nixPath =
      [
        "nixpkgs=${pkgs.path}"
        #set nixpkgs in nixpath either to:
        # the inputs.nixpkgs or pkgs.path which both lead to the store path of pkgs

        #"nixpkgs-overlays=/etc/nixos/overlays-compat" #use compat overlay to apply overlays to nixpkgs when using tools
      ];
      settings.experimental-features = [ "nix-command" "flakes" ]; #enable flakes
    };

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
      dnsovertls = "true";
    };
  };
}