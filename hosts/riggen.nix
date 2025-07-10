{ config, pkgs, lib, inputs, ... }:

{

  networking.hostName = "riggen";
  media_server.enable = false;

  # Packages
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

  # Coolercontrol / Virtual
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

  # Kernel Version :
  boot.kernelParams = [ "kvm.enable_virt_at_load=0" "nvidia-drm.fbdev=0" ];

  systemd.services.ckb-next = lib.mkIf config.hardware.ckb-next.enable {
    serviceConfig.ExecStart = lib.mkForce "${config.hardware.ckb-next.package}/bin/ckb-next-daemon --enable-experimental ${lib.optionalString (config.hardware.ckb-next.gid != null) "--gid=${builtins.toString config.hardware.ckb-next.gid}"}";
  };

  hardware = {
    graphics.enable32Bit = true;
    graphics.enable = true;
    nvidia.open = false;
  };
  # Nvidia settings
  hardware.nvidia = {
    #modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    #open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  services.xserver.videoDrivers = [ "nvidia" ];

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

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users.maw = import ../home.nix;
  };

  programs.ssh = {
    #enable = true;
    startAgent = true;
  };

}
