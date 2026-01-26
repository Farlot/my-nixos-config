{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [
      ./hyprland.nix
      ./rofi.nix
      ./waybar.nix
    ];
}
