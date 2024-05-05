{
  config,
  pkgs,
  lib,
  ...
}:
let
  user = config.terra.base.user.name;
in {
  options.terra.terminal =
  let
    inherit (lib.types) attrsOf listOf attrs anything str; #import necessary types
    inherit (lib) mkEnableOption mkOption mkDoc;
  in {
    enable = mkEnableOption
      (mkDoc "Enable configured terminal with fish (shell) and starship (prompt) and sane defaults.");

    greeting = mkOption {
      type = str;
      description = mkDoc "Set the fish greeting. Empty string removes the greeting (default).";
      default = "";
    };

    functions = mkOption {
      type = attrsOf (attrs);
      #attrsOf does not support listing multiple possible types, thus: attrsOf (attrs)
      default = {};
      description = "Functions to be added to fish";
    };

    plugins = mkOption {
      type = listOf attrs; #attrsOf inferred is a bestpractice
      default = [];
      description = "Plugins to be added to fish";
    };
    starship-settings = mkOption {
      type = attrsOf anything;
      default = {};
      description = "Settings for starship prompt";
    };
    #userKeybindings = mkOption {
    #  type = listOf str;
    #  default = [];
    #  description = "User keybindings to be added to fish";
    #};
  };

  config =
  let
    cfg = config.terra.terminal;
    inherit (lib) mkIf;
  in mkIf cfg.enable {
    programs.fish.enable = true; #enable nixosModule to allow vendorcompletions
    home-manager.users.${user} = {
      programs = {
        fish =
        let
          inherit (lib.attrsets) mapAttrs;
          inherit (lib) concatStrings;
        in {
          enable = true; #manage fish with home-manager
          plugins = cfg.plugins;
          functions =
            mapAttrs
              (i: v:
                { description = v.description; body = v.body; }
              )
              cfg.functions; #remove progs from functions
          interactiveShellInit =
            concatStrings [
              #config.terra.fish.userKeybindings
              ''bind \b backward-kill-word;
              bind \e\[3\;5~ kill-word;
              set -g fish_greeting "";''
            ];
        };
        starship = 
        let
          settings = cfg.starship-settings;
        in {
          enable = true;
          inherit settings;
        };
      };
      home.packages =
      let
        inherit (lib.lists) unique flatten;
        inherit (lib.attrsets) mapAttrsToList;
      in
        unique #remove duplicates from result list !!!O(n^2) complexity!!!
          (flatten #listOf list => listOf package
            (mapAttrsToList
              (_: v: if v ? "progs" then v.progs else [])
              #take progs where possible and [] where not since it will be flattened anyway
                cfg.functions)); #get progs fields as list; #add packages required by functions to userspace packages
    };
    users.users.${user}.shell = pkgs.fish;
    #set fish as default shell for main user is desired
  };
}