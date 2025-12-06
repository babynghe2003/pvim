-- Central language module that loads all language-specific configurations
local M = {}

-- Function to load all language configurations 
function M.setup()
  -- Load language configurations
  require("language.cpp")
  require("language.rust")
  require("language.python")
  require("language.verilog")
  require("language.latex")
  
  -- Shared language settings that apply to all languages can go here
  vim.api.nvim_create_autocmd("FileType", {
    pattern = {"cpp", "c", "python", "verilog", "latex"},
    callback = function()
      -- Settings for all programming languages
      vim.opt_local.formatoptions:append("croql")
      vim.opt_local.formatoptions:remove("t")
    end,
  })
end

return M
