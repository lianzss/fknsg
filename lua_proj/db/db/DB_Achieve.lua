-- Filename: DB_Achieve.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Achieve", package.seeall)

keys = {
	"id", "name", "des", "icon", "subType", "completeArray", "attrIds", "isShowDetail", "score", "belly", "itemId", "gold", "msgId", "potential", "add_max_stamina", 
}

Achieve = {
	id_10000 = {10000, "初出茅庐", "所有名将好感等级之和达到", "xin.png", 10, 1, nil, 1, nil, nil, nil, nil, nil, 2, 2, },
	id_10001 = {10001, "一马当先", "所有名将好感等级之和达到", "xin.png", 10, 25, nil, 1, nil, nil, nil, nil, nil, 2, 2, },
	id_10002 = {10002, "征战沙场", "所有名将好感等级之和达到", "xin.png", 10, 50, nil, 1, nil, nil, nil, nil, nil, 3, 2, },
	id_10003 = {10003, "百般敬仰", "所有名将好感等级之和达到", "xin.png", 10, 100, nil, 1, nil, nil, nil, nil, nil, 3, 2, },
	id_10004 = {10004, "爱的体验", "所有名将好感等级之和达到", "xin.png", 10, 150, nil, 1, nil, nil, nil, nil, nil, 3, 2, },
	id_10005 = {10005, "执子之手", "所有名将好感等级之和达到", "xin.png", 10, 200, nil, 1, nil, nil, nil, nil, nil, 4, 2, },
	id_10006 = {10006, "治国安邦", "所有名将好感等级之和达到", "xin.png", 10, 250, nil, 1, nil, nil, nil, nil, nil, 4, 2, },
	id_10007 = {10007, "三阳开泰", "所有名将好感等级之和达到", "xin.png", 10, 300, nil, 1, nil, nil, nil, nil, nil, 4, 2, },
	id_10008 = {10008, "万里扬名", "所有名将好感等级之和达到", "xin.png", 10, 400, nil, 1, nil, nil, nil, nil, nil, 4, 2, },
	id_10009 = {10009, "半壁江山", "所有名将好感等级之和达到", "xin.png", 10, 500, nil, 1, nil, nil, nil, nil, nil, 4, 2, },
	id_10010 = {10010, "六朝金粉", "所有名将好感等级之和达到", "xin.png", 10, 600, nil, 1, nil, nil, nil, nil, nil, 5, 2, },
	id_10011 = {10011, "七夕情人", "所有名将好感等级之和达到", "xin.png", 10, 700, nil, 1, nil, nil, nil, nil, nil, 5, 2, },
	id_10012 = {10012, "八仙过海", "所有名将好感等级之和达到", "xin.png", 10, 800, nil, 1, nil, nil, nil, nil, nil, 5, 2, },
	id_10013 = {10013, "九五之尊", "所有名将好感等级之和达到", "xin.png", 10, 900, nil, 1, nil, nil, nil, nil, nil, 5, 2, },
	id_10014 = {10014, "千军万马", "所有名将好感等级之和达到", "xin.png", 10, 1000, nil, 1, nil, nil, nil, nil, nil, 5, 2, },
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
	local id_data = Achieve["id_" .. key_id]
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
	for k, v in pairs(Achieve) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Achieve"] = nil
	package.loaded["DB_Achieve"] = nil
	package.loaded["db/DB_Achieve"] = nil
end

