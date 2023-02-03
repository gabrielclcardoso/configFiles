vim9script

def InsertCanonicalClass(name: string)
	var classText: string
	classText = "class " .. name .. " {\n" ..
				\ "private:\n" ..
				\ "public:\n" ..
				\ name .. "(void);\n" ..
				\ "~" .. name .. "(void);\n" ..
				\ name .. "(const " .. name .. "& src);\n\n" ..
				\ name .. "& operator=(const " .. name .. "& src);\n" ..
				\ "};"	
	execute "normal! i" .. classText
enddef

command! -nargs=1 Canonical call InsertCanonicalClass(<f-args>)
