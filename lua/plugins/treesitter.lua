-- =============================================================================
-- NewVim - plugins/treesitter.lua
-- =============================================================================
-- NOTE IMPORTANTE (Neovim 0.11 / nvim-treesitter “nuovo”):
--
-- Il plugin nvim-treesitter ha cambiato struttura interna:
--   - il modulo `nvim-treesitter.configs` NON esiste più
--   - ora esistono `nvim-treesitter` + `nvim-treesitter.config`
--
-- Quindi in questa config facciamo due cose “semplici e robuste”:
--   1) Installiamo i parser richiesti (se mancanti)
--   2) Avviamo Tree-sitter nei buffer (highlight/foldexpr funzionano)
-- =============================================================================

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",

    -- Carica quando serve (apertura file)
    event = { "BufReadPost", "BufNewFile" },

    -- Comandi utili per manutenzione parser
    cmd = { "TSUpdate", "TSInstall" },

    -- Lista parser “desiderati”.
    -- NB: non è la vecchia `ensure_installed` di configs.lua; qui la gestiamo noi.
    opts = {
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
    },

    config = function(_, opts)
      -- -----------------------------------------------------------------------
      -- 1) Setup base di nvim-treesitter (config interna: install_dir, ecc.)
      -- -----------------------------------------------------------------------
      -- In questa versione del plugin la “setup” gestisce config generica.
      local ok_ts, ts = pcall(require, "nvim-treesitter")
      if ok_ts then
        ts.setup({})
      end

      -- -----------------------------------------------------------------------
      -- 2) Install parser mancanti
      -- -----------------------------------------------------------------------
      local ok_install, install = pcall(require, "nvim-treesitter.install")
      if ok_install and opts.ensure_installed then
        -- Non blocchiamo l'avvio: install è async.
        install.install(opts.ensure_installed, { summary = false })
      end

      -- -----------------------------------------------------------------------
      -- 3) Avvia Tree-sitter per i buffer
      -- -----------------------------------------------------------------------
      -- Questo rende effettivi:
      --   - highlight tree-sitter
      --   - foldexpr = vim.treesitter.foldexpr()
      -- Se manca il parser per un buffer, pcall evita errori.
      vim.api.nvim_create_autocmd({ "FileType" }, {
        group = vim.api.nvim_create_augroup("newvim_treesitter_start", { clear = true }),
        callback = function(ev)
          pcall(vim.treesitter.start, ev.buf)
        end,
      })
    end,
  },
}
