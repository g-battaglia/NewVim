-- =============================================================================
-- NewVim - plugins/which-key.lua
-- =============================================================================
-- which-key:
--   - mostra in overlay i mapping disponibili quando premi un prefisso
--   - utile quando si hanno molti keymap sotto <leader>
-- =============================================================================

return {
  "folke/which-key.nvim",
  event = "VeryLazy",

  opts = {
    -- In v3 si usa `spec` con una lista di gruppi.
    -- Qui definiamo solo “etichette” per raggruppare mapping.
    spec = {
      { "<leader>t", group = "+terminal" },
      { "<leader>p", group = "+prettier" },
      { "<leader>f", group = "+find" },
      { "<leader>s", group = "+search" },
      { "<leader>g", group = "+git" },
      { "<leader>x", group = "+diagnostics" },
      { "<leader>u", group = "+toggle" },
      { "<leader>q", group = "+session/quit" },
    },
  },
}
