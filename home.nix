{ config, pkgs, ... }:
{
  imports = [
    ./modules/home/zsh.nix
    ./modules/home/gtk.nix
    ./modules/home/fastfetch.nix
    ./modules/home/wlogout.nix
    ./modules/home/dconf.nix
    ./modules/home/neovim.nix
    ./modules/home/waybar.nix
    ./modules/home/hyprland.nix
    ./modules/home/rofi.nix
  ];
  nixpkgs.config.allowUnfree = true;

  home.username = "prathamk";
  home.homeDirectory = "/home/prathamk";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
  # rofi-wayland #app launcher
  waybar #status bar
  swww #wallpaper manager
  wl-clipboard #clipboard manager
  wlogout #logout menu
  hypridle #idle management
  hyprlock #screen locker
  swappy #image editor
  slurp #screen selector
  grim #screenshot tool
  xdg-desktop-portal #portal for desktop applications
  xdg-desktop-portal-hyprland #hyprland portal
  swaynotificationcenter #notification center
  (python313.withPackages (ps: with ps; [
    requests
    ])) # Python with requests library
  mpv #media player
  playerctl # media player control
  cliphist # clipboard history manager
  xdg-utils
  brightnessctl
  networkmanagerapplet
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

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 22;
  };
  programs.home-manager.enable = true;
}
