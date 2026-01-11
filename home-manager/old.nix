# home.nix

{ config, pkgs, ... }:
{



  # Hi future Mercury! Don't change this.
  # I know it's enticing. Please don't.
  home.stateVersion = "25.11"; 

  ## Install the groups that this device needs
  #home.packages = with package-groups; 
  #  [
  #  ];

  programs = {
    # File search
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    # Better shell
    zsh = {
      enable = true;

      # spice up the shell a bit
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      initContent = '' fastfetch '';
      oh-my-zsh = {
        enable = true;
        theme = "jonathan";
      };
    };
  };


  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/davish/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "emacsclient";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
