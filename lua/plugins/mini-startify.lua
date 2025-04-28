return {
    "goolord/alpha-nvim",
    config = function()
      local alpha = require'alpha'
      local theta = require'alpha.themes.theta'
      local dashboard = require'alpha.themes.dashboard'
  
      -- Set custom header
      theta.header.val = {
        [[]],
        [[]],
        [[]],
        [[]],
        [[███╗   ███╗██╗███╗   ██╗██╗  ██╗    ██████╗ ██╗  ██╗██╗]],
        [[████╗ ████║██║████╗  ██║██║  ██║    ██╔══██╗██║  ██║██║]],
        [[██╔████╔██║██║██╔██╗ ██║███████║    ██████╔╝███████║██║]],
        [[██║╚██╔╝██║██║██║╚██╗██║██╔══██║    ██╔═══╝ ██╔══██║██║]],
        [[██║ ╚═╝ ██║██║██║ ╚████║██║  ██║    ██║     ██║  ██║██║]],
        [[╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝    ╚═╝     ╚═╝  ╚═╝╚═╝]],
      }
  
      -- Use dashboard.button for theta.buttons.val
      theta.buttons.val = {
        { type = "text", val = "Quick links", opts = { hl = "SpecialComment", position = "center" } },
        { type = "padding", val = 1 },
        dashboard.button("e", "  New file", "<cmd>ene<CR>"),
        dashboard.button("f", "  Find file", "<cmd>Telescope find_files<CR>"),
        dashboard.button("g", "󰊄  Live grep", "<cmd>Telescope live_grep<CR>"),
        dashboard.button("c", "  Configuration", "<cmd>cd $HOME/.config/nvim<CR>"),
        dashboard.button("u", "  Update plugins", "<cmd>Lazy sync<CR>"),
        dashboard.button("q", "󰅚  Quit", "<cmd>qa<CR>"),
      }
  
      theta.config.opts.noautocmd = true
      alpha.setup(theta.config)
    end
  }
