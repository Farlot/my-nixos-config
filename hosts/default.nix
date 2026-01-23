{ config, pkgs, stable-pkgs, lib, inputs, ... }:

{
  imports =
  [
    ../hardware-configuration.nix
    ../modules/maintenance.nix
    ../modules/gameservers
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
  ];


  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  boot.loader.grub = {
  enable = true;
  device = "nodev"; # Or specify your device, e.g., "/dev/sda"
  efiSupport = true; # If you're using UEFI
  };
  boot.loader.systemd-boot.enable = false;


  time.timeZone = "Europe/Oslo";
  i18n.defaultLocale = "en_US.UTF-8";
  services.xserver.enable = true;

  services.displayManager.sddm = {
    enable = true;
    autoNumlock = true;
  };


  services.xserver.xkb = {
    layout = "no";
    variant = "";
  };
  console.keyMap = "no";
  services.printing.enable = true;

  # AUDIO
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Shell
  programs.zsh.enable = true;

  users.users.maw = {
    isNormalUser = true;
    description = "";
    extraGroups = [ "networkmanager" "wheel" "docker" "vboxusers" "gamemode"];
    shell = pkgs.zsh;
    packages = with pkgs; [
    ];
  };

  # Allow non-free packages
  nixpkgs.config.allowUnfree = true;
  programs.nix-ld.enable = true; # https://nix.dev/guides/faq#how-to-run-non-nix-executables
  programs.nix-ld.libraries = with pkgs; [
  # Add missing dynamic libraries for unpackages programs here :
  ];

  programs.git = {
    enable = true;
    };

  environment.systemPackages = [
    pkgs.sops
  ];

  # fetch secrets with :
  # $(cat ${config.sops.secrets."myservice/my_subdir/my_secret".path})
  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/maw/.config/sops/age/keys.txt";
  sops.secrets.wgpub = {};
  sops.secrets.wgpriv = {};
  #sops.secrets."myservice/my_subdir/mysecret" = {};

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };

  system.stateVersion = "24.05"; # Did you read the comment?
  nix.settings.experimental-features = [ "nix-command" "flakes" ];


}

