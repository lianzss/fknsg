-- Filename: DB_Normal_config.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Normal_config", package.seeall)

keys = {
	"id", "fightSoulOpenLevel", "changeName", "clearFightCdCost", "resetStrongHlod", "moneyTreeAttack", "astrologyItem", "competeTimes", "helpArmyIncomeRatio", "oneHelpArmyEnhance", "lootHelpArmyCostExection", "resPlayerLv", "resAddTime", "friendsPk", "vipEffect", "resPlayerVip", "helpArmyTime", "chatChangeHead", "goldResCost", "comprehendCost", "heroDetailedAffix", "openMysical", "changeCardCost", "changeCard1", "changeCard2", "changeCard3", "changeCard4", "star6heroesPreviewCard1", "star6heroesPreviewCard2", "star6heroesPreviewCard3", "star6heroesPreviewCard4", "MysicalTowerisSkipFight", "TesttowerisSkipFight", "GeneralsbiographyisSkipFight", "activitycopyisSkipFight", "eliteisSkipFight", 
}

Normal_config = {
	id_1 = {1, "30,40,45,50,60,70,75,80", "100|60012", "10|10|100", 60014, "300001|60015", "60013|1", "20|20", 50, 10, 2, 50, "28800|10|5,28800|20|5", "20|20|5", 5, 1, 28800, 1, 50, "30|50", "1,9,2,3,4,5,29,30,84,85,86,87,88,89", "410002|410003|410004|410005|410006|410007|410008|410009|410010", "5|5|5|5|10|15|20|25,10|10|10|10|20|30|40|50", "10022|10023|10024|10025|10026|10027|10046|10047|10058|10060,10003|10004|10005", "10028|10029|10030|10031|10032|10033|10048|10049|10097|10179,10007|10010", "10034|10035|10036|10037|10038|10039|10050|10051|10070|10075,10012|10013|10015", "10040|10041|10042|10043|10044|10045|10052|10053|10083,10017|10018|10019", "60001,60003,60004,60005,60027", "60009,60006,60007,60010,60029", "60014,60012,60013,60015,60034", "60020,60017,60018,60019,60042", "5|50", "5|50", "7|60", "8|50", "8|50", },
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
	local id_data = Normal_config["id_" .. key_id]
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
	for k, v in pairs(Normal_config) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Normal_config"] = nil
	package.loaded["DB_Normal_config"] = nil
	package.loaded["db/DB_Normal_config"] = nil
end

