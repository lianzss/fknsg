-- Filename: DB_Card_activereward.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Card_activereward", package.seeall)

keys = {
	"id", "scoreLimit1", "scoreReward1", "scoreLimit2", "scoreReward2", "scoreLimit3", "scoreReward3", "scoreLimit4", "scoreReward4", "scoreLimit5", "scoreReward5", "num", "rank1", "rankingReward1", "needScore1", "rank2", "rankingReward2", "needScore2", "rank3", "rankingReward3", "needScore3", "rank4", "rankingReward4", "needScore4", "rank5", "rankingReward5", "needScore5", 
}

Card_activereward = {
	id_1 = {1, 60, "7|60002|500,10|40001|10,1|0|200000", nil, nil, nil, nil, nil, nil, nil, nil, 4, 1, "10|10011|1,10|10012|1,10|10167|1,10|10168|1", 1, 3, "10|10011|1,10|10012|1", nil, 20, "10|10011|1", nil, 50, "7|30201|1", 1, nil, nil, nil, },
	id_2 = {2, 60, "7|60002|500,10|40001|10,1|0|200000", nil, nil, nil, nil, nil, nil, nil, nil, 4, 1, "10|10021|1,10|10017|1,10|10045|1,10|10042|1", 1, 3, "10|10021|1,10|10017|1", nil, 20, "10|10021|1", nil, 50, "7|30201|1", 1, nil, nil, nil, },
	id_3 = {3, 60, "7|60002|500,10|40001|10,1|0|200000", nil, nil, nil, nil, nil, nil, nil, nil, 4, 1, "10|10011|1,10|10012|1,10|10167|1,10|10168|1", 1, 3, "10|10011|1,10|10012|1", nil, 20, "10|10011|1", nil, 50, "7|30201|1", 1, nil, nil, nil, },
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
	local id_data = Card_activereward["id_" .. key_id]
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
	for k, v in pairs(Card_activereward) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Card_activereward"] = nil
	package.loaded["DB_Card_activereward"] = nil
	package.loaded["db/DB_Card_activereward"] = nil
end

