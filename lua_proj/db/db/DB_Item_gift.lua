-- Filename: DB_Item_gift.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Item_gift", package.seeall)

keys = {
	"id", "name", "desc", "icon_small", "icon_big", "item_type", "quality", "sellable", "sell_type", "sell_num", "max_stack", "fix_type", "can_destroy", "getItemsNum", "resID1", "num1", "resID2", "num2", "resID3", "num3", "resID4", "num4", "resID5", "num5", "resID6", "num6", "resID7", "num7", "resID8", "num8", "resID9", "num9", "resID10", "num10", "delayOpenTime", "use_minRoleLv", "use_maxRoleLv", "use_needItem", "use_needNum", "use_costBely", "use_costGold", "choose_items", 
}

Item_gift = {
	id_20001 = {20001, "测试_礼包1", "我是测试的礼包1", "datili.png", "datili.png", 6, 1, 0, nil, nil, 9999, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "1|0|1000,3|0|1000,7|410001|10,11|0|1000", },
	id_20002 = {20002, "测试_礼包2", "我是测试的礼包1", "datili.png", "datili.png", 6, 1, 0, nil, nil, 9999, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "1|0|1000,3|0|1000,7|410001|10,8|0|1000", },
	id_20003 = {20003, "测试_礼包3", "我是测试的礼包1", "datili.png", "datili.png", 6, 1, 0, nil, nil, 9999, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "1|0|1000,3|0|1000,7|410001|10,9|0|1000", },
	id_20004 = {20004, "测试_礼包4", "我是测试的礼包1", "datili.png", "datili.png", 6, 1, 0, nil, nil, 9999, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "1|0|1000,3|0|1000,7|410001|10,13|10001|5", },
	id_20005 = {20005, "测试_礼包5", "我是测试的礼包1", "datili.png", "datili.png", 6, 1, 0, nil, nil, 9999, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "1|0|1000,3|0|1000,7|410001|10,14|5015011|1", },
	id_20006 = {20006, "五星武魂选择包", "可挑选庞德，庞统，水镜先生，于吉中任意一种武魂，并获得6个所选择的武魂。", "whxuanzebao.png", "whxuanzebao.png", 6, 5, 0, nil, nil, 9999, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "7|410211|6,7|410199|6,7|410208|6,7|410021|6", },
	id_20007 = {20007, "五星武魂选择包", "可选邓艾,庞德,庞统,水镜先生,于吉,南华老仙中任一种武魂，并获得6个所选武魂。", "whxuanzebao.png", "whxuanzebao.png", 6, 5, 0, nil, nil, 9999, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "7|410198|6,7|410211|6,7|410199|6,7|410208|6,7|410021|6,7|410207|6", },
	id_20008 = {20008, "橙装图纸选择包", "可选择获得10个散件橙装图纸或套装橙装图纸。", "libao5.png", "libao5.png", 6, 5, 0, nil, nil, 9999, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "7|60301|10,7|60302|10,7|60303|10,7|60311|10,7|60312|10,7|60313|10", },
	id_20011 = {20011, "五星兵书选择包", "可挑选任意一个紫色兵书", "baowubao.png", "baowubao.png", 6, 5, 0, nil, nil, 9999, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "7|502501|1,7|502502|1,7|502503|1,7|502504|1,7|502505|1,7|502506|1", },
	id_20012 = {20012, "五星战马选择包", "可挑选任意一个紫色战马", "baowubao.png", "baowubao.png", 6, 5, 0, nil, nil, 9999, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "7|501501|1,7|501502|1,7|501503|1,7|501504|1,7|501505|1,7|501506|1", },
	id_20013 = {20013, "五星宝物选择包", "可挑选任意一个紫色宝物，包括战马和兵书", "baowubao.png", "baowubao.png", 6, 5, 0, nil, nil, 9999, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "7|502501|1,7|502502|1,7|502503|1,7|502504|1,7|502505|1,7|502506|1,7|501501|1,7|501502|1,7|501503|1,7|501504|1,7|501505|1,7|501506|1", },
	id_20014 = {20014, "五星战魂选择包", "可挑选任意一个紫色战魂", "whxuanzebao.png", "whxuanzebao.png", 6, 5, 0, nil, nil, 9999, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "7|70301|1,7|70302|1,7|70303|1,7|70304|1,7|70305|1,7|70306|1,7|70307|1,7|70308|1,7|70309|1,7|70310|1,7|70311|1,7|70312|1,7|70313|1,7|70314|1", },
	id_20021 = {20021, "五星武将选择包", "可选邓艾,庞德,庞统,水镜先生,于吉,南华老仙中任一种武魂，并获得30个所选武魂。", "wujiangxuanzebao.png", "wujiangxuanzebao.png", 6, 5, 0, nil, nil, 9999, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "7|410198|30,7|410211|30,7|410199|30,7|410208|30,7|410021|30,7|410207|30", },
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
	local id_data = Item_gift["id_" .. key_id]
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
	for k, v in pairs(Item_gift) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Item_gift"] = nil
	package.loaded["DB_Item_gift"] = nil
	package.loaded["db/DB_Item_gift"] = nil
end

