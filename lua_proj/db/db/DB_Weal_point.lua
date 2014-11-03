-- Filename: DB_Weal_point.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Weal_point", package.seeall)

keys = {
	"id", "active_event", "gain_point", 
}

Weal_point = {
	id_1 = {1, "夺宝", 1, },
	id_2 = {2, "比武", 0, },
	id_3 = {3, "占星", 1, },
	id_4 = {4, "攻击普通副本", 1, },
	id_5 = {5, "攻击精英副本", 1, },
	id_6 = {6, "攻击活动副本", 2, },
	id_7 = {7, "攻击军团副本", 2, },
	id_8 = {8, "攻打世界boss", 1, },
	id_9 = {9, "竞技场", 1, },
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
	local id_data = Weal_point["id_" .. key_id]
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
	for k, v in pairs(Weal_point) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Weal_point"] = nil
	package.loaded["DB_Weal_point"] = nil
	package.loaded["db/DB_Weal_point"] = nil
end

