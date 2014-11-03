-- Filename: DB_Item_star_gift.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Item_star_gift", package.seeall)

keys = {
	"id", "name", "desc", "icon_small", "icon_big", "item_type", "quality", "sellable", "sell_type", "sell_num", "max_stack", "fix_type", "can_destroy", "process_mode", "coins", "ratioGrow", 
}

Item_star_gift = {
	id_40001 = {40001, "饼干", "无论是大人小孩都爱吃的饼干。增加100点红颜好感度", "datili.png", nil, 9, 2, 0, nil, nil, 9999, nil, 0, nil, 100, 100, },
	id_40002 = {40002, "果汁", "纯天然鲜榨果汁，无污染零公害。增加100点红颜好感度", "datili.png", nil, 9, 2, 0, nil, nil, 9999, nil, 0, nil, 100, 100, },
	id_40003 = {40003, "好丽友派", "每一个男人生命中都有那么一两个知己，好丽友派，你懂的。增加200点红颜好感度", "datili.png", nil, 9, 2, 0, nil, nil, 9999, nil, 0, nil, 100, 100, },
	id_40004 = {40004, "冰淇淋", "一只麒麟飞进冰箱以后，你猜它变成了什么？增加200点红颜好感度", "datili.png", nil, 9, 3, 0, nil, nil, 9999, nil, 0, nil, 200, 100, },
	id_40005 = {40005, "狐狸冬菇面", "狐狸用自己精华培育出的蘑菇，味道十分特殊。增加300点红颜好感度", "datili.png", nil, 9, 3, 0, nil, nil, 9999, nil, 0, nil, 200, 100, },
	id_40006 = {40006, "可乐", "一般人只会用来解渴，其实也能作为燃料使用。增加300点红颜好感度", "datili.png", nil, 9, 3, 0, nil, nil, 9999, nil, 0, nil, 200, 100, },
	id_40007 = {40007, "肉排", "一整块肉排，快速补充体力的必备食物。增加400点红颜好感度", "datili.png", nil, 9, 4, 0, nil, nil, 9999, nil, 0, nil, 400, 100, },
	id_40008 = {40008, "红酒", "周末的时候最舒服的事情莫过于坐在沙发里品着红酒看着电影了。增加400点红颜好感度", "datili.png", nil, 9, 4, 0, nil, nil, 9999, nil, 0, nil, 400, 100, },
	id_40009 = {40009, "香浓炖鱼锅", "用各种活鱼死鱼炖出的浓汤，让人望而生畏。增加500点红颜好感度", "datili.png", nil, 9, 4, 0, nil, nil, 9999, nil, 0, nil, 400, 100, },
	id_40010 = {40010, "甲骨文", "一大块甲鱼的壳", "datili.png", nil, 9, 4, 0, nil, nil, 9999, nil, 0, nil, 400, 100, },
	id_40011 = {40011, "饼干", "无论是大人小孩都爱吃的饼干。增加100点红颜好感度", "datili.png", nil, 9, 2, 0, nil, nil, 9999, nil, 0, nil, 100, 100, },
	id_40012 = {40012, "果汁", "纯天然鲜榨果汁，无污染零公害。增加100点红颜好感度", "datili.png", nil, 9, 2, 0, nil, nil, 9999, nil, 0, nil, 100, 100, },
	id_40013 = {40013, "好丽友派", "每一个男人生命中都有那么一两个知己，好丽友派，你懂的。增加200点红颜好感度", "datili.png", nil, 9, 2, 0, nil, nil, 9999, nil, 0, nil, 100, 100, },
	id_40014 = {40014, "冰淇淋", "一只麒麟飞进冰箱以后，你猜它变成了什么？增加200点红颜好感度", "datili.png", nil, 9, 3, 0, nil, nil, 9999, nil, 0, nil, 200, 100, },
	id_40015 = {40015, "狐狸冬菇面", "狐狸用自己精华培育出的蘑菇，味道十分特殊。增加300点红颜好感度", "datili.png", nil, 9, 3, 0, nil, nil, 9999, nil, 0, nil, 200, 100, },
	id_40016 = {40016, "可乐", "一般人只会用来解渴，其实也能作为燃料使用。增加300点红颜好感度", "datili.png", nil, 9, 3, 0, nil, nil, 9999, nil, 0, nil, 200, 100, },
	id_40017 = {40017, "肉排", "一整块肉排，快速补充体力的必备食物。增加400点红颜好感度", "datili.png", nil, 9, 4, 0, nil, nil, 9999, nil, 0, nil, 400, 100, },
	id_40018 = {40018, "红酒", "周末的时候最舒服的事情莫过于坐在沙发里品着红酒看着电影了。增加400点红颜好感度", "datili.png", nil, 9, 4, 0, nil, nil, 9999, nil, 0, nil, 400, 100, },
	id_40019 = {40019, "香浓炖鱼锅", "用各种活鱼死鱼炖出的浓汤，让人望而生畏。增加500点红颜好感度", "datili.png", nil, 9, 4, 0, nil, nil, 9999, nil, 0, nil, 400, 100, },
	id_40020 = {40020, "甲骨文", "一大块甲鱼的壳", "datili.png", nil, 9, 4, 0, nil, nil, 9999, nil, 0, nil, 400, 100, },
	id_40021 = {40021, "女儿红", "只卖998两！无论是英雄美人，都难过女儿红这一关！增加50点名将好感度", "jiu.png", nil, 9, 2, 0, nil, nil, 9999, nil, 0, nil, 50, 100, },
	id_40022 = {40022, "密令旗", "赐给心腹的密令旗。危急时刻可以当作兵符使用调动兵马！增加50点名将好感度", "junqi.png", nil, 9, 2, 0, nil, nil, 9999, nil, 0, nil, 50, 100, },
	id_40023 = {40023, "梨木百宝箱", "以上好的梨木所制成的百宝箱，可以隔绝空气中的有害物质！增加50点名将好感度", "baoxiang.png", nil, 9, 2, 0, nil, nil, 9999, nil, 0, nil, 50, 100, },
	id_40031 = {40031, "一合酥", "曹操在上面写了“一合酥”仨字，众将以为是一人一口就给分了。增加100点名将好感度", "yihesu.png", nil, 9, 3, 0, nil, nil, 9999, nil, 0, nil, 100, 100, },
	id_40032 = {40032, "蹴鞠", "曹操梦想就是凑齐五虎上将和五子良将来一场惊世骇俗的蹴鞠赛。增加100点名将好感度", "cuju.png", nil, 9, 3, 0, nil, nil, 9999, nil, 0, nil, 100, 100, },
	id_40033 = {40033, "紫晶钻石", "无论是放在戒指上，还是穿在项链上都会损失它的华丽。增加100点名将好感度", "zuanshi.png", nil, 9, 3, 0, nil, nil, 9999, nil, 0, nil, 100, 100, },
	id_40034 = {40034, "姻红香囊", "新娘成婚之前每每都会将其置于乳前，不知道是谁把谁熏香了呢？增加100点名将好感度", "xiangnang.png", nil, 9, 3, 0, nil, nil, 9999, nil, 0, nil, 100, 100, },
	id_40035 = {40035, "翠玉耳坠", "具金之坚，钻之华，美人一般，要担心的只是如何把它长久留住。增加100点名将好感度", "erzhui.png", nil, 9, 3, 0, nil, nil, 9999, nil, 0, nil, 100, 100, },
	id_40041 = {40041, "流光金樽", "可将月光溶于酒中，那满满溢出的不知是月光，还是美酒？增加400点名将好感度", "jinzun.png", nil, 9, 4, 0, nil, nil, 9999, nil, 0, nil, 400, 100, },
	id_40042 = {40042, "送子肚兜", "达官贵妇们之间流行的小礼品，寓意在于早生贵子。增加450点名将好感度", "dudou.png", nil, 9, 4, 0, nil, nil, 9999, nil, 0, nil, 450, 100, },
	id_40043 = {40043, "君子佩", "三国时期君子与君子之间互相表达仰慕之情时赠予对方的礼物。增加500点名将好感度", "yupei.png", nil, 9, 4, 0, nil, nil, 9999, nil, 0, nil, 500, 100, },
	id_40044 = {40044, "青玉宝簪", "镶有上好的青玉，是女汉子们都梦寐以求的礼物！增加500点名将好感度", "zanzi.png", nil, 9, 4, 0, nil, nil, 9999, nil, 0, nil, 500, 100, },
	id_40045 = {40045, "金镶玉镯", "本是一个普通的玉镯，在一次摔断后以24K纯金镶接，华美无比。增加550点名将好感度", "yuzhuo.png", nil, 9, 4, 0, nil, nil, 9999, nil, 0, nil, 550, 100, },
	id_40046 = {40046, "天雷鼓", "用犀牛皮做成的战鼓，响声震天动地，所以也叫天雷鼓。增加600点名将好感度", "zhangu.png", nil, 9, 4, 0, nil, nil, 9999, nil, 0, nil, 600, 100, },
	id_40051 = {40051, "波光稠", "从西域进贡的波光稠，摆在哪里都会闪闪发光，令人无法直视。增加1050点名将好感度", "chouduan.png", nil, 9, 5, 0, nil, nil, 9999, nil, 0, nil, 1050, 100, },
	id_40052 = {40052, "东海之心", "传说失传几百年的东海珍珠，硕大无比，圆润瑰丽，绝佳藏品。增加1000点名将好感度", "zhenzhu.png", nil, 9, 5, 0, nil, nil, 9999, nil, 0, nil, 1000, 100, },
	id_40053 = {40053, "貔貅玺", "貔貅乃是上古神物，只进不出。平时还可以当成存钱罐什么的。增加950点名将好感度", "yuxi.png", nil, 9, 5, 0, nil, nil, 9999, nil, 0, nil, 950, 100, },
	id_40054 = {40054, "青梅煮酒", "打雷时煮青梅酒的故事传出去后，反而在民间成为了一种时尚。增加1050点名将好感度", "meizijiu.png", nil, 9, 5, 0, nil, nil, 9999, nil, 0, nil, 1050, 100, },
	id_40055 = {40055, "流云秦筝", "从秦时所传下的古筝，所奏琴音，如高山流水，风云际会。增加1000点名将好感度", "guzheng.png", nil, 9, 5, 0, nil, nil, 9999, nil, 0, nil, 1000, 100, },
	id_40056 = {40056, "鼎烧鹿肉", "曹操送给关羽的绝顶美食，据说怕在路上凉了还加送了火炭。增加1050点名将好感度", "lurou.png", nil, 9, 5, 0, nil, nil, 9999, nil, 0, nil, 1050, 100, },
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
	local id_data = Item_star_gift["id_" .. key_id]
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
	for k, v in pairs(Item_star_gift) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Item_star_gift"] = nil
	package.loaded["DB_Item_star_gift"] = nil
	package.loaded["db/DB_Item_star_gift"] = nil
end

