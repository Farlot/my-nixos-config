{ config, pkgs, ... }:

{
  virtualisation.oci-containers.containers.vintagestorykaoi = {
    image = "docker.io/devidian/vintagestory:latest";
    ports = [ "42420:42420" ];
    volumes = [
      "/mnt/stuff/DockerStuff/vintagestorykaoi:/gamedata"
    ];
    environment = {
      VS_DATA_PATH = "/gamedata";
    };
  };
}
