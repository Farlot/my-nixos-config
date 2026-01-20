{ pkgs, inputs, ... }:

{
  nixflix = {
    enable = true;
    mediaDir = "/mnt/spin/nixflix/media";
    stateDir = "/mnt/spin/nixflix/.state";

    nginx.enable = true;
    postgres.enable = true;

    sonarr = {
      enable = true;
      config = {
        apiKeyPath = config.sops.secrets."sonarr/api_key".path;
        hostConfig.passwordPath = config.sops.secrets."sonarr/password".path;
      };
    };

    radarr = {
      enable = true;
      config = {
        apiKeyPath = config.sops.secrets."radarr/api_key".path;
        hostConfig.passwordPath = config.sops.secrets."radarr/password".path;
      };
    };

    prowlarr = {
      enable = true;
      config = {
        apiKeyPath = config.sops.secrets."prowlarr/api_key".path;
        hostConfig.passwordPath = config.sops.secrets."prowlarr/password".path;
      };
    };

    sabnzbd = {
      enable = true;
      settings = {
        misc.api_key = {_secret = config.sops.secrets."sabnzbd/api_key".path;};
      };
    };

    jellyfin = {
      enable = true;
      users.admin = {
        policy.isAdministrator = true;
        passwordFile = config.sops.secrets."jellyfin/admin_password".path;
      };
    };
  };
}
