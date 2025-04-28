return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local config = require("nvim-treesitter.configs")
    config.setup({
      ensure_installed = { "lua", "c", "vim", "cpp", "qmljs", "python", "dart" }, -- Add your languages
      highlight = {
        enable = true, -- Enable syntax highlighting
        additional_vim_regex_highlighting = false, -- Disable regex-based highlighting for better performance
      },
      indent = {
        enable = true, -- Enable Tree-sitter-based indentation
      },
      incremental_selection = {
        enable = true, -- Enable incremental selection
        keymaps = {
          init_selection = "gnn", -- Start selection
          node_incremental = "grn", -- Increment to the next node
          scope_incremental = "grc", -- Increment to the next scope
          node_decremental = "grm", -- Decrement to the previous node
        },
      },
      textobjects = {
        select = {
          enable = true, -- Enable text objects
          lookahead = true, -- Automatically jump forward to the text object
          keymaps = {
            ["af"] = "@function.outer", -- Select around a function
            ["if"] = "@function.inner", -- Select inside a function
            ["ac"] = "@class.outer", -- Select around a class
            ["ic"] = "@class.inner", -- Select inside a class
          },
        },
        move = {
          enable = true, -- Enable moving between text objects
          set_jumps = true, -- Set jumps in the jumplist
          goto_next_start = {
            ["]m"] = "@function.outer", -- Go to the start of the next function
            ["]]"] = "@class.outer", -- Go to the start of the next class
          },
          goto_next_end = {
            ["]M"] = "@function.outer", -- Go to the end of the next function
            ["]["] = "@class.outer", -- Go to the end of the next class
          },
          goto_previous_start = {
            ["[m"] = "@function.outer", -- Go to the start of the previous function
            ["[["] = "@class.outer", -- Go to the start of the previous class
          },
          goto_previous_end = {
            ["[M"] = "@function.outer", -- Go to the end of the previous function
            ["[]"] = "@class.outer", -- Go to the end of the previous class
          },
        },
      },
    })
  end,
}
