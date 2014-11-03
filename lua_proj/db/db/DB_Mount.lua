-- Filename: DB_Mount.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Mount", package.seeall)

keys = {
	"id", "tmpl_name", "name", "img", "model_id", "desc", "needed_usr_lv", "attr1_id", "attr1_val", "attr2_id", "attr2_val", "attr3_id", "attr3_val", "attr4_id", "attr4_val", "attr5_id", "attr5_val", "is_open_groove", "lv_up_mount_id", 
}

Mount = {
	id_1 = {1, "坐骑1_1", nil, 1, 1, nil, 1, 1, 50, nil, nil, nil, nil, nil, nil, nil, nil, nil, 2, },
	id_2 = {2, "坐骑1_2", nil, 1, 1, nil, 2, 2, 10, nil, nil, nil, nil, nil, nil, nil, nil, nil, 3, },
	id_3 = {3, "坐骑1_3", nil, 1, 1, nil, 3, 3, 10, nil, nil, nil, nil, nil, nil, nil, nil, nil, 4, },
	id_4 = {4, "坐骑1_4", nil, 1, 1, nil, 4, 4, 10, nil, nil, nil, nil, nil, nil, nil, nil, nil, 5, },
	id_5 = {5, "坐骑1_5", nil, 1, 1, nil, 5, 5, 10, nil, nil, nil, nil, nil, nil, nil, nil, nil, 6, },
	id_6 = {6, "坐骑1_6", nil, 1, 1, nil, 6, 1, 50, nil, nil, nil, nil, nil, nil, nil, nil, nil, 7, },
	id_7 = {7, "坐骑1_7", nil, 1, 1, nil, 7, 2, 10, nil, nil, nil, nil, nil, nil, nil, nil, nil, 8, },
	id_8 = {8, "坐骑1_8", nil, 1, 1, nil, 8, 3, 10, nil, nil, nil, nil, nil, nil, nil, nil, nil, 9, },
	id_9 = {9, "坐骑1_9", nil, 1, 1, nil, 9, 4, 10, nil, nil, nil, nil, nil, nil, nil, nil, nil, 10, },
	id_10 = {10, "坐骑1_10", nil, 1, 1, nil, 10, 5, 10, nil, nil, nil, nil, nil, nil, nil, nil, 1, 11, },
	id_11 = {11, "坐骑2_1", nil, 1, 2, nil, 11, 1, 50, nil, nil, nil, nil, nil, nil, nil, nil, nil, 12, },
	id_12 = {12, "坐骑2_2", nil, 1, 2, nil, 12, 2, 10, nil, nil, nil, nil, nil, nil, nil, nil, nil, 13, },
	id_13 = {13, "坐骑2_3", nil, 1, 2, nil, 13, 3, 10, nil, nil, nil, nil, nil, nil, nil, nil, nil, 14, },
	id_14 = {14, "坐骑2_4", nil, 1, 2, nil, 14, 4, 10, nil, nil, nil, nil, nil, nil, nil, nil, nil, 15, },
	id_15 = {15, "坐骑2_5", nil, 1, 2, nil, 15, 5, 10, nil, nil, nil, nil, nil, nil, nil, nil, nil, 16, },
	id_16 = {16, "坐骑2_6", nil, 1, 2, nil, 16, 1, 50, nil, nil, nil, nil, nil, nil, nil, nil, nil, 17, },
	id_17 = {17, "坐骑2_7", nil, 1, 2, nil, 17, 2, 10, nil, nil, nil, nil, nil, nil, nil, nil, nil, 18, },
	id_18 = {18, "坐骑2_8", nil, 1, 2, nil, 18, 3, 10, nil, nil, nil, nil, nil, nil, nil, nil, nil, 19, },
	id_19 = {19, "坐骑2_9", nil, 1, 2, nil, 19, 4, 10, nil, nil, nil, nil, nil, nil, nil, nil, nil, 20, },
	id_20 = {20, "坐骑2_10", nil, 1, 2, nil, 20, 5, 10, nil, nil, nil, nil, nil, nil, nil, nil, 1, nil, },
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
	local id_data = Mount["id_" .. key_id]
	if id_data == nil then
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
	for k, v in pairs(Mount) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Mount"] = nil
	package.loaded["DB_Mount"] = nil
	package.loaded["db/DB_Mount"] = nil
end

