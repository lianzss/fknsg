-- Filename: DB_Goods.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Goods", package.seeall)

keys = {
	"id", "sell_mode", "type", "icon", "desc", "original_price", "current_price", "vip_needed", "user_lv_needed", "vip_discount", "limit_num", "item_id", "hero_id", "drop_table_id", "buy_siliver_num", "buy_soul_num", "cost_gold_add_siliver", 
}

Goods = {
	id_1 = {1, 2, 30, nil, "将数颗大力丸糅在一起后做成的体力丹，使用后可获得25点体力。", 50, 20, 0, 0, nil, 0, 10032, nil, nil, nil, nil, "10|100", },
	id_2 = {2, 2, 31, nil, "男人们追捧的耐力神器，使用后可获得10点耐力。", 50, 10, 0, 0, nil, nil, 10042, nil, nil, nil, nil, "5|50", },
	id_11 = {11, 3, 1, nil, "奇妙的符纸，上有财神爷亲笔所书“招财”二字，购买后可获得10000银币。", nil, 2, 0, 0, nil, nil, nil, nil, nil, 10000, nil, "2|10", },
	id_10 = {10, 3, 2, nil, "神奇的经验熊猫，可用于强化武将，增加5000点武将经验。", nil, 5, 0, 0, nil, nil, nil, 40001, nil, nil, nil, "5|20", },
	id_5 = {5, 3, 9, nil, "镶有上好的青玉，是女汉子们都梦寐以求的礼物！增加500点名将好感度", nil, 10, 0, 0, nil, nil, 40044, nil, nil, nil, nil, nil, },
	id_6 = {6, 3, 11, nil, "以黄金所铸的宝箱，可获得绿色，蓝色，紫色装备及名将好感礼物。", nil, 50, 0, 0, nil, nil, 30003, nil, nil, nil, nil, nil, },
	id_7 = {7, 3, 12, nil, "金钥匙，用于开启黄金宝箱。", nil, 25, 0, 0, nil, nil, 30013, nil, nil, nil, nil, nil, },
	id_8 = {8, 3, 13, nil, "以白银所铸的宝箱，可获得绿色、蓝色装备及名将好感礼物。", nil, 20, 0, 0, nil, nil, 30002, nil, nil, nil, nil, nil, },
	id_9 = {9, 3, 14, nil, "银钥匙，用于开启白银宝箱。", nil, 10, 0, 0, nil, nil, 30012, nil, nil, nil, nil, nil, },
	id_13 = {13, 3, 15, nil, "铜钥匙，用于开启青铜宝箱。", nil, 5, 0, 0, nil, nil, 30011, nil, nil, nil, nil, nil, },
	id_14 = {14, 3, 21, nil, "由“三国户籍管理办”独家统一制作，可用于更改主角名称。", nil, 100, 0, 0, nil, nil, 60012, nil, nil, nil, nil, nil, },
	id_15 = {15, 3, 22, nil, "《宠物中学生之娃娃早恋必须抓》，喂养宠物可获得400经验值。", nil, 20, 0, 0, nil, nil, 50305, nil, nil, nil, nil, nil, },
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
	local id_data = Goods["id_" .. key_id]
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
	for k, v in pairs(Goods) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Goods"] = nil
	package.loaded["DB_Goods"] = nil
	package.loaded["db/DB_Goods"] = nil
end

