-- Load sensible defaults first
require("config.defaults")

-- --- User Custom Options ---

-- Spell checking settings
-- Add Italian and US English dictionaries
vim.o.spelllang = "en_us,it"
vim.o.spell = true

-- CMD Line height
-- vim.opt.cmdheight = 0

-- Disable relative line number (Global preference override)
vim.opt.relativenumber = false

-- Disable Autoformat
-- Can be toggled manually if needed
vim.g.autoformat = false

-- Nvim Tree setting
-- Respect buffer's current working directory
vim.g.nvim_tree_respect_buf_cwd = 1

-- List characters configuration
-- Show spaces as dots and tabs as arrows for better visibility of whitespace
vim.opt.list = true
vim.opt.listchars = { space = "⋅", tab = "→ " }

-- Set root directory detection preference
-- Prioritizes LSP, then package.json/.git/lua files, then current working directory
vim.g.root_spec = { "lsp", { "package.json", ".git", "lua" }, "cwd" }

-- Folding settings
-- Use Treesitter for accurate code folding
vim.opt.foldlevel = 99 -- Start with all folds open
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldmethod = 'expr'

-- Disable conceal
-- Ensures all characters (like quotes in JSON) are visible
vim.opt.conceallevel = 0
