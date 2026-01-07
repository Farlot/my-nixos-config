{ config, pkgs, lib, inputs, ... }:

{

  networking.hostName = "riggen";
  media_server.enable = false;

  imports =[
    ../modules/arr.nix
    ../modules/wireguardvpn.nix
    ../modules/ddns.nix
    inputs.stable-diffusion-webui-nix.nixosModules.default
  ];


  # Packages
  nixpkgs.config.permittedInsecurePackages = ["dotnet-runtime-7.0.20"];
  environment.systemPackages = with pkgs; [
    kdePackages.kate
    goxlr-utility
    ckb-next
    betterdiscordctl
    coolercontrol.coolercontrold
    #coolercontrol.coolercontrol-liqctld
    #coolercontrol.coolercontrol-gui
    protonup-ng
    docker
    docker-compose
    runc
    nvidia-container-toolkit
    gh
    prismlauncher
    google-chrome
    flatpak
    umu-launcher
    obs-studio
    ydotool
    rust-stakeholder
    rclone
    autorandr
    stable-diffusion-webui.comfy.cuda
    stable-diffusion-webui.forge.cuda
    # Games
    #vintagestory
  ];

  services.dbus.enable = true;

  services.autorandr = {
    enable = true;
    };


  # Noisetorch noisecancel stuff
  programs.noisetorch.enable = true;

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
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    #open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
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

  home-manager.backupFileExtension = "hm-bak";
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users.maw = import ../home.nix;

  };

  #sops.age.keyFile = "/home/maw/.config/sops/age/keys.txt";
  #sops.secrets.example-key = {};
  #sops.secrets."myservice/my_subdir/mysecret" = {};
  #programs.ssh = {
    #enable = true;
    #startAgent = true;
  #};

}
