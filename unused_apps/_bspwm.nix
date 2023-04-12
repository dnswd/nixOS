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
  xsession.windowManager.bspwm = {
    enable = true;
    settings = {
      inherit top_padding;
      window_gap = 16;
      border_width = 2;
      split_ratio = 0.5;
      gapless_monocle = false;
      borderless_monocle = true;
      single_monocle = true;

      # initial light theme
      normal_border_color = t."05";
      focused_border_color = t."66";
      active_border_color = t."16";
      presel_feedback_color = t."66";
    };
    rules = {
      Emacs.state = "tiled";
      Zathura.state = "tiled";
      "*:*:Picture-in-Picture".state = "floating";
      "*:jetbrains-clion:splash".state = "floating";
      "origin.exe".state = "floating";
      "explorer.exe".hidden = true;
    };
    monitors = {Virtual1 = map toString (lib.lists.range 1 desks');};
    extraConfig = ''
      bspc desktop -l monocle

      xdo lower -N "eww-bar"
      bspc subscribe node_state | while read -r _ _ _ _ state flag; do
        if [[ "$state" != fullscreen ]]; then continue; fi
        if [[ "$flag" == on ]]; then
          xdo lower -N "eww-bar"
        else
          xdo raise -N "eww-bar"
        fi
      done &
    '';
  };
  xdg.configFile."bspwm/dark".executable = true;
  xdg.configFile."bspwm/dark".text = ''
    bspc config normal_border_color '${t."0A"}'
    bspc config focused_border_color '${t."65"}'
    bspc config active_border_color '${t."15"}'
    bspc config presel_feedback_color '${t."64"}'
  '';
  xdg.configFile."bspwm/light".executable = true;
  xdg.configFile."bspwm/light".text = ''
    bspc config normal_border_color '${t."05"}'
    bspc config focused_border_color '${t."66"}'
    bspc config active_border_color '${t."16"}'
    bspc config presel_feedback_color '${t."66"}'
  '';
}
