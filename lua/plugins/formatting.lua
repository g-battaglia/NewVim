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

        javascript = { { "prettierd", "prettier" } },
        typescript = { { "prettierd", "prettier" } },
        javascriptreact = { { "prettierd", "prettier" } },
        typescriptreact = { { "prettierd", "prettier" } },
        vue = { { "prettierd", "prettier" } },
        css = { { "prettierd", "prettier" } },
        scss = { { "prettierd", "prettier" } },
        less = { { "prettierd", "prettier" } },
        html = { { "prettierd", "prettier" } },
        json = { { "prettierd", "prettier" } },
        jsonc = { { "prettierd", "prettier" } },
        yaml = { { "prettierd", "prettier" } },
        markdown = { { "prettierd", "prettier" } },
        graphql = { { "prettierd", "prettier" } },
      },

      -- Se non esiste formatter dedicato, prova quello del LSP.
      default_format_opts = {
        lsp_format = "fallback",
      },
    },
  },
}
