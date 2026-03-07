return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	config = function()
		require("nvim-autopairs").setup({
			check_ts = true, -- Uses treesitter to check context (e.g., won't pair inside comments)
			disable_filetype = { "TelescopePrompt", "spectre_panel" },
			fast_wrap = {}, -- Enables wrapping text with brackets using Alt-e
		})
	end,
}
