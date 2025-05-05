{ config, pkgs, ... }:

{
  virtualisation.oci-containers.containers.avorion = {
    image = "docker.io/factoriotools/factorio/";
    ports = [ "34197:34197/udp" "27015:27015/tcp" ]; # Adjust as needed
    volumes = [
      "/mnt/stuff/DockerStuff/factorio:/factorio" # Map a local directory for persistent data
    ];
  };
}
