-- Makes .tpp files be highlighted as cpp files --
vim.api.nvim_exec([[
  augroup filetype_tpp
    autocmd!
    autocmd BufNewFile,BufRead *.tpp set filetype=cpp
  augroup END
]], false)


-- Force nvim to use 256colors when running inside tmux--
if vim.fn.has('gui_running') == 0 and vim.o.term:find('^%(screen%|tmux%)') then
  vim.o.t_8f = '\27[38;2;%lu;%lu;%lum'
  vim.o.t_8b = '\27[48;2;%lu;%lu;%lum'
end

vim.o.listchars = "tab:>-"

vim.o.syntax = "on"
vim.o.termguicolors = true

vim.o.nu = true
vim.o.relativenumber = true

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.smartindent = true

vim.o.wrap = false
vim.o.colorcolumn = "80"

vim.o.swapfile = false
vim.o.backup = false
vim.o.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.o.undofile = true

vim.o.scrolloff = 8

vim.o.hlsearch = false
vim.o.incsearch = true

vim.cmd([[
  autocmd FileType json setlocal tabstop=2
  autocmd FileType json setlocal shiftwidth=2
]])
