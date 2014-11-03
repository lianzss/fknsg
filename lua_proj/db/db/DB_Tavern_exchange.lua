-- Filename: DB_Tavern_exchange.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Tavern_exchange", package.seeall)

keys = {
	"id", "need_scroe", "exchange_hero_id", "country", 
}

Tavern_exchange = {
	id_1 = {1, 2500, 410006, 2, },
	id_2 = {2, 2500, 410005, 1, },
	id_3 = {3, 2500, 410014, 3, },
	id_4 = {4, 2500, 410018, 4, },
	id_5 = {5, 1000, 410025, 1, },
	id_6 = {6, 1000, 410026, 1, },
	id_7 = {7, 1000, 410027, 1, },
	id_8 = {8, 1000, 410030, 2, },
	id_9 = {9, 1000, 410029, 2, },
	id_10 = {10, 1000, 410033, 2, },
	id_11 = {11, 1000, 410035, 3, },
	id_12 = {12, 1000, 410036, 3, },
	id_13 = {13, 1000, 410037, 3, },
	id_14 = {14, 1000, 410040, 4, },
	id_15 = {15, 1000, 410044, 4, },
	id_16 = {16, 1000, 410045, 4, },
	id_17 = {17, 500, 410049, 2, },
	id_18 = {18, 500, 410050, 3, },
	id_19 = {19, 500, 410053, 4, },
	id_20 = {20, 500, 410047, 1, },
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
	local id_data = Tavern_exchange["id_" .. key_id]
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
	for k, v in pairs(Tavern_exchange) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Tavern_exchange"] = nil
	package.loaded["DB_Tavern_exchange"] = nil
	package.loaded["db/DB_Tavern_exchange"] = nil
end

