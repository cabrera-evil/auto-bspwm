return {
  "ellisonleao/carbon-now.nvim",
  lazy = true,
  cmd = "CarbonNow",
  opts = {},
  keys = {
    {
      "<leader>cn",
      ":'<,'>CarbonNow<CR>",
      mode = "v",
      desc = "CarbonNow selected code",
      silent = true,
    },
  },
}
