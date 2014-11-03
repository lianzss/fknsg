-- Filename: DB_Tower.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Tower", package.seeall)

keys = {
	"id", "times", "loseTime", "wipeCd", "loseTimeBaseGold", "loseTimeGrowGold", "loseTimeMaxGold", "attackTime", "hideLayerTime", "wipeGold", 
}

Tower = {
	id_1 = {1, 2, 2, 30, 10, 10, 50, 5, 7200, 1, },
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
	local id_data = Tower["id_" .. key_id]
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
	for k, v in pairs(Tower) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Tower"] = nil
	package.loaded["DB_Tower"] = nil
	package.loaded["db/DB_Tower"] = nil
end

