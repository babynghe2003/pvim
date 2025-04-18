local builtin = require("telescope.builtin")
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<C-f>', builtin.live_grep, {})

vim.keymap.set('n', '<C-h>', '<C-w>h',{})
vim.keymap.set('n', '<C-j>', '<C-w>j',{})
vim.keymap.set('n', '<C-k>', '<C-w>k',{})
vim.keymap.set('n', '<C-l>', '<C-w>l',{})

-- Move lines up and down with Alt+j/k
vim.keymap.set('n', '<M-j>', ':m+<CR>==', { noremap = true, silent = true })
vim.keymap.set('n', '<M-k>', ':m-2<CR>==', { noremap = true, silent = true })
vim.keymap.set('i', '<M-j>', '<Esc>:m+<CR>==gi', { noremap = true, silent = true })
vim.keymap.set('i', '<M-k>', '<Esc>:m-2<CR>==gi', { noremap = true, silent = true })
vim.keymap.set('v', '<M-j>', ":m'>+<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set('v', '<M-k>', ":m-2<CR>gv=gv", { noremap = true, silent = true })

-- Remove Windows ^M characters
vim.keymap.set('n', '<Leader>m', "mmHmt:%s/\r//ge<cr>'tzt'm", { noremap = true })

-- Increase and decrease window size
vim.keymap.set('n', '<C-S-Right>', ':vertical resize +5<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-S-Left>', ':vertical resize -5<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-S-Up>', ':resize +5<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-S-Down>', ':resize -5<CR>', { noremap = true, silent = true })

-- Highlight word under cursor with double-click
vim.keymap.set('n', '<2-LeftMouse>', ":let @/='\\V\\<'.escape(expand('<cword>'), '\\').'\\'<cr>:set hls<cr>", 
               { noremap = true, silent = true })

-- Clear search highlights with Escape key
vim.keymap.set('n', '<Esc>', ':nohl<CR>', { noremap = true, silent = true })

-- LSP keybindings
-- Rename the symbol under cursor (function, variable, etc.)
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { noremap = true, silent = true, desc = "Rename symbol" })

-- Format current buffer
vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, { noremap = true, silent = true, desc = "Format buffer" })

-- Code actions (like quick fixes)
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { noremap = true, silent = true, desc = "Code actions" })

-- Go to definition
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { noremap = true, silent = true, desc = "Go to definition" })

-- Show hover information
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { noremap = true, silent = true, desc = "Show hover info" })
