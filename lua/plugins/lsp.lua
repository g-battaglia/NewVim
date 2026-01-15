return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim", -- Manages external tooling (LSP servers, linters)
      "williamboman/mason-lspconfig.nvim", -- Bridges Mason with lspconfig
    },
    opts = {
      -- Inlay hints are the type hints shown inline in the code.
      -- Disabled by default to reduce visual clutter, can be toggled via keymap <leader>ih.
      inlay_hints = { enabled = false },
    },
    config = function(_, opts)
      -- 1. Setup Mason: This handles the installation of binaries
      require("mason").setup({
        ensure_installed = {
          -- List of tools to automatically install if missing
          "css-lsp", "emmet-ls", "eslint-lsp", "html-lsp", "intelephense",
          "json-lsp", "lua-language-server", "phpactor", "pyright",
          "python-lsp-server", "shfmt", "stylua", "typescript-language-server",
          "vue-language-server",
        },
        automatic_installation = true, -- Automatically install missing tools
      })

      -- 2. Prepare Capabilities:
      -- LSPs need to know what the editor supports (e.g. snippets, completion features).
      -- We start with default capabilities and extend them with cmp/blink capabilities.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      
      -- Add nvim-cmp capabilities if available
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if has_cmp then
        capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
      end
      
      -- Add blink.cmp capabilities if available (newer alternative to cmp)
      local has_blink, blink = pcall(require, "blink.cmp")
      if has_blink then
        capabilities = blink.get_lsp_capabilities(capabilities)
      end

      -- 3. Load Manual Server Configurations:
      -- We load the configurations from 'config.servers' which returns a table.
      -- We do this *before* setup so we can pass them to the handler.
      local servers = require("config.servers")

      -- 4. Setup LSP Servers via Mason-LSPConfig:
      -- This handler function is called for every server installed via Mason.
      -- It ensures we call .setup() on every server with our capabilities.
      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            -- Get custom config if available
            local server_config = servers[server_name] or {}
            
            -- Merge default capabilities with custom config
            server_config.capabilities = vim.tbl_deep_extend(
              "force",
              capabilities,
              server_config.capabilities or {}
            )
            
            -- Initialize the server
            require("lspconfig")[server_name].setup(server_config)
          end,
        }
      })
    end,
  },
}
