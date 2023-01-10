{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    # sysadmin stuff
    busybox
    bind

    # dev
    pkgs.vscode-fhs
    pkgs.git
    pkgs.git-crypt

    # browser
    firefox

    # theming
    fontforge-gtk
  ];
}
