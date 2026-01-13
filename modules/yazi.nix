{ pkgs, ... }:

{
  # 1. Yazi Configuration
  programs.yazi = {
    enable = true;
    enableZshIntegration = true; # Change to enableBashIntegration if using Bash

    settings = {
      manager = {
        show_hidden = false;
        sort_by = "natural";
        sort_dir_first = true;
        linemode = "none";
      };
      preview = {
        max_width = 1920;
        max_height = 1080;
        image_filter = "lanczos3";
        sixel_fraction = 10;
      };
    };
  };

  # 2. Yazi-specific Dependencies
  # We put them here instead of home.nix so they live and die with this file.
  home.packages = with pkgs; [
    # Archive tools for Yazi to use
    p7zip
    unrar
    gnutar

    # Preview tools
    ffmpegthumbnailer
    poppler
    imagemagick
    fd
    ripgrep
    zoxide
  ];
}
