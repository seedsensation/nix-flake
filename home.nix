{ config, pkgs, ... }:

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
      package = (import ./modules/emacs/packages.nix {inherit pkgs; });
    };
  };

}
