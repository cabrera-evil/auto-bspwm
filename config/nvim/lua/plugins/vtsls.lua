return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    opts.servers.vtsls = vim.tbl_deep_extend("force", opts.servers.vtsls or {}, {
      -- Running the Mason shim through Node drops `--stdio` on this setup.
      -- Invoke the language server directly so its LSP transport is explicit.
      cmd = {
        vim.fn.exepath("node"),
        vim.fn.stdpath("data") .. "/mason/packages/vtsls/node_modules/@vtsls/language-server/dist/main.js",
        "--stdio",
      },
    })
  end,
}
