-- Filename: DB_Starfeelarr.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Starfeelarr", package.seeall)

keys = {
	"id", "arr", 
}

Starfeelarr = {
	id_1 = {1, "1|0", },
	id_2 = {2, "1|0", },
	id_3 = {3, "1|0", },
	id_4 = {4, "1|0", },
	id_5 = {5, "1|0", },
	id_6 = {6, "1|0", },
	id_7 = {7, "1|0", },
	id_8 = {8, "1|0", },
	id_9 = {9, "1|0", },
	id_10 = {10, "1|0", },
	id_11 = {11, "1|0", },
	id_12 = {12, "1|0", },
	id_13 = {13, "1|0", },
	id_14 = {14, "1|0", },
	id_15 = {15, "1|0", },
	id_16 = {16, "1|0", },
	id_17 = {17, "1|0", },
	id_18 = {18, "1|0", },
	id_19 = {19, "1|0", },
	id_20 = {20, "1|0", },
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
	local id_data = Starfeelarr["id_" .. key_id]
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
	for k, v in pairs(Starfeelarr) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Starfeelarr"] = nil
	package.loaded["DB_Starfeelarr"] = nil
	package.loaded["db/DB_Starfeelarr"] = nil
end

