require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Make current file executable (for scripts, etc.)
map("n", "<leader>sx", "<cmd>!chmod +x %<CR>", { desc = "Make file executable", silent = true })

-- Move selected lines up/down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Quick save from any mode
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<CR><Esc>", { desc = "Quick save" })

