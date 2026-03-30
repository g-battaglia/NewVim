-- =============================================================================
-- NewVim - util/init.lua
-- =============================================================================
-- Modulo di utility “stile LazyVim”, ma minimale e trasparente.
--
-- Qui mettiamo:
--   - Root detection (per terminal, grep, picker, ecc.)
--   - Toggle rapidi (diagnostics, wrap, spell, …)
--   - Icone condivise (statusline, diagnostics, completion)
-- =============================================================================

local M = {}

-- -----------------------------------------------------------------------------
-- Root detection
-- -----------------------------------------------------------------------------
-- Pattern usati come fallback quando:
--   - non c'è LSP attaccato al buffer
--   - non esiste root_dir/workspace folder
M.root_patterns = { ".git", "lua" }

---Restituisce la root “migliore” per il buffer corrente.
---Priorità:
---  1) workspace folders LSP
---  2) root_dir LSP
---  3) fallback per pattern (.git, lua)
---@return string root_dir
function M.get_root()
  local bufname = vim.api.nvim_buf_get_name(0)
  local realpath = bufname ~= "" and vim.loop.fs_realpath(bufname) or nil

  -- Colleziona tutte le root candidate dai client LSP attivi sul buffer.
  local roots = {}
  if realpath then
    for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
      local workspace = client.config.workspace_folders

      local candidates = workspace
          and vim.tbl_map(function(ws)
            return vim.uri_to_fname(ws.uri)
          end, workspace)
        or (client.config.root_dir and { client.config.root_dir })
        or {}

      for _, p in ipairs(candidates) do
        local r = vim.loop.fs_realpath(p)
        if r then
          table.insert(roots, r)
        end
      end
    end
  end

  -- Se ci sono più root, scegli la più “specifica” (più lunga).
  table.sort(roots, function(a, b)
    return #a > #b
  end)

  local root = roots[1]

  -- Fallback: cerca .git / lua risalendo dalla directory del file
  if not root then
    local start = realpath and vim.fs.dirname(realpath) or vim.loop.cwd()
    local match = vim.fs.find(M.root_patterns, { path = start, upward = true })[1]
    root = match and vim.fs.dirname(match) or vim.loop.cwd()
  end

  return root
end

-- -----------------------------------------------------------------------------
-- Toggle
-- -----------------------------------------------------------------------------

---Toggle di un'opzione locale al buffer.
---
---Esempi:
---  Util.toggle("wrap")
---  Util.toggle("spell")
---
---@param option string nome opzione (es. "wrap")
---@param silent? boolean se true non notifica
---@param values? any[] coppia valori alternati (es. { "yes", "no" })
function M.toggle(option, silent, values)
  if values then
    vim.opt_local[option] = (vim.opt_local[option]:get() == values[1]) and values[2] or values[1]
    vim.notify("Set " .. option .. " to " .. tostring(vim.opt_local[option]:get()))
    return
  end

  vim.opt_local[option] = not vim.opt_local[option]:get()

  if not silent then
    vim.notify((vim.opt_local[option]:get() and "Enabled " or "Disabled ") .. option)
  end
end

-- Stato interno per toggle diagnostica
local diagnostics_active = true

---Abilita/disabilita la diagnostica globale (vim.diagnostic).
function M.toggle_diagnostics()
  diagnostics_active = not diagnostics_active
  if diagnostics_active then
    vim.diagnostic.enable()
    vim.notify("Enabled Diagnostics")
  else
    vim.diagnostic.disable()
    vim.notify("Disabled Diagnostics")
  end
end

---Toggle inlay hints LSP (Neovim 0.10+).
function M.toggle_inlay_hints()
  local ih = vim.lsp.inlay_hint
  if ih.is_enabled() then
    ih.enable(false)
    vim.notify("Disabled Inlay Hints")
  else
    ih.enable(true)
    vim.notify("Enabled Inlay Hints")
  end
end

-- -----------------------------------------------------------------------------
-- Icone
-- -----------------------------------------------------------------------------
-- Convenzione: tabella unica di icone per non duplicare stringhe in giro.
M.icons = {
  misc = {
    dots = "...",
  },
  diagnostics = {
    Error = "E ",
    Warn = "W ",
    Hint = "H ",
    Info = "I ",
  },
  git = {
    added = "+ ",
    modified = "~ ",
    removed = "- ",
  },
  dap = {
    Stopped = { "> ", "DiagnosticWarn", "DapStoppedLine" },
    Breakpoint = "B ",
    BreakpointCondition = "C ",
    BreakpointRejected = { "! ", "DiagnosticError" },
    LogPoint = "L>",
  },
  kinds = {
    Array = "[]",
    Boolean = "tf",
    Class = "C ",
    Codeium = "AI",
    Color = "# ",
    Control = "co",
    Collapsed = "> ",
    Constant = "c ",
    Constructor = "+ ",
    Copilot = "AI",
    Enum = "e ",
    EnumMember = "em",
    Event = "ev",
    Field = "f ",
    File = "F ",
    Folder = "D ",
    Function = "fn",
    Interface = "I ",
    Key = "k ",
    Keyword = "kw",
    Method = "m ",
    Module = "M ",
    Namespace = "N ",
    Null = "nl",
    Number = "1 ",
    Object = "{} ",
    Operator = "op",
    Package = "P ",
    Property = "p ",
    Reference = "r ",
    Snippet = "sn",
    String = "\" ",
    Struct = "S ",
    Text = "tx",
    TypeParameter = "tp",
    Unit = "u ",
    Value = "v ",
    Variable = "x ",
  },
}

return M
