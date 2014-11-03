-- Filename: DB_Announcement.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Announcement", package.seeall)

keys = {
	"id", "type", "pictureid", "picturelocation", "title", "content", 
}

Announcement = {
	id_1 = {1, 1, nil, nil, "游戏测试1", "游戏公告游戏公告游戏公告游戏公告游戏公告", },
	id_2 = {2, 1, nil, nil, "游戏测试2", "游戏公告游戏公告游戏公告游戏公告游戏公告222", },
	id_3 = {3, 1, nil, nil, "游戏测试3", "游戏公告游戏公告游戏公告游戏公告游戏公告", },
	id_4 = {4, 1, nil, nil, "游戏测试4", "游戏公告游戏公告游戏公告游戏公告游戏公告222", },
}

local mt = {}
mt.__index = function (table, key)
	for i = 1, #keys do
		if (keys[i] == key) then
			return table[i]
		end
	end
end

function getDataById(key_id)
	local id_data = Announcement["id_" .. key_id]
	if id_data == nil then
		print("don't find data by id " .. key_id)
		return nil
	end
	if getmetatable(id_data) ~= nil then
		return id_data
	end
	setmetatable(id_data, mt)

	return id_data
end

function getArrDataByField(fieldName, fieldValue)
	local arrData = {}
	local fieldNo = 1
	for i=1, #keys do
		if keys[i] == fieldName then
			fieldNo = i
			break
		end
	end
	for k, v in pairs(Announcement) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Announcement"] = nil
	package.loaded["DB_Announcement"] = nil
	package.loaded["db/DB_Announcement"] = nil
end

