return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		picker = {
			enabled = true,
			ui_select = true,
			win = {
				input = {
					keys = {
						["<C-j>"] = { "list_down", mode = { "i", "n" } },
						["<C-k>"] = { "list_up", mode = { "i", "n" } },
					},
				},
			},
		},
		input = {
			enabled = true
		},
		lazygit = {
			enabled = true,
			configure = true,
		},
		dashboard = {
			enabled = true,
		},
	},


	keys = {
		{ "<leader>ff", function() Snacks.picker.files() end,     desc = "Find Files" },
		{ "<leader>fr", function() Snacks.picker.recent() end,    desc = "Recent Files" },
		{ "<leader>fs", function() Snacks.picker.grep() end,      desc = "Live Grep" },
		{ "<leader>fc", function() Snacks.picker.grep_word() end, desc = "Grep Word Under Cursor" },

		{ "<leader>lg", function() Snacks.lazygit() end,          desc = "Open LazyGit" },
	},
}
