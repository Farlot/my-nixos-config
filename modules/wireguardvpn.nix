{ config, pkgs, ... }:
#publicKey = "veLqpZazR9j/Ol2G8TfrO32yEhc1i543MCN8rpy1FBA=";
#privateKeyFile = config.sops.secrets.wgpriv.path;
#address = [ "10.71.233.75/32" ];
#dns = [ "10.64.0.1" ];
#endpoint = "185.204.1.203:51820";

{
    networking = {
    firewall.allowedUDPPorts = [ 51820 ];
    iproute2.rttablesExtraConfig = ''
      200 vpn
    '';

    # Wireguard client
    firewall.checkReversePath = false;
    wg-quick.interfaces.wg1 = {
      table = "vpn";
      address = [ "10.71.233.75/32" ];
      dns = [ "10.64.0.1" ];
      privateKeyFile = config.sops.secrets.wgpriv.path;
      peers = [
        {
          publicKey = "veLqpZazR9j/Ol2G8TfrO32yEhc1i543MCN8rpy1FBA=";
          allowedIPs = [ "0.0.0.0/0" ];
          endpoint = "185.204.1.203:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
