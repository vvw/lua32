
require 'extra'
require 'big5toutf8'
require 'path'

-- 提取所有当前文件夹下的Mebook mp3字幕
function extra_lrcs()
	local mp3s = paths_ext({['mp3']='',['MP3']='',})
	for _, f in pairs(mp3s) do
		if (extra_lrc(f)) then big5toutf8(f..'.txt') end
	end
end

function del_lrcs()
	local mp3s = paths_ext({['mp3']='',['MP3']='',})
	for _, f in pairs(mp3s) do
		os.execute('del '..f..'.txt')
	end
end

--extra_lrcs()
del_lrcs()

--extra_lrc('SC050851.MP3')
