-- Filename: DB_Challenge.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Challenge", package.seeall)

keys = {
	"id", "startTime", "challengeEvent", "lastTimeArr", "prizeID", "prizePoint", "cdTime", "clearCDCostGold", "joinCostBelly", "infoLen", "cheerCostBelly", "cheerPrizeID", "pointExchange", "luckyNum", "cheerLuckyPoint", "cheerLuckyPrizeID", "finalPrizePoint", "finalPrizeID", "minPrize", "maxPrize", "continueReward", "challengeCost", "effectiveChange", "reduceEffective", "champion", "Terminator", "other", "cheerMultiple", 
}

Challenge = {
	id_1 = {1, 100000, "1,1,1,1,1,1,2", "300,60,60,60,60,60,60", "6,5,4,3,2,1", "10,20,40,60,80,100", 30, 10, 100, 20, 200, 7, 10, 10, 20, 8, 50, 9, 100000, 200000, "5|10,10|20", 100, "78", "1000,2000,3000,4000,5000", "200,400,600,800,1000,1200,1400,1600,1800,2000", "200,220,240,260,280,300,320,340,360,380,400", "100,110,120,130,140,150,160,170,180,190,200", 2, },
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
	local id_data = Challenge["id_" .. key_id]
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
	for k, v in pairs(Challenge) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Challenge"] = nil
	package.loaded["DB_Challenge"] = nil
	package.loaded["db/DB_Challenge"] = nil
end

