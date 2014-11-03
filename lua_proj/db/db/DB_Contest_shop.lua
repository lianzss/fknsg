-- Filename: DB_Contest_shop.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Contest_shop", package.seeall)

keys = {
	"id", "items", "costHonor", "sortType", "limitType", "baseNum", "isSold", "needLevel", 
}

Contest_shop = {
	id_1 = {1, "1|104451|1", 3200, 1, 2, 1, 1, 60, },
	id_2 = {2, "1|410006|1", 100, 11, 3, 30, 1, 0, },
	id_3 = {3, "1|410183|1", 100, 12, 3, 30, 1, 0, },
	id_4 = {4, "1|410202|1", 100, 13, 3, 30, 1, 0, },
	id_5 = {5, "1|410203|1", 100, 14, 3, 30, 1, 0, },
	id_6 = {6, "1|410190|1", 40, 15, 3, 30, 1, 0, },
	id_7 = {7, "2|10006|1", 3000, 16, 3, 1, 1, 0, },
	id_8 = {8, "2|10183|1", 3000, 17, 3, 1, 1, 0, },
	id_9 = {9, "2|10202|1", 3000, 18, 3, 1, 1, 0, },
	id_10 = {10, "2|10203|1", 3000, 19, 3, 1, 1, 0, },
	id_11 = {11, "2|10190|1", 1200, 20, 3, 1, 1, 0, },
	id_12 = {12, "1|30701|1", 5, 41, 1, 5, 1, 70, },
	id_13 = {13, "1|30701|5", 25, 42, 1, 1, 1, 80, },
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
	local id_data = Contest_shop["id_" .. key_id]
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
	for k, v in pairs(Contest_shop) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Contest_shop"] = nil
	package.loaded["DB_Contest_shop"] = nil
	package.loaded["db/DB_Contest_shop"] = nil
end

