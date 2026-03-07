local function select_model()
	local avante_config = require("avante.config")

	-- Collect the names of all your defined providers
	local models = vim.tbl_keys(avante_config.providers)

	-- Use Neovim's native select (handled by Snacks)
	vim.ui.select(models, {
		prompt = "Select Avante Model:",
		format_item = function(item)
			return "󰚩  " .. item
		end,
	}, function(choice)
		if choice then
			-- Update the active provider and notify the user
			avante_config.provider = choice
			vim.notify("Avante: Switched to " .. choice, vim.log.levels.INFO)
		end
	end)
end

return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	lazy = false,
	version = false,
	build = "make",
	opts = {
		provider = "copilot-fast",
		providers = {
			["copilot-fast"] = {
				__inherited_from = "copilot",
				model = "gpt-5-mini",
			},
			["copilot-smart"] = {
				__inherited_from = "copilot",
				model = "claude-4.6-sonnet",
			},
			["copilot-complex"] = {
				__inherited_from = "copilot",
				model = "claude-4.6-opus",
			},
		},
		mappings = {
			ask = "<leader>aa",
			edit = "<leader>ae",
			refresh = "<leader>ar",
			toggle = {
				default = "<leader>at",
			},
		},
	},
	keys = {
		{ "<leader>am", select_model, desc = "Avante: Select Model" },
	},
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
		{
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
}
