-- Basics
vim.opt.termguicolors = true
vim.opt.pumblend = 10
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.list = true
vim.opt.listchars = { tab = "__" }
-- Prefer global status line
vim.opt.laststatus = 3
vim.opt.completeopt = "menu,menuone,noselect"
-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- Prefer soft tab
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
-- Keep updating cwd
vim.opt.autochdir = true
-- Faster CursorHold
vim.opt.updatetime = 500
-- Disable mouse for term handler
vim.opt.mouse = ""


local map_args = { silent = true, noremap = true };
-- Keep visual mode after indentation
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
-- Clear search highlight
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR><Esc>", map_args)


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
		"EdenEast/nightfox.nvim",
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme nightfox]])
		end,
	},

	-- Uis
	"nvim-tree/nvim-web-devicons",
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signcolumn = false,
			numhl = true,
			linehl = true,
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
	{ "feline-nvim/feline.nvim", config = true, event = "BufReadPost" },

	-- Utils
	{ "NMAC427/guess-indent.nvim", config = true, event = "BufReadPost" },
	{ "yutkat/history-ignore.nvim", config = true, event = "BufReadPost" },
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = "all",
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				indent = { enable = true },
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
		},
		config = function()
			vim.cmd([[
				let g:loaded_netrw = 1
				let g:loaded_netrwPlugin = 1
				let g:neo_tree_remove_legacy_commands = 1
			]])
			require("neo-tree").setup({
				filesystem = {
					filtered_items = { visible = true },
					hijack_netrw_behavior = "open_current",
				},
			})
		end,
	},

	-- Fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.0",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		init = function()
			vim.keymap.set("n", "<C-p>", ":Telescope git_files show_untracked=true <CR>", map_args)
		end,
		config = function()
			require("telescope").setup({
				defaults = {
					mappings = {
						i = {
							["<C-s>"] = require("telescope.actions").select_horizontal,
						},
					},
				},
			})
		end,
		cmd = "Telescope",
	},

	-- Editors
	{ "machakann/vim-sandwich", event = "BufReadPost" },
	{ "windwp/nvim-autopairs", config = true, event = "BufReadPost" },
	-- XXX: `config = true` is enough but it throws...
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
			vim.keymap.set("n", "<C-_>", ":CommentToggle<CR>", map_args)
			vim.keymap.set("v", "<C-_>", ":'<,'>CommentToggle<CR>", map_args)
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
		},
		config = function()
			local default_capabilities = require("cmp_nvim_lsp").default_capabilities()
			require("mason-lspconfig").setup_handlers({
				function(server)
					local options = {
						capabilities = default_capabilities,
						on_attach = function(_, bufnr)
							local buf_opts = vim.list_extend({ buffer = bufnr }, map_args)
							vim.keymap.set("n", "gs", ":sp | lua vim.lsp.buf.definition()<CR>", buf_opts)
							vim.keymap.set("n", "gv", ":vs | lua vim.lsp.buf.definition()<CR>", buf_opts)
							vim.keymap.set("n", "gr", vim.lsp.buf.references, buf_opts)
							vim.keymap.set("n", "K", vim.lsp.buf.hover, buf_opts)
							vim.keymap.set("n", "<Space>f", function()
								vim.lsp.buf.format({ async = true })
							end, buf_opts)

							-- Show diagnostics only on hover
							vim.diagnostic.config({ virtual_text = false })
							vim.api.nvim_create_autocmd("CursorHold", {
								buffer = bufnr,
								callback = vim.diagnostic.open_float,
							})
						end,
					}

					-- Suppress "Undefined global `vim`" warning
					if server == "sumneko_lua" then
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
		event = "BufReadPre",
	},

	-- Completion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"hrsh7th/vim-vsnip",
			"hrsh7th/cmp-emoji",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"onsails/lspkind.nvim",
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
					{ name = "vsnip" },
					{ name = "buffer" },
					{ name = "path" },
					{ name = "emoji" },
				},
				mapping = cmp.mapping.preset.insert({
					["<Tab>"] = function(fallback)
						if cmp.visible() then cmp.select_next_item() else fallback() end
					end,
					["<S-Tab>"] = function(fallback)
						if cmp.visible() then cmp.select_prev_item() else fallback() end
					end,
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					}),
				}),
				formatting = {
					format = require("lspkind").cmp_format({ mode = "symbol_text", preset = "codicons" }),
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
