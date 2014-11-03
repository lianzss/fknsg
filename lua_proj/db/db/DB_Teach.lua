-- Filename: DB_Teach.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Teach", package.seeall)

keys = {
	"id", "drawNum", "challengeNum", "buyDrawNum", "buyChallengeNum", "draw", "refreshCardCost", "challengeFeel", "maxGold", 
}

Teach = {
	id_1 = {1, 10, 5, "20|20|100", "10|10|50", "1|万世师表|1000|5000|5张牌相同,2|脱胎换骨|800|7500|4张牌相同,3|学无止境|600|10000|3张牌相同+1对牌相同,4|天资聪颖|500|15000|3张牌相同,5|一心两用|400|20000|2对牌相同,6|一心一意|200|30000|1对牌相同,7|勤加练习|100|12500|没有相同的牌", "1|0,2|10,3|20,4|30", "1|90,2|80,3|70,4|60,5|50,6|40,7|30,8|20,9|10", 50, },
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
	local id_data = Teach["id_" .. key_id]
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
	for k, v in pairs(Teach) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Teach"] = nil
	package.loaded["DB_Teach"] = nil
	package.loaded["db/DB_Teach"] = nil
end

