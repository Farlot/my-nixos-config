{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12; 
    };

    shellIntegration.enableZshIntegration = true;
    settings = {
      background_opacity = "0.85";
      confirm_os_window_close = 0;


      # Core Colors
      background = "#282828";
      foreground = "#0abdc6";
      selection_background = "none";
      selection_foreground = "none";
      cursor = "#0abdc6";

      active_tab_foreground = "#eeeeee";
      active_tab_background = "#000d24";
      inactive_tab_foreground = "#0abdc6";
      inactive_tab_background = "#000918";

      # Color Palette
      # Black
      color0 = "#000b1e";
      color8 = "#1c61c2";
      # Red
      color1 = "#ff0000";
      color9 = "#ff0000";
      # Green
      color2 = "#d300c4";
      color10 = "#d300c4";
      # Yellow
      color3 = "#f57800";
      color11 = "#ff5780";
      # Blue
      color4 = "#133e7c";
      color12 = "#00ff00";
      # Purple
      color5 = "#711c91";
      color13 = "#711c91";
      # Cyan
      color6 = "#0abdc6";
      color14 = "#0abdc6";
      # White
      color7 = "#0abdc6";
      color15 = "#0abdc6";
    };
  };
}
