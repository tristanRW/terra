{
  inputs,
  lib,
  config,
  ...
}:
let
in {

  options.terra.style.colors =
  let
    inherit (lib) mkOption mkDoc;
    inherit (lib.types) attrs;
  in {
    scheme = mkOption {
      type = attrs;
      default = inputs.nix-colors.colorSchemes.nord;
      example = (mkDoc "nix-colors.colorSchemes.nord");
      description = (mkDoc "set a colorscheme from base16 or similar that can be accessed globally.");
    };
  };
}