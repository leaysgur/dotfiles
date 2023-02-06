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
vim.opt.swapfile = false
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

-- Disable some builtin vim plugins
local default_plugins = {
	"2html_plugin",
	"getscript",
	"getscriptPlugin",
	"gzip",
	"logipat",
	"netrw",
	"netrwPlugin",
	"netrwSettings",
	"netrwFileHandlers",
	"matchit",
	"tar",
	"tarPlugin",
	"rrhelper",
	"spellfile_plugin",
	"vimball",
	"vimballPlugin",
	"zip",
	"zipPlugin",
	"tutor",
	"rplugin",
	"syntax",
	"synmenu",
	"optwin",
	"compiler",
	"bugreport",
	"ftplugin",
}
for _, plugin in pairs(default_plugins) do
	vim.g["loaded_" .. plugin] = 1
end


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
			vim.keymap.set("n", "\\", ":Neotree toggle reveal_force_cwd<CR>", map_args)
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
			{
				"glepnir/lspsaga.nvim",
				opts = {
					symbol_in_winbar = { enable = false },
					lightbulb = { enable = false },
					finder = {
						split = "s",
						vsplit = "v",
					},
				},
				init = function()
					vim.keymap.set("n", "gs", ":sp | :Lspsaga goto_definition<CR>", map_args)
					vim.keymap.set("n", "gv", ":vs | :Lspsaga goto_definition<CR>", map_args)
					vim.keymap.set("n", "gr", ":Lspsaga lsp_finder<CR>", map_args)
					vim.keymap.set("n", "K", ":Lspsaga hover_doc<CR>", map_args)
				end,
				cmd = "Lspsaga",
			},
		},
		config = function()
			local default_capabilities = require("cmp_nvim_lsp").default_capabilities()
			require("mason-lspconfig").setup_handlers({
				function(server)
					local options = {
						capabilities = default_capabilities,
						on_attach = function(_, bufnr)
							local buf_opts = vim.list_extend({ buffer = bufnr }, map_args)
							vim.keymap.set("n", "<Space>f", function()
								vim.lsp.buf.format({ async = true })
							end, buf_opts)

							-- Show diagnostics only on hover
							vim.diagnostic.config({ virtual_text = false })
							vim.api.nvim_create_autocmd("CursorHold", {
								buffer = bufnr,
								command = ":Lspsaga show_line_diagnostics",
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
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-emoji",
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
					format = require("lspkind").cmp_format({ mode = "symbol_text" }),
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
