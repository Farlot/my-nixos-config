{ config, pkgs, stable-pkgs, lib, inputs, ... }:

{
  imports =
  [
    ../hardware-configuration.nix
    ../modules/maintenance.nix
    ../modules/gameservers
    #../modules/arr.nix
    #./modules/gameservers/empyrion.nix
    #./modules/gameservers/foundry.nix
    #./modules/gameservers/avorion.nix
    #./modules/gameservers/factorio.nix
    #./modules/gameservers/abiotic.nix
    #./modules/gameservers/icarus.nix
    #./modules/gameservers/soulmask.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
  ];


  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  boot.loader.grub = {
  enable = true;
  device = "nodev"; # Or specify your device, e.g., "/dev/sda"
  efiSupport = true; # If you're using UEFI
  #Optional configurations
  #useOSProber = true; #To detect other OS's
  #efiInstallAsRemovable = true; # Sometimes this helps with UEFI issues.
  };
  boot.loader.systemd-boot.enable = false;


  time.timeZone = "Europe/Oslo";
  i18n.defaultLocale = "en_US.UTF-8";
  services.xserver.enable = true;

  # KDE
  #services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm = {
    enable = true;
    autoNumlock = true;
  };

  # Hyprland
  programs.hyprland = { enable = true; xwayland.enable = true;};
  programs.waybar = { enable = true;};
  programs.hyprlock.enable = true;

  programs.fuse.userAllowOther = true;

  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];


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
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Shell
  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.maw = {
    isNormalUser = true;
    description = "Marcus";
    extraGroups = [ "networkmanager" "wheel" "docker" "vboxusers" "gamemode"];
    shell = pkgs.zsh;
    packages = with pkgs; [
    #kdePackages.kate
    #  thunderbird
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

  #nixpkgs.config = {
  #  programs.git.extraConfig = {
  #    user.name = "Farlot";
  #    user.email = "m.waaagan@gmail.com";
  #    safe.directory = [ "/mnt/stuff/nixos" ];
  #    url."git@github.com:".insteadOf = "https://github.com/";
  #  };
  #};

  #environment.sessionVariables = {
  #EDITOR = "kate";
  #};

  environment.systemPackages = [
    pkgs.keepassxc
    pkgs.discord
    pkgs.fastfetch
    pkgs.podman
    pkgs.btop
    pkgs.nh
    pkgs.sops
    pkgs.firefox
    stable-pkgs.gimp
    pkgs.pavucontrol
    # Hyprland rebuild
    pkgs.hyprshot
    pkgs.libnotify
    pkgs.kdePackages.dolphin
    pkgs.kitty
    pkgs.hyprpaper
    pkgs.calcurse
    pkgs.kdePackages.gwenview
    pkgs.kdePackages.ark
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

