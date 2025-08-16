{ config, pkgs, lib, inputs, ... }:

{
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
    ];
}
