
require 'util'
require 'names'

-- 返回所有这样的文件全路径名：扩展名存在于extnames 的key 中
function paths_ext(extnames)
	allfiles()  -- 生成a.txt
	local t = {}
	local filepaths = ReadFile('a.txt')
	for filepath in allrows(filepaths) do
		--print (filepath)
		local content = ReadFile(filepath)
		local filename = GetJustFileName(filepath)
		local ext = extname(GetJustFileName(filepath))  -- 扩展名
		if (extnames[ext]~=nil) then t[#t+1] = filepath end
	end
	-- 删除临时文件
	os.execute("del names.bat")
	os.execute("del a.txt")
	return t
end

-- 返回所有这样的文件全路径名：例如，包含'.ksbao.' 字串，扩展名是java 或xml
function paths(oldnamespace)
	allfiles()  -- 生成a.txt 当前目录及子目录下的所有文件的文件名
	local t = {}
	local filepaths = ReadFile('a.txt')
	for filepath in allrows(filepaths) do
		local content = ReadFile(filepath)
		local filename = GetJustFileName(filepath)
		local s, e = string.find(content, oldnamespace)
		--print (oldnamespace)
		local ext = extname(GetJustFileName(filepath))  -- 扩展名
		if (s ~= nil and (ext == 'java' or ext == 'txt')) then t[#t+1] = filepath end
	end
	-- 删除临时文件
	os.execute("del names.bat")
	os.execute("del a.txt")
	return t
end



local extnames = {
		['mp3']='',
}


--Printkv(paths('wearing wedding'))
--Printkv(paths_ext(extnames))


