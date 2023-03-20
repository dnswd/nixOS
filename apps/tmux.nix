{ config, lib, pkgs, ... }: {

  programs.tmux = {
    enable = true;
    terminal = "xterm-kitty";
    shell = "${lib.getExe pkgs.zsh}";
    sensibleOnTop = true;
    extraConfig = ''
      # Server variables
      set-option -g status "on"
      color_status_text="colour245"
      color_window_off_status_bg="colour238"
      color_light="white" #colour015
      color_dark="colour232" # black= colour232
      color_window_off_status_current_bg="colour254"
    '';
  };
}
