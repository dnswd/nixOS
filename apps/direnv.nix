{ pkgs, ... }:

{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Avoid garbage collection
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';
}