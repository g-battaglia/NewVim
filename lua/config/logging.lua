-- =============================================================================
-- NewVim - config/logging.lua
-- =============================================================================
-- Logging “globale” su file.
--
-- Premessa (importante):
-- Neovim non espone un singolo hook ufficiale per intercettare *qualsiasi* output
-- (messaggi UI, log plugin, echo vari) in modo perfetto.
--
-- Obiettivo pragmatico:
-- - salvare su file i messaggi più comuni e utili al debug:
--     1) `vim.notify(...)` (notifiche)
--     2) `vim.api.nvim_echo(...)` (molti plugin lo usano, es. treesitter)
--     3) `vim.api.nvim_err_writeln(...)` (errori)
-- - mantenere la UI normale (Noice può filtrare/spostare i messaggi, ma qui li
--   registriamo *prima* che arrivino alla UI).
--
-- File di log:
-- - `vim.fn.stdpath('state') .. '/newvim/nvim.log'`
--   (su macOS di solito: `~/.local/state/NewVim/newvim/nvim.log`)
-- =============================================================================

local M = {}

-- -----------------------------------------------------------------------------
-- Paths
-- -----------------------------------------------------------------------------

local function log_dir()
  return vim.fn.stdpath("state") .. "/newvim"
end

local function log_file()
  return log_dir() .. "/nvim.log"
end

-- -----------------------------------------------------------------------------
-- Low-level writer
-- -----------------------------------------------------------------------------

local function ensure_dir(path)
  if vim.uv.fs_stat(path) then
    return
  end
  pcall(vim.fn.mkdir, path, "p")
end

local function normalize_message(msg)
  if msg == nil then
    return "<nil>"
  end
  if type(msg) == "string" then
    return msg
  end
  -- Fallback: prova ad ispezionare valori complessi
  local ok, inspected = pcall(vim.inspect, msg)
  return ok and inspected or tostring(msg)
end

local function ts()
  -- Timestamp ISO-like, utile da grep
  return os.date("%Y-%m-%d %H:%M:%S")
end

local function append_line(line)
  ensure_dir(log_dir())
  local f = io.open(log_file(), "a")
  if not f then
    return
  end
  f:write(line)
  f:write("\n")
  f:close()
end

local function write(kind, msg)
  append_line(string.format("%s [%s] %s", ts(), kind, normalize_message(msg)))
end

-- -----------------------------------------------------------------------------
-- Wrappers
-- -----------------------------------------------------------------------------

-- Implementazioni originali (salvate quando facciamo attach)
M._notify_impl = nil
M._echo_impl = nil
M._err_impl = nil

function M.notify(msg, level, opts)
  write("notify", msg)
  if M._notify_impl then
    return M._notify_impl(msg, level, opts)
  end
end

function M.echo(chunks, history, opts)
  -- chunks = { {text, hl?}, ... }
  local parts = {}
  if type(chunks) == "table" then
    for _, c in ipairs(chunks) do
      if type(c) == "table" and c[1] then
        table.insert(parts, tostring(c[1]))
      end
    end
  end
  if #parts > 0 then
    write("echo", table.concat(parts, ""))
  end
  if M._echo_impl then
    return M._echo_impl(chunks, history, opts)
  end
end

function M.err_writeln(msg)
  write("error", msg)
  if M._err_impl then
    return M._err_impl(msg)
  end
end

---Aggancia i wrapper.
---
---Perché esiste `attach()` e non solo `setup()`?
---Alcuni plugin (es. nvim-notify/noice) possono riassegnare `vim.notify`.
---Noi vogliamo:
--- - catturare sempre su file
--- - delegare all'implementazione “attuale” per la UI
function M.attach()
  -- notify
  if vim.notify ~= M.notify then
    M._notify_impl = vim.notify
    vim.notify = M.notify
  end

  -- echo
  if vim.api.nvim_echo ~= M.echo then
    M._echo_impl = vim.api.nvim_echo
    vim.api.nvim_echo = M.echo
  end

  -- errors
  if vim.api.nvim_err_writeln ~= M.err_writeln then
    M._err_impl = vim.api.nvim_err_writeln
    vim.api.nvim_err_writeln = M.err_writeln
  end
end

-- -----------------------------------------------------------------------------
-- Public setup
-- -----------------------------------------------------------------------------

function M.setup()
  -- rende il path facilmente accessibile anche da :lua
  vim.g.newvim_log_file = log_file()

  -- attach subito (copre anche i log “early”)
  M.attach()

  -- re-attach dopo che i plugin UI si sono caricati
  vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("newvim_logging_attach", { clear = true }),
    pattern = "VeryLazy",
    callback = function()
      M.attach()
    end,
  })

  -- comandi utility
  vim.api.nvim_create_user_command("NewVimLogPath", function()
    vim.notify(vim.g.newvim_log_file)
  end, { desc = "Show NewVim log file path" })

  vim.api.nvim_create_user_command("NewVimLogOpen", function()
    vim.cmd("edit " .. vim.fn.fnameescape(vim.g.newvim_log_file))
  end, { desc = "Open NewVim log file" })

  vim.api.nvim_create_user_command("NewVimLogClear", function()
    ensure_dir(log_dir())
    local f = io.open(log_file(), "w")
    if f then
      f:write("")
      f:close()
    end
    vim.notify("NewVim log cleared: " .. vim.g.newvim_log_file)
  end, { desc = "Clear NewVim log file" })

  -- Nota: LSP ha un suo log separato.
  -- Utile quando debugghi problemi con server/handshake.
  pcall(function()
    write("info", "LSP log: " .. vim.lsp.get_log_path())
  end)
end

return M
