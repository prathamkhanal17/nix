{pkgs, ...}:
{
    gtk = {
        enable = true;
        cursorTheme.package = pkgs.vanilla-dmz;
        cursorTheme.name = "Vanilla-DMZ";
    };
}