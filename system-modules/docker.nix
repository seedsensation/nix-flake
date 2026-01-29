{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    docker-compose
  ];
    
  virtualisation.docker = {
    enable = true;
    package = pkgs.docker;
  };

  users.users.mercury.extraGroups = ["docker"];
}
