{ config, pkgs, ... }:

{
    hardware.graphics.enable=true;
    services.xserver.videoDrivers=["nvidia" ];
    hardware.nvidia={
	modesetting.enable=true;
	open=false;
	package=config.boot.kernelPackages.nvidiaPackages.stable;
	prime = {
		sync.enable = true;
		nvidiaBusId = "PCI:1:0:0";
		amdgpuBusId = "PCI:5:0:0";
	};
};
  time.timeZone = "Asia/Kathmandu";
  i18n.defaultLocale = "en_US.UTF-8";
  environment.systemPackages = with pkgs; [
	vscode
	firefox
	youtube-music
	kdePackages.kdeconnect-kde
  ];
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

  networking.hostName = "legion"; 

}
