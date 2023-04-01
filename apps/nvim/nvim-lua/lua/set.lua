local set = vim.opt
local globalvar = vim.g

set.guicursor = ""

-- Set line number
set.nu = true
set.relativenumber = true

-- Set the behavior of tab
set.tabstop = 2
set.shiftwidth = 2
set.softtabstop = 2
set.expandtab = true
set.smartindent = true
set.smarttab = true

set.hlsearch = true
set.incsearch = true
set.showmatch = true
set.cmdheight = 0

set.wrap = true
set.breakindent = true
set.linebreak = true

globalvar.mapleader = " "
globalvar.setpaste = true

set.mouse = "a"

globalvar.default = true

set.ignorecase = true
set.smartcase = true

set.splitbelow = true
set.splitright = true

set.signcolumn = "yes:2"

set.swapfile = false
set.backup = false

set.scrolloff = 12
set.updatetime = 50

set.clipboard = "unnamedplus"

set.autowriteall = true

globalvar.loaded_netrw = 1
globalvar.loaded_netrwPlugin = 1

set.timeoutlen = 10