return {
	"saghen/blink.cmp",
	version = "*",
	dependencies = {
		"rafamadriz/friendly-snippets",
	},
	opts = {
		keymap = {
			["<C-k>"] = { "select_prev", "fallback" },
			["<C-j>"] = { "select_next", "fallback" },
			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },
			["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-e>"] = { "hide" },
			["<C-y>"] = { "select_and_accept" },
		},

		completion = {
			accept = {
				auto_brackets = { enabled = true },
			},
			list = {
				selection = { preselect = false, auto_insert = false },
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 250,
			},
		},

		sources = {
			default = { "lsp", "snippets", "buffer", "path" },
		},
	},
}
