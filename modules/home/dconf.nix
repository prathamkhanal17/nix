{ config,pkgs, lib, ...}:
{
    dconf.enable = true; # Ensure dconf is enabled
dconf.settings = with lib.hm.gvariant; {
    "org/gnome/shell/extensions/user-theme" = {
    name = "Gruvbox-Dark";
    };
    "org/gnome/desktop/interface".color-scheme = "prefer-dark";
    "org/gnome/desktop/background" = {
          picture-uri = "file://${../../wallpapers/gruvbox-nix.png}";
          picture-options = "zoom"; # or "stretched", "wallpaper", etc.
          color-shading-type = "solid"; # or "vertical", "horizontal"
          primary-color = "#000000"; # if color-shading-type is "solid"
};
};
}