-- Filename: DB_Xiaofei_leiji_kaifu.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Xiaofei_leiji_kaifu", package.seeall)

keys = {
	"id", "des", "expenseGold", "reward", 
}

Xiaofei_leiji_kaifu = {
	id_1 = {1, nil, 500, "1|0|300000,14|5010101|1,7|60002|200,7|30002|5,7|30012|5,7|30102|10", },
	id_2 = {2, nil, 1000, "1|0|400000,14|5010101|1,7|30003|6,7|30013|6,7|60006|5,7|30102|10", },
	id_3 = {3, nil, 2000, "1|0|500000,14|5010101|1,7|60007|50,7|60002|400,7|60006|10,7|30102|15,13|40001|15", },
	id_4 = {4, nil, 5000, "1|0|600000,7|30201|1,7|501010|1,7|30003|12,7|30013|12,7|60006|20,7|30102|15", },
	id_5 = {5, nil, 10000, "1|0|700000,7|30401|1,7|501010|1,7|60007|100,7|60002|800,7|60006|30,7|30102|20,13|40001|30", },
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
	local id_data = Xiaofei_leiji_kaifu["id_" .. key_id]
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
	for k, v in pairs(Xiaofei_leiji_kaifu) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Xiaofei_leiji_kaifu"] = nil
	package.loaded["DB_Xiaofei_leiji_kaifu"] = nil
	package.loaded["db/DB_Xiaofei_leiji_kaifu"] = nil
end

