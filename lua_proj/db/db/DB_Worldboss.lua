-- Filename: DB_Worldboss.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Worldboss", package.seeall)

keys = {
	"id", "name", "model", "strongholdId", "baseLv", "minLv", "maxLv", "rewardId", "attackSilver", "attackRestige", "beginTime", "endTime", "monthBeginTime", "monthEndTime", "dayBeginTime", "dayEndTime", "ratioHerosNums", "armyId", "backGroundMusic", 
}

Worldboss = {
	id_1 = {1, "青龙魔神", nil, 300003, 1, 1, 200, 1, 0, 10, "20121223125959", "20191223125959", nil, nil, "210000", "211500", "3|10000,2|20000,1|40000", 1000005, "music12.mp3", },
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
	local id_data = Worldboss["id_" .. key_id]
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
	for k, v in pairs(Worldboss) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Worldboss"] = nil
	package.loaded["DB_Worldboss"] = nil
	package.loaded["db/DB_Worldboss"] = nil
end

