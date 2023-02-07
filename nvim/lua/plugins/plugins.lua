vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  use 'rstacruz/vim-closer'
  use 'tanvirtin/monokai.nvim'
  use {
  'nvim-telescope/telescope.nvim', tag = '0.1.1',
  requires = { {'nvim-lua/plenary.nvim'} }
  }
end)


