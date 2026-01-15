return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    -- Simplified spec format for v3
    spec = {
      { "<leader>t", group = "+nvterm" },
      { "<leader>p", group = "+prettier" },
    },
  },
}
