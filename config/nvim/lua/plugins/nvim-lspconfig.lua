return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    opts.servers = {
      gh_actions_ls = {
        enabled = true,
      },
    }
  end,
}
