return {
  "ellisonleao/carbon-now.nvim",
  lazy = true,
  cmd = "CarbonNow",
  config = function()
    require("carbon-now").setup()
  end,
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
