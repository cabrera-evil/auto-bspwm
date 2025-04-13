return {{
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
    opts = require("configs.treesitter")
}, {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = require("configs.mason-lspconfig")
}, {
    "github/copilot.vim",
    lazy = false
}, {
    "rmagatti/auto-session",
    config = function()
        require("configs.auto-session")
    end
}, {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {"LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitFilterCurrentFile"},
    dependencies = {"nvim-lua/plenary.nvim"},
    keys = {{
        "<leader>lg",
        "<cmd>LazyGit<cr>",
        desc = "LazyGit"
    }}
}}
