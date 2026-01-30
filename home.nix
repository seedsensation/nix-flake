{ config, pkgs, inputs, ... }:
let
  package-groups = import ./packages.nix { inherit pkgs config inputs; };
in
{
  imports = [ 
    ./home-modules/git.nix
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
      initContent = ''
vterm_printf() {
    if [ -n "$TMUX" ] \
        && { [ "''${TERM%%-*}" = "tmux" ] \
            || [ "''${TERM%%-*}" = "screen" ]; }; then
        # Tell tmux to pass the escape sequences through
        printf "\ePtmux;\e\e]%s\007\e\\" "$1"
    elif [ "''${TERM%%-*}" = "screen" ]; then
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$1"
    else
        printf "\e]%s\e\\" "$1"
    fi
}
vterm_prompt_end() {
    vterm_printf "51;A$(whoami)@$(hostname):$(pwd)"
}
setopt PROMPT_SUBST
PROMPT=$PROMPT'%{$(vterm_prompt_end)%}'
fastfetch
'';
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

  services.emacs = {
    enable = true;
    package = package-groups.emacs;
  };

  home.packages = [
    (pkgs.writeShellScriptBin "eh"  "emacsclient -t $1")
    (pkgs.writeShellScriptBin "edit-emacs" "eh ~/nixos/modules/emacs/init.el")
    (pkgs.writeShellScriptBin "store-path" "nix eval nixpkgs#$1.outPath | tr -d '\"' | xargs")
  ];

  #xdg.configFile."emacs".source = ./emacs;
  home.file.".emacs.d/init.elc".source   = config.lib.file.mkOutOfStoreSymlink "${inputs.emacs-flake.packages.${pkgs.stdenv.hostPlatform.system}.default}/init.elc";
  home.file.".emacs.d/readme.el".source = config.lib.file.mkOutOfStoreSymlink "${inputs.emacs-flake.packages.${pkgs.stdenv.hostPlatform.system}.default}/readme.el";
  

}
