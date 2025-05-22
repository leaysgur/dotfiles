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
vim.opt.completeopt = { "menu", "menuone", "noselect", "popup" }
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.winborder = "single"
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
vim.opt.timeoutlen = 300

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
		"neanias/everforest-nvim",
		priority = 1000,
		main = "everforest",
		opts = {
			transparent_background_level = 1,
			italics = true,
		},
		--stylua: ignore
		init = function() vim.cmd([[colorscheme everforest]]) end,
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
		--stylua: ignore
		init = function() vim.g.linefly_options = {
				with_lsp_status = true,
				with_search_count = true,
		} end,
		-- Do not lazy load, just leave it to plugin
	},
	{ "b0o/incline.nvim", config = true, event = LazyFile },
	{
		"folke/snacks.nvim",
		priority = 1000,
		opts = {
			bigfile = {},
			dashboard = {},
			indent = {},
			notifier = {}, -- For `CodeCompanion.nvim` to display progress
			picker = {}, -- For `CodeCompanion.nvim` to change adapters
			words = { debounce = 50 },
		},
		init = function()
			vim.keymap.set("n", "[w", ":lua Snacks.words.jump(-vim.v.count1, true)<CR>", { silent = true })
			vim.keymap.set("n", "]w", ":lua Snacks.words.jump(vim.v.count1, true)<CR>", { silent = true })
		end,
		lazy = false,
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
	{
		"rainbowhxch/accelerated-jk.nvim",
		config = true,
		keys = {
			{ "<Up>", "<Plug>(accelerated_jk_gk)", silent = true },
			{ "<Down>", "<Plug>(accelerated_jk_gj)", silent = true },
		},
	},
	{
		"nvim-focus/focus.nvim",
		opts = { commands = false },
		event = LazyFile,
	},
	{ "echasnovski/mini.diff", config = true, event = LazyFile },
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
	{
		"catgoose/nvim-colorizer.lua",
		opts = {
			user_commands = false,
			user_default_options = { css = true, tailwind = true },
		},
		ft = { "css", "html", "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte", "astro" },
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

	-- ## Editing
	{ "Darazaki/indent-o-matic", config = true, event = LazyFile },
	{ "echasnovski/mini.surround", config = true, event = LazyFile },
	{ "monkoose/matchparen.nvim", config = true, event = LazyFile },
	{ "windwp/nvim-autopairs", config = true, event = "InsertEnter" },
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
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			adapters = {
				copilot = function()
					return require("codecompanion.adapters").extend(
						"copilot",
						{ schema = { model = { default = "gemini-2.5-pro" } } }
					)
				end,
			},
			display = { chat = { show_header_separator = true } },
			opts = { language = "same(user asked)" },
		},
		init = function()
			vim.api.nvim_create_autocmd({ "User" }, {
				pattern = "CodeCompanionRequest{Started,Streaming,Finished}",
				group = vim.api.nvim_create_augroup("CodeCompanionHooks", { clear = true }),
				callback = function(request)
					vim.notify("[CodeCompanion] " .. request.match:gsub("CodeCompanion", ""), "info", {
						id = "code_companion_status",
						title = "CodeCompanion.nvim",
						timeout = 1600,
						-- stylua: ignore
						keep = function() return not vim.endswith(request.match, "Finished") end,
					})
				end,
			})
		end,
		event = LazyFile,
	},

	-- ## LSP
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "mason-org/mason.nvim", config = true },
			{ "mason-org/mason-lspconfig.nvim", config = true },
			"saghen/blink.cmp",
		},
		config = function()
			local default_config = {
				on_attach = function(_, bufnr)
					local keymap_opts = { buffer = bufnr, silent = true }
					vim.keymap.set("n", "R", vim.lsp.buf.rename, keymap_opts)
					vim.keymap.set("n", "gs", ":sp | lua vim.lsp.buf.definition()<CR>", keymap_opts)
					vim.keymap.set("n", "gv", ":vs | lua vim.lsp.buf.definition()<CR>", keymap_opts)
				end,
				capabilities = require("blink.cmp").get_lsp_capabilities(),
			}
			local server_configs = {
				lua_ls = {
					settings = {
						Lua = { diagnostics = { globals = { "vim" } } },
					},
				},
				rust_analyzer = {
					settings = {
						["rust-analyzer"] = {
							check = {
								command = "clippy",
								extraArgs = { "--target-dir", "./target/ra" },
							},
						},
					},
				},
			}

			for _, server in ipairs(require("mason-lspconfig").get_installed_servers()) do
				vim.lsp.config(server, vim.tbl_deep_extend("force", default_config, server_configs[server] or {}))
			end
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
				border = { enable = true },
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
	{
		"hedyhli/outline.nvim",
		opts = {
			outline_window = { width = 50 },
			outline_items = { show_symbol_lineno = true },
			keymaps = { fold_toggle = "<Space>" },
			symbol_folding = { autofold_depth = 2 },
			symbols = {
				icon_fetcher = function(kind)
					return require("mini.icons").get("lsp", kind) .. " " .. kind
				end,
			},
		},
		--stylua: ignore
    init = function() vim.api.nvim_create_user_command("OO", "Outline", {}) end,
		cmd = "Outline",
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
			completion = {
				menu = {
					border = "single",
					draw = {
						components = {
							kind_icon = {
								ellipsis = false,
								text = function(ctx)
									local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
									return kind_icon .. " " .. ctx.kind
								end,
								highlight = function(ctx)
									local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
									return hl
								end,
							},
						},
					},
				},
				list = { selection = { preselect = false, auto_insert = false } },
				documentation = { auto_show = true, window = { border = "single" } },
			},
			signature = { enabled = true, window = { border = "single" } },
			cmdline = { enabled = false },
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
