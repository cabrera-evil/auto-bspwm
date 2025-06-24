-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>go", function()
  vim.fn.jobstart("git open", { detach = true })
end, { desc = "Opens remote repository" })

vim.keymap.set("n", "<leader>cp", function()
  vim.fn.jobstart("find . -type f -exec dos2unix {} +", { detach = true })
end, { desc = "Convert files to Unix format" })
