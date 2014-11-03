-- Filename: DB_Activitycopy.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Activitycopy", package.seeall)

keys = {
	"id", "name", "desc", "image", "type", "pass_fort_open", "limit_lv", "pass_num", "attack_num", "reward_silver_coin", "reward_soul", "reward_exp", "pass_energy", "attack_energy", "fort_ids", "start_time", "end_time", "thumbnail", 
}

Activitycopy = {
	id_300001 = {300001, "摇钱树", "挑战摇钱树可以获得大量银币", "name_copy1.png", 1, nil, 20, nil, 2, 1000, 1000, 1000, nil, 0, 300001, nil, nil, "activitycopy1.png", },
	id_300002 = {300002, "经验宝物", "经验宝物副本", "name_copy3.png", 2, nil, 30, nil, 2, nil, nil, nil, nil, 0, 300002, nil, nil, "activitycopy2.png", },
	id_300004 = {300004, "经验熊猫", "挑战胜利有概率获得经验熊猫", "name_copy4.png", 3, nil, 35, nil, 2, nil, nil, nil, nil, 0, 300004, "2|100000,4|100000,6|100000,0|100000", "2|235959,4|235959,6|235959,0|235959", "activitycopy3.png", },
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
	local id_data = Activitycopy["id_" .. key_id]
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
	for k, v in pairs(Activitycopy) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Activitycopy"] = nil
	package.loaded["DB_Activitycopy"] = nil
	package.loaded["db/DB_Activitycopy"] = nil
end

