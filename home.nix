{ config, pkgs, inputs, ... }:

{
  imports = [
      inputs.stylix.homeModules.stylix
      inputs.nixvim.homeModules.nixvim
      inputs.sops-nix.homeManagerModules.sops
      ./modules/yazi.nix # filemanager
      ./modules/neovim.nix
      ./modules/scripts.nix
      ./modules/waybar.nix
      ./modules/rofi.nix
      ./modules/kitty.nix
    ];
  

  nixpkgs.config = {
    allowUnfree = true;
  };

  
  home.username = "maw";
  home.homeDirectory = "/home/maw";
  home.sessionVariables = {
     # EDITOR = "kate";
  };

  home.packages = with pkgs; [
    obsidian
    flameshot
    git
    teams-for-linux
    spotify
    protontricks
    mangohud
    goverlay
    xivlauncher
    lutris
    qbittorrent
    tldr
    itch
    wowup-cf
    qdirstat
    appimage-run
    gocryptfs # encrypt vault
    ouch
    vesktop
    prismlauncher # Minecraft Launcher
    google-chrome # browser
    flatpak # package
    umu-launcher # game
    obs-studio # streaming
    ydotool # Autohotkey ish
    rust-stakeholder # rust
    autorandr # monitor
    loupe # image
    keepassxc # password
    btop # process
    nh # game
    firefox # browser
    gimp # image
    pavucontrol # audio
    hyprshot # screenshot
    libnotify # notification
    kitty # terminal
    hyprpaper # wallpaper
    calcurse # calendar
    mpv # mediaplayer
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
  

  programs.zoxide = { # terminal navigation tool
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf.enable = true; # terminal navigation helper for zoxide


  programs.brave = {
    enable = true;
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
      "--disable-features=PasswordManagerOnboarding"
      "--disable-features=AutofillEnableAccountWalletStorage"
    ];
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
  };


  home.file.".config/nixpkgs/config.nix".text = ''
    {
      allowUnfree = true;
    }
  '';


  home.stateVersion = "24.05"; # Please read the comment before changing.
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
