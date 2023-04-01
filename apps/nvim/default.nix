{ pkgs, lib, ... }:

let
  # List of custom packages
  smart-splits = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "smart-splits";
    src = pkgs.fetchFromGitHub {
      owner = "mrjones2014";
      repo = "smart-splits.nvim";
      rev = "0abf0348aa56025ef31d6eed9e1b3c1fee84421e";
      hash = "sha256-Ern46zl8gouOD+SQfLxB1Gu9Sqt4SyIawhggBThSvfM=";
    };
  };

  barbecue = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "barbecue";
    src = pkgs.fetchFromGitHub {
      owner = "utilyre";
      repo = "barbecue.nvim";
      rev = "v1.0.0";
      hash = "sha256-oQwrCCgHt04Amyc/Uis6HtwjDQ3V+AhetJ/yEyY7yRU=";
    };
  };

  persistence = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "persistence";
    src = pkgs.fetchFromGitHub {
      owner = "folke";
      repo = "persistence.nvim";
      rev = "c814fae5c37aa0aba9cd9da05df6e52b88d612c3";
      hash = "sha256-IjFJcXyfax72AsypO4HVRmG/kIBDB74PdSVcIrxRLqY=";
    };
  };

  no-neck-pain = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "no-neck-pain";
    src = pkgs.fetchFromGitHub {
      owner = "shortcuts";
      repo = "no-neck-pain.nvim";
      rev = "33db10e593edc7d720c0f5c0320899bd1dd014e1";
      hash = "sha256-Yq68nxfapBbjZa4Gd6tRz8JNg8bWvCQjhzl1lCH+8bA=";
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
  
  vimPlugin = with pkgs.vimPlugins; [
      # plugins set up in nvim/
      impatient-nvim
      # color.lua
      catppuccin-nvim
      lualine-nvim
      twilight-nvim

      # telescope.lua
      telescope-nvim
      harpoon

      # lsp.lua
      rust-tools-nvim
      nvim-lspconfig
      nvim-treesitter-refactor
      nvim-treesitter-textobjects
      nvim-treesitter.withAllGrammars
      playground
      nvim-navic

      # Completions
      cmp-buffer
      cmp-cmdline
      cmp-nvim-lsp
      cmp-nvim-lsp-signature-help
      cmp-path
      lspkind-nvim
      nvim-cmp
      # Snippets
      luasnip
      cmp_luasnip

      # formatter.lua
      neoformat

      # navigation
      smart-splits
      barbecue

      # plugins set up here
      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = "require('gitsigns').setup({sign_priority = 0})";
      }
      {
        plugin = which-key-nvim;
        type = "lua";
        config = "require('which-key').setup()";
      }
      {
        plugin = nvim-autopairs;
        type = "lua";
        config = "require('nvim-autopairs').setup()";
      }
      {
        plugin = nvim-surround;
        type = "lua";
        config = "require('nvim-surround').setup()";
      }
      {
        plugin = comment-nvim;
        type = "lua";
        config = "require('Comment').setup()";
      }
      {
        plugin = leap-nvim;
        type = "lua";
        config = "require('leap').add_default_mappings()";
      }
      {
        plugin = fidget-nvim;
        type = "lua";
        config = "require('fidget').setup()";
      }
      {
        plugin = indent-blankline-nvim;
        type = "lua";
        config = ''require('indent_blankline').setup({
          show_current_context = true,
          show_current_context_start = true,
        })'';
      }
      {
        plugin = nvim-lastplace;
        type = "lua";
        config = "require('nvim-lastplace').setup()";
      }
      {
        plugin = trouble-nvim;
        type = "lua";
        config = "require('trouble').setup()";
      }
      {
        plugin = toggleterm-nvim;
        type = "lua";
        config = "require('toggleterm').setup()";
      }
      {
        plugin = persistence;
        type = "lua";
        config = "require('persistence').setup()";
      }
      {
        plugin = nvim-tree-lua;
        type = "lua";
        config = ''
        require('nvim-tree').setup({
          update_focused_file = {
            enable = true,
            update_cwd = true,
            update_root = true,
          },
        })'';
      }
      markdown-preview-nvim
      nvim-web-devicons
      no-neck-pain
      zen-mode-nvim
  ];

  vimPluginUnstable = with pkgs.unstable.vimPlugins; [
      copilot-lua
      copilot-cmp
      winshift-nvim
  ];
in
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraPackages = with pkgs; [
      pgformatter
      black
      nixpkgs-fmt
      nodePackages.bash-language-server
      nodePackages.vscode-langservers-extracted
      nodePackages.yaml-language-server
      pyright
      rnix-lsp
      sumneko-lua-language-server
      tree-sitter
    ];
    extraConfig = ''
      " your custom configuration (vim format). If you like to have multiple files or lua config,
      " you can create a plugin easily as shown above.
      lua require("init")
    '';
    plugins = [myConfig] ++ vimPlugin ++ vimPluginUnstable;
  };
}
