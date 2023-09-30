-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap
-- Insert --
-- Press jk fast to exit insert mode
keymap("i", "jk", "<ESC>", opts)

-- Visual --
-- Press jk fast to exit insert mode
keymap("v", "jk", "<ESC>", opts)

-- Copy and paste from system clipboard
keymap("v", "y", '"+y', opts)
keymap("v", "yy", '"+yy', opts)

-- keymap("n", "y", '"+y', opts)
keymap("n", "yy", '"+yy', opts)

keymap("n", "p", '"+p', opts)
