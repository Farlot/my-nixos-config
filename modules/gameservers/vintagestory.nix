{ config, pkgs, ... }:

{
  virtualisation.oci-containers.containers.vintagestory = {
    image = "docker.io/devidian/vintagestory:latest";
    autoStart = false;
    ports = [ "42421:42420" ];
    volumes = [
      "/mnt/stuff/DockerStuff/vintagestory:/gamedata"
    ];
    environment = {
      VS_DATA_PATH = "/gamedata";
    };
  };
}
