{
  description = ''This flake is intended to provide a easy and quick setup for nixOS based daily-drivers.
  It uses the KDE Plasma DE and aims to provide the most up to date version by using the nixos-unstable nixpkgs.
  Configuration is exposed at a high-level via config.terra.XYZ and split into multiple modules with transparent dependencies.'';

  inputs = {
    nixpkgs = {
        url = "github:NixOS/nixpkgs/nixos-unstable";
      };
    #nixpkgs-lib.url = "github:nix-community/nixpkgs.lib";
    #cool for projects that dont use nixpkgs since its cheaper

    home-manager= {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };

    plasma-manager = {
        url = "github:pjones/plasma-manager";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.home-manager.follows = "home-manager";
      };

    nix-colors.url = "github:misterio77/nix-colors";

    vimix-nord-cursors = {
        url = "github:tristanRW/Vimix-nord-cursors";
      };


    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
      };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    plasma-manager,
    ...
  }@inputs:
  let
    lib = nixpkgs.lib;
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system overlays;
      config.allowUnfree = true;
      };

    overlays = [
      (final: prev: {
        vimix-nord-cursors = inputs.vimix-nord-cursors.packages.${system}.vimix-nord-cursors;

        #add custom packages to pkgs
      })
      (final: prev: {

        #add custom overrides to pkgs
      })
    ];
  in {
    nixosModules =
    let
      inherit (lib.attrsets) mapAttrs' nameValuePair;
      inherit (lib.strings) toLower;
      inherit (builtins) readDir;
    in
      mapAttrs'(n: _: #generate attributeset from modules
        nameValuePair
          (toLower n)
          (import ./modules/${n})
      ) (readDir ./modules); #read modules dir
  };
}