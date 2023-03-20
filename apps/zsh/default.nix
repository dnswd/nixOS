{ config, pkgs, lib, ... }: {

  imports = [
    ./starship.nix
  ];

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    enableCompletion = true;
    autocd = true;
    defaultKeymap = "viins";
    dotDir = ".config/zsh";
    initExtraFirst = builtins.readFile ./initExtraFirst.zsh;
    initExtra = builtins.readFile ./initExtra.zsh;

    history = {
      ignoreDups = true;
      ignoreSpace = true;
      path = "$ZDOTDIR/.history";
      share = true;
    };

    shellAliases = {
      # cat = "bat";
      # e = ''devour emacsclient -c -a \"\"'';
      # qrclip = "xclip -o | qrencode -t utf8";
      clear = ''printf "\033[2J\033[3J\033[1;1H"'';
      # lutris = "WEBKIT_DISABLE_COMPOSITING_MODE=1 lutris";
      # neofetch = "fix_neofetch";
    };
    
    zplug = {
      enable = true;
      plugins = [
        { name = "plugins/tmux"; tags = [ from:oh-my-zsh ]; }
        { name = "plugins/history"; tags = [ from:oh-my-zsh ]; }
        { name = "plugins/history-substring-search"; tags = [ from:oh-my-zsh ]; }
        { name = "plugins/colored-man-pages"; tags = [ from:oh-my-zsh ]; }
      ];
    };

    plugins = [
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "5eb494852ebb99cf5c2c2bffee6b74e6f1bf38d0";
          sha256 = "8gyZe6OPVLMdfruHJAHcyYeuiyvMTLvuX1UnUOv8eg8=";
        };
      }
    ];
  };
}