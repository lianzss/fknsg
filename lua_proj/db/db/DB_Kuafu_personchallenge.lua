-- Filename: DB_Kuafu_personchallenge.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Kuafu_personchallenge", package.seeall)

keys = {
	"id", "level", "loseTime", "lastTimeArr", "applyTime", "championLastTime", "num", "massElectionGapTime", "kuafu_SroundGapTime", "cd", "refreshFightCdCost", "inScoreRewardId", "outScoreRewardId", "cheerCost", "cheerReward", "allServeGift", "wishReward", "wishCost", "rewardPreviewIn", "rewardPreviewOut", 
}

Kuafu_personchallenge = {
	id_1 = {1, 65, "3,3", "0|43200,1|43200,2|46800,2|65400,2|73800,3|65400,3|73800,4|43200,5|46800,5|65400,5|73800,6|65400,6|73800", 79200, 6000, 1, 600, 1200, "300,300,300,300,300,300,300,300,300,300,300,300", 50, "11|12|13|14|15|16,21|22|23|24|25|26", "1001|1002|1003|1004|1005|1006,2001|2002|2003|2004|2005|2006", "1|250,1|500", "31,3001", 10001, "20001,20002,20003", "3|0|10,3|0|40,3|0|100", "11|12|13|14|15|16|31,21|22|23|24|25|26|31", "1001|1002|1003|1004|1005|1006|3001|10001,2001|2002|2003|2004|2005|2006|3001", },
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
	local id_data = Kuafu_personchallenge["id_" .. key_id]
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
	for k, v in pairs(Kuafu_personchallenge) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Kuafu_personchallenge"] = nil
	package.loaded["DB_Kuafu_personchallenge"] = nil
	package.loaded["db/DB_Kuafu_personchallenge"] = nil
end

