return {
  {
    "stevearc/conform.nvim",
    -- Load the plugin just before writing a file to ensure formatting works on save
    event = { "BufWritePre" },
    -- Command to show info about the current buffer's formatters
    cmd = { "ConformInfo" },
    
    keys = {
      {
        -- Custom keymap to format injected languages (e.g. SQL inside Python strings)
        "<leader>cF",
        function()
          require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
        end,
        mode = { "n", "v" },
        desc = "Format Injected Langs",
      },
    },
    
    opts = {
      -- Define which formatters to use for each filetype
      -- "prettierd" is preferred over "prettier" for performance (daemonized)
      formatters_by_ft = {
        lua = { "stylua" }, -- Standard Lua formatter
        python = { "isort", "black" }, -- Sort imports first (isort), then format code (black)
        
        -- Web technologies usually share the same prettier config
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
      
      -- Default formatting options
      default_format_opts = {
        -- "fallback": If no formatter is defined for the filetype (in formatters_by_ft),
        -- use the LSP's formatting capability (e.g. clangd for C++).
        -- This ensures we always have *some* formatting if a server is attached.
        lsp_format = "fallback",
      },
    },
  },
}
