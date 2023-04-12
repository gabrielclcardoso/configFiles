require("plugins.packer")
require("plugins.Canonical")
require("plugins.treesitter")
require("plugins.lsp")
require("plugins.nvim-tree")
require("plugins.lualine")
local path = os.getenv("HOME") .. "/.config/nvim/lua/plugins/stdheader.vim"
vim.cmd { cmd = 'source', args = { path } }
