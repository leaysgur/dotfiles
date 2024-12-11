-- # Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- # Global options
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
-- Ui
vim.opt.number = true
vim.opt.list = true
vim.opt.listchars = { tab = "__" }
vim.opt.completeopt = { "menu", "menuone", "noselect" }
-- Use global status line
vim.opt.laststatus = 3
-- Use status line as cmd line
vim.opt.cmdheight = 0
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
vim.opt.updatetime = 250
vim.opt.timeoutlen = 500

-- # Keymaps
-- Keep visual mode after indentation
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
-- Clear search highlight
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR><Esc>", { silent = true })

-- # Setup plugins
-- Event for buffer loaded
-- See https://github.com/LazyVim/LazyVim/discussions/1583
local LazyFile = { "BufReadPost", "BufNewFile", "BufWritePre" }

require("lazy").setup({
	-- ## Theme
	{
		"fynnfluegge/monet.nvim",
		priority = 1000,
		opts = { transparent_background = true },
		--stylua: ignore
		init = function() vim.cmd([[colorscheme monet]]) end,
	},
	{
		"echasnovski/mini.icons",
		config = true,
		--stylua: ignore
		init = function() require("mini.icons").mock_nvim_web_devicons() end,
	},

	-- ## UI/UX
	{
		"bluz71/nvim-linefly",
		init = function()
			vim.g.linefly_options = {
				with_lsp_status = true,
				with_search_count = true,
			}
		end,
		-- Do not lazy load, just leave it to plugin
	},
	{
		"b0o/incline.nvim",
		opts = { hide = { cursorline = true } },
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
		"Saghen/blink.indent",
		main = "blink.indent",
		opts = {
			static = { char = "│" },
			scope = { char = "│", highlights = { "BlinkIndentBlue" } },
		},
		-- Do not lazy load, just leave it to plugin
	},
	{
		"NvChad/nvim-colorizer.lua",
		opts = {
			filetypes = { "*", "!lazy", "!mason", "!markdown" },
			user_default_options = {
				css = true,
				mode = "virtualtext",
				virtualtext_inline = true,
				user_commands = false,
			},
		},
		event = LazyFile,
	},
	{
		"ibhagwan/smartyank.nvim",
		opts = { highlight = { timeout = 80 } },
		event = LazyFile,
	},
	{
		"sphamba/smear-cursor.nvim",
		opts = { color_levels = 8, gamma = 4 },
		event = LazyFile,
	},
	{ "echasnovski/mini.diff", config = true, event = LazyFile },
	{ "RRethy/vim-illuminate", event = LazyFile },
	{ "nvim-focus/focus.nvim", config = true, event = LazyFile },
	{ "mvllow/modes.nvim", config = true, event = LazyFile },
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
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

	-- ## Treesitter
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

	-- ## Editing
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
		opts = { use_default_keymaps = false },
		keys = { { "sj", ":TSJToggle<CR>", silent = true } },
	},
	{ "windwp/nvim-autopairs", config = true, event = "InsertEnter" },
	{ "echasnovski/mini.surround", config = true, event = LazyFile },
	{ "monkoose/matchparen.nvim", config = true, event = LazyFile },
	{ "Darazaki/indent-o-matic", config = true, event = LazyFile },

	-- ## LSP
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",
			"saghen/blink.cmp",
		},
		config = function()
			local on_attach = function(_, bufnr)
				local keymap_opts = { buffer = bufnr, silent = true }
				vim.keymap.set("n", "R", vim.lsp.buf.rename, keymap_opts)
				vim.keymap.set("n", "gs", ":sp | lua vim.lsp.buf.definition()<CR>", keymap_opts)
				vim.keymap.set("n", "gv", ":vs | lua vim.lsp.buf.definition()<CR>", keymap_opts)
				vim.keymap.set("n", "m", vim.diagnostic.goto_next, keymap_opts)
				vim.keymap.set("n", "M", vim.diagnostic.goto_prev, keymap_opts)
				-- Use `tiny-inline-diagnostic` instead
				vim.diagnostic.config({ virtual_text = false, sevirity_sort = true })
			end
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			require("mason-lspconfig").setup_handlers({
				function(server_name)
					require("lspconfig")[server_name].setup({ on_attach = on_attach, capabilities = capabilities })
				end,
				lua_ls = function()
					require("lspconfig").lua_ls.setup({
						on_attach = on_attach,
						capabilities = capabilities,
						settings = {
							-- Suppress "Undefined global `vim`" warning
							Lua = { diagnostics = { globals = { "vim" } } },
						},
					})
				end,
				rust_analyzer = function()
					require("lspconfig").rust_analyzer.setup({
						on_attach = on_attach,
						capabilities = capabilities,
						settings = {
							-- Temporarily disable, it's too slow in large repo
							-- ["rust-analyzer"] = { check = { command = "clippy" } },
						},
					})
				end,
			})
		end,
		event = LazyFile,
	},
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		opts = {
			preset = "nonerdfont",
			signs = { arrow = "", up_arrow = "" }, -- Arrows are useless because column pos is not supported
			options = { show_source = true },
		},
		event = "VeryLazy",
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

	-- ## Formatter
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

	-- ## Completion
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
		event = "InsertEnter",
	},
	{
		"saghen/blink.cmp",
		build = "cargo build --release",
		opts = {
			keymap = {
				["<CR>"] = { "accept", "fallback" },
				["<Tab>"] = { "select_next", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
				["<S-Tab>"] = { "select_prev", "fallback" },
				["<Up>"] = { "select_prev", "fallback" },
			},
			signature = { enabled = true },
			completion = { list = { selection = "manual" } },
		},
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
