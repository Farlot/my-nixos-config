# autostart.nix

{ config, pkgs, ... }:

{
  # Steam Autostart
  systemd.user.services.steam = {
    Unit = {
      Description = "Open Steam in the background at boot";
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.steam}/bin/steam -nochatui -nofriendsui -silent %U";
      Restart = "on-failure";
      RestartSec = "5s";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # Discord Autostart
  systemd.user.services.discord = {
    Unit = {
      Description = "Open Discord in the background at boot";
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.discord}/bin/Discord";
      Restart = "on-failure";
      RestartSec = "5s";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };


  systemd.user.startServices = true;
}
