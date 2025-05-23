return {{
    "rmagatti/auto-session",
    config = function()
        require("configs.auto-session")
    end
}, {
    "github/copilot.vim",
    lazy = false
}, {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require("configs.conform")
}, {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = require("configs.mason-lspconfig")
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
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "BufReadPre",
    opts = require("configs.mason-tool-installer")
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
}, {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = function(_, opts)
        return require("indent-rainbowline").make_opts(opts)
    end,
    dependencies = {"TheGLander/indent-rainbowline.nvim"}
}, {
    "windwp/nvim-ts-autotag",
    opts = require("configs.nvim-ts-autotag")
}, {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
    dependencies = {"nvim-tree/nvim-web-devicons"}
}}
