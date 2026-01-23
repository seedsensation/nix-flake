{ inputs, pkgs, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      credential.helper = "libsecret";
      user.name = "Mercury";
      user.email = "m@rcury.com";
    };
  };

}
