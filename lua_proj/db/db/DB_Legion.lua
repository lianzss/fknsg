-- Filename: DB_Legion.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Legion", package.seeall)

keys = {
	"id", "needLevel", "costSilver", "costGold", "cd", "baseNum", "maxNum", "maxLevel", "expId", "donate1", "donate2", "donate3", "donate4", "donate5", "viceLevelArr", "jionNumLimit", "accuseCost", 
}

Legion = {
	id_1 = {1, 20, 500000, 500, 86400, "1|20,2|21,3|21,4|22,5|22,6|23,7|23,8|24,9|24,10|25,11|25,12|26,13|26,14|27,15|27,16|28,17|28,18|29,19|29,20|30,21|30,22|30,23|30,24|30,25|30,26|30,27|30,28|30,29|30,30|30,31|30,32|30,33|30,34|30,35|30,36|30,37|30,38|30,39|30,40|30,41|30,42|30,43|30,44|30,45|30,46|30,47|30,48|30,49|30,50|30,51|30,52|30,53|30,54|30,55|30,56|30,57|30,58|30,59|30,60|30,61|30,62|30,63|30,64|30,65|30,66|30,67|30,68|30,69|30,70|30,71|30,72|30,73|30,74|30,75|30,76|30,77|30,78|30,79|30,80|30,81|30,82|30,83|30,84|30,85|30,86|30,87|30,88|30,89|30,90|30,91|30,92|30,93|30,94|30,95|30,96|30,97|30,98|30,99|30,100|30", 30, 20, 2001, "20000|0|200|200|0", "0|20|600|400|0", "0|200|1000|2000|2", "0|300|1500|3000|5", nil, "10|2,20|2,30|2,40|2,99|2", 5, 300, },
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
	local id_data = Legion["id_" .. key_id]
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
	for k, v in pairs(Legion) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Legion"] = nil
	package.loaded["DB_Legion"] = nil
	package.loaded["db/DB_Legion"] = nil
end

