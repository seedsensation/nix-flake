{ pkgs, ... }:
{
  # stuff that wants to go system-wide on every device
  # primarily, things that i want to be able to use as sudo
  global-utils = with pkgs; [
    autoconf
    busybox
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
  ];

  ssh-utils = with pkgs; [
    google-authenticator
  ];

  # desktop apps, specifically for nixos
  desktop-software = with pkgs; [
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
  emacs = (pkgs.emacsPackagesFor pkgs.emacs).emacsWithPackages ( epkgs:
  (with epkgs.melpaStablePackages; [
    magit
    gruvbox-theme
    org-fragtog
  ])

  ++

  (with epkgs.melpaPackages; [
    avy
    company
    consult
    dash
    emacs-everywhere
    evil
    f
    ivy
    ivy-prescient
    magit-section
    marginalia
    nix-mode
    orderless
    simple-httpd
    surround
    vertico
    websocket
  ])

  ++

  (with epkgs.elpaPackages; [
    devdocs     
  ])

  ++ (with epkgs; [
    org
    org-roam
    org-roam-ui
    org-roam-timestamps
    sqlite3
    lsp-mode
  ])



  );

  nixos-scripts = [
    (pkgs.writeShellScriptBin "rebuild-nixos" "sudo nixos-rebuild switch")
	  (pkgs.writeShellScriptBin "reload-nixos" "sudo nixos-rebuild test")
	  (pkgs.writeShellScriptBin "reload-emacs" "sudo nixos-rebuild test && systemctl restart emacs --user")
	  (pkgs.writeShellScriptBin "reload-nixos-trace" "sudo nixos-rebuild test --show-trace")
  ];

  darwin-scripts = [
    (pkgs.writeShellScriptBin "rebuild-darwin" "sudo darwin-rebuild switch --flake ~/darwin#darwin")
  ];

  global-scripts = [
    (pkgs.writeShellScriptBin "speak" "toilet \"$1\" | cowsay -rn | lolcat")
    (pkgs.writeShellScriptBin "actually" "toilet \"$1\" | cowsay -rf actually -n | lolcat")
  ];
}
