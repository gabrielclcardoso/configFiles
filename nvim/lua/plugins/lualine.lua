return {
	"nvim-lualine/lualine.nvim",
	dependencies = {"nvim-tree/nvim-web-devicons"},
	config = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status")
		lualine.setup({
		  options = {
		    icons_enabled = true,
		    theme = 'ayu_dark',
		    component_separators = { left = '', right = ''},
		    section_separators = { left = '', right = ''},
		    disabled_filetypes = {
		      statusline = {},
		      winbar = {},
		    },
		    ignore_focus = {},
		    always_divide_middle = true,
		    globalstatus = false,
		    refresh = {
		      statusline = 1000,
		      tabline = 1000,
		      winbar = 1000,
		    }
		  },
		  sections = {
		    lualine_a = {'mode'},
		    lualine_b = {
				{
					lazy_status.updates,
					cond = lazy_status.has_updates,
				},
			},
		    lualine_c = {'filename'},
		    lualine_x = {'fileformat', 'filetype'},
		    lualine_y = {'progress'},
		    lualine_z = {'location'}
		  },
		})
	end,
}
