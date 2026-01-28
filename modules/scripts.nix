{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "comfy-vault"; # Open vault for use with ComfyUI
      runtimeInputs = [ pkgs.gocryptfs pkgs.libnotify pkgs.util-linux ];
      text = ''
        # 1. Check if mounted
        if ! mountpoint -q "/mnt/spin/vault"; then
          echo "🔐 Vault is locked. Please enter password to mount..."
          notify-send "Vault" "Mounting required for ComfyUI"

          # This will prompt for password in the current terminal
          if ! gocryptfs "/mnt/spin/.vault_encrypted" "/mnt/spin/vault"; then
            echo "❌ Failed to mount vault. Exiting."
            exit 1
          fi
        fi

        # 2. Check if the specific data directory exists inside the vault
        if [ ! -d "/mnt/spin/vault/comfyuidata" ]; then
          echo "⚠️ Warning: Data directory not found at /mnt/spin/vault/comfyuidata"
          echo "Creating it now..."
          mkdir -p "/mnt/spin/vault/comfyuidata"
        fi

        # 3. Symlink models
        MODELS_DIR="/mnt/spin/vault/stablediff/models"
        TARGET_DIR="/mnt/spin/vault/comfyuidata/models/checkpoints"

        mkdir -p "$MODELS_DIR"
        if [ ! -L "$TARGET_DIR" ]; then
          rm -rf "$TARGET_DIR" # Remove directory if it's not a link
          ln -s "$MODELS_DIR" "$TARGET_DIR"
        fi

        # 4. Launch ComfyUI
        echo "🚀 Launching ComfyUI..."
        comfy-ui --base-directory "/mnt/spin/vault/comfyuidata"
        '';
        })
        (pkgs.writeShellApplication {
        name = "webui-vault"; # Open vault for use with WebUI
        runtimeInputs = [ pkgs.gocryptfs pkgs.libnotify pkgs.util-linux ];
        text = ''
        # 1. Check if mounted
        if ! mountpoint -q "/mnt/spin/vault"; then
          echo "🔐 Vault is locked. Please enter password to mount..."
          notify-send "Vault" "Mounting required for SD-WebUI"

          if ! gocryptfs "/mnt/spin/.vault_encrypted" "/mnt/spin/vault"; then
            echo "❌ Failed to mount vault. Exiting."
            exit 1
          fi
        fi

        # 2. Check/Create data directory
        if [ ! -d "/mnt/spin/vault/webuidata" ]; then
          echo "Creating data directory at /mnt/spin/vault/webuidata..."
          mkdir -p "/mnt/spin/vault/webuidata"
        fi

        # 3. Symlink models
        MODELS_DIR="/mnt/spin/vault/stablediff/models"
        TARGET_DIR="/mnt/spin/vault/webuidata/models/Stable-diffusion"

        mkdir -p "$MODELS_DIR"
        if [ ! -L "$TARGET_DIR" ]; then
          rm -rf "$TARGET_DIR" # Remove directory if it's not a link
          ln -s "$MODELS_DIR" "$TARGET_DIR"
        fi

        # 3. Launch WebUI
        echo "🚀 Launching Stable Diffusion WebUI..."
        stable-diffusion-webui --data-dir "/mnt/spin/vault/webuidata"
        '';
        })
        # Ping waybar Script
        (pkgs.writeShellApplication {
        name = "waybar-ping";
        runtimeInputs = [ pkgs.iputils pkgs.bc pkgs.gnugrep pkgs.gawk ];
        text = ''
        # Ping 3 times, wait 1s between pings
        # We capture the output and check the exit status
        PING_OUT=$(ping -c 3 -W 1 8.8.8.8 2>/dev/null || true)

        # Extract Average Latency
        AVG_LATENCY=$(echo "$PING_OUT" | tail -1 | awk -F'/' '{print $5}')

        # If AVG_LATENCY is empty, it means no packets returned a round-trip time
        if [ -z "$AVG_LATENCY" ]; then
          echo '{"text": "󰈂 Down", "tooltip": "No connection to 8.8.8.8", "class": "down"}'
        else
          # Extract Packet Loss %
          LOSS=$(echo "$PING_OUT" | grep "packet loss" | awk -F'%' '{print $1}' | awk '{print $NF}')

          # Round the latency
          ROUNDED_LATENCY=$(echo "''${AVG_LATENCY}" | awk '{print int($1 + 0.5)}')

          TEXT="󰓅 ''${ROUNDED_LATENCY}ms | ''${LOSS}%"

          # Logic for CSS classes
          if [ "''${LOSS}" -eq 100 ]; then
            CLASS="down"
          elif [ "''${LOSS}" -gt 20 ]; then
            CLASS="critical"
          elif [ "''${LOSS}" -gt 0 ] || (( $(echo "''${AVG_LATENCY} > 150" | bc -l) )); then
            CLASS="poor"
          elif (( $(echo "''${AVG_LATENCY} > 60" | bc -l) )); then
            CLASS="average"
          else
            CLASS="good"
          fi

          printf '{"text": "%s", "tooltip": "Latency: %sms\\nLoss: %s%%", "class": "%s"}\n' "''${TEXT}" "''${AVG_LATENCY}" "''${LOSS}" "''${CLASS}"
        fi
        '';
        })
        # Minecraft Waybar script
        (pkgs.writeShellApplication {
        name = "waybar-mc";
        runtimeInputs = [ pkgs.jq pkgs.mcstatus ];
        text = ''
        # Get status using the syntax that works for you
        DATA=$(mcstatus localhost json 2>/dev/null || true)

        # Check if we got data and if .online is true
        IS_ONLINE=$(echo "$DATA" | jq -r '.online')

        if [ "$IS_ONLINE" = "true" ]; then
          # Extract counts from the nested .status.players object
          ONLINE=$(echo "$DATA" | jq -r '.status.players.online')
          MAX=$(echo "$DATA" | jq -r '.status.players.max')

          # Handle the "sample" field being null when nobody is online
          PLAYERS=$(echo "$DATA" | jq -r '.status.players.sample | if . == null then "No players online" else (map(.name) | join(", ")) end')

          printf '{"text": "⛏ %s/%s", "tooltip": "%s", "class": "good"}\n' "$ONLINE" "$MAX" "$PLAYERS"
        else
          printf '{"text": "⛏ Offline", "tooltip": "Server unreachable", "class": "critical"}\n'
        fi
        '';
        })
  ];
}
