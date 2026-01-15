-- =============================================================================
-- NewVim - plugins/ui.lua
-- =============================================================================
-- UI “distro-like”:
--   - nvim-notify: notifiche moderne
--   - dressing: migliora vim.ui.select / vim.ui.input
--   - noice: cmdline/messaggi/popup più curati
-- =============================================================================

return {
  -- ---------------------------------------------------------------------------
  -- Notifiche
  -- ---------------------------------------------------------------------------
  {
    "rcarriga/nvim-notify",

    -- Mapping: pulisci tutte le notifiche
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
      timeout = 3000,

      -- Evita che una notifica “gigante” copra tutto
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,

      -- Z-index alto: sopra altri float
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

    -- Lazy-load “intelligente”: carica dressing solo al primo utilizzo.
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
  -- noice: cmdline/messaggi/popup
  -- ---------------------------------------------------------------------------
  {
    "folke/noice.nvim",
    event = "VeryLazy",

    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },

    opts = {
      lsp = {
        -- Usa rendering markdown migliore per hover/signature help
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },

      -- “Route” = regole per filtrare/redirectare messaggi
      routes = {
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
