-- Basics
vim.opt.termguicolors = true
-- Ui
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.list = true
vim.opt.listchars = { tab = "__" }
vim.opt.completeopt = { "menuone", "noselect" }
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

local keymap_opts = { silent = true, noremap = true }
-- Keep visual mode after indentation
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
-- Clear search highlight
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR><Esc>", keymap_opts)

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- Theme
	{
		"JoosepAlviste/palenightfall.nvim",
		priority = 1000,
		opts = {
			transparent = true,
			highlight_overrides = { VertSplit = { fg = "#a6accd" } },
		},
	},

	-- Common dependencies
	{ "nvim-tree/nvim-web-devicons", lazy = true },
	{ "nvim-lua/plenary.nvim", lazy = true },

	-- Uis
	"bluz71/nvim-linefly",
	{
		"nvim-focus/focus.nvim",
		opts = { ui = { number = true } },
		event = { "BufReadPost", "BufNewFile" },
	},
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signcolumn = false,
			numhl = true,
		},
		event = { "BufReadPost", "BufNewFile" },
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			scope = {
				show_start = false,
				highlight = "Special",
			},
		},
		event = { "BufReadPost", "BufNewFile" },
	},
	{
		"NvChad/nvim-colorizer.lua",
		opts = {
			filetypes = { "*", "!lazy", "!markdown" },
			user_default_options = { css = true, mode = "virtualtext" },
		},
		event = { "BufReadPost", "BufNewFile" },
	},
	{ "RRethy/vim-illuminate", event = { "BufReadPost", "BufNewFile" } },

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
			hook = function()
				require("ts_context_commentstring.internal").update_commentstring()
			end,
		},
		init = function()
			vim.keymap.set("n", "<C-_>", ":CommentToggle<CR>", keymap_opts)
			vim.keymap.set("v", "<C-_>", ":'<,'>CommentToggle<CR>", keymap_opts)
		end,
		cmd = "CommentToggle",
	},
	{ "andymass/vim-matchup", config = true, event = { "BufReadPre", "BufNewFile" } },
	{ "Darazaki/indent-o-matic", config = true, event = { "BufReadPost", "BufNewFile" } },
	{
		"echasnovski/mini.surround",
		main = "mini.surround",
		config = true,
		event = { "BufReadPost", "BufNewFile" },
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
						on_attach = function(_, bufnr)
							local buf_opts = vim.list_extend({ buffer = bufnr }, keymap_opts)

							-- Use `conform.nvim` for formatting
							-- vim.keymap.set("n", "<Space>f", function() vim.lsp.buf.format({ async = true }) end, buf_opts)
							vim.keymap.set("n", "K", vim.lsp.buf.hover, buf_opts)
							vim.keymap.set("n", "rn", vim.lsp.buf.rename, buf_opts)
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
								callback = vim.diagnostic.open_float,
							})
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
		event = { "BufReadPre", "BufNewFile" },
	},
	{ "j-hui/fidget.nvim", config = true, event = "LspAttach" },
	{
		"dnlhc/glance.nvim",
		config = function()
			local glance = require("glance")
			glance.setup({
				list = { position = "left" },
				folds = { folded = false },
				mappings = {
					list = {
						["<C-s>"] = glance.actions.jump_split,
						["<C-v>"] = glance.actions.jump_vsplit,
					},
				},
			})
		end,
		init = function()
			vim.keymap.set("n", "gr", ":Glance references<CR>", keymap_opts)
			vim.keymap.set("n", "grr", ":Glance definitions<CR>", keymap_opts)
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
			"hrsh7th/cmp-emoji",
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
			-- Only for expanding snippet from LSP safely
			"hrsh7th/vim-vsnip",
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					-- stylua: ignore
					expand = function(args) vim.fn["vsnip#anonymous"](args.body) end,
				},
				sources = {
					{ name = "copilot" },
					{ name = "nvim_lsp_signature_help" },
					{ name = "nvim_lsp" },
					{ name = "path" },
					{ name = "emoji" },
					{ name = "buffer" },
				},
				mapping = cmp.mapping.preset.insert({
					["<Tab>"] = function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end,
					["<S-Tab>"] = function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end,
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					}),
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
-- See https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua#L377
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
