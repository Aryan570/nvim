-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
     {
       "scottmckendry/cyberdream.nvim",
       lazy = false,
       priority = 1000,
       config = function()
            require("cyberdream").setup({
                transparent = true, -- 透明
                italic_comments = true, -- 斜体注释
                hide_fillchars = true, -- 隐藏fillchars ,比如md中的#
                terminal_colors = true, -- 终端颜色
                --cache = true, -- 缓存
                borderless_telescope = { border = false, style = "flat" }, -- 无边框的telescope
                theme = {
			variant = "default",
		        colors = {
			    background =  "#16181a",
			    black = "#16181a",
			    blue = "#5ea1ff",
			    brightBlack = "#3c4048",
			    brightBlue = "#5ea1ff",
			    brightCyan = "#5ef1ff",
			    brightGreen = "#5eff6c",
			    brightPurple = "#bd5eff",
			    brightRed = "#ff6e5e",
			    brightWhite = "#ffffff",
			    brightYellow = "#f1ff5e",
			    cursorColor = "#ffffff",
			    cyan = "#5ef1ff",
			    foreground = "#ffffff",
			    green = "#5eff6c",
			    name =  "cyberdream",
			    purple = "#bd5eff",
			    red = "#ff6e5e",
			    selectionBackground =  "#3c4048",
			    white = "#ffffff",
			    yellow ="#f1ff5e",
		     }
		}, -- 主题
		extensions = {
			telescope = true,
			notify = true,
			mini = true,
		},
            })
	    vim.cmd("colorscheme cyberdream") 
            -- vim.api.nvim_set_keymap("n", "<leader>tt", ":CyberdreamToggleMode<CR>", { noremap = true, silent = true })
        end,
     },
     {
       'nvim-telescope/telescope.nvim', tag = '0.1.8',
        dependencies = { 'nvim-lua/plenary.nvim' }
     },
     { "nvim-treesitter/nvim-treesitter",
       build = ":TSUpdate"
     },
     {
	  "folke/noice.nvim",
	  event = "VeryLazy",
	  opts = {
	    -- add any options here
	  },
	  dependencies = {
	    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
	    "MunifTanjim/nui.nvim",
	    -- OPTIONAL:
	    --   `nvim-notify` is only needed, if you want to use the notification view.
	    --   If not available, we use `mini` as the fallback
	    "rcarriga/nvim-notify",
	  }
      },
      {
	  "folke/todo-comments.nvim",
	  dependencies = { "nvim-lua/plenary.nvim" },
	  opts = {
	    -- your configuration comes here
	    -- or leave it empty to use the default settings
	    -- refer to the configuration section below
	  }
       }
    --[[ {
	  "nvim-treesitter/nvim-treesitter",
	  version = false, -- last release is way too old and doesn't work on Windows
	  build = ":TSUpdate",
	  event = { "LazyFile", "VeryLazy" },
	  --event = { "BufRead", "BufWinEnter" },
	  lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
	  init = function(plugin)
	    -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
	    -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
	    -- no longer trigger the **nvim-treesitter** module to be loaded in time.
	    -- Luckily, the only things that those plugins need are the custom queries, which we make available
	    -- during startup.
	    require("lazy.core.loader").add_to_rtp(plugin)
	    require("nvim-treesitter.query_predicates")
	  end,
	  cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
	  keys = {
	    { "<c-space>", desc = "Increment Selection" },
	    { "<bs>", desc = "Decrement Selection", mode = "x" },
	  },
	  opts_extend = { "ensure_installed" },
	  ---@type TSConfig
	  ---@diagnostic disable-next-line: missing-fields
	  opts = {
	    highlight = { enable = true },
	    indent = { enable = true },
	    auto_install = true,
	    ensure_installed = {
	      "bash",
	      "c",
	      "diff",
	      "html",
	      "javascript",
	      "jsdoc",
	      "json",
	      "jsonc",
	      "lua",
	      "luadoc",
	      "luap",
	      "markdown",
	      "markdown_inline",
	      "printf",
	      "python",
	      "query",
	      "regex",
	      "toml",
	      "tsx",
	      "typescript",
	      "vim",
	      "vimdoc",
	      "xml",
	      "yaml",
	      "rust",
	    },
	    incremental_selection = {
	      enable = true,
	      keymaps = {
		init_selection = "<C-space>",
		node_incremental = "<C-space>",
		scope_incremental = false,
		node_decremental = "<bs>",
	      },
	    },
	    textobjects = {
	      move = {
		enable = true,
		goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
		goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
		goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
		goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
	      },
	    },
	  },
	  ---@param opts TSConfig
	  config = function(_, opts)
	    if type(opts.ensure_installed) == "table" then
	      opts.ensure_installed = LazyVim.dedup(opts.ensure_installed)
	    end
	    require("nvim-treesitter.configs").setup(opts)
	  end,
	},]]--
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "cyberdream" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
require 'nvim-treesitter.install'.compilers = { "gcc", "C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\VC\\Tools\\MSVC\\14.41.34120\\bin\\Hostx64\\x64\\cl" }
vim.cmd("set number")
vim.wo.relativenumber = true
