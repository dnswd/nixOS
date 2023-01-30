{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    # sysadmin stuff
    busybox
    bind

    # dev
    git
    git-crypt

    # work
    slack
    obsidian
    jetbrains.idea-ultimate
    postman
    dbeaver

    # browser
    firefox

    # theming
    fontforge-gtk

    # ricing stuffs
    xorg.xev
    xdo # for devour
    xdotool
    xclip
    service-wrapper
  ];
}
