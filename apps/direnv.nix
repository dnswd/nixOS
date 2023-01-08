{ pkgs, ... }:

{
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.direnv.nix-direnv.enableFlakes = true;

  programs.zsh.enable = true;

  nix.extraOptions = ''
  keep-outputs = true
  keep-derivations = true
  ''
}