-- Filename: DB_Copy_mysticalshop.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Copy_mysticalshop", package.seeall)

keys = {
	"id", "lastTime", "cd", "baseGold", "growGold", "item", 
}

Copy_mysticalshop = {
	id_1 = {1, 7200, 86400, 100, 100, nil, },
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
	local id_data = Copy_mysticalshop["id_" .. key_id]
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
	for k, v in pairs(Copy_mysticalshop) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Copy_mysticalshop"] = nil
	package.loaded["DB_Copy_mysticalshop"] = nil
	package.loaded["db/DB_Copy_mysticalshop"] = nil
end

