{ config, pkgs, ... }:

{
  virtualisation.oci-containers.containers.abiotic = {
    image = "ghcr.io/pleut/abiotic-factor-linux-docker:latest";
    ports = [ "7777:7777/udp" "27016:27016/tcp" ]; # Adjust as needed
    volumes = [
      "/mnt/stuff/DockerStuff/abiotic:/server/AbioticFactor/Saved" # Map a local directory for persistent data
    ];
    environment = {
      MaxServerPLayers = "6";
      Port = "7777";
      QueryPort = "27016";
      ServerPassword = "kaoi";
      SteamServerName = "RageAura";
      UsePerfThreads = "true";
      NoAsyncLoadingThread = "true";
      WorldSaveName = "idiots2";
      AutoUpdate = "true";
      AdditionalArgs = "-SandboxIniPath=Config/WindowsServer/Server1Sandbox.ini";
    };
  };
}
