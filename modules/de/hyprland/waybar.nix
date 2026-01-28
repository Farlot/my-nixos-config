{ pkgs, config, ... }:

{
  programs.waybar = {
    enable = true;
    
    # Declarative JSON Config
    settings = [{
      layer = "top";
      position = "top";
      output = "DP-1"; # Matches your original config
      modules-left = [ "hyprland/workspaces" "custom/mc" ];
      modules-center = [ "clock" ];
      modules-right = [ "tray" "custom/ping" "cpu" "memory" "pulseaudio" ];

      "tray" = {
        icon-size = 16;
        spacing = 10;
      };

      "clock" = {
        format = "󰃭 {:%A, %B %d, %Y | %H:%M:%S}";
        tooltip-format = "󰃭 {:%A, %B %d, %Y | %H:%M:%S}";
        interval = 1;
        on-click = "kitty --hold calcurse";
      };

      "custom/ping" = {
        format = "{}";
        return-type = "json";
        exec = "waybar-ping"; # Using your new Nix-managed script
        interval = 10;
        on-click = "kitty --hold ping 8.8.8.8";
      };

      "custom/mc" = {
        format = "{}";
        return-type = "json";
        exec = "waybar-mc"; # The script we created above
        interval = 60;      # Check every 60 seconds
        on-click = "kitty --hold mcstatus localhost:25565 status";
      };

      "cpu" = {
        format = " {usage}%";
        on-click = "kitty --hold btop";
      };

      "memory" = {
        format = " {used} GB";
        on-click = "kitty --hold btop";
      };

      "pulseaudio" = {
        format = "󰓃 {volume}%";
        format-muted = " muted";
        on-click = "pavucontrol";
        # on-click-right = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
      };

      "hyprland/workspaces" = {
        all-outputs = true;
        disable-scroll = true;
      };
    }];

    # Declarative CSS
    style = ''
      * {
        font-family: JetBrainsMono Nerd Font, monospace;
        font-size: 14px;
        font-weight: bold;
        border: 1px;
        padding: 0;
        margin: 0;
        color: #fc2d5e;
      }

      window#waybar {
        background-color: rgba(40, 40, 40, 0.95);
        border-bottom: 3px solid #fc2d5e;
      }

      #workspaces button {
        margin: 0 4px;
        padding: 2px 6px;
        background-color: transparent;
      }

      #workspaces button.active { color: #02a332; }
      #workspaces button.urgent { color: #00a130; }

      #cpu, #memory, #pulseaudio, #tray, #custom-ping { 
        margin-right: 15px; 
      }

      /* Your new color-coded Ping classes */
      #custom-ping.good { color: #02a332; }
      #custom-ping.average { color: #e0af68; }
      #custom-ping.poor { color: #fc2d5e; }
      #custom-ping.critical { 
        color: #ffffff; 
        background-color: #ff0000; 
        border-radius: 4px;
        padding: 0 5px;
      }
      #custom-mc { margin-right: 15px; }
      #custom-mc.good { color: #02a332; }
      #custom-mc.critical { color: #fc2d5e; }
    '';
  };
}
