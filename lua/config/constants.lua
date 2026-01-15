-- =============================================================================
-- NewVim - config/constants.lua
-- =============================================================================
-- Costanti/flag di configurazione centralizzati.
--
-- Scopo:
-- - avere un punto unico dove attivare/disattivare comportamenti senza dover
--   andare a caccia in N file.
-- - evitare “magic values” sparsi.
--
-- Nota:
-- - Questo file deve essere *semplice*: solo tabelle e valori.
-- - La logica sta nei moduli che consumano queste costanti.
-- =============================================================================

local M = {}

-- -----------------------------------------------------------------------------
-- Logging (config/logging.lua)
-- -----------------------------------------------------------------------------
-- Ogni flag abilita/disabilita *una parte* del logging.
--
-- Suggerimento:
-- - lascia `enabled = true` ma spegni i canali rumorosi.
-- - per un log super dettagliato abilita anche i wrapper dei comandi esterni.
M.logging = {
  -- Master switch
  enabled = true,

  -- Rotazione file (evita crescite infinite)
  max_bytes = 2 * 1024 * 1024, -- 2MB
  max_files = 3,

  -- Output esterni: limiti per non loggare megabyte di testo
  max_output_lines = 200,
  max_output_chars = 20000,

  -- Canali UI / messaggi
  hook_notify = true,
  hook_notify_once = true,
  hook_echo = true,
  hook_out_write = true,
  hook_err_write = true,
  hook_err_writeln = true,

  -- Cmdline: log dei comandi ":" e ricerche "/" "?"
  capture_cmdline = true,

  -- Dump di :messages alla chiusura
  dump_messages_on_exit = true,

  -- LSP: eventi di attach/detach (utile per capire cosa parte e quando)
  log_lsp_events = true,

  -- Wrapping comandi esterni
  hook_vim_system = true,     -- vim.system(...)
  hook_vim_fn_system = true,  -- vim.fn.system / systemlist
  hook_jobstart = true,       -- vim.fn.jobstart

  -- Wrapping Ex commands (molto verboso, ma davvero “completo”)
  -- Logga anche comandi eseguiti da plugin via API.
  hook_nvim_command = true,   -- vim.api.nvim_command("...")
  hook_nvim_cmd = true,       -- vim.api.nvim_cmd({cmd=...}, {})

  -- Super-verbose: log tasti premuti (può esplodere il file)
  -- Default: OFF.
  hook_on_key = false,
}

return M
