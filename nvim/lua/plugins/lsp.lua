local lsp = require('lsp-zero')

lsp.preset({
  name = 'minimal',
  set_lsp_keymaps = true,
  manage_nvim_cmp = true,
  suggest_lsp_servers = false,
})

lsp.ensure_installed({
	'clangd'
})

local cmp = require('cmp')

lsp.setup_nvim_cmp({
  mapping = lsp.defaults.cmp_mappings({
    ['<Tab>'] = vim.NIL,
    ['<S-Tab>'] = vim.NIL,
    ['<CR>'] = vim.NIL,
  })
})

-- (Optional) Configure lua language server for neovim
lsp.nvim_workspace()

lsp.setup()
