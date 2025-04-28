return {
  "nvim-treesitter/nvim-treesitter-context",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("treesitter-context").setup({
      enable = true, -- Enable this plugin
      max_lines = 4, -- Limit the number of context lines
      min_window_height = 0, -- No minimum window height
      line_numbers = true, -- Show line numbers in the context window
      multiline_threshold = 20, -- Maximum number of lines for a single context
      trim_scope = "outer", -- Trim outer context lines if max_lines is exceeded
      mode = "cursor", -- Use the cursor line to calculate context
      separator = nil, -- No separator between context and content
      zindex = 20, -- Z-index of the context window
      on_attach = nil, -- No custom attach function
    })

    -- Add a keybinding to toggle the context window
    vim.keymap.set("n", "<leader>tc", function()
      require("treesitter-context").toggle()
    end, { desc = "Toggle Treesitter Context" })
  end,
}
