

-- 提取MeBook 文本

function fsize (file)
	local current = file:seek() 	-- get current position
	file:seek("set", 0)
	local size = file:seek("end") 	-- get file size
	file:seek("set", current) 		-- restore position
	return size
end

-- MeBook LRC字幕大概在文件末尾几K 的样子
function Seek32k(file)
	file:seek("set", fsize(file) - 2^10*32)
end

function Data(filename)
	local fr = assert(io.open(filename, "rb"))
	Seek32k(fr)
	local data = fr:read("*a")
	fr:close()
	return data
end
function extra(data)
	return (string.match(data, '<CHP=1,.->.-<EOS=.->'))
end

function Xor80(data)
	local tmp = ''
	for i= 1, string.len(data) do
		for _, b in pairs{string.byte(data, i, i)} do
			tmp = tmp .. string.char(bit32.bxor(b,0x80))
		end
	end
	return tmp
end

-- 提取MeBook 文本
function extra_lrc(filename)
	local txt = filename..'.txt'
	local fw = assert(io.open(txt, "wb"))
	local lrc = extra(Xor80(Data(filename)))
	if (lrc == nil) then print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!ERROR:not a MeBook. File: '..filename) end
	if (lrc ~= nil) then
		fw:write(lrc)
		fw:close()
		return true
	else
		--assert(lrc ~= nil)
		fw:close()
		os.execute('del '..txt)
		os.execute('del '..filename)
	end
	return false
end

--extra_lrc('LT050759.mp3')
--extra_lrc('LT050701.mp3')



