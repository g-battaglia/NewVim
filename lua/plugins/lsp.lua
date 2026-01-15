return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    opts = {
      inlay_hints = { enabled = false },
    },
    config = function(_, opts)
      -- Setup Mason
      require("mason").setup({
        ensure_installed = {
          "css-lsp",
          "emmet-ls",
          "eslint-lsp",
          "html-lsp",
          "intelephense",
          "json-lsp",
          "lua-language-server",
          "phpactor",
          "pyright",
          "python-lsp-server",
          "shfmt",
          "stylua",
          "typescript-language-server",
          "vue-language-server",
        },
        automatic_installation = true,
      })

      require("mason-lspconfig").setup()

      -- Setup LSPConfig
      local lspconfig = require("lspconfig")

      -- Common capabilities including cmp
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if has_cmp then
        capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
      end
      
      -- Also check for blink.cmp
      local has_blink, blink = pcall(require, "blink.cmp")
      if has_blink then
        capabilities = blink.get_lsp_capabilities(capabilities)
      end

      -- Default setup for all installed servers via mason-lspconfig
      -- This ensures that if a server is installed but not manually configured in servers.lua, it still works.
      require("mason-lspconfig").setup_handlers({
        function(server_name)
          -- We only setup here if it's NOT handled in config.servers
          -- But for simplicity, we can let config.servers override specific ones by running it *after*.
          lspconfig[server_name].setup({
            capabilities = capabilities,
          })
        end,
      })
      
      -- Load manual server configurations
      require("config.servers")
    end,
  },
}
