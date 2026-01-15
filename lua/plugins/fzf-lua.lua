-- =============================================================================
-- NewVim - plugins/fzf-lua.lua
-- =============================================================================
-- fzf-lua:
--   - fuzzy finder super veloce (file, grep, buffer, git, ecc.)
--
-- Nota:
-- Alcune voci qui sono etichettate “Root Dir” per coerenza con LazyVim.
-- Se vuoi la root *vera* (LSP/.git), si può integrare Util.get_root() nei cmd.
-- Per ora lasciamo i comandi standard di fzf-lua.
-- =============================================================================

return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",

  -- ---------------------------------------------------------------------------
  -- Keymaps
  -- ---------------------------------------------------------------------------
  keys = {
    -- File / buffer
    { "<leader>,", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Switch Buffer" },
    { "<leader><space>", "<cmd>FzfLua files<cr>", desc = "Find Files (Root Dir)" },
    { "<leader>fb", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
    { "<leader>fc", "<cmd>FzfLua files cwd=vim.fn.stdpath('config')<cr>", desc = "Find Config File" },
    { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find Files (Root Dir)" },
    { "<leader>fF", "<cmd>FzfLua files cwd=false<cr>", desc = "Find Files (cwd)" },
    { "<leader>fg", "<cmd>FzfLua git_files<cr>", desc = "Find Files (git-files)" },
    { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent" },
    { "<leader>fR", "<cmd>FzfLua oldfiles cwd=vim.loop.cwd()<cr>", desc = "Recent (cwd)" },

    -- Grep
    { "<leader>/", "<cmd>FzfLua live_grep<cr>", desc = "Grep (Root Dir)" },
    { "<leader>sg", "<cmd>FzfLua live_grep<cr>", desc = "Grep (Root Dir)" },
    { "<leader>sG", "<cmd>FzfLua live_grep cwd=false<cr>", desc = "Grep (cwd)" },
    { "<leader>sb", "<cmd>FzfLua grep_curbuf<cr>", desc = "Grep Buffer" },

    -- Ricerca “meta”
    { "<leader>:", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
    { "<leader>sa", "<cmd>FzfLua autocmds<cr>", desc = "Auto Commands" },
    { "<leader>sc", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
    { "<leader>sC", "<cmd>FzfLua commands<cr>", desc = "Commands" },
    { "<leader>sh", "<cmd>FzfLua help_tags<cr>", desc = "Help Pages" },
    { "<leader>sH", "<cmd>FzfLua highlights<cr>", desc = "Highlight Groups" },
    { "<leader>sk", "<cmd>FzfLua keymaps<cr>", desc = "Key Maps" },
    { "<leader>sM", "<cmd>FzfLua man_pages<cr>", desc = "Man Pages" },
    { "<leader>sm", "<cmd>FzfLua marks<cr>", desc = "Marks" },
    { "<leader>so", "<cmd>FzfLua vim_options<cr>", desc = "Options" },
    { "<leader>sR", "<cmd>FzfLua resume<cr>", desc = "Resume" },
    { "<leader>sq", "<cmd>FzfLua quickfix<cr>", desc = "Quickfix List" },

    -- Diagnostica (integrata)
    { "<leader>sd", "<cmd>FzfLua diagnostics_document<cr>", desc = "Document Diagnostics" },
    { "<leader>sD", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Workspace Diagnostics" },

    -- Ricerca parole/selezione
    { "<leader>sw", "<cmd>FzfLua grep_cword<cr>", desc = "Word (Root Dir)" },
    { "<leader>sW", "<cmd>FzfLua grep_cword cwd=false<cr>", desc = "Word (cwd)" },
    { "<leader>sw", "<cmd>FzfLua grep_visual<cr>", mode = "v", desc = "Selection (Root Dir)" },
    { "<leader>sW", "<cmd>FzfLua grep_visual cwd=false<cr>", mode = "v", desc = "Selection (cwd)" },

    -- Git
    { "<leader>gc", "<cmd>FzfLua git_commits<cr>", desc = "Commits" },
    { "<leader>gs", "<cmd>FzfLua git_status<cr>", desc = "Status" },

    -- UI
    { "<leader>uC", "<cmd>FzfLua colorschemes<cr>", desc = "Colorscheme (Preview)" },
    { '<leader>s"', "<cmd>FzfLua registers<cr>", desc = "Registers" },
  },

  -- ---------------------------------------------------------------------------
  -- Opzioni
  -- ---------------------------------------------------------------------------
  opts = {
    winopts = {
      height = 0.85,
      width = 0.80,
      preview = { layout = "horizontal" },
    },
  },
}
