vim.cmd [[packadd packer.nvim]]

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  use 'rstacruz/vim-closer'

  use 'folke/tokyonight.nvim'

  use {
	  'nvim-treesitter/nvim-treesitter',
	  run = ':TSUpdate'
  }

  use {
	'nvim-telescope/telescope.nvim', tag = '0.1.1',
  	requires = { {'nvim-lua/plenary.nvim'} }
  }

  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional
    },
  }

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }

  use('neovim/nvim-lspconfig')
  use('jose-elias-alvarez/null-ls.nvim')
  use('MunifTanjim/prettier.nvim')

  use {
	'VonHeikemen/lsp-zero.nvim',
  	branch = 'v1.x',
  	requires = {
  	  -- LSP Support
  	  {'neovim/nvim-lspconfig'},             -- Required
  	  {'williamboman/mason.nvim'},           -- Optional
  	  {'williamboman/mason-lspconfig.nvim'}, -- Optional

  	  -- Autocompletion
  	  {'hrsh7th/nvim-cmp'},         -- Required
  	  {'hrsh7th/cmp-nvim-lsp'},     -- Required
  	  {'hrsh7th/cmp-buffer'},       -- Optional
  	  {'hrsh7th/cmp-path'},         -- Optional
  	  {'saadparwaiz1/cmp_luasnip'}, -- Optional
  	  {'hrsh7th/cmp-nvim-lua'},     -- Optional

  	  -- Snippets
  	  {'L3MON4D3/LuaSnip'},             -- Required
  	  {'rafamadriz/friendly-snippets'}, -- Optional
  	}
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
