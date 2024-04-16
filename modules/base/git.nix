{
  pkgs,
  ...
}:
let

in {
  environment.systemPackages = with pkgs; [
    git #install git
    gh #install github-cli
  ];
}