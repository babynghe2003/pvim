return {{
  'mg979/vim-visual-multi',
  lazy = false,
  branch = "master",
  init = function () 
    vim.g.VM_default_mappings = 0
    vim.g.VM_leader = '\\'
    vim.g.VM_mouse_mappings = 1
    vim.g.VM_maps = {}

    vim.g.VM_maps = {
      ['Find Under']         = '<C-d>',
      ['Find Subword Under'] = '<C-d>',
      ["Select Cursor Down"] = '<M-S-Down>',
      ["Select Cursor Up"]   = '<M-S-Up>',

      ["Mouse Cursor"]                = '<M-LeftMouse>',
      ["Mouse Word"]                  = '<M-RightMouse>',
      ["Mouse Column"]                = '<M-S-RightMouse>',
    }
  end
},
{
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = "cd app && npm install",
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
  end,
  ft = { "markdown" },
},
{
  'https://gitlab.com/itaranto/plantuml.nvim',
  version = '*',
  config = function() require('plantuml').setup() end,
}
}
