return { {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  opts = require("configs.conform")
}, {
  "neovim/nvim-lspconfig",
  config = function()
    require("configs.lspconfig")
  end
}, {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  opts = {
    ensure_installed = { "vim", "lua", "vimdoc", "html", "css", "javascript", "typescript", "tsx", "json",
      "markdown", "dockerfile", "yaml", "bash" },
    highlight = {
      enable = true
    },
    indent = {
      enable = true
    }
  }
}, {
  "williamboman/mason-lspconfig.nvim",
  lazy = false,
  opts = {
    auto_install = true,
    ensure_installed = { "html", "cssls", "tailwindcss", "eslint", "jsonls", "graphql", "emmet_ls",
      "lua_ls", "yamlls", "ansiblels", "terraformls", "tflint",
      "dockerls", "docker_compose_language_service", "bashls", "vimls", "marksman", "lemminx",
      "pyright", "prismals", "sqlls" }
  }
}, {
  "github/copilot.vim",
  lazy = false
}, {
  "rmagatti/auto-session",
  config = function()
    require("auto-session").setup({
      log_level = "info",
      auto_session_suppress_dirs = { "~" }
    })
  end
}, {
  "kdheepak/lazygit.nvim",
  lazy = true,
  cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitFilterCurrentFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = { {
    "<leader>lg",
    "<cmd>LazyGit<cr>",
    desc = "LazyGit"
  } }
} }
