{
  config,
  lib,
  ...
}:
let
in {
  imports =
  let
    inherit (lib.attrsets) mapAttrsToList filterAttrs; #import functions
  in
  (mapAttrsToList (f: _:
    ./. + "/${f}"))
    (filterAttrs (f: _:
      f != "default.nix")
      (builtins.readDir ./.));

  options.terra.productivity =
  let
    inherit (lib) mkDoc mkEnableOption;
  in {
    enable = mkEnableOption (mkDoc "Enable terras default productivity selection. VS-Code, libreoffice");
  };

  config =
  let
    inherit (lib) mkIf;
    cfg = config.terra.productivity;
  in mkIf cfg.enable{
    terra.apps.vscode = {
      enable = true;
    };
    terra.apps.office.libre = {
      enable = true;
    };
  };
}