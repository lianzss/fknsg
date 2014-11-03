-- Filename: DB_Explore_long_shop.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Explore_long_shop", package.seeall)

keys = {
	"id", "items", "costPrestige", "sortType", "limitType", "baseNum", "isSold", "needLevel", 
}

Explore_long_shop = {
	id_1 = {1, "1|60201|1", 20, 2, 1, 99, 1, 60, },
	id_2 = {2, "1|60202|1", 20, 3, 1, 99, 1, 60, },
	id_3 = {3, "1|60203|1", 20, 4, 1, 99, 1, 60, },
	id_4 = {4, "1|60204|1", 20, 5, 1, 99, 1, 60, },
	id_5 = {5, "1|60205|1", 20, 6, 1, 99, 1, 60, },
	id_6 = {6, "1|60301|1", 100, 11, 1, 999, 1, 60, },
	id_7 = {7, "1|60302|1", 100, 12, 1, 999, 1, 60, },
	id_8 = {8, "1|60303|1", 100, 13, 1, 999, 1, 60, },
	id_9 = {9, "1|60311|1", 100, 14, 1, 999, 1, 60, },
	id_10 = {10, "1|60312|1", 100, 15, 1, 999, 1, 60, },
	id_11 = {11, "1|60313|1", 100, 16, 1, 999, 1, 60, },
	id_12 = {12, "1|102451|1", 20000, 1, 2, 1, 1, 60, },
	id_13 = {13, "2|10200|1", 6000, 21, 1, 1, 1, 60, },
	id_14 = {14, "2|10205|1", 6000, 22, 1, 1, 1, 60, },
	id_15 = {15, "2|10192|1", 6000, 23, 1, 1, 1, 60, },
	id_16 = {16, "2|10197|1", 6000, 24, 1, 1, 1, 60, },
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
	local id_data = Explore_long_shop["id_" .. key_id]
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
	for k, v in pairs(Explore_long_shop) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Explore_long_shop"] = nil
	package.loaded["DB_Explore_long_shop"] = nil
	package.loaded["db/DB_Explore_long_shop"] = nil
end

