-- Filename: DB_Box_activity.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Box_activity", package.seeall)

keys = {
	"id", "limitDayNum", "activityExplain", "costNum", "firstReward", "dropId_1", "changeDropId_1", "dropShow_1", "dropId_2", "changeDropId_2", "dropShow_2", "dropId_3", "changeDropId_3", "dropShow_3", 
}

Box_activity = {
	id_1 = {1, "1,1,1", "充值达到指定金额即可获得抽奖次数", "60,300,500", "1|0|500000", "110101|10000,110102|1000,110103|1000", "10|110003", "7|60001|1,7|60002|1,7|60006|1,7|40031|1,7|40032|1,7|40033|1,7|10011|1,7|10021|1,7|10031|1,7|101401|1", "110201|1000,110202|10000,110203|1000", "105|110003", "7|60001|1,7|60002|1,7|60006|1,7|40031|1,7|40032|1,7|40033|1,7|10011|1,7|10021|1,7|10031|1,7|102401|1", "110301|1000,110302|1000,110303|10000", "105|110002", "7|60001|1,7|60002|1,7|60006|1,7|40031|1,7|40032|1,7|40033|1,7|10011|1,7|10021|1,7|10031|1,7|103401|1", },
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
	local id_data = Box_activity["id_" .. key_id]
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
	for k, v in pairs(Box_activity) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Box_activity"] = nil
	package.loaded["DB_Box_activity"] = nil
	package.loaded["db/DB_Box_activity"] = nil
end

