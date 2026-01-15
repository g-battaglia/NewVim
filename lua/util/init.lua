local M = {}

---@class Util
---@field root_patterns string[] List of patterns used to detect project root (e.g., .git, lua)
M.root_patterns = { ".git", "lua" }

---@class UtilIcons
---@field misc table<string, string> Miscellaneous icons
---@field dap table<string, string|table> Debug Adapter Protocol icons
---@field diagnostics table<string, string> Diagnostic icons (Error, Warn, etc.)
---@field git table<string, string> Git status icons
---@field kinds table<string, string> Completion item kinds
M.icons = {
  misc = {
    dots = "󰇘",
  },
  dap = {
    Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
    Breakpoint = " ",
    BreakpointCondition = " ",
    BreakpointRejected = { " ", "DiagnosticError" },
    LogPoint = ".>",
  },
  diagnostics = {
    Error = " ",
    Warn = " ",
    Hint = " ",
    Info = " ",
  },
  git = {
    added = " ",
    modified = " ",
    removed = " ",
  },
  kinds = {
    Array = " ",
    Boolean = "󰨙 ",
    Class = " ",
    Codeium = "󰘦 ",
    Color = " ",
    Control = " ",
    Collapsed = " ",
    Constant = "󰏿 ",
    Constructor = " ",
    Copilot = " ",
    Enum = " ",
    EnumMember = " ",
    Event = " ",
    Field = " ",
    File = " ",
    Folder = " ",
    Function = "󰊕 ",
    Interface = " ",
    Key = " ",
    Keyword = " ",
    Method = "󰊕 ",
    Module = " ",
    Namespace = "󰦮 ",
    Null = " ",
    Number = "󰎠 ",
    Object = " ",
    Operator = " ",
    Package = " ",
    Property = " ",
    Reference = " ",
    Snippet = " ",
    String = " ",
    Struct = "󰆼 ",
    Text = " ",
    TypeParameter = " ",
    Unit = " ",
    Value = " ",
    Variable = "󰀫 ",
  },
}

---Gets the project root directory based on LSP or git patterns.
---Prioritizes LSP workspace folders, then LSP root_dir, then git/pattern matching.
---@return string The absolute path to the project root
function M.get_root()
  ---@type string?
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.loop.fs_realpath(path) or nil
  
  ---@type string[]
  local roots = {}
  
  if path then
    -- Try to get root from active LSP clients attached to the buffer
    for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
      local workspace = client.config.workspace_folders
      -- Prefer workspace folders if available, otherwise fallback to root_dir
      local paths = workspace and vim.tbl_map(function(ws)
        return vim.uri_to_fname(ws.uri)
      end, workspace) or client.config.root_dir and { client.config.root_dir } or {}
      
      for _, p in ipairs(paths) do
        local r = vim.loop.fs_realpath(p)
        if r then
          table.insert(roots, r)
        end
      end
    end
  end
  
  -- Sort roots by length (longest path first) to prefer more specific roots (nested projects)
  table.sort(roots, function(a, b)
    return #a > #b
  end)
  
  local root = roots[1]
  
  -- Fallback to pattern matching (e.g. .git directory) if no LSP root found
  if not root then
    path = path and vim.fs.dirname(path) or vim.loop.cwd()
    root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()
  end
  
  return root
end

---Toggle a vim option (boolean) or a pair of values.
---@param option string The vim option name (e.g., "spell", "wrap")
---@param silent? boolean If true, suppresses the notification message
---@param values? table Optional pair of values to toggle between (e.g., {true, false})
function M.toggle(option, silent, values)
  if values then
    if vim.opt_local[option]:get() == values[1] then
      vim.opt_local[option] = values[2]
    else
      vim.opt_local[option] = values[1]
    end
    return vim.notify("Set " .. option .. " to " .. vim.opt_local[option]:get())
  end
  
  vim.opt_local[option] = not vim.opt_local[option]:get()
  
  if not silent then
    if vim.opt_local[option]:get() then
      vim.notify("Enabled " .. option)
    else
      vim.notify("Disabled " .. option)
    end
  end
end

-- Internal state for diagnostics toggle
local diagnostics_active = true

---Toggles global diagnostics on/off.
---Updates the vim.diagnostic framework and sends a notification.
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

---Toggles LSP Inlay Hints on/off for the current buffer.
---Checks the current state and inverts it.
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

return M
