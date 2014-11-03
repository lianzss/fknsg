-- Filename: DB_Daytask_reward.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Daytask_reward", package.seeall)

keys = {
	"id", "needScore", "reward", 
}

Daytask_reward = {
	id_1 = {1, 30, "1|0|10000,7|30102|1", },
	id_2 = {2, 60, "1|0|20000,3|0|10,7|60007|5", },
	id_3 = {3, 100, "1|0|50000,7|30103|1,7|30023|1,7|72001|1", },
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
	local id_data = Daytask_reward["id_" .. key_id]
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
	for k, v in pairs(Daytask_reward) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Daytask_reward"] = nil
	package.loaded["DB_Daytask_reward"] = nil
	package.loaded["db/DB_Daytask_reward"] = nil
end

