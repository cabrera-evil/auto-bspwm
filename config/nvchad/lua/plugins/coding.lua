return { {
    "folke/lazydev.nvim",
    ft = "lua",     -- only load on lua files
    opts = {
        library = { -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            {
                path = "${3rd}/luv/library",
                words = { "vim%.uv" }
            } }
    }
}, {
    "github/copilot.vim",
    lazy = false
},
    {
        "nomnivore/ollama.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        cmd = { "Ollama", "OllamaModel", "OllamaServe", "OllamaServeStop" },
        keys = {
            {
                "<leader>oo",
                ":<c-u>lua require('ollama').prompt()<cr>",
                desc = "ollama prompt",
                mode = { "n", "v" },
            },
            {
                "<leader>oG",
                ":<c-u>lua require('ollama').prompt('Generate_Code')<cr>",
                desc = "ollama Generate Code",
                mode = { "n", "v" },
            },
        },
        opts = require ('configs.ollama')
    }
}
