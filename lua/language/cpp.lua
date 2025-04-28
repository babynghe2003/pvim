-- C++ language configuration
local M = {}

-------------------------------------------------
-- Project Detection
-------------------------------------------------
local function detect_project_type()
  local is_cmake_project = false
  local file_dir = vim.fn.expand('%:p:h')
  local root_dir = vim.fn.getcwd()
  
  -- Look for CMakeLists.txt in current directory or parent directories
  local dir_to_check = file_dir
  while dir_to_check and string.len(dir_to_check) >= string.len(root_dir) do
    if vim.fn.filereadable(dir_to_check .. '/CMakeLists.txt') == 1 then
      is_cmake_project = true
      break
    end
    -- Go up one directory
    dir_to_check = vim.fn.fnamemodify(dir_to_check, ':h')
  end
  
  return is_cmake_project
end

-------------------------------------------------
-- Terminal Integration
-------------------------------------------------
-- Terminal wrapper function
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
end

-------------------------------------------------
-- CMake Project Functions
-------------------------------------------------
local function setup_cmake_project()
  vim.opt_local.makeprg = "cmake --build build"
  vim.keymap.set("n", "<leader>ch", ":ClangdSwitchSourceHeader<CR>", { buffer = true, silent = true })
  vim.keymap.set("n", "<leader>ct", ":CMakeSelectTarget<CR>", { buffer = true, silent = true })
  vim.notify("CMake project detected", vim.log.levels.INFO)
  
  -- Check for compile_commands.json and create symlink if needed
  local root_dir = vim.fn.getcwd()
  local compile_commands_build = root_dir .. "/build/compile_commands.json"
  local compile_commands_root = root_dir .. "/compile_commands.json"
  
  if vim.fn.filereadable(compile_commands_build) == 1 then
    -- Check if symlink already exists
    if vim.fn.filereadable(compile_commands_root) == 0 then
      -- Create symlink from build/compile_commands.json to workspace root
      local cmd = string.format("ln -s %s/build/compile_commands.json %s", root_dir, root_dir)
      local success = vim.fn.system(cmd)
      
      if vim.v.shell_error == 0 then
        vim.notify("Created symlink to compile_commands.json in workspace root", vim.log.levels.INFO)
      else
        vim.notify("Failed to create symlink to compile_commands.json: " .. success, vim.log.levels.ERROR)
      end
    end
  end
  
  -- CMake-specific compile and run command
  vim.api.nvim_buf_create_user_command(0, 'CompileAndRun', function()
    term_wrapper([[cmake --build build && ./build/$(basename $(find ./build -type f -executable -not -path '*/\.*' | head -n 1))]])
  end, {})
end

-------------------------------------------------
-- Standard C++ Project Functions
-------------------------------------------------
local function setup_standard_project()
  vim.opt_local.makeprg = "g++ -std=c++2a %"
  vim.notify("Non-CMake C++ project", vim.log.levels.INFO)
  
  -- Regular compile and run commands
  vim.api.nvim_buf_create_user_command(0, 'CompileAndRun', function()
    local file = vim.fn.expand('%')
    term_wrapper(string.format('g++ -std=c++2a %s && ./a.out', file))
  end, {})
  
  vim.api.nvim_buf_create_user_command(0, 'CompileAndRunWithFile', function(opts)
    local file = vim.fn.expand('%')
    local input_file = opts.args
    term_wrapper(string.format('g++ -std=c++2a %s && ./a.out < %s', file, input_file))
  end, {nargs = 1, complete = 'file'})
  
  -- Additional keybindings for regular C++ projects
  vim.keymap.set('n', '<leader>fb', ':!g++ -std=c++2a %:r.cpp && ./a.out<CR>', { buffer = true })
  vim.keymap.set('n', '<leader>ftb', ':!g++ -std=c++2a %:r.cpp -pthread && ./a.out<CR>', { buffer = true })
  vim.keymap.set('n', '<leader>fr', ':!./%:r.out<CR>', { buffer = true })
end

-------------------------------------------------
-- Competitive Programming Templates
-------------------------------------------------
-- Initialize templates directory and files
local function init_cp_templates()
  local template_dir = vim.fn.stdpath("config") .. "/templates"
  if vim.fn.isdirectory(template_dir) == 0 then
    vim.fn.mkdir(template_dir, "p")
  end

  -- Template file paths
  local templates = {
    standard = template_dir .. "/cpp_competitive.template",
    minimal = template_dir .. "/cpp_minimal.template",
    advanced = template_dir .. "/cpp_advanced.template",
  }
  
  -- Template contents
  local template_content = {
    standard = [[
#include <bits/stdc++.h>
#define X first
#define Y second
#define pb push_back
#define ll long long
#define pii pair<int, int>
#define pll pair<long long, long long>
#define vi vector<int>
#define vll vector<long long>
#define mii map<int, int>
#define si set<int>
#define sc set<char>
#define MOD 1000000007
#define PI 3.1415926535897932384626433832795

using namespace std;

void indef(){
#ifndef ONLINE_JUDGE
    freopen("input.txt","r",stdin);
    freopen("output.txt","w",stdout);
#endif
}

void solve() {
    int n;
    cin >> n;
    cout << n;
}
 
int main() {
    ios::sync_with_stdio(false);
    cin.tie(nullptr);
    
    indef();
    
    int t = 1;
    cin >> t;
    
    while (t--) {
        solve();
    }
    
    return 0;
}
]],
    minimal = [[
#include <bits/stdc++.h>
using namespace std;

int main() {
    ios::sync_with_stdio(false);
    cin.tie(nullptr);
    
    // Your code here
    
    return 0;
}
]],
    advanced = [[
#include <bits/stdc++.h>
#define X first
#define Y second
#define pb push_back
#define eb emplace_back
#define all(x) begin(x), end(x)
#define rall(x) rbegin(x), rend(x)
#define sz(x) (int)(x).size()
#define ll long long
#define pii pair<int, int>
#define pll pair<long long, long long>
#define vi vector<int>
#define vll vector<long long>
#define mii map<int, int>
#define si set<int>
#define sc set<char>
#define MOD 1000000007
#define INF 1e18
#define EPS 1e-9
#define PI 3.1415926535897932384626433832795

using namespace std;

// Fast I/O setup
void indef(){
#ifndef ONLINE_JUDGE
    freopen("input.txt","r",stdin);
    freopen("output.txt","w",stdout);
#endif
}

// Debug macro
#ifdef DEBUG
#define debug(x) cerr << #x << " = " << x << endl
#else
#define debug(x)
#endif

// Utility functions
template<typename T> inline void chmax(T &a, T b) { a = max(a, b); }
template<typename T> inline void chmin(T &a, T b) { a = min(a, b); }

void solve() {
    int n;
    cin >> n;
    cout << n << "\n";
}
 
int main() {
    ios::sync_with_stdio(false);
    cin.tie(nullptr);
    
    indef();
    
    int t = 1;
    cin >> t;
    
    while (t--) {
        solve();
    }
    
    return 0;
}
]]
  }

  -- Write templates to files if they don't exist
  for name, content in pairs(template_content) do
    local file_path = templates[name]
    if vim.fn.filereadable(file_path) == 0 then
      local file = io.open(file_path, "w")
      if file then
        file:write(content)
        file:close()
      end
    end
  end
  
  return templates
end

-- Load a specific CP template
local function load_cp_template(template_type, create_io)
  local templates = {
    standard = vim.fn.stdpath("config") .. "/templates/cpp_competitive.template",
    minimal = vim.fn.stdpath("config") .. "/templates/cpp_minimal.template",
    advanced = vim.fn.stdpath("config") .. "/templates/cpp_advanced.template",
  }
  
  return function()
    -- Read the template file
    local file_path = templates[template_type]
    if vim.fn.filereadable(file_path) == 1 then
      local lines = vim.fn.readfile(file_path)
      -- Clear current buffer and add template content
      vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
      
      -- Create input/output files if requested
      if create_io then
        vim.cmd('vnew output.txt | new input.txt')
      end
      
      -- Move cursor to a good starting position - find the solve() function
      local solve_line = 0
      for i, line in ipairs(lines) do
        if line:match("void solve%(%)")  then
          solve_line = i + 1
          break
        end
      end
      
      if solve_line > 0 then
        vim.api.nvim_win_set_cursor(0, {solve_line + 1, 4}) -- +1 because lines are 1-indexed, indent 4 spaces
      end
    else
      vim.notify("Template file not found: " .. file_path, vim.log.levels.ERROR)
    end
  end
end

-- Template selection menu
local function select_template(create_io)
  local items = {
    {text = "Standard", value = "standard"},
    {text = "Minimal", value = "minimal"},
    {text = "Advanced", value = "advanced"},
  }
  
  vim.ui.select(items, {
    prompt = "Select a template:",
    format_item = function(item)
      return item.text
    end
  }, function(choice)
    if choice then
      load_cp_template(choice.value, create_io)()
    end
  end)
end

-------------------------------------------------
-- Main Setup Function
-------------------------------------------------
local function setup_cpp()
  -- Initialize templates
  init_cp_templates()
  
  -- Register basic commands
  vim.api.nvim_create_user_command("CMakeInit", function()
    vim.fn.system("mkdir -p build && cd build && cmake ..")
    vim.notify("CMake project initialized in build/", vim.log.levels.INFO)
  end, {})

  -- Setup FileType autocommand
  vim.api.nvim_create_autocmd("FileType", {
    pattern = {"cpp", "c", "h", "hpp"},
    callback = function()
      -- Basic editor settings
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.softtabstop = 2
      vim.opt_local.expandtab = true
      vim.opt_local.cindent = true
      vim.opt_local.cinoptions = "g0,N-s,j1,(0,ws,Ws"
      
      -- Terminal settings
      vim.g.split_term_style = "vertical"
      vim.g.split_term_resize_cmd = "vertical resize 60"
      vim.opt.splitright = true
      
      -- Detect project type and apply specific settings
      local is_cmake_project = detect_project_type()
      if is_cmake_project then
        setup_cmake_project()
      else
        setup_standard_project()
      end
      
      -- Common keybindings
      vim.keymap.set('n', 'fw', ':CompileAndRun<CR>', { buffer = true, silent = true })
      vim.keymap.set('n', '<leader>iof', ':vnew output.txt | new input.txt <CR>', { buffer = true, silent = true })
      
      -- CP template keybindings
      vim.keymap.set('n', '<leader>cpf', function() select_template(false) end, 
        { buffer = true, desc = "Load CP template" })
        
      vim.keymap.set('n', '<leader>cpif', function() select_template(true) end,
        { buffer = true, desc = "Load CP template with I/O files" })
    end
  })
end

-- Initialize the module
setup_cpp()

return M
