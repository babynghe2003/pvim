return {
  "github/copilot.vim",
  -- enable copilot by default
  lazy = false,
  -- keys = { "<leader>c" },
  config = function()
    -- vim.cmd("Copilot setup") -- Line I added
    -- set C-L to accept
    vim.api.nvim_set_keymap("i", "<C-L>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
  end
}

