{ config, pkgs, inputs, ... }:

{
  nixpkgs.config = {
    allowUnfree = true;
  };

  home.username = "maw";
  home.homeDirectory = "/home/maw";


  home.packages = with pkgs; [
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
    tldr
    itch
    wowup-cf
    qdirstat
    appimage-run
    gocryptfs # encrypt vault
    ollama
    ouch
    vesktop
    webcord
    #oterm # Broken AI terminnal tool ?
    
  ];


  stylix = {
    enable = true;
    targets = {
      qt.enable = true;
      kde.enable = true;
      gtk.enable = true;
    };
    image = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/wallpapers/nix-wallpaper-nineish-dark-gray.png";
      sha256 = "07zl1dlxqh9dav9pibnhr2x1llywwnyphmzcdqaby7dz5js184ly";
    };
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
    polarity = "dark";

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
    };
  };

  # qt = {
  #   enable = true;
  #   platformTheme.name = "gtk";
  #   style.name = "adwaita-dark"; # Fallback style
  # };

  # # 2. Set a Dark GTK Theme (Prism Launcher will pick this up)
  # gtk = {
  #   enable = true;
  #   theme = {
  #     # Matches your Neovim/Rofi aesthetic
  #     name = "Tokyonight-Dark"; 
  #     package = pkgs.tokyonight-gtk-theme;
  #   };
  #   
  #   # Optional: Match icons/cursor
  #   iconTheme = {
  #     name = "Papirus-Dark";
  #     package = pkgs.papirus-icon-theme;
  #   };
  #   
  #   cursorTheme = {
  #     name = "Bibata-Modern-Ice";
  #     package = pkgs.bibata-cursors;
  #   };
  # };
  

  programs.zoxide = { # terminal navigation tool
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf.enable = true; # terminal navigation helper for zoxide


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
      "inode/directory" = [ "yazi.desktop" ];
      "image/jpeg" = [ "org.kde.gwenview.desktop" ];
      "image/png" = [ "org.kde.gwenview.desktop" ];
      "image/gif" = [ "org.kde.gwenview.desktop" ];
      "image/bmp" = [ "org.kde.gwenview.desktop" ];
      "image/webp" = [ "org.kde.gwenview.desktop" ];
      "image/svg+xml" = [ "org.kde.gwenview.desktop" ];
    };
  };


  sops = {
  defaultSopsFile = ./secrets/secrets.yaml;
  defaultSopsFormat = "yaml";
  age.keyFile = "/home/maw/.config/sops/age/keys.txt"; # Matches your system config

  secrets.git_name = {};
  secrets.git_email = {};

  # Create a file that looks like a git config
  templates."git-config" = {
    content = ''
      [user]
        name = ${config.sops.placeholder.git_name}
        email = ${config.sops.placeholder.git_email}
    '';
  };
  };


  programs.git = {
    enable = true;
    includes = [
        { path = config.sops.templates."git-config".path; }
    ];

    settings = {
      safe.directory = [ "/mnt/stuff/nixos" ];
      url."git@github.com:".insteadOf = "https://github.com/";

    };
  };

  # Notification handler mako
  services.mako = {
    enable = true;
    settings = {
      anchor = "top-left";
      border-radius = 5;
      border-size = 2;
      default-timeout = 5000; # 5 seconds
      layer = "overlay";
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

  xdg.configFile = {
    "hypr" = { source = ./configs/hypr; recursive = true; };
    #"rofi" = { source = ./configs/rofi; recursive = true; };
  };
  # home.file = {
  #   ".local/share/rofi/themes" = { source = ./configs/rofitheme/themes; recursive = true;};
  # };


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
        ignore_dbus_inhibit = true;
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
          timeout = 1750;
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
      inputs.stylix.homeModules.stylix
      ./modules/yazi.nix # filemanager
      inputs.nixvim.homeModules.nixvim
      inputs.sops-nix.homeManagerModules.sops
      ./modules/neovim.nix
      ./modules/scripts.nix
      ./modules/waybar.nix
      ./modules/rofi.nix
      ./modules/kitty.nix
    ];


  home.sessionVariables = {
     # EDITOR = "kate";
  };

  home.stateVersion = "24.05"; # Please read the comment before changing.
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
