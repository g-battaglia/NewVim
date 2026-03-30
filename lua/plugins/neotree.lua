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
