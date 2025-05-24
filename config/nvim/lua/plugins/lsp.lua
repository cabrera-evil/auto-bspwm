return { {
    "mason-org/mason-lspconfig.nvim",
    lazy = false,
    dependencies = {
        {
            "mason-org/mason.nvim",
            opts = {}
        },
        "neovim/nvim-lspconfig",
    },
    opts = require("configs.mason-lspconfig")
}, {
    "neovim/nvim-lspconfig",
    config = function()
        require("configs.lspconfig")
    end
}, {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "BufReadPre",
    opts = require("configs.mason-tool-installer"),
    config = function()
        vim.keymap.set("n", "<leader>mi", "<cmd>MasonToolsInstall<cr>", { desc = "Mason Install Missing Tools" })
        vim.keymap.set("n", "<leader>ms", "<cmd>MasonToolsInstallSync<cr>", { desc = "Mason Install Sync" })
        vim.keymap.set("n", "<leader>mu", "<cmd>MasonToolsUpdate<cr>", { desc = "Mason Update Tools" })
        vim.keymap.set("n", "<leader>mU", "<cmd>MasonToolsUpdateSync<cr>", { desc = "Mason Update Sync" })
        vim.keymap.set("n", "<leader>mc", "<cmd>MasonToolsClean<cr>", { desc = "Mason Clean Unused Tools" })
    end
} }
