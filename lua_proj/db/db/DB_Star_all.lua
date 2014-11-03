-- Filename: DB_Star_all.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Star_all", package.seeall)

keys = {
	"id", "attrRate", "giftGold", "giftincrease", "Likeability", "giftGoldmax", "giftRatio1", "giftRatio2", "exchangeCost", 
}

Star_all = {
	id_1 = {1, "0|1,0|5,0|9999", 5, 5, 500, 100, 5000, 5000, "4|25,5|50", },
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
	local id_data = Star_all["id_" .. key_id]
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
	for k, v in pairs(Star_all) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Star_all"] = nil
	package.loaded["DB_Star_all"] = nil
	package.loaded["db/DB_Star_all"] = nil
end

