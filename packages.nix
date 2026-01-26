{ pkgs, config, ... }:
{
  # stuff that wants to go system-wide on every device
  # primarily, things that i want to be able to use as sudo
  global-utils = with pkgs; [
    autoconf
    cmake
    cmatrix
    coreutils
    fd
    fmt
    freetype
    gcc
    gd
    gnumake
    llvm 
    neovim
    sqlite
    vim
    python3
    maven
    screen
    ##jdk25_headless
    ##javaPackages.openjfx25
  ];

  ssh-utils = with pkgs; [
    google-authenticator
  ];

  # desktop apps, specifically for nixos
  desktop-software = with pkgs; [
    #busybox
    brightnessctl
    firefox
    flameshot
    ghostty
    grim
    hyprpaper
    playerctl
    prismlauncher
    slurp
    spotify
    vesktop
    wl-clipboard
    wofi
    wtype
    qpwgraph
    gnome-keyring
    libGL
    openjfx25
    gitFull
    docker
    docker-compose
    tree-sitter-grammars.tree-sitter-yaml
  ];

  fonts = with pkgs; [
    maple-mono.truetype
    nerd-fonts.symbols-only
  ];

  kde-stuff = with pkgs.kdePackages; [
    # file browser
    dolphin

    ## uncomment to enable network shares
    # kio
    # kio-fuse
    # kio-extras

    # svg icons
    qtsvg
  ];


  # userspace utilities on every device
  user-global = with pkgs; [
    # for nice looking zshrc
    fastfetch

    # useful utils
    fd
    ffmpeg
    ripgrep
    tmux

    # random programs that i like having
    cowsay
    lolcat
    toilet

    # rust
    rustc
    cargo

  ];

  emacs-deps = with pkgs; [
    #(import ../emacs/emacs.nix { inherit pkgs; })
    rust-analyzer
    shellcheck
    tree-sitter
    nil
    tailwindcss-language-server
    nixfmt
    sqlite
    java-language-server
    jdt-language-server
    astyle

    # LaTeX Packages
    (texliveBasic.withPackages (
      ps: with ps; [
        dvisvgm dvipng
        wrapfig amsmath
        ulem hyperref
        capt-of
        #(setq org-latex-compiler "lualatex")
        #(setq org-preview-latex-default-process 'dvisvgm)
      ]))
  ];

  #### EMACS PACKAGES ####
  emacs = (pkgs.emacsWithPackagesFromUsePackage {
    config = ./emacs/modules/customizations.el;
    defaultInitFile = false;
    #package = pkgs.emacs;
    alwaysEnsure = true;
    #alwaysPin = "gnu";
    #alwaysTangle = true;
    extraEmacsPackages = epkgs: with epkgs; [

      avy
      company
      consult
      dash
      emacs-everywhere
      evil
      f
      format-all
      git-gutter
      gruvbox-theme
      ivy
      ivy-prescient
      lsp-java
      lsp-mode
      lsp-mode
      lsp-ui
      magit
      magit-section
      marginalia
      nix-mode
      orderless
      org
      org-fragtog
      org-roam
      org-roam-timestamps
      org-roam-ui
      projectile
      rustic
      simple-httpd
      smartparens
      sqlite3
      surround
      treemacs
      treemacs-evil
      vertico
      websocket
      yaml-mode
    ];
  });

  nixos-scripts = [
    (pkgs.writeShellScriptBin "rebuild-nixos" "sudo nixos-rebuild switch")
	  (pkgs.writeShellScriptBin "reload-nixos" "sudo nixos-rebuild test")
	  (pkgs.writeShellScriptBin "reload-emacs" "sudo nixos-rebuild test && systemctl restart emacs --user")
	  (pkgs.writeShellScriptBin "reload-nixos-trace" "sudo nixos-rebuild test --show-trace")
  ];

  darwin-scripts = [
    (pkgs.writeShellScriptBin "rebuild-darwin" "sudo darwin-rebuild switch --flake ~/nixos#big-mac")
  ];

  global-scripts = [
    (pkgs.writeShellScriptBin "speak" "toilet \"$1\" | cowsay -rn | lolcat")
    (pkgs.writeShellScriptBin "actually" "toilet \"$1\" | cowsay -rf actually -n | lolcat")
  ];
}
