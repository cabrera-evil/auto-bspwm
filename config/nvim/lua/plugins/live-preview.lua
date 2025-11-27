return {
  "cabrera-evil/live-preview.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "ibhagwan/fzf-lua",
    "nvim-mini/mini.pick",
    "folke/snacks.nvim",
  },
  keys = {
    { "<leader>ps", ":LivePreview start<CR>", desc = "Start Live Preview" },
    { "<leader>pc", ":LivePreview close<CR>", desc = "Stop Live Preview" },
    { "<leader>pp", ":LivePreview pick<CR>", desc = "Pick file to preview" },
  },
}
