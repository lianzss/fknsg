-- Filename: DB_Switch.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Switch", package.seeall)

keys = {
	"id", "level", "copyId", "name", "desc", "show", "alertContent", 
}

Switch = {
	id_1 = {1, nil, 1001, "阵容", "需击败“[桃源村]-张角”开启", 1, "上阵武将可大大提高战力", },
	id_2 = {2, nil, 1002, "武将进阶", "需击败“[桃源村]-左慈”开启，可进阶武将，大幅提高战斗力", 0, "进阶武将可大幅增加武将战斗力", },
	id_3 = {3, 5, nil, "商店", "需xx级开启，可招募强力稀有武将", 0, nil, },
	id_4 = {4, 15, nil, "精英副本", "需xx级开启，可获得稀有装备", 1, "通关精英副本可获得武将装备", },
	id_5 = {5, 1, nil, "活动", "需xx级开启", 0, nil, },
	id_6 = {6, 18, nil, "名将", "需xx级开启，收集名将增进好感，提高战斗力", 1, "向名将送礼提升好感等级可增加武将属性", },
	id_7 = {7, 30, nil, "比武", "需xx级开启，可参加比武获得稀有道具", 1, "参加比武获得稀有道具", },
	id_8 = {8, 14, nil, "竞技场", "需xx级开启，可参加竞技场排名，获得声望兑换大量进阶丹和稀有道具", 1, "参加竞技可获得大量声望", },
	id_9 = {9, 25, nil, "活动副本", "需xx级开启,挑战活动副本可以获得大量银币", 1, "挑战摇钱树可以获得大量银币", },
	id_10 = {10, 40, nil, "宠物", "需xx级开启，副本“白马之围上”开始掉落宠物精华", 1, "宠物出战后会给上阵武将增加属性", },
	id_11 = {11, 45, nil, "资源矿", "需xx级开启，可占领资源矿获得大量银币", 1, "占领资源矿可以获得大量银币", },
	id_12 = {12, 33, nil, "占星", "需xx级开启，可获得装备项链和大量银币", 1, "完成占星星座可以获得项链", },
	id_13 = {13, 13, nil, "签到", "需xx级开启，每日签到领大量福利", 1, "每日登陆签到不同好礼等你来拿", },
	id_14 = {14, 5, nil, "等级礼包", "需xx级开启", 1, "等级越高更多好礼等你来拿！", },
	id_15 = {15, 1, nil, "铁匠铺", "需通关副本“[虎牢关上]”开启，可强化装备，大幅提升战斗力", 0, nil, },
	id_16 = {16, 9, nil, "装备强化", "需xx级开启，可强化装备，大幅提升战斗力", 1, "强化装备可以大幅度提升战力", },
	id_17 = {17, nil, 1002, "武将强化", "需击败“[桃源村]-左慈”开启，可强化武将，大幅提高战斗力", 0, nil, },
	id_18 = {18, nil, 1002, "武将进阶", "需击败“[桃源村]-左慈”开启，可进阶武将，大幅提高战斗力", 1, "进阶武将可大幅增加武将战斗力", },
	id_19 = {19, 10, nil, "宝物强化", "需xx级开启", 0, nil, },
	id_20 = {20, 10, nil, "夺宝", "需xx级开启，可抢夺战马和兵书，提升战斗力", 1, "夺宝可获得宝物碎片合成宝物", },
	id_21 = {21, 16, nil, "武将炼化", "需xx级开启，可炼化武将获得魂玉，使用魂玉可在神秘商店兑换稀有道具", 1, "在炼化炉炼化武将可获得魂玉", },
	id_22 = {22, 22, nil, "天命系统", "需xx级开启，可消耗副本星数大幅度提高主角属性", 1, "消耗副本星数大幅度提高主角属性", },
	id_23 = {23, 20, nil, "军团", "需xx级开启，可创建或加入军团", 1, "可创建或加入军团", },
	id_24 = {24, 26, nil, "装备洗炼", "需xx级开启，可洗炼装备，提高装备属性", 1, "可洗炼装备，提高装备属性", },
	id_25 = {25, 34, nil, "宝物精炼", "需xx级开启", 0, "宝物精炼", },
	id_26 = {26, 28, nil, "试练塔", "需xx级开启，通关50层可以获得宠物精华", 1, "挑战试练塔可获得稀有道具", },
	id_27 = {27, 1, nil, "进击的魔神", "需xx级开启", 0, "进击的魔神", },
	id_28 = {28, 35, nil, "战魂", "需xx级开启,装备战魂可提升武将战力", 1, "装备战魂可提升武将战力", },
	id_29 = {29, 1, nil, "主角时装", "需xx级开启", 0, "进击的魔神", },
	id_30 = {30, 31, nil, "每日任务", "需xx级开启", 1, "完成每日任务可以获得任务奖励", },
	id_31 = {31, 1, nil, "时装强化", "需xx级开启", 0, nil, },
	id_32 = {32, 50, nil, "武将列传", "需xx级开启", 1, "通关武将列传可领悟觉醒能力！", },
	id_33 = {33, 70, nil, "寻龙探宝", "需xx级开启", 1, "寻龙探宝可获得铸造紫色装备的材料", },
	id_34 = {34, 55, nil, "擂台争霸", "需xx级开启", 1, "挑战擂台争霸夺冠军可获得丰厚奖励", },
	id_35 = {35, 65, nil, "学习技能", "需xx级开启", 1, "学习技能可以让主角更厉害哦！", },
	id_36 = {36, 74, nil, "武将变身", "需xx级开启", 1, "可让你的武将变为你想要的武将！", },
	id_37 = {37, 75, nil, "武将进化", "需xx级开启", 1, "武将进化成6星后，实力将大幅提升", },
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
	local id_data = Switch["id_" .. key_id]
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
	for k, v in pairs(Switch) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Switch"] = nil
	package.loaded["DB_Switch"] = nil
	package.loaded["db/DB_Switch"] = nil
end

