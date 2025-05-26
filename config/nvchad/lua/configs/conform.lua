local M = {}

-- Formatters mapped by filetype
M.formatters_by_ft = {
    lua = {"stylua"},

    javascript = {"eslint_d", "prettier"},
    typescript = {"eslint_d", "prettier"},
    javascriptreact = {"eslint_d", "prettier"},
    typescriptreact = {"eslint_d", "prettier"},

    json = {"prettier"},
    yaml = {"prettier"},
    html = {"prettier"},
    css = {"prettier"},
    scss = {"prettier"},
    markdown = {"markdownlint"},
    markdown_inline = {"prettier"}, -- for embedded code blocks

    sh = {"shfmt"},
    bash = {"shfmt"},

    python = {"black"},
    toml = {"taplo"},
    sql = {"sqlfluff"}
}

-- Conform setup
M.setup = {
    formatters_by_ft = M.formatters_by_ft,

    -- Global formatting options
    default_format_opts = {
        lsp_format = "fallback", -- use LSP only if no other formatter is available
        timeout_ms = 1000
    },

    -- Format on save
    format_on_save = {
        lsp_format = "fallback",
        timeout_ms = 1000
    },

    -- Optional: format asynchronously after save
    -- format_after_save = {
    --   lsp_format = "fallback",
    -- },

    notify_on_error = true, -- notify when a formatter fails
    notify_no_formatters = true, -- notify when no formatters are available
    log_level = vim.log.levels.WARN
}

return M
