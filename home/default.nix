{ ... }:

{
  imports = [
    ./packages.nix
    ./zsh.nix
    ./kitty.nix
    ./tmux.nix
    ./neovim.nix
    ./git.nix
  ];

  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
}
