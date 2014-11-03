-- Filename: DB_Contest_reward.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Contest_reward", package.seeall)

keys = {
	"id", "desc", "coin", "soul", "gold", "items", "honor", 
}

Contest_reward = {
	id_1 = {1, "第1名", 10000, 0, 500, nil, 1000, },
	id_2 = {2, "第2名", 9000, 0, 400, nil, 900, },
	id_3 = {3, "第3名", 8000, 0, 300, nil, 900, },
	id_4 = {4, "第4名", 7000, 0, 200, nil, 850, },
	id_5 = {5, "第5名", 6000, 0, 100, nil, 800, },
	id_6 = {6, "第6~10名", 5000, 0, 90, nil, 750, },
	id_7 = {7, "第11~20名", 4500, 0, 80, nil, 700, },
	id_8 = {8, "第21~50名", 4000, 0, 70, nil, 650, },
	id_9 = {9, "第51~100名", 3500, 0, 60, nil, 600, },
	id_10 = {10, "第101~200名", 3000, 0, 50, nil, 550, },
	id_11 = {11, "第201~300名", 2500, 0, 50, nil, 500, },
	id_12 = {12, "第301~400名", 2000, 0, 50, nil, 450, },
	id_13 = {13, "第401~500名", 1500, 0, 50, nil, 400, },
	id_14 = {14, "第501~750名", 1250, 0, nil, nil, 350, },
	id_15 = {15, "第751~1000名", 1250, 0, nil, nil, 300, },
	id_16 = {16, "第1001~2000名", 1000, 0, nil, nil, 250, },
	id_17 = {17, "第2001~3000名", 900, 0, nil, nil, 200, },
	id_18 = {18, "第3001~4000名", 800, 0, nil, nil, 150, },
	id_19 = {19, "第4001~5000名", 750, nil, nil, nil, 100, },
	id_20 = {20, "第5001名后", 500, nil, nil, nil, 50, },
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
	local id_data = Contest_reward["id_" .. key_id]
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
	for k, v in pairs(Contest_reward) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Contest_reward"] = nil
	package.loaded["DB_Contest_reward"] = nil
	package.loaded["db/DB_Contest_reward"] = nil
end

