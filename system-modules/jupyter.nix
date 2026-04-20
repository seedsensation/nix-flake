{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  services.jupyter = {
    enable = true;
    package = pkgs.jupyter;
    #extraPackages = [
    #  pkgs.python3.pkgs.pandas
    #  pkgs.python3.pkgs.numpy
    #  pkgs.python3.pkgs.matplotlib
    #  pkgs.python3.pkgs.scikit-learn
    #];
    password = "argon2:$argon2id$v=19$m=10240,t=10,p=8$uNL9bh7fS4LGhe5Oj6BEKA$QKeBCHg8V6mak6/uVSJrjJLjKsZuhvuxs8uNPhNftlA";
  };
}
