require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Delete without copying to any register (black hole)
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yanking" })

-- Yank (copy) to system clipboard
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
map("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })

-- Paste without overwriting what's in the yank buffer
map("v", "<leader>p", [["_dP]], { desc = "Paste without yanking selection" })

-- Search and replace word under cursor
map("n", "<leader>sw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Substitute word under cursor" })

-- Make current file executable (for scripts, etc.)
map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { desc = "Make file executable", silent = true })

-- Move selected lines up/down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Keep cursor centered when searching
map("n", "n", "nzzzv", { desc = "Next search result centered" })
map("n", "N", "Nzzzv", { desc = "Prev search result centered" })

-- Keep cursor in place when joining lines
map("n", "J", "mzJ`z", { desc = "Join lines and keep cursor" })

-- Buffer navigation
map("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })

-- Quick save from any mode
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<CR><Esc>", { desc = "Quick save" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
