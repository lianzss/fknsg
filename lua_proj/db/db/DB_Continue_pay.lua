-- Filename: DB_Continue_pay.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Continue_pay", package.seeall)

keys = {
	"id", "openId", "payNum", "payReward", "activityExplain", 
}

Continue_pay = {
	id_1 = {1, 0, "300", "3|0|50,7|410198|1,7|30003|3", "第1天充值达到30元", },
	id_2 = {2, 1, "300", "3|0|50,7|410198|1,7|30013|6", "第2天充值达到30元", },
	id_3 = {3, 2, "300", "3|0|50,7|410198|1,7|60006|6", "第3天充值达到30元", },
	id_4 = {4, 3, "300", "3|0|50,7|410198|1,7|60011|3", "第4天充值达到30元", },
	id_5 = {5, 4, "300", "3|0|50,7|410198|1,7|60017|3", "第5天充值达到30元", },
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
	local id_data = Continue_pay["id_" .. key_id]
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
	for k, v in pairs(Continue_pay) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Continue_pay"] = nil
	package.loaded["DB_Continue_pay"] = nil
	package.loaded["db/DB_Continue_pay"] = nil
end

