-- Basics
vim.opt.number = true
vim.opt.termguicolors = true
vim.opt.autochdir = true
vim.opt.tabstop = 2
-- Prefer soft tab
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
-- Show hidden characters
vim.opt.list = true
vim.opt.listchars = { tab = "»»", trail = "-" }
-- Prefer global status line
vim.opt.laststatus = 3
-- Yank to OS clipboard
vim.opt.clipboard = "unnamedplus"

-- Keep visual mode after indentation
vim.keymap.set("v", "<", "<gv", { noremap = true })
vim.keymap.set("v", ">", ">gv", { noremap = true })
-- Clear search highlight
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { noremap = true })

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
			vim.cmd([[colorscheme terafox]])
		end,
	},

	-- Uis
	{ "ojroques/nvim-hardline", config = true },
	{
		"lewis6991/gitsigns.nvim",
		config = {
			signcolumn = false,
			numhl = true,
		},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		config = {
			show_current_context = true,
		},
	},
	{ "petertriho/nvim-scrollbar", config = true },

	-- Utils
	{ "NMAC427/guess-indent.nvim", config = true },
	{ "yutkat/history-ignore.nvim", config = true },
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
	},

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
			vim.keymap.set("n", "<C-p>", ":Telescope git_files<CR>", { silent = true, noremap = true })
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
								["<Esc>"] = function(buf)
									require("telescope.actions").close(buf)
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
	{ "windwp/nvim-autopairs", config = true },
	-- XXX: `config = true` is enough but it throws...
	{ "andymass/vim-matchup", config = {} },
	{
		"terrortylor/nvim-comment",
		-- XXX: `config = { ... }` does not work because plugin name is not consistent
		config = function()
			require("nvim_comment").setup({ create_mappings = false })
		end,
		init = function()
			vim.keymap.set("n", "<C-_>", ":CommentToggle<CR>", { silent = true, noremap = true })
			vim.keymap.set("v", "<C-_>", ":'<,'>CommentToggle<CR>", { silent = true, noremap = true })
		end,
		cmd = "CommentToggle",
	},

	-- LSP
	"neovim/nvim-lspconfig",
	{ "williamboman/mason.nvim", config = true },
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup_handlers({
				function(server)
					local options = {
						capabilities = require("cmp_nvim_lsp").default_capabilities(),
						on_attach = function(_, buf)
							local buf_opts = { noremap = true, silent = true, buffer = buf }
							vim.keymap.set("n", "gs", ":sp | lua vim.lsp.buf.definition()<CR>", buf_opts)
							vim.keymap.set("n", "gv", ":vs | lua vim.lsp.buf.definition()<CR>", buf_opts)
							vim.keymap.set("n", "gr", vim.lsp.buf.references, buf_opts)
							vim.keymap.set("n", "K", vim.lsp.buf.hover, buf_opts)
							vim.keymap.set("n", "<Space>f", function()
								vim.lsp.buf.format({ async = true })
							end, buf_opts)
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
	},
	{ "j-hui/fidget.nvim", config = true },

	-- Completion
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"hrsh7th/vim-vsnip",
			"hrsh7th/cmp-emoji",
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
			})
		end,
	},
}, {
	checker = {
		enabled = true,
	},
})
