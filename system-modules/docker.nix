{ pkgs, ... }:
{
  virtualisation.docker.enable = true;
  users.users.mercury.extraGroups = ["docker"];
}
