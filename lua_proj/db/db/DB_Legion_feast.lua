-- Filename: DB_Legion_feast.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Legion_feast", package.seeall)

keys = {
	"id", "expId", "levelRatio", "baseExecution", "growExecution", "baseStamina", "growStamina", "basePrestige", "growPrestige", "baseSoul", "growSoul", "baseSilver", "growSilver", "baseGold", "growGold", "beginTime", "endTime", "contributeCost", 
}

Legion_feast = {
	id_1 = {1, 2002, 100, 10, 100, 0, 0, 100, 500, 0, 0, 75000, 250000, 0, 0, "075900", "235959", 50, },
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
	local id_data = Legion_feast["id_" .. key_id]
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
	for k, v in pairs(Legion_feast) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Legion_feast"] = nil
	package.loaded["DB_Legion_feast"] = nil
	package.loaded["db/DB_Legion_feast"] = nil
end

