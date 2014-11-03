-- Filename: DB_Contest.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Contest", package.seeall)

keys = {
	"id", "winBasescore", "loseBasescore", "maxSorce", "winSorceratio", "loseSorceratio", "winExp", "loseExp", "startime", "overtime", "gameTime", "releaseTime", "cd", "scoreArr", "scoreDec", "winHonor", 
}

Contest = {
	id_1 = {1, 10, 5, 200, 500, 250, 2, 1, 080000, 230000, "1,2,3,4,5,6", "0", 10, "25,50,75,100,500", "极低积分,较低积分,一般积分,较高积分,极高积分", 2, },
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
	local id_data = Contest["id_" .. key_id]
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
	for k, v in pairs(Contest) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Contest"] = nil
	package.loaded["DB_Contest"] = nil
	package.loaded["db/DB_Contest"] = nil
end

