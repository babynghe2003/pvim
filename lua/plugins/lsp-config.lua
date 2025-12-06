return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "ts_ls",
          "html",
          "cssls",
          "ruff",
          "pyright",
          "rust_analyzer",
          -- "cmake",      -- CMake
          -- "clangd",     -- C++
          -- "pyright",    -- Python
          -- "dartls"      -- Dart
          -- Note: QML server isn't available in Mason's default registry
        }
      })
    end
  },
  {
    'neovim/nvim-lspconfig',
    config = function()
      -- Configure diagnostics to only show on cursor hover
      vim.diagnostic.config({
        virtual_text = false,     -- Disable inline diagnostics
        signs = true,             -- Keep signs in the sign column
        underline = true,         -- Keep underlines
        update_in_insert = false, -- Don't update diagnostics in insert mode
        severity_sort = true,     -- Sort by severity
        float = {
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })

      -- Show diagnostics when cursor hovers on the text
      vim.o.updatetime = 250 -- Faster update time for better hover experience
      vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
          vim.diagnostic.open_float(nil, { focus = false })
        end
      })

      local servers = {
        {
          "clangd",
          {
            cmd = {
              "clangd",
              "--background-index",
              "--suggest-missing-includes",
              "--header-insertion=iwyu",
              "--compile-commands-dir=build",
              "--offset-encoding=utf-16",
              "--enable-config",
              "--fallback-style=Google",
              "--all-scopes-completion",
              "--cross-file-rename",
              "--completion-style=detailed",
            },
            init_options = {
              fallbackFlags = { "-std=c++17" },
            },
          }
        },
        {
          "cmake",
          {
            init_options = {
              buildDirectory = "build"
            }
          }
        },
        {
          "qmlls",
          {
            cmd = { '/home/as/Qt/Tools/QtDesignStudio/qt6_design_studio_reduced_version/bin/qmlls' },
            filetypes = { 'qml', 'qmljs' }
          }
        },
        {
          "ts_ls",
          {
            settings = {
              javascript = { format = { enable = true } },
              typescript = { format = { enable = true } },
            },
          }
        },
        {
          "html",
          {
            cmd = { "vscode-html-language-server", "--stdio" },
            filetypes = { "html" },
            init_options = { configuration = {} },
          }
        },
        {
          "cssls",
          {
            cmd = { "vscode-css-language-server", "--stdio" },
            settings = {
              css = { validate = true },
              scss = { validate = true },
              less = { validate = true },
            },
          }
        },
        {
          "pyright",
          {
            settings = {
              python = {
                analysis = {
                  autoImportCompletions = true,
                  typeCheckingMode = "standard",
                  diagnosticMode = "openFilesOnly",
                }
              }
            }
          }
        },
        {
          "rust_analyzer",
          {
            settings = {
              ['rust-analyzer'] = {
                cargo = { allFeatures = true },
                checkOnSave = true,
                procMacro = { enable = true },
              }
            },
          }
        }
      }

      for _, server in ipairs(servers) do
        local name, config = server[1], server[2]
        if config then
          vim.lsp.config(name, config)
        end
        vim.lsp.enable(name)
      end
    end
  }
}
