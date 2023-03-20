setopt nobanghist

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

autoload -Uz vcs_info

export GPG_TTY=$TTY

ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_AUTOSTART_ONCE=false
ZSH_TMUX_AUTOCONNECT=true
