-- =============================================================================
-- NewVim - init.lua
-- =============================================================================
-- Questo è l'entrypoint della configurazione.
-- Obiettivo: replicare l'esperienza “stile LazyVim” MA senza dipendere da LazyVim.
--
-- Ordine di caricamento (importante):
--   1) options   -> opzioni di base + override personali
--   2) logging   -> abilita log su file (notify/echo/error)
--   3) lazy      -> bootstrap lazy.nvim e carica i plugin
--   4) keymaps   -> mappature (molte richiedono plugin già presenti)
--   5) autocmds  -> automazioni/eventi
-- =============================================================================

-- 1) Opzioni: prima di tutto, per evitare flicker e comportamenti strani.
require("config.options")

-- 2) Logging: cattura notify/echo/error su file.
-- Va prima dei plugin così prende anche i messaggi di bootstrap.
require("config.logging").setup()

-- 3) Plugin manager: installa/carica i plugin.
require("config.lazy")

-- 4) Keymaps: dopo lazy, così i mapping “plugin-aware” hanno senso.
require("config.keymaps")

-- 5) Autocomandi: registrati per ultimi.
require("config.autocmds")
