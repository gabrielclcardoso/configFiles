require("plugins.packer")
require("plugins.Canonical")
require("plugins.treesitter")
local path = os.getenv("HOME") .. "/.config/nvim/lua/plugins/stdheader.vim"
vim.cmd('source "path"') 
