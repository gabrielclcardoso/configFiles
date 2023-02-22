if vim.fn.has('gui_running') == 0 and vim.o.term:find('^%(screen%|tmux%)') then
  vim.o.t_8f = '\27[38;2;%lu;%lu;%lum'
  vim.o.t_8b = '\27[48;2;%lu;%lu;%lum'
end

vim.opt.syntax = "on"
vim.opt.termguicolors = true

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.scrolloff = 8

vim.opt.hlsearch = false
vim.opt.incsearch = true
