-- Filename: DB_Hefu_accumulateactive.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Hefu_accumulateactive", package.seeall)

keys = {
	"id", "des", "icon", "accumulateDay", "reward", 
}

Hefu_accumulateactive = {
	id_1 = {1, "合服1天礼包", nil, 1, "3|0|50,7|30002|5,7|30012|5", },
	id_2 = {2, "合服2天礼包", nil, 2, "3|0|50,7|60006|10", },
	id_3 = {3, "合服3天礼包", nil, 3, "3|0|50,7|60017|5", },
	id_4 = {4, "合服4天礼包", nil, 4, "3|0|100,7|60015|2", },
	id_5 = {5, "合服5天礼包", nil, 5, "3|0|100,7|60011|5", },
	id_6 = {6, "合服6天礼包", nil, 6, "3|0|100,7|30003|5,7|30013|5", },
	id_7 = {7, "合服7天礼包", nil, 7, "3|0|150,13|10046|1", },
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
	local id_data = Hefu_accumulateactive["id_" .. key_id]
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
	for k, v in pairs(Hefu_accumulateactive) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Hefu_accumulateactive"] = nil
	package.loaded["DB_Hefu_accumulateactive"] = nil
	package.loaded["db/DB_Hefu_accumulateactive"] = nil
end

