vim.g.mapleader = " "

vim.keymap.set("n", "<leader>cc", vim.cmd.Canonical)
vim.keymap.set("n", "<leader>v", vim.cmd.split)
vim.keymap.set("n", "<leader>s", vim.cmd.vsplit)
vim.keymap.set("n", "<leader>w", vim.cmd.write)

vim.keymap.set("n", "<leader>t", function()
	local list = vim.opt.list:get()
	if list then
		vim.cmd('set nolist')
	else
		vim.cmd('set list')
	end
end)

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")


--Telescope binds--
--local telescope = require('telescope.builtin')
--vim.keymap.set('n', '<leader>f', telescope.find_files, {})
--vim.keymap.set('n', '<leader>g', telescope.git_files, {})
--
----nvim-tree binds--
--local api = require('nvim-tree.api')
--
--vim.keymap.set('n', '<leader>e', api.tree.toggle, {})
