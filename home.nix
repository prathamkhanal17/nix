{ config, pkgs, ... }:
{
  imports = [
    ./modules/home/zsh.nix
  ];
  home.username = "prathamk";
  home.homeDirectory = "/home/prathamk";
  home.stateVersion = "25.05";

  home.packages = [
  ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    userName = "prathamkhanal17";
    userEmail = "prathamkhanal962@gmail.com";
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs.home-manager.enable = true;
}
