return {
  "kevinhwang91/nvim-ufo",
  event = 'BufReadPost',
  dependencies = {
    "kevinhwang91/promise-async",
  },
  init = function ()
    vim.o.foldenable = true
    vim.o.foldcolumn = '0'
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
  end,
  opts = {
    provider_selector = function ()
      return { 'treesitter', 'indent'}
    end
  }

}
