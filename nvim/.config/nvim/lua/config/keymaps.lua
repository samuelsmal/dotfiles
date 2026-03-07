vim.g.mapleader = " "
vim.g.maplocalleader = "  "

local map = vim.keymap.set

-- Save file
map("n", "<Leader>w", "<cmd>w<CR>")

-- Search and replace word under cursor
map("n", "<Leader>*", ":%s/\\<<C-r><C-w>\\>//<Left>")

-- Close buffer without closing split
map("n", ",d", "<cmd>b#<bar>bd#<CR>")
