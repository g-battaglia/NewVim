return { 
  "folke/tokyonight.nvim",
  priority = 1000, 
  opts = {
    styles = {
      sidebars = "transparent",
      floats = "transparent",
    },
  },
  init = function()
    vim.cmd.colorscheme("tokyonight-storm")
    vim.cmd.hi("Comment gui=none")
  end,
}
