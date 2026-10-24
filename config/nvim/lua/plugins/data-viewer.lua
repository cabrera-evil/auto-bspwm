-- Table view for tsv and sqlite files; csv is handled by csvview.nvim.
return {
  "vidocqh/data-viewer.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "kkharji/sqlite.lua",
  },
  cmd = { "DataViewer", "DataViewerNextTable", "DataViewerPrevTable", "DataViewerClose" },
  ft = { "tsv", "sqlite" },
  keys = {
    { "<leader>vd", "<cmd>DataViewer<cr>", desc = "Data Viewer" },
    { "<leader>vc", "<cmd>DataViewerClose<cr>", desc = "Close Data Viewer" },
  },
  opts = {
    -- open tsv/sqlite files directly in the table view
    autoDisplayWhenOpenFile = true,
    maxLineEachTable = 200,
    view = { float = true, width = 0.9, height = 0.85 },
  },
}
