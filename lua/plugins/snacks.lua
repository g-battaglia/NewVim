-- =============================================================================
-- NewVim - plugins/snacks.lua
-- =============================================================================
-- snacks.nvim:
--   - dashboard
--   - terminal floating
--   - utility varie (bufdelete, ecc.)
--
-- Allineamento “stile LazyVim”:
-- - i picker del dashboard (files/grep/recent) usano la project root
--   (LSP/.git fallback) tramite `require('util').get_root()`.
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
          -- Root-aware (come LazyVim)
          { icon = "F ", key = "f", desc = "Find File (Root)", action = ":lua Snacks.dashboard.pick('files', { cwd = require('util').get_root() })" },
          { icon = "S ", key = "g", desc = "Find Text (Root)", action = ":lua Snacks.dashboard.pick('live_grep', { cwd = require('util').get_root() })" },
          { icon = "R ", key = "r", desc = "Recent Files (Root)", action = ":lua Snacks.dashboard.pick('oldfiles', { cwd = require('util').get_root() })" },

          -- Non-root-aware per definizione
          { icon = "N ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = "C ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', { cwd = vim.fn.stdpath('config') })" },

          -- Session / lifecycle
          { icon = "S ", key = "s", desc = "Restore Session", section = "session" },
          { icon = "L ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = "Q ", key = "q", desc = "Quit", action = ":qa" },
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
      terminal = { height = 0.3 },
      lazygit = { width = 0.9, height = 0.9 },
    },

    -- -------------------------------------------------------------------------
    -- Feature non usate (tenute spente)
    -- -------------------------------------------------------------------------
    scroll = { enabled = false },
    scope = { enabled = false },
    animate = { enabled = false },
  },
}
