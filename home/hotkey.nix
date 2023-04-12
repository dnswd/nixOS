{
  config,
  lib,
  pkgs,
  my,
  ...
}: let
  mkHotkeyChain = set:
    with lib.attrsets;
    with lib.strings;
      listToAttrs (map (c: {
          name = elemAt c 0;
          value = elemAt c 1;
        }) (collect isList
          (mapAttrsRecursive (path: value: [(concatStrings path) value]) set)));
  prefix = c: with lib.attrsets; mapAttrs' (n: v: nameValuePair "${c}${n}" v);
  plus = prefix " + ";
  chord = prefix " ; ";
  chord' = prefix " : ";
  none = prefix " ";

  step = "10";
  desks' = 4;
  desks = "{1-${toString desks'}}";
  top_padding = 32;
  t = my.palette;
in {
  services.sxhkd = {
    enable = true;
    keybindings = mkHotkeyChain {
      #   "alt + {_,shift + }Tab" = "bspc node -f {next,prev}.leaf.local.!sticky";
      #   Print = "flameshot gui";
      "shift + Print" = "flameshot full -c";

      # sound
      #   XF86AudioMute = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
      #   XF86AudioRaiseVolume = "pactl set-sink-volume @DEFAULT_SINK@ +2%";
      #   XF86AudioLowerVolume = "pactl set-sink-volume @DEFAULT_SINK@ -2%";

      #   XF86AudioPlay = "playerctl -p spotifyd play-pause";

      # headset/speakers toggle
      #   "alt + XF86AudioPlay" = "audio_device_toggle";
      #   "shift + XF86AudioPlay" =
      #     "spt pb --transfer=Daemon; playerctl -p spotifyd play";
      #   "shift + XF86AudioMute" = "systemctl --user restart spotifyd";
      #   "shift + XF86AudioRaiseVolume" = "playerctl -p spotifyd next";
      #   "shift + XF86AudioLowerVolume" = "playerctl -p spotifyd previous";

      super = plus {
        # reload sxhkd
        # Escape = "pkill -USR1 -x sxhkd; bspc wm -r";
        # Return = "$TERMINAL";
        # f = "bspc desktop -l next";
        # m = "bspc node @/first -f";
        # t = "bspc node -t {floating,tiled}";
        # p = "bspc node -g sticky";
        # x = "bspc node -c";
        # b = "bspc node @parent -B";
        # g = "bspc node @parent -E";
        # "{q,e}" = "bspc node @parent -F {horizontal,vertical}";
        # "{w,a,s,d}" = "bspc node -f {north,west,south,east}.leaf.local.!sticky";
        # "{j,k}" = "bspc node {last.descendant_of,@parent} -f";
        # "${desks}" = "bspc desktop -f ${desks}";

        # shift = plus {
        #   f = ''
        #     {\
        #       eww close bar; bspc config top_padding 0,\
        #       bspc config top_padding ${toString top_padding}; eww open bar\
        #       }'';
        #   x = "bspc node -k";
        #   "{q,e}" = "bspc node @parent -R {270,90}";
        #   # from https://www.reddit.com/r/bspwm/comments/r5stxu/resizing_windows_nicely_in_my_opinion/
        #   "{w,a,s,d}" = ''
        #     {\
        #       bspc node @parent/first  -z top 0 -${step}; \
        #       bspc node @parent/second -z top    0 -${step}, \
        #       bspc node @parent/second -z left   -${step} 0; \
        #       bspc node @parent/first  -z right  -${step} 0, \
        #       bspc node @parent/second -z top    0 +${step}; \
        #       bspc node @parent/first  -z top 0 +${step}, \
        #       bspc node @parent/first  -z right  +${step} 0; \
        #       bspc node @parent/second -z left   +${step} 0  \
        #       }'';
        #   "{1-9}" = "bspc node @parent -r 0.{1-9}";
        # };

        # alt = plus {
        #   f = "bspc node -t {fullscreen,tiled}";
        #   m = "bspc node -s biggest.window";
        #   "{q,e}" = "bspc node @parent -C {backward,forward}";
        #   "{w,a,s,d}" = ''
        #     {\
        #       bspc node focused.tiled    -s north.leaf; \
        #       bspc node focused.floating -v 0 -${step}, \
        #       bspc node focused.tiled    -s west.leaf;  \
        #       bspc node focused.floating -v -${step} 0, \
        #       bspc node focused.tiled    -s south.leaf; \
        #       bspc node focused.floating -v 0 +${step}, \
        #       bspc node focused.tiled    -s east.leaf;  \
        #       bspc node focused.floating -v +${step} 0, \
        #       }'';
        #   "${desks}" = "bspc node -d ${desks}";
        #   shift = plus {
        #     q = "bspc node -p {north,south}";
        #     e = "bspc node -p {west,east}";
        #     w = "bspc node -g marked";
        #     a = "bspc node -n last.!automatic";
        #     s = "bspc node -s last.marked";
        #     d = "bspc node -p cancel; bspc node -g marked=off";
        #     "${desks}" = "bspc node -d ${desks} -f";
        #   };
        # };

        space = chord {
          "{_,super + }" = none {
            space = "rofit -show drun";
            q = ''
              rofit -show p -modi "p:rofi-power --choices=shutdown/reboot/logout" -theme power'';
            u = ''
              rofit -show emoji -emoji-format "\{emoji\}" -modi emoji -theme emoji'';
            f = "firefox";
            # e = "emacsclient -c -a ''";
            # w = "fehbg random";
            # t = "che theme toggle";
            m = "pcmanfm";
          };
        };
      };
    };
  };
}
