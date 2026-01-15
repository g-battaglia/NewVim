return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      -- nvim-ts-rainbow2 configuration
      ensure_installed = {
        "bash",
        "vimdoc",
        "html",
        "javascript",
        "json",
        "lua",
        "luap",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "svelte",
        "jsdoc",
        "yaml",
        "php",
        "phpdoc",
        "css",
        "scss",
        "jsonc",
        "vue",
      },
      highlight = {
        enable = true, -- false will disable the whole extension
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
