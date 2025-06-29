{ config, pkgs, ... }:

{
  virtualisation.oci-containers.containers.avorion = {
    image = "docker.io/rfvgyhn/avorion";
    ports = [ "27000:27000/tcp" "27003:27003/udp" ]; # Adjust as needed
    volumes = [
      "/mnt/stuff/DockerStuff/avorion/currentsave:/home/steam/.avorion/galaxies/avorion_galaxy" # Map a local directory for persistent data
      "/mnt/stuff/DockerStuff/avorion/backup:/home/steam/.avorion/backups"
    ];
    # If the image uses a non-root user, you might need to specify it:
    # user = "1000:1000"; # Replace with the correct UID:GID
    # If you need environment variables:
    # environment = {
    #   "SOME_VAR" = "some_value";
    # };
    # If you need to specify resource limits:
    # resources = {
    #   memory = "4G";
    #   cpuShares = 1024;
    # };
    # If you need to set restart policies:
    # autoRestart = true;
  };
}
