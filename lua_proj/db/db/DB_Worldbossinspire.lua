-- Filename: DB_Worldbossinspire.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Worldbossinspire", package.seeall)

keys = {
	"inspireArr", "maxLv", "inspireCd", "inspireSilver", "inspireGold", "rebirthBaseGold", "rebirthGrowGold", "cd", 
}

Worldbossinspire = {
	id_1 = {"78|500", 20, 30, 1000, 10, 10, 10, 45, },
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
	local id_data = Worldbossinspire["id_" .. key_id]
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
	for k, v in pairs(Worldbossinspire) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Worldbossinspire"] = nil
	package.loaded["DB_Worldbossinspire"] = nil
	package.loaded["db/DB_Worldbossinspire"] = nil
end

