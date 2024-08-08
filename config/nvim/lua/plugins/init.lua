return {{
    "stevearc/conform.nvim",
    event = 'BufWritePre',
    opts = require "configs.conform"
}, {
    "neovim/nvim-lspconfig",
    config = function()
        require "configs.lspconfig"
    end
}, {
    "nvim-treesitter/nvim-treesitter",
    opts = {
        ensure_installed = {"vim", "lua", "vimdoc", "html", "css"}
    }
}, {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
        auto_install = true
    }
}, {
    "github/copilot.vim",
    lazy = false
}, {
    "rmagatti/auto-session",
    config = function()
        require("auto-session").setup()
    end
}}
