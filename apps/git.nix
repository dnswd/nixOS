{ config, pkgs, lib, ... }: {
  programs.git = {
    enable = true;
    userName = "Dennis Al Baihaqi Walangadi";
    userEmail = "dennis.walangadi@gmail.com";
    extraConfig = {
      core = {
        editor = "nvim";
        autocrlf = "input";
      };
      # Force SSH on GitHub
      url."git@github.com:".insteadOf = "https://github.com/";
      #Pull request stuffs
      pull = {
        ff = "only";
        rebase = false;
      };
      diff.algorithm = "histogram";
    };
    delta.enable = true;
  };
}
