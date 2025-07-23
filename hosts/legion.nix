{ config, pkgs, ... }:

{
    hardware.graphics.enable=true;
    services.xserver.videoDrivers=["nvidia"];
    hardware.nvidia={
	modesetting.enable=true;
	open=false;
	package=config.boot.kernelPackages.nvidiaPackages.stable;
};
  time.timeZone = "Asia/Kathmandu";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  users.users.prathamk = {
    isNormalUser = true;
    description = "Pratham Khanal";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
  };

  networking.hostName = "nixos"; 

}
