-- =============================================================================
-- NewVim - config/autocmds.lua
-- =============================================================================
-- Autocomandi “quality of life”.
-- L'idea è replicare i comportamenti comodi tipici di LazyVim, ma in modo esplicito.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1) checktime: ricarica file modificati fuori da Neovim
-- -----------------------------------------------------------------------------
-- Scenario tipico: git checkout, formatter esterni, editor diversi.
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = vim.api.nvim_create_augroup("newvim_checktime", { clear = true }),
  callback = function()
    -- Evita buffer speciali (nofile) per non spam.
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- -----------------------------------------------------------------------------
-- 2) highlight_yank: feedback visivo dopo yank
-- -----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("newvim_highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- -----------------------------------------------------------------------------
-- 3) resize_splits: ridistribuisci split dopo resize della finestra
-- -----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("VimResized", {
  group = vim.api.nvim_create_augroup("newvim_resize_splits", { clear = true }),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- -----------------------------------------------------------------------------
-- 4) close_with_q: chiudi buffer “utility” premendo `q`
-- -----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("newvim_close_with_q", { clear = true }),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- -----------------------------------------------------------------------------
-- 5) wrap_spell: scrittura comoda su markdown/gitcommit
-- -----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("newvim_wrap_spell", { clear = true }),
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- -----------------------------------------------------------------------------
-- 6) json_conceal: JSON senza conceal
-- -----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("newvim_json_conceal", { clear = true }),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- -----------------------------------------------------------------------------
-- 7) auto_create_dir: crea cartelle mancanti al salvataggio
-- -----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("newvim_auto_create_dir", { clear = true }),
  callback = function(event)
    -- Skip per URI tipo scp://...
    if event.match:match("^%w%w+://") then
      return
    end

    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})


-- -----------------------------------------------------------------------------
-- 7) Per i file markdown non vogliamo i numeri e vogliamo andare a capo
-- -----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.number = true
    vim.opt_local.relativenumber = false
  end,
})
