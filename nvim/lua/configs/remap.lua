vim.g.mapleader = " "
vim.keymap.set("n", "<leader>ee", vim.cmd.Ex)
vim.keymap.set("n", "<leader>cc", vim.cmd.Canonical)

--Telescope binds--
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
