-- Filename: DB_Daytask.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Daytask", package.seeall)

keys = {
	"id", "name", "icon", "taskDes", "needNum", "score", "type", "sortId", "quality", 
}

Daytask = {
	id_1 = {1, "副本", "1", "成功挑战据点20次", 20, 20, 1, 2, 5, },
	id_2 = {2, "精英副本", "2", "成功挑战精英副本2次", 2, 10, 2, 1, 5, },
	id_3 = {3, "活动副本", "3", "成功挑战活动副本2次", 2, 10, 3, 5, 5, },
	id_4 = {4, "占星", "4", "进行2次占星", 2, 5, 4, 6, 4, },
	id_5 = {5, "战魂", "5", "进行2次猎魂", 2, 5, 5, 7, 4, },
	id_6 = {6, "夺宝", "6", "进行3次夺宝", 3, 10, 6, 3, 5, },
	id_7 = {7, "竞技场", "7", "进行3次竞技场", 3, 10, 7, 4, 5, },
	id_8 = {8, "试练塔", "8", "进行2次挑战", 2, 10, 8, 9, 5, },
	id_9 = {9, "进击的魔神", "9", "攻击青龙魔神1次", 1, 10, 9, 10, 5, },
	id_10 = {10, "送耐力", "10", "给20个好友赠送耐力", 20, 5, 10, 11, 4, },
	id_11 = {11, "好感礼物", "11", "给任意名将进行3次送礼", 3, 5, 11, 12, 4, },
	id_12 = {12, "装备洗练", "12", "进行5次洗练", 5, 10, 12, 8, 5, },
	id_13 = {13, "拜关公", "13", "进行1次拜关公", 1, 3, 13, 13, 4, },
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
	local id_data = Daytask["id_" .. key_id]
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
	for k, v in pairs(Daytask) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Daytask"] = nil
	package.loaded["DB_Daytask"] = nil
	package.loaded["db/DB_Daytask"] = nil
end

