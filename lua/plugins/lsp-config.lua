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
    config = function ()
      local lspconfig = require("lspconfig")
      
      -- Configure diagnostics to only show on cursor hover
      vim.diagnostic.config({
        virtual_text = false,       -- Disable inline diagnostics
        signs = true,               -- Keep signs in the sign column
        underline = true,           -- Keep underlines
        update_in_insert = false,   -- Don't update diagnostics in insert mode
        severity_sort = true,       -- Sort by severity
        float = {
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })
      
      -- Show diagnostics when cursor hovers on the text
      vim.o.updatetime = 250  -- Faster update time for better hover experience
      vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
          vim.diagnostic.open_float(nil, { focus = false })
        end
      })
      
      -- Lua LSP
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT',
            },
            diagnostics = {
              globals = {
                'vim',
                'require'
              },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = {
              enable = false,
            },
          }
        }
      })
      
      -- C++ LSP
      lspconfig.clangd.setup({
        cmd = {
          "clangd",
          "--background-index",
          "--suggest-missing-includes",
          "--clang-tidy",
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
      })
      
      -- Python LSP
      lspconfig.pyright.setup({
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "workspace",
              useLibraryCodeForTypes = true
            }
          }
        }
      })
      
      -- Dart LSP
      lspconfig.dartls.setup({
        cmd = { "dart", 'language-server', '--protocol=lsp' }
      })
      
      -- CMake LSP
      lspconfig.cmake.setup({
        -- Default CMake language server settings
        init_options = {
          buildDirectory = "build"
        }
      })
      
      -- Qt/QML LSP - You'll need to install this server manually
      -- or use a custom method to set it up
      -- Uncomment and adjust if you have a QML language server installed
      -- lspconfig.qmlls.setup({
      --   -- Qt Language Server settings
      -- })
    end
  }
}
