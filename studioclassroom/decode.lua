-- 读取文件
function _G.ReadFile(filename)
	local fr = assert(io.open(filename, "rb"))
	local content = fr:read("*all")
    fr:close()
	return content
end

-- 写入文件
function _G.WriteFile(filename, content)
	local fw = assert(io.open(filename, "wb"))
	fw:write(content)
    fw:close()
end

local fr = assert(io.open("LT050759.mp3", "rb"))
local fw = assert(io.open("decoded.txt", "wb"))
local data = fr:read("*a")


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


function Xor80(data)
	local tmp
	for i= 1, string.len(data) do
		for _, b in pairs{string.byte(data, i, i)} do
			--print (string.format("%02X", bit32.bxor(b,0x80)))
			fw:write(string.char(bit32.bxor(b,0x80)))
		end
	end
end
Xor80(data)


