-- =============================================================================
-- NewVim - plugins/editor.lua
-- =============================================================================
-- Plugin “editor workflow”:
--   - mini.pairs     : autopair di parentesi/virgolette
--   - mini.surround  : aggiungi/rimuovi/cambia surrounding
--   - persistence    : sessioni
--   - todo-comments  : evidenzia TODO/FIXME ecc.
--   - trouble        : UI per diagnostica/quickfix
-- =============================================================================

return {
  -- ---------------------------------------------------------------------------
  -- Autopairs
  -- ---------------------------------------------------------------------------
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {},
  },

  -- ---------------------------------------------------------------------------
  -- Surround
  -- ---------------------------------------------------------------------------
  {
    "echasnovski/mini.surround",
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
        update_n_lines = "gsn",
      },
    },
  },

  -- ---------------------------------------------------------------------------
  -- Folding (LazyVim-style)
  -- ---------------------------------------------------------------------------
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    event = "BufReadPost",
    opts = {
      provider_selector = function(_, filetype, buftype)
        -- nvim-ufo supporta solo { main, fallback }.
        -- Disabilita ufo su buffer "speciali".
        if buftype ~= "" and buftype ~= "acwrite" then
          return ""
        end

        -- Vue: Tree-sitter tende a dare fold migliori.
        if filetype == "vue" then
          return { "treesitter", "indent" }
        end

        -- TypeScript/JavaScript: LazyVim di solito preferisce LSP folding.
        -- Fallback a Tree-sitter quando il server non supporta folding.
        if filetype == "javascript"
          or filetype == "javascriptreact"
          or filetype == "typescript"
          or filetype == "typescriptreact"
        then
          return { "lsp", "treesitter" }
        end

        -- Default robusto: LSP come main, indent come fallback.
        -- (evita errori quando treesitter non ha query 'folds')
        return { "lsp", "indent" }
      end,
    },
    keys = {
      { "zR", function() require("ufo").openAllFolds() end, desc = "Open all folds" },
      { "zM", function() require("ufo").closeAllFolds() end, desc = "Close all folds" },
      { "zr", function() require("ufo").openFoldsExceptKinds() end, desc = "Open folds" },
      { "zm", function() require("ufo").closeFoldsWith() end, desc = "Close folds" },
    },
  },

  -- ---------------------------------------------------------------------------
  -- Sessioni
  -- ---------------------------------------------------------------------------
  {
    "folke/persistence.nvim",
    event = "BufReadPre",

    -- Session options coerenti con defaults.lua
    opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" } },

    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Session" },
    },
  },

  -- ---------------------------------------------------------------------------
  -- TODO/FIXME
  -- ---------------------------------------------------------------------------
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    opts = {},

    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Prev Todo" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo (Telescope)" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Telescope)" },
    },
  },

  -- ---------------------------------------------------------------------------
  -- Trouble
  -- ---------------------------------------------------------------------------
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },

    keys = {
      { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Doc Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
      { "<leader>xL", "<cmd>TroubleToggle loclist<cr>", desc = "Loclist (Trouble)" },
      { "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix (Trouble)" },

      -- Se Trouble è aperto, naviga lì; altrimenti usa quickfix normale.
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").previous({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Prev Trouble/Quickfix",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Next Trouble/Quickfix",
      },
    },
  },
}
