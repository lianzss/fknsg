-- Filename: DB_Yingxiong_zhuanzhi.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Yingxiong_zhuanzhi", package.seeall)

keys = {
	"id", "needHeroTid", "needHeroRebirth", "needHeroLevel", "needHeroPreciouseLevel", "afterTransferTid", "costBely", "costYueLi", "costSoul", "soulType", "needPastCopyid", "successWords", "preNeedHeroid", "level", 
}

Yingxiong_zhuanzhi = {
	id_1 = {1, 10001, 0, 70, 0, 10002, 0, 10000, 100, 2, 300001, nil, "-1", nil, },
	id_2 = {2, 10002, 0, 70, 0, 10003, 0, 20000, 200, 2, 300002, nil, "-1", nil, },
	id_3 = {3, 10003, 0, 70, 0, 10004, 0, 20000, 200, 2, 300002, nil, "-1", nil, },
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
	local id_data = Yingxiong_zhuanzhi["id_" .. key_id]
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
	for k, v in pairs(Yingxiong_zhuanzhi) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Yingxiong_zhuanzhi"] = nil
	package.loaded["DB_Yingxiong_zhuanzhi"] = nil
	package.loaded["db/DB_Yingxiong_zhuanzhi"] = nil
end

