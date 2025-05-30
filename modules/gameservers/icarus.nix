{ config, pkgs, ... }:

{
  virtualisation.oci-containers.containers.icarus = {
    image = "mastermnb/icarus-dedicated-server:latest";
    ports = [ "17777:17777/udp" "27015:27015/udp" ];
    volumes = [
      "/mnt/stuff/DockerStuff/icarus/data:/home/container/icarus/drive_c/icarus"
      "/mnt/stuff/DockerStuff/icarus/game:/home/container/game/icarus"
    ];
    environment = {
      ASYNC_TIMEOUT = "60";
      BRANCH = "public";
      AUTOUPDATE = "1";
      SERVERNAME = "Rageaura";
      SERVER_PORT = "17777";
      QUERY_PORT = "27015";
      JOIN_PASSWORD = "kaoi";
      MAX_PLAYERS = "5";
      ADMIN_PASSWORD = "smallpp";
    };
  };
}
