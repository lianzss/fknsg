-- Filename: DB_Apple_tw.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Apple_tw", package.seeall)

keys = {
	"id", "dollar", "productId", 
}

Apple_tw = {
	id_1 = {1, 199, "696_0_1_45", },
	id_2 = {2, 499, "696_0_2_225", },
	id_3 = {3, 999, "696_0_3_450", },
	id_4 = {4, 1999, "696_0_4_900", },
	id_5 = {5, 4999, "696_0_5_2250", },
	id_6 = {6, 9999, "696_0_6_4500", },
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
	local id_data = Apple_tw["id_" .. key_id]
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
	for k, v in pairs(Apple_tw) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Apple_tw"] = nil
	package.loaded["DB_Apple_tw"] = nil
	package.loaded["db/DB_Apple_tw"] = nil
end

