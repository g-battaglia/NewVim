return {
  -- nvim-notify: Replaces standard vim notifications with a nice floating window
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        -- Keymap to clear all active notifications immediately
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss all Notifications",
      },
    },
    opts = {
      timeout = 3000, -- Default notification duration (3 seconds)
      
      -- Limit dimensions to avoid covering the whole screen
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      
      -- Ensure notifications appear on top of other floating windows
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
    },
  },

  -- dressing.nvim: Improves the default vim.ui interfaces (input and select)
  -- It makes things like "Code Actions" or "Renaming" look like nice floating windows
  -- instead of plain text prompts at the bottom.
  {
    "stevearc/dressing.nvim",
    lazy = true, -- Lazy load until vim.ui.select/input is actually called
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

  -- noice.nvim: Completely replaces the UI for messages, cmdline and popupmenu
  -- It gives the "modern IDE" feel with centered command palette, better messages, etc.
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        -- Override standard LSP message handlers to use Noice's UI
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- Better docs in completion menu
        },
      },
      routes = {
        -- Filter out annoying/redundant messages
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" }, -- "10L, 50B written" messages
              { find = "; after #%d+" }, -- Undo messages
              { find = "; before #%d+" }, -- Redo messages
            },
          },
          view = "mini", -- Show them in a small mini-view instead of a notification
        },
      },
      presets = {
        bottom_search = true, -- Keep search bar at the bottom (classic feel)
        command_palette = true, -- Position command line in the center
        long_message_to_split = true, -- Long messages go to a split window
        inc_rename = true, -- Support for incremental renaming
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim", -- UI Component library required by Noice
      "rcarriga/nvim-notify", -- Notification system integrated with Noice
    },
  },
}
