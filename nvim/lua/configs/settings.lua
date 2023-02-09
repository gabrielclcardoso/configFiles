vim.cmd([[
syntax on
set number relativenumber
set nu rnu
set	tabstop=4
set	shiftwidth=4
set t_co=256
]])

require("monokai").setup { palette = require("monokai").pro }

--syntax on
--set t_co=256
--colorscheme monokai 
--hi Normal guibg=NONE ctermbg=NONE
--set number
--filetype on
--filetype indent on
--set tabstop=4
--set shiftwidth=4
