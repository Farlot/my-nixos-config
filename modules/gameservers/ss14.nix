{ config, pkgs, ... }:

{
  virtualisation.oci-containers.containers.spacestation14 = {
    image = "ghcr.io/farlot/ss14-docker-linux-server:latest";
    ports = [
      "1212:1212/tcp" # Game server TCP port
      "1212:1212/udp" # Game server UDP port
      "5000:5000/tcp" # Default RCON TCP port (from Dockerfile)
      "5000:5000/udp" # Default RCON UDP port (from Dockerfile)
    ];
    volumes = [
      # Map your host directory for server data to the container's data directory.
      # IMPORTANT: Replace "/path/on/host" with your desired host path, e.g., "/mnt/stuff/DockerStuff/spacestation14/data"
      "/mnt/stuff/DockerStuff/spacestation14/:/ss14"
    ];
    # autoStart = false; # Equivalent to Docker Compose's 'restart: always'
    # wantedBy = [ "multi-user.target" ]; # Optional: ensure it starts with the system
  };
}
