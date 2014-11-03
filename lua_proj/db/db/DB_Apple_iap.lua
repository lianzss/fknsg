-- Filename: DB_Apple_iap.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Apple_iap", package.seeall)

keys = {
	"id", "rmb", "productId", 
}

Apple_iap = {
	id_1 = {1, 6, "com.babeltime.cardSango.6rmb", },
	id_2 = {2, 30, "com.babeltime.cardSango.30rmb", },
	id_3 = {3, 50, "com.babeltime.cardSango.50rmb", },
	id_4 = {4, 98, "com.babeltime.cardSango.98rmb", },
	id_5 = {5, 198, "com.babeltime.cardSango.198rmb", },
	id_6 = {6, 328, "com.babeltime.cardSango.328rmb", },
	id_7 = {7, 488, "com.babeltime.cardSango.488rmb", },
	id_8 = {8, 518, "com.babeltime.cardSango.518rmb", },
	id_9 = {9, 648, "com.babeltime.cardSango.648rmb", },
	id_10 = {10, 30, "com.babeltime.cardSango.monthCard", },
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
	local id_data = Apple_iap["id_" .. key_id]
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
	for k, v in pairs(Apple_iap) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Apple_iap"] = nil
	package.loaded["DB_Apple_iap"] = nil
	package.loaded["db/DB_Apple_iap"] = nil
end

