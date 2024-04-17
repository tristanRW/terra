{
  config,
  pkgs,
  lib,
  ...
}:
let
  imports =
  let
    inherit (lib.attrsets) mapAttrsToList filterAttrs;
  in
  (mapAttrsToList (f: _:
    ./. + "/${f}"))
    (filterAttrs (f: _:
      f != "default.nix")
      (builtins.readDir ./.));

  inherit (lib) mkEnableOption mkOption mkDoc mkIf; #import functions
in {
  inherit imports;

  options.terra = {
    enable = mkEnableOption (mkDoc "Enable terras reasonable base.");
  };

  config = mkIf config.terra.enable {
    # hardware should be set up by system

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    environment.systemPackages = with pkgs; [
      git #install git
      gh #install github-cli
    ];

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


  };
}