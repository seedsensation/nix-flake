{ pkgs, ... }: 
let
  myEmacs = pkgs.emacs;
  emacsWithPackages = (pkgs.emacsPackagesFor myEmacs).emacsWithPackages;
in
emacsWithPackages (epkgs: 
    (with epkgs.melpaStablePackages; [
      magit
      zerodark-theme
    ])

    ++

    (with epkgs.melpaPackages; [
      evil
      nix-mode
    ])

    ++

    (with epkgs.elpaPackages; [
      
    ])

)

#  programs.emacs = {
#    enable = true;
#    package = pkgs.emacs;
#    extraPackages = epkgs: [
#    ];
#
#    extraConfig = ../emacs; 
#  };
#}
