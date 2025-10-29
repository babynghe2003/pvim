return {
    "github/copilot.vim",
    -- disable copilot by default
    lazy = true,
    keys = { "<leader>ce" },
    config = function()
    vim.cmd("Copilot setup") -- Line I added
    end,
}

