-- Filename: DB_Item_randgift.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Item_randgift", package.seeall)

keys = {
	"id", "name", "desc", "icon_small", "icon_big", "item_type", "quality", "sellable", "sell_type", "sell_num", "max_stack", "fix_type", "can_destroy", "dropID", "delayOpenTime", "use_minRoleLv", "use_maxRoleLv", "use_needItem", "use_needNum", "use_costBely", "use_costGold", 
}

Item_randgift = {
	id_30001 = {30001, "青铜宝箱", "以青铜所铸的宝箱，可获得白色、绿色装备，绿色宝物及名将好感礼物。", "tongxiangzi.png", nil, 8, 3, 1, 1, 5000, 9999, nil, 0, 11, nil, 1, 999, 30011, 1, nil, nil, },
	id_30002 = {30002, "白银宝箱", "以白银所铸的宝箱，可获得绿色、蓝色装备和宝物及名将好感礼物。", "yinxiangzi.png", nil, 8, 4, 1, 1, 10000, 9999, nil, 0, 12, nil, 1, 999, 30012, 1, nil, nil, },
	id_30003 = {30003, "黄金宝箱", "以黄金所铸的宝箱，可获得绿色，蓝色，紫色装备和宝物及名将好感礼物。", "jinxiangzi.png", nil, 8, 5, 0, 0, nil, 9999, nil, 0, 13, nil, 1, 999, 30013, 1, nil, nil, },
	id_30004 = {30004, "白金宝箱", "白金宝箱", "datili.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 11, nil, 1, 999, 30014, 1, nil, nil, },
	id_30005 = {30005, "钻石宝箱", "钻石宝箱", "datili.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 12, nil, 1, 999, 30015, 1, nil, nil, },
	id_30011 = {30011, "青铜钥匙", "铜钥匙，用于开启青铜宝箱。", "tongyaoshi.png", nil, 8, 3, 0, nil, nil, 9999, nil, 0, 11, nil, 1, 999, 30001, 1, nil, nil, },
	id_30012 = {30012, "白银钥匙", "银钥匙，用于开启白银宝箱。", "yinyaoshi.png", nil, 8, 4, 0, nil, nil, 9999, nil, 0, 12, nil, 1, 999, 30002, 1, nil, nil, },
	id_30013 = {30013, "黄金钥匙", "金钥匙，用于开启黄金宝箱。", "jinyaoshi.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 13, nil, 1, 999, 30003, 1, nil, nil, },
	id_30014 = {30014, "白金钥匙", "开启白金箱子", "datili.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 11, nil, 1, 999, 30004, 1, nil, nil, },
	id_30015 = {30015, "钻石钥匙", "开启钻石箱子", "datili.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 12, nil, 1, 999, 30005, 1, nil, nil, },
	id_30021 = {30021, "4星武魂包", "4星武魂包，使用后可获得一个4星武将武魂。", "libao3.png", nil, 8, 4, 0, nil, nil, 9999, nil, 0, 901, nil, 1, 999, nil, nil, nil, nil, },
	id_30022 = {30022, "5星武魂包", "5星武魂包，使用后可获得一个5星武将武魂。", "libao3.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 902, nil, 1, 999, nil, nil, nil, nil, },
	id_30023 = {30023, "高级武魂包", "高级武魂包，使用后可获得一个13资质武将武魂。", "libao4.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 603, nil, 1, 999, nil, nil, nil, nil, },
	id_30101 = {30101, "绿色礼物包", "装有礼物的绿色好感礼物随机礼包，使用后可获得1个绿色名将好感礼物。", "libao1.png", nil, 8, 3, 0, nil, nil, 9999, nil, 0, 502, nil, 1, 999, nil, nil, nil, nil, },
	id_30102 = {30102, "蓝色礼物包", "装有礼物的蓝色好感礼物随机礼包，使用后可获得1个蓝色名将好感礼物。", "libao2.png", nil, 8, 4, 0, nil, nil, 9999, nil, 0, 503, nil, 1, 999, nil, nil, nil, nil, },
	id_30103 = {30103, "紫色礼物包", "装有礼物的紫色好感礼物随机礼包，使用后可获得1个紫色名将好感礼物。", "libao1.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 504, nil, 1, 999, nil, nil, nil, nil, },
	id_31001 = {31001, "测试宝箱", "测试获得英雄", "tongxiangzi.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 11, nil, 1, 999, 31002, 1, nil, nil, },
	id_31002 = {31002, "测试钥匙", "测试获得英雄", "tongyaoshi.png", nil, 8, 4, 0, nil, nil, 9999, nil, 0, 12, nil, 1, 999, 31001, 1, nil, nil, },
	id_30031 = {30031, "蓝色兵书包", "蓝色兵书礼包，使用后可获得1个蓝色兵书。", "libao3.png", nil, 8, 4, 0, nil, nil, 9999, nil, 0, 331, nil, 1, 999, nil, nil, nil, nil, },
	id_30032 = {30032, "紫色兵书包", "紫色兵书礼包，使用后可获得1个紫色兵书。", "libao4.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 333, nil, 1, 999, nil, nil, nil, nil, },
	id_30041 = {30041, "蓝色战马包", "蓝色战马礼包，使用后可获得1个蓝色战马。", "libao3.png", nil, 8, 4, 0, nil, nil, 9999, nil, 0, 332, nil, 1, 999, nil, nil, nil, nil, },
	id_30042 = {30042, "紫色战马包", "紫色战马礼包，使用后可获得1个紫色战马。", "libao4.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 334, nil, 1, 999, nil, nil, nil, nil, },
	id_30051 = {30051, "蓝书碎片包", "蓝色兵书碎片礼包，使用后可获得1个蓝色兵书碎片。", "libao3.png", nil, 8, 4, 0, nil, nil, 9999, nil, 0, 322, nil, 1, 999, nil, nil, nil, nil, },
	id_30052 = {30052, "紫书碎片包", "紫色兵书碎片礼包，使用后可获得1个紫色兵书碎片。", "libao4.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 323, nil, 1, 999, nil, nil, nil, nil, },
	id_30053 = {30053, "绿书碎片包", "绿色兵书碎片礼包，使用后可获得1个绿色兵书碎片。", "libao2.png", nil, 8, 3, 0, nil, nil, 9999, nil, 0, 321, nil, 1, 999, nil, nil, nil, nil, },
	id_30061 = {30061, "蓝马碎片包", "蓝色战马碎片礼包，使用后可获得1个蓝色战马碎片。", "libao3.png", nil, 8, 4, 0, nil, nil, 9999, nil, 0, 312, nil, 1, 999, nil, nil, nil, nil, },
	id_30062 = {30062, "紫马碎片包", "紫色战马碎片礼包，使用后可获得1个紫色战马碎片。", "libao4.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 313, nil, 1, 999, nil, nil, nil, nil, },
	id_30063 = {30063, "绿马碎片包", "绿色战马碎片礼包，使用后可获得1个绿色战马碎片。", "libao2.png", nil, 8, 3, 0, nil, nil, 9999, nil, 0, 311, nil, 1, 999, nil, nil, nil, nil, },
	id_30071 = {30071, "蓝宝物碎片包", "蓝色宝物碎片包，使用后可随机获得1个蓝色碎片。", "libao3.png", nil, 8, 4, 0, nil, nil, 9999, nil, 0, 303, nil, 1, 999, nil, nil, nil, nil, },
	id_30081 = {30081, "蓝装备碎片包", "蓝色装备碎片包，使用后可随机获得1个蓝色装备碎片（可获得套装）。", "libao2.png", nil, 8, 4, 0, nil, nil, 9999, nil, 0, 208, nil, 1, 999, nil, nil, nil, nil, },
	id_30201 = {30201, "5星武将包", "获得一个12资质5星武将", "libao3.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 6105, nil, 1, 999, nil, nil, nil, nil, },
	id_30301 = {30301, "放开那红包", "放开那红包，“红”福齐天！使用后可随机获得50、100或500金币！", "jinbihongbao.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 805, nil, 1, 999, nil, nil, nil, nil, },
	id_30401 = {30401, "紫色宝物包", "紫色宝物礼包，使用后可随机获得1个紫色宝物。", "libao4.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 306, nil, 1, 999, nil, nil, nil, nil, },
	id_30501 = {30501, "神将武魂包", "神将武魂包,使用后可随机获得1个限时神将武将的武魂。", "wuhunbao.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 903, nil, 1, 999, nil, nil, nil, nil, },
	id_30601 = {30601, "5星装备碎片包", "5星装备碎片包，使用后可随机获得1个5星装备碎片。", "zhuangbeibao.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 209, nil, 1, 999, nil, nil, nil, nil, },
	id_30701 = {30701, "铸造材料包", "铸造材料包，使用后随机获得1个橙装材料（魔石、乌金、玄铁、翎羽、神玉）。", "libao4.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 10011, nil, 1, 999, nil, nil, nil, nil, },
	id_30801 = {30801, "散件橙装图纸包", "散件橙装图纸包，使用后随机获得1个散件橙装图纸。", "libao4.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 10101, nil, 1, 999, nil, nil, nil, nil, },
	id_30802 = {30802, "套装橙装图纸包", "套装橙装图纸包，使用后随机获得1个套装橙装图纸。", "libao4.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 10102, nil, 1, 999, nil, nil, nil, nil, },
	id_30803 = {30803, "橙装图纸随机包", "橙装图纸随机包，使用后随机获得1个散件橙装图纸或套装橙装图纸。", "libao4.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 10103, nil, 1, 999, nil, nil, nil, nil, },
	id_30804 = {30804, "13资质武将包", "获得一个13资质5星武将（酒馆中可抽到的武将）", "libao4.png", nil, 8, 5, 0, nil, nil, 9999, nil, 0, 10104, nil, 1, 999, nil, nil, nil, nil, },
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
	local id_data = Item_randgift["id_" .. key_id]
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
	for k, v in pairs(Item_randgift) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Item_randgift"] = nil
	package.loaded["DB_Item_randgift"] = nil
	package.loaded["db/DB_Item_randgift"] = nil
end

