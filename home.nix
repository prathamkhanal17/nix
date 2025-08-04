{ config, pkgs, ... }:
{
  imports = [
    ./modules/home/zsh.nix
    ./modules/home/gtk.nix
    ./modules/home/fastfetch.nix
  ];
  home.username = "prathamk";
  home.homeDirectory = "/home/prathamk";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
  rofi-wayland
  waybar
  swww
  wl-clipboard
  wlogout
  swaynotificationcenter
  (python313.withPackages (ps: with ps; [ 
    requests
    ]))
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
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
}
