

--module ("utility", package.seeall)

-- ��ӡ
function _G.Print(v)
	print (v)
	print ('-----')
end

-- ��ӡtable ��key, value
function _G.Printkv(t)
	for k in pairs(t) do
		print (k, t[k])
	end
	print ('-----')
end

-- ��ȡ�ļ�
function _G.ReadFile(filename)
	local fr = assert(io.open(filename, "rb"))
	content = fr:read("*all")
    fr:close()
	return content
end

-- д���ļ�
function _G.WriteFile(filename, content)
	local fw = assert(io.open(filename, "wb"))
	fw:write(content)
    fw:close()
end

-- �е�����
function _G.allrows (content)
	local pos = 1 				    -- current position in the content
	return function ()
				local s, e = string.find(content, "\r\n", pos)  -- s �ǿ�ʼλ�ã�e �ǽ���λ��
				if (s == nil) then return nil end
				local line = string.sub(content, pos, s-1)
				pos = e + 1
				return line
		   end
end

-- ���������ı��г����˶��ٴ�
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

-- ��ȡ�ļ���չ��������nil ��ʾû����չ��
function _G.extname(filename)
	local ext = string.gsub(filename, '.+%.', '')
	if (ext == '') then return nil end
	if (ext == filename) then return nil end
	return ext
end

-- ʮ������תʮ����
function _G.Hex2Dec(s)
	return tonumber(s, 16)
end

-- ��ӡʮ������
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

			io.write(string.rep(" ", block - string.len(bytes))) -- ǰ����������ʮ�����Ĳ����ÿո�
			io.write(" ", string.gsub(bytes, "%c", "."), "\n")   -- �������ַ���%c control characters��ת���ɵ�
		end

		for _, b in pairs{string.byte(bytes, 1, -1)} do
				fhex:write(string.format("%02X ", b))
			end

			fhex:write(string.rep(" ", block - string.len(bytes))) -- ǰ����������ʮ�����Ĳ����ÿո�
			fhex:write(" ", string.gsub(bytes, "%c", "."), "\n")   -- �������ַ���%c control characters��ת���ɵ�

		count = count + 1
	end
end

-- ����gbk �ִ������utf8 �ִ�
function _G.utf8(gbk)
	local p = 'a.txt'
	WriteFile(p, gbk)
	os.execute('gbk2utf8 '.. p .. ' ' .. p)
	deletefilebom(p)
	local content = ReadFile(p)
	--os.execute('del ' .. p)
	return content
end

-- ����utf8 �ִ������gbk �ִ�
function _G.gbk(utf8)
	local p = 'a.txt'
	WriteFile(p, utf8)
	deletefilebom(p)
	os.execute('utf82gbk '.. p .. ' ' .. p)
	local content = ReadFile(p)
	os.execute('del ' .. p)
	return content
end



