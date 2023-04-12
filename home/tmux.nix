{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.tmux = {
    enable = true;
    terminal = "xterm-kitty";
    shell = "${lib.getExe pkgs.zsh}";
    # sensibleOnTop = true;
    prefix = "C-b";
    keyMode = "vi";
    historyLimit = 10000;
    baseIndex = 1;
    escapeTime = 1;
    extraConfig = ''
      # split panes using | and -, make sure they open in the same path
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      unbind '"'
      unbind %

      # open new windows in the current path
      bind c new-window -c "#{pane_current_path}"
      bind s new-session

      # reload config file
      bind r source-file ~/.config/tmux/tmux.conf
      unbind p
      bind p previous-window

      # vim key to switch window and session
      bind -r j previous-window
      bind -r k next-window
      bind -r h switch-client -p
      bind -r l switch-client -n

      # vim key to move pane
      bind -r K select-pane -U
      bind -r J select-pane -D
      bind -r H select-pane -R
      bind -r L select-pane -L

      # resize pane
      bind -r C-k resize-pane -U 5
      bind -r C-j resize-pane -D 5
      bind -r C-h resize-pane -L 5
      bind -r C-l resize-pane -R 5
      set -g mouse on

      # don't rename windows automatically
      set -g allow-rename off

      # for server
      #Variables
      color_status_text="colour245"
      color_window_off_status_bg="colour238"
      color_light="white" #colour015
      color_dark="colour232" # black= colour232
      color_window_off_status_current_bg="colour254"

      bind -T root F12  \
        set prefix None \;\
        set key-table off \;\
        set status-style "fg=$color_status_text,bg=$color_window_off_status_bg" \;\
        set window-status-current-format "#[fg=$color_window_off_status_bg,bg=$color_window_off_status_current_bg]$separator_powerline_right#[default] #I:#W# #[fg=$color_window_off_status_current_bg,bg=$color_window_off_status_bg]$separator_powerline_right#[default]" \;\
        set window-status-current-style "fg=$color_dark,bold,bg=$color_window_off_status_current_bg" \;\
        if -F '#{pane_in_mode}' 'send-keys -X cancel' \;\
        refresh-client -S \;\

      bind -T off F12 \
        set -u prefix \;\
        set -u key-table \;\
        set -u status-style \;\
        set -u window-status-current-style \;\
        set -u window-status-current-format \;\
        refresh-client -S

      wg_is_keys_off="#[fg=$color_light,bg=$color_window_off_indicator]#([ $(tmux show-option -qv key-table) = 'off' ] && echo 'OFF')#[default]"

      # status line
      set -g status-interval 1
      set -g status-style fg=white,bold,bg=default
      set -g window-status-style bg=color0
      set -g window-status-format " #W "
      set -g window-status-current-format " #W "
      set -g status-right-style fg=color0,bold,bg=color4
      set -g status-right " %d %b #[bg=color15,fg=color0] %H:%M "
    '';
  };
}
