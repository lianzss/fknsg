-- Filename: DB_Ernie_kaifu.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Ernie_kaifu", package.seeall)

keys = {
	"id", "icon", "des", "showItems1", "showItems2", "showItems3", "showItems4", "showItems5", "GoldCost", "levelLimit", "freeDropId", "goldDropId", "changeTimes", "changeDropId", "onceDrop", 
}

Ernie_kaifu = {
	id_1 = {1, nil, nil, nil, nil, "1|10016,1|10012", "1|10021,1|10013,1|30002,1|30012,1|60009,1|60010,1|501001,1|502001,1|60002,1|40043,1|40041,1|40042,1|40043,1|40044,1|40045", "1|80003,1|60018,1|5010101,1|10022,1|10023,1|10024,1|10025,1|10014,1|10015,1|30003,1|30013,1|501002,1|502002,1|60007,1|60006,1|60005,1|60001,1|40051,1|40052,1|40053,1|40054,1|40055,1|60011,1|60013,1|60014,1|60015,1|60016", 20, 30, "40001|164000,40002|0,40003|60000,40004|120000,40005|40000,40006|40000,40007|100000,40008|80000,40009|70000,40010|75000,40011|80000,40012|5000,304|8000,40062|0,303|30000,208|30000,40022|2000,40017|20000,40018|40000,40019|20000,40020|6000,40021|10000", "40001|164000,40002|0,40003|60000,40004|120000,40005|40000,40006|40000,40007|100000,40008|161500,40009|70000,40010|75000,40011|80000,40012|5000,304|4000,40062|0,303|30000,208|30000,40022|500,40017|20000,40018|40000,40019|20000,40020|3000,40021|10000", 451, "40022|999999999,40063|1", "40022|1", },
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
	local id_data = Ernie_kaifu["id_" .. key_id]
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
	for k, v in pairs(Ernie_kaifu) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Ernie_kaifu"] = nil
	package.loaded["DB_Ernie_kaifu"] = nil
	package.loaded["db/DB_Ernie_kaifu"] = nil
end

