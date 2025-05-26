local auto_session = require("auto-session")

auto_session.setup({
  log_level = "info", -- Set log level (options: "debug", "info", "warn", "error")

  -- Directory where sessions are stored
  root_dir = vim.fn.stdpath("data") .. "/sessions/",

  -- Automatically save, restore, and create sessions
  auto_save = true,
  auto_restore = true,
  auto_create = true,

  -- Restore last session if no session exists for current cwd
  auto_restore_last_session = true,

  -- Use Git branch name as part of session name (useful for monorepos)
  git_use_branch_name = true,
  git_auto_restore_on_branch_change = false, -- Requires the option above

  -- Prevent session auto save/restore in these directories
  suppressed_dirs = {
    vim.loop.os_homedir(),  -- Home directory
    "/",                    -- Root directory
    "/tmp",                 -- Temporary files
    vim.fn.stdpath("config") -- Neovim config path
  },

  -- Don't autosave if only dashboard buffer is open
  bypass_save_filetypes = { "alpha", "dashboard" },

  -- Automatically handle saving/restoring when cwd changes via :cd or :lcd
  cwd_change_handling = true,
  pre_cwd_changed_cmds = {
    "tabdo NvimTreeClose", -- Close file tree before saving session
  },
  post_cwd_changed_cmds = {
    function()
      require("lualine").refresh() -- Refresh statusline after restoring session
    end,
  },

  -- Enable Telescope integration for session management
  session_lens = {
    load_on_setup = true,
    previewer = false,
    mappings = {
      delete_session = { "i", "<C-D>" },      -- Delete session
      alternate_session = { "i", "<C-S>" },   -- Switch to alternate session
      copy_session = { "i", "<C-Y>" },        -- Copy session name
    },
  },
})

