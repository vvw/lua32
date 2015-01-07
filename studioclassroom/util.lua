

--module ("utility", package.seeall)

-- 打印
function _G.Print(v)
	print (v)
	print ('-----')
end

-- 打印table 的key, value
function _G.Printkv(t)
	for k in pairs(t) do
		print (k, t[k])
	end
	print ('-----')
end

-- 读取文件
function _G.ReadFile(filename)
	local fr = assert(io.open(filename, "rb"))
	content = fr:read("*all")
    fr:close()
	return content
end

-- 写入文件
function _G.WriteFile(filename, content)
	local fw = assert(io.open(filename, "wb"))
	fw:write(content)
    fw:close()
end

-- 行迭代器
function _G.allrows (content)
	local pos = 1 				    -- current position in the content
	return function ()
				local s, e = string.find(content, "\r\n", pos)  -- s 是开始位置，e 是结束位置
				if (s == nil) then return nil end
				local line = string.sub(content, pos, s-1)
				pos = e + 1
				return line
		   end
end

-- 特征串在文本中出现了多少次
function _G.Count(content, txt)
	return select(2, string.gsub(content, txt, txt))
end

-- Input:
-- 			C:\rename\images\0.gif
-- Output:
-- 			0.gif
-- Example:
-- 			print (GetJustFileName('C:\\rename\\images\\0.gif'))
function _G.GetJustFileName(FullPath)
	return string.gsub(FullPath, '.+\\', '')
end



-- Input:
-- 			C:\rename\images\0.gif
-- Output:
-- 			C:\rename\images\
-- Example:
-- 			print (GetJustPath('C:\\rename\\images\\0.gif'))
function _G.GetJustPath(fullPath)
	return string.gsub(fullPath, '(.+\\).*', '%1')
end

-- 获取文件扩展名，返回nil 表示没有扩展名
function _G.extname(filename)
	local ext = string.gsub(filename, '.+%.', '')
	if (ext == '') then return nil end
	if (ext == filename) then return nil end
	return ext
end

-- 十六进制转十进制
function _G.Hex2Dec(s)
	return tonumber(s, 16)
end

-- 打印十六进制
function _G.PrintHex(filename)
	local f = assert(io.open(filename, "rb"))
	local fhex = assert(io.open("hex.txt", "wb"))
	local block = 16
	count = 0
	while true do
		local bytes = f:read(block)
		if not bytes then break end
		if count < 16 then
			for _, b in pairs{string.byte(bytes, 1, -1)} do
				io.write(string.format("%02X ", b))
			end

			io.write(string.rep(" ", block - string.len(bytes))) -- 前面的输出不足十六个的部分用空格补
			io.write(" ", string.gsub(bytes, "%c", "."), "\n")   -- 将控制字符（%c control characters）转换成点
		end

		for _, b in pairs{string.byte(bytes, 1, -1)} do
				fhex:write(string.format("%02X ", b))
			end

			fhex:write(string.rep(" ", block - string.len(bytes))) -- 前面的输出不足十六个的部分用空格补
			fhex:write(" ", string.gsub(bytes, "%c", "."), "\n")   -- 将控制字符（%c control characters）转换成点

		count = count + 1
	end
end

-- 输入gbk 字串，输出utf8 字串
function _G.utf8(gbk)
	local p = 'a.txt'
	WriteFile(p, gbk)
	os.execute('gbk2utf8 '.. p .. ' ' .. p)
	deletefilebom(p)
	local content = ReadFile(p)
	--os.execute('del ' .. p)
	return content
end

-- 输入utf8 字串，输出gbk 字串
function _G.gbk(utf8)
	local p = 'a.txt'
	WriteFile(p, utf8)
	deletefilebom(p)
	os.execute('utf82gbk '.. p .. ' ' .. p)
	local content = ReadFile(p)
	os.execute('del ' .. p)
	return content
end



