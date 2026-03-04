{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    extraPackages = with pkgs; [
      # LSP servers
      lua-language-server
      nil
      pyright
      typescript-language-server
      clang-tools
      vscode-langservers-extracted
      bash-language-server

      # Formatters
      stylua
      ruff
      black
      isort
      prettier
      shfmt
      codespell
      fixjson

      # Linters
      mypy
      shellcheck

      # Debuggers
      python3Packages.debugpy

      # Plugin dependencies
      imagemagick
    ];
  };

  home.file.".config/nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dothome/config/nvim";
  };
}
