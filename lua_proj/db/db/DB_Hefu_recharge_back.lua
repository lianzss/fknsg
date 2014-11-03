-- Filename: DB_Hefu_recharge_back.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Hefu_recharge_back", package.seeall)

keys = {
	"id", "des", "expenseGold", "reward", 
}

Hefu_recharge_back = {
	id_1 = {1, nil, 60, "1|0|500000,7|50403|5,7|10042|2", },
	id_2 = {2, nil, 300, "7|501010|1,7|60007|50,7|60015|1", },
	id_3 = {3, nil, 980, "1|0|1000000,7|103401|1,7|10032|5", },
	id_4 = {4, nil, 1980, "7|102401|1,7|50403|25,7|60013|50", },
	id_5 = {5, nil, 3280, "1|0|1500000,7|30803|20,7|30003|30,7|30013|30", },
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
	local id_data = Hefu_recharge_back["id_" .. key_id]
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
	for k, v in pairs(Hefu_recharge_back) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Hefu_recharge_back"] = nil
	package.loaded["DB_Hefu_recharge_back"] = nil
	package.loaded["db/DB_Hefu_recharge_back"] = nil
end

