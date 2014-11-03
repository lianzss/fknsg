-- Filename: DB_Accumulate_sign.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Accumulate_sign", package.seeall)

keys = {
	"id", "accumulate_type", "add_up_days", "reward_num", "reward_type1", "reward_quality1", "reward_value1", "reward_desc1", "reward_type2", "reward_quality2", "reward_value2", "reward_desc2", "reward_type3", "reward_quality3", "reward_value3", "reward_desc3", "reward_type4", "reward_quality4", "reward_value4", "reward_desc4", 
}

Accumulate_sign = {
	id_1 = {1, 1, 1, 3, 3, 5, "150", "金币", 7, 4, "60006|2", "刷新令", 7, 4, "60001|2", "招募令", nil, nil, nil, nil, },
	id_2 = {2, 1, 2, 3, 3, 5, "400", "金币", 6, 4, "502401", "三略", 7, 4, "60001|5", "招募令", nil, nil, nil, nil, },
	id_3 = {3, 1, 3, 2, 6, 4, "501405", "玉龙", 7, 4, "60001|2", "招募令", nil, nil, nil, nil, nil, nil, nil, nil, },
	id_4 = {4, 1, 4, 3, 6, 4, "101301", "爆流双槌", 6, 4, "30071", "蓝宝物碎片包", 7, 4, "60001|2", "招募令", nil, nil, nil, nil, },
	id_5 = {5, 1, 5, 2, 3, 5, "200", "金币", 7, 4, "60001|3", "招募令", nil, nil, nil, nil, nil, nil, nil, nil, },
	id_6 = {6, 1, 6, 2, 6, 4, "102301", "如意战甲", 7, 4, "60001|2", "招募令", nil, nil, nil, nil, nil, nil, nil, nil, },
	id_7 = {7, 1, 7, 2, 10, 5, "10018", "貂蝉", 7, 4, "60001|2", "招募令", nil, nil, nil, nil, nil, nil, nil, nil, },
	id_8 = {8, 1, 8, 2, 3, 5, "200", "金币", 7, 4, "60001|3", "招募令", nil, nil, nil, nil, nil, nil, nil, nil, },
	id_9 = {9, 1, 9, 2, 6, 4, "104301", "碧纹琥珀", 7, 4, "60001|2", "招募令", nil, nil, nil, nil, nil, nil, nil, nil, },
	id_10 = {10, 1, 10, 3, 7, 5, "30003|2", "金箱子", 7, 5, "30013|2", "金钥匙", 7, 4, "60001|2", "招募令", nil, nil, nil, nil, },
	id_11 = {11, 1, 11, 2, 3, 5, "300", "金币", 7, 4, "60001|3", "招募令", nil, nil, nil, nil, nil, nil, nil, nil, },
	id_12 = {12, 1, 12, 2, 7, 5, "60005|2", "免战牌", 7, 4, "60001|2", "招募令", nil, nil, nil, nil, nil, nil, nil, nil, },
	id_13 = {13, 1, 13, 2, 7, 4, "60006|5", "刷新令", 7, 4, "60001|2", "招募令", nil, nil, nil, nil, nil, nil, nil, nil, },
	id_14 = {14, 1, 14, 2, 3, 5, "200", "金币", 7, 4, "60001|3", "招募令", nil, nil, nil, nil, nil, nil, nil, nil, },
	id_15 = {15, 1, 15, 2, 7, 5, "60005|2", "免战牌", 7, 4, "60001|2", "招募令", nil, nil, nil, nil, nil, nil, nil, nil, },
	id_16 = {16, 1, 16, 3, 7, 5, "30003|2", "金箱子", 7, 5, "30013|2", "金钥匙", 7, 4, "60001|2", "招募令", nil, nil, nil, nil, },
	id_17 = {17, 1, 17, 2, 3, 5, "200", "金币", 7, 4, "60001|3", "招募令", nil, nil, nil, nil, nil, nil, nil, nil, },
	id_18 = {18, 1, 18, 2, 7, 4, "60006|5", "刷新令", 7, 4, "60001|2", "招募令", nil, nil, nil, nil, nil, nil, nil, nil, },
	id_19 = {19, 1, 19, 3, 7, 5, "30003|2", "金箱子", 7, 5, "30013|2", "金钥匙", 7, 4, "60001|2", "招募令", nil, nil, nil, nil, },
	id_20 = {20, 1, 20, 2, 3, 5, "300", "金币", 7, 4, "60001|3", "招募令", nil, nil, nil, nil, nil, nil, nil, nil, },
	id_21 = {21, 1, 21, 2, 7, 4, "60006|5", "刷新令", 7, 4, "60001|2", "招募令", nil, nil, nil, nil, nil, nil, nil, nil, },
	id_22 = {22, 1, 22, 3, 7, 5, "30003|2", "金箱子", 7, 5, "30013|2", "金钥匙", 7, 4, "60001|2", "招募令", nil, nil, nil, nil, },
	id_23 = {23, 1, 23, 2, 3, 5, "200", "金币", 7, 4, "60001|3", "招募令", nil, nil, nil, nil, nil, nil, nil, nil, },
	id_24 = {24, 1, 24, 2, 7, 5, "60005|2", "免战牌", 7, 4, "60001|2", "招募令", nil, nil, nil, nil, nil, nil, nil, nil, },
	id_25 = {25, 1, 25, 3, 7, 5, "30003|2", "金箱子", 7, 5, "30013|2", "金钥匙", 7, 4, "60001|2", "招募令", nil, nil, nil, nil, },
	id_26 = {26, 1, 26, 2, 3, 5, "200", "金币", 7, 4, "60001|3", "招募令", nil, nil, nil, nil, nil, nil, nil, nil, },
	id_27 = {27, 1, 27, 2, 7, 5, "60005|2", "免战牌", 7, 4, "60001|2", "招募令", nil, nil, nil, nil, nil, nil, nil, nil, },
	id_28 = {28, 1, 28, 3, 7, 5, "30003|2", "金箱子", 7, 5, "30013|2", "金钥匙", 7, 4, "60001|2", "招募令", nil, nil, nil, nil, },
	id_29 = {29, 1, 29, 2, 7, 4, "60006|5", "刷新令", 7, 4, "60001|2", "招募令", nil, nil, nil, nil, nil, nil, nil, nil, },
	id_30 = {30, 1, 30, 2, 3, 5, "300", "金币", 7, 4, "60001|3", "招募令", nil, nil, nil, nil, nil, nil, nil, nil, },
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
	local id_data = Accumulate_sign["id_" .. key_id]
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
	for k, v in pairs(Accumulate_sign) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Accumulate_sign"] = nil
	package.loaded["DB_Accumulate_sign"] = nil
	package.loaded["db/DB_Accumulate_sign"] = nil
end

