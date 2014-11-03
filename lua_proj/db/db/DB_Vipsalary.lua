-- Filename: DB_Vipsalary.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Vipsalary", package.seeall)

keys = {
	"vip", "reward", 
}

Vipsalary = {
	id_0 = {0, nil, },
	id_1 = {1, "1|0|10000", },
	id_2 = {2, "1|0|30000,7|60014|1", },
	id_3 = {3, "1|0|50000,13|40001|1,7|60014|1", },
	id_4 = {4, "1|0|80000,13|40001|1,7|60013|1,7|60014|1", },
	id_5 = {5, "1|0|100000,13|40001|2,7|60006|1,7|60013|1,7|60014|1", },
	id_6 = {6, "1|0|120000,13|40001|2,7|60006|1,7|60013|1,7|60014|2", },
	id_7 = {7, "1|0|150000,13|40001|3,7|60006|1,7|60011|1,7|60013|1,7|60014|2", },
	id_8 = {8, "1|0|200000,13|40001|3,7|60006|2,7|60011|1,7|60013|1,7|60014|2", },
	id_9 = {9, "1|0|250000,13|40001|3,7|60006|2,7|60011|1,7|60015|1,7|60013|1,7|60014|2", },
	id_10 = {10, "1|0|300000,13|40001|4,7|60006|2,7|60011|2,7|60015|1,7|60013|1,7|60014|2", },
	id_11 = {11, "1|0|350000,13|40001|4,7|60006|2,7|60011|2,7|60015|1,7|60013|1,7|60014|2", },
	id_12 = {12, "1|0|400000,13|40001|4,7|60006|2,7|60011|2,7|60015|1,7|60013|2,7|60014|2", },
	id_13 = {13, "1|0|450000,13|40001|4,7|60006|2,7|60011|2,7|60015|1,7|60013|2,7|60014|2", },
	id_14 = {14, "1|0|500000,13|40001|4,7|60006|3,7|60011|2,7|60015|1,7|60013|2,7|60014|2", },
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
	local id_data = Vipsalary["id_" .. key_id]
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
	for k, v in pairs(Vipsalary) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Vipsalary"] = nil
	package.loaded["DB_Vipsalary"] = nil
	package.loaded["db/DB_Vipsalary"] = nil
end

