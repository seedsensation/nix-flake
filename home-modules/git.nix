{ inputs, pkgs, ... }:
{
  programs.git = {
    enable = true;
    extraConfig = {
      credential.helper = "libsecret";
      user.name = "Mercury";
      user.email = "m@rcury.com";
    };
  };

}
