# dothome

Portable Home Manager configuration. Works standalone on any Linux system with Nix, or as a module imported by a NixOS flake.

## What's included

- **zsh** — oh-my-zsh, powerlevel10k, aliases, docker/gcloud/jupyter functions
- **kitty** — Solarized Dark theme, Hack Nerd Font
- **tmux** — vim keybindings, C-Space prefix, minimal status bar
- **neovim** — LSP servers, formatters, linters, config symlinked from `config/nvim/`
- **git** — user config

## Quick setup

### 1. Install Nix

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh
```

### 2. Clone and apply

```bash
git clone https://github.com/lsantos7654/dothome.git ~/dothome
nix run home-manager -- switch --flake ~/dothome#santos@nixos
```

## Usage with NixOS

This flake is imported as a module by [dotnix](https://github.com/lsantos7654/dotnix):

```nix
# In dotnix/flake.nix inputs:
dothome.url = "path:/home/santos/dothome";

# In configuration.nix:
home-manager.users.santos = {
  imports = [ inputs.dothome.homeModules.default ];
  home.username = "santos";
  home.homeDirectory = "/home/santos";
};
```

## Adding a new machine target

Add an entry to `flake.nix`:

```nix
homeConfigurations."santos@macbook" = home-manager.lib.homeManagerConfiguration {
  pkgs = nixpkgs.legacyPackages.aarch64-darwin;
  modules = [
    ./home
    { home.username = "santos"; home.homeDirectory = "/Users/santos"; }
  ];
};
```

Then: `home-manager switch --flake ~/dothome#santos@macbook`
