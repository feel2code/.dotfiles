---@type ChadrcConfig
local M = {}

M.ui = {
  theme = 'catppuccin',
  transparency = true,
  statusline = {
    theme = "vscode_colored",
    separator_style = "default",
    overriden_modules = nil,
  },

}
M.plugins = "custom.plugins"
vim.opt.relativenumber = true

return M
