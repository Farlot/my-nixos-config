{ config, pkgs, ... }:

{
  nixpkgs.config = {
    allowUnfree = true;
  };

  home.username = "maw";
  home.homeDirectory = "/home/maw";


  home.packages = [
    pkgs.gimp
    pkgs.obsidian
    pkgs.neovim
    pkgs.flameshot
    pkgs.git
    pkgs.teams-for-linux
    pkgs.wineWowPackages.full
    pkgs.winetricks
    pkgs.spotify
    pkgs.protontricks
    pkgs.mangohud
    pkgs.xivlauncher
    pkgs.transmission_4
    pkgs.vlc
    pkgs.z-lua
    pkgs.ranger
    pkgs.tldr
    #pkgs.librewolf

  ];

  programs.git = {
    enable = true;
    userName = "Farlot";  # Replace with your GitHub username
    userEmail = "m.waaagan@gmail.com";  # Replace with your GitHub email
    #extraConfig = {
    #  # Ensure git uses SSH for GitHub instead of HTTPS
    #  url."git@github.com:".insteadOf = "https://github.com/";
    #};
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
      ./modules/home/autostart.nix  # Import the autostart file
    ];


  home.sessionVariables = {
     EDITOR = "kate";
  };

  home.stateVersion = "24.05"; # Please read the comment before changing.
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
