return { {
    "mason-org/mason-lspconfig.nvim",
    lazy = false,
    dependencies = {
        {
            "mason-org/mason.nvim",
            opts = {},
            keys = {
                { "<leader>mm", "<cmd>Mason<cr>",             desc = "Mason: Open UI" },
                { "<leader>mU", "<cmd>MasonUpdate<cr>",       desc = "Mason: Update Registries" },
                { "<leader>mX", "<cmd>MasonUninstallAll<cr>", desc = "Mason: Uninstall All" },
                { "<leader>ml", "<cmd>MasonLog<cr>",          desc = "Mason: Open Log File" },
            },
        },
        "neovim/nvim-lspconfig",
    },
    opts = require("configs.mason-lspconfig"),
}, {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "williamboman/mason.nvim",
        "nvimtools/none-ls.nvim",
    },
    config = function()
        require("configs.mason-null-ls")
    end,
}, {
    "jay-babu/mason-nvim-dap.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "mason-org/mason.nvim",
        "mfussenegger/nvim-dap",
    },
    config = function()
        require("configs.mason-nvim-dap")
    end,
}, {
    "neovim/nvim-lspconfig",
    config = function()
        require("configs.lspconfig")
    end,
}, {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "BufReadPre",
    opts = require("configs.mason-tool-installer"),
} }
