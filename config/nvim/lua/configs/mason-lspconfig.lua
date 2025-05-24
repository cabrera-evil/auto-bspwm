return {
  -- A list of servers to automatically install if they're not already installed. Example: { "rust_analyzer@nightly", "lua_ls" }
  ---@type string[]
  ensure_installed = {
    "ansiblels",
    "astro",
    "bashls",
    "cssls",
    "docker_compose_language_service",
    "dockerls",
    "emmet_ls",
    "eslint",
    -- "graphql",
    -- "groovyls",
    "helm_ls",
    "html",
    "jsonls",
    "lua_ls",
    "marksman",
    "nextls",
    -- "nginx_language_server",
    "prismals",
    "pyright",
    -- "sqlls",
    "snyk_ls",
    "tailwindcss",
    "terraformls",
    "ts_ls",
    "yamlls",
  },
  -- Whether installed servers should automatically be enabled via `:h vim.lsp.enable()`.
  --
  -- To exclude certain servers from being automatically enabled:
  -- ```lua
  --   automatic_enable = {
  --     exclude = { "rust_analyzer", "ts_ls" }
  --   }
  -- ```
  --
  -- To only enable certain servers to be automatically enabled:
  -- ```lua
  --   automatic_enable = {
  --     "lua_ls",
  --     "vimls"
  --   }
  -- ```
  ---@type boolean | string[] | { exclude: string[] }
  automatic_enable = {
    exclude = {
      "snyk_ls",
      "yamlls",
    },
  },
}
