{ config, pkgs, ... }:

{
  # Define the secret file format
  sops.secrets.cf_api_key = {};
  sops.secrets.mc_server_pass = {};
  sops.templates."minecraft-env" = {
    content = ''
      CF_API_KEY=${config.sops.placeholder.cf_api_key}
      RCON_PASSWORD=${config.sops.placeholder.mc_server_pass}
    '';
    mode = "0400";
  };

  virtualisation.oci-containers.containers.minecraft-atmons = {
    image = "docker.io/itzg/minecraft-server:java21";
    autoStart = true;
    ports = [ "25565:25565" ];
    volumes = [ "/mnt/stuff/DockerStuff/minecraft-atmons:/data" ];
    
    # Point the container to the decrypted sops file
    environmentFiles = [
      config.sops.templates."minecraft-env".path
    ];

    environment = {
      EULA = "TRUE";
      TYPE = "AUTO_CURSEFORGE";
      CF_SLUG = "all-the-mons";
      MEMORY = "6G";
    };
  };
}
