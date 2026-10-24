return {
  "azratul/live-share.nvim",
  dependencies = {
    "jbyuki/instant.nvim",
  },
  cmd = { "LiveShareServer", "LiveShareJoin" },
  init = function()
    vim.g.instant_username = os.getenv("USER") or os.getenv("USERNAME") or "guest"
  end,
  opts = {
    max_attempts = 40, -- Maximum number of attempts to read the URL from service(serveo.net or localhost.run), every 250 ms
    service = "serveo.net", -- Service to use, options are serveo.net or localhost.run
  },
}
