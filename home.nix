{ config, pkgs, inputs, ... }:

{
  nixpkgs.config = {
    allowUnfree = true;
  };

  home.username = "maw";
  home.homeDirectory = "/home/maw";


  home.packages = with pkgs; [
    #gimp
    obsidian
    flameshot
    git
    teams-for-linux
    wineWowPackages.stagingFull
    winetricks
    spotify
    protontricks
    mangohud
    goverlay
    xivlauncher
    lutris
    qbittorrent
    vlc
    z-lua
    ranger
    tldr
    itch
    wowup-cf
    qdirstat
    appimage-run
    gocryptfs # encrypt vault
    ollama
    ouch
    #oterm
    # Custom shell stuff:
    (writeShellApplication {
      name = "comfy-vault";
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
    (writeShellApplication {
      name = "webui-vault";
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
  ];



  programs.rofi = {
    enable = true;
    plugins = [
      pkgs.rofi-calc
    ];
  };

  programs.brave = {
    enable = true;
    #package = pkgs.brave;
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
      { id = "oboonakemofpalcgghocfoadofidjkkk"; } # KeePassXC
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark Reader
      { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # SponsorBlock
      { id = "mmnhjecbajmgkapcinkhdnjabclcnfpg"; } # Reddit Promoted Ad Blocker
      { id = "omoinegiohhgbikclijaniebjpkeopip"; } # Clickbait Remover Youtube
      { id = "gebbhagfogifgggkldgodflihgfeippi"; } # Return YouTube Dislike
      { id = "kbmfpngjjgdllneeigpgjifpgocmfgmb"; } # Reddit Enhancement Suite
      { id = "fchmanciglollaagnijpcagpofejennb"; } # Twitch Channel Point Auto Claimer
      { id = "ammjkodgmmoknidbanneddgankgfejfh"; } # 7TV
      #{ id = "ajopnjidmegmdimjlfnijceegpefgped"; } # BetterTTV
      ];
    commandLineArgs = [
      #"--disable-features=WebRtcAllowInputVolumeAdjustment"
      "--disable-features=PasswordManagerOnboarding"
      "--disable-features=AutofillEnableAccountWalletStorage"
    ];
  };

  # Define default applications using xdg.mimeApps
  xdg.mimeApps = {
    enable = true; # Ensures the necessary services are active
    defaultApplications = {
      "inode/directory" = [ "org.kde.dolphin.desktop" ];
      "image/jpeg" = [ "org.kde.gwenview.desktop" ];
      "image/png" = [ "org.kde.gwenview.desktop" ];
      "image/gif" = [ "org.kde.gwenview.desktop" ];
      "image/bmp" = [ "org.kde.gwenview.desktop" ];
      "image/webp" = [ "org.kde.gwenview.desktop" ];
      "image/svg+xml" = [ "org.kde.gwenview.desktop" ];
    };
  };


  programs.git = {
    enable = true;
    settings = {
      user.name = "Farlot";  # Replace with your GitHub username
      user.email = "m.waaagan@gmail.com";  # Replace with your GitHub email
      safe.directory = [ "/mnt/stuff/nixos" ];
      # Ensure git uses SSH for GitHub instead of HTTPS
      url."git@github.com:".insteadOf = "https://github.com/";
    };
  };

  # Notification handler mako
  services.mako = {
    enable = true;
    settings = {
      anchor = "top-left";
      background-color = "#1e1e2e"; # Catppuccin Mocha Base
      text-color = "#cdd6f4";
      border-color = "#89b4fa";
      border-radius = 5;
      border-size = 2;
      default-timeout = 5000; # 5 seconds
      layer = "overlay";     # Ensures it shows above windows
    };
  };

  # Bashfix for scripts
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      v-up = "gocryptfs /mnt/spin/.vault_encrypted /mnt/spin/vault";
      v-down = "fusermount -u /mnt/spin/vault";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "docker" ];
      theme = "robbyrussell"; # or "agnoster", "powerlevel10k", etc.
    };
  };
  #programs.bash.enable = false;
  #programs.bash.shellAliases = {
  #  v-up = "gocryptfs /mnt/spin/.vault_encrypted /mnt/spin/vault";
  #  v-down = "fusermount -u /mnt/spin/vault";
  #};

  xdg.configFile = {
    "hypr" = { source = ./configs/hypr; recursive = true; };
    "kitty" = { source = ./configs/kitty; recursive = true; };
    "rofi" = { source = ./configs/rofi; recursive = true; };
    "waybar" = { source = ./configs/waybar; recursive = true; };
    #"waybar/btcprice.sh" = { source = ./configs/waybar/btcprice.sh; executable = true; };
    #"mako" = { source = ./configs/mako; recursive = true; };
  };
  home.file = {
    ".local/share/rofi/themes" = { source = ./configs/rofitheme/themes; recursive = true;};
  };


  services.hypridle = {
    enable = true;
    settings = {
      general = {
        # Optional: command to run when locking (if you want to use your hyprlock config)
        lock_cmd = "pidof hyprlock || hyprlock";
        # Command to run before sleep (suspend)
        before_sleep_cmd = "loginctl lock-session";
        # Command to run after waking up
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        # 30 Minutes (1800 seconds) - Turn off screen
        {
          timeout = 1800;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }

        # Optional: Lock screen after 30 mins (or slightly before/after)
        # Since you already have hyprlock configured, you might want this:
        {
          timeout = 1800;
          on-timeout = "loginctl lock-session";
        }
      ];
    };
  };


  home.file.".config/nixpkgs/config.nix".text = ''
    {
      allowUnfree = true;
    }
  '';


  imports = [
      ./modules/yazi.nix # filemanager
      inputs.nixvim.homeManagerModules.nixvim
      ./modules/neovim.nix
      #./modules/home/autostart.nix  # Import the autostart file
      #./modules/waybar.nix
    ];


  home.sessionVariables = {
     # EDITOR = "kate";
  };

  home.stateVersion = "24.05"; # Please read the comment before changing.
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
