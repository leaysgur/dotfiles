-- Basics
vim.opt.termguicolors = true
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
vim.opt.clipboard = "unnamedplus"

-- Independent keymaps
local keymap_opts = { silent = true, noremap = true }
-- Keep visual mode after indentation
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
-- Clear search highlight
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR><Esc>", keymap_opts)

-- Event for buffer loaded
-- See https://github.com/LazyVim/LazyVim/discussions/1583
local LazyFile = { "BufReadPost", "BufNewFile", "BufWritePre" }

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- Theme
	{
		"rebelot/kanagawa.nvim",
		priority = 1000,
		opts = {
			transparent = true,
			dimInactive = true,
		},
		init = function()
			vim.cmd("colorscheme kanagawa")
		end,
	},

	-- Common dependencies
	{ "nvim-tree/nvim-web-devicons", lazy = true },
	{ "nvim-lua/plenary.nvim", lazy = true },

	-- Uis
	"bluz71/nvim-linefly",
	{
		"petertriho/nvim-scrollbar",
		opts = { excluded_filetypes = { "NvimTree", "Lazy", "Glance" } },
		event = LazyFile,
	},
	{ "nvim-focus/focus.nvim", config = true, event = LazyFile },
	{
		"lewis6991/gitsigns.nvim",
		opts = { signcolumn = false, numhl = true },
		event = LazyFile,
	},
	{ "mvllow/modes.nvim", opts = { line_opacity = 0.3 }, event = LazyFile },
	{
		"shellRaining/hlchunk.nvim",
		opts = {
			line_num = { enable = false },
			blank = { enable = false },
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
	{ "RRethy/vim-illuminate", event = LazyFile },
	{
		"echasnovski/mini.animate",
		config = function()
			local animate = require("mini.animate")
			animate.setup({
				scroll = { enable = false },
				resize = { enable = false },
				open = { enable = false },
				close = { enable = false },
				cursor = {
					timing = animate.gen_timing.exponential({ easing = "out", duration = 160, unit = "total" }),
					-- stylua: ignore
					path = animate.gen_path.line({ predicate = function() return true end }),
				},
			})
		end,
		event = LazyFile,
	},

	-- File browser(cannot lazy load to open directory like netrw)
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = { "MunifTanjim/nui.nvim" },
		opts = {
			close_if_last_window = true,
			window = {
				position = "right",
				width = 50,
				mappings = {
					["<space>"] = { "toggle_node", nowait = true },
					["<C-s>"] = "open_split",
					["<C-v>"] = "open_vsplit",
				},
			},
			filesystem = {
				filtered_items = { visible = true },
				follow_current_file = { enabled = true, leave_dirs_open = true },
				hijack_netrw_behavior = "open_current",
			},
		},
		init = function()
			vim.keymap.set("n", "\\", ":Neotree toggle reveal_force_cwd<CR>", keymap_opts)
		end,
	},

	-- Editors
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			{ "JoosepAlviste/nvim-ts-context-commentstring", opts = { enable_autocmd = false } },
			"windwp/nvim-ts-autotag",
		},
		build = ":TSUpdate",
		-- Setup manually for perf, see bottom of this file
		lazy = true,
	},
	{
		"terrortylor/nvim-comment",
		main = "nvim_comment",
		opts = {
			create_mappings = false,
			comment_empty = false,
			--stylua: ignore
			hook = function() require("ts_context_commentstring.internal").update_commentstring() end,
		},
		init = function()
			vim.keymap.set("n", "<C-_>", ":CommentToggle<CR>", keymap_opts)
			vim.keymap.set("v", "<C-_>", ":'<,'>CommentToggle<CR>", keymap_opts)
		end,
		cmd = "CommentToggle",
	},
	{ "andymass/vim-matchup", config = true, event = LazyFile },
	{ "Darazaki/indent-o-matic", config = true, event = LazyFile },
	{ "echasnovski/mini.surround", config = true, event = LazyFile },
	{
		"Wansmer/treesj",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = { use_default_keymaps = false },
		--stylua: ignore
		init = function() vim.keymap.set("n", "sj", ":TSJToggle<CR>", keymap_opts) end,
		cmd = "TSJToggle",
	},
	{ "windwp/nvim-autopairs", config = true, event = "InsertEnter" },

	-- LSP
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			require("mason-lspconfig").setup_handlers({
				function(server)
					local options = {
						capabilities = require("cmp_nvim_lsp").default_capabilities(
							vim.lsp.protocol.make_client_capabilities()
						),
						on_attach = function(client, bufnr)
							local buf_opts = vim.list_extend({ buffer = bufnr }, keymap_opts)

							-- Use `conform.nvim` for formatting
							-- vim.keymap.set("n", "<Space>f", function() vim.lsp.buf.format({ async = true }) end, buf_opts)
							vim.keymap.set("n", "K", vim.lsp.buf.hover, buf_opts)
							vim.keymap.set("n", "R", vim.lsp.buf.rename, buf_opts)
							vim.keymap.set("n", "gs", ":sp | lua vim.lsp.buf.definition()<CR>", buf_opts)
							vim.keymap.set("n", "gv", ":vs | lua vim.lsp.buf.definition()<CR>", buf_opts)
							-- Use `glance.nvim` for LSP references
							-- vim.keymap.set("n", "gr", vim.lsp.buf.references, buf_opts)

							-- Show diagnostics only on CursorHold
							vim.diagnostic.config({
								virtual_text = false,
								severity_sort = true,
								float = { focusable = false },
							})
							vim.api.nvim_create_autocmd("CursorHold", {
								buffer = bufnr,
								-- stylua: ignore
								callback = function() vim.diagnostic.open_float({ bufnr }) end,
							})

							if client.supports_method("textDocument/inlayHint") then
								vim.keymap.set("n", "H", function()
									local value = not vim.lsp.inlay_hint.is_enabled(bufnr)
									vim.lsp.inlay_hint.enable(bufnr, value)
								end, buf_opts)
							end
						end,
					}

					if server == "lua_ls" then
						-- Suppress "Undefined global `vim`" warning
						options.settings = { Lua = { diagnostics = { globals = { "vim" } } } }
					end
					if server == "rust_analyzer" then
						options.settings = { ["rust-analyzer"] = { check = { command = "clippy" } } }
					end

					require("lspconfig")[server].setup(options)
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
		init = function()
			vim.keymap.set("n", "gr", ":Glance references<CR>", keymap_opts)
			vim.keymap.set("n", "gd", ":Glance definitions<CR>", keymap_opts)
		end,
		cmd = "Glance",
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
		init = function()
			-- stylua: ignore
			vim.keymap.set("n", "<Space>f", function() require("conform").format() end, keymap_opts)
		end,
		lazy = true,
	},

	-- Completion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lsp",
			{
				"zbirenbaum/copilot-cmp",
				dependencies = {
					{
						"zbirenbaum/copilot.lua",
						opts = {
							suggestion = { enabled = false },
							panel = { enabled = false },
						},
					},
				},
				config = true,
			},
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"onsails/lspkind.nvim",
			"hrsh7th/vim-vsnip", -- Only for expanding snippet from LSP safely
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				-- stylua: ignore
				snippet = { expand = function(args) vim.fn["vsnip#anonymous"](args.body) end, },
				sources = {
					{ name = "copilot" },
					{ name = "nvim_lsp_signature_help" },
					{ name = "nvim_lsp" },
					{ name = "path" },
					{ name = "buffer" },
				},
				mapping = cmp.mapping.preset.insert({
					-- stylua: ignore
					["<Tab>"] = function(fallback) if cmp.visible() then cmp.select_next_item() else fallback() end end,
					-- stylua: ignore
					["<S-Tab>"] = function(fallback) if cmp.visible() then cmp.select_prev_item() else fallback() end end,
					-- stylua: ignore
					["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
				}),
				formatting = {
					format = require("lspkind").cmp_format({
						mode = "symbol_text",
						symbol_map = { Copilot = "" },
					}),
				},
			})
		end,
		event = "InsertEnter",
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
				"matchit",
				"man",
				"osc52",
				"rplugin",
				"spellfile",
				"tarPlugin",
				"zipPlugin",
				"matchparen",
				"netrwPlugin",
			},
		},
	},
})

-- Defer Treesitter setup after first render to improve startup time of `nvim {filename}`
-- See https://github.com/nvim-lua/kickstart.nvim/blob/2510c29d62d39d63bb75f1a613d2ae628a2af4ee/init.lua#L422
vim.defer_fn(function()
	require("nvim-treesitter.configs").setup({
		ensure_installed = "all",
		highlight = { enable = true },
		indent = { enable = true },
		autotag = { enable = true },
		-- Enhance `vim-matchup`
		matchup = { enable = true },
	})
end, 0)
