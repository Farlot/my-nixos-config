{ lib, pkgs }:

pkgs.ckb-next.overrideAttrs (oldAttrs: rec {
  src = pkgs.fetchgit {
    url = "https://github.com/ckb-next/ckb-next";
    rev = "95ab0d9beab0d0149e9d0b0b628ac1dd9c5ae9d9";  # Commit hash from the PR
    sha256 = "14dmdbvajqz9g6y91w1s7wwhd5h3bmkg4z48ay9zcczhjrlzzmxz";  # Correct hash
  };
})
