local vim = vim
vim.g.mapleader = " "
vim.o.nu = true
vim.o.rnu = true
vim.o.termguicolors = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.cursorline = true
vim.o.confirm = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.list = true
vim.opt.listchars = { tab = "  ", trail = "_" }

vim.o.clipboard = "unnamedplus"
vim.cmd("set completeopt+=noselect")

-- git blame custom
vim.api.nvim_create_user_command("GitBlameLine", function()
    local line_number = vim.fn.line(".")
    local filename = vim.api.nvim_buf_get_name(0)
    local blame = vim.fn.system({ "git", "blame", "-L", line_number .. ",+1", filename })
    local hash = blame:match("^(%x+)")
    local summary = hash and vim.fn.system({ "git", "log", "-1", "--pretty=format:%s", hash }) or ""
    print(blame .. "  " .. summary)
end, { desc = "Print the git blame for the current line" })

-- Built-in package manager (Neovim 0.12+)
vim.pack.add({
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/stevearc/conform.nvim" },
    { src = "https://github.com/catppuccin/nvim" },
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/echasnovski/mini.pick" },
    { src = "https://github.com/nvimdev/hlsearch.nvim" },
})

-- Plugin setup (safe pcall)
pcall(vim.cmd.colorscheme, "catppuccin-mocha")

do
    local ok, hl = pcall(require, "hlsearch")
    if ok then hl.setup() end
end

do
    local ok, oil = pcall(require, "oil")
    if ok then oil.setup() end
end

do
    local ok, pick = pcall(require, "mini.pick")
    if ok then
        pick.setup({
            mappings = { choose_marked = "<C-q>" },
        })
    end
end

do
    local ok, conform = pcall(require, "conform")
    if ok then
        conform.setup({
            formatters_by_ft = {
                python = { "ruff_organize_imports", "ruff_format" },
            },
            format_on_save = {
                lsp_fallback = true,
                timeout_ms = 1000,
            },
        })
    end
end

do
    local ok, ts = pcall(require, "nvim-treesitter.configs")
    if ok then
        ts.setup({
            ensure_installed = { "python", "lua", "markdown", "vimdoc" },
            highlight = { enable = true },
        })
    end
end

-- LSP
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client and client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
        end
    end,
})

vim.lsp.config("lua_ls", {})

vim.lsp.config("jedi_language_server", {
    on_attach = function(_, bufnr)
        vim.api.nvim_create_autocmd("CursorHold", {
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.hover()
            end,
        })
    end,
})

vim.lsp.config("ruff", {
    init_options = {
        settings = {
            lint = { enable = true },
            configurationPreference = "filesystemFirst",
        },
    },
})

vim.lsp.enable({ "lua_ls", "jedi_language_server", "ruff" })

vim.diagnostic.config({
    virtual_text = {
        format = function(diagnostic)
            if diagnostic.code then
                return string.format("%s [%s]", diagnostic.message, diagnostic.code)
            end
            return diagnostic.message
        end,
    },
    signs = true,
    update_in_insert = false,
})

-- Keymaps
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]])
vim.keymap.set("n", "<leader>ff", "<cmd>Pick files<CR>")
vim.keymap.set("n", "<leader>fw", "<cmd>Pick grep_live<CR>")
vim.keymap.set("n", "<leader>h", "<cmd>term<CR>i")
vim.keymap.set("n", "<leader>e", "<cmd>Oil<CR>")
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format)
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "<leader>cr", "<cmd>!python3 %<CR>")
vim.keymap.set("n", "<leader>gb", "<cmd>GitBlameLine<CR>")
vim.keymap.set("n", "<leader>x", "<cmd>bd<CR>")
vim.keymap.set("n", "<Tab>", "<cmd>bn<CR>")
vim.keymap.set("n", "<S-Tab>", "<cmd>bp<CR>")

-- UI
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
-- langmap
vim.cmd([[
set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz
]])
