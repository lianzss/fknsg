-- Filename: DB_Ernie.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Ernie", package.seeall)

keys = {
	"id", "icon", "des", "showItems1", "showItems2", "showItems3", "showItems4", "showItems5", "GoldCost", "levelLimit", 
}

Ernie = {
	id_1 = {1, nil, nil, nil, "101101|102101", "101201|102201", "101301|102301", "101101|102401|103401|104401", 20, 30, },
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
	local id_data = Ernie["id_" .. key_id]
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
	for k, v in pairs(Ernie) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Ernie"] = nil
	package.loaded["DB_Ernie"] = nil
	package.loaded["db/DB_Ernie"] = nil
end

