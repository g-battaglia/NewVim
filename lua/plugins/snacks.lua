-- =============================================================================
-- NewVim - plugins/snacks.lua
-- =============================================================================
-- snacks.nvim:
--   - dashboard
--   - terminal floating
--   - utility varie (bufdelete, ecc.)
--
-- Nota:
-- In LazyVim Snacks viene integrato con varie helper (pick/root). Qui usiamo
-- le API standard di Snacks.
-- =============================================================================

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,

  opts = {
    -- -------------------------------------------------------------------------
    -- Dashboard
    -- -------------------------------------------------------------------------
    dashboard = {
      preset = {
        -- stylua: ignore
        ---@type snacks.dashboard.Item[]
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
    },

    -- -------------------------------------------------------------------------
    -- Indent guides (Snacks)
    -- -------------------------------------------------------------------------
    indent = {
      priority = 1,
      enabled = true,
      char = "│",
      only_scope = false,
      only_current = false,
      hl = "SnacksIndent",
      animate = { enabled = false },
    },

    -- -------------------------------------------------------------------------
    -- Stili
    -- -------------------------------------------------------------------------
    styles = {
      terminal = {
        height = 0.3,
      },
      lazygit = {
        width = 0.9,
        height = 0.9,
      },
    },

    -- -------------------------------------------------------------------------
    -- Feature non usate (tenute spente)
    -- -------------------------------------------------------------------------
    scroll = { enabled = false },
    scope = { enabled = false },
    animate = { enabled = false },
  },
}
