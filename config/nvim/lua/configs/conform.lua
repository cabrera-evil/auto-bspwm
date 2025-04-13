local options = {
    formatters_by_ft = {
        lua = {"stylua"},
        javascript = {"prettier"},
        typescript = {"prettier"}
    },

    -- Use Prettier as a fallback if no formatter is defined for the filetype
    fallback_formatter = "prettier",

    format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true
    }
}

return options
