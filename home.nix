{ config, pkgs, inputs, ... }:

{
  imports = [
      inputs.stylix.homeModules.stylix
      inputs.nixvim.homeModules.nixvim
      inputs.sops-nix.homeManagerModules.sops
      ./modules/stylix.nix
      ./modules/yazi.nix # filemanager
      ./modules/neovim.nix
      ./modules/scripts.nix
      ./modules/kitty.nix
      ./modules/de/hyprland
    ];
  

  nixpkgs.config = {
    allowUnfree = true;
  };

  
  home.username = "maw";
  home.homeDirectory = "/home/maw";
  home.sessionVariables = {
     EDITOR = "nvim";
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
    gimp # image
    pavucontrol # audio
    hyprshot # screenshot
    libnotify # notification
    kitty # terminal
    calcurse # calendar
    mpv # mediaplayer
  ];
  

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


  home.file.".config/nixpkgs/config.nix".text = ''
    {
      allowUnfree = true;
    }
  '';


  home.stateVersion = "24.05"; # Please read the comment before changing.
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
