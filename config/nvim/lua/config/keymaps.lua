-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Helpers
local function current_file_or_warn()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("No file associated with current buffer", vim.log.levels.WARN)
    return nil
  end
  return file
end

local function copy_to_clipboard(text, label)
  if not text or text == "" then
    vim.notify("Nothing to copy", vim.log.levels.WARN)
    return
  end
  vim.fn.setreg("+", text)
  vim.fn.setreg("*", text)
  vim.notify(" Copied " .. label .. " to clipboard", vim.log.levels.INFO)
end

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

-- Copy absolute path of current file
vim.keymap.set("n", "<leader>yp", function()
  local file = current_file_or_warn()
  if not file then
    return
  end
  local path = vim.fn.fnamemodify(file, ":p")
  copy_to_clipboard(path, "absolute path")
end, { desc = "Copy absolute path to clipboard" })

-- Copy path relative to cwd
vim.keymap.set("n", "<leader>yr", function()
  local file = current_file_or_warn()
  if not file then
    return
  end
  local path = vim.fn.fnamemodify(file, ":.")
  copy_to_clipboard(path, "relative path")
end, { desc = "Copy relative path to clipboard" })

-- Copy just the filename
vim.keymap.set("n", "<leader>yn", function()
  local file = current_file_or_warn()
  if not file then
    return
  end
  local name = vim.fn.fnamemodify(file, ":t")
  copy_to_clipboard(name, "filename")
end, { desc = "Copy filename to clipboard" })

-- Copy directory of current file
vim.keymap.set("n", "<leader>yd", function()
  local file = current_file_or_warn()
  if not file then
    return
  end
  local dir = vim.fn.fnamemodify(file, ":p:h")
  copy_to_clipboard(dir, "directory path")
end, { desc = "Copy directory path to clipboard" })

-- Yank entire buffer to system clipboard
vim.keymap.set("n", "<leader>yy", function()
  local ok, err = pcall(vim.cmd, "silent %y+")
  if not ok then
    vim.notify(" Failed to yank buffer: " .. err, vim.log.levels.ERROR)
    return
  end
  vim.notify(" Yanked entire buffer to system clipboard", vim.log.levels.INFO)
end, { desc = "Yank entire buffer to system clipboard" })

-- Toggle executable bit (u+x) for current file
vim.keymap.set("n", "<leader>cx", function()
  local file = current_file_or_warn()
  if not file then
    return
  end

  local perm = vim.fn.getfperm(file)
  if perm == "" then
    vim.notify(" Cannot get permissions for file: " .. file, vim.log.levels.ERROR)
    return
  end

  local is_exec = perm:sub(3, 3) == "x"
  local cmd = is_exec and { "chmod", "u-x", file } or { "chmod", "u+x", file }

  vim.fn.jobstart(cmd, {
    on_exit = function(_, code)
      vim.schedule(function()
        if code == 0 then
          local action = is_exec and "Removed" or "Made"
          vim.notify(" " .. action .. " executable: " .. file, vim.log.levels.INFO)
        else
          vim.notify(" Failed to toggle executable bit: " .. file, vim.log.levels.ERROR)
        end
      end)
    end,
  })
end, { desc = "Toggle executable (u+x) for current file" })

-- Open directory of current file in system file manager
vim.keymap.set("n", "<leader>xo", function()
  local file = current_file_or_warn()
  if not file then
    return
  end

  local dir = vim.fn.fnamemodify(file, ":p:h")
  local sysname = vim.loop.os_uname().sysname
  local cmd

  if sysname == "Windows_NT" then
    cmd = { "cmd.exe", "/C", "start", "", dir }
  elseif sysname == "Darwin" then
    cmd = { "open", dir }
  else
    cmd = { "xdg-open", dir }
  end

  vim.fn.jobstart(cmd, { detach = true })
end, { desc = "Open file directory in system file manager" })

-- Delete entire content of current file (without clobbering registers)
vim.keymap.set("n", "<leader>c0", function()
  if not vim.bo.modifiable then
    vim.notify("Buffer is not modifiable", vim.log.levels.WARN)
    return
  end

  local file = vim.api.nvim_buf_get_name(0)
  local msg = "Clear entire buffer?"
  if file ~= "" then
    msg = msg .. "\n(" .. file .. ")"
  end

  local choice = vim.fn.confirm(msg, "&Yes\n&No", 2)
  if choice ~= 1 then
    return
  end

  -- use black-hole register so we don't trash default yank
  vim.cmd("silent keepjumps keepalt %delete _")
  vim.notify(" Cleared buffer content", vim.log.levels.INFO)
end, { desc = "Delete entire buffer content" })
