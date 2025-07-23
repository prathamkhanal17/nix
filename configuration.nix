{ config, pkgs, ... }:

{
  imports = [
    ./hosts/legion.nix# You can dynamically choose host later if needed
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Asia/Kathmandu";
  i18n.defaultLocale = "en_US.UTF-8";

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

  users.users.prathamk = {
    isNormalUser = true;
    description = "Pratham Khanal";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
  };

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
}
