---@type ChadrcConfig
local M = {}

M.ui = {
  theme = 'chadracula',
  transparency = true,
  statusline = {
    theme = "vscode_colored",
    separator_style = "default",
    overriden_modules = nil,
  },

}
M.plugins = "custom.plugins"
vim.opt.relativenumber = true

vim.keymap.set('i', '<C-y>', 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false
})
vim.g.copilot_no_tab_map = true

return M
