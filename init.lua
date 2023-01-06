-- Basics
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.tabstop = 2
vim.opt.list = true
vim.opt.listchars = { tab = "»»", trail = "-" }
-- Prefer global status line
vim.opt.laststatus = 3
-- Keep updating cwd
vim.opt.autochdir = true
-- Faster CursorHold
vim.opt.updatetime = 500
-- Prefer soft tab
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
-- Yank to OS clipboard
vim.opt.clipboard = "unnamedplus"
-- Disable mouse for term handler
vim.opt.mouse = ""

local map_args = { silent = true, noremap = true };
-- Keep visual mode after indentation
vim.keymap.set("v", "<", "<gv", { noremap = true })
vim.keymap.set("v", ">", ">gv", { noremap = true })
-- Clear search highlight
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", map_args)

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
	{ "ojroques/nvim-hardline", config = true, event = "BufReadPost" },
	{
		"lewis6991/gitsigns.nvim",
		config = {
			signcolumn = false,
			numhl = true,
		},
		event = "BufReadPost",
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		config = {
			show_current_context = true,
		},
		event = "BufReadPost",
	},
	{ "petertriho/nvim-scrollbar", config = true, event = "BufReadPost" },
	{ "rbtnn/vim-ambiwidth", event = "BufReadPost" },
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = "all",
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				-- Enhance `vim-matchup`
				matchup = { enable = true },
			})
		end,
		event = "BufReadPost",
	},

	-- Utils
	{ "NMAC427/guess-indent.nvim", config = true, event = "BufReadPost" },
	{ "yutkat/history-ignore.nvim", config = true, event = "BufReadPost" },

	-- Finder, file browser
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.0",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
		},
		init = function()
			vim.keymap.set("n", "<C-p>", ":Telescope git_files show_untracked=true <CR>", map_args)
		end,
		config = function()
			local telescope = require("telescope");
			telescope.setup({
				defaults = {
					mappings = {
						i = {
							["<C-s>"] = require("telescope.actions").select_horizontal,
						},
					},
				},
				extensions = {
					file_browser = {
						hijack_netrw = true,
						hidden = true,
						grouped = true,
						initial_mode = "normal",
						mappings = {
							n = {
								-- Override default to auto-close empty buffer
								["<Esc>"] = function(bufnr)
									require("telescope.actions").close(bufnr)
									-- But confirm to prevent from closing non-empty buffer
									vim.cmd([[:confirm quit]])
								end
							},
						},
					},
				},
			})
			telescope.load_extension("file_browser")
		end,
	},

	-- Editors
	{ "machakann/vim-sandwich", event = "BufReadPost" },
	{ "windwp/nvim-autopairs", config = true, event = "BufReadPost" },
	-- XXX: `config = true` is enough but it throws...
	{ "andymass/vim-matchup", config = {}, event = "BufReadPost" },
	{
		"terrortylor/nvim-comment",
		-- XXX: `config = { ... }` does not work because plugin name is not consistent
		config = function()
			require("nvim_comment").setup({ create_mappings = false })
		end,
		init = function()
			vim.keymap.set("n", "<C-_>", ":CommentToggle<CR>", map_args)
			vim.keymap.set("v", "<C-_>", ":'<,'>CommentToggle<CR>", map_args)
		end,
		cmd = "CommentToggle",
	},

	-- LSP
	{ "neovim/nvim-lspconfig", event = "BufReadPost" },
	{ "williamboman/mason.nvim", config = true, event = "BufReadPost" },
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup_handlers({
				function(server)
					local options = {
						capabilities = require("cmp_nvim_lsp").default_capabilities(),
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
		event = "BufReadPost",
	},
	{ "j-hui/fidget.nvim", config = true, event = "BufReadPost" },

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
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{ name = "vsnip" },
					{ name = "path" },
					{ name = "emoji" },
					{ name = "nvim_lsp_signature_help" },
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
