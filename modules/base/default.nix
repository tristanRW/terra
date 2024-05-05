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
in {
  inherit imports;

}