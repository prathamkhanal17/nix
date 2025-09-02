    { config, pkgs, ... }:

    {
      programs.btop = {
        enable = true;
        settings = {
          color_theme = "gruvbox_dark_v2"; 
          update_ms = 1000;      
          show_detailed_cpu = true; 
        };
      };
    }
