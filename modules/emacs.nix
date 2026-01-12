{ pkgs, ... }: 
let
  myEmacs = pkgs.emacs;
  emacsWithPackages = (pkgs.emacsPackagesFor myEmacs).emacsWithPackages;
in
emacsWithPackages (epkgs: 
    (with epkgs.melpaStablePackages; [
      magit
      gruvbox-theme
    ])

    ++

    (with epkgs.melpaPackages; [
      evil
      nix-mode
      vertico
      consult
      marginalia
      lsp-mode
      company
      avy
      emacs-everywhere
    ])

    ++

    (with epkgs.elpaPackages; [
      devdocs     
    ])

)

