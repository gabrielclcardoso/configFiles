vim.cmd([[ let extension = expand('%:e') ]])

function	get_extension(var)
	return vim.api.nvim_get_var(var)
end

local ext = get_extension("extension")

print("File extension = <" .. ext .. ">")
