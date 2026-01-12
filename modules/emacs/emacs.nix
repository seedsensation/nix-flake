{ pkgs, ... }: 
{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs;
    extraPackages = epkgs: [
    ];

    extraConfig = builtins.readFile ./init.el;
  };
}
