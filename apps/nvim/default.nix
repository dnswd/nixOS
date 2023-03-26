{ pkgs, ... }:

let 
  # List of custom packages
  easygrep = pkgs.vimUtils.buildVimPlugin {
    name = "vim-easygrep";
    src = pkgs.fetchFromGitHub {
      owner = "dkprice";
      repo = "vim-easygrep";
      rev = "d0c36a77cc63c22648e792796b1815b44164653a";
      sha256 = "0y2p5mz0d5fhg6n68lhfhl8p4mlwkb82q337c22djs4w5zyzggbc";
    };
  };

  # Use customRC for simple config but if you want your configuration to be in multiple files, you
  # can just package them as a plugin as plugins respect the hierarchie of .config/nvim file
  # as presented for instance here.
  # https://github.com/nanotee/nvim-lua-guide
  myConfig = pkgs.vimUtils.buildVimPlugin {
    name = "my-config";
    # Create in this directory a file like my-neovim-config/lua/init.lua, to load as below in customRC using
    # lua require("init")
    src = ./nvim-lua;
  };
  
  vimPlugins = with pkgs.vimPlugins; [
    telescope-nvim
    easygrep
  ];
in
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    extraConfig = ''
      " your custom configuration (vim format). If you like to have multiple files or lua config,
      " you can create a plugin easily as shown above.
      lua require("init")
    '';
    plugins = [myConfig] ++ vimPlugins;
  };
}
