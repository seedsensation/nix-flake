{ pkgs, ... }:
{
  # stuff that wants to go system-wide on every device
  # primarily, things that i want to be able to use as sudo
  global-utils = with pkgs; [
    coreutils
    fmt
    llvm 
    cmake
    fd
    vim
    neovim
    autoconf
    sqlite
    gcc
    busybox
  ];

  ssh-utils = with pkgs; [
    google-authenticator
  ];

  # desktop apps, specifically for nixos
  desktop-software = with pkgs; [
    prismlauncher
    vesktop
    firefox
    ghostty
    wofi
    wl-clipboard
    grim
    slurp
    flameshot
    hyprpaper
    playerctl
    brightnessctl
    wtype
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

  ];

  emacs = (pkgs.emacsPackagesFor pkgs.emacs).emacsWithPackages ( epkgs:
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

  );

}
