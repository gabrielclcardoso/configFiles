function	get_extension(var)
	return vim.api.nvim_get_var(var)
end

function	insertCanonicalClass()
	vim.cmd([[ let extension = expand('%:e') ]])
	vim.cmd([[ let name = expand('%:t:r') ]])
	local	ext = get_extension("extension")
	local	name = vim.api.nvim_get_var("name")
	local	lines

	if (ext == "cpp") then
		lines = getSourceText(name)
	elseif (ext == "hpp") then
		lines = getHeaderText(name)
	else
		print("Invalid file type")
		return
	end

	local	row = unpack(vim.api.nvim_win_get_cursor(0))
	vim.api.nvim_buf_set_lines(0, -2, -1, {}, lines)
end

function	getHeaderText(name)
	local	headerGuard = string.upper(string.gsub(name, "%u", "_%1"))
	if (string.sub(headerGuard, 1, 1) == "_") then
		headerGuard = string.sub(headerGuard, 2)
	end
	local	lines = {
		"#ifndef " .. headerGuard .. "_HPP",
		"# define " .. headerGuard .. "_HPP", "",
		"class " .. name .. " {",
		"public:",
		"\t" .. name .. "(void);",
		"\t" .. name .. "(const " .. name .. "& src);",
		"\t" .. "virtual\t~" .. name .. "(void);", "",
		"\t" .. name .. "&\toperator=(const " .. name .. "& src);",
		"private:",
		"};", "",
		"#endif"
	}
	return lines
end

function	getSourceText(name)
	local	lines = {
		"#include \"" .. name .. ".hpp\"", "",
		name .. "::" .. name .. "(void) {", "}",  "",
		name .. "::" .. name .. "(const " .. name .. "& src) { *this = src; }", "",
		name .. "::~" .. name .. "(void) {", "}", "",
		name .. "&\t" .. name .. "::operator=(const " .. name .. "& src) {",
		"\tif (this != &src) {", "\t}",
		"\treturn (*this);",
		"}"
	}
	return lines
end

vim.api.nvim_create_user_command('Canonical', insertCanonicalClass, {})

