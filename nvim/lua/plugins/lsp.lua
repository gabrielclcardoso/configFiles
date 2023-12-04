local lsp = require('lsp-zero')

lsp.preset({
	name = 'minimal',
	set_lsp_keymaps = true,
	manage_nvim_cmp = true,
	suggest_lsp_servers = false,
})

-- List lsp servers --
lsp.ensure_installed({
	'clangd',
	'pylsp',
	'tsserver',
	'lua_ls',
})

local cmp = require('cmp')

lsp.setup_nvim_cmp({
	mapping = lsp.defaults.cmp_mappings({
		['<Tab>'] = vim.NIL,
		['<S-Tab>'] = vim.NIL,
		['<CR>'] = vim.NIL,
	})
})

vim.lsp.buf.format {
	filter = function(client) return client.name ~= "tsserver" end
}

-- Format on Write
lsp.on_attach(function(client, bufnr)
	lsp.default_keymaps({ buffer = bufnr })
end)

lsp.format_on_save({
	format_opts = {
		async = false,
		timeout_ms = 10000,
	},
	servers = {
		['clangd'] = { 'cpp', 'c' },
		['rust_analyzer'] = { 'rust' },
		['pylsp'] = { 'python' },
		['lua_ls'] = { 'lua' },
	}
})

-- (Optional) Configure lua language server for neovim
lsp.nvim_workspace()

lsp.setup()
