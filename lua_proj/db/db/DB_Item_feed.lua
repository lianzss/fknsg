-- Filename: DB_Item_feed.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Item_feed", package.seeall)

keys = {
	"id", "name", "desc", "icon_small", "icon_big", "item_type", "quality", "sellable", "sell_type", "sell_num", "max_stack", "fix_type", "can_destroy", "handle_type", "add_exp", 
}

Item_feed = {
	id_50001 = {50001, "宠物小饲料1", "宠物吃了后可以获得20经验值", "datili.png", nil, 4, 1, 0, nil, nil, 9999, nil, 0, nil, 20, },
	id_50002 = {50002, "宠物中饲料1", "宠物吃了后可以获得20经验值", "datili.png", nil, 4, 1, 0, nil, nil, 9999, nil, 0, nil, 20, },
	id_50003 = {50003, "宠物大饲料1", "宠物吃了后可以获得20经验值", "datili.png", nil, 4, 1, 0, nil, nil, 9999, nil, 0, nil, 20, },
	id_50004 = {50004, "宠物小饲料2", "宠物吃了后可以获得20经验值", "datili.png", nil, 4, 1, 0, nil, nil, 9999, nil, 0, nil, 20, },
	id_50005 = {50005, "宠物中饲料2", "宠物吃了后可以获得20经验值", "datili.png", nil, 4, 1, 0, nil, nil, 9999, nil, 0, nil, 20, },
	id_50101 = {50101, "宠物小饲料1", "宠物吃了后可以获得50经验值", "datili.png", nil, 4, 2, 0, nil, nil, 9999, nil, 0, nil, 50, },
	id_50102 = {50102, "宠物中饲料1", "宠物吃了后可以获得50经验值", "datili.png", nil, 4, 2, 0, nil, nil, 9999, nil, 0, nil, 50, },
	id_50103 = {50103, "宠物大饲料1", "宠物吃了后可以获得50经验值", "datili.png", nil, 4, 2, 0, nil, nil, 9999, nil, 0, nil, 50, },
	id_50104 = {50104, "宠物小饲料2", "宠物吃了后可以获得50经验值", "datili.png", nil, 4, 2, 0, nil, nil, 9999, nil, 0, nil, 50, },
	id_50105 = {50105, "宠物中饲料2", "宠物吃了后可以获得50经验值", "datili.png", nil, 4, 2, 0, nil, nil, 9999, nil, 0, nil, 50, },
	id_50201 = {50201, "幸运草", "据说找到四叶草的人就可以获得幸福哦，喂养宠物可获得100经验值。", "xingyuncao.png", nil, 4, 3, 0, nil, nil, 9999, nil, 0, nil, 100, },
	id_50202 = {50202, "仙灵雨露", "在仙山中采集的仙灵雨露，喂养宠物可获得100经验值。", "yulu.png", nil, 4, 3, 0, nil, nil, 9999, nil, 0, nil, 100, },
	id_50203 = {50203, "初级经验书", "《宠物小学生之十万个为什么》，喂养宠物可获得100经验值。", "chujijingyan.png", nil, 4, 3, 0, nil, nil, 9999, nil, 0, nil, 100, },
	id_50204 = {50204, "宠物小饲料2", "宠物吃了后可以获得100经验值", "datili.png", nil, 4, 3, 0, nil, nil, 9999, nil, 0, nil, 50, },
	id_50205 = {50205, "宠物中饲料2", "宠物吃了后可以获得100经验值", "datili.png", nil, 4, 3, 0, nil, nil, 9999, nil, 0, nil, 50, },
	id_50301 = {50301, "天狼魂晶", "小天狼换下来的牙所结成的魂晶，喂养宠物可获得380经验值。", "tianlang.png", nil, 4, 4, 0, nil, nil, 9999, nil, 0, nil, 380, },
	id_50302 = {50302, "白虎精魄", "由白虎之魂所结成的精魄，喂养宠物可获得390经验值。", "baihu.png", nil, 4, 4, 0, nil, nil, 9999, nil, 0, nil, 390, },
	id_50303 = {50303, "玄武精华", "将玄武壳研碎后所提取的精华，喂养宠物可获得410经验值。", "xuanwu.png", nil, 4, 4, 0, nil, nil, 9999, nil, 0, nil, 410, },
	id_50304 = {50304, "麒麟朱果", "传说中被麒麟之血浇灌过的果子，喂养宠物可获得420经验值。", "qilin.png", nil, 4, 4, 0, nil, nil, 9999, nil, 0, nil, 420, },
	id_50305 = {50305, "中级经验书", "《宠物中学生之娃娃早恋必须抓》，喂养宠物可获得400经验值。", "zhongjijingyan.png", nil, 4, 4, 0, nil, nil, 9999, nil, 0, nil, 400, },
	id_50401 = {50401, "青龙元神", "由青龙之威所结成的元神，喂养宠物可获得1050经验值。", "qinglong.png", nil, 4, 5, 0, nil, nil, 9999, nil, 0, nil, 1050, },
	id_50402 = {50402, "朱雀燃羽", "传说中可以点燃生长之力的朱雀羽，喂养宠物可获得1000经验值。", "zhuque.png", nil, 4, 5, 0, nil, nil, 9999, nil, 0, nil, 1000, },
	id_50403 = {50403, "高级经验书", "《宠物大学生之宠物的自我修养》，喂养宠物可获得1000经验值。", "gaojijingyan.png", nil, 4, 5, 0, nil, nil, 9999, nil, 0, nil, 1000, },
	id_50404 = {50404, "宠物小饲料2", "宠物吃了后可以获得1000经验值", "datili.png", nil, 4, 5, 0, nil, nil, 9999, nil, 0, nil, 1000, },
	id_50405 = {50405, "宠物中饲料2", "宠物吃了后可以获得1000经验值", "datili.png", nil, 4, 5, 0, nil, nil, 9999, nil, 0, nil, 1000, },
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
	local id_data = Item_feed["id_" .. key_id]
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
	for k, v in pairs(Item_feed) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Item_feed"] = nil
	package.loaded["DB_Item_feed"] = nil
	package.loaded["db/DB_Item_feed"] = nil
end

