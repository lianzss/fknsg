-- Filename: DB_Tavern.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Tavern", package.seeall)

keys = {
	"id", "recruit_desc", "recruit_img", "general_star_lv", "free_times", "free_time_cd", "gold_needed", "cost_item", "is_show", "base_score", "first_recruit_id", "changeTimes", "gold_nums", 
}

Tavern = {
	id_1 = {1, "可招2~4星武将", nil, 3, 0, 0, nil, "60001|1", nil, "0", nil, "199,199", nil, },
	id_2 = {2, "可招3~5星武将", nil, 4, 1, 86400, 80, nil, 0, "0", "6220,6205,6200", nil, nil, },
	id_3 = {3, "可招4~6星武将", nil, 5, 1, 172800, 280, nil, 6305, "0", "6320,6321,6300", "5,10", "10|2680", },
	id_4 = {4, "活动卡包", nil, 3, 0, 0, nil, nil, nil, "0", nil, "10,10", nil, },
	id_5 = {5, "活动卡包", nil, 3, 0, 0, nil, nil, nil, "0", nil, "10,10", nil, },
	id_6 = {6, "活动卡包", nil, 3, 0, 0, nil, nil, nil, "0", nil, "10,10", nil, },
	id_7 = {7, "活动卡包", nil, 3, 0, 0, nil, nil, nil, "0", nil, "10,10", nil, },
	id_8 = {8, "活动卡包", nil, 3, 0, 0, nil, nil, nil, "0", nil, "10,10", nil, },
	id_9 = {9, "活动卡包6", nil, 3, 0, 0, nil, nil, nil, "0", nil, "10,10", nil, },
	id_10 = {10, "活动卡包7", nil, 3, 0, 0, nil, nil, nil, "0", nil, "10,10", nil, },
	id_11 = {11, "活动卡包8", nil, 3, 0, 0, nil, nil, nil, "0", nil, "10,10", nil, },
	id_12 = {12, "活动卡包9", nil, 3, 0, 0, nil, nil, nil, "0", nil, "10,10", nil, },
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
	local id_data = Tavern["id_" .. key_id]
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
	for k, v in pairs(Tavern) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Tavern"] = nil
	package.loaded["DB_Tavern"] = nil
	package.loaded["db/DB_Tavern"] = nil
end

