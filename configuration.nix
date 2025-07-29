{ config, pkgs, ... }:

{
  imports = [
    ./hosts/legion.nix
    ./hardware-configuration.nix
    ./modules/system/gnome.nix
    ./modules/system/vm.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  
  security.rtkit.enable = true;

  networking.networkmanager.enable = true;

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  environment.shells = [ pkgs.zsh ];

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];

  environment.systemPackages = with pkgs; [
    vim
    wget
    vscode
    fastfetch
    lshw
    google-chrome
    btop
    yazi
    pkgs.kdePackages.kdeconnect-kde
    alacritty
    git
    openssh
    pkgs.tree
    pkgs.wl-clipboard
    tmux
    pkgs.devenv
    pkgs.waydroid
    pkgs.ollama
    pkgs.youtube-music
    firefox
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPortRanges = [ {from=1714; to=1764;} ]; #kde connect
  # networking.firewall.allowedUDPPortRanges = [ {from=1714; to=1764;} ]; #kde connect
  # Or disable the firewall altogether.
   networking.firewall.enable = false;

  system.stateVersion = "25.05"; # Did you read the comment?
  nix.settings.substituters = [ "https://aseipp-nix-cache.global.ssl.fastly.net" ];
}
