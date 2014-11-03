-- Filename: DB_Item_choose.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Item_choose", package.seeall)

keys = {
	"id", "name", "info", "itemSmall", "itemBig", "quality", "sellable", "sellType", "sellNum", "maxStacking", "canDestroy", "choose_items", 
}

Item_choose = {
	id_90001 = {90001, "我是测试的礼包1", "datili.png", "datili.png", "15", 1, 0, nil, nil, 9999, 0, "1|0|1000,3|0|1000,7|410001|10,11|0|1000", },
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
	local id_data = Item_choose["id_" .. key_id]
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
	for k, v in pairs(Item_choose) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Item_choose"] = nil
	package.loaded["DB_Item_choose"] = nil
	package.loaded["db/DB_Item_choose"] = nil
end

