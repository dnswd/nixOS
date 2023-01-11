{ pkgs, lib, ... }: {
  xsession = {
    enable = true;
    initExtra = ''
      # Kitty theme
      kitty +kitten themes --reload-in=all --config-file-name ~/.config/kitty/mytheme.conf Mydark

      # Direnv
      eval "$(direnv hook zsh)"
    '';
  };
  home.pointerCursor = {
    name = "capitaine-cursors-white";
    package = pkgs.capitaine-cursors;
    size = 30;
    x11.enable = true;
  };
}
