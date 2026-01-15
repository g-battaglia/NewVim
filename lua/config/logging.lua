-- =============================================================================
-- NewVim - config/logging.lua
-- =============================================================================
-- Logging “globale” su file (esteso) per debug.
--
-- Questa versione è configurabile tramite `lua/config/constants.lua`.
--
-- TL;DR
-- -----
-- - Config: `require('config.constants').logging`
-- - Path:   `:NewVimLogPath` / `:NewVimLogOpen`
-- - Toggle: `:NewVimLogDisable` / `:NewVimLogEnable`
--
-- Filosofia
-- ---------
-- Neovim non espone un singolo hook ufficiale per catturare “ogni cosa”.
-- Questa implementazione è molto completa e cattura:
--   - canali UI (notify/echo/out/err)
--   - comandi e ricerche da cmdline
--   - :messages in uscita
--   - LSP attach/detach
--   - (opzionale) tasti premuti (vim.on_key)
--   - (opzionale) comandi Ex lanciati da plugin (nvim_command/nvim_cmd)
--   - comandi esterni (vim.system, vim.fn.system, jobstart)
--
-- IMPORTANT: loggare “tutto” può diventare rumoroso e può includere informazioni
-- sensibili (comandi shell/path). Usa i flag per modulare.
-- =============================================================================

local M = {}

-- -----------------------------------------------------------------------------
-- Config: viene da config/constants.lua
-- -----------------------------------------------------------------------------

local defaults = {
  enabled = true,

  max_bytes = 2 * 1024 * 1024,
  max_files = 3,

  max_output_lines = 200,
  max_output_chars = 20000,

  hook_notify = true,
  hook_notify_once = true,
  hook_echo = true,
  hook_out_write = true,
  hook_err_write = true,
  hook_err_writeln = true,

  capture_cmdline = true,
  dump_messages_on_exit = true,
  log_lsp_events = true,

  hook_vim_system = true,
  hook_vim_fn_system = true,
  hook_jobstart = true,

  hook_nvim_command = true,
  hook_nvim_cmd = true,

  hook_on_key = false,
}

---@return table
local function load_config(overrides)
  local ok, constants = pcall(require, "config.constants")
  local from_constants = ok and constants.logging or {}
  return vim.tbl_deep_extend("force", defaults, from_constants, overrides or {})
end

-- cfg corrente (impostata in setup)
M.cfg = load_config()

-- -----------------------------------------------------------------------------
-- Paths
-- -----------------------------------------------------------------------------

local function log_dir()
  return vim.fn.stdpath("state") .. "/newvim"
end

local function log_file()
  return log_dir() .. "/nvim.log"
end

local function ensure_dir(path)
  if vim.uv.fs_stat(path) then
    return
  end
  pcall(vim.fn.mkdir, path, "p")
end

-- -----------------------------------------------------------------------------
-- Helpers
-- -----------------------------------------------------------------------------

local function ts()
  return os.date("%Y-%m-%d %H:%M:%S")
end

local function normalize_message(msg)
  if msg == nil then
    return "<nil>"
  end
  if type(msg) == "string" then
    return msg
  end
  local ok, inspected = pcall(vim.inspect, msg)
  return ok and inspected or tostring(msg)
end

local function safe_open(path, mode)
  local ok, f = pcall(io.open, path, mode)
  if not ok then
    return nil
  end
  return f
end

local function truncate_text(text)
  text = text or ""
  if #text > M.cfg.max_output_chars then
    return text:sub(1, M.cfg.max_output_chars) .. "\n<…truncated…>"
  end
  return text
end

local function truncate_lines(text)
  text = text or ""
  local out = {}
  local i = 0
  for line in text:gmatch("[^\n]*\n?") do
    if line == "" then
      break
    end
    i = i + 1
    if i > M.cfg.max_output_lines then
      table.insert(out, "<…truncated…>\n")
      break
    end
    table.insert(out, line)
  end
  return table.concat(out, "")
end

-- -----------------------------------------------------------------------------
-- Rotation
-- -----------------------------------------------------------------------------

local function rotate_if_needed()
  if not M.cfg.enabled then
    return
  end

  local stat = vim.uv.fs_stat(log_file())
  if not stat or not stat.size or stat.size < M.cfg.max_bytes then
    return
  end

  for i = M.cfg.max_files - 1, 1, -1 do
    local src = log_file() .. "." .. tostring(i)
    local dst = log_file() .. "." .. tostring(i + 1)
    if vim.uv.fs_stat(src) then
      pcall(vim.uv.fs_rename, src, dst)
    end
  end

  if vim.uv.fs_stat(log_file()) then
    pcall(vim.uv.fs_rename, log_file(), log_file() .. ".1")
  end
end

-- -----------------------------------------------------------------------------
-- Low-level writer
-- -----------------------------------------------------------------------------

local function append_line(line)
  if not M.cfg.enabled then
    return
  end

  ensure_dir(log_dir())
  rotate_if_needed()

  local f = safe_open(log_file(), "a")
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
-- Storage originali (per detach)
-- -----------------------------------------------------------------------------

M._notify_impl = nil
M._notify_once_impl = nil
M._echo_impl = nil
M._out_write_impl = nil
M._err_write_impl = nil
M._err_writeln_impl = nil

M._vim_system_impl = nil
M._fn_system_impl = nil
M._fn_systemlist_impl = nil
M._fn_jobstart_impl = nil

M._nvim_command_impl = nil
M._nvim_cmd_impl = nil

M._on_key_ns = nil

-- -----------------------------------------------------------------------------
-- Wrappers: notify/echo/out/err
-- -----------------------------------------------------------------------------

function M.notify(msg, level, opts)
  write("notify", msg)
  if M._notify_impl then
    return M._notify_impl(msg, level, opts)
  end
end

function M.notify_once(msg, level, opts)
  write("notify_once", msg)
  if M._notify_once_impl then
    return M._notify_once_impl(msg, level, opts)
  end
end

function M.echo(chunks, history, opts)
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

function M.out_write(text)
  if text and text ~= "" then
    write("out", text:gsub("\n$", ""))
  end
  if M._out_write_impl then
    return M._out_write_impl(text)
  end
end

function M.err_write(text)
  if text and text ~= "" then
    write("err", text:gsub("\n$", ""))
  end
  if M._err_write_impl then
    return M._err_write_impl(text)
  end
end

function M.err_writeln(text)
  if text and text ~= "" then
    write("error", text)
  end
  if M._err_writeln_impl then
    return M._err_writeln_impl(text)
  end
end

-- -----------------------------------------------------------------------------
-- Wrappers: comandi esterni (vim.system / vim.fn.system / jobstart)
-- -----------------------------------------------------------------------------

local function cmd_to_string(cmd)
  if type(cmd) == "string" then
    return cmd
  end
  if type(cmd) == "table" then
    return table.concat(vim.tbl_map(tostring, cmd), " ")
  end
  return tostring(cmd)
end

function M.vim_system(cmd, opts, on_exit)
  write("system", string.format("start: %s", cmd_to_string(cmd)))

  local function wrapped_on_exit(res)
    if res then
      write("system", string.format("exit code=%s signal=%s", tostring(res.code), tostring(res.signal)))
      if res.stderr and res.stderr ~= "" then
        write("system", "stderr:\n" .. truncate_lines(truncate_text(res.stderr)))
      end
      if res.stdout and res.stdout ~= "" then
        write("system", "stdout:\n" .. truncate_lines(truncate_text(res.stdout)))
      end
    end
    if on_exit then
      return on_exit(res)
    end
  end

  if M._vim_system_impl then
    return M._vim_system_impl(cmd, opts, on_exit and wrapped_on_exit or nil)
  end
end

function M.fn_system(cmd)
  write("fn.system", string.format("start: %s", cmd_to_string(cmd)))
  local out = M._fn_system_impl(cmd)
  write("fn.system", string.format("shell_error=%s", tostring(vim.v.shell_error)))
  if out and out ~= "" then
    write("fn.system", "stdout:\n" .. truncate_lines(truncate_text(out)))
  end
  return out
end

function M.fn_systemlist(cmd)
  write("fn.systemlist", string.format("start: %s", cmd_to_string(cmd)))
  local out = M._fn_systemlist_impl(cmd)
  write("fn.systemlist", string.format("shell_error=%s", tostring(vim.v.shell_error)))
  if type(out) == "table" and #out > 0 then
    write("fn.systemlist", "stdout:\n" .. truncate_lines(truncate_text(table.concat(out, "\n"))))
  end
  return out
end

function M.fn_jobstart(cmd, opts)
  write("jobstart", string.format("start: %s", cmd_to_string(cmd)))
  local jobid = M._fn_jobstart_impl(cmd, opts)
  write("jobstart", string.format("jobid=%s", tostring(jobid)))
  return jobid
end

-- -----------------------------------------------------------------------------
-- Wrappers: Ex commands lanciati via API
-- -----------------------------------------------------------------------------

function M.nvim_command(cmd)
  write("ex", cmd)
  return M._nvim_command_impl(cmd)
end

function M.nvim_cmd(cmd, opts)
  -- cmd è una tabella (es. { cmd = 'edit', args = { 'file' } })
  write("ex", "nvim_cmd: " .. truncate_text(normalize_message(cmd)))
  return M._nvim_cmd_impl(cmd, opts)
end

-- -----------------------------------------------------------------------------
-- Extra: LSP events
-- -----------------------------------------------------------------------------

local function setup_lsp_events()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("newvim_logging_lsp", { clear = true }),
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      if not client then
        return
      end
      write("lsp", string.format("attach client=%s(%s) buf=%s ft=%s", client.name, client.id, ev.buf, vim.bo[ev.buf].filetype))
    end,
  })

  vim.api.nvim_create_autocmd("LspDetach", {
    group = vim.api.nvim_create_augroup("newvim_logging_lsp_detach", { clear = true }),
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      if not client then
        return
      end
      write("lsp", string.format("detach client=%s(%s) buf=%s", client.name, client.id, ev.buf))
    end,
  })
end

-- -----------------------------------------------------------------------------
-- Extra: on_key (super verboso)
-- -----------------------------------------------------------------------------

local function setup_on_key()
  if M._on_key_ns then
    return
  end

  M._on_key_ns = vim.api.nvim_create_namespace("newvim_logging_on_key")

  vim.on_key(function(key)
    if not M.cfg.enabled then
      return
    end
    local mode = vim.api.nvim_get_mode().mode
    -- Log solo tasti “interessanti” (evita di esplodere troppo):
    -- se vuoi davvero tutto, togli questo filtro.
    if #key == 1 and key:match("%w") then
      return
    end
    write("key", string.format("mode=%s key=%s", mode, vim.fn.keytrans(key)))
  end, M._on_key_ns)
end

-- -----------------------------------------------------------------------------
-- Cmdline capture
-- -----------------------------------------------------------------------------

local function setup_cmdline_capture()
  vim.api.nvim_create_autocmd("CmdlineLeave", {
    group = vim.api.nvim_create_augroup("newvim_logging_cmdline", { clear = true }),
    callback = function()
      local ev = vim.v.event or {}
      local cmdtype = ev.cmdtype
      local cmdline = ev.cmdline
      if not cmdtype or not cmdline or cmdline == "" then
        return
      end

      if cmdtype == ":" then
        write("cmd", cmdline)
      elseif cmdtype == "/" or cmdtype == "?" then
        write("search", cmdtype .. cmdline)
      else
        write("cmdline", string.format("%s%s", cmdtype, cmdline))
      end
    end,
  })
end

-- -----------------------------------------------------------------------------
-- :messages dump
-- -----------------------------------------------------------------------------

local function dump_messages()
  local ok, out = pcall(vim.api.nvim_exec2, "messages", { output = true })
  if ok and out and out.output and out.output ~= "" then
    write("messages", "---- messages dump start ----")
    for line in out.output:gmatch("[^\n]+") do
      write("messages", line)
    end
    write("messages", "---- messages dump end ----")
  end
end

-- -----------------------------------------------------------------------------
-- Startup info
-- -----------------------------------------------------------------------------

local function write_startup_info()
  write("info", "cwd: " .. (vim.uv.cwd() or "<unknown>"))

  local v = vim.version()
  write("info", string.format("nvim version: %s.%s.%s", v.major, v.minor, v.patch))

  pcall(function()
    write("info", "LSP log: " .. vim.lsp.get_log_path())
  end)
end

-- -----------------------------------------------------------------------------
-- Attach / Detach
-- -----------------------------------------------------------------------------

function M.attach()
  -- notify
  if M.cfg.hook_notify and vim.notify ~= M.notify then
    M._notify_impl = vim.notify
    vim.notify = M.notify
  end

  if M.cfg.hook_notify_once and vim.notify_once and vim.notify_once ~= M.notify_once then
    M._notify_once_impl = vim.notify_once
    vim.notify_once = M.notify_once
  end

  -- echo
  if M.cfg.hook_echo and vim.api.nvim_echo ~= M.echo then
    M._echo_impl = vim.api.nvim_echo
    vim.api.nvim_echo = M.echo
  end

  -- out/err
  if M.cfg.hook_out_write and vim.api.nvim_out_write ~= M.out_write then
    M._out_write_impl = vim.api.nvim_out_write
    vim.api.nvim_out_write = M.out_write
  end

  if M.cfg.hook_err_write and vim.api.nvim_err_write ~= M.err_write then
    M._err_write_impl = vim.api.nvim_err_write
    vim.api.nvim_err_write = M.err_write
  end

  if M.cfg.hook_err_writeln and vim.api.nvim_err_writeln ~= M.err_writeln then
    M._err_writeln_impl = vim.api.nvim_err_writeln
    vim.api.nvim_err_writeln = M.err_writeln
  end

  -- vim.system
  if M.cfg.hook_vim_system and vim.system and vim.system ~= M.vim_system then
    M._vim_system_impl = vim.system
    vim.system = M.vim_system
  end

  -- vim.fn.system/systemlist/jobstart
  if M.cfg.hook_vim_fn_system and vim.fn.system and vim.fn.system ~= M.fn_system then
    M._fn_system_impl = vim.fn.system
    vim.fn.system = M.fn_system
  end

  if M.cfg.hook_vim_fn_system and vim.fn.systemlist and vim.fn.systemlist ~= M.fn_systemlist then
    M._fn_systemlist_impl = vim.fn.systemlist
    vim.fn.systemlist = M.fn_systemlist
  end

  if M.cfg.hook_jobstart and vim.fn.jobstart and vim.fn.jobstart ~= M.fn_jobstart then
    M._fn_jobstart_impl = vim.fn.jobstart
    vim.fn.jobstart = M.fn_jobstart
  end

  -- nvim_command / nvim_cmd
  if M.cfg.hook_nvim_command and vim.api.nvim_command ~= M.nvim_command then
    M._nvim_command_impl = vim.api.nvim_command
    vim.api.nvim_command = M.nvim_command
  end

  if M.cfg.hook_nvim_cmd and vim.api.nvim_cmd ~= M.nvim_cmd then
    M._nvim_cmd_impl = vim.api.nvim_cmd
    vim.api.nvim_cmd = M.nvim_cmd
  end

  -- on_key
  if M.cfg.hook_on_key then
    setup_on_key()
  end
end

function M.detach()
  if M._notify_impl then
    vim.notify = M._notify_impl
  end
  if M._notify_once_impl then
    vim.notify_once = M._notify_once_impl
  end
  if M._echo_impl then
    vim.api.nvim_echo = M._echo_impl
  end
  if M._out_write_impl then
    vim.api.nvim_out_write = M._out_write_impl
  end
  if M._err_write_impl then
    vim.api.nvim_err_write = M._err_write_impl
  end
  if M._err_writeln_impl then
    vim.api.nvim_err_writeln = M._err_writeln_impl
  end

  if M._vim_system_impl then
    vim.system = M._vim_system_impl
  end

  if M._fn_system_impl then
    vim.fn.system = M._fn_system_impl
  end
  if M._fn_systemlist_impl then
    vim.fn.systemlist = M._fn_systemlist_impl
  end
  if M._fn_jobstart_impl then
    vim.fn.jobstart = M._fn_jobstart_impl
  end

  if M._nvim_command_impl then
    vim.api.nvim_command = M._nvim_command_impl
  end
  if M._nvim_cmd_impl then
    vim.api.nvim_cmd = M._nvim_cmd_impl
  end

  -- disabilita callback on_key
  if M._on_key_ns then
    vim.on_key(nil, M._on_key_ns)
    M._on_key_ns = nil
  end
end

-- -----------------------------------------------------------------------------
-- Public setup
-- -----------------------------------------------------------------------------

function M.setup(opts)
  -- Ricalcola config e applica.
  M.cfg = load_config(opts)

  vim.g.newvim_log_file = log_file()

  -- attach subito (copre log early)
  M.attach()

  -- info iniziali
  write_startup_info()

  -- cmdline capture
  if M.cfg.capture_cmdline then
    setup_cmdline_capture()
  end

  -- LSP events
  if M.cfg.log_lsp_events then
    setup_lsp_events()
  end

  -- re-attach dopo VeryLazy (plugin UI possono riassegnare notify/echo)
  vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("newvim_logging_attach", { clear = true }),
    pattern = "VeryLazy",
    callback = function()
      M.attach()
    end,
  })

  -- dump messages in uscita
  if M.cfg.dump_messages_on_exit then
    vim.api.nvim_create_autocmd("VimLeavePre", {
      group = vim.api.nvim_create_augroup("newvim_logging_vimleave", { clear = true }),
      callback = function()
        dump_messages()
      end,
    })
  end

  -- comandi utility
  vim.api.nvim_create_user_command("NewVimLogPath", function()
    vim.notify(vim.g.newvim_log_file)
  end, { desc = "Show NewVim log file path" })

  vim.api.nvim_create_user_command("NewVimLogOpen", function()
    vim.cmd("edit " .. vim.fn.fnameescape(vim.g.newvim_log_file))
  end, { desc = "Open NewVim log file" })

  vim.api.nvim_create_user_command("NewVimLogClear", function()
    ensure_dir(log_dir())
    local f = safe_open(log_file(), "w")
    if f then
      f:write("")
      f:close()
    end
    vim.notify("NewVim log cleared: " .. vim.g.newvim_log_file)
  end, { desc = "Clear NewVim log file" })

  vim.api.nvim_create_user_command("NewVimLogDisable", function()
    M.cfg.enabled = false
    M.detach()
    vim.notify("NewVim logging disabled")
  end, { desc = "Disable NewVim logging (detach hooks)" })

  vim.api.nvim_create_user_command("NewVimLogEnable", function()
    M.cfg.enabled = true
    M.attach()
    vim.notify("NewVim logging enabled")
  end, { desc = "Enable NewVim logging (attach hooks)" })
end

return M
