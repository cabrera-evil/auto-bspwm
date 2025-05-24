require("nvchad.configs.lspconfig").defaults()

vim.lsp.config('*', {
    root_markers = {".git", "package.json"},
    capabilities = {
        textDocument = {
            codeAction = {
                dynamicRegistration = false,
            },
            completion = {
                completionItem = {
                    snippetSupport = true,
                },
            },
            semanticTokens = {
                multilineTokenSupport = true,
            },
        },
    },
})

-- read :h vim.lsp.config for changing options of lsp servers
