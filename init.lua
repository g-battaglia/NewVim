-- =============================================================================
-- NewVim - init.lua
-- =============================================================================
-- Questo è l'entrypoint della configurazione.
-- Obiettivo: replicare l'esperienza “stile LazyVim” MA senza dipendere da LazyVim.
--
-- Ordine di caricamento (importante):
--   1) options   -> opzioni di base + override personali
--   2) lazy      -> bootstrap lazy.nvim e carica i plugin
--   3) keymaps   -> mappature (molte richiedono plugin già presenti)
--   4) autocmds  -> automazioni/eventi
-- =============================================================================

-- 1) Opzioni: prima di tutto, per evitare flicker e comportamenti strani.
require("config.options")

-- 2) Plugin manager: installa/carica i plugin.
require("config.lazy")

-- 3) Keymaps: dopo lazy, così i mapping “plugin-aware” hanno senso.
require("config.keymaps")

-- 4) Autocomandi: registrati per ultimi.
require("config.autocmds")
