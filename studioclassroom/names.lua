-- 获取当前目录及子目录下的所有文件名，并存在a.txt 文件里
function allfiles()
	local bat = {
		"@echo off\n",
		"if exist a.txt del a.txt\n",
		[=[for /r  %%i in (*) do echo %%i>>a.txt]=]
	}
	local fw = assert(io.open("names.bat", "w"))
	for _, v in ipairs(bat) do
		fw:write(v)
	end
	fw:close()
	os.execute("names.bat")
end

-- 重命名一个特定的文件夹
function renamedir(oldnamespace, newnamespace)
	local bat = {
		"@echo off\n",
		"cd %cd%\\src\\com\\yingsoft\\\n",
		'ren '.. oldnamespace .. ' ' .. newnamespace
	}
	local fw = assert(io.open("renamedir.bat", "w"))
	for _, v in ipairs(bat) do
		fw:write(v)
	end
	fw:close()
	os.execute("renamedir.bat")
	os.execute("del renamedir.bat")
end


-- 删除两个特定文件夹
function deldir()
	local bat = {
		"@echo off\n",
		'rd /q /s bin\n',
		'rd /q /s gen\n'
	}
	local fw = assert(io.open("deldir.bat", "w"))
	for _, v in ipairs(bat) do
		fw:write(v)
	end
	fw:close()
	os.execute("deldir.bat")
	os.execute("del deldir.bat")
end
