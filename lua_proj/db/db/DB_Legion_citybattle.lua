-- Filename: DB_Legion_citybattle.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Legion_citybattle", package.seeall)

keys = {
	"id", "applyBeginTime", "applyEndTime", "readyTime", "fightEndTime", "finalEndTime", "rewardTime", "maxApply", "citySort", "cityDefendRatio", "maxJoinNum", "attackAffix", "defendAffix", "maxLevel", "inspireCostSilver", "inspireCostGold", "inspireCd", "defaultWin", "WinCost", "posionEarningsRatio", "hall_lv", "user_lv", 
}

Legion_citybattle = {
	id_1 = {1, "1|100000", "2|200000", 600, "3|201500,3|203000", "3|203000", "3|220000", 2, 3, 10000, 30, "78|200", "79|200", 10, 1000, 10, 30, 2, "100|1,200|1", "100,200,150", 5, 20, },
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
	local id_data = Legion_citybattle["id_" .. key_id]
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
	for k, v in pairs(Legion_citybattle) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Legion_citybattle"] = nil
	package.loaded["DB_Legion_citybattle"] = nil
	package.loaded["db/DB_Legion_citybattle"] = nil
end

