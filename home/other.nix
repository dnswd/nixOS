{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # sysadmin stuff
    unstable.busybox
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
    zoom-us

    # theming
    fontforge-gtk
    dconf

    # mac apps
    darling
    darling-dmg

    # ricing stuffs
    xorg.xev
    xdo # for devour
    xdotool
    xclip
    service-wrapper
  ];
}
