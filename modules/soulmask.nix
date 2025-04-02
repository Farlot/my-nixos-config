{ config, pkgs, ... }:

{
  virtualisation.oci-containers.containers.soulmask = {
    # Url : https://hub.docker.com/r/kagurazakanyaa/soulmask
    image = "docker.io/kagurazakanyaa/soulmask";
    ports = [ "7777:7777/udp" ]; # Adjust as needed
    volumes = [
      "/mnt/stuff/DockerStuff/soulmask:/opt/soulmask/WS/Saved" # Map a local directory for persistent data
    ];
    #cmd =[ "" ];
  };
}
