{ config, pkgs, ... }:

{
  virtualisation.oci-containers.containers.empyrion = {
    image = "docker.io/bitr/empyrion-server:latest";
    #pull = "always";
    ports = [ "30000:30000/udp" "30001:30001/udp" "30001:30001/tcp" ]; # Adjust as needed
    volumes = [
      "/mnt/stuff/DockerStuff/empyrion/server:/home/user/Steam"
      "/mnt/stuff/DockerStuff/empyrion/saves:/home/user/Steam/steamapps/common/Empyrion\ -\ Dedicated\ Server/Saves"
    ];
  };
}
