-- Filename: DB_WealActivity.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_WealActivity", package.seeall)

keys = {
	"id", "name", "picPath", "desc", "expl", "open_act", "ac_double_num", "nc_act", "nc_soul", "sc_drop", "friend_stamina", "guild_donate_act", "guild_shop", "hero_gift", "g_box_drop", "card_cost", "score_lim", "open_draw", 
}

WealActivity = {
	id_1 = {1, "摇摆摇钱树！", nil, "活动期间内，每日攻打摇钱树副本次数将变为原来的2倍", "摇钱树似乎感受到了节日的来临，开始了它最拿手的摇摆舞！\n看着这么得瑟的摇钱树，军师决定发动一场全民摇钱树摇摆活动！\n少年们，快拿起手中的刀枪剑戟指向我们的摇钱树吧！", 1, "300001|2", nil, nil, nil, nil, nil, nil, nil, nil, 5, 500, 1, },
	id_2 = {2, "来自星星的宝物！", nil, "活动期间内，每日攻打经验宝物副本次数将变为原来2倍", "天降奇观！观星台观测到有大量经验宝物坐着天外飞星来到了我们的三国世界！\n快看，这些经验宝物正坐在星星上向大家招着手呢！\n少年们，快追逐星星的轨迹，与宝物们一决胜负吧！", 0, "300002|2", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_3 = {3, "大兴土木", nil, "为了让军团更活跃，留住更多人，活动期间公会捐献个人贡献加倍，军团建设度加倍！\n好好把握这个机会，少年，蜀国的未来就靠你了！\n活动持续太久可是会亏死的，抓紧吧各大军团！", "“哎呀呀~人才凋零，后蜀堪忧啊~！”\n——大张皇后。\n兄弟们招贤去，让各大军团提升待遇福利~\n什么，年终奖？我说的是建设度和个人贡献！\n测试凑数字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字字", 0, nil, nil, nil, nil, nil, "1|10000|20000,2|20000|20000,3|10000|20000", nil, nil, nil, nil, nil, nil, },
	id_4 = {4, "节日活动4", nil, "公会捐献公会建设度加倍", "公会捐献公会建设度加倍", 0, nil, nil, nil, nil, nil, "1|20000|10000,2|20000|10000,3|20000|10000", nil, nil, nil, nil, nil, nil, },
	id_5 = {5, "福利全集", nil, "3项福利一起开启", "3项福利一起开启", 0, "300001|2,300002|2", "1|20000,2|20000,3|20000", nil, nil, nil, "1|20000|20000,2|20000|30000,3|30000|30000", nil, nil, nil, nil, nil, nil, },
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
	local id_data = WealActivity["id_" .. key_id]
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
	for k, v in pairs(WealActivity) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_WealActivity"] = nil
	package.loaded["DB_WealActivity"] = nil
	package.loaded["db/DB_WealActivity"] = nil
end

