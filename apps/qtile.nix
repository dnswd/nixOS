{ inputs, pkgs, config, lib, ... }:

{
  # Qtile custom module are sourced from:
  # https://github.com/addy419/configurations/blob/1d3a91dc6645c7785f432b41b862e46beccbb1db/modules/desktop/qtile.nix

  home.packages = with pkgs; [
    qtile
  ];

  xsession = {
    enable = true;
    windowManager.qtile = {
      enable = true;
      keybindings = {

        # Basic
        "mod + mod1 + r" = "lazy.restart()";
        "mod + h" = "lazy.layout.left()";
        "mod + j" = "lazy.layout.down()";
        "mod + k" = "lazy.layout.up()";
        "mod + l" = "lazy.layout.right()";
        "mod + Return" = "lazy.spawn(terminal)";
        "mod + w" = "lazy.window.kill()"; # Kill focused window

        # Layout
        "mod + shift + h" = "lazy.layout.swap_left()";
        "mod + shift + j" = "lazy.layout.shuffle_down()";
        "mod + shift + k" = "lazy.layout.shuffle_up()";
        "mod + shift + l" = "lazy.layout.swap_right()";

        # Custom function (declared in extraConfig)
        "mod + control + h" = "lazy.function(shrink_master)";
        "mod + control + j" = "lazy.function(shrink_window)";
        "mod + control + k" = "lazy.function(grow_window)";
        "mod + control + l" = "lazy.function(grow_master)";
        "mod + r" = {
          keybindings = {
            "h" = "lazy.function(shrink_master)";
            "l" = "lazy.function(grow_master)";
            "mod + r" = {
              keybindings = {
                "h" = "lazy.function(shrink_master)";
                "l" = "lazy.function(grow_master)";
              };
              mode = "resize_nested";
            };
          };
          mode = "resize";
        };
      };
      groups = (lib.genList (i: toString(i + 1)) 9);
      layouts = [ "MonadTall()" ];
      extraConfig = ''
        from libqtile import hook
        def monad_stack_size(qtile):
            info = qtile.current_layout.info()
            return len(info["secondary"])
        def grow_master(qtile):
            if monad_stack_size(qtile) != 0:
                qtile.current_layout.cmd_grow_main()
        def shrink_master(qtile):
            if monad_stack_size(qtile) != 0:
                qtile.current_layout.cmd_shrink_main()
        def grow_window(qtile):
            if monad_stack_size(qtile) > 1:
                qtile.current_layout.cmd_grow()
        def shrink_window(qtile):
            if monad_stack_size(qtile) > 1:
                qtile.current_layout.cmd_shrink()
        # Reset ratio : will work in 0.18.0
        # @hook.subscribe.client_killed
        # def on_client_kill(window):
        #     if monad_stack_size(qtile) == 0:
      '';
    };
  };
}