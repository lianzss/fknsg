-- Filename: DB_Challenge_reward.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Challenge_reward", package.seeall)

keys = {
	"ID", "tips", "reward", 
}

Challenge_reward = {
	id_1 = {"1", "冠军奖励", "8|0|5000,12|0|500", },
	id_2 = {"2", "亚军奖励", "8|0|4000,12|0|450", },
	id_3 = {"3", "4强奖励", "8|0|3500,12|0|400", },
	id_4 = {"4", "8强奖励", "8|0|3000,12|0|350", },
	id_5 = {"5", "16强奖励", "8|0|2500,12|0|300", },
	id_6 = {"6", "32强奖励", "8|0|2000,12|0|250", },
	id_7 = {"7", "助威奖励", "8|0|1500,12|0|200", },
	id_8 = {"8", "幸运奖", "8|0|2500,12|0|300,3|0|50", },
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
	local id_data = Challenge_reward["id_" .. key_id]
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
	for k, v in pairs(Challenge_reward) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Challenge_reward"] = nil
	package.loaded["DB_Challenge_reward"] = nil
	package.loaded["db/DB_Challenge_reward"] = nil
end

