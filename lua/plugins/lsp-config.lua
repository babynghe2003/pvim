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

      -- Lua LSP
     -- C++ LSP
      vim.lsp.config.clangd = {
        cmd = {
          "clangd",
          "--background-index",
          "--suggest-missing-includes",
          "--header-insertion=iwyu",
          "--compile-commands-dir=build", -- Look for compile_commands.json in the build directory
          "--offset-encoding=utf-16",     -- Fixes some offset encoding issues
          "--enable-config",              -- Use .clangd configuration files if any
          "--fallback-style=Google",      -- Coding style for formatting if no .clang-format file
          "--all-scopes-completion",      -- Complete from all accessible scopes
          "--cross-file-rename",          -- Enable rename across files
          "--completion-style=detailed",  -- Provides more detailed completion items
        },
        init_options = {
          fallbackFlags = { "-std=c++17" }, -- Default to C++17 if no standard is specified
        },
      }


      -- CMake LSP
      vim.lsp.config.cmake = {
        -- Default CMake language server settings
        init_options = {
          buildDirectory = "build"
        }
      }

      -- Qt/QML LSP - You'll need to install this server manually
      -- or use a custom method to set it up
      -- Uncomment and adjust if you have a QML language server installed
      vim.lsp.config.qmlls = {
        -- Qt Language Server settings
        cmd = { '/home/as/Qt/Tools/QtDesignStudio/qt6_design_studio_reduced_version/bin/qmlls' },
        filetypes = { 'qml', 'qmljs' }
        -- /home/as/Qt/Tools/QtDesignStudio/qt6_design_studio_reduced_version/bin/qmlls
      }
      -- JavaScript/TypeScript LSP
      vim.lsp.config.ts_ls = {
        settings = {
          javascript = {
            format = {
              enable = true,
            },
          },
          typescript = {
            format = {
              enable = true,
            },
          },
        },
      }

      -- HTML LSP
      vim.lsp.config.html  = {
        cmd = { "vscode-html-language-server", "--stdio" },
        filetypes = { "html" },
        init_options = {
          configuration = {},
        },
      }

      -- CSS LSP
      vim.lsp.config.cssls = {
         cmd = { "vscode-css-language-server", "--stdio" },
        settings = {
          css = { validate = true },
          scss = { validate = true },
          less = { validate = true },
        },
      }
      })

      -- Rust LSP
      lspconfig.rust_analyzer.setup({
        settings = {
          ['rust-analyzer'] = {
            cargo = { allFeatures = true },
            checkOnSave = true,
            procMacro = {
              enable = true
            }
          }
        }
      })
    end
  }
}
