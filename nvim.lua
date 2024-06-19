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
		"fynnfluegge/monet.nvim",
		name = "monet",
		priority = 1000,
		-- stylua: ignore
		config = function() vim.cmd("colorscheme monet") end,
	},

	-- Uis
	{
		"bluz71/nvim-linefly",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		"b0o/incline.nvim",
		opts = { hide = { only_win = true, focused_win = true } },
		event = LazyFile,
	},
	{
		"petertriho/nvim-scrollbar",
		opts = { excluded_filetypes = { "NvimTree", "Lazy", "Glance" } },
		event = LazyFile,
	},
	{ "echasnovski/mini.diff", config = true, event = LazyFile },
	{ "nvim-focus/focus.nvim", config = true, event = LazyFile },
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
		},
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
		config = function()
			vim.keymap.set("n", "\\", ":Neotree toggle reveal_force_cwd<CR>", keymap_opts)
		end,
		-- To open directory like `netrw` does, this cannot be lazy loaded
	},

	-- UX
	{
		"ibhagwan/smartyank.nvim",
		opts = { highlight = { timeout = 80 } },
		event = LazyFile,
	},
	{ "Darazaki/indent-o-matic", config = true, event = LazyFile },
	{ "RRethy/vim-illuminate", event = LazyFile },
	{ "andymass/vim-matchup", config = true, event = LazyFile },
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
		"mvllow/modes.nvim",
		opts = { line_opacity = 0.4 },
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
			-- Enhance `vim-matchup`
			matchup = { enable = true },
		},
		build = ":TSUpdate",
		event = LazyFile,
	},
	{ "JoosepAlviste/nvim-ts-context-commentstring", opts = { enable_autocmd = false }, event = LazyFile },
	{ "nvim-treesitter/nvim-treesitter-context", opts = { max_lines = 1 }, event = LazyFile },
	{ "windwp/nvim-ts-autotag", config = true, event = LazyFile },

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
			{ "<C-_>", "<cmd>CommentToggle<cr>" },
			{ "<C-_>", "<cmd>'<,'>CommentToggle<cr>", mode = "v" },
		},
	},
	{ "echasnovski/mini.surround", config = true, event = LazyFile },
	{
		"Wansmer/treesj",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = { use_default_keymaps = false },
		keys = { { "sj", "<cmd>TSJToggle<cr>" } },
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

							vim.keymap.set("n", "R", vim.lsp.buf.rename, buf_opts)
							vim.keymap.set("n", "K", vim.lsp.buf.hover, buf_opts)
							vim.keymap.set("n", "gs", ":sp | lua vim.lsp.buf.definition()<CR>", buf_opts)
							vim.keymap.set("n", "gv", ":vs | lua vim.lsp.buf.definition()<CR>", buf_opts)
							vim.keymap.set("n", "gd", vim.lsp.buf.definition, buf_opts)
							-- Use `glance.nvim` for LSP references
							-- vim.keymap.set("n", "gr", vim.lsp.buf.references, buf_opts)
							-- Use `conform.nvim` for formatting
							-- vim.keymap.set("n", "<Space>f", function() vim.lsp.buf.format({ async = true }) end, buf_opts)

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
		keys = { { "gr", "<cmd>Glance references<cr>" } },
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
		keys = { { "<Space>f", "<cmd>lua require('conform').format()<cr>" } },
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
