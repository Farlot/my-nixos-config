{ config, pkgs, lib, inputs, ... }:

{

  networking.hostName = "riggen";

  imports =[
    inputs.stable-diffusion-webui-nix.nixosModules.default
    ../modules/ollama.nix
    ../modules/backup.nix
    ../modules/wireguardvpn.nix
    ../modules/ddns.nix
  ];


  # Packages
  nixpkgs.config.permittedInsecurePackages = ["dotnet-runtime-7.0.20"];
  environment.systemPackages = with pkgs; [
    goxlr-utility # audio
    kdePackages.kate # text editor
    ckb-next # keyboard
    nvidia-container-toolkit # gpu
    coolercontrol.coolercontrold # cooling
    protonup-ng # gaming
    docker # container
    podman # container
    docker-compose # container
    runc # OCI container
    gh # Git CLI integration?
    ollama
    rclone # cloud storage
    stable-diffusion-webui.comfy.cuda # ai
    stable-diffusion-webui.forge.cuda # ai
  ];

  services.dbus.enable = true;

  services.autorandr = {
    enable = true;
    };

  # Hyprland
  programs.hyprland = { enable = true; xwayland.enable = true;};
  programs.hyprlock.enable = true;
  programs.fuse.userAllowOther = true; # gcrypt integration

  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];

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
    NIXOS_OZONE_WL = "1";
  };

  home-manager.backupFileExtension = "hm-bak";
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users.maw = import ../home.nix;
  };


}
