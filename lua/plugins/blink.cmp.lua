-- =============================================================================
-- NewVim - plugins/blink.cmp.lua
-- =============================================================================
-- blink.cmp:
--   - completion engine moderno
--   - può (opzionalmente) abilitare completion anche in cmdline (":")
--
-- Richiesta utente:
--   - niente autocomplete mentre si scrivono comandi nel prompt ":"
--     => disabilitiamo la cmdline completion di blink
-- =============================================================================

return {
  {
    "saghen/blink.cmp",
    dependencies = "rafamadriz/friendly-snippets",
    version = "*",

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- Keymap preset base (stile nvim-cmp)
      keymap = { preset = "default" },

      -- Aspetto delle icone/menu
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },

      -- Sorgenti completion nei buffer
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },

      -- Behaviour lista completion
      completion = {
        list = {
          selection = {
            preselect = false,
          },
        },
      },

      -- Cmdline completion (":", "/", "?")
      -- Disabilitata per evitare l'autocomplete nel prompt dei comandi.
      cmdline = {
        enabled = false,
      },
    },
  },
}
