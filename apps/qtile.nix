{ pkgs, config, ... }:

{
  # Qtile custom module are sourced from:
  # https://github.com/addy419/configurations/blob/1d3a91dc6645c7785f432b41b862e46beccbb1db/modules/desktop/qtile.nix

  imports = [ ../hm-modules/qtile.nix ];

  xsession = {
    enable = true;
    windowManager.qtile = {
      enable = true;
      package = pkgs.unstable.qtile;
      terminal = "kitty";
      keybindings = {
        "mod + Return" = "lazy.spawn(terminal)";
        "mod + mod1 + r" = "lazy.reload_config()";
        "mod + 0" = {
          mode = "(s)hutdown (r)estart (q)uit";
          keybindings = {
            "q" = "lazy.shutdown()";
            "s" = ''lazy.spawn("shutdown now")'';
            "r" = ''lazy.spawn("shutdown now -r")'';
          };
        };
        "mod + h" = "lazy.layout.left()";
        "mod + j" = "lazy.layout.down()";
        "mod + k" = "lazy.layout.up()";
        "mod + l" = "lazy.layout.right()";
        "mod + shift + h" = "lazy.layout.swap_left()";
        "mod + shift + j" = "lazy.layout.shuffle_down()";
        "mod + shift + k" = "lazy.layout.shuffle_up()";
        "mod + shift + l" = "lazy.layout.swap_right()";
        "mod + control + h" = "lazy.function(shrink_master)";
        "mod + control + j" = "lazy.function(shrink_window)";
        "mod + control + k" = "lazy.function(grow_window)";
        "mod + control + l" = "lazy.function(grow_master)";
        "mod + q" = "lazy.window.kill()";
        "mod1 + m" = "lazy.window.toggle_maximize()";
        "mod1 + f" = "lazy.window.toggle_fullscreen()";
        "mod + shift + space" = "lazy.window.toggle_floating()";
      };
      extraConfig = ''
        from libqtile import hook
        
        # groups
        groups = [Group(str(i),label=str(i)) for i in range(1,10)]
        for i in groups:
            keys.extend([
                Key([mod], i.name, lazy.group[i.name].toscreen(toggle=False),
                    desc="Switch to group {}".format(i.name)),
                Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True),
                    desc="Switch to & move focused window to group {}".format(i.name)),
            ])

        # layouts
        gaps = 5
        border_width = 2
        border_focus = "#ff0000"
        border_unfocused = "#44475a"
        floating_layout = layout.Floating(
            float_rules=[
                *layout.Floating.default_float_rules,
                Match(wm_class='confirmreset'),  # gitk
                Match(wm_class='makebranch'),  # gitk
                Match(wm_class='maketag'),  # gitk
                Match(wm_class='ssh-askpass'),  # ssh-askpass
                Match(wm_class='lxqt-notificationd'),
                Match(title='branchdialog'),  # gitk
                Match(title='pinentry'),  # GPG key password entry
                ],
            border_width=border_width,
            border_focus=border_focus,
            border_normal=border_unfocused
            )
        monad_layout = layout.MonadTall(
            margin=gaps,
            border_width=border_width,
            border_focus=border_focus,
            border_normal=border_unfocused
            )
        layouts = [monad_layout]

        # screens
        widget_defaults = dict(font="JetBrains Mono Nerd Font",fontsize=12)
        extension_defaults = widget_defaults.copy()

        wallpaper = ""
        wallpaper_color = "#ecbfbd"
        wallpaper_color_alt = "#282a36"

        status_notifier = widget.StatusNotifier(
            icon_theme="papirus-icon-theme",
            icon_size=16
            )

        chord = widget.Chord(
            foreground = "#f8f8f2"
            )

        def screen(index):
            barheight = 32
            borderwidth = 3
            
            # groupbox
            fontsize = 14
            padding = 10
            groupbox = widget.GroupBox(
                fontsize=fontsize,
                highlight_method="block",
                borderwidth=borderwidth,
                font="Font Awesome 6 Free Solid",
                active="#f8f8f2",
                inactive="#44475a",
                block_highlight_text_color=wallpaper_color_alt,
                this_current_screen_border=wallpaper_color,
                this_screen_border=wallpaper_color,
                margin=0,
                padding_y=barheight-fontsize-2*borderwidth,
                padding_x=padding,
                rounded=False
                )

            widgets = [
                groupbox,
                chord,
                widget.Spacer(),
                #status_notifier
                #widget.Systray()
                status_notifier
                ]

            return Screen(
                bottom=bar.Bar(widgets,barheight,background="#282a36"),
                wallpaper=wallpaper,
                wallpaper_mode="fill"
                )

        maxScreens = 1
        screens = [screen(i) for i in range(maxScreens)]

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

        @hook.subscribe.client_killed
        def on_client_kill(window):
            qtile = window.qtile
            if monad_stack_size(qtile) <= 1:
                qtile.current_layout.cmd_set_ratio(0.5)
      '';
    };
  };
}
