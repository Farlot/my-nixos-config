{ config, pkgs, inputs, ... }:

{
    # Automatic updates
    system.autoUpgrade = {
        enable = true;
        dates = "05:00";
        flake = inputs.self.outPath;
        flags = [
            "--update-input"
            "nixpkgs"
            "-L"
            "--recreate-lock-file"
            "--commit-lock-file"
        ];
        randomizedDelaySec = "45min";
    };

    # Garbage collection
    nix.gc = {
        automatic = true;
        dates = "02:00";
        options = "--delete-older-than 10d";
    };

    # Nix store Optimize
    nix.optimise = {
        automatic = true;
        dates = [ "04:00" ];
        };
}
