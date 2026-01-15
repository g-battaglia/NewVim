-- =============================================================================
-- NewVim - plugins/treesitter.lua
-- =============================================================================
-- Treesitter:
--   - parsing accurato per highlight/fold/indent
--   - installazione automatica dei parser richiesti
--
-- Nota: se vedi un warning "configs not found", di solito significa che il plugin
-- non è ancora stato installato completamente (o è stato reinstallato in quel momento).
-- =============================================================================

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",

    -- Carica treesitter quando apri un file (riduce lavoro all'avvio)
    event = { "BufReadPost", "BufNewFile" },

    -- Comandi utili
    cmd = { "TSUpdate", "TSInstall" },

    opts = {
      -- Parser da tenere installati
      ensure_installed = {
        "bash",
        "css",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luap",
        "markdown",
        "markdown_inline",
        "php",
        "phpdoc",
        "python",
        "query",
        "regex",
        "scss",
        "svelte",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "vue",
        "yaml",
      },

      -- Highlight basato su AST (più robusto del regex)
      highlight = { enable = true },

      -- Indentazione basata su AST (non perfetta per tutti i linguaggi, ma spesso utile)
      indent = { enable = true },
    },

    config = function(_, opts)
      -- Lazy a volte esegue config durante install/reload.
      -- Con pcall evitiamo hard-fail se il modulo non è ancora pronto.
      local ok, configs = pcall(require, "nvim-treesitter.configs")
      if not ok then
        vim.notify(
          "nvim-treesitter.configs not found. Plugin might be installing.",
          vim.log.levels.WARN
        )
        return
      end
      configs.setup(opts)
    end,
  },
}
