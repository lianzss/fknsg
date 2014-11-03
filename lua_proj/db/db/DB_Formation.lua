-- Filename: DB_Formation.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Formation", package.seeall)

keys = {
	"id", "openSort", "openPositionLv", "leadposition", "openNumByLv", "openFriendByLv", "openFriendCost", 
}

Formation = {
	id_1 = {1, "4,1,2,3,5,0", "1,1,1,1,1,12", 1, "1|2,5|3,12|4,16|5,22|6", "25|1,30|2,40|3,50|4,60|5,70|6,80|7", "6|1000", },
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
	local id_data = Formation["id_" .. key_id]
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
	for k, v in pairs(Formation) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Formation"] = nil
	package.loaded["DB_Formation"] = nil
	package.loaded["db/DB_Formation"] = nil
end

