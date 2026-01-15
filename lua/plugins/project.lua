-- =============================================================================
-- NewVim - plugins/project.lua
-- =============================================================================
-- project.nvim:
--   - rilevamento root del progetto (pattern)
--   - utile per tool/picker che dipendono dalla cwd
--
-- Nota importante:
-- Il modulo Lua si chiama `project_nvim` (underscore), non `project.nvim`.
-- Per questo NON usiamo `config = true` (che farebbe require automatico sbagliato).
-- =============================================================================

return {
  "ahmedkhalf/project.nvim",
  event = "VeryLazy",

  config = function(_, opts)
    require("project_nvim").setup(opts)
  end,

  opts = {
    manual_mode = false,

    -- Metodo di detection: qui usiamo pattern (più prevedibile).
    detection_methods = { "pattern" },

    -- File/dir che identificano la root.
    patterns = { "package.json", ".git", ".gitignore" },

    ignore_lsp = {},
    exclude_dirs = {},

    show_hidden = false,
    silent_chdir = false,
    scope_chdir = "global",

    datapath = vim.fn.stdpath("data"),
  },
}
