{ config, pkgs, lib, my, ... }: {
  programs.kitty = {
    enable = true;
    font.name = "mono";
    font.size = 12;
    settings = {
      confirm_os_window_close = 0;
      enable_audio_bell = false;
      allow_remote_control = true;
      window_padding_width = "16";
      background_opacity = "0.8";
      include = "mytheme.conf";
      cursor_text_color = "background";
    };
  };
    xdg.configFile."kitty/themes/mydark.conf".text = ''
    # mydark theme
    background #0b1c2d
    foreground #f9fcff
    cursor #64aef8
    url_color #64aef8
    # black
    color0 #0b1c2d
    color8 #6b7784
    # red
    color1 #f5615d
    color9 #fa7c75
    # green
    color2 #51c672
    color10 #82df97
    # yellow
    color3 #f3be73
    color11 #fad199
    # blue
    color4 #4da0f0
    color12 #7cbcfc
    # magenta
    color5 #8f86f2
    color13 #9d98f7
    # cyan
    color6 #30c39c
    color14 #64deb8
    # white
    color7 #dde4ec
    color15 #f9fcff
  '';
  xdg.configFile."kitty/themes/mylight.conf".text = ''
    # mylight theme
    background #f9fcff
    foreground #0b1c2d
    cursor #3992e5
    url_color #3992e5
    # black
    color0 #0b1c2d
    color8 #54616e
    # red
    color1 #dd2f35
    color9 #eb4747
    # green
    color2 #38a95b
    color10 #51c672
    # yellow
    color3 #dc9c32
    color11 #e9ac50
    # blue
    color4 #2885d7
    color12 #4da0f0
    # magenta
    color5 #7364e0
    color13 #8175eb
    # cyan
    color6 #30c39c
    color14 #30c39c
    # white
    color7 #0b1c2d
    color15 #54616e
  '';
}
