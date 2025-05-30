{ lib, pkgs }:

pkgs.ckb-next.overrideAttrs (oldAttrs: rec {
  src = pkgs.fetchgit {
    url = "https://github.com/ckb-next/ckb-next";
    rev = "677749020edb3272d379c103c956b6933a59fbb5";  # Commit hash from the PR
    sha256 = "1aas7i79gfd9aab31m7sgzfmq0kznp3035ml8jn73vrzzifb28dp";  # Correct hash
  };
})
