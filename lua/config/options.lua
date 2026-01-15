-- =============================================================================
-- NewVim - config/options.lua
-- =============================================================================
-- Qui vivono le tue preferenze personali.
--
-- Regola pratica:
-- - `config/defaults.lua` = default “generici” tipo LazyVim
-- - `config/options.lua`  = override *specifici* dell'utente
-- =============================================================================

-- Carica prima i default
require("config.defaults")

-- -----------------------------------------------------------------------------
-- Spell
-- -----------------------------------------------------------------------------
-- Dizionari: inglese US + italiano
vim.o.spelllang = "en_us,it"
vim.o.spell = true

-- -----------------------------------------------------------------------------
-- UI / numeri di riga
-- -----------------------------------------------------------------------------
-- Preferenza: niente numeri relativi
vim.opt.relativenumber = false

-- -----------------------------------------------------------------------------
-- Autoformat
-- -----------------------------------------------------------------------------
-- Flag che alcuni plugin/flow possono usare per decidere se formattare o no.
-- (Conform ha mapping manuali, quindi qui possiamo tenerlo off.)
vim.g.autoformat = false

-- -----------------------------------------------------------------------------
-- File explorer
-- -----------------------------------------------------------------------------
-- Compat: settaggio storico da NvimTree (anche se ora usi Neo-tree).
vim.g.nvim_tree_respect_buf_cwd = 1

-- -----------------------------------------------------------------------------
-- Whitespace
-- -----------------------------------------------------------------------------
vim.opt.list = true
vim.opt.listchars = { space = "⋅", tab = "→ " }

-- -----------------------------------------------------------------------------
-- Root detection
-- -----------------------------------------------------------------------------
-- In LazyVim esiste un sistema di root detection; qui lasciamo un hint globale.
-- NOTA: la root “vera” è gestita da `lua/util/init.lua` (Util.get_root()).
vim.g.root_spec = { "lsp", { "package.json", ".git", "lua" }, "cwd" }

-- -----------------------------------------------------------------------------
-- Folding
-- -----------------------------------------------------------------------------
-- Usa treesitter per fold.
-- foldlevel alto = parti con tutto aperto, poi puoi chiudere manualmente.
vim.opt.foldlevel = 99
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldmethod = "expr"

-- -----------------------------------------------------------------------------
-- Conceal
-- -----------------------------------------------------------------------------
-- Disabilita conceal per evitare sorprese (es. JSON/Markdown).
vim.opt.conceallevel = 0
