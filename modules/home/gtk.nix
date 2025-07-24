{ config, pkgs, ... }:

{
  gtk = {
    enable = true;

    theme = {
      name = "Gruvbox-Dark";  # One of the included variants
      package = pkgs.gruvbox-gtk-theme;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
    };
  };
}
