require "nvchad.options"

local opt = vim.opt

-- Better cursor experience
opt.cursorline = true
opt.cursorlineopt = "both" -- highlights line and number

-- Better indentation and tabs
opt.expandtab = false   -- convert tabs to spaces
opt.shiftwidth = 2     -- number of spaces for each indent
opt.tabstop = 2        -- number of spaces per tab
opt.smartindent = true -- autoindent new lines

-- Line numbers
opt.number = true         -- show absolute line number
opt.relativenumber = true -- relative numbers for movement

-- UI/UX
opt.scrolloff = 8      -- minimal lines above/below cursor
opt.sidescrolloff = 8  -- minimal columns around cursor
opt.signcolumn = "yes" -- keep sign column visible

-- Mouse support
opt.mouse = "a" -- enable mouse in all modes

-- Clipboard
opt.clipboard = "unnamedplus" -- use system clipboard

-- Performance
opt.timeoutlen = 400 -- faster mapped sequence timeout
opt.updatetime = 250 -- reduce CursorHold delay

-- Search
opt.ignorecase = true -- case-insensitive search...
opt.smartcase = true  -- ...unless capital letter is used
opt.incsearch = true  -- show match as you type
opt.hlsearch = true   -- highlight all matches

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Wrapping
opt.wrap = true     -- no line wrapping by default
opt.linebreak = true -- break on word boundaries if wrapping enabled

-- Backup/Swap
opt.swapfile = false
opt.backup = false
opt.undofile = true -- enable persistent undo

-- UI aesthetics
opt.termguicolors = true -- enable true color
