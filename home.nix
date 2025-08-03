{ config, pkgs, ... }:

{
  nixpkgs.config = {
    allowUnfree = true;
  };

  home.username = "maw";
  home.homeDirectory = "/home/maw";


  home.packages = with pkgs; [
    #gimp
    obsidian
    neovim
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
    rcon
  ];

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




  programs.git = {
    enable = true;
    userName = "Farlot";  # Replace with your GitHub username
    userEmail = "m.waaagan@gmail.com";  # Replace with your GitHub email
    extraConfig = {
      safe.directory = [ "/mnt/stuff/nixos" ];
      # Ensure git uses SSH for GitHub instead of HTTPS
      url."git@github.com:".insteadOf = "https://github.com/";
    };
  };

  xdg.configFile = {
    "hypr" = { source = ./configs/hypr; recursive = true; };
    "kitty" = { source = ./configs/kitty; recursive = true; };
    "rofi" = { source = ./configs/rofi; recursive = true; };
    "waybar" = { source = ./configs/waybar; recursive = true; };
    "waybar/btcprice.sh" = { source = ./configs/waybar/btcprice.sh; executable = true; };
    #"mako" = { source = ./configs/mako; recursive = true; };
  };




  # Ensure the SSH key is placed in the right location using home-manager
  # home.file.".ssh/github".source = "/path/to/your/github/key";  # Replace this with the full path to your private key


  home.file = {

  };
  home.file.".config/nixpkgs/config.nix".text = ''
    {
      allowUnfree = true;
    }
  '';


  imports = [
      #./modules/home/autostart.nix  # Import the autostart file
    ];


  home.sessionVariables = {
     EDITOR = "kate";
  };

  home.stateVersion = "24.05"; # Please read the comment before changing.
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
