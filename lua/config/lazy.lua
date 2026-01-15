-- =============================================================================
-- NewVim - config/lazy.lua
-- =============================================================================
-- Bootstrap di lazy.nvim + configurazione del plugin manager.
--
-- Obiettivo:
-- - restare su lazy.nvim come package manager
-- - NON usare LazyVim (niente import "lazyvim.plugins")
-- - caricare la spec dei plugin dalla cartella `lua/plugins/`
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Bootstrap: installa lazy.nvim se manca
-- -----------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })

  -- Se fallisce il clone, mostra errore e termina.
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

-- Aggiunge lazy.nvim al runtimepath.
vim.opt.rtp:prepend(lazypath)

-- -----------------------------------------------------------------------------
-- Setup: spec plugin + impostazioni del manager
-- -----------------------------------------------------------------------------
require("lazy").setup({
  spec = {
    -- Importa la directory `lua/plugins/`.
    -- Ogni file deve ritornare una spec Lazy valida.
    { import = "plugins" },
  },

  -- Default applicati ai plugin che non specificano esplicitamente `lazy`, `version`, etc.
  defaults = {
    lazy = false,   -- carica i plugin all'avvio (comportamento “distro-like”)
    version = false -- usa sempre HEAD; evita release vecchie che rompono Neovim
  },

  -- Aggiornamenti
  checker = {
    enabled = true,
    notify = false,
  },

  -- Performance: disabilita alcuni runtime plugin built-in inutili
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
