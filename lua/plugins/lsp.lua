-- =============================================================================
-- NewVim - plugins/lsp.lua
-- =============================================================================
-- Setup LSP in stile “distro”:
--   - Mason installa i binari (server LSP, tool)
--   - mason-lspconfig collega Mason con nvim-lspconfig
--   - config.servers fornisce override per i server “speciali”
--
-- Nota: nvim-lspconfig sta migrando verso `vim.lsp.config` (Neovim 0.11).
-- Qui restiamo su nvim-lspconfig per compatibilità, sapendo che in futuro
-- andrà aggiornata questa parte.
-- =============================================================================

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },

    opts = {
      -- Inlay hints: spesso utili ma “visivamente rumorosi”.
      -- Disabilitati di default; toggle via keymap (vedi util/keymaps).
      inlay_hints = { enabled = false },
    },

    config = function(_, _)
      -- -----------------------------------------------------------------------
      -- 1) Mason: gestisce installazione pacchetti
      -- -----------------------------------------------------------------------
      require("mason").setup()

      -- Server LSP (nomi nvim-lspconfig / mason-lspconfig, NON nomi pacchetto Mason)
      local lsp_servers = {
        "cssls",
        "emmet_ls",
        "eslint",
        "html",
        "intelephense",
        "jsonls",
        "lua_ls",
        "phpactor",
        "pyright",
        "pylsp",
        "ts_ls",
        "volar",
        "prismals",
      }

      -- Tool non-LSP (nomi pacchetto Mason) usati da formatter/linter
      -- (es. conform.nvim in `lua/plugins/formatting.lua`)
      local tools = {
        "stylua",
        "shfmt",
        "prettierd",
        "prettier",
        "black",
        "isort",
      }

      local has_tool_installer, mason_tool_installer = pcall(require, "mason-tool-installer")
      if has_tool_installer then
        mason_tool_installer.setup({
          ensure_installed = tools,
          run_on_start = true,
        })
      end

      -- -----------------------------------------------------------------------
      -- 2) Capabilities: dice ai server cosa supporta l'editor
      -- -----------------------------------------------------------------------
      local capabilities = vim.lsp.protocol.make_client_capabilities()

      -- LazyVim-style: aiuta i server LSP a mandare folding ranges a ufo.
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      -- Se c'è nvim-cmp, aggiunge capabilities per completion/snippets.
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if has_cmp then
        capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
      end

      -- Se c'è blink.cmp, aggiunge/aggiorna capabilities.
      local has_blink, blink = pcall(require, "blink.cmp")
      if has_blink then
        capabilities = blink.get_lsp_capabilities(capabilities)
      end

      -- -----------------------------------------------------------------------
      -- 3) Config per-server: viene da config/servers.lua
      -- -----------------------------------------------------------------------
      -- Il file NON chiama setup direttamente: restituisce una tabella.
      local servers = require("config.servers")

      -- -----------------------------------------------------------------------
      -- 4) mason-lspconfig: auto-setup di tutti i server installati
      -- -----------------------------------------------------------------------
      require("mason-lspconfig").setup({
        ensure_installed = lsp_servers,
        automatic_installation = true,
        handlers = {
          function(server_name)
            -- Config server-specific (se presente)
            local server_config = servers[server_name] or {}

            -- Merge capabilities di base + eventuali override del server
            server_config.capabilities = vim.tbl_deep_extend(
              "force",
              capabilities,
              server_config.capabilities or {}
            )

            -- Setup del server
            require("lspconfig")[server_name].setup(server_config)
          end,
        },
      })
    end,
  },
}
