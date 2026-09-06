vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

vim.o.colorcolumn = "80"

vim.o.scrolloff = 8

vim.cmd([[
  autocmd FileType json setlocal tabstop=2
  autocmd FileType json setlocal shiftwidth=2
]])
