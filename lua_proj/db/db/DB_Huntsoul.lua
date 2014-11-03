-- Filename: DB_Huntsoul.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Huntsoul", package.seeall)

keys = {
	"id", "icon", "nextScene", "cost", "name", "des", "soulId", 
}

Huntsoul = {
	id_1 = {1, nil, 2, 4000, "破碎龙珠", "破碎龙珠可以猎出白色品质战魂", "70001,70002,70003,70004,70005,70006,70007,70008,70009,70010,70011,70012,70013,70014,71001,71002,71003", },
	id_2 = {2, nil, 3, 8000, "驻魂龙珠", "驻魂龙珠可以猎出白色、绿色品质战魂", "70101,70102,70103,70104,70105,70106,70107,70108,70109,70110,70111,70112,70113,70114,70001,70002,70003,70004,70005,70006,70007,70008,70009,70010,70011,70012,70013,70014,71001,71002,71003", },
	id_3 = {3, nil, 4, 12000, "英魂龙珠", "英魂龙珠可以猎出白色、绿色品质战魂", "70101,70102,70103,70104,70105,70106,70107,70108,70109,70110,70111,70112,70113,70114,70001,70002,70003,70004,70005,70006,70007,70008,70009,70010,70011,70012,70013,70014", },
	id_4 = {4, nil, 5, 20000, "将魂龙珠", "将魂龙珠可以猎出绿色、蓝色品质战魂", "70201,70202,70203,70204,70205,70206,70207,70208,70209,70210,70211,70212,70213,70214,70101,70102,70103,70104,70105,70106,70107,70108,70109,70110,70111,70112,70113,70114", },
	id_5 = {5, nil, 1, 30000, "金魂龙珠", "金魂龙珠可以猎出蓝色、紫色品质战魂和经验战魂", "70301,70302,70303,70304,70305,70306,70307,70308,70309,70310,70311,70312,70313,70314,70201,70202,70203,70204,70205,70206,70207,70208,70209,70210,70211,70212,70213,70214,72001,72002,72003", },
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
	local id_data = Huntsoul["id_" .. key_id]
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
	for k, v in pairs(Huntsoul) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Huntsoul"] = nil
	package.loaded["DB_Huntsoul"] = nil
	package.loaded["db/DB_Huntsoul"] = nil
end

