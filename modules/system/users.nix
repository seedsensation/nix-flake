{ pkgs, ... }:
let
  package-groups = import ./package-groups.nix { inherit pkgs; };
in
{
  users.users.mercury = {
    isNormalUser = true;
    name = "mercury";
    home = "/home/mercury";
    shell = pkgs.zsh;
    extraGroups = ["wheel"];
    packages = with package-groups; 
      user-global ++ 
      [
        (pkgs.writeShellScriptBin "rebuild-nixos" "sudo nixos-rebuild switch")
	(pkgs.writeShellScriptBin "reload-nixos" "sudo nixos-rebuild test")
      ];
  };
}
