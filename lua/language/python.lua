-- Python language configuration

-------------------------------------------------
-- Virtual Environment Detection
-------------------------------------------------
local function find_venv()
  local cwd = vim.fn.getcwd()
  local venv_path = cwd .. '/venv'
  
  if vim.fn.isdirectory(venv_path) == 1 and vim.fn.filereadable(venv_path .. '/bin/activate') == 1 then
    return venv_path
  else
    return ''
  end
end

-------------------------------------------------
-- Terminal Integration
-------------------------------------------------
-- Terminal wrapper function with virtual env support
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
  
  -- Check for virtual environment
  local venv_path = find_venv()
  local venv_prefix = ""
  if venv_path ~= "" then
    venv_prefix = "source " .. venv_path .. "/bin/activate && "
  end
  
  vim.cmd('term ' .. venv_prefix .. command)
  vim.cmd('setlocal nornu nonu')
  vim.cmd('startinsert')
  
  -- Auto-start insert mode when entering this buffer
  vim.api.nvim_create_autocmd("BufEnter", {
    buffer = 0, -- current buffer
    command = "startinsert"
  })
end

-------------------------------------------------
-- Main Setup Function
-------------------------------------------------
local function setup_python()
  -- Terminal settings
  vim.g.split_term_style = "vertical"
  vim.g.split_term_resize_cmd = "vertical resize 60"
  vim.opt.splitright = true
  
  vim.api.nvim_create_autocmd("FileType", {
    pattern = {"python"},
    callback = function()
      -- Indentation settings (PEP8)
      vim.opt_local.tabstop = 4
      vim.opt_local.shiftwidth = 4
      vim.opt_local.softtabstop = 4
      vim.opt_local.expandtab = true
      
      -- Enable docstring recognition
      vim.opt_local.textwidth = 88  -- Black formatter default
      
      -- Create Python execution commands
      vim.api.nvim_buf_create_user_command(0, 'CompileAndRunPython', function()
        local file = vim.fn.expand('%')
        term_wrapper(string.format('python3 %s', file))
      end, {})
      
      vim.api.nvim_buf_create_user_command(0, 'CompileAndRunWithFilePython', function(opts)
        local file = vim.fn.expand('%')
        local output_file = opts.args
        term_wrapper(string.format('python3 %s >> %s', file, output_file))
      end, {nargs = 1, complete = 'file'})
      
      -- Key mappings
      vim.keymap.set('n', 'fw', ':CompileAndRunPython<CR>', { buffer = true, silent = true })
      
      -- Python-specific environment setup
      local venv_path = find_venv()
      if venv_path ~= "" then
        vim.notify("Found Python virtual environment: " .. venv_path, vim.log.levels.INFO)
      elseif vim.fn.executable("poetry") == 1 then
        -- Try Poetry if no standard venv found
        vim.env.PYTHONPATH = vim.fn.system("poetry env info -p"):gsub("%s+$", "") .. "/lib/python3.*/site-packages"
      end
    end
  })
end

-- Initialize the module
setup_python()

-- Return an empty table as we're using autocmds
return {}
