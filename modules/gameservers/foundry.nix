{ config, pkgs, ... }:

{
  virtualisation.oci-containers.containers.foundry = {
    image = "docker.io/luxusburg/docker-foundry:latest";
    #pull = "always";
    ports = [ "27015:27015/udp" "3724:3724/udp" ]; # Adjust as needed
    volumes = [
      "/mnt/stuff/DockerStuff/foundry/server:/home/foundry/server_files"
      "/mnt/stuff/DockerStuff/foundry/data:/home/foundry/persistent_data"
    ];
    environment = {
      TZ = "Europe/Paris";
      SERVER_NAME = "Space Idiots";
      SERVER_PWD = "smallpp"; # REMINDER: Change this password
      PAUSE_SERVER_WHEN_EMPTY = "false";
      MAX_TRANSFER_RATE = "8192";
    };

  };
}
