local auto_session = require("auto-session")

auto_session.setup({
  log_level = "info",
  auto_session_suppress_dirs = { "~/" },
  auto_session_enable_last_session = true,
  auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
  auto_session_use_git_branch = true,
  auto_session_create_enabled = true,
  auto_save_enabled = true,
  auto_restore_enabled = true,
})

