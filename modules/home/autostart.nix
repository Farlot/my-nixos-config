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


  # Flameshot autostart service
#  systemd.user.services.flameshot = {
#    Unit = {
#      Description = "Autostart Flameshot screenshot tool";
#      After = [ "graphical-session.target" ];
#    };
#
#    Service = {
#      ExecStart = "${pkgs.flameshot}/bin/flameshot";
#      Restart = "on-failure";
#      RestartSec = "5s";
#    };
#
#    Install = {
#      WantedBy = [ "default.target" ];
#    };
#  };

  systemd.user.startServices = true;
}
