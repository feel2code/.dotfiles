local vim = vim
-- leader key
vim.g.mapleader = ' '
-- numbers at left
vim.o.number = true
-- relative numbers
vim.o.relativenumber = true
-- symbols at left
vim.o.signcolumn = "yes"
-- colored
vim.o.termguicolors = true
vim.o.wrap = false
vim.o.swapfile = false
vim.o.winborder = "rounded"
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true
-- tabs
vim.o.tabstop = 4
vim.o.list = true
vim.opt.listchars = {
	tab = "  ",
	trail = "_",
}

-- clipboard
vim.o.clipboard = "unnamedplus"
vim.api.nvim_create_autocmd('UIEnter', {
	callback = function()
		vim.o.clipboard = 'unnamedplus'
	end,
})

-- Highlight when yanking (copying) text.
vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking (copying) text',
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Create a command `:GitBlameLine` that print the git blame for the current line
vim.api.nvim_create_user_command('GitBlameLine', function()
	local line_number = vim.fn.line('.') -- Get the current line number. See `:h line()`
	local filename = vim.api.nvim_buf_get_name(0)
	print(vim.fn.system({ 'git', 'blame', '-L', line_number .. ',+1', filename }))
end, { desc = 'Print the git blame for the current line' })

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
	{ "neovim/nvim-lspconfig" },
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
	{ "nvim-treesitter/nvim-treesitter" },
	-- nohlsearch
	{
		'nvimdev/hlsearch.nvim',
		event = 'BufRead',
		config = function()
			require('hlsearch').setup()
		end
	},
	-- colorcheme
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("catppuccin-mocha") -- latte, frappe, macchiato, mocha
		end,
	},
	-- oil file tree
	{ "stevearc/oil.nvim" },
	-- file picker
	{ "echasnovski/mini.pick" },
	-- Autocomplete
	{ "hrsh7th/nvim-cmp" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "L3MON4D3/LuaSnip" },
	{ "saadparwaiz1/cmp_luasnip" },
	-- lint
	{
		"nvimtools/none-ls.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	-- autoformat
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					python = { "isort", "black" },
				},
				format_on_save = {
					lsp_fallback = true,
					timeout_ms = 1000,
				},
			})
		end,
	}
})

-- mason
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls", "pyright" }
})

-- lsp attach
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})
vim.cmd("set completeopt+=noselect")

-- cmp
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()
lspconfig.pyright.setup({
	capabilities = capabilities,
})

local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = {
		["<Tab>"] = cmp.mapping.select_next_item(),
		["<S-Tab>"] = cmp.mapping.select_prev_item(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	},
})

-- null_ls for lint
local null_ls = require("null-ls")
null_ls.setup({
	sources = {
		null_ls.builtins.diagnostics.pylint.with({
			command = "pylint",
			args = {
				"--output-format=json",
				"--from-stdin", "%filepath"
			},
			method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
		}),
	},
})

vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	update_in_insert = false,
})

-- mini.pick
require "mini.pick".setup()
-- nvim-treesitter
require "nvim-treesitter.configs".setup({
	ensure_installed = { "python" },
	highlight = { enable = true }
})
--oil
require "oil".setup()

-- keymaps
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>y', '"+y<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>d', '"+d<CR>')
vim.keymap.set('n', '<leader>ff', ":Pick files<CR>")
vim.keymap.set("n", "<leader>fw", ":Pick grep_live<CR>")
vim.keymap.set('n', '<leader>h', ":term<CR>i")
vim.keymap.set('n', '<leader>e', ":Oil<CR>")
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)
vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
vim.keymap.set("n", "<leader>cr", ":!python3 % <CR>")
vim.keymap.set("n", "<leader>gb", ":GitBlameLine<CR>")
vim.keymap.set("n", "<leader>x", ":bd<CR>")
vim.keymap.set("n", "<Tab>", ":bn<CR>")
vim.keymap.set("n", "<S-Tab>", ":bp<CR>")

-- lsp enabling
vim.lsp.enable({ "lua_ls", "pyright" })
-- transparent statusline
vim.cmd(":hi statusline guibg=NONE")
