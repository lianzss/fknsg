-- Filename: DB_Suit.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Suit", package.seeall)

keys = {
	"id", "name", "total_num", "max_lock", "suit_items", "lock_num1", "astAttr1", "lock_num2", "astAttr2", "lock_num3", "astAttr3", "lock_num4", "astAttr4", "lock_num5", "astAttr5", "lock_num6", "astAttr6", "lock_num7", "astAttr7", "lock_num8", "astAttr8", "lock_num9", "astAttr9", "lock_num10", "astAttr10", 
}

Suit = {
	id_21 = {21, "冰凌套装", 4, 3, "101212,102212,103212,104212", 2, "4|50,5|50", 3, "9|50,1|200", 4, "9|100,4|75,5|75,1|400", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_31 = {31, "七绝套装", 4, 3, "101312,102312,103312,104312", 2, "4|100,5|100", 3, "9|100,1|300", 4, "9|150,4|100,5|100,1|750", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_32 = {32, "龙鸣套装", 4, 3, "101322,102322,103322,104322", 2, "4|120,5|120", 3, "9|120,1|400", 4, "9|160,4|120,5|120,1|900", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_41 = {41, "金龙套装", 4, 3, "101412,102412,103412,104412", 2, "4|150,5|150", 3, "9|200,1|750", 4, "9|300,4|200,5|200,1|1500", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_42 = {42, "裂天套装", 4, 3, "101423,102423,103423,104423", 2, "4|250,5|250", 3, "9|300,1|1250", 4, "9|400,4|300,5|300,1|2500", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_45 = {45, "宝马套装", 4, 3, "101451,102451,103451,104451", 2, "4|150,5|150", 3, "9|200,1|750", 4, "9|300,4|200,5|200,1|1500", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_51 = {51, "劫炎套装", 4, 3, "101511,102511,103511,104511", 2, "4|300,5|300", 3, "9|350,1|1500", 4, "9|450,4|350,5|350,1|3000", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_52 = {52, "刑天套装", 4, 3, "101522,102522,103522,104522", 2, "4|350,5|350", 3, "9|400,1|2000", 4, "9|500,4|400,5|400,1|3500", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_53 = {53, "九仪套装", 4, 3, "101533,102533,103533,104533", 2, "4|400,5|400", 3, "9|450,1|2500", 4, "9|550,4|450,5|450,1|4000", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_54 = {54, "橙4套装", 4, 3, "101544,102544,103544,104544", 2, "4|450,5|450", 3, "9|500,1|3000", 4, "9|600,4|500,5|500,1|4500", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_55 = {55, "橙5套装", 4, 3, "101555,102555,103555,104555", 2, "4|500,5|500", 3, "9|550,1|3500", 4, "9|650,4|550,5|550,1|5000", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_56 = {56, "橙6套装", 4, 3, "101566,102566,103566,104566", 2, "4|550,5|550", 3, "9|600,1|4000", 4, "9|700,4|600,5|600,1|5500", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
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
	local id_data = Suit["id_" .. key_id]
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
	for k, v in pairs(Suit) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Suit"] = nil
	package.loaded["DB_Suit"] = nil
	package.loaded["db/DB_Suit"] = nil
end

