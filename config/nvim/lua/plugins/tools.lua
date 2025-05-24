return {{
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require("configs.conform")
}, {
    "windwp/nvim-ts-autotag",
    opts = require("configs.nvim-ts-autotag")
}, {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = require("configs.treesitter")
}}
