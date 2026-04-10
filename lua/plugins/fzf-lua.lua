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
-- Nota: fzf-lua vuole `opts.cwd` come stringa, non come funzione.
local function fzf(action, opts)
  return function()
    local o = opts and vim.deepcopy(opts) or {}

    if type(o.cwd) == "function" then
      o.cwd = o.cwd()
    end

    require("fzf-lua")[action](o)
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
    { 
      "<leader>gc", 
      fzf("git_commits", {
        actions = {
          ["default"] = function(selected, opts)
            if not selected or #selected == 0 then return end
            local commit_hash = selected[1]:match("[^ ]+")
            vim.cmd("DiffviewOpen " .. commit_hash .. "^!")
          end
        }
      }), 
      desc = "Esplora Diff Commit (Tutto il repo)" 
    },
    { 
      "<leader>gh", 
      fzf("git_bcommits", {
        actions = {
          ["default"] = function(selected, opts)
            if not selected or #selected == 0 then return end
            local commit_hash = selected[1]:match("[^ ]+")
            local current_file = vim.fn.expand("%")
            if current_file ~= "" then
              vim.cmd("DiffviewOpen " .. commit_hash .. "^! -- " .. vim.fn.fnameescape(current_file))
            else
              vim.cmd("DiffviewOpen " .. commit_hash .. "^!")
            end
          end
        }
      }), 
      desc = "History File Corrente (Fzf + Diffview)" 
    },
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

  config = function(_, opts)
    local fzf = require("fzf-lua")
    local actions = require("fzf-lua.actions")
    local path_mod = require("fzf-lua.path")

    -- Workaround: su Neovim 0.12 il cursore viene resettato dopo l'azione
    -- di default. Ri-posizioniamo via vim.schedule per essere sicuri.
    local orig = actions.file_edit_or_qf
    local function grep_edit(selected, o)
      orig(selected, o)
      if selected and #selected == 1 then
        vim.schedule(function()
          local entry = path_mod.entry_to_file(selected[1], o)
          if entry and entry.line > 0 then
            pcall(vim.api.nvim_win_set_cursor, 0,
              { entry.line, math.max(0, entry.col - 1) })
            vim.cmd("norm! zvzz")
          end
        end)
      end
    end

    opts.grep = vim.tbl_deep_extend("force", opts.grep or {}, {
      actions = { ["default"] = grep_edit },
    })

    fzf.setup(opts)
  end,

  opts = {
    winopts = {
      height = 0.85,
      width = 0.80,
      preview = { layout = "horizontal" },
    },
  },
}
