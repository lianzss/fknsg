-- Filename: DB_Pet_cost.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Pet_cost", package.seeall)

keys = {
	"id", "feed_critRatio", "feed_critweight", "fenseExp", "lockSkillCost", "openPetFenceGold", "baseFenseNum", "openFenseNum", "openFenseBaseCost", "openFenseGrowCost", "description", 
}

Pet_cost = {
	id_1 = {1, 1000, "20000|6000,30000|3000,40000|1000", 1, "1|50,2|200,3|500", "0|0,45|200,50|300,60|500,999|600,999|800,999|1000,999|1000,999|1000,999|1000,999|1000,999|1000", 20, 5, 25, 25, "1、处于驯养状态的宠物，每隔一段时间获得一定经验，且其特殊技能可生效\n2、只有驯养中的宠物才可以进行“出战”操作，出战状态下的宠物将自身技能所增加的属性提供给上阵武将\n3、最多只能有一个宠物处于出战状态\n4、喂养可增加宠物经验，当宠物升级至一定等级时，可获得技能点\n5、技能点可用来开启普通技能格、领悟普通技能，升级普通技能", },
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
	local id_data = Pet_cost["id_" .. key_id]
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
	for k, v in pairs(Pet_cost) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Pet_cost"] = nil
	package.loaded["DB_Pet_cost"] = nil
	package.loaded["db/DB_Pet_cost"] = nil
end

