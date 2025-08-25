-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Set the LSP log level to debug
-- vim.lsp.set_log_level("debug")

-- Set the filetype for GitHub Actions workflow files
vim.filetype.add({
  pattern = {
    -- Match GitHub Actions workflow files (.yml and .yaml)
    [".*%.github/workflows/.*%.ya?ml$"] = "yaml.github",
  },
})

-- LSP Configuration
local lspconfig = require("lspconfig")

-- GitHub Actions Language Server
lspconfig.gh_actions_ls.setup({
  cmd = { "gh-actions-language-server", "--stdio" },
  filetypes = { "yaml.github" },
  root_dir = lspconfig.util.root_pattern(".github/workflows", ".github"),
})

-- Additional autocmd for more specific GitHub Actions detection
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.github/workflows/*.yml", "*.github/workflows/*.yaml" },
  callback = function()
    vim.bo.filetype = "yaml.github"
  end,
  desc = "Set filetype for GitHub Actions workflow files",
})
