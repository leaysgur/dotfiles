-- Basics
vim.opt.termguicolors = true
vim.opt.pumblend = 10
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
vim.opt.completeopt = "menuone,noselect"
vim.opt.autochdir = true


local map_opts = { silent = true, noremap = true }
-- Keep visual mode after indentation
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
-- Clear search highlight
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR><Esc>", map_opts)


-- Plugins by `lazy.nvim`
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
				style = "night",
				on_colors = function(colors)
					colors.border = colors.border_highlight
				end,
			})
			vim.cmd([[colorscheme tokyonight]])
		end,
	},

	-- Uis
	"nvim-tree/nvim-web-devicons",
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signcolumn = false,
			numhl = true,
		},
		event = "BufReadPre",
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		opts = {
			disable_with_nolist = true,
			show_current_context = true,
		},
		event = "BufReadPre",
	},
	{
		"echasnovski/mini.statusline",
		config = function()
			require("mini.statusline").setup({
				set_vim_settings = false,
			})
		end,
		event = "BufReadPost",
	},
	{
		"NvChad/nvim-colorizer.lua",
		opts = { user_default_options = { css = true, css_fn = true, mode = "virtualtext" } },
		event = "BufReadPost",
	},
	{ "RRethy/vim-illuminate", event = "BufReadPost" },

	-- Utils
	{ "NMAC427/guess-indent.nvim", config = true, event = "BufReadPost" },
	{ "yutkat/history-ignore.nvim", config = true, event = "BufReadPost" },
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
			"windwp/nvim-ts-autotag",
			"yioneko/nvim-yati",
		},
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = "all",
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				-- Native TS indent does not work well with JSDoc multiline comments.
				-- While waiting for https://github.com/nvim-treesitter/nvim-treesitter/pull/2545 to be merged,
				-- use `yati`(also not perfect) instead...
				indent = { enable = false },
				yati = { enable = true },
				autotag = { enable = true },
				-- Enhance `nvim-comment`
				context_commentstring = { enable = true, enable_autocmd = false },
				-- Enhance `vim-matchup`
				matchup = { enable = true },
			})
		end,
		event = "BufReadPost",
	},

	-- File browser
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			-- Required to make `*_with_window_picker` work on mappings
			{ "s1n7ax/nvim-window-picker", config = true },
		},
		init = function()
			vim.g.neo_tree_remove_legacy_commands = 1
			vim.keymap.set("n", "\\", ":Neotree toggle reveal_force_cwd<CR>", map_opts)
		end,
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
	},

	-- Editors
	{ "machakann/vim-sandwich", event = "BufReadPost" },
	{ "windwp/nvim-autopairs", config = true, event = "BufReadPost" },
	-- XXX: `config = true` is enough but it throws error!
	{ "andymass/vim-matchup", opts = {}, event = "BufReadPost" },
	{
		"terrortylor/nvim-comment",
		-- XXX: `opts = { ... }` does not work because plugin name is not consistent
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

	-- LSP
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",
			{ "j-hui/fidget.nvim", config = true },
			{
				"jose-elias-alvarez/null-ls.nvim",
				dependencies = { "nvim-lua/plenary.nvim" },
				config = function()
					local null_ls = require("null-ls")
					null_ls.setup({
						debounce = 1000,
						sources = {
							null_ls.builtins.diagnostics.eslint.with({ only_local = "node_modules/.bin" }),
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

							vim.diagnostic.config({
								-- Show diagnostics only on CursorHold
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
			local actions = glance.actions
			glance.setup({
				border = { enable = true },
				list = { position = "left" },
				folds = { folded = false },
				mappings = {
					list = {
						["<C-s>"] = actions.jump_split,
						["<C-v>"] = actions.jump_vsplit,
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
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"onsails/lspkind.nvim",
			-- Only for expanding snippet from LSP safely
			"hrsh7th/vim-vsnip",
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body)
					end,
				},
				sources = {
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
					format = require("lspkind").cmp_format(),
				},
				experimental = { ghost_text = true },
			})
		end,
		event = "InsertEnter",
	},
}, {
	checker = {
		enabled = true,
	},
})
