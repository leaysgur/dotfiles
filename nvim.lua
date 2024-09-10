-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Ui
vim.opt.number = true
vim.opt.list = true
vim.opt.listchars = { tab = "__" }
vim.opt.completeopt = { "menu", "menuone", "noselect" }
-- Use global status line
vim.opt.laststatus = 3
-- Prefer soft tab
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- Misc
vim.opt.swapfile = false
vim.opt.autochdir = true
vim.opt.autoread = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 500

-- Keep visual mode after indentation
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
-- Clear search highlight
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR><Esc>", { silent = true })

-- Event for buffer loaded
-- See https://github.com/LazyVim/LazyVim/discussions/1583
local LazyFile = { "BufReadPost", "BufNewFile", "BufWritePre" }

-- Setup lazy.nvim
require("lazy").setup({
	-- Theme
	{
		"fynnfluegge/monet.nvim",
		name = "monet",
		lazy = false,
		priority = 1000,
		-- stylua: ignore
		config = function() vim.cmd([[colorscheme monet]]) end,
	},

	-- UI/UX
	{
		"bluz71/nvim-linefly",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		-- Do not lazy load, just leave it to plugin
	},
	{
		"b0o/incline.nvim",
		opts = { hide = { only_win = true, focused_win = true } },
		event = LazyFile,
	},
	{
		"petertriho/nvim-scrollbar",
		opts = {
			show_in_active_only = true,
			hide_if_all_visible = true,
			excluded_filetypes = { "lazy", "mason" },
			handlers = { handle = false },
		},
		event = LazyFile,
	},
	{
		"folke/noice.nvim",
		version = "4.4.7", -- Until cursor blinking bug is fixed
		dependencies = { "MunifTanjim/nui.nvim" },
		opts = {
			lsp = {
				hover = { enabled = false }, -- Use default LSP
				signature = { enabled = false }, -- Use `mini.completion`
			},
		},
		event = "VeryLazy",
	},
	{
		"echasnovski/mini.animate",
		config = function()
			local animate = require("mini.animate")
			animate.setup({
				scroll = { enable = false },
				open = { enable = false },
				close = { enable = false },
				resize = { timing = animate.gen_timing.linear({ duration = 16, unit = "total" }) },
				cursor = {
					timing = animate.gen_timing.exponential({ easing = "out", duration = 80, unit = "total" }),
					-- stylua: ignore
					path = animate.gen_path.line({ predicate = function() return true end }),
				},
			})
		end,
		event = LazyFile,
	},
	{
		"shellRaining/hlchunk.nvim",
		opts = {
			chunk = { enable = true },
			indent = { enable = true },
		},
		event = LazyFile,
	},
	{
		"NvChad/nvim-colorizer.lua",
		opts = {
			filetypes = { "*", "!lazy", "!mason", "!markdown" },
			user_default_options = { css = true, mode = "virtualtext" },
		},
		event = LazyFile,
	},
	{
		"ibhagwan/smartyank.nvim",
		opts = { highlight = { timeout = 80 } },
		event = LazyFile,
	},
	{ "echasnovski/mini.diff", config = true, event = LazyFile },
	{ "nvim-focus/focus.nvim", config = true, event = LazyFile },
	{ "RRethy/vim-illuminate", event = LazyFile },
	{ "mvllow/modes.nvim", config = true, event = LazyFile },
	{ "monkoose/matchparen.nvim", config = true, event = LazyFile },
	{ "Darazaki/indent-o-matic", config = true, event = LazyFile },
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			window = {
				mappings = {
					["<Space>"] = { "toggle_node", nowait = true },
					["<C-s>"] = "open_split",
					["<C-v>"] = "open_vsplit",
				},
			},
			filesystem = {
				filtered_items = { visible = true },
				hijack_netrw_behavior = "open_current",
			},
		},
		-- To open directory like `netrw`, this plugin cannot be lazy loaded
	},

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		version = false,
		main = "nvim-treesitter.configs",
		opts = {
			ensure_installed = "all",
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			indent = { enable = true },
			-- Enable `nvim-treesitter-pairs`
			pairs = {
				enable = true,
				fallback_cmd_normal = "normal! %",
				keymaps = { goto_partner = "%" },
			},
		},
		build = ":TSUpdate",
		event = LazyFile,
	},
	{ "JoosepAlviste/nvim-ts-context-commentstring", opts = { enable_autocmd = false }, event = LazyFile },
	{ "nvim-treesitter/nvim-treesitter-context", opts = { max_lines = 1 }, event = LazyFile },
	{ "windwp/nvim-ts-autotag", config = true, event = LazyFile },
	{ "theHamsta/nvim-treesitter-pairs", event = LazyFile },

	-- Editors
	{
		"terrortylor/nvim-comment",
		main = "nvim_comment",
		opts = {
			create_mappings = false,
			comment_empty = false,
			--stylua: ignore
			hook = function() require("ts_context_commentstring").update_commentstring() end,
		},
		keys = {
			{ "<C-_>", ":CommentToggle<CR>", silent = true },
			{ "<C-_>", ":'<,'>CommentToggle<CR>", mode = "v", silent = true },
		},
	},
	{
		"Wansmer/treesj",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = { use_default_keymaps = false },
		keys = { { "sj", ":TSJToggle<CR>", silent = true } },
	},
	{ "windwp/nvim-autopairs", config = true, event = "InsertEnter" },
	{ "echasnovski/mini.surround", config = true, event = LazyFile },

	-- LSP
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			require("mason-lspconfig").setup_handlers({
				function(server_name)
					local options = {
						on_attach = function(_, bufnr)
							local keymap_opts = { buffer = bufnr, silent = true }
							vim.keymap.set("n", "R", vim.lsp.buf.rename, keymap_opts)
							vim.keymap.set("n", "gs", ":sp | lua vim.lsp.buf.definition()<CR>", keymap_opts)
							vim.keymap.set("n", "gv", ":vs | lua vim.lsp.buf.definition()<CR>", keymap_opts)

							-- Show diagnostics w/ border only on CursorHold
							vim.diagnostic.config({
								virtual_text = false,
								severity_sort = true,
								float = { focusable = false, border = "single" },
							})
							-- stylua: ignore
							vim.api.nvim_create_autocmd("CursorHold", { callback = function() vim.diagnostic.open_float({ bufnr }) end })
							-- Apply border to hover
							vim.lsp.handlers["textDocument/hover"] =
								vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
						end,
						settings = {
							-- Suppress "Undefined global `vim`" warning
							Lua = { diagnostics = { globals = { "vim" } } },
							["rust-analyzer"] = { check = { command = "clippy" } },
						},
					}

					require("lspconfig")[server_name].setup(options)
				end,
			})
		end,
		event = LazyFile,
	},
	{
		"dnlhc/glance.nvim",
		config = function()
			local glance = require("glance")
			glance.setup({
				height = 30,
				list = { position = "left" },
				folds = { folded = false },
				mappings = {
					list = {
						["<C-s>"] = glance.actions.jump_split,
						["<C-v>"] = glance.actions.jump_vsplit,
						["<C-w><Right>"] = glance.actions.enter_win("preview"),
					},
					preview = {
						["<C-w><Left>"] = glance.actions.enter_win("list"),
					},
				},
			})
		end,
		keys = {
			{ "gd", ":Glance definitions<CR>", silent = true },
			{ "gr", ":Glance references<CR>", silent = true },
		},
	},

	-- Formatter
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				rust = { "rustfmt" },
				["_"] = { "prettier" },
			},
		},
		keys = { { "<Space>f", ":lua require('conform').format()<CR>", silent = true } },
	},

	-- Completion
	{
		"zbirenbaum/copilot.lua",
		opts = {
			suggestion = {
				auto_trigger = true,
				keymap = {
					accept = "<c-CR>",
					next = "<c-]>",
					prev = "<c-[>",
					dismiss = "<ESC>",
				},
			},
			panel = { enabled = false },
		},
		init = function()
			-- stylua: ignore
			vim.api.nvim_create_autocmd("CompleteChanged", { callback = function() vim.b.copilot_suggestion_hidden = true end })
			-- stylua: ignore
			vim.api.nvim_create_autocmd("CompleteDone", { callback = function() vim.b.copilot_suggestion_hidden = false end })
		end,
		event = "InsertEnter",
	},
	{
		"echasnovski/mini.completion",
		opts = {
			-- Disable due to layout conflict with `noice.nvim`'s popupmenu
			delay = { info = 10 ^ 7 },
			window = { signature = { border = "single" } },
			lsp_completion = { source_func = "omnifunc" },
		},
		init = function()
			-- stylua: ignore
			vim.keymap.set("i", "<Tab>", [[pumvisible() ? "\<Down>" : "\<Tab>"]], { expr = true, replace_keycodes = false })
			-- stylua: ignore
			vim.keymap.set("i", "<S-Tab>", [[pumvisible() ? "\<Up>" : "\<S-Tab>"]], { expr = true, replace_keycodes = false })
		end,
		-- Do not lazy load, just leave it to plugin
	},
}, {
	checker = { enabled = true, frequency = 60 * 60 * 12 },
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"shada",
				"tutor",
				"tohtml",
				"man",
				"osc52",
				"rplugin",
				"spellfile",
				"tarPlugin",
				"zipPlugin",
				"netrwPlugin",
				-- "matchit", -- Make `%` works for HTML, etc
				"matchparen",
			},
		},
	},
})
