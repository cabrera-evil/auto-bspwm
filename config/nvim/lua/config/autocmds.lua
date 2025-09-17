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

-- LSP Configuration
local lspconfig = require("lspconfig")

-- GitHub Actions Language Server
lspconfig.gh_actions_ls.setup({
  cmd = { "gh-actions-language-server", "--stdio" },
  filetypes = { "yaml", "yml" },
  root_dir = lspconfig.util.root_pattern(".github/workflows", ".github"),
})
