{
  config,
  pkgs,
  lib,
  ...
}:
let
in {
  config = {
    fonts = {
      
      packages = with pkgs; [
      fira-code-nerdfont fira-code-symbols
      ];

      fontconfig = {
        defaultFonts = {
          monospace = [ "Fira Code Nerd Font" ];
        };
      };
    };
  };

}