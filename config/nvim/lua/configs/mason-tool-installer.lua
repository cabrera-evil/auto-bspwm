return {
    ensure_installed = {
        "black",
        "prettier",
        "stylua",
        "markdownlint",
        "shfmt",
        "shellcheck",
        "sqlfluff",
        "taplo"
    },
    auto_update = false,
    run_on_start = true,
    start_delay = 3000,
    debounce_hours = 5,
    integrations = {
        ["mason-lspconfig"] = true,
        ["mason-null-ls"] = false,
        ["mason-nvim-dap"] = false
    }
}
