-- # Install `mini.deps`
local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.deps"
if not vim.loop.fs_stat(mini_path) then
	vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/echasnovski/mini.deps", mini_path })
	vim.cmd("packadd mini.deps | helptags ALL")
end

-- # Setup `mini.deps`
require("mini.deps").setup({ path = { package = path_package } })
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- # Global options and keymaps
now(function()
	vim.g.mapleader = " "
	vim.g.maplocalleader = "\\"
	-- Ui
	vim.opt.number = true
	vim.opt.list = true
	vim.opt.listchars = { tab = "__" }
	vim.opt.completeopt = { "menu", "menuone", "noselect", "popup" }
	vim.opt.splitright = true
	vim.opt.splitbelow = true
	-- Since Nvim does not have API for it, add border to completion list is impossible for now
	-- https://github.com/echasnovski/mini.nvim/issues/741
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

	-- Keep visual mode after indentation
	vim.keymap.set("v", "<", "<gv")
	vim.keymap.set("v", ">", ">gv")
	-- Clear search highlight
	vim.keymap.set("n", "<Esc>", ":nohlsearch<CR><Esc>", { silent = true })
end)

-- # Theme, UIs
now(function()
	add({ source = "everviolet/nvim", name = "evergarden" })
	require("evergarden").setup({
		theme = { variant = "fall", accent = "overlay1" },
		editor = { transparent_background = true },
	})
	vim.cmd([[colorscheme evergarden]])
end)

now(function()
	add({ source = "echasnovski/mini.icons" })
	require("mini.icons").setup()
	require("mini.icons").tweak_lsp_kind()
	require("mini.icons").mock_nvim_web_devicons()
end)

now(function()
	add({ source = "echasnovski/mini.notify" })
	require("mini.notify").setup()
	vim.notify = require("mini.notify").make_notify()
end)

now(function()
	add({ source = "bluz71/nvim-linefly" })
	vim.g.linefly_options = { with_search_count = true }
end)

now(function()
	add({ source = "b0o/incline.nvim" })
	require("incline").setup()
end)

now(function()
	add({
		source = "nvim-neo-tree/neo-tree.nvim",
		checkout = "v3.x",
		depends = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		},
	})
	require("neo-tree").setup({
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
	})
end)

now(function()
	add({ source = "folke/snacks.nvim" })
	require("snacks").setup({
		bigfile = {},
		indent = {},
		picker = {}, -- Used by `codecompanion.nvim`
		words = { debounce = 50 },
	})
	vim.keymap.set("n", "[w", ":lua Snacks.words.jump(-vim.v.count1, true)<CR>", { silent = true })
	vim.keymap.set("n", "]w", ":lua Snacks.words.jump(vim.v.count1, true)<CR>", { silent = true })
end)

-- # UX
later(function()
	add({ source = "ibhagwan/smartyank.nvim" })
	require("smartyank").setup({ highlight = { timeout = 80 } })
end)

later(function()
	add({ source = "sphamba/smear-cursor.nvim" })
	require("smear_cursor").setup({ color_levels = 8, gamma = 4 })
end)

later(function()
	add({ source = "rainbowhxch/accelerated-jk.nvim" })
	require("accelerated-jk").setup()
	vim.keymap.set("n", "<Up>", "<Plug>(accelerated_jk_gk)", { silent = true })
	vim.keymap.set("n", "<Down>", "<Plug>(accelerated_jk_gj)", { silent = true })
end)

later(function()
	add({ source = "nvim-focus/focus.nvim" })
	require("focus").setup({ commands = false })
end)

later(function()
	add({ source = "catgoose/nvim-colorizer.lua" })
	require("colorizer").setup({
		user_commands = false,
		user_default_options = { css = true, tailwind = true },
	})
end)

later(function()
	add({ source = "echasnovski/mini.diff" })
	require("mini.diff").setup()
end)

-- # Treesitter
-- now(function()
-- 	add({
-- 		source = "nvim-treesitter/nvim-treesitter",
-- 		checkout = "master",
-- 		depends = {
-- 			"JoosepAlviste/nvim-ts-context-commentstring",
-- 			"nvim-treesitter/nvim-treesitter-context",
-- 			"windwp/nvim-ts-autotag",
-- 			"theHamsta/nvim-treesitter-pairs",
-- 		},
-- 	})
-- 	require("nvim-treesitter.configs").setup({
-- 		ensure_installed = "all",
-- 		ignore_install = { "ipkg" },
-- 		highlight = {
-- 			enable = true,
-- 			additional_vim_regex_highlighting = false,
-- 		},
-- 		indent = { enable = true },
-- 		pairs = {
-- 			enable = true,
-- 			fallback_cmd_normal = "normal! %",
-- 			keymaps = { goto_partner = "%" },
-- 		},
-- 	})
-- 	vim.cmd("TSUpdate")

-- 	require("ts_context_commentstring").setup({ enable_autocmd = false })
-- 	require("treesitter-context").setup({ max_lines = 1 })
-- 	require("nvim-ts-autotag").setup()
-- end)

-- now(function()
-- 	add({ source = "terrortylor/nvim-comment" })
-- 	require("nvim_comment").setup({
-- 		create_mappings = false,
-- 		comment_empty = false,
-- 		hook = function() require("ts_context_commentstring").update_commentstring() end,
-- 	})
-- 	vim.keymap.set("n", "<C-_>", ":CommentToggle<CR>", { silent = true })
-- 	vim.keymap.set("v", "<C-_>", ":'<,'>CommentToggle<CR>", { silent = true })
-- end)

-- now(function()
-- 	add({ source = "Wansmer/treesj" })
-- 	require("treesj").setup({ use_default_keymaps = false })
-- 	vim.keymap.set("n", "sj", ":TSJToggle<CR>", { silent = true })
-- end)

-- # Editing
later(function()
	add({ source = "echasnovski/mini.surround" })
	require("mini.surround").setup()
end)

later(function()
	add({ source = "monkoose/matchparen.nvim" })
	require("matchparen").setup()
end)

later(function()
	add({ source = "windwp/nvim-autopairs" })
	require("nvim-autopairs").setup()
end)

later(function()
	add({ source = "Darazaki/indent-o-matic" })
	require("indent-o-matic").setup({})
end)

-- # Language server, linter, formatter
now(function()
	add({
		source = "neovim/nvim-lspconfig",
		depends = {
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
			"echasnovski/mini.completion",
		},
	})

	local default_config = {
		on_attach = function(_, bufnr)
			local keymap_opts = { buffer = bufnr, silent = true }
			vim.keymap.set("n", "R", vim.lsp.buf.rename, keymap_opts)
			vim.keymap.set("n", "gs", ":sp | lua vim.lsp.buf.definition()<CR>", keymap_opts)
			vim.keymap.set("n", "gv", ":vs | lua vim.lsp.buf.definition()<CR>", keymap_opts)
		end,
		capabilities = require("mini.completion").get_lsp_capabilities(),
	}
	local server_configs = {
		lua_ls = {
			settings = {
				Lua = { diagnostics = { globals = { "vim", "MiniDeps" } } },
			},
		},
		rust_analyzer = {
			settings = {
				["rust-analyzer"] = {
					check = {
						command = "clippy",
						extraArgs = { "--target-dir", "./target/rust-analyzer" },
					},
				},
			},
		},
	}

	require("mason").setup()
	for _, server in ipairs(require("mason-lspconfig").get_installed_servers()) do
		vim.lsp.config(server, vim.tbl_deep_extend("force", default_config, server_configs[server] or {}))
	end
	require("mason-lspconfig").setup() -- will call `vim.lsp.enable()`
end)

later(function()
	add({ source = "rachartier/tiny-inline-diagnostic.nvim" })
	require("tiny-inline-diagnostic").setup({
		preset = "nonerdfont",
		signs = { arrow = "", up_arrow = "" }, -- Arrows are useless because column pos is not moved
		options = { show_source = true },
	})
end)

later(function()
	add({ source = "dnlhc/glance.nvim" })
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
	vim.keymap.set("n", "gd", ":Glance definitions<CR>", { silent = true })
	vim.keymap.set("n", "gr", ":Glance references<CR>", { silent = true })
end)

later(function()
	add({
		source = "hedyhli/outline.nvim",
		depends = { "echasnovski/mini.icons" },
	})
	require("outline").setup({
		outline_window = { width = 50 },
		outline_items = { show_symbol_lineno = true },
		keymaps = { fold_toggle = "<Space>" },
		symbol_folding = { autofold_depth = 2 },
		symbols = {
			icon_fetcher = function(kind)
				return require("mini.icons").get("lsp", kind) .. " " .. kind
			end,
		},
	})
	vim.api.nvim_create_user_command("OO", "Outline", {})
end)

later(function()
	add({ source = "stevearc/conform.nvim" })
	require("conform").setup({
		formatters_by_ft = {
			lua = { "stylua" },
			rust = { "rustfmt" },
			["_"] = { "prettier" },
		},
	})

	vim.keymap.set("n", "<Space>f", ":lua require('conform').format()<CR>", { silent = true })
end)

-- # Completion
later(function()
	add({
		source = "echasnovski/mini.completion",
	})
	require("mini.completion").setup({
		lsp_completion = { source_func = "omnifunc" },
	})

	vim.keymap.set("i", "<Tab>", [[pumvisible() ? "\<Down>" : "\<Tab>"]], { expr = true, replace_keycodes = false })
	vim.keymap.set("i", "<S-Tab>", [[pumvisible() ? "\<Up>" : "\<S-Tab>"]], { expr = true, replace_keycodes = false })
end)

later(function()
	add({ source = "zbirenbaum/copilot.lua" })
	require("copilot").setup({
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
	})
end)

later(function()
	add({
		source = "olimorris/codecompanion.nvim",
		depends = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
	})
	require("codecompanion").setup({
		strategies = { chat = { adapter = "anthropic" } },
		adapters = {
			copilot = function()
				return require("codecompanion.adapters").extend(
					"copilot",
					{ schema = { model = { default = "claude-3.7-sonnet-thought" } } }
				)
			end,
			anthropic = function()
				return require("codecompanion.adapters").extend(
					"anthropic",
					{ schema = { model = { default = "claude-opus-4-20250514" } } }
				)
			end,
		},
		display = { chat = { show_header_separator = true } },
		opts = { language = "same" },
	})

	vim.api.nvim_create_autocmd({ "User" }, {
		pattern = "CodeCompanionRequest{Started,Streaming,Finished}",
		group = vim.api.nvim_create_augroup("CodeCompanionHooks", { clear = true }),
		callback = function(request)
			vim.notify("CodeCompanion: " .. request.match:gsub("CodeCompanion", ""), vim.log.levels.INFO, {
				id = "code_companion_status",
				title = "CodeCompanion.nvim",
				timeout = 1600,
				keep = function()
					return not vim.endswith(request.match, "Finished")
				end,
			})
		end,
	})
end)
