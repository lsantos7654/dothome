{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Fonts
    nerd-fonts.hack

    # Terminal utilities
    wl-clipboard
    ripgrep
    fd
    fzf
    bat
    eza
    zoxide
    glow
    tree
    uv
    zsh-powerlevel10k
    fastfetch
    cmatrix

    # Neovim dependencies
    nodejs
    python3
    gcc
    gnumake
    unzip
    cargo
    luajit
    luarocks
  ];
}
