return {
    ensure_installed = {
        "actionlint",
        -- "black",
        "eslint_d",
        "dotenv-linter",
        "prettier",
        "stylua",
        "markdownlint",
        "kube-linter",
        "shfmt",
        "shellcheck",
        -- "sqlfluff",
        "taplo"
    },
    auto_update = true,
    run_on_start = true,
    start_delay = 3000,
    debounce_hours = 5,
    integrations = {
        ["mason-lspconfig"] = true,
        ["mason-null-ls"] = false,
        ["mason-nvim-dap"] = false
    }
}
