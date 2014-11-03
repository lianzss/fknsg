-- Filename: DB_Legion_copy.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Legion_copy", package.seeall)

keys = {
	"id", "expId", "levelRatio", "teamCopy", "limitNum", "max_atk_num", "helpNum", "begin_talk", "win_talk", "sameLogionAddSilver", 
}

Legion_copy = {
	id_1 = {1, 2004, 100, "1|400102,3|400103,5|400104,7|400105,8|400106,9|400107,10|400108,11|400109,12|400110,13|400111,14|400112,15|400113,16|400114,17|400115,18|400116,19|400117,20|400118,20|400119,20|400120,20|400121,20|400122,20|400123", 2, 15, 3, "还不都给我往\n前冲！|杀呀！杀呀！\n杀的他们片甲\n不留！|快点打完，我\n还得回去喝酒\n呢！|一记左钩拳右\n钩拳惹毛我的\n人有危险！|第一个飞的人\n会是谁呢？|建队虽易，开\n战不易，且打\n且珍惜！", "切，太慢了！|你已经死了！|就是这个feel\n倍儿爽！,来一个我杀一\n个，来两个我杀\n一双！,他有三英战吕\n布，我有一将\n战三英！,连胜下场！掌\n声在哪里！", 5000, },
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
	local id_data = Legion_copy["id_" .. key_id]
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
	for k, v in pairs(Legion_copy) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Legion_copy"] = nil
	package.loaded["DB_Legion_copy"] = nil
	package.loaded["db/DB_Legion_copy"] = nil
end

