-- Filename: DB_Vip_card.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Vip_card", package.seeall)

keys = {
	"id", "continueTime", "limitTime", "cardExplain", "pay", "cardReward", "productId", "buyExplain", "firstReward", "getGoldRigthNow", 
}

Vip_card = {
	id_1 = {1, 30, 5, "购买月卡，每日领取返还金币", 30, "3|0|50,7|30023|1,7|30003|1,7|30013|1,7|60006|1,7|60013|1", 10, "30元月卡", "7|10032|5,7|10042|5,7|30003|5,7|30013|5,1|0|100000", "300", },
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
	local id_data = Vip_card["id_" .. key_id]
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
	for k, v in pairs(Vip_card) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Vip_card"] = nil
	package.loaded["DB_Vip_card"] = nil
	package.loaded["db/DB_Vip_card"] = nil
end

