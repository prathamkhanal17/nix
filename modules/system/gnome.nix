{pkgs, ...}:
{
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    environment.gnome.excludePackages = with pkgs.gnome; [
        pkgs.evince
        pkgs.simple-scan
        pkgs.totem
        pkgs.yelp
        pkgs.epiphany
        pkgs.geary
        pkgs.gnome-contacts
        pkgs.gnome-logs
        pkgs.gnome-maps
        pkgs.gnome-connections
        pkgs.gnome-console
        pkgs.gnome-tour
        pkgs.gnome-weather
    ];

}