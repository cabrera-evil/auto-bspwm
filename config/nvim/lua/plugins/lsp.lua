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
                { "<leader>mi", "<cmd>MasonInstall<space>",   desc = "Mason: Install Package" },
                { "<leader>mu", "<cmd>MasonUninstall<space>", desc = "Mason: Uninstall Package" },
                { "<leader>mX", "<cmd>MasonUninstallAll<cr>", desc = "Mason: Uninstall All" },
                { "<leader>ml", "<cmd>MasonLog<cr>",          desc = "Mason: Open Log File" },
            },
        },
        "neovim/nvim-lspconfig",
    },
    opts = require("configs.mason-lspconfig"),
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
