{ config, pkgs, ... }:

{
  # Enable the Tailscale service
  services.tailscale.enable = true;

  networking.firewall = {
    allowedUDPPorts = [
      41641 # Default Tailscale
      42421 # Vintage Story
      7777  # Abiotic Factor
      14159 # Necesse
      34197 # Factorio
      25565 # Minecraft
    ];
  };
}
