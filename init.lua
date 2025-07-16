vim.g.mapleader = " "
vim.g.maplocalleader = " "
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
--vim.g.mapleader = " "
--vim.g.maplocalleader = " "

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		--[[		{
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
					borderless_telescope = { border = false, style = "flat" }, 
					theme = {
						variant = "default",
						colors = {
							background = "#16181a",
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
							name = "cyberdream",
							purple = "#bd5eff",
							red = "#ff6e5e",
							selectionBackground = "#3c4048",
							white = "#ffffff",
							yellow = "#f1ff5e",
						},
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
		},]]
		--
		{
			"rose-pine/neovim",
			name = "rose-pine",
			config = function()
				require("rose-pine").setup({
					variant = "auto", -- auto, main, moon, or dawn
					dark_variant = "main", -- main, moon, or dawn
					dim_inactive_windows = false,
					extend_background_behind_borders = true,

					enable = {
						terminal = true,
						legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
						migrations = true, -- Handle deprecated options automatically
					},

					styles = {
						bold = true,
						italic = true,
						transparency = true,
					},

					groups = {
						border = "muted",
						link = "iris",
						panel = "surface",

						error = "love",
						hint = "iris",
						info = "foam",
						note = "pine",
						todo = "rose",
						warn = "gold",

						git_add = "foam",
						git_change = "rose",
						git_delete = "love",
						git_dirty = "rose",
						git_ignore = "muted",
						git_merge = "iris",
						git_rename = "pine",
						git_stage = "iris",
						git_text = "rose",
						git_untracked = "subtle",

						h1 = "iris",
						h2 = "foam",
						h3 = "rose",
						h4 = "gold",
						h5 = "pine",
						h6 = "foam",
					},

					palette = {
						-- Override the builtin palette per variant
						-- moon = {
						--     base = '#18191a',
						--     overlay = '#363738',
						-- },
					},

					-- NOTE: Highlight groups are extended (merged) by default. Disable this
					-- per group via `inherit = false`
					highlight_groups = {
						-- Comment = { fg = "foam" },
						-- StatusLine = { fg = "love", bg = "love", blend = 15 },
						-- VertSplit = { fg = "muted", bg = "muted" },
						-- Visual = { fg = "base", bg = "text", inherit = false },
					},

					before_highlight = function(group, highlight, palette)
						-- Disable all undercurls
						-- if highlight.undercurl then
						--     highlight.undercurl = false
						-- end
						--
						-- Change palette colour
						-- if highlight.fg == palette.pine then
						--     highlight.fg = palette.foam
						-- end
					end,
				})

				vim.cmd("colorscheme rose-pine")
				-- vim.cmd("colorscheme rose-pine-main")
				-- vim.cmd("colorscheme rose-pine-moon")
				-- vim.cmd("colorscheme rose-pine-dawn")
			end,
		},
		-- { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' },
		{
			"nvim-telescope/telescope.nvim",
			tag = "0.1.8",
			event = "VimEnter",
			dependencies = {
				"nvim-lua/plenary.nvim",
				{ "nvim-telescope/telescope-ui-select.nvim" },
				{
					"nvim-telescope/telescope-fzf-native.nvim",
					build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
				},
			},
			config = function()
				require("telescope").setup({})
				require("telescope").load_extension("fzf")
				require("telescope").load_extension("file_browser")
				pcall(require("telescope").load_extension, "ui-select")
				local builtin = require("telescope.builtin")
				vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
				vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
				vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
				--vim.keymap.set("n", "<leader>sf", ":Telescope find_files path=%:p:h <CR>")
				vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
				vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
				vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
				vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
				vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
				vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
				vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
				vim.keymap.set("n", "<space>fb", ":Telescope file_browser path=%:p:h select_buffer=true<CR>")
				--vim.keymap.set("n", "<space>fb", ":Telescope file_browser<CR>")
				vim.keymap.set("n", "<leader>sn", function()
					builtin.find_files({ cwd = vim.fn.stdpath("config") })
				end, { desc = "[S]earch [N]eovim files" })
			end,
		},
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			main = "nvim-treesitter.configs",
			opts = {
				ensure_installed = {
					"bash",
					"c",
					"diff",
					"html",
					"lua",
					"luadoc",
					"markdown",
					"markdown_inline",
					"query",
					"vim",
					"vimdoc",
				},
				-- Autoinstall languages that are not installed
				auto_install = true,
				highlight = {
					enable = true,
					-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
					--  If you are experiencing weird indenting issues, add the language to
					--  the list of additional_vim_regex_highlighting and disabled languages for indent.
					-- additional_vim_regex_highlighting = { 'ruby' },
				},
				indent = { enable = true },
			},
		},
		{
			"nvim-telescope/telescope-file-browser.nvim",
			dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
		},
		{
			"folke/which-key.nvim",
			event = "VeryLazy",
			opts = {
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			},
			keys = {
				{
					"<leader>?",
					function()
						require("which-key").show({ global = false })
					end,
					desc = "Buffer Local Keymaps (which-key)",
				},
			},
		},
		{
			"nvimdev/dashboard-nvim",
			event = "VimEnter",
			config = function()
				require("dashboard").setup({
					-- config
					config = {
						week_header = {
							enable = true,
						},
						shortcut = {
							{ desc = "󰊳 Update", group = "@property", action = "Lazy update", key = "u" },
							{
								icon = " ",
								icon_hl = "@variable",
								desc = "Files",
								group = "Label",
								action = "Telescope find_files",
								key = "f",
							},
							{
								desc = " Apps",
								group = "DiagnosticHint",
								action = "Telescope app",
								key = "a",
							},
							{
								desc = " dotfiles",
								group = "Number",
								action = "Telescope dotfiles",
								key = "d",
							},
						},
					},
				})
			end,
			dependencies = { { "nvim-tree/nvim-web-devicons" } },
		},
		{
			"rcarriga/nvim-notify",
			lazy = false,
			opts = {
				background_colour = "#993366",
				timeout = 3000,
			},
			config = function(_, opts)
				require("notify").setup(opts)
				vim.notify = require("notify")
			end,
		},
		{
			"folke/noice.nvim",
			event = "VeryLazy",
			opts = {},
			dependencies = {
				"MunifTanjim/nui.nvim",
				"rcarriga/nvim-notify",
			},
		},
		{
			"folke/todo-comments.nvim",
			dependencies = { "nvim-lua/plenary.nvim" },
			opts = {
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			},
		},
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = function()
				require("lualine").setup({
					options = {
						--- @usage 'rose-pine' | 'rose-pine-alt'
						theme = "rose-pine",
					},
				})
			end,
		},

		{
			"echasnovski/mini.nvim",
			version = "*",
			config = function()
				require("mini.ai").setup({ n_lines = 500 })
				require("mini.surround").setup()
				require("mini.files").setup()
				require("mini.clue").setup()
				require("mini.pairs").setup()
				--local statusline = require 'mini.statusline'
				--statusline.setup {use_icons = vim.g.have_nerd_font}
			end,
		},
		--[[	{
			"akinsho/bufferline.nvim",
			dependencies = {
				"nvim-tree/nvim-web-devicons",
			},
			config = function()
				require("bufferline").setup({})
			end,
		},]]
		--

		-- LSP config
		{
			-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
			-- used for completion, annotations and signatures of Neovim apis
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {
				library = {
					-- Load luvit types when the `vim.uv` word is found
					{ path = "luvit-meta/library", words = { "vim%.uv" } },
				},
			},
		},
		{ "Bilal2453/luvit-meta", lazy = true },
		{
			-- Main LSP Configuration
			"neovim/nvim-lspconfig",
			dependencies = {
				-- Automatically install LSPs and related tools to stdpath for Neovim
				{ "williamboman/mason.nvim", config = true, version = "1.11.0" }, -- NOTE: Must be loaded before dependants
				{ "williamboman/mason-lspconfig.nvim", version = "1.32.0" },
				"WhoIsSethDaniel/mason-tool-installer.nvim",

				-- Useful status updates for LSP.
				-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
				{
					"j-hui/fidget.nvim",
					opts = {
						progress = {
							display = {
								progress_style = "NormalFloat",
								group_style = "NormalFloat",
								icon_style = "NormalFloat",
								done_style = "NormalFloat",
							},
						},
						notification = {
							window = {
								winblend = 0,
								normal_hl = "",
							},
						},
					},
				},
				-- Allows extra capabilities provided by nvim-cmp
				"hrsh7th/cmp-nvim-lsp",
			},
			config = function()
				-- Brief aside: **What is LSP?**
				--
				-- LSP is an initialism you've probably heard, but might not understand what it is.
				--
				-- LSP stands for Language Server Protocol. It's a protocol that helps editors
				-- and language tooling communicate in a standardized fashion.
				--
				-- In general, you have a "server" which is some tool built to understand a particular
				-- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
				-- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
				-- processes that communicate with some "client" - in this case, Neovim!
				--
				-- LSP provides Neovim with features like:
				--  - Go to definition
				--  - Find references
				--  - Autocompletion
				--  - Symbol Search
				--  - and more!
				--
				-- Thus, Language Servers are external tools that must be installed separately from
				-- Neovim. This is where `mason` and related plugins come into play.
				--
				-- If you're wondering about lsp vs treesitter, you can check out the wonderfully
				-- and elegantly composed help section, `:help lsp-vs-treesitter`

				--  This function gets run when an LSP attaches to a particular buffer.
				--    That is to say, every time a new file is opened that is associated with
				--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
				--    function will be executed to configure the current buffer
				vim.api.nvim_create_autocmd("LspAttach", {
					group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
					callback = function(event)
						-- NOTE: Remember that Lua is a real programming language, and as such it is possible
						-- to define small helper and utility functions so you don't have to repeat yourself.
						--
						-- In this case, we create a function that lets us more easily define mappings specific
						-- for LSP related items. It sets the mode, buffer and description for us each time.
						local map = function(keys, func, desc, mode)
							mode = mode or "n"
							vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
						end

						-- Jump to the definition of the word under your cursor.
						--  This is where a variable was first declared, or where a function is defined, etc.
						--  To jump back, press <C-t>.
						map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

						-- Find references for the word under your cursor.
						map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

						-- Jump to the implementation of the word under your cursor.
						--  Useful when your language has ways of declaring types without an actual implementation.
						map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

						-- Jump to the type of the word under your cursor.
						--  Useful when you're not sure what type a variable is and you want to see
						--  the definition of its *type*, not where it was *defined*.
						map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

						-- Fuzzy find all the symbols in your current document.
						--  Symbols are things like variables, functions, types, etc.
						map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

						-- Fuzzy find all the symbols in your current workspace.
						--  Similar to document symbols, except searches over your entire project.
						map(
							"<leader>ws",
							require("telescope.builtin").lsp_dynamic_workspace_symbols,
							"[W]orkspace [S]ymbols"
						)

						-- Rename the variable under your cursor.
						--  Most Language Servers support renaming across files, etc.
						map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

						-- Execute a code action, usually your cursor needs to be on top of an error
						-- or a suggestion from your LSP for this to activate.
						map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

						-- WARN: This is not Goto Definition, this is Goto Declaration.
						--  For example, in C this would take you to the header.
						map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

						-- The following two autocommands are used to highlight references of the
						-- word under your cursor when your cursor rests there for a little while.
						--    See `:help CursorHold` for information about when this is executed
						--
						-- When you move your cursor, the highlights will be cleared (the second autocommand).
						local client = vim.lsp.get_client_by_id(event.data.client_id)
						if
							client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight)
						then
							local highlight_augroup =
								vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
							vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
								buffer = event.buf,
								group = highlight_augroup,
								callback = vim.lsp.buf.document_highlight,
							})

							vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
								buffer = event.buf,
								group = highlight_augroup,
								callback = vim.lsp.buf.clear_references,
							})

							vim.api.nvim_create_autocmd("LspDetach", {
								group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
								callback = function(event2)
									vim.lsp.buf.clear_references()
									vim.api.nvim_clear_autocmds({
										group = "kickstart-lsp-highlight",
										buffer = event2.buf,
									})
								end,
							})
						end

						-- The following code creates a keymap to toggle inlay hints in your
						-- code, if the language server you are using supports them
						--
						-- This may be unwanted, since they displace some of your code
						if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
							map("<leader>th", function()
								vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
							end, "[T]oggle Inlay [H]ints")
						end
					end,
				})

				-- Change diagnostic symbols in the sign column (gutter)
				-- if vim.g.have_nerd_font then
				--   local signs = { ERROR = '', WARN = '', INFO = '', HINT = '' }
				--   local diagnostic_signs = {}
				--   for type, icon in pairs(signs) do
				--     diagnostic_signs[vim.diagnostic.severity[type]] = icon
				--   end
				--   vim.diagnostic.config { signs = { text = diagnostic_signs } }
				-- end

				-- LSP servers and clients are able to communicate to each other what features they support.
				--  By default, Neovim doesn't support everything that is in the LSP specification.
				--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
				--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
				local capabilities = vim.lsp.protocol.make_client_capabilities()
				capabilities =
					vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

				-- Enable the following language servers
				--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
				--
				--  Add any additional override configuration in the following tables. Available keys are:
				--  - cmd (table): Override the default command used to start the server
				--  - filetypes (table): Override the default list of associated filetypes for the server
				--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
				--  - settings (table): Override the default settings passed when initializing the server.
				--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
				local servers = {
					-- clangd = {},
					-- gopls = {},
					-- pyright = {},
					rust_analyzer = {},
					-- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
					--
					-- Some languages (like typescript) have entire language plugins that can be useful:
					--    https://github.com/pmizio/typescript-tools.nvim
					--
					-- But for many setups, the LSP (`ts_ls`) will work just fine
					-- ts_ls = {},
					--

					lua_ls = {
						-- cmd = {...},
						-- filetypes = { ...},
						-- capabilities = {},
						settings = {
							Lua = {
								completion = {
									callSnippet = "Replace",
								},
								-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
								-- diagnostics = { disable = { 'missing-fields' } },
								workspace = {
									library = {
										[vim.fn.expand("$VIMRUNTIME/lua")] = true,
										[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
										--[vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types"] = true,
										[vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy"] = true,
									},
									maxPreload = 100000,
									preloadFileSize = 10000,
								},
							},
						},
					},
				}

				-- Ensure the servers and tools above are installed
				--  To check the current status of installed tools and/or manually install
				--  other tools, you can run
				--    :Mason
				--
				--  You can press `g?` for help in this menu.
				require("mason").setup()
				-- You can add other tools here that you want Mason to install
				-- for you, so that they are available from within Neovim.
				local ensure_installed = vim.tbl_keys(servers or {})
				vim.list_extend(ensure_installed, {
					"stylua", -- Used to format Lua code
				})
				require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

				require("mason-lspconfig").setup({
					handlers = {
						function(server_name)
							local server = servers[server_name] or {}
							-- This handles overriding only values explicitly passed
							-- by the server configuration above. Useful when disabling
							-- certain features of an LSP (for example, turning off formatting for ts_ls)
							server.capabilities =
								vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
							require("lspconfig")[server_name].setup(server)
						end,
					},
				})
			end,
		},
		{ -- Autoformat
			"stevearc/conform.nvim",
			event = { "BufWritePre" },
			cmd = { "ConformInfo" },
			keys = {
				{
					"<leader>f",
					function()
						require("conform").format({ async = true, lsp_format = "fallback" })
					end,
					mode = "",
					desc = "[F]ormat buffer",
				},
			},
			opts = {
				notify_on_error = false,
				format_on_save = function(bufnr)
					-- Disable "format_on_save lsp_fallback" for languages that don't
					-- have a well standardized coding style. You can add additional
					-- languages here or re-enable it for the disabled ones.
					local disable_filetypes = { c = true, cpp = true, rust = false, lua = false }
					local lsp_format_opt
					if disable_filetypes[vim.bo[bufnr].filetype] then
						lsp_format_opt = "never"
					else
						lsp_format_opt = "fallback"
					end
					return {
						timeout_ms = 500,
						lsp_format = lsp_format_opt,
					}
				end,
				formatters_by_ft = {
					lua = { "stylua" },
					-- Conform can also run multiple formatters sequentially
					-- python = { "isort", "black" },
					--
					-- You can use 'stop_after_first' to run the first available formatter from the list
					-- javascript = { "prettierd", "prettier", stop_after_first = true },
				},
			},
		},
		{ -- Autocompletion
			"hrsh7th/nvim-cmp",
			event = "InsertEnter",
			dependencies = {
				-- Snippet Engine & its associated nvim-cmp source
				{
					"L3MON4D3/LuaSnip",
					build = (function()
						-- Build Step is needed for regex support in snippets.
						-- This step is not supported in many windows environments.
						-- Remove the below condition to re-enable on windows.
						if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
							return
						end
						return "make install_jsregexp"
					end)(),
					dependencies = {
						-- `friendly-snippets` contains a variety of premade snippets.
						--    See the README about individual language/framework/plugin snippets:
						--    https://github.com/rafamadriz/friendly-snippets
						-- {
						--   'rafamadriz/friendly-snippets',
						--   config = function()
						--     require('luasnip.loaders.from_vscode').lazy_load()
						--   end,
						-- },
					},
				},
				"saadparwaiz1/cmp_luasnip",

				-- Adds other completion capabilities.
				--  nvim-cmp does not ship with all sources by default. They are split
				--  into multiple repos for maintenance purposes.
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-path",
			},
			config = function()
				-- See `:help cmp`
				local cmp = require("cmp")
				local luasnip = require("luasnip")
				luasnip.config.setup({})

				cmp.setup({
					snippet = {
						expand = function(args)
							luasnip.lsp_expand(args.body)
						end,
					},
					completion = { completeopt = "menu,menuone,noinsert" },

					-- For an understanding of why these mappings were
					-- chosen, you will need to read `:help ins-completion`
					--
					-- No, but seriously. Please read `:help ins-completion`, it is really good!
					mapping = cmp.mapping.preset.insert({
						-- Select the [n]ext item
						["<C-n>"] = cmp.mapping.select_next_item(),
						-- Select the [p]revious item
						["<C-p>"] = cmp.mapping.select_prev_item(),

						-- Scroll the documentation window [b]ack / [f]orward
						["<C-b>"] = cmp.mapping.scroll_docs(-4),
						["<C-f>"] = cmp.mapping.scroll_docs(4),

						-- Accept ([y]es) the completion.
						--  This will auto-import if your LSP supports it.
						--  This will expand snippets if the LSP sent a snippet.
						["<C-y>"] = cmp.mapping.confirm({ select = true }),

						-- If you prefer more traditional completion keymaps,
						-- you can uncomment the following lines
						--['<CR>'] = cmp.mapping.confirm { select = true },
						--['<Tab>'] = cmp.mapping.select_next_item(),
						--['<S-Tab>'] = cmp.mapping.select_prev_item(),

						-- Manually trigger a completion from nvim-cmp.
						--  Generally you don't need this, because nvim-cmp will display
						--  completions whenever it has completion options available.
						["<C-Space>"] = cmp.mapping.complete({}),

						-- Think of <c-l> as moving to the right of your snippet expansion.
						--  So if you have a snippet that's like:
						--  function $name($args)
						--    $body
						--  end
						--
						-- <c-l> will move you to the right of each of the expansion locations.
						-- <c-h> is similar, except moving you backwards.
						["<C-l>"] = cmp.mapping(function()
							if luasnip.expand_or_locally_jumpable() then
								luasnip.expand_or_jump()
							end
						end, { "i", "s" }),
						["<C-h>"] = cmp.mapping(function()
							if luasnip.locally_jumpable(-1) then
								luasnip.jump(-1)
							end
						end, { "i", "s" }),

						-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
						--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
					}),
					sources = {
						{
							name = "lazydev",
							-- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
							group_index = 0,
						},
						{ name = "nvim_lsp" },
						{ name = "luasnip" },
						{ name = "path" },
					},
				})
			end,
		},

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
	},]]
		--
	},
	ui = {
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
		--backdrop = 100,
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "rose-pine" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})
-- have to download god damn clang
require("nvim-treesitter.install").prefer_git = false
require("nvim-treesitter.install").compilers = { "zig" }
vim.cmd("set number")
vim.wo.relativenumber = true
--require('mini.icons').setup()
-- Fix the line numbers
function LineNumberColors()
	vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "grey" })
	vim.api.nvim_set_hl(0, "LineNr", { fg = "white" })
	vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "grey" })
end
LineNumberColors()
-- chnage the title of the wezterm
vim.api.nvim_create_autocmd({ "BufEnter" }, {
	callback = function(event)
		local title = "vim"
		if event.file ~= "" then
			title = string.format("%s", vim.fs.basename(event.file))
		end

		vim.fn.system({ "wezterm", "cli", "set-tab-title", title })
	end,
})
-- change title back to the "Wezterm"
vim.api.nvim_create_autocmd({ "VimLeave" }, {
	callback = function()
		-- Setting title to empty string causes wezterm to revert to its
		-- default behavior of setting the tab title automatically
		vim.fn.system({ "wezterm", "cli", "set-tab-title", "Wezterm" })
	end,
})
vim.api.nvim_set_hl(0, "Visual", { bg = "#993366", blend = 100 })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })

-- Fidget-specific highlights
vim.api.nvim_set_hl(0, "FidgetTitle", { fg = "#eb6f92", bg = "none", bold = true })
vim.api.nvim_set_hl(0, "FidgetTask", { fg = "#6e6a86", bg = "none" })
vim.api.nvim_set_hl(0, "FidgetSpinner", { fg = "#9ccfd8", bg = "none" })
vim.api.nvim_set_hl(0, "FidgetTaskLine", { bg = "none" })
