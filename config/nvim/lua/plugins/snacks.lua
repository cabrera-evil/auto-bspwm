return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = function(_, opts)
    opts.picker = {
      sources = {
        explorer = {
          auto_close = true,
          hidden = true,
        },
      },
    }
  end,
}
