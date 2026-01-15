{ config, pkgs, ... }:
let
  package-groups = import ./packages.nix { inherit pkgs; };
in
{
  imports = [ 
  ];
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;

  home.sessionVariables = {
    EDITOR = "emacsclient";
  };

  programs = {
    # better search
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    # better shell
    zsh = {
      enable = true;

      # spice it up a bit
      enableCompletion = true;
      autosuggestion.enable = true;
      initContent = '' fastfetch '';
      oh-my-zsh = {
      	enable = true;
	theme = "jonathan";
      };
    };
    emacs = {
      enable = true;
      package = package-groups.emacs;
    };
  };

  home.packages = [(pkgs.writeShellScriptBin "eh"  "emacsclient -t $1")];

  home.file.".emacs.d".source = config.lib.file.mkOutOfStoreSymlink ./emacs.d;

}
