
require 'util'
require 'names'

-- ���������������ļ�ȫ·��������չ��������extnames ��key ��
function paths_ext(extnames)
	allfiles()  -- ����a.txt
	local t = {}
	local filepaths = ReadFile('a.txt')
	for filepath in allrows(filepaths) do
		--print (filepath)
		local content = ReadFile(filepath)
		local filename = GetJustFileName(filepath)
		local ext = extname(GetJustFileName(filepath))  -- ��չ��
		if (extnames[ext]~=nil) then t[#t+1] = filepath end
	end
	-- ɾ����ʱ�ļ�
	os.execute("del names.bat")
	os.execute("del a.txt")
	return t
end

-- ���������������ļ�ȫ·���������磬����'.ksbao.' �ִ�����չ����java ��xml
function paths(oldnamespace)
	allfiles()  -- ����a.txt ��ǰĿ¼����Ŀ¼�µ������ļ����ļ���
	local t = {}
	local filepaths = ReadFile('a.txt')
	for filepath in allrows(filepaths) do
		local content = ReadFile(filepath)
		local filename = GetJustFileName(filepath)
		local s, e = string.find(content, oldnamespace)
		--print (oldnamespace)
		local ext = extname(GetJustFileName(filepath))  -- ��չ��
		if (s ~= nil and (ext == 'java' or ext == 'txt')) then t[#t+1] = filepath end
	end
	-- ɾ����ʱ�ļ�
	os.execute("del names.bat")
	os.execute("del a.txt")
	return t
end



local extnames = {
		['mp3']='',
}


--Printkv(paths('wearing wedding'))
--Printkv(paths_ext(extnames))


