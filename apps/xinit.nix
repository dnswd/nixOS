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
}
