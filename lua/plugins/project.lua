-- =============================================================================
-- NewVim - plugins/project.lua
-- =============================================================================
-- project.nvim:
--   - tiene traccia della cronologia dei progetti (utile per un picker "progetti")
--   - NON cambia più la cwd all'apertura dei file (manual_mode = true)
--
-- Comportamento cwd:
--   Aprirlo una cartella con nvim => la root resta SEMPRE quella cartella,
--   indipendentemente dai repo .git superiori. project.nvim è in modalità
--   manuale: registra i progetti ma non tocca la working directory.
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

    -- Fix E944: glob() interpreta [] come character class nei path.
    -- Usiamo fs_stat che non fa glob expansion.
    local path = require("project_nvim.utils.path")
    path.exists = function(p)
      return vim.uv.fs_stat(p) ~= nil
    end
  end,

  opts = {
    -- true = NON cambiare la cwd all'apertura di un file.
    -- La root resta sempre la cartella da cui hai lanciato nvim,
    -- anche se c'è un repo .git in una directory superiore.
    manual_mode = true,

    -- Metodo di detection: qui usiamo pattern (più prevedibile).
    detection_methods = { "pattern" },

    -- File/dir che identificano la root.
    patterns = { "pyproject.toml", "package.json", ".git", ".gitignore" },

    ignore_lsp = {},
    exclude_dirs = {},

    show_hidden = false,

    -- In manual_mode queste due opzioni sono ininfluenti: project.nvim
    -- non chiama chdir in automatico. Le lasciamo per completezza.
    silent_chdir = false,
    scope_chdir = "global",

    datapath = vim.fn.stdpath("data"),
  },
}
