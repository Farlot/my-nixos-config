{ config, pkgs, lib, inputs, ... }:

{

  # Serverpassword
  # PASSWORD = "$(cat ${config.sops.secrets."serverpass".path})";
  sops.secrets.serverpass = {};

  imports =
    [
      #./empyrion.nix
      #./foundry.nix
      #./avorion.nix
      #./factorio.nix
      #./abiotic.nix
      #./icarus.nix
      #./soulmask.nix
      #./ss14.nix
      #./necesse.nix
      #./vintagestory.nix
      #./vintagestorykaoi.nix
    ];
}
