{
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrains Mono Nerd Font";
      size = 11.0;
    };
    settings = {
      confirm_os_window_close = "0";
      shell = "zsh";
    };
    keybindings = {
      "ctrl+c" = "copy_or_interrupt";
      "page_up" = "scroll_page_up";
      "page_down" = "scroll_page_down";
      "ctrl+plus" = "change_font_size all +1";
      "ctrl+equal" = "change_font_size all +1";
      "ctrl+kp_add" = "change_font_size all +1";
      "ctrl+minus" = "change_font_size all -1";
      "ctrl+underscore" = "change_font_size all -1";
      "ctrl+kp_subtract" = "change_font_size all -1";
      "ctrl+0" = "change_font_size all 0";
      "ctrl+kp_0" = "change_font_size all 0";
    };
    # You can include your theme configuration like this, assuming current-theme.conf is accessible or embedded.
    # For a full theme, you might copy its contents into `extraConfig` or manage it as a separate file.
    extraConfig = ''
      cursor_shape beam
      cursor_trail 1
      include current-theme.conf
      background_image_layout scaled
    '';
  };
}