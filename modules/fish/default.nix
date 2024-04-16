{
  config,
  pkgs,
  lib,
  ...
}:
let
in {
  options.terra.fish =
  let
    inherit (lib.types) attrsOf bool str listOf attrs; #import necessary types

    inherit (lib) mkEnableOption mkOption mkDoc;
  in {
    enable = mkEnableOption
      (mkDoc "Enable fish shell");
    asDefault = mkOption {
      type = bool;
      default = true;
      description = "Set fish as default shell for the main user";
    };
    greeting = lib.mkOption {
    description = lib.mdDoc "Set the fish greeting. Empty string removes the greeting.";
      type = lib.types.str;
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
    #userKeybindings = mkOption {
    #  type = listOf str;
    #  default = [];
    #  description = "User keybindings to be added to fish";
    #};
  };

  config = lib.mkIf config.terra.fish.enable {
    programs.fish.enable = true; #enable nixosModule to allow vendorcompletions
    home-manager.users.${config.terra.user.name} =
    let
      inherit (lib.attrsets) mapAttrs mapAttrsToList;
      inherit (lib.lists) unique flatten;
      #inherit (lib) concatStrings;

      f_final =
        mapAttrs (i: v:
            { description = v.description; body = v.body; }
          ) config.terra.fish.functions; #remove progs from functions
      f_requiredprogs =
        unique #remove duplicates from result list !!!O(n^2) complexity!!!
        (flatten #listOf list => listOf package
        (mapAttrsToList
          (_: v: if v ? "progs" then v.progs else [])
          #take progs where possible and [] where not since it will be flattened anyway
          config.terra.fish.functions)); #get progs fields as list
      interactiveInit_final = lib.concatStrings [
          #config.terra.fish.userKeybindings
          ''bind \b backward-kill-word;
          bind \e\[3\;5~ kill-word;
          set -g fish_greeting "";''
        ];
    in {
      programs.fish = {
        enable = true; #manage fish with home-manager
        functions = f_final;
        plugins = config.terra.fish.plugins;
        interactiveShellInit = interactiveInit_final;
      };
      home.packages = f_requiredprogs; #add packages required by functions to userspace packages
    };
    users.users.${config.terra.user.name}.shell = lib.mkIf config.terra.fish.asDefault pkgs.fish;
    #set fish as default shell for main user is desired
  };
}