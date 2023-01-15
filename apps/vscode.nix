{ ... }:

{
  programs.vscode = {
    enable = true;
    userSettings = {
      "editor.fontFamily" = "'LigaSF Mono Nerd Font', 'Droid Sans Mono', 'monospace', monospace";
      "editor.fontLigatures" = true;
      "terminal.integrated.fontFamily" = "'LigaSF Mono Nerd Font', 'Droid Sans Mono', 'monospace', monospace";
    };
  };
}
