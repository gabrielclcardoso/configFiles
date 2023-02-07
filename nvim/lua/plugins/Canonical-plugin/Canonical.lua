vim.cmd([[ let extension = expand('%:e') ]])

function	get_extension(var)
	return vim.api.nvim_get_var(var)
end

--local ext = get_extension("extension")

function	insertCanonicalClass(opts)
	local ext = get_extension("extension")
	print("args = " .. opts.args)
	if (ext == "cpp") then
		print("source file")
	elseif (ext == "hpp") then
		print("header file")
	end
end

vim.api.nvim_create_user_command('Canonical', insertCanonicalClass, { nargs=1 })
