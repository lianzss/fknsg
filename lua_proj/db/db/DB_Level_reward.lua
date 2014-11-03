-- Filename: DB_Level_reward.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Level_reward", package.seeall)

keys = {
	"id", "level", "reward_num", "reward_type1", "reward_quality1", "reward_values1", "reward_desc1", "reward_type2", "reward_quality2", "reward_values2", "reward_desc2", "reward_type3", "reward_quality3", "reward_values3", "reward_desc3", "reward_type4", "reward_quality4", "reward_values4", "reward_desc4", "reward_type5", "reward_quality5", "reward_values5", "reward_desc5", "reward_type6", "reward_quality6", "reward_values6", "reward_desc6", "reward_type7", "reward_quality7", "reward_values7", "reward_desc7", "reward_type8", "reward_quality8", "reward_values8", "reward_desc8", 
}

Level_reward = {
	id_1 = {1, 5, 1, 1, 3, "5000", "银币", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_2 = {2, 10, 3, 3, 5, "100", "金币", 10, 4, "40001", "经验熊猫", 1, 4, "10000", "银币", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_3 = {3, 12, 4, 3, 5, "100", "金币", 10, 4, "10066", "周仓", 6, 3, "10032", "体力丹", 1, 4, "20000", "银币", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_4 = {4, 15, 4, 3, 5, "150", "金币", 10, 4, "40001", "经验熊猫", 6, 3, "10032", "体力丹", 1, 4, "30000", "银币", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_5 = {5, 18, 4, 3, 5, "150", "金币", 10, 4, "40001", "经验熊猫", 6, 3, "10032", "体力丹", 1, 4, "40000", "银币", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_6 = {6, 20, 4, 3, 5, "150", "金币", 10, 4, "40001", "经验熊猫", 6, 3, "10032", "体力丹", 1, 4, "50000", "银币", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_7 = {7, 23, 4, 3, 5, "150", "金币", 6, 5, "501002", "经验金马", 6, 3, "10032", "体力丹", 1, 4, "60000", "银币", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_8 = {8, 25, 4, 3, 5, "150", "金币", 6, 5, "502002", "经验金书", 6, 3, "10032", "体力丹", 1, 4, "70000", "银币", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_9 = {9, 28, 4, 3, 5, "150", "金币", 6, 5, "501002", "经验金马", 6, 3, "10032", "体力丹", 1, 4, "80000", "银币", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_10 = {10, 30, 4, 3, 5, "150", "金币", 6, 5, "502002", "经验金书", 6, 3, "10032", "体力丹", 1, 4, "90000", "银币", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_11 = {11, 33, 4, 3, 5, "200", "金币", 7, 5, "501002|2", "经验金马", 6, 3, "10032", "体力丹", 1, 5, "100000", "银币", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_12 = {12, 36, 4, 3, 5, "200", "金币", 7, 5, "502002|2", "经验金书", 6, 3, "10032", "体力丹", 1, 5, "120000", "银币", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_13 = {13, 38, 4, 3, 5, "200", "金币", 7, 5, "501002|2", "经验金马", 6, 3, "10032", "体力丹", 1, 5, "140000", "银币", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_14 = {14, 40, 4, 3, 5, "200", "金币", 7, 5, "502002|2", "经验金书", 6, 3, "10032", "体力丹", 1, 5, "160000", "银币", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_15 = {15, 45, 4, 3, 5, "200", "金币", 7, 5, "30022|5", "紫色武魂包", 6, 3, "10032", "体力丹", 1, 5, "180000", "银币", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_16 = {16, 50, 4, 3, 5, "200", "金币", 7, 5, "30022|5", "紫色武魂包", 6, 3, "10032", "体力丹", 1, 5, "200000", "银币", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_17 = {17, 55, 4, 3, 5, "200", "金币", 7, 5, "30022|5", "紫色武魂包", 6, 3, "10032", "体力丹", 1, 5, "300000", "银币", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_18 = {18, 60, 4, 3, 5, "500", "金币", 7, 5, "30022|5", "紫色武魂包", 6, 3, "10032", "体力丹", 1, 5, "400000", "银币", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_19 = {19, 65, 4, 3, 5, "500", "金币", 7, 5, "60006|5", "刷新令", 6, 3, "10032", "体力丹", 1, 5, "500000", "银币", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_20 = {20, 70, 4, 3, 5, "500", "金币", 7, 5, "60006|5", "刷新令", 6, 3, "10032", "体力丹", 1, 5, "500000", "银币", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
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
	local id_data = Level_reward["id_" .. key_id]
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
	for k, v in pairs(Level_reward) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Level_reward"] = nil
	package.loaded["DB_Level_reward"] = nil
	package.loaded["db/DB_Level_reward"] = nil
end

