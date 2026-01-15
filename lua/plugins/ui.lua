-- =============================================================================
-- NewVim - plugins/ui.lua
-- =============================================================================
-- UI “distro-like” ma senza fronzoli:
--   - nvim-notify: notifiche moderne (senza animazioni)
--   - dressing: migliora vim.ui.select / vim.ui.input
--   - noice: cmdline/messaggi più curati
--
-- Richieste utente:
--   1) Niente animazioni
--   2) Niente autocomplete/popupmenu mentre scrivi comandi
-- =============================================================================

return {
  -- ---------------------------------------------------------------------------
  -- Notifiche (no animazioni)
  -- ---------------------------------------------------------------------------
  {
    "rcarriga/nvim-notify",

    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss Notifications",
      },
    },

    opts = {
      -- Disabilita completamente le animazioni di notify
      stages = "static",

      timeout = 3000,

      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,

      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
    },
  },

  -- ---------------------------------------------------------------------------
  -- UI helpers: select/input
  -- ---------------------------------------------------------------------------
  {
    "stevearc/dressing.nvim",
    lazy = true,

    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end

      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },

  -- ---------------------------------------------------------------------------
  -- noice: cmdline/messaggi
  -- ---------------------------------------------------------------------------
  {
    "folke/noice.nvim",
    event = "VeryLazy",

    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },

    opts = {
      -- 1) Disabilita popupmenu del cmdline (autocomplete mentre scrivi comandi)
      popupmenu = { enabled = false },

      -- 2) Mantieni cmdline/messaggi più leggibili
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },

      routes = {
        -- Nasconde lo spam di installazione parser Tree-sitter
        -- (es. "[nvim-treesitter/install/bash]: Compiling parser")
        {
          filter = {
            event = "msg_show",
            find = "%[nvim%-treesitter/install/",
          },
          opts = { skip = true },
        },

        -- Nasconde messaggi “di servizio” molto frequenti
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
      },

      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
      },
    },
  },
}
