vim.opt.syntax = "on"
vim.opt.termguicolors = true
vim.cmd.colorscheme("tokyonight-night")

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

--syntax on
--set t_co=256
--colorscheme monokai 
--hi Normal guibg=NONE ctermbg=NONE
--set number
--filetype on
--filetype indent on
--set tabstop=4
--set shiftwidth=4
