-- Rust language configuration

-------------------------------------------------
-- Terminal Integration
-------------------------------------------------
-- Terminal wrapper function for Rust
local function term_wrapper(command)
  local buffercmd
  if vim.g.split_term_style == "vertical" then
    buffercmd = "vnew"
  elseif vim.g.split_term_style == "horizontal" then
    buffercmd = "new"
  else
    vim.notify("ERROR! g:split_term_style is not a valid value (must be 'horizontal' or 'vertical')", vim.log.levels.ERROR)
    return
  end

  vim.cmd(buffercmd)
  if vim.g.split_term_resize_cmd then
    vim.cmd(vim.g.split_term_resize_cmd)
  end

  vim.cmd('term ' .. command)
  vim.cmd('setlocal nornu nonu')
  vim.cmd('startinsert')

  vim.api.nvim_create_autocmd("BufEnter", {
    buffer = 0,
    command = "startinsert"
  })
end

-------------------------------------------------
-- Main Setup Function
-------------------------------------------------
local function setup_rust()
  vim.g.split_term_style = "vertical"
  vim.g.split_term_resize_cmd = "vertical resize 60"
  vim.opt.splitright = true

  vim.api.nvim_create_autocmd("FileType", {
    pattern = {"rust"},
    callback = function()
      -- Indentation settings
      vim.opt_local.tabstop = 4
      vim.opt_local.shiftwidth = 4
      vim.opt_local.softtabstop = 4
      vim.opt_local.expandtab = true

      -- Create Rust execution commands
      vim.api.nvim_buf_create_user_command(0, 'CargoRun', function()
        term_wrapper('cargo run')
      end, {})

      vim.api.nvim_buf_create_user_command(0, 'CargoBuild', function()
        term_wrapper('cargo build')
      end, {})

      vim.api.nvim_buf_create_user_command(0, 'CargoTest', function()
        term_wrapper('cargo test')
      end, {})

      -- Key mappings
      vim.keymap.set('n', 'fw', ':CargoRun<CR>', { buffer = true, silent = true })
      vim.keymap.set('n', 'fb', ':CargoBuild<CR>', { buffer = true, silent = true })
      vim.keymap.set('n', 'ft', ':CargoTest<CR>', { buffer = true, silent = true })
    end
  })
end

-- Initialize the module
setup_rust()

return {}
