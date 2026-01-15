-- =============================================================================
-- NewVim - plugins/fzf-lua.lua
-- =============================================================================
-- fzf-lua (root-aware)
--
-- In LazyVim, molte ricerche (files/grep) usano la “root del progetto” invece
-- della cwd corrente. Qui replichiamo quel comportamento usando `Util.get_root()`.
--
-- Regole:
-- - "(Root Dir)" usa `Util.get_root()`
-- - "(cwd)" usa `vim.uv.cwd()`
-- =============================================================================

local Util = require("util")

-- Helper: crea callback che chiama una funzione fzf-lua con opts
local function fzf(action, opts)
  return function()
    require("fzf-lua")[action](opts or {})
  end
end

-- Helper: root/cwd
local function root_dir()
  return Util.get_root()
end

local function cwd_dir()
  return vim.uv.cwd()
end

return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",

  keys = {
    -- -------------------------------------------------------------------------
    -- Files / Buffers
    -- -------------------------------------------------------------------------
    { "<leader>,", fzf("buffers", { sort_mru = true, sort_lastused = true }), desc = "Switch Buffer" },
    { "<leader><space>", fzf("files", { cwd = root_dir }), desc = "Find Files (Root Dir)" },

    { "<leader>fb", fzf("buffers", { sort_mru = true, sort_lastused = true }), desc = "Buffers" },
    { "<leader>fc", fzf("files", { cwd = vim.fn.stdpath("config") }), desc = "Find Config File" },

    { "<leader>ff", fzf("files", { cwd = root_dir }), desc = "Find Files (Root Dir)" },
    { "<leader>fF", fzf("files", { cwd = cwd_dir }), desc = "Find Files (cwd)" },

    -- Git tracked files (usa automaticamente il repo)
    { "<leader>fg", fzf("git_files"), desc = "Find Files (git-files)" },

    { "<leader>fr", fzf("oldfiles"), desc = "Recent" },

    -- -------------------------------------------------------------------------
    -- Grep
    -- -------------------------------------------------------------------------
    { "<leader>/", fzf("live_grep", { cwd = root_dir }), desc = "Grep (Root Dir)" },
    { "<leader>sg", fzf("live_grep", { cwd = root_dir }), desc = "Grep (Root Dir)" },
    { "<leader>sG", fzf("live_grep", { cwd = cwd_dir }), desc = "Grep (cwd)" },
    { "<leader>sb", fzf("grep_curbuf"), desc = "Grep Buffer" },

    -- Word/Selection search
    { "<leader>sw", fzf("grep_cword", { cwd = root_dir }), desc = "Word (Root Dir)" },
    { "<leader>sW", fzf("grep_cword", { cwd = cwd_dir }), desc = "Word (cwd)" },
    { "<leader>sw", fzf("grep_visual", { cwd = root_dir }), mode = "v", desc = "Selection (Root Dir)" },
    { "<leader>sW", fzf("grep_visual", { cwd = cwd_dir }), mode = "v", desc = "Selection (cwd)" },

    -- -------------------------------------------------------------------------
    -- Diagnostics
    -- -------------------------------------------------------------------------
    { "<leader>sd", fzf("diagnostics_document"), desc = "Document Diagnostics" },
    { "<leader>sD", fzf("diagnostics_workspace"), desc = "Workspace Diagnostics" },

    -- -------------------------------------------------------------------------
    -- Git
    -- -------------------------------------------------------------------------
    { "<leader>gc", fzf("git_commits"), desc = "Commits" },
    { "<leader>gs", fzf("git_status"), desc = "Status" },

    -- -------------------------------------------------------------------------
    -- Meta
    -- -------------------------------------------------------------------------
    { "<leader>:", fzf("command_history"), desc = "Command History" },
    { "<leader>sa", fzf("autocmds"), desc = "Auto Commands" },
    { "<leader>sc", fzf("command_history"), desc = "Command History" },
    { "<leader>sC", fzf("commands"), desc = "Commands" },
    { "<leader>sh", fzf("help_tags"), desc = "Help Pages" },
    { "<leader>sH", fzf("highlights"), desc = "Highlight Groups" },
    { "<leader>sk", fzf("keymaps"), desc = "Key Maps" },
    { "<leader>sM", fzf("man_pages"), desc = "Man Pages" },
    { "<leader>sm", fzf("marks"), desc = "Marks" },
    { "<leader>so", fzf("vim_options"), desc = "Options" },
    { "<leader>sR", fzf("resume"), desc = "Resume" },
    { "<leader>sq", fzf("quickfix"), desc = "Quickfix List" },
    { '<leader>s"', fzf("registers"), desc = "Registers" },

    -- -------------------------------------------------------------------------
    -- UI
    -- -------------------------------------------------------------------------
    { "<leader>uC", fzf("colorschemes"), desc = "Colorscheme (Preview)" },
  },

  opts = {
    winopts = {
      height = 0.85,
      width = 0.80,
      preview = { layout = "horizontal" },
    },
  },
}
