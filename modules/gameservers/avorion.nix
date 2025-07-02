{ config, pkgs, ... }:

{
  virtualisation.oci-containers.containers.avorion = {
    image = "docker.io/rfvgyhn/avorion:latest";
    pull = "always";
    ports = [ "27000:27000/tcp" "27003:27003/udp" "27015:27015/tcp" ]; # Adjust as needed
    volumes = [
      "/mnt/stuff/DockerStuff/avorion/currentsave:/home/steam/.avorion/galaxies/avorion_galaxy" # Map a local directory for persistent data
      "/mnt/stuff/DockerStuff/avorion/backup:/home/steam/.avorion/backups"
    ];
  };
}
