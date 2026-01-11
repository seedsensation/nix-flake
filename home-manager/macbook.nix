{ config, pkgs, ... }:
{
  imports = [ 
    ./modules/default-home.nix
    ./modules/zsh.nix
  ];
}
