-- =============================================================================
-- NewVim - config/keymaps.lua
-- =============================================================================
-- Mappature “distro-like” + mappature personali.
--
-- NOTE IMPORTANTI
-- - Questo file è volutamente “verboso”: è il punto unico dove cercare *tutte*
--   le scorciatoie da tastiera.
-- - I mapping “standard” servono a replicare l’esperienza LazyVim.
-- - In fondo trovi i tuoi mapping personalizzati (portati 1:1).
--
-- Suggerimento:
-- - Usa `:FzfLua keymaps` oppure `:WhichKey` (se installato) per esplorare.
-- =============================================================================

local Util = require("util")

-- -----------------------------------------------------------------------------
-- Helper: definizione mapping con un minimo di “safety”
-- -----------------------------------------------------------------------------
-- Lazy può gestire alcuni mapping tramite handler interno.
-- Questa funzione evita di “sovrascrivere” mapping che Lazy considera attivi.
local function map(mode, lhs, rhs, opts)
	local keys = require("lazy.core.handler").handlers.keys
	---@cast keys LazyKeysHandler

	if not keys.active[keys.parse({ lhs, mode = mode }).id] then
		opts = opts or {}

		-- silent di default = true
		opts.silent = opts.silent ~= false

		-- se remap è richiesto, lo lasciamo solo fuori da contesti speciali (es. vscode)
		if opts.remap and not vim.g.vscode then
			opts.remap = nil
		end

		vim.keymap.set(mode, lhs, rhs, opts)
	end
end

-- =============================================================================
-- Navigazione
-- =============================================================================

-- Movimento “smart” su righe wrappate
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Navigazione tra finestre
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Resize finestre (ctrl + frecce)
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Sposta righe/blocchi (alt + j/k)
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- =============================================================================
-- Buffer
-- =============================================================================

map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- Snacks: gestione buffer più “gentile” (chiude senza spaccare layout)
map("n", "<leader>bd", function()
	Snacks.bufdelete()
end, { desc = "Delete Buffer" })
map("n", "<leader>bo", function()
	Snacks.bufdelete.other()
end, { desc = "Delete Other Buffers" })
map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

-- =============================================================================
-- Ricerca / editing
-- =============================================================================

-- Esc: pulisce hlsearch e torna in normal
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

-- Cerca parola sotto cursore
map({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })

-- n/N coerenti: sempre avanti/indietro (apre fold con zv)
map("n", "n", function()
	return (vim.v.searchforward == 1 and "n" or "N") .. "zv"
end, { expr = true, desc = "Next Search Result" })
map("x", "n", function()
	return (vim.v.searchforward == 1 and "n" or "N")
end, { expr = true, desc = "Next Search Result" })
map("o", "n", function()
	return (vim.v.searchforward == 1 and "n" or "N")
end, { expr = true, desc = "Next Search Result" })
map("n", "N", function()
	return (vim.v.searchforward == 1 and "N" or "n") .. "zv"
end, { expr = true, desc = "Prev Search Result" })
map("x", "N", function()
	return (vim.v.searchforward == 1 and "N" or "n")
end, { expr = true, desc = "Prev Search Result" })
map("o", "N", function()
	return (vim.v.searchforward == 1 and "N" or "n")
end, { expr = true, desc = "Prev Search Result" })

-- Undo breakpoints: rende l'undo più “fine” quando scrivi testo
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- Salva rapido
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- Keywordprg: richiama la doc della keyword sotto cursore
map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- Indent visual: mantiene selezione
map("v", "<", "<gv")
map("v", ">", ">gv")

-- =============================================================================
-- Tooling
-- =============================================================================

-- Lazy UI
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- Nuovo file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- Quickfix / loclist
map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })
map("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- Formattazione (Conform)
map({ "n", "v" }, "<leader>cf", function()
	require("conform").format({ lsp_fallback = true })
end, { desc = "Format" })

-- Diagnostica
local diagnostic_goto = function(next, severity)
	local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
	severity = severity and vim.diagnostic.severity[severity] or nil
	return function()
		go({ severity = severity })
	end
end
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "gl", vim.diagnostic.open_float, { desc = "Line Diagnostics (Quick)" })
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- Toggle
map("n", "<leader>uf", function()
	require("conform").format({ lsp_fallback = true })
end, { desc = "Format" })
map("n", "<leader>ud", Util.toggle_diagnostics, { desc = "Toggle Diagnostics" })
map("n", "<leader>us", function()
	Util.toggle("spell")
end, { desc = "Toggle Spelling" })
map("n", "<leader>uw", function()
	Util.toggle("wrap")
end, { desc = "Toggle Word Wrap" })
map("n", "<leader>uL", function()
	Util.toggle("relativenumber")
end, { desc = "Toggle Relative Numbers" })
map("n", "<leader>ul", function()
	Util.toggle("number")
end, { desc = "Toggle Line Numbers" })
map("n", "<leader>ih", Util.toggle_inlay_hints, { desc = "Toggle Inlay Hints" })

-- Quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- Inspect
map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
map("n", "<leader>uI", "<cmd>InspectTree<cr>", { desc = "Inspect Tree" })

-- Terminal (Snacks)
map("n", "<leader>ft", function()
	Snacks.terminal(nil, { cwd = Util.get_root() })
end, { desc = "Terminal (Root Dir)" })
map("n", "<leader>fT", function()
	Snacks.terminal()
end, { desc = "Terminal (cwd)" })
map("n", "<c-/>", function()
	Snacks.terminal(nil, { cwd = Util.get_root() })
end, { desc = "Terminal (Root Dir)" })
map("n", "<c-_>", function()
	Snacks.terminal(nil, { cwd = Util.get_root() })
end, { desc = "which_key_ignore" })

-- Gestione finestre (prefisso <leader>w)
map("n", "<leader>ww", "<C-W>p", { desc = "Other window", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true })
map("n", "<leader>w-", "<C-W>s", { desc = "Split below", remap = true })
map("n", "<leader>w|", "<C-W>v", { desc = "Split right", remap = true })
map("n", "<leader>-", "<C-W>s", { desc = "Split below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split right", remap = true })

-- =============================================================================
-- Mapping personali (portati)
-- =============================================================================

-- Sposta righe con Alt+Shift+Frecce
map("n", "<M-Down>", "<cmd>m .+1<CR>==", { silent = true, desc = "Move line down" })
map("n", "<M-Up>", "<cmd>m .-2<CR>==", { silent = true, desc = "Move line up" })
map("i", "<M-Down>", "<esc><cmd>m .+1<cr>==gi", { silent = true, desc = "Move line down" })
map("i", "<M-Up>", "<esc><cmd>m .-2<cr>==gi", { silent = true, desc = "Move line up" })
map("v", "<M-Down>", ":m '>+1<cr>gv=gv", { silent = true, desc = "Move line down" })
map("v", "<M-Up>", ":m '<-2<cr>gv=gv", { silent = true, desc = "Move line up" })

-- Paste “senza sporcare” il registro
map("x", "p", [["_dP]], { silent = true, desc = "Paste without yanking" })

-- d va nel blackhole register
map("n", "d", '"_d', { silent = true, desc = "Delete to blackhole" })
map("v", "d", '"_d', { silent = true, desc = "Delete to blackhole" })
map("n", "dd", '"_dd', { silent = true, desc = "Delete line to blackhole" })

-- Cut selezione senza copiare
map("x", "<leader>x", [["_d]], { silent = true, desc = "Cut (no yank)" })
map("x", "<leader>d", [["_d]], { silent = true, desc = "Cut (no yank)" })

-- Save
map({ "n", "x" }, "<leader>fs", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Trova i file modificati (Git)
vim.keymap.set("n", "<leader>gf", function()
	local ok, fzf = pcall(require, "fzf-lua")
	if not ok then
		vim.notify("fzf-lua non disponibile", vim.log.levels.ERROR)
		return
	end
	fzf.git_status()
end, { desc = "Trova file Git modificati" })

-- Tabs
map("n", "<leader><tab>h", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>l", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- Apri config
map("n", "<leader>xc", "<cmd>edit $MYVIMRC<cr>", { desc = "Open config file" })

-- Copilot
map("i", "<C-]>", "<Plug>(copilot-next)", { silent = true, desc = "Copilot next" })
map("i", "<C-[>", "<Plug>(copilot-prev)", { silent = true, desc = "Copilot prev" })
map("i", "<C-}>", "<Plug>(copilot-complete)", { silent = true, desc = "Copilot complete" })
map("i", "<C-{>", "<Plug>(copilot-dismiss)", { silent = true, desc = "Copilot dismiss" })

-- Prettier (compat): comandi & mapping tramite Conform
-- Nota: in questa config non usiamo un plugin "prettier" dedicato, quindi
--       definiamo noi i comandi :Prettier* per evitare E492.
local function conform_range_from_args(args)
	if args and args.count and args.count ~= -1 then
		local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1] or ""
		return {
			start = { args.line1, 0 },
			["end"] = { args.line2, end_line:len() },
		}
	end
	return nil
end

local function conform_range_from_visual()
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")
	local start_line = start_pos[2]
	local end_line = end_pos[2]

	if start_line == 0 or end_line == 0 then
		return nil
	end

	if start_line > end_line then
		start_line, end_line = end_line, start_line
	end

	local end_line_text = vim.api.nvim_buf_get_lines(0, end_line - 1, end_line, true)[1] or ""
	return {
		start = { start_line, 0 },
		["end"] = { end_line, end_line_text:len() },
	}
end

vim.api.nvim_create_user_command("Prettier", function(args)
	require("conform").format({
		lsp_fallback = true,
		range = conform_range_from_args(args),
	})
end, { range = true, desc = "Prettier (Conform)" })

vim.api.nvim_create_user_command("PrettierPartial", function(args)
	require("conform").format({
		lsp_fallback = true,
		range = conform_range_from_args(args),
	})
end, { range = true, desc = "Prettier Partial (Conform)" })

vim.api.nvim_create_user_command("PrettierFragment", function(args)
	require("conform").format({
		formatters = { "injected" },
		timeout_ms = 3000,
		lsp_fallback = true,
		range = conform_range_from_args(args),
	})
end, { range = true, desc = "Prettier Fragment (Conform)" })

map("n", "<leader>pp", "<cmd>Prettier<cr>", { silent = true, desc = "Prettier" })
map("v", "<leader>pp", function()
	require("conform").format({ lsp_fallback = true, range = conform_range_from_visual() })
end, { silent = true, desc = "Prettier" })

map("n", "<leader>pr", "<cmd>PrettierPartial<cr>", { silent = true, desc = "Prettier Partial" })
map("v", "<leader>pr", function()
	require("conform").format({ lsp_fallback = true, range = conform_range_from_visual() })
end, { silent = true, desc = "Prettier Partial" })

map("n", "<leader>ps", "<cmd>PrettierFragment<cr>", { silent = true, desc = "Prettier Fragment" })
map("v", "<leader>ps", function()
	require("conform").format({
		formatters = { "injected" },
		timeout_ms = 3000,
		lsp_fallback = true,
		range = conform_range_from_visual(),
	})
end, { silent = true, desc = "Prettier Fragment" })

-- cd al path del file corrente
map("n", "<leader>td", "<cmd>cd %:p:h<cr>:pwd<cr>", { desc = "cd to current file" })

-- Gitsigns: hunk next/prev
map("n", "<leader>gn", "<cmd>lua require('gitsigns').next_hunk()<cr>", { silent = true, desc = "Next Git Hunk" })
map("n", "<leader>gp", "<cmd>lua require('gitsigns').prev_hunk()<cr>", { silent = true, desc = "Prev Git Hunk" })

-- Terminal (override personale)
map("n", "<leader>tT", function()
	Snacks.terminal()
end, { desc = "Terminal (cwd)" })
map("n", "<leader>tt", function()
	Snacks.terminal(nil, { cwd = Util.get_root() })
end, { desc = "Terminal (Root Dir)" })

-- Frecce: ripristina j/k
map({ "n", "x" }, "<Down>", "j", { desc = "Move cursor down" })
map({ "n", "x" }, "<Up>", "k", { desc = "Move cursor up" })

-- Python: esegui selezione in REPL tramite file temporaneo
vim.keymap.set("v", "<leader>r", function()
	vim.cmd('normal! "+y')
	local code = vim.fn.getreg("+")

	local temp_file = os.tmpname() .. ".py"
	local file = io.open(temp_file, "w")
	if not file then
		vim.notify("Errore nella creazione del file temporaneo", vim.log.levels.ERROR)
		return
	end
	file:write(code)
	file:close()

	local python_buf = vim.fn.bufnr("term://*python3")
	if python_buf == -1 then
		vim.cmd("botright split | terminal python3")
		vim.cmd("resize 15")
	else
		vim.cmd("buffer " .. python_buf)
	end

	vim.cmd("startinsert")
	local command = string.format("exec(open('%s').read()); import os; os.remove('%s')\n", temp_file, temp_file)
	vim.api.nvim_feedkeys(command, "t", false)

	vim.defer_fn(function()
		vim.cmd("stopinsert")
	end, 500)
end, { desc = "Esegui selezione Python" })

-- Python: esegui file corrente in REPL
vim.keymap.set("n", "<leader>rr", function()
	local current_file = vim.fn.expand("%:p")
	if vim.fn.expand("%:e") ~= "py" then
		vim.notify("Il file corrente non è un file Python (.py)", vim.log.levels.WARN)
		return
	end

	local bufnr = vim.fn.bufnr("term://*python3")
	if bufnr == -1 then
		vim.cmd("botright split | terminal python3")
		vim.cmd("resize 15")
	else
		vim.cmd("buffer " .. bufnr)
	end

	vim.cmd("startinsert")
	vim.api.nvim_feedkeys(string.format("exec(open('%s').read())\n", current_file), "t", false)
end, { desc = "Esegui file Python in REPL" })

-- Terminal: ESC torna in normal
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- Terminal: mapping di chiusura su TermOpen
vim.api.nvim_create_autocmd("TermOpen", {
	callback = function()
		vim.keymap.set("n", "<leader>tt", "<cmd>bd!<CR>", { buffer = true, desc = "Chiudi terminale" })
		vim.keymap.set("n", "q", "<cmd>bd!<CR>", { buffer = true, desc = "Chiudi terminale" })
	end,
})

-- Tema: toggle light/dark
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

-- Gitsigns: toggle highlight
vim.keymap.set("n", "<leader>tg", function()
	local gitsigns = require("gitsigns")
	gitsigns.toggle_linehl()
	gitsigns.toggle_numhl()
end, { desc = "Toggle gitsigns highlight" })
