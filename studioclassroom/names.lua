-- ��ȡ��ǰĿ¼����Ŀ¼�µ������ļ�����������a.txt �ļ���
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

-- ������һ���ض����ļ���
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


-- ɾ�������ض��ļ���
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
