-- init.lua --- haoxiangliew's Neovim configuration

--- Commentary:
-- This is my personal Neovim configuration
-- It is designed to be used in vscode-neovim
-- and as a minimal editor in the terminal

--- Dependencies:
-- git

--- Code:

vim.loader.enable()

-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
}, {})

-- set colorscheme from terminal
vim.o.termguicolors = true

-- set statusline
require("lualine").setup({
  options = {
    theme = "auto",
    section_separators = "",
  },
})

-- disable highlight on search
vim.o.hlsearch = false
-- case insensitive search
vim.o.ignorecase = true
vim.o.smartcase = true

-- enable mouse mode
vim.o.mouse = "a"

-- use system clipboard
vim.o.clipboard = "unnamedplus"

-- smart word wrap
vim.o.breakindent = true

-- keep signcolumn
vim.o.signcolumn = "yes"

-- decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- completeopt
vim.o.completeopt = "menuone,noselect"
