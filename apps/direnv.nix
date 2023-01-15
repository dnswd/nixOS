{ pkgs, ... }:

{
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  # programs.direnv.nix-direnv.enableFlakes = true; # now always enabled, disable this option

  programs.zsh.enable = true;

  # Avoid garbage collection
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';
}