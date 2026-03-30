return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      {
        "<leader>fe",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
      { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (cwd)", remap = true },
    },

    opts = {
      default_component_configs = {
        icon = {
          folder_closed = "D",
          folder_open = "O",
          folder_empty = "E",
          default = "*",
        },
        modified = {
          symbol = "[+]",
        },
        name = {
          use_git_status_colors = true,
        },
        git_status = {
          symbols = {
            added = "+",
            modified = "~",
            deleted = "-",
            renamed = "R",
            untracked = "?",
            ignored = "I",
            unstaged = "U",
            staged = "S",
            conflict = "C",
          },
        },
      },
      filesystem = {
        follow_current_file = { enabled = true },
        filtered_items = {
          visible = true, 
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_hidden = true, 
          hide_by_name = {},
          hide_by_pattern = {},
          always_show = { 
            "dist",
            "temp",
          },
          never_show = { 
            ".git",
          },
          never_show_by_pattern = {},
          bind_to_cwd = true, 
        },
      },
    },
  },
}
