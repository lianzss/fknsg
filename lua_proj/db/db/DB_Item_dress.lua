-- Filename: DB_Item_dress.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Item_dress", package.seeall)

keys = {
	"id", "name", "info", "icon_small", "icon_big", "item_type", "quality", "sellable", "sellType", "sellNum", "maxStacking", "canDestroy", "changeModel", "changeHeadIcon", "changeBodyImg", "changeRageHeadIcon", "baseAffix", "score", "growAffix", "enforeCost", "resolveGot", "resetGold", 
}

Item_dress = {
	id_80001 = {80001, "20001|炎马烈铠,20002|天马霓裳", "20001|马年时装！总有一天，我的如意郎君会身披炎马烈铠，踩着七彩祥云来迎接我！,20002|马年时装！你就像那黑夜中的天马座，那么耀眼，那么靓丽，那么令人难以自拔！", "20001|small_nanzhu_shizhuang_1.png,20002|small_nvzhu_shizhuang_1.png", "20001|big_nanzhu_shizhuang_1.png,20002|big_nvzhu_shizhuang_1.png", 14, 5, 0, 1, 1000, 1, 1, "20001|zhan_jiang_nanzhu_shizhuang1.png,20002|zhan_jiang_nvzhu_shizhuang1.png", "20001|head_nanzhu_shizhuang1.png,20002|head_nvzhu_shizhuang1.png", "20001|quan_jiang_nanzhu_shizhuang1.png,20002|quan_jiang_nvzhu_shizhuang1.png", "20001|nuqi_nanzhu_shizhuang1.png,20002|nuqi_nvzhu_shizhuang1.png", "1|1000,4|100,5|100,9|100,6|100,7|100,8|100", 10, "1|500,9|50,4|50,5|50,6|20,7|20,8|20", "100000|60016|5|15,200000|60016|10|20,300000|60016|15|30,400000|60016|20|40,500000|60016|25|50,600000|60016|30|60,700000|60016|35|70,800000|60016|40|80,900000|60016|45|90,1000000|60016|50|100", "60016|30", 20, },
	id_80002 = {80002, "20001|皇帝新装,20002|女王新装", "20001|皇帝的新装！你嘲笑我没穿衣服，我说你们不懂时尚，我的地盘我做主！,20002|女王大人的新装！你嘲笑我放荡不羁，我说你不懂我的心，只管叫我女王大人！", "20001|small_nanzhu_shizhuang_2.png,20002|small_nvzhu_shizhuang_2.png", "20001|big_nanzhu_shizhuang_2.png,20002|big_nvzhu_shizhuang_2.png", 14, 5, 0, 1, 1000, 1, 1, nil, nil, nil, nil, "1|500,4|50,5|50,9|50,6|100,7|100,8|100", 8, "1|250,9|25,4|25,5|25,6|10,7|10,8|10", "100000|60016|5|15,200000|60016|10|20,300000|60016|15|30,400000|60016|20|40,500000|60016|25|50,600000|60016|30|60,700000|60016|35|70,800000|60016|40|80,900000|60016|45|90,1000000|60016|50|100", "60016|10", 10, },
	id_80003 = {80003, "20001|塞鹰青甲,20002|饰蝶缕衣", "20001|塞鹰青甲！是时候脱掉厚重的冬装，迎来迷人的春夏了！啊，我觉得我好像能飞起来了！,20002|饰蝶缕衣！经过慢慢严冬，是时候破茧成蝶了！哎呀，今天的我可是公主哦！", "20001|small_nanzhu_shizhuang_3.png,20002|small_nvzhu_shizhuang_3.png", "20001|big_nanzhu_shizhuang_3.png,20002|big_nvzhu_shizhuang_3.png", 14, 5, 0, 1, 1000, 1, 1, "20001|zhan_jiang_nanzhu_shizhuang3.png,20002|zhan_jiang_nvzhu_shizhuang3.png", "20001|head_nanzhu_shizhuang3.png,20002|head_nvzhu_shizhuang3.png", "20001|quan_jiang_nanzhu_shizhuang3.png,20002|quan_jiang_nvzhu_shizhuang3.png", "20001|nuqi_nanzhu_shizhuang3.png,20002|nuqi_nvzhu_shizhuang3.png", "1|1000,4|100,5|100,9|100,6|100,7|100,8|100", 10, "1|500,9|50,4|50,5|50,6|20,7|20,8|20", "100000|60016|5|15,200000|60016|10|20,300000|60016|15|30,400000|60016|20|40,500000|60016|25|50,600000|60016|30|60,700000|60016|35|70,800000|60016|40|80,900000|60016|45|90,1000000|60016|50|100", "60016|30", 20, },
	id_80004 = {80004, "20001|炫酷水龙,20002|荷塘月色", "20001|炫酷水龙！夏天最舒服的事情是什么？当然就是和妹子们一起玩水！炮！啦！,20002|荷塘月色！无论是什么样的男子，都会拜倒在我的荷！花！伞！下！", "20001|small_nanzhu_shizhuang_4.png,20002|small_nvzhu_shizhuang_4.png", "20001|big_nanzhu_shizhuang_4.png,20002|big_nvzhu_shizhuang_4.png", 14, 5, 0, 1, 1000, 1, 1, "20001|zhan_jiang_nanzhu_shizhuang4.png,20002|zhan_jiang_nvzhu_shizhuang4.png", "20001|head_nanzhu_shizhuang4.png,20002|head_nvzhu_shizhuang4.png", "20001|quan_jiang_nanzhu_shizhuang4.png,20002|quan_jiang_nvzhu_shizhuang4.png", "20001|nuqi_nanzhu_shizhuang4.png,20002|nuqi_nvzhu_shizhuang4.png", "1|1000,4|100,5|100,9|100,6|100,7|100,8|100", 10, "1|500,9|50,4|50,5|50,6|20,7|20,8|20", "100000|60016|5|15,200000|60016|10|20,300000|60016|15|30,400000|60016|20|40,500000|60016|25|50,600000|60016|30|60,700000|60016|35|70,800000|60016|40|80,900000|60016|45|90,1000000|60016|50|100", "60016|30", 20, },
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
	local id_data = Item_dress["id_" .. key_id]
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
	for k, v in pairs(Item_dress) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Item_dress"] = nil
	package.loaded["DB_Item_dress"] = nil
	package.loaded["db/DB_Item_dress"] = nil
end

