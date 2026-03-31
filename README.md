# 🌟 NewVim

A modular, robust Neovim configuration built from scratch. **NewVim** aims to replicate the highly-polished, feature-rich experience of [LazyVim](https://github.com/LazyVim/LazyVim) without actually depending on the LazyVim framework as a core dependency.

It provides a blazing-fast, modern development environment with carefully selected plugins, sensible defaults, and a clean architectural structure.

## ✨ Features

- 📦 **Package Management:** Powered by [lazy.nvim](https://github.com/folke/lazy.nvim) for ultra-fast startup times and lazy-loading.
- 🧠 **Smart Autocompletion:** Next-generation completion and snippets using [blink.cmp](https://github.com/Saghen/blink.cmp).
- 🔍 **Fuzzy Finding:** Blazing fast searches via [fzf-lua](https://github.com/ibhagwan/fzf-lua).
- 🌲 **File Explorer:** Manage your workspace efficiently with [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim).
- 🌳 **Syntax Highlighting:** Unmatched parsing and highlighting with [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter).
- 🛠️ **LSP & Formatting:** Out-of-the-box support for Language Servers and external formatters.
- 🐙 **Git Integration:** Seamless version control features using [gitsigns](https://github.com/lewis6991/gitsigns.nvim) and [diffview](https://github.com/sindrets/diffview.nvim).
- 🎨 **Beautiful UI:** Polished interface with [lualine](https://github.com/nvim-lualine/lualine.nvim), [bufferline](https://github.com/akinsho/bufferline.nvim), and [snacks.nvim](https://github.com/folke/snacks.nvim).

## 📁 Project Structure

The configuration is completely modularized in the `lua/` directory.

```text
~/.config/nvim
├── init.lua             # Entry point (handles loading order)
├── lazy-lock.json       # Locked plugin versions for stability
├── ICONS_RECAP.md       # Icon glossary and reference
├── SUGGESTIONS.md       # Development and setup suggestions
└── lua/
    ├── config/          # Core Neovim setup
    │   ├── options.lua  # Base Vim options
    │   ├── logging.lua  # Custom file logging utilities
    │   ├── lazy.lua     # Plugin manager bootstrap
    │   ├── keymaps.lua  # General keybindings
    │   └── autocmds.lua # Auto commands & events
    ├── plugins/         # Plugin specifications (loaded by lazy.nvim)
    │   ├── blink.cmp.lua
    │   ├── fzf-lua.lua
    │   ├── lsp.lua
    │   └── ...
    └── util/            # Custom utility functions
```

> **Note:** Internal code comments are written in Italian to document the logic and the "why" behind specific configurations.

## 📋 Prerequisites

To get the most out of NewVim, ensure you have the following installed on your system:

- **Neovim** >= **0.10.0** (Recommended for modern plugins like `blink.cmp`)
- **Git** (for package management)
- A **[Nerd Font](https://www.nerdfonts.com/)** (crucial for rendering UI icons correctly)
- **[Ripgrep](https://github.com/BurntSushi/ripgrep)** (`rg`) (for blazing fast text search in `fzf-lua`)
- **[fd](https://github.com/sharkdp/fd)** (for fast file discovery)
- A **C Compiler** (`gcc`, `clang`, or `zig`) to compile Treesitter parsers
- **Node.js** & **npm** (required for some LSPs like `pyright`, `tsserver`, etc.)

## 🚀 Installation

1. **Backup your existing configuration (if any):**

   ```bash
   mv ~/.config/nvim ~/.config/nvim.bak
   mv ~/.local/share/nvim ~/.local/share/nvim.bak
   mv ~/.local/state/nvim ~/.local/state/nvim.bak
   mv ~/.cache/nvim ~/.cache/nvim.bak
   ```

2. **Clone this repository:**

   ```bash
   git clone https://github.com/<your-username>/NewVim.git ~/.config/nvim
   ```
   *(Be sure to replace `<your-username>` with your actual GitHub username or the correct repository URL)*

3. **Start Neovim!**

   ```bash
   nvim
   ```

   On the first run, `lazy.nvim` will automatically bootstrap itself and install all the plugins specified in `lua/plugins/`. Wait for the installation to finish, and you might need to restart Neovim once.

## 📖 Further Reading

- Need help with icons? Check out **`ICONS_RECAP.md`**.
- Looking for extra tips and environment setup tricks? Read **`SUGGESTIONS.md`**.
- Want to add a new plugin? Simply create a new file like `lua/plugins/my-plugin.lua` and return a valid `lazy.nvim` specification table.
