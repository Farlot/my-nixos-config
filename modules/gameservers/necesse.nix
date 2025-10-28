{ config, pkgs, lib, ... }:

{
  sops.templates.necesse-env-password = {
    content = ''PASSWORD=${config.sops.placeholder."serverpass"}'';
    mode = "0400";
  };

  virtualisation.oci-containers.containers.necesse = {
    image = "docker.io/brammys/necesse-server:latest";
    autoStart = true;
    pull = "always";
    ports = [ "14159:14159/tcp" "14159:14159/udp" ];
    volumes = [
      "/mnt/stuff/DockerStuff/necesse/saves:/necesse/saves"
    ];

    environmentFiles = [
      config.sops.templates.necesse-env-password.path
    ];

    environment = {
      OWNER = "Farlot";
      WORLD = "Rage";
      MOTD = "Motd's are dumb";
    };
  };
}
