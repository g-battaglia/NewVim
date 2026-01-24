-- =============================================================================
-- NewVim - config/servers.lua
-- =============================================================================
-- Configurazioni “manuali” per server LSP specifici.
--
-- IMPORTANTE:
-- Questo file NON deve chiamare `lspconfig.SERVER.setup(...)` direttamente.
--
-- Motivo:
-- - La configurazione LSP centralizzata sta in `lua/plugins/lsp.lua`.
-- - Qui restituiamo solo una tabella di opzioni, che verrà applicata dal
--   setup handler (Mason-LSPConfig).
-- =============================================================================

local util = require("lspconfig.util")

return {
  -- ---------------------------------------------------------------------------
  -- Lua: lua_ls (fix "undefined global vim")
  -- ---------------------------------------------------------------------------
  lua_ls = {
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          checkThirdParty = false,
          library = vim.api.nvim_get_runtime_file("", true),
        },
        telemetry = { enable = false },
      },
    },
  },

  -- ---------------------------------------------------------------------------
  -- PHP: Intelephense
  -- ---------------------------------------------------------------------------
  intelephense = {
    settings = {
      intelephense = {
        format = {
          braces = "k&r",
        },
        stubs = {
          "Core",
          "FFI",
          "PDO",
          "Phar",
          "Reflection",
          "SPL",
          "SimpleXML",
          "Zend OPcache",
          "apache",
          "bcmath",
          "bz2",
          "calendar",
          "com_dotnet",
          "ctype",
          "curl",
          "date",
          "dba",
          "dom",
          "enchant",
          "exif",
          "fileinfo",
          "filter",
          "fpm",
          "ftp",
          "gd",
          "gettext",
          "gmp",
          "hash",
          "iconv",
          "imap",
          "intl",
          "json",
          "ldap",
          "libxml",
          "mbstring",
          "meta",
          "mysqli",
          "oci8",
          "odbc",
          "openssl",
          "pcntl",
          "pcre",
          "pdo_ibm",
          "pdo_mysql",
          "pdo_pgsql",
          "pdo_sqlite",
          "pgsql",
          "posix",
          "pspell",
          "readline",
          "random",
          "session",
          "shmop",
          "snmp",
          "soap",
          "sockets",
          "sodium",
          "sqlite3",
          "standard",
          "superglobals",
          "sysvmsg",
          "sysvsem",
          "sysvshm",
          "tidy",
          "tokenizer",
          "wordpress",
          "wordpress-stubs",
          "woocommerce-stubs",
          "acf-pro-stubs",
          "wordpress-globals",
          "wp-cli-stubs",
          "xml",
          "xmlreader",
          "xmlrpc",
          "xmlwriter",
          "xsl",
          "zip",
          "zlib",
        },
      },
    },
  },

  -- ---------------------------------------------------------------------------
  -- Python: pyright
  -- ---------------------------------------------------------------------------
  pyright = {
    root_dir = util.root_pattern(
      "pyrightconfig.json",
      "pyproject.toml",
      "setup.py",
      "setup.cfg",
      "requirements.txt",
      ".git"
    ),
    settings = {
      pyright = {
        disableOrganizeImports = true, -- usa isort
      },
      python = {
        analysis = {
          -- Pyright leggerà le config da pyrightconfig.json o pyproject.toml
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = "openFilesOnly",
        },
      },
    },
  },

  -- ---------------------------------------------------------------------------
  -- Python: pylsp
  -- ---------------------------------------------------------------------------
  pylsp = {
    settings = {
      pylsp = {
        plugins = {
          -- Disabilitati
          autopep8 = { enabled = false },
          flake8 = { enabled = false },
          isort = { enabled = false },
          mccabe = { enabled = false },
          pycodestyle = { enabled = false },
          pyflakes = { enabled = false },
          pylint = { enabled = false },
          yapf = { enabled = false },

          -- Abilitati
          pyright = { enabled = true },
          black = { enabled = true },
          pylsp_mypy = { enabled = true },
        },
      },
    },
  },

  -- ---------------------------------------------------------------------------
  -- CSS / SCSS / LESS
  -- ---------------------------------------------------------------------------
  cssls = {
    settings = {
      css = { validate = true, lint = { unknownAtRules = "ignore" } },
      scss = { validate = true, lint = { unknownAtRules = "ignore" } },
      less = { validate = true, lint = { unknownAtRules = "ignore" } },
    },
  },

  -- ---------------------------------------------------------------------------
  -- Vue: Volar
  -- ---------------------------------------------------------------------------
  volar = {
    init_options = {
      vue = {
        hybridMode = false,
      },
    },
    settings = {
      typescript = {
        inlayHints = {
          enumMemberValues = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          parameterTypes = { enabled = true, suppressWhenArgumentMatchesName = true },
          variableTypes = { enabled = true },
        },
      },
    },
  },

  -- ---------------------------------------------------------------------------
  -- TypeScript: ts_ls (con plugin Vue TS)
  -- ---------------------------------------------------------------------------
  ts_ls = {
    init_options = {
      plugins = {
        {
          name = "@vue/typescript-plugin",
          location = vim.fn.stdpath("data")
            .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
          languages = { "vue" },
        },
      },
    },
    settings = {
      typescript = {
        tsserver = {
          useSyntaxServer = false,
        },
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayVariableTypeHintsWhenTypeMatchesName = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
    },
  },

  -- ---------------------------------------------------------------------------
  -- Prisma
  -- ---------------------------------------------------------------------------
  prismals = {
    root_dir = util.root_pattern("prisma/schema.prisma", "schema.prisma", ".git"),
    single_file_support = true,
  },
}
