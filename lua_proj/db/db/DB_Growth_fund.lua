-- Filename: DB_Growth_fund.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Growth_fund", package.seeall)

keys = {
	"id", "desc", "need_vip", "golds_array", "need_gold", 
}

Growth_fund = {
	id_1 = {1, "你好", 2, "25|400,30|450,35|500,40|550,45|600,50|650,55|700,60|1038", 1000, },
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
	local id_data = Growth_fund["id_" .. key_id]
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
	for k, v in pairs(Growth_fund) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Growth_fund"] = nil
	package.loaded["DB_Growth_fund"] = nil
	package.loaded["db/DB_Growth_fund"] = nil
end

