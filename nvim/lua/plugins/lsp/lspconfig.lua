return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"simrat39/rust-tools.nvim",
	},
	config = function()
		local keymap = vim.keymap

		local opts = { noremap = true, silent = true }
		local on_attach = function(client, bufnr)
			opts.buffer = bufnr
			-- set keybinds
			opts.desc = "Show LSP references"
			keymap.set("n", "gR", function() Snacks.picker.lsp_references() end, opts)

			opts.desc = "Go to declaration"
			keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

			opts.desc = "Show LSP definitions"
			keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end, opts)

			opts.desc = "Show LSP implementations"
			keymap.set("n", "gi", function() Snacks.picker.lsp_implementations() end, opts)

			opts.desc = "Show LSP type definitions"
			keymap.set("n", "gt", function() Snacks.picker.lsp_type_definitions() end, opts)

			opts.desc = "See available code actions"
			keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

			opts.desc = "Smart rename"
			keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

			opts.desc = "Show buffer diagnostics"
			keymap.set("n", "<leader>D", function() Snacks.picker.diagnostics_buffer() end, opts)

			opts.desc = "Show line diagnostics"
			keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

			opts.desc = "Go to previous diagnostic"
			keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

			opts.desc = "Go to next diagnostic"
			keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

			opts.desc = "Show documentation for what is under cursor"
			keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

			opts.desc = "Restart LSP"
			keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
		end

		local capabilities = require('blink.cmp').get_lsp_capabilities()
		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.HINT] = "󰠠 ",
					[vim.diagnostic.severity.INFO] = " ",
				},
			},
		})

		local servers = { "html", "ts_ls", "cssls", "clangd", "ruff" }
		for _, server in ipairs(servers) do
			vim.lsp.config(server, {
				capabilities = capabilities,
				on_attach = on_attach,
			})
			vim.lsp.enable(server)
		end

		vim.lsp.config("basedpyright", {
			capabilities = capabilities,
			on_attach = on_attach,
			-- on_new_config fires every time you open a new project directory
			on_new_config = function(config, workspace_dir)
				-- Look for the uv environment in the current workspace
				local venv_path = workspace_dir .. "/.venv/bin/python"

				-- If it exists, inject it into the LSP settings
				if vim.fn.filereadable(venv_path) == 1 then
					config.settings = config.settings or {}
					config.settings.python = config.settings.python or {}
					config.settings.python.pythonPath = venv_path
				end
			end,
			settings = {
				basedpyright = {
					analysis = {
						autoSearchPaths = true,
						useLibraryCodeForTypes = true,
						diagnosticMode = "workspace",
					},
				},
			},
		})
		vim.lsp.enable("basedpyright")

		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				Lua = {
					diagnostics = { globals = { "vim" } },
					workspace = {
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
					},
				},
			},
		})
		vim.lsp.enable("lua_ls")
	end
}
