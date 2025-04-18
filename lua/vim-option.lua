vim.g.mapleader = " "

vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2") 
vim.cmd("set number")
vim.cmd("set relativenumber")
vim.cmd("set clipboard=unnamedplus")
vim.cmd("set ignorecase")
vim.cmd("set smartcase")
vim.cmd("set hlsearch")

-- Auto-save and Auto-format configuration
vim.api.nvim_create_augroup("AutoSave", { clear = true })
-- Auto-save all buffers when text changes, leaving insert mode, or losing focus
vim.api.nvim_create_autocmd({"TextChanged", "InsertLeave", "FocusLost"}, {
  group = "AutoSave",
  pattern = "*",
  command = "silent! wall"
})

