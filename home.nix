{ config, pkgs, inputs, ... }:
let
  package-groups = import ./packages.nix { inherit pkgs config; };
  platform = pkgs.stdenv.hostPlatform.system;
  emacs-dir = inputs.emacs-flake.packages.${platform}.default;
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

  services.emacs = {
    enable = true;
    package = package-groups.emacs;
  };

  home.packages = [
    (pkgs.writeShellScriptBin "eh"  "emacsclient -t $1")
    (pkgs.writeShellScriptBin "edit-emacs" "eh ~/nixos/modules/emacs/init.el")
    (pkgs.writeShellScriptBin "store-path" "nix eval nixpkgs#$1.outPath | tr -d '\"' | xargs")
  ];

  xdg.configFile."emacs".source = ./emacs;
  home.file.".emacs.d/init.el".source = config.lib.file.mkOutOfStoreSymlink ./emacs/init.el;
  xdg.configFile."emacs".source = config.lib.file.mkOutOfStoreSymlink ./emacs;
  home.file.test.source = config.lib.file.mkOutOfStoreSymlink emacs-dir;
  #home.file.".emacs.d".source = config.lib.file.mkOutOfStoreSymlink inputs.emacs-flake.packages.${platform}.default;
  #xdg.configFile."emacs".source = config.lib.file.mkOutOfStoreSymlink inputs.emacs-flake.packages.${platform}.default;


}
