local Util = require("util")

---Helper function to simplify keymap creation.
---Checks if a keymap is already handled by a lazy key handler to prevent conflicts.
---@param mode string|string[] Mode(s) for the keymap (n, i, v, x, etc.)
---@param lhs string The key sequence to map
---@param rhs string|function The command or function to execute
---@param opts table? Optional parameters (desc, silent, remap, etc.)
local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
      opts.remap = nil
    end
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

-- --- Better Navigation ---

-- Better up/down movement
-- Moves by visual line if the line is wrapped, unless a count is provided
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
-- Allows easy navigation between split windows
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Resize window using <ctrl> arrow keys
-- Quickly adjust window sizes without complex commands
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Move Lines
-- Moves the current line or selected block up/down
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- --- Buffer Management ---

-- Navigate buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- Delete buffers using Snacks
map("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })
map("n", "<leader>bo", function() Snacks.bufdelete.other() end, { desc = "Delete Other Buffers" })
map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

-- --- Search & Editing ---

-- Clear search with <esc>
-- Stops highlighting search results
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

-- Search word under cursor
map({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })

-- Saner behavior of n and N
-- Ensures 'n' always goes forward and 'N' always goes backward
-- Uses a Lua function to avoid potential Vimscript string indexing issues and ambiguous 'E20' errors.
map("n", "n", function() return (vim.v.searchforward == 1 and "n" or "N") .. "zv" end, { expr = true, desc = "Next Search Result" })
map("x", "n", function() return (vim.v.searchforward == 1 and "n" or "N") end, { expr = true, desc = "Next Search Result" })
map("o", "n", function() return (vim.v.searchforward == 1 and "n" or "N") end, { expr = true, desc = "Next Search Result" })
map("n", "N", function() return (vim.v.searchforward == 1 and "N" or "n") .. "zv" end, { expr = true, desc = "Prev Search Result" })
map("x", "N", function() return (vim.v.searchforward == 1 and "N" or "n") end, { expr = true, desc = "Prev Search Result" })
map("o", "N", function() return (vim.v.searchforward == 1 and "N" or "n") end, { expr = true, desc = "Prev Search Result" })

-- Add undo break-points
-- Creates an undo point when typing punctuation, allowing granular undo
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- Save file with Ctrl+s
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- Keywordprg (Documentation)
map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- Better indenting
-- Keeps selection after indenting in visual mode
map("v", "<", "<gv")
map("v", ">", ">gv")

-- --- Tools & Utilities ---

-- Lazy Package Manager
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- New file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- Quickfix & Location List
map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })
map("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- Formatting
map({ "n", "v" }, "<leader>cf", function()
  require("conform").format({ lsp_fallback = true })
end, { desc = "Format" })

-- Diagnostics
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- --- Toggle Options ---
map("n", "<leader>uf", function() require("conform").format({ lsp_fallback = true }) end, { desc = "Format" })
map("n", "<leader>ud", Util.toggle_diagnostics, { desc = "Toggle Diagnostics" })
map("n", "<leader>us", function() Util.toggle("spell") end, { desc = "Toggle Spelling" })
map("n", "<leader>uw", function() Util.toggle("wrap") end, { desc = "Toggle Word Wrap" })
map("n", "<leader>uL", function() Util.toggle("relativenumber") end, { desc = "Toggle Relative Line Numbers" })
map("n", "<leader>ul", function() Util.toggle("number") end, { desc = "Toggle Line Numbers" })
map("n", "<leader>ih", Util.toggle_inlay_hints, { desc = "Toggle Inlay Hints" })

-- Quit all
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- UI Inspection
map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
map("n", "<leader>uI", "<cmd>InspectTree<cr>", { desc = "Inspect Tree" })

-- Floating Terminal
-- Uses Snacks to open a floating terminal
map("n", "<leader>ft", function() Snacks.terminal(nil, { cwd = Util.get_root() }) end, { desc = "Terminal (Root Dir)" })
map("n", "<leader>fT", function() Snacks.terminal() end, { desc = "Terminal (cwd)" })
map("n", "<c-/>", function() Snacks.terminal(nil, { cwd = Util.get_root() }) end, { desc = "Terminal (Root Dir)" })
map("n", "<c-_>", function() Snacks.terminal(nil, { cwd = Util.get_root() }) end, { desc = "which_key_ignore" })

-- Window Management
map("n", "<leader>ww", "<C-W>p", { desc = "Other window", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true })
map("n", "<leader>w-", "<C-W>s", { desc = "Split window below", remap = true })
map("n", "<leader>w|", "<C-W>v", { desc = "Split window right", remap = true })
map("n", "<leader>-", "<C-W>s", { desc = "Split window below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split window right", remap = true })

-- --- Custom User Mappings (Ported) ---

-- Move line up and down wiht opt + shift + arrow up/down (User Preference)
map("n", "<M-Down>", "<cmd>m .+1<CR>==", { silent = true, desc = "Move line down" })
map("n", "<M-Up>", "<cmd>m .-2<CR>==", { silent = true, desc = "Move line up" })
map("i", "<M-Down>", "<esc><cmd>m .+1<cr>==gi", { silent = true, desc = "Move line down" })
map("i", "<M-Up>", "<esc><cmd>m .-2<cr>==gi", { silent = true, desc = "Move line up" })
map("v", "<M-Down>", ":m '>+1<cr>gv=gv", { silent = true, desc = "Move line down" })
map("v", "<M-Up>", ":m '<-2<cr>gv=gv", { silent = true, desc = "Move line up" })

-- Paste from clipboard without copying the old register
map("x", "p", [["_dP]], { silent = true, desc = "Paste from clipboard without copying the old register" })

-- "d" deletes the text and copies it to the black hole register
map("n", "d", '"_d', { silent = true, desc = "Delete text and copy to black hole register" })
map("v", "d", '"_d', { silent = true, desc = "Delete text and copy to black hole register" })
map("n", "dd", '"_dd', { silent = true, desc = "Delete line and copy to black hole register" })

-- Cut from clipboard without copying the old register
map("x", "<leader>x", [["_d]], { silent = true, desc = "Cut from clipboard without copying the old register" })
map("x", "<leader>d", [["_d]], { silent = true, desc = "Cut from clipboard without copying the old register" })

-- Save file
map({ "n", "x" }, "<leader>fs", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Find Git Modified Files (fzf-lua)
map("n", "<leader>gf", function()
  local ok, fzf = pcall(require, "fzf-lua")
  if not ok then
    vim.notify("fzf-lua non disponibile", vim.log.levels.ERROR)
    return
  end
  fzf.git_status()
end, { desc = "Trova file Git modificati" })

-- Tabs Navigation
map("n", "<leader><tab>h", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>l", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- Open config file
map("n", "<leader>xc", "<cmd>edit $MYVIMRC<cr>", { desc = "Open config file" })

-- Copilot.vim mappings (Explicit keymaps)
map("i", "<C-]>", "<Plug>(copilot-next)", { silent = true, desc = "Copilot next" })
map("i", "<C-[>", "<Plug>(copilot-prev)", { silent = true, desc = "Copilot prev" })
map("i", "<C-}>", "<Plug>(copilot-complete)", { silent = true, desc = "Copilot complete" })
map("i", "<C-{>", "<Plug>(copilot-dismiss)", { silent = true, desc = "Copilot dismiss" })

-- Prettier Manual Triggers
map({ "n", "v" }, "<leader>pp", "<cmd>Prettier<cr>", { silent = true, desc = "Prettier" })
map({ "n", "v" }, "<leader>pr", "<cmd>PrettierPartial<cr>", { silent = true, desc = "Prettier Partial" })
map({ "n", "v" }, "<leader>ps", "<cmd>PrettierFragment<cr>", { silent = true, desc = "Prettier Fragment" })

-- Change directory to current file
map("n", "<leader>td", "<cmd>cd %:p:h<cr>:pwd<cr>", { desc = "Change directory to current file" })

-- Git Signs Navigation
map("n", "<leader>gn", "<cmd>lua require('gitsigns').next_hunk()<cr>", { silent = true, desc = "Next Git Hunk" })
map("n", "<leader>gp", "<cmd>lua require('gitsigns').prev_hunk()<cr>", { silent = true, desc = "Previous Git Hunk" })

-- Floating terminal custom overrides (redundant with standard but kept for user preference)
map("n", "<leader>tT", function() Snacks.terminal() end, { desc = "Terminal (cwd)" })
map("n", "<leader>tt", function() Snacks.terminal(nil, { cwd = Util.get_root() }) end, { desc = "Terminal (Root Dir)" })

-- Restore arrows to normal j/k behavior
-- (Note: Standard LazyVim uses arrows for resize, user maps them to j/k. User pref wins here because it's applied last)
map({ "n", "x" }, "<Down>", "j", { desc = "Move cursor down" })
map({ "n", "x" }, "<Up>", "k", { desc = "Move cursor up" })

-- Execute Selected Python Code in a temporary file
vim.keymap.set("v", "<leader>r", function()
  -- Copy selection to register
  vim.cmd('normal! "+y')
  local code = vim.fn.getreg('+')
  
  -- Create temp file
  local temp_file = os.tmpname() .. ".py"
  local file = io.open(temp_file, "w")
  if not file then
    vim.notify("Errore nella creazione del file temporaneo", vim.log.levels.ERROR)
    return
  end
  file:write(code)
  file:close()
  
  -- Find or create python terminal
  local python_buf = vim.fn.bufnr('term://*python3')
  if python_buf == -1 then
    vim.cmd("botright split | terminal python3")
    vim.cmd("resize 15")
  else
    vim.cmd("buffer " .. python_buf)
  end
  
  -- Execute and clean up
  vim.cmd('startinsert')
  local command = string.format("exec(open('%s').read()); import os; os.remove('%s')\n",
    temp_file, temp_file)
  vim.api.nvim_feedkeys(command, 't', false)
  vim.defer_fn(function()
    vim.cmd('stopinsert')
  end, 500)
end, { desc = "Esegui selezione Python tramite file temporaneo" })

-- Execute Current Python File in REPL
vim.keymap.set("n", "<leader>rr", function()
  local current_file = vim.fn.expand('%:p')
  local file_extension = vim.fn.expand('%:e')
  
  if file_extension ~= 'py' then
    vim.notify("Il file corrente non è un file Python (.py)", vim.log.levels.WARN)
    return
  end
  
  local bufnr = vim.fn.bufnr('term://*python3')
  if bufnr == -1 then
    vim.cmd("botright split | terminal python3")
    vim.cmd("resize 15")
  else
    vim.cmd("buffer " .. bufnr)
  end
  
  vim.cmd('startinsert')
  local exec_command = string.format("exec(open('%s').read())\n", current_file)
  vim.api.nvim_feedkeys(exec_command, 't', false)
end, { desc = "Esegui file Python corrente in REPL" })

-- Escape terminal mode with ESC
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "ESC per uscire dal terminale" })

-- Close terminal on open
-- Adds keymaps to close the terminal window easily when it opens
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.keymap.set("n", "<leader>tt", "<cmd>bd!<CR>", { buffer = true, desc = "Chiudi terminale" })
    vim.keymap.set("n", "q", "<cmd>bd!<CR>", { buffer = true, desc = "Chiudi terminale" })
  end,
})

-- --- Light/Dark Mode Toggle ---
local function toggle_light_mode()
  if vim.o.background == "light" then
    vim.o.background = "dark"
    vim.cmd.colorscheme("tokyonight-moon")
  else
    vim.o.background = "light"
    vim.cmd.colorscheme("everforest")
  end
end

vim.api.nvim_create_user_command("ToggleLightMode", toggle_light_mode, {})
vim.keymap.set("n", "<leader>tl", toggle_light_mode, { desc = "Toggle Light Mode" })

-- --- Gitsigns Toggle Line Highlight ---
vim.keymap.set("n", "<leader>tg", function()
  local gitsigns = require("gitsigns")
  gitsigns.toggle_linehl()
  gitsigns.toggle_numhl()
end, { desc = "Toggle gitsigns line highlight" })
