{ pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;          # use pkgs.rofi if you're on X11
    font = "JetBrainsMono Nerd Font 10";

    # Built-in filebrowser; no plugins needed
    extraConfig = {
      modi = "drun,filebrowser,window,run";
      show-icons = true;
      icon-theme = "Tela-circle-dracula";

      display-drun = " ";
      display-run = " ";
      display-filebrowser = " ";
      display-window = " ";

      drun-display-format = "{name}";
      window-format = "{w}{t}";

      matching = "fuzzy";
      case-sensitive = false;
      cycle = true;
    };

    # Point rofi at the theme file we install below
    theme = "~/.config/rofi/theme.rasi";
  };

  # Write your theme as a *raw Rasi* file (no lib.formats.rasi needed)
  xdg.configFile."rofi/theme.rasi".text = ''
* {
  main-bg: #1d2021;
  main-fg: #fbf1c7;
  main-br: #504945;
  select-bg: #3c3836;
  select-fg: #fbf1c7;
  red:    #cc241d;
  green:  #98971a;
  yellow: #d79921;
  blue:   #458588;
  purple: #b16286;
  aqua:   #689d6a;
  orange: #d65d0e;
}

window {
  height: 33em;
  width: 63em;
  transparency: "real";
  fullscreen: false;
  enabled: true;
  cursor: default;
  spacing: 0em;
  padding: 0em;
  border-color: @main-br;
  background-color: @main-bg;
  border-radius: 15px;
}

mainbox {
  enabled: true;
  spacing: 0em;
  padding: 0em;
  orientation: horizontal;
  children: [ "dummywall", "listbox" ];
  background-color: transparent;
  border-radius: 15px;
}

dummywall {
  spacing: 0em;
  padding: 0em;
  width: 37em;
  expand: false;
  orientation: horizontal;
  children: [ "mode-switcher", "inputbar" ];
  background-color: transparent;
  background-image: url("~/nix/wallpapers/elias.png", height);
}

mode-switcher {
  orientation: vertical;
  enabled: true;
  width: 3.8em;
  padding: 9.2em 0.5em 9.2em 0.5em;
  spacing: 1.2em;
  background-color: transparent;
  background-image: url("~/nix/wallpapers/elias.png", height);
}

button {
  cursor: pointer;
  border-radius: 2em;
  background-color: @main-bg;
  text-color: @main-fg;
}

button selected {
  background-color: @main-fg;
  text-color: @main-bg;
}

inputbar {
  enabled: true;
  children: [ "entry" ];
  background-color: transparent;
}

entry { enabled: false; }

listbox {
  spacing: 0em;
  padding: 2em;
  children: [ "dummy", "listview", "dummy" ];
  background-color: transparent;
}

listview {
  enabled: true;
  spacing: 0em;
  padding: 0em;
  columns: 1;
  lines: 8;
  cycle: true;
  dynamic: true;
  scrollbar: false;
  layout: vertical;
  reverse: false;
  expand: false;
  fixed-height: true;
  fixed-columns: true;
  cursor: default;
  background-color: transparent;
  text-color: @main-fg;
}

dummy { background-color: transparent; }

element {
  enabled: true;
  spacing: 0.8em;
  padding: 0.4em 0.4em 0.4em 1.5em;
  cursor: pointer;
  background-color: transparent;
  text-color: @main-fg;
}

element selected.normal {
  background-color: @select-bg;
  text-color: @select-fg;
}

element-icon {
  size: 2.8em;
  cursor: inherit;
  background-color: transparent;
  text-color: inherit;
}

element-text {
  vertical-align: 0.5;
  horizontal-align: 0.0;
  cursor: inherit;
  background-color: transparent;
  text-color: inherit;
}

error-message {
  text-color: @main-fg;
  background-color: @main-bg;
  text-transform: capitalize;
  children: [ "textbox" ];
}

textbox {
  text-color: inherit;
  background-color: inherit;
  vertical-align: 0.5;
  horizontal-align: 0.5;
}
'';
}
