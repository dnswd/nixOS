{ pkgs, lib, ... }: {
  xsession = {
    enable = true;
    initExtra = ''
      kitty +kitten themes --reload-in=all --config-file-name ~/.config/kitty/mytheme.conf Mylight
    '';
  };
}