# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./modules/maintenance.nix
      ./modules/gameservers
      ./modules/arr.nix
      inputs.home-manager.nixosModules.home-manager
    ];
  # Boot
  boot.loader.grub = {
    enable = true;
    device = "nodev"; # Or specify your device, e.g., "/dev/sda"
    efiSupport = true; # If you're using UEFI
    #Optional configurations
    #useOSProber = true; #To detect other OS's
    #efiInstallAsRemovable = true; # Sometimes this helps with UEFI issues.
  };
  boot.loader.systemd-boot.enable = false;

  networking.hostName = "riggen"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "no";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "no";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.maw = {
    isNormalUser = true;
    description = "Marcus";
    extraGroups = [ "networkmanager" "wheel" "docker" "vboxusers" "gamemode"];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Arr stack activate
  media_server.enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    kdePackages.kate
    keepassxc
    goxlr-utility
    ckb-next
    discord
    betterdiscordctl
    #vesktop #No keybind support, trash
    #legcord #Has keybinds, but they dont work
    steam
    coolercontrol.coolercontrold
    coolercontrol.coolercontrol-liqctld
    coolercontrol.coolercontrol-gui
    fastfetch
    protonup
    docker
    docker-compose
    podman
    btop
    runc
    nvidia-container-toolkit
    git
    gh
    nh # Nixos fancy rebuild tool
    #bottles
    firefox
    #librewolf
    prismlauncher
    google-chrome
    flatpak
    umu-launcher
    obs-studio
    ydotool
    rust-stakeholder
    rclone
    #qjackctl
    easyeffects
  ];

  programs.nix-ld.enable = true; # https://nix.dev/guides/faq#how-to-run-non-nix-executables
  programs.nix-ld.libraries = with pkgs; [
  # Add missing dynamic libraries for unpackages programs here :
  ];


  programs.git = {
    enable = true;
    };

  nixpkgs.config = {
    programs.git.extraConfig = {
      user.name = "Farlot";
      user.email = "m.waaagan@gmail.com";
      safe.directory = [ "/mnt/stuff/nixos" ];
      url."git@github.com:".insteadOf = "https://github.com/";
    };
  };

  programs.coolercontrol.enable = true;
  services.goxlr-utility.enable = true;
  hardware.ckb-next.enable = true;
  virtualisation.docker = {
    enable = true;
    #package = pkgs.docker_25;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.guest.enable = true;
  hardware.nvidia-container-toolkit.enable = true; # New but problematic ?

  boot.kernelParams = [ "kvm.enable_virt_at_load=0" "nvidia-drm.fbdev=0" ];
  boot.kernelPackages = pkgs.linuxPackages_latest; # Commenting out the kernel change until virtualbox fixes build issue with 6.15

  systemd.services.ckb-next = lib.mkIf config.hardware.ckb-next.enable {
    serviceConfig.ExecStart = lib.mkForce "${config.hardware.ckb-next.package}/bin/ckb-next-daemon --enable-experimental ${lib.optionalString (config.hardware.ckb-next.gid != null) "--gid=${builtins.toString config.hardware.ckb-next.gid}"}";
  };

  hardware = {
  graphics.enable32Bit = true;
  graphics.enable = true;
  nvidia.open = false;
  #nvidia-container-toolkit.enable = true;
  };
  # nvidia configuration
  hardware.nvidia = {
    #modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    #open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  # Steam
  programs.steam = {
    enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };
  programs.gamemode.enable = true;
  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/maw/.steam/root/compatabilitytools.d";
  };
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users.maw = import ./home.nix;
  };

  # Secret stuff
  programs.ssh = {
    #enable = true;
    startAgent = true;
  };


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

}
