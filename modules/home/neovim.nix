{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.packages = with pkgs; [

    # Core CLI
    ripgrep
    fd
    git
    stylua
    nixfmt-rfc-style
    tree-sitter

    # Python runtime & tools
    python3
    python3Packages.debugpy
    python3Packages.pytest

    # LSP / linters / formatters (Nix-only, no Mason)
    pyright
    ruff # provides `ruff server` LSP
    black
    isort

    # Markdown CLIs
    pandoc
    glow
    nodePackages_latest.prettier
    trash-cli # for nvim-tree trash
  ];

  programs.neovim.plugins = with pkgs.vimPlugins; [
    lazy-nvim
  ];

}
