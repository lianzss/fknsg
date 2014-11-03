-- Filename: DB_Kuafu_challengereward.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Kuafu_challengereward", package.seeall)

keys = {
	"id", "des", "reward", 
}

Kuafu_challengereward = {
	id_11 = {11, "服内傲视群雄冠军", "8|0|30000,12|0|10000", },
	id_12 = {12, "服内傲视群雄亚军", "8|0|25000,12|0|9000", },
	id_13 = {13, "服内傲视群雄4强", "8|0|20000,12|0|8000", },
	id_14 = {14, "服内傲视群雄8强", "8|0|15000,12|0|7000", },
	id_15 = {15, "服内傲视群雄16强", "8|0|12000,12|0|6000", },
	id_16 = {16, "服内傲视群雄32强", "8|0|10000,12|0|5000", },
	id_21 = {21, "服内初出茅庐冠军", "8|0|12000,12|0|5000", },
	id_22 = {22, "服内初出茅庐亚军", "8|0|10000,12|0|4500", },
	id_23 = {23, "服内初出茅庐4强", "8|0|9000,12|0|4000", },
	id_24 = {24, "服内初出茅庐8强", "8|0|8500,12|0|3500", },
	id_25 = {25, "服内初出茅庐16强", "8|0|8000,12|0|3000", },
	id_26 = {26, "服内初出茅庐32强", "8|0|7500,12|0|2500", },
	id_31 = {31, "服内助威奖励", "8|0|1500,12|0|250", },
	id_1001 = {1001, "跨服傲视群雄冠军", "7|6000011|20,7|20008|12,7|30701|300,8|0|120000,12|0|20000", },
	id_1002 = {1002, "跨服傲视群雄亚军", "7|6000011|18,7|20008|10,7|30701|280,8|0|100000,12|0|18000", },
	id_1003 = {1003, "跨服傲视群雄4强", "7|6000011|16,7|20008|9,7|30701|260,8|0|90000,12|0|16000", },
	id_1004 = {1004, "跨服傲视群雄8强", "7|6000011|14,7|20008|8,7|30701|240,8|0|80000,12|0|14000", },
	id_1005 = {1005, "跨服傲视群雄16强", "7|6000011|12,7|20008|7,7|30701|220,8|0|70000,12|0|12000", },
	id_1006 = {1006, "跨服傲视群雄32强", "7|6000011|10,7|20008|6,7|30701|200,8|0|60000,12|0|10000", },
	id_2001 = {2001, "跨服初出茅庐冠军", "7|6000011|12,7|20008|8,7|30701|200,8|0|65000,12|0|12000", },
	id_2002 = {2002, "跨服初出茅庐亚军", "7|6000011|10,7|20008|6,7|30701|180,8|0|60000,12|0|10000", },
	id_2003 = {2003, "跨服初出茅庐4强", "7|6000011|8,7|20008|5,7|30701|160,8|0|50000,12|0|9000", },
	id_2004 = {2004, "跨服初出茅庐8强", "7|6000011|6,7|20008|4,7|30701|140,8|0|40000,12|0|8500", },
	id_2005 = {2005, "跨服初出茅庐16强", "7|6000011|4,7|20008|3,7|30701|120,8|0|35000,12|0|8000", },
	id_2006 = {2006, "跨服初出茅庐32强", "7|6000011|2,7|20008|2,7|30701|100,8|0|30000,12|0|7500", },
	id_3001 = {3001, "跨服助威奖励", "8|0|5000,12|0|1000", },
	id_10001 = {10001, "全服礼包奖励", "1|0|2000000,12|0|5000", },
	id_20001 = {20001, "文君酒", "12|0|100,7|60017|1", },
	id_20002 = {20002, "杜康酒", "7|30701|2,12|0|200,7|60017|2", },
	id_20003 = {20003, "清圣浊贤", "7|30701|5,12|0|300,7|60017|5", },
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
	local id_data = Kuafu_challengereward["id_" .. key_id]
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
	for k, v in pairs(Kuafu_challengereward) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Kuafu_challengereward"] = nil
	package.loaded["DB_Kuafu_challengereward"] = nil
	package.loaded["db/DB_Kuafu_challengereward"] = nil
end

