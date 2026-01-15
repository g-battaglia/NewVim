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

-- 0) Cache Lua: se Neovim cambia versione, invalida il bytecode cache.
-- Evita errori tipo: `module 'vim.lsp.client' not found` dopo upgrade.
do
  local cache_dir = vim.fn.stdpath("cache")
  local version_file = cache_dir .. "/nvim-version"
  local current = string.format("%d.%d.%d", vim.version().major, vim.version().minor, vim.version().patch)

  local ok_read, prev_lines = pcall(vim.fn.readfile, version_file)
  local prev = ok_read and prev_lines and prev_lines[1] or nil

  if prev ~= current then
    pcall(vim.fn.delete, cache_dir .. "/luac", "rf")
    pcall(vim.fn.writefile, { current }, version_file)
  end
end

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
