-- Filename: DB_Arena_shop.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Arena_shop", package.seeall)

keys = {
	"id", "items", "costPrestige", "sortType", "limitType", "baseNum", "isSold", "needLevel", 
}

Arena_shop = {
	id_1 = {1, "1|101101|1", 1000, 1, 1, 10, 0, 0, },
	id_2 = {2, "2|10001|1", 2000, 8, 1, 5, 0, 0, },
	id_3 = {3, "1|101101|1", 3000, 7, 2, 5, 0, 0, },
	id_4 = {4, "2|10001|1", 4000, 6, 2, 5, 0, 0, },
	id_5 = {5, "1|101101|1", 1000, 5, 1, 10, 0, 0, },
	id_6 = {6, "2|10001|1", 2000, 4, 1, 5, 0, 0, },
	id_7 = {7, "1|101101|1", 3000, 3, 2, 5, 0, 0, },
	id_8 = {8, "2|10001|1", 4000, 2, 2, 5, 0, 0, },
	id_9 = {9, "1|40043|1", 100, 91, 1, 99, 1, 0, },
	id_10 = {10, "1|40055|1", 180, 92, 1, 99, 1, 0, },
	id_11 = {11, "1|60002|50", 500, 41, 1, 4, 1, 0, },
	id_12 = {12, "1|60002|10", 100, 42, 1, 10, 1, 0, },
	id_13 = {13, "2|10038|1", 20000, 33, 1, 1, 1, 0, },
	id_14 = {14, "1|501501|1", 45000, 11, 2, 1, 1, 0, },
	id_15 = {15, "1|502501|1", 45000, 12, 2, 1, 1, 0, },
	id_16 = {16, "1|60002|100", 1000, 43, 1, 1, 1, 0, },
	id_17 = {17, "1|60007|1", 50, 201, 1, 20, 1, 0, },
	id_18 = {18, "1|101401|1", 50000, 2, 2, 1, 1, 60, },
	id_19 = {19, "1|102401|1", 25000, 3, 2, 1, 1, 50, },
	id_20 = {20, "1|103401|1", 25000, 4, 2, 1, 1, 45, },
	id_21 = {21, "1|50305|1", 100, 101, 1, 99, 1, 40, },
	id_22 = {22, "1|103451|1", 50000, 1, 2, 1, 1, 60, },
	id_23 = {23, "2|10175|1", 50000, 21, 1, 1, 1, 0, },
	id_24 = {24, "2|10201|1", 50000, 22, 1, 1, 1, 0, },
	id_25 = {25, "2|10172|1", 50000, 23, 1, 1, 1, 0, },
	id_26 = {26, "2|10191|1", 50000, 24, 1, 1, 1, 0, },
	id_27 = {27, "2|10033|1", 20000, 34, 1, 1, 1, 0, },
	id_28 = {28, "2|10046|1", 20000, 32, 1, 1, 1, 0, },
	id_29 = {29, "2|10018|1", 50000, 31, 1, 1, 1, 0, },
	id_30 = {30, "1|30701|1", 100, 51, 1, 5, 1, 70, },
	id_31 = {31, "1|30701|5", 500, 52, 1, 1, 1, 80, },
	id_32 = {32, "1|60019|1", 25, 53, 1, 20, 1, 70, },
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
	local id_data = Arena_shop["id_" .. key_id]
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
	for k, v in pairs(Arena_shop) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Arena_shop"] = nil
	package.loaded["DB_Arena_shop"] = nil
	package.loaded["db/DB_Arena_shop"] = nil
end

