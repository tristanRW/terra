{
  pkgs,
  ...
}:
{
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
}