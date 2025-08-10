{config, pkgs, ...}:
{
    #enable dconf (system management tool)
    programs.dconf.enable = true;

    #add user in the libvirtd group
    users.users.prathamk.extraGroups = [ "libvirtd" ];
    
    #install necessary packages
    environment.systemPackages = with pkgs; [
        virt-manager
        virt-viewer
        spice spice-gtk
        spice-protocol
        win-virtio
        win-spice
        adwaita-icon-theme
	    virtiofsd
    ];

    #Manage the virtualization services
    virtualisation = {
	waydroid.enable = false;
        libvirtd = {
            enable = true;
            qemu = {
                swtpm.enable = true;
                ovmf.enable = true;
                ovmf.packages = [ pkgs.OVMFFull.fd ];
            };
        };
        spiceUSBRedirection.enable = true;
    };
    services.spice-vdagentd.enable = true;
}
