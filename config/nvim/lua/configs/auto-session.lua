local auto_session = require("auto-session")

auto_session.setup({
    log_level = "info",
    auto_session_enable_last_session = true,

    -- Store sessions under standard data dir
    auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",

    -- Save sessions automatically when exiting Neovim
    auto_save_enabled = true,
    auto_restore_enabled = true,
    auto_session_create_enabled = true,

    -- Create session per Git branch (great for monorepos)
    auto_session_use_git_branch = true,

    -- Suppress autosave in HOME and common transient dirs
    auto_session_suppress_dirs = {vim.loop.os_homedir(), "/", "/tmp", vim.fn.stdpath("config")},

    -- Optional: prevent overwriting broken sessions
    auto_session_enable_git_clean = true
})
