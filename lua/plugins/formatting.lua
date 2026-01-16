-- =============================================================================
-- NewVim - plugins/formatting.lua
-- =============================================================================
-- Conform:
--   - formattazione uniforme, per-filetype
--   - alternativa leggera a null-ls
--
-- Scelte principali:
--   - Prettier: preferiamo prettierd se disponibile (daemon)
--   - Python  : isort -> black
--   - Lua     : stylua
-- =============================================================================

return {
  {
    "stevearc/conform.nvim",

    -- Carica prima del salvataggio (per format-on-save se lo abiliti)
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },

    keys = {
      {
        -- Formatta “linguaggi embedded” (es. JS dentro template, SQL dentro stringhe)
        "<leader>cF",
        function()
          require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
        end,
        mode = { "n", "v" },
        desc = "Format Injected",
      },
    },

    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },

        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        vue = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        scss = { "prettierd", "prettier", stop_after_first = true },
        less = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        jsonc = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        graphql = { "prettierd", "prettier", stop_after_first = true },
      },

      -- Se non esiste formatter dedicato, prova quello del LSP.
      default_format_opts = {
        lsp_format = "fallback",
      },
    },
  },
}
