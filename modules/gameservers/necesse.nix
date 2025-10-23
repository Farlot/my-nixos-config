{ config, pkgs, ... }:

{
  virtualisation.oci-containers.containers.necesse = {
    image = "docker.io/brammys/necesse-server:latest";
    autoStart = false;
    ports = [ "14159:14159" ];
    volumes = [
      "/mnt/stuff/DockerStuff/necesse/saves:/necesse/saves"
    ];
    environment = {
      PASSWORD = "smallpp";
      OWNER = "Farlot";
      WORLD = "Rage";
      MOTD = "Motd's are dumb";

    };
  };
}
