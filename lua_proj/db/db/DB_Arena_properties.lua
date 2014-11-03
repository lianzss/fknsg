-- Filename: DB_Arena_properties.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Arena_properties", package.seeall)

keys = {
	"id", "challenge_times", "win_base_coin", "lose_base_coin", "win_base_soul", "lose_base_soul", "win_base_exp", "lose_base_exp", "costEndurance", "winPrestige", "losePrestige", 
}

Arena_properties = {
	id_1 = {1, 999, 25, 0, 0, 0, 2, 1, 2, 20, 10, },
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
	local id_data = Arena_properties["id_" .. key_id]
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
	for k, v in pairs(Arena_properties) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Arena_properties"] = nil
	package.loaded["DB_Arena_properties"] = nil
	package.loaded["db/DB_Arena_properties"] = nil
end

