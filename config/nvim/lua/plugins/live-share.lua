return {
  "azratul/live-share.nvim",
  dependencies = {
    "jbyuki/instant.nvim",
  },
  config = function()
    vim.g.instant_username = os.getenv("USER") or os.getenv("USERNAME") or "guest"
    require("live-share").setup({
      max_attempts = 40, -- Maximum number of attempts to read the URL from service(serveo.net or localhost.run), every 250 ms
      service = "serveo.net", -- Service to use, options are serveo.net or localhost.run
    })
  end,
}
