return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  opts = {
    options = {
      mode = "buffers",
      diagnostics = "nvim_lsp",
      show_buffer_close_icons = false,
      show_close_icon = false,
      separator_style = "thin",
      always_show_bufferline = false,
      offsets = {
        {
          filetype = "neo-tree",
          text = "",
          separator = false,
          highlight = "NeoTreeNormal",
        },
      },
      custom_filter = function(buf_number)
        -- Exclude special filetypes
        local ft = vim.bo[buf_number].filetype
        local excluded = {
          ["neo-tree"] = true,
          ["neo-tree-popup"] = true,
          ["snacks_dashboard"] = true,
          ["dashboard"] = true,
          ["alpha"] = true,
          ["starter"] = true,
        }
        return not excluded[ft]
      end,
    },
  },
  config = function(_, opts)
    require("bufferline").setup(opts)
    -- Hide tabline when only special buffers are visible
    vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter", "WinClosed" }, {
      callback = function()
        vim.schedule(function()
          local dominated_by_special = true
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            local ft = vim.bo[buf].filetype
            if ft ~= "neo-tree" and ft ~= "" and ft ~= "snacks_dashboard" and ft ~= "dashboard" then
              dominated_by_special = false
              break
            end
          end
          if dominated_by_special then
            vim.opt.showtabline = 0
          else
            vim.opt.showtabline = 2
          end
        end)
      end,
    })
  end,
  keys = {
    { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
    { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
    { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Toggle pin" },
    { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Delete non-pinned buffers" },
  },
}
