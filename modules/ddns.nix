{ config, pkgs, ... }:

{


    systemd.services.domeneshop-dyndns = {
        # This service will run your update script
        description = "Domeneshop Dynamic DNS Updater";

        # Use a timer to run this regularly, e.g., every 5 minutes
        wantedBy = [ "timers.target" ];

        # The actual command to execute
        script = ''
        TOKEN=$(cat ${config.sops.secrets."domeneshop/token".path})
        SECRET=$(cat ${config.sops.secrets."domeneshop/secret".path})

        # 3. Get the current external IP
        IP=$(${pkgs.curl}/bin/curl -q ifconfig.me)

        # 4. Run the update command
        ${pkgs.curl}/bin/curl --silent "https://$TOKEN:$SECRET@api.domeneshop.no/v0/dyndns/update?hostname=farlot.no&myip=$IP"
        '';

        # Ensure yq and curl are available in the service environment
        path = [ pkgs.curl ];
    };

    # 3. Define the Timer (Runs the service every 5 minutes)
    systemd.timers.domeneshop-dyndns = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
        # Use an arbitrary time to start, then repeat every 5 minutes
        OnBootSec = "30s";
        OnUnitActiveSec = "5m";
        Unit = "domeneshop-dyndns.service";
        };
    };


}
