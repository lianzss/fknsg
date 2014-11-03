-- Filename: DB_Potentiality.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Potentiality", package.seeall)

keys = {
	"id", "baprizeCost1", "baprizeCost2", "baprizeCost3", "baprizeCost4", "baprizeCost5", "attNum", "type1", "value1", "type2", "value2", "type3", "value3", "type4", "value4", "type5", "value5", "type6", "value6", "type7", "value7", "type8", "value8", "type9", "value9", "type10", "value10", "type11", "value11", "type12", "value12", "type13", "value13", "type14", "value14", "type15", "value15", "type16", "value16", "type17", "value17", "type18", "value18", "type19", "value19", "type20", "value20", 
}

Potentiality = {
	id_31 = {31, "60007|2,0,0", "60007|1,3000,0", "60007|1,0,5", nil, nil, 4, 9, 80, 29, 100, 30, 125, 1, 25, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_32 = {32, "60007|2,0,0", "60007|1,3000,0", "60007|1,0,5", nil, nil, 4, 4, 80, 29, 125, 30, 100, 1, 20, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_33 = {33, "60007|2,0,0", "60007|1,3000,0", "60007|1,0,5", nil, nil, 4, 5, 80, 29, 125, 30, 100, 1, 20, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_34 = {34, "60007|2,0,0", "60007|1,3000,0", "60007|1,0,5", nil, nil, 4, 9, 100, 4, 100, 5, 125, 1, 16, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_41 = {41, "60007|2,0,0", "60007|1,3000,0", "60007|1,0,5", nil, nil, 4, 9, 80, 29, 100, 30, 125, 1, 25, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_42 = {42, "60007|2,0,0", "60007|1,3000,0", "60007|1,0,5", nil, nil, 4, 4, 80, 29, 125, 30, 100, 1, 20, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_43 = {43, "60007|2,0,0", "60007|1,3000,0", "60007|1,0,5", nil, nil, 4, 5, 80, 29, 125, 30, 100, 1, 20, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_44 = {44, "60007|2,0,0", "60007|1,3000,0", "60007|1,0,5", nil, nil, 4, 9, 100, 4, 100, 5, 125, 1, 16, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_51 = {51, "60007|2,0,0", "60007|1,3000,0", "60007|1,0,5", nil, nil, 4, 9, 80, 29, 100, 30, 125, 1, 25, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_52 = {52, "60007|2,0,0", "60007|1,3000,0", "60007|1,0,5", nil, nil, 4, 4, 80, 29, 125, 30, 100, 1, 20, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_53 = {53, "60007|2,0,0", "60007|1,3000,0", "60007|1,0,5", nil, nil, 4, 5, 80, 29, 125, 30, 100, 1, 20, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_54 = {54, "60007|2,0,0", "60007|1,3000,0", "60007|1,0,5", nil, nil, 4, 9, 100, 4, 100, 5, 125, 1, 16, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_61 = {61, "60007|2,0,0", "60007|1,3000,0", "60007|1,0,5", nil, nil, 4, 9, 80, 29, 100, 30, 125, 1, 25, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_62 = {62, "60007|2,0,0", "60007|1,3000,0", "60007|1,0,5", nil, nil, 4, 4, 80, 29, 125, 30, 100, 1, 20, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_63 = {63, "60007|2,0,0", "60007|1,3000,0", "60007|1,0,5", nil, nil, 4, 5, 80, 29, 125, 30, 100, 1, 20, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_64 = {64, "60007|2,0,0", "60007|1,3000,0", "60007|1,0,5", nil, nil, 4, 9, 100, 4, 100, 5, 125, 1, 16, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
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
	local id_data = Potentiality["id_" .. key_id]
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
	for k, v in pairs(Potentiality) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Potentiality"] = nil
	package.loaded["DB_Potentiality"] = nil
	package.loaded["db/DB_Potentiality"] = nil
end

