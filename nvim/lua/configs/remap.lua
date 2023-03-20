vim.g.mapleader = " "

vim.keymap.set("n", "<leader>cc", vim.cmd.Canonical)
vim.keymap.set("n", "<leader>hs", vim.cmd.split)
vim.keymap.set("n", "<leader>vs", vim.cmd.vsplit)
vim.keymap.set("n", "<leader>wr", vim.cmd.write)

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<leader>ww", "<C-w><C-w>")

--Telescope binds--
local telescope = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', telescope.find_files, {})

--nvim-tree binds--
local api = require('nvim-tree.api')
vim.keymap.set('n', '<leader>ee', api.tree.toggle, {})
