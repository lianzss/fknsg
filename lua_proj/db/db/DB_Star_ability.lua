-- Filename: DB_Star_ability.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Star_ability", package.seeall)

keys = {
	"id", "attr", "rewardItem", "rewardSource", "add_max_stamina", 
}

Star_ability = {
	id_1101 = {1101, "9|4", nil, nil, nil, },
	id_1201 = {1201, "4|4", nil, nil, nil, },
	id_1301 = {1301, "5|4", nil, nil, nil, },
	id_1401 = {1401, "1|40", nil, nil, nil, },
	id_1102 = {1102, "9|8", nil, nil, nil, },
	id_1202 = {1202, "4|8", nil, nil, nil, },
	id_1302 = {1302, "5|8", nil, nil, nil, },
	id_1402 = {1402, "1|80", nil, nil, nil, },
	id_1103 = {1103, "9|12", nil, nil, nil, },
	id_1203 = {1203, "4|12", nil, nil, nil, },
	id_1303 = {1303, "5|12", nil, nil, nil, },
	id_1403 = {1403, "1|120", nil, nil, nil, },
	id_1104 = {1104, "9|16", nil, nil, nil, },
	id_1204 = {1204, "4|16", nil, nil, nil, },
	id_1304 = {1304, "5|16", nil, nil, nil, },
	id_1404 = {1404, "1|160", nil, nil, nil, },
	id_1105 = {1105, "9|20", nil, nil, nil, },
	id_1205 = {1205, "4|20", nil, nil, nil, },
	id_1305 = {1305, "5|20", nil, nil, nil, },
	id_1405 = {1405, "1|200", nil, nil, nil, },
	id_1106 = {1106, "9|24", nil, nil, nil, },
	id_1206 = {1206, "4|24", nil, nil, nil, },
	id_1306 = {1306, "5|24", nil, nil, nil, },
	id_1406 = {1406, "1|240", nil, nil, nil, },
	id_1107 = {1107, "9|28", nil, nil, nil, },
	id_1207 = {1207, "4|28", nil, nil, nil, },
	id_1307 = {1307, "5|28", nil, nil, nil, },
	id_1407 = {1407, "1|280", nil, nil, nil, },
	id_1108 = {1108, "9|32", nil, nil, nil, },
	id_1208 = {1208, "4|32", nil, nil, nil, },
	id_1308 = {1308, "5|32", nil, nil, nil, },
	id_1408 = {1408, "1|320", nil, nil, nil, },
	id_1109 = {1109, "9|36", nil, nil, nil, },
	id_1209 = {1209, "4|36", nil, nil, nil, },
	id_1309 = {1309, "5|36", nil, nil, nil, },
	id_1409 = {1409, "1|360", nil, nil, nil, },
	id_1110 = {1110, "9|40", nil, nil, nil, },
	id_1210 = {1210, "4|40", nil, nil, nil, },
	id_1310 = {1310, "5|40", nil, nil, nil, },
	id_1410 = {1410, "1|400", nil, nil, nil, },
	id_1111 = {1111, "9|44", nil, nil, nil, },
	id_1211 = {1211, "4|44", nil, nil, nil, },
	id_1311 = {1311, "5|44", nil, nil, nil, },
	id_1411 = {1411, "1|440", nil, nil, nil, },
	id_9999 = {9999, nil, nil, nil, 1, },
	id_2101 = {2101, "9|5", nil, nil, nil, },
	id_2201 = {2201, "4|5", nil, nil, nil, },
	id_2301 = {2301, "5|5", nil, nil, nil, },
	id_2401 = {2401, "1|50", nil, nil, nil, },
	id_2102 = {2102, "9|10", nil, nil, nil, },
	id_2202 = {2202, "4|10", nil, nil, nil, },
	id_2302 = {2302, "5|10", nil, nil, nil, },
	id_2402 = {2402, "1|100", nil, nil, nil, },
	id_2103 = {2103, "9|15", nil, nil, nil, },
	id_2203 = {2203, "4|15", nil, nil, nil, },
	id_2303 = {2303, "5|15", nil, nil, nil, },
	id_2403 = {2403, "1|150", nil, nil, nil, },
	id_2104 = {2104, "9|20", nil, nil, nil, },
	id_2204 = {2204, "4|20", nil, nil, nil, },
	id_2304 = {2304, "5|20", nil, nil, nil, },
	id_2404 = {2404, "1|200", nil, nil, nil, },
	id_2105 = {2105, "9|25", nil, nil, nil, },
	id_2205 = {2205, "4|25", nil, nil, nil, },
	id_2305 = {2305, "5|25", nil, nil, nil, },
	id_2405 = {2405, "1|250", nil, nil, nil, },
	id_2106 = {2106, "9|30", nil, nil, nil, },
	id_2206 = {2206, "4|30", nil, nil, nil, },
	id_2306 = {2306, "5|30", nil, nil, nil, },
	id_2406 = {2406, "1|300", nil, nil, nil, },
	id_2107 = {2107, "9|35", nil, nil, nil, },
	id_2207 = {2207, "4|35", nil, nil, nil, },
	id_2307 = {2307, "5|35", nil, nil, nil, },
	id_2407 = {2407, "1|350", nil, nil, nil, },
	id_2108 = {2108, "9|40", nil, nil, nil, },
	id_2208 = {2208, "4|40", nil, nil, nil, },
	id_2308 = {2308, "5|40", nil, nil, nil, },
	id_2408 = {2408, "1|400", nil, nil, nil, },
	id_2109 = {2109, "9|45", nil, nil, nil, },
	id_2209 = {2209, "4|45", nil, nil, nil, },
	id_2309 = {2309, "5|45", nil, nil, nil, },
	id_2409 = {2409, "1|450", nil, nil, nil, },
	id_2110 = {2110, "9|50", nil, nil, nil, },
	id_2210 = {2210, "4|50", nil, nil, nil, },
	id_2310 = {2310, "5|50", nil, nil, nil, },
	id_2410 = {2410, "1|500", nil, nil, nil, },
	id_2112 = {2112, "9|60", nil, nil, nil, },
	id_2212 = {2212, "4|60", nil, nil, nil, },
	id_2312 = {2312, "5|60", nil, nil, nil, },
	id_2412 = {2412, "1|600", nil, nil, nil, },
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
	local id_data = Star_ability["id_" .. key_id]
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
	for k, v in pairs(Star_ability) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Star_ability"] = nil
	package.loaded["DB_Star_ability"] = nil
	package.loaded["db/DB_Star_ability"] = nil
end

