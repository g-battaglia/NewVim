-- =============================================================================
-- NewVim - config/defaults.lua
-- =============================================================================
-- Questo file contiene le “sane impostazioni di base” che, in un setup LazyVim,
-- vengono tipicamente impostate automaticamente.
--
-- NOTA:
-- - Qui mettiamo i default globali *generici*.
-- - Le preferenze personali del tuo setup stanno in `lua/config/options.lua`.
-- =============================================================================

local opt = vim.opt

-- -----------------------------------------------------------------------------
-- Editor: comportamento generale
-- -----------------------------------------------------------------------------
opt.autowrite = true           -- autosalva quando opportuno (es. cambio buffer)
opt.confirm = true             -- chiede conferma prima di perdere modifiche
opt.mouse = "a"                -- abilita mouse (utile in split/resize)
opt.timeoutlen = 300           -- tempo per completare mapping multi-tasto
opt.updatetime = 200           -- CursorHold più reattivo / swap più frequente

-- -----------------------------------------------------------------------------
-- UI: aspetto
-- -----------------------------------------------------------------------------
opt.termguicolors = true       -- colori 24bit
opt.cursorline = true          -- evidenzia la riga corrente
opt.number = true              -- numeri di riga
opt.relativenumber = true      -- numeri relativi (puoi disabilitarlo in options.lua)
opt.signcolumn = "yes"         -- colonna segni sempre visibile (gitsigns/diagnostics)
opt.laststatus = 3             -- statusline globale
opt.pumheight = 10             -- altezza massima popup completion
opt.pumblend = 10              -- trasparenza popup completion
opt.showmode = false           -- non mostrare -- INSERT -- (lo statusline lo gestisce)

-- -----------------------------------------------------------------------------
-- Indentazione
-- -----------------------------------------------------------------------------
opt.expandtab = true           -- spazi al posto dei tab
opt.shiftwidth = 2             -- indent size
opt.tabstop = 2                -- tab = 2 spazi
opt.shiftround = true          -- arrotonda indent ai multipli di shiftwidth
opt.smartindent = true         -- indent automatico su nuove righe

-- -----------------------------------------------------------------------------
-- Ricerca
-- -----------------------------------------------------------------------------
opt.ignorecase = true          -- ignore case in search...
opt.smartcase = true           -- ...tranne quando scrivi maiuscole
opt.inccommand = "nosplit"     -- preview sostituzioni durante :%s
opt.grepprg = "rg --vimgrep"   -- usa ripgrep
opt.grepformat = "%f:%l:%c:%m"

-- -----------------------------------------------------------------------------
-- Testo invisibile / wrap
-- -----------------------------------------------------------------------------
opt.wrap = false               -- no soft-wrap di default
opt.list = true                -- mostra alcuni caratteri invisibili

-- -----------------------------------------------------------------------------
-- Clipboard / completion
-- -----------------------------------------------------------------------------
opt.clipboard = "unnamedplus" -- clipboard di sistema
opt.completeopt = "menu,menuone,noselect"

-- -----------------------------------------------------------------------------
-- Undo
-- -----------------------------------------------------------------------------
opt.undofile = true
opt.undolevels = 10000

-- -----------------------------------------------------------------------------
-- Split e sessioni
-- -----------------------------------------------------------------------------
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "screen"
opt.scrolloff = 4
opt.sidescrolloff = 8
opt.winminwidth = 5
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- -----------------------------------------------------------------------------
-- Messaggi
-- -----------------------------------------------------------------------------
opt.shortmess:append({ W = true, I = true, c = true, C = true })

-- -----------------------------------------------------------------------------
-- Leader
-- -----------------------------------------------------------------------------
-- IMPORTANT: va impostato prima di definire mapping.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- -----------------------------------------------------------------------------
-- Conceal
-- -----------------------------------------------------------------------------
-- LazyVim spesso imposta conceallevel a 3 di default. Tu lo disabiliti poi in
-- options.lua (conceallevel=0). Qui lasciamo un default sensato.
opt.conceallevel = 3

-- -----------------------------------------------------------------------------
-- Diagnostic signs (niente "E/W/I/H")
-- -----------------------------------------------------------------------------
-- Neovim 0.11: `sign_define()` è deprecato per i diagnostic signs.
-- Usiamo `vim.diagnostic.config()` per impostare i simboli.
do
  local ok, icons = pcall(function()
    return require("util").icons.diagnostics
  end)

  if ok and icons then
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = icons.Error,
          [vim.diagnostic.severity.WARN] = "",
          [vim.diagnostic.severity.INFO] = icons.Info,
          [vim.diagnostic.severity.HINT] = icons.Hint,
        },
      },
      underline = true,
    })
  end
end
