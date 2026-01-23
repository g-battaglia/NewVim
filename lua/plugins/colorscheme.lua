return {
  "folke/tokyonight.nvim",
  priority = 1000,
  opts = {
    styles = {
      sidebars = "transparent",
      floats = "transparent",
    },
    on_highlights = function(hl, c)
      -- Remove background from markdown headings (treesitter)
      hl["@markup.heading.1.markdown"] = { fg = c.blue, bold = true }
      hl["@markup.heading.2.markdown"] = { fg = c.yellow, bold = true }
      hl["@markup.heading.3.markdown"] = { fg = c.green, bold = true }
      hl["@markup.heading.4.markdown"] = { fg = c.teal, bold = true }
      hl["@markup.heading.5.markdown"] = { fg = c.purple, bold = true }
      hl["@markup.heading.6.markdown"] = { fg = c.red, bold = true }
      -- Remove background from heading markers
      hl["@markup.heading.1.marker.markdown"] = { fg = c.blue, bold = true }
      hl["@markup.heading.2.marker.markdown"] = { fg = c.yellow, bold = true }
      hl["@markup.heading.3.marker.markdown"] = { fg = c.green, bold = true }
      hl["@markup.heading.4.marker.markdown"] = { fg = c.teal, bold = true }
      hl["@markup.heading.5.marker.markdown"] = { fg = c.purple, bold = true }
      hl["@markup.heading.6.marker.markdown"] = { fg = c.red, bold = true }
      -- Remove background from inline code (`code`)
      hl["@markup.raw.markdown_inline"] = { fg = c.green, bg = "NONE" }
      hl["@markup.raw"] = { bg = "NONE" }
      hl["@text.literal"] = { bg = "NONE" }
    end,
  },
  init = function()
    vim.cmd.colorscheme("tokyonight-storm")
    vim.cmd.hi("Comment gui=none")
  end,
}
