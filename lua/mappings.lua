require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- inspect treesitter
map('n', '<leader>it', vim.treesitter.inspect_tree)
map('n', '<leader>i', vim.show_pos)

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
