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
}