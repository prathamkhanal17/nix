{ config, pkgs, ... }:

{
  imports = [
    ./hosts/legion.nix# You can dynamically choose host later if needed
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;


  services.xserver.enable = true;

  services.displayManager = {
    sddm.enable = true;
    autoLogin.enable = false;
    autoLogin.user = "prathamk";
  };

  services.desktopManager.plasma6.enable = true;

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
    google-chrome
    python314
    fastfetch
    lshw
    btop
    yazi
    pkgs.kdePackages.kdeconnect-kde
    alacritty
    git
  ];

  # Open ports in the firewall.
   networking.firewall.allowedTCPPortRanges = [ {from=1714; to=1764;} ]; #kde connect
   networking.firewall.allowedUDPPortRanges = [ {from=1714; to=1764;} ]; #kde connect
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "25.05"; # Did you read the comment?
  nix.binaryCaches = [ "https://aseipp-nix-cache.global.ssl.fastly.net" ];
}
