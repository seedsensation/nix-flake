{
  pkgs,
  config,
  inputs,
  ...
}:
let
  pkgs-legacy = import inputs.nixpkgs-legacy {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
  pkgs-stable = import inputs.nixpkgs-stable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
{
  # stuff that wants to go system-wide on every device
  # primarily, things that i want to be able to use as sudo
  global-utils = with pkgs; [
    autoconf
    clang-tools
    cmake
    cmake-format
    cmatrix
    coreutils
    doxygen
    fd
    fmt
    freetype
    gcc
    gd
    gnumake
    llvm
    maven
    neovim
    netcat-gnu
    openssl
    openssl.dev

    rustup
    screen
    sqlite
    tree
    unzip
    vim
    ##jdk25_headless
    ##javaPackages.openjfx25

    python3
  ];

  # desktop apps, specifically for nixos
  desktop-software = with pkgs; [
    alsa-plugins
    brightnessctl
    ckan
    davinci-resolve
    firefox
    flameshot
    gh
    gitFull
    godot
    gnome-keyring
    grim
    handbrake
    hyprpaper
    killall
    krita
    libGL
    libreoffice
    pavucontrol
    playerctl
    prismlauncher
    qpwgraph
    slurp
    twitch-dl
    #pkgs-stable.tuxclocker
    vesktop
    vlc
    wine
    wtype
    yt-dlp

    (bottles.override { removeWarningPopup = true; })

    # sway requirements
    mako
    wl-clipboard
    xdg-desktop-portal
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk

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
    # command line utils
    tree

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
    rustfmt

  ];

  latex-docs = with pkgs; [
    texliveFull
    pandoc
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
    tree-sitter-grammars.tree-sitter-yaml

    # LaTeX Packages
    #(texliveBasic.withPackages (
    #  ps: with ps; [
    #    dvisvgm
    #    dvipng
    #    wrapfig
    #    amsmath
    #    ulem
    #    hyperref
    #    capt-of
    #    ec
    #    xelatex
    #    #(setq org-latex-compiler "lualatex")
    #    #(setq org-preview-latex-default-process 'dvisvgm)
    #  ]
    #))
  ];

  #### EMACS PACKAGES ####
  emacs = (
    pkgs.emacsWithPackagesFromUsePackage {
      config = (
        builtins.readFile "${
          inputs.emacs-flake.packages.${pkgs.stdenv.hostPlatform.system}.default
        }/custom.el"
      );
      defaultInitFile = false;
      #package = pkgs.emacs;
      alwaysEnsure = true;
      #alwaysPin = "gnu";
      #alwaysTangle = true;
      extraEmacsPackages =
        epkgs: with epkgs; [

          ace-window
          avy
          #company
          cmake-mode
          corfu
          corfu-terminal
          consult
          dash
          doxymacs
          emacs-everywhere
          envrc
          evil
          f
          format-all
          fzf
          gdscript-mode
          git-gutter
          gruvbox-theme
          inheritenv
          ivy
          ivy-prescient
          lsp-java
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
          pdf-tools
          projectile
          rustic
          simple-httpd
          smartparens
          sqlite3
          surround
          treemacs
          treemacs-evil
          vertico
          multi-vterm
          #vterm
          websocket
          yaml-mode

          # Jupyter Notebooks
          jupyter
          ein
        ];
    }
  );

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
