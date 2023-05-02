-- Basics
vim.opt.termguicolors = true
vim.opt.pumblend = 5
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.list = true
vim.opt.listchars = { tab = "__" }
-- Prefer soft tab
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- Prefer global status line
vim.opt.laststatus = 3
vim.opt.swapfile = false
vim.opt.autochdir = true

local map_opts = { silent = true, noremap = true }
-- Keep visual mode after indentation
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
-- Clear search highlight
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR><Esc>", map_opts)

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
		"folke/tokyonight.nvim",
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				transparent = true,
				on_colors = function(colors)
					colors.border = colors.border_highlight
				end,
			})
			vim.cmd([[colorscheme tokyonight-night]])
		end,
	},

	-- Common dependencies
	{ "nvim-tree/nvim-web-devicons", lazy = true },
	{ "nvim-lua/plenary.nvim",       lazy = true },

	-- Uis
	{
		"echasnovski/mini.statusline",
		main = "mini.statusline",
		opts = { set_vim_settings = false },
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
		opts = {
			disable_with_nolist = true,
			show_current_context = true,
		},
		event = { "BufReadPost", "BufNewFile" },
	},
	{
		"NvChad/nvim-colorizer.lua",
		opts = {
			filetypes = { "*", "!lazy" },
			user_default_options = { css = true, mode = "virtualtext" },
		},
		event = { "BufReadPost", "BufNewFile" },
	},
	{ "RRethy/vim-illuminate",     event = { "BufReadPost", "BufNewFile" } },

	-- File browser
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		dependencies = {
			"MunifTanjim/nui.nvim",
			-- Required to make `*_with_window_picker` work on mappings
			{ "s1n7ax/nvim-window-picker", config = true },
		},
		opts = {
			window = {
				position = "float",
				mappings = {
					["<C-s>"] = "split_with_window_picker",
					["<C-v>"] = "vsplit_with_window_picker",
				},
			},
			filesystem = {
				filtered_items = { visible = true },
				hijack_netrw_behavior = "open_current",
				bind_to_cwd = false,
				follow_current_file = true,
			},
		},
		init = function()
			vim.g.neo_tree_remove_legacy_commands = 1
			vim.keymap.set("n", "\\", ":Neotree toggle reveal_force_cwd<CR>", map_opts)
		end,
	},

	-- Editors
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
			"windwp/nvim-ts-autotag",
			"yioneko/nvim-yati",
		},
		build = ":TSUpdate",
		main = "nvim-treesitter.configs",
		opts = {
			ensure_installed = "all",
			highlight = { enable = true },
			-- Native indent does not work well with JSDoc multiline comments.
			-- While waiting https://github.com/nvim-treesitter/nvim-treesitter/pull/2545 to be merged,
			-- use `yati`(also not perfect) instead...
			indent = { enable = false },
			yati = { enable = true },
			autotag = { enable = true },
			-- Enhance `nvim-comment`
			context_commentstring = { enable = true, enable_autocmd = false },
			-- Enhance `vim-matchup`
			matchup = { enable = true },
		},
		event = { "BufReadPost", "BufNewFile" },
	},
	{
		"terrortylor/nvim-comment",
		-- XXX: `opts = { ... }` will fail to call `require()`
		config = function()
			require("nvim_comment").setup({
				create_mappings = false,
				hook = require("ts_context_commentstring.internal").update_commentstring,
			})
		end,
		init = function()
			vim.keymap.set("n", "<C-_>", ":CommentToggle<CR>", map_opts)
			vim.keymap.set("v", "<C-_>", ":'<,'>CommentToggle<CR>", map_opts)
		end,
		cmd = "CommentToggle",
	},
	-- XXX: `config = true` is enough but it throws :(
	{ "andymass/vim-matchup",      opts = {},                              event = { "BufReadPost", "BufNewFile" } },
	{ "NMAC427/guess-indent.nvim", config = true,                          event = { "BufReadPost", "BufNewFile" } },
	{
		"echasnovski/mini.surround",
		main = "mini.surround",
		config = true,
		event = { "BufReadPost", "BufNewFile" },
	},
	{
		"echasnovski/mini.pairs",
		main = "mini.pairs",
		config = true,
		event = "InsertEnter",
	},

	-- LSP
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",
			{
				"j-hui/fidget.nvim",
				opts = { text = { spinner = "arc" } },
			},
			{
				"jose-elias-alvarez/null-ls.nvim",
				config = function()
					local null_ls = require("null-ls")
					null_ls.setup({
						debounce = 1000,
						sources = {
							null_ls.builtins.diagnostics.eslint.with({ only_local = "node_modules/.bin" }),
							null_ls.builtins.formatting.stylua,
							null_ls.builtins.formatting.prettier.with({ extra_filetypes = { "svelte", "astro" } }),
						},
					})
				end,
			},
		},
		config = function()
			require("mason-lspconfig").setup_handlers({
				function(server)
					local options = {
						capabilities = require("cmp_nvim_lsp").default_capabilities(
							vim.lsp.protocol.make_client_capabilities()
						),
						on_attach = function(_, bufnr)
							local buf_opts = vim.list_extend({ buffer = bufnr }, map_opts)

							vim.keymap.set("n", "<Space>f", function()
								vim.lsp.buf.format({ async = true })
							end, buf_opts)
							vim.keymap.set("n", "K", vim.lsp.buf.hover, buf_opts)
							vim.keymap.set("n", "rn", vim.lsp.buf.rename, buf_opts)
							vim.keymap.set("n", "gs", ":sp | lua vim.lsp.buf.definition()<CR>", buf_opts)
							vim.keymap.set("n", "gv", ":vs | lua vim.lsp.buf.definition()<CR>", buf_opts)
							-- Use `glance` for LSP references
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
							-- Quicken CursorHold
							vim.api.nvim_set_option("updatetime", 500)
						end,
					}

					-- Suppress "Undefined global `vim`" warning
					if server == "lua_ls" then
						options = vim.tbl_deep_extend(
							"force",
							options,
							{ settings = { Lua = { diagnostics = { globals = { "vim" } } } } }
						)
					end

					require("lspconfig")[server].setup(options)
				end,
			})
		end,
		event = { "BufReadPre", "BufNewFile" },
	},
	{
		"dnlhc/glance.nvim",
		config = function()
			local glance = require("glance")
			glance.setup({
				border = { enable = true },
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
			vim.keymap.set("n", "gr", ":Glance references<CR>", map_opts)
		end,
		cmd = "Glance",
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
				completion = { completeopt = "menu,menuone,noinsert" },
				snippet = {
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body)
					end,
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
				experimental = { ghost_text = true },
			})
		end,
		event = "InsertEnter",
	},
}, {
	checker = { enabled = true },
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
