local M = {}

M.gitsigns = {
  plugin = true,

  n = {
    ["<leader>gn"] = {
      function()
        package.loaded.gitsigns.blame()
      end,
      "Blame fugitive",
    },
  },
}

return M
