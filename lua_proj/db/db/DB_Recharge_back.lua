-- Filename: DB_Recharge_back.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Recharge_back", package.seeall)

keys = {
	"id", "des", "expenseGold", "reward", 
}

Recharge_back = {
	id_1 = {1, nil, 100, "1|0|10000,2|0|10000,3|0|100,4|0|100,5|0|100,7|60002|100,8|0|100,9|0|100,11|0|1000,12|0|10000,13|40001|10", },
	id_2 = {2, nil, 500, "1|0|10000,2|0|10000,3|0|100,4|0|100,5|0|100,7|60002|100,8|0|100,9|0|100,11|0|1000,12|0|10000,13|40001|10", },
	id_3 = {3, nil, 1000, "1|0|10000,2|0|10000,3|0|100,4|0|100,5|0|100,7|60002|100,8|0|100,9|0|100,11|0|1000,12|0|10000,13|40001|10", },
	id_4 = {4, nil, 2000, "1|0|10000,2|0|10000,3|0|100,4|0|100,5|0|100,7|60002|100,8|0|100,9|0|100,11|0|1000,12|0|10000,13|40001|10", },
	id_5 = {5, nil, 3000, "1|0|10000,2|0|10000,3|0|100,4|0|100,5|0|100,7|60002|100,8|0|100,9|0|100,11|0|1000,12|0|10000,13|40001|10", },
	id_6 = {6, nil, 4000, "1|0|10000,2|0|10000,3|0|100,4|0|100,5|0|100,7|60002|100,8|0|100,9|0|100,11|0|1000,12|0|10000,13|40001|10", },
	id_7 = {7, nil, 5000, "1|0|10000,2|0|10000,3|0|100,4|0|100,5|0|100,7|60002|100,8|0|100,9|0|100,11|0|1000,12|0|10000,13|40001|10", },
	id_8 = {8, nil, 6000, "1|0|10000,2|0|10000,3|0|100,4|0|100,5|0|100,7|60002|100,8|0|100,9|0|100,11|0|1000,12|0|10000,13|40001|10", },
	id_9 = {9, nil, 7000, "1|0|10000,2|0|10000,3|0|100,4|0|100,5|0|100,7|60002|100,8|0|100,9|0|100,11|0|1000,12|0|10000,13|40001|10", },
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
	local id_data = Recharge_back["id_" .. key_id]
	if id_data == nil then
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
	for k, v in pairs(Recharge_back) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Recharge_back"] = nil
	package.loaded["DB_Recharge_back"] = nil
	package.loaded["db/DB_Recharge_back"] = nil
end

