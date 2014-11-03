-- Filename: DB_Chat_interface.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Chat_interface", package.seeall)

keys = {
	"lv_require", "vip_lv_require", "cost_coin", "max_characters", "display_time", "chat_cost_goods", 
}

Chat_interface = {
	id_1 = {20, nil, nil, nil, nil, nil, },
	id_2 = {nil, nil, nil, nil, nil, nil, },
	id_3 = {20, nil, nil, nil, nil, nil, },
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
	local id_data = Chat_interface["id_" .. key_id]
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
	for k, v in pairs(Chat_interface) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Chat_interface"] = nil
	package.loaded["DB_Chat_interface"] = nil
	package.loaded["db/DB_Chat_interface"] = nil
end

