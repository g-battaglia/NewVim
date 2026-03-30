return {
  "sindrets/diffview.nvim",
  event = "VeryLazy",
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewFileHistory",
    "DiffviewFocusFiles",
    "DiffviewToggleFiles",
    "DiffviewRefresh",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-tree/nvim-web-devicons", optional = true },
  },
  keys = function()
    local function default_branch()
      local out = vim.fn.systemlist("git remote show origin 2>/dev/null | sed -n '/HEAD branch/s/.*: //p'")
      return (#out > 0 and out[1] ~= "") and out[1] or "main"
    end

    return {
      { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Diffview • working tree" },
      { "<leader>gD", "<cmd>DiffviewClose<CR>", desc = "Diffview • chiudi" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<CR>", desc = "Diffview • history repo" },
      -- { "<leader>gf", "<cmd>DiffviewFocusFiles<CR>", desc = "Diffview • focus files panel" },
      { "<leader>gt", "<cmd>DiffviewToggleFiles<CR>", desc = "Diffview • toggle files panel" },
      { "<leader>gr", "<cmd>DiffviewRefresh<CR>", desc = "Diffview • refresh" },
      {
        "<leader>gM",
        function()
          require("diffview").open(default_branch())
        end,
        desc = "Diffview • confronto con branch di default",
      },
    }
  end,
  opts = {
    enhanced_diff_hl = true, -- Highlight migliorato
    use_icons = true,
    view = {
      default = { winbar_info = true },
      merge_tool = {
        layout = "diff3_mixed",
        disable_diagnostics = true,
        winbar_info = true,
      },
      file_history = { winbar_info = true },
    },
    file_panel = {
      listing_style = "tree",
      tree_options = {
        flatten_dirs = true,
        folder_statuses = "only_folded",
      },
      win_config = { position = "left", width = 35 },
    },
    file_history_panel = {
      log_options = {
        git = {
          single_file = { diff_merges = "combined" },
          multi_file = { diff_merges = "first-parent" },
        },
      },
      win_config = { position = "bottom", height = 16 },
    },
    hooks = {
      diff_buf_read = function(bufnr)
        vim.opt_local.wrap = false
        vim.opt_local.list = false
      end,
    },
  },
}
