-- Filename: DB_Card_active.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Card_active", package.seeall)

keys = {
	"id", "icon", "des", "freeScore", "goldScore", "goldCost", "freeCd", "rewardId", "freeTimeNum", "freeTavernId", "tavernId", "showHeros", "coseTime", "first_reward_text", "second_reward_text", "third_reward_text", "fourth_reward_text", 
}

Card_active = {
	id_1 = {1, nil, nil, 10, 10, 280, 72000, 2, 150, 5, 5, "10021|10167|10168", 3600, "第1|于吉、贾诩、董卓、张角", "2-3|于吉、贾诩", "4-20|于吉", "21-50|12资质五星武将", },
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
	local id_data = Card_active["id_" .. key_id]
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
	for k, v in pairs(Card_active) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Card_active"] = nil
	package.loaded["DB_Card_active"] = nil
	package.loaded["db/DB_Card_active"] = nil
end

