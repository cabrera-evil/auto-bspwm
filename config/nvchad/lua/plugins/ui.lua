return { {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = function(_, opts)
            -- Other blankline configuration here
            return require("indent-rainbowline").make_opts(opts)
        end,
        dependencies = {
            "TheGLander/indent-rainbowline.nvim",
        },
    },
    {
        "stevearc/oil.nvim",
        lazy = false,
        dependencies = { {
            "echasnovski/mini.icons",
            lazy = false
        }, { "nvim-tree/nvim-web-devicons" } },
        config = function()
            local oil = require("oil")
            oil.setup()
            vim.keymap.set("n", "-", oil.toggle_float, {})
        end
    }, {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
    dependencies = { "nvim-tree/nvim-web-devicons" }
} }
