-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

-- Theme configuration (Base46)
M.base46 = {
  theme = "onedark",

  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },
}

-- Dashboard configuration
M.nvdash = {
  load_on_startup = true,
}

-- UI configuration
M.ui = {
  theme_toggle = { "onedark", "catppuccin" }, -- toggle theme

  -- Enable and customize tabline
  tabufline = {
    lazyload = false,
    order = { "treeOffset", "buffers", "tabs", "btns" },
  },

  -- Enable better statusline contrast and diagnostics
  statusline = {
    theme = "default",         -- or "minimal"
    separator_style = "round", -- options: "default", "round", "block", "arrow"
  },

  -- Enable LSP diagnostic icons
  lsp_semantic_tokens = true,
}

return M
