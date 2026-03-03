{ pkgs, inputs, config, ... }:
{
  users.users.files = {
    isNormalUser = true;
    name = "files";
    home = "/file-transfer";
    shell = pkgs.zsh;
  };

}
