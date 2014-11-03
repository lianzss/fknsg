-- Filename: DB_Normal_sign.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Normal_sign", package.seeall)

keys = {
	"id", "login_type", "level_require", "sgin_act_begin_time", "sgin_act_end_time", "continue_login_days", "reward_num", "reward_type1", "reward_quality1", "reward_val1", "reward_desc1", "reward_type2", "reward_quality2", "reward_val2", "reward_desc2", "reward_type3", "reward_quality3", "reward_val3", "reward_desc3", "reward_type4", "reward_quality4", "reward_val4", "reward_desc4", "reward_type5", "reward_quality5", "reward_val5", "reward_desc5", 
}

Normal_sign = {
	id_1 = {1, 1, 1, 20130531000000, 21130531000000, 1, 4, 3, 5, "20", "金币", 6, 4, "60005", "免战牌", 7, 5, "60001|1", "招募令", 6, 5, "10042", "耐力丹", nil, nil, nil, nil, },
	id_2 = {2, 1, 1, 20130531000000, 21130531000000, 2, 4, 3, 5, "30", "金币", 6, 4, "60005", "免战牌", 7, 5, "60001|1", "招募令", 6, 5, "10042", "耐力丹", nil, nil, nil, nil, },
	id_3 = {3, 1, 1, 20130531000000, 21130531000000, 3, 4, 3, 5, "40", "金币", 6, 4, "60005", "免战牌", 7, 5, "60001|2", "招募令", 6, 5, "10042", "耐力丹", nil, nil, nil, nil, },
	id_4 = {4, 1, 1, 20130531000000, 21130531000000, 4, 4, 3, 5, "50", "金币", 6, 4, "60005", "免战牌", 7, 5, "60001|2", "招募令", 6, 5, "10042", "耐力丹", nil, nil, nil, nil, },
	id_5 = {5, 1, 1, 20130531000000, 21130531000000, 5, 4, 3, 5, "50", "金币", 6, 4, "60005", "免战牌", 7, 5, "60001|2", "招募令", 6, 5, "10042", "耐力丹", nil, nil, nil, nil, },
	id_6 = {6, 1, 1, 20130531000000, 21130531000000, 6, 4, 3, 5, "50", "金币", 6, 4, "60005", "免战牌", 7, 5, "60001|3", "招募令", 6, 5, "10042", "耐力丹", nil, nil, nil, nil, },
	id_7 = {7, 1, 1, 20130531000000, 21130531000000, 7, 4, 3, 5, "50", "金币", 6, 4, "60005", "免战牌", 7, 5, "60001|4", "招募令", 7, 5, "10042|2", "耐力丹", nil, nil, nil, nil, },
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
	local id_data = Normal_sign["id_" .. key_id]
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
	for k, v in pairs(Normal_sign) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Normal_sign"] = nil
	package.loaded["DB_Normal_sign"] = nil
	package.loaded["db/DB_Normal_sign"] = nil
end

