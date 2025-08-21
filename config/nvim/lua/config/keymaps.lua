-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>go", function()
  vim.fn.jobstart("git open", { detach = true })
end, { desc = "Opens remote repository" })

vim.keymap.set("n", "<leader>cp", function()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("No file associated with current buffer", vim.log.levels.WARN)
    return
  end
  vim.fn.jobstart({ "dos2unix", file }, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_exit = function(_, code, _)
      vim.schedule(function()
        if code == 0 then
          vim.cmd("edit")
          vim.notify(" Converted to Unix format: " .. file, vim.log.levels.INFO)
        else
          vim.notify(" Failed to convert file: " .. file, vim.log.levels.ERROR)
        end
      end)
    end,
  })
end, {
  desc = "Convert current file to Unix format and reload buffer",
})
