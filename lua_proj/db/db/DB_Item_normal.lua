-- Filename: DB_Item_normal.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Item_normal", package.seeall)

keys = {
	"id", "name", "desc", "icon_small", "icon_big", "item_type", "quality", "sellable", "sell_type", "sell_num", "max_stack", "fix_type", "can_destroy", 
}

Item_normal = {
	id_60001 = {60001, "招募令", "号令天下，无敢不从！可用于酒馆中招募武将！", "jiangjunling.png", nil, 10, 5, 1, 1, 1000, 999, nil, 1, },
	id_60002 = {60002, "进阶丹", "可用于武将进阶。（可在神秘商店与竞技场兑换获得，副本概率掉落）", "zhuanshengdan.png", nil, 10, 4, 1, 1, 1000, 9999, nil, 1, },
	id_60003 = {60003, "小喇叭", "消耗1个小喇叭可以进行1次世界聊天。", "datili.png", nil, 10, 1, 1, 1, 1000, 999, nil, 1, },
	id_60004 = {60004, "大喇叭", "消耗1个大喇叭可以进行1次世界广播。", "datili.png", nil, 10, 1, 1, 1, 1000, 999, nil, 1, },
	id_60005 = {60005, "免战牌", "免战令，可用于在夺宝中开启免战。", "mianzhan.png", nil, 10, 5, 1, 1, 1000, 999, nil, 1, },
	id_60006 = {60006, "神秘刷新令", "神秘商店刷新令，可用于刷新神秘商店中的商品。", "shenmi_shuaxin.png", nil, 10, 5, 1, 1, 1000, 999, nil, 1, },
	id_60007 = {60007, "洗炼石", "装备洗炼石，蕴含改变装备属性的能力，可用于洗炼装备。", "xilianshi.png", nil, 10, 5, 1, 1, 1000, 999, nil, 1, },
	id_60008 = {60008, "精炼宝钻", "宝物精炼宝钻，能够提升宝物的潜在能力，可用于宝物精炼。", "jinglianzuan.png", nil, 10, 5, 1, 1, 1000, 999, nil, 1, },
	id_60009 = {60009, "4星宝物碎片", "可随机获得一个4星宝物碎片。", "baowuwenhao.png", nil, 10, 4, 1, 1, 1000, 999, nil, 1, },
	id_60010 = {60010, "4星装备碎片", "可随机获得一个4星装备碎片。", "zhuangbeiwenhao.png", nil, 10, 4, 1, 1, 1000, 999, nil, 1, },
	id_60011 = {60011, "神龙令", "附有龙魂之力，可用于猎魂中召唤神龙开启第4场景。", "shenlongling.png", nil, 10, 5, 1, 1, 1000, 999, nil, 1, },
	id_60012 = {60012, "更名牌", "由“三国户籍管理办”独家统一制作，可用于更改主角名称。", "gengmingpai.png", nil, 10, 5, 0, nil, nil, 999, nil, 1, },
	id_60013 = {60013, "占星令", "三国时期大师们占星所用的甲令，可用于免费刷新星座。", "guijia.png", nil, 10, 5, 0, nil, nil, 999, nil, 1, },
	id_60014 = {60014, "强攻旗", "兵不厌诈，攻而再攻，是谓强攻！可用于免费重置普通副本攻打次数。", "qianggongqi_big.png", nil, 10, 5, 0, nil, nil, 999, nil, 1, },
	id_60015 = {60015, "伐树令", "进入摇钱树乐园用的门票，可用于额外攻打摇钱树活动副本。", "fashuling.png", nil, 10, 5, 0, nil, nil, 999, nil, 1, },
	id_60016 = {60016, "时装精华", "谜一样的水晶，靠近时装时会自动向前骑上，光彩非常。可用于强化时装。", "shuizhijinghun.png", nil, 10, 5, 1, 1, 1000, 9999, nil, 1, },
	id_60017 = {60017, "觉醒令", "蕴含突破武将能力，领悟觉醒的力量。可用于洗练武将觉醒能力。", "juexing.png", nil, 10, 5, 1, 1, 1000, 9999, nil, 1, },
	id_60018 = {60018, "5星宝物碎片", "可随机获得一个5星宝物碎片。", "baowuwenhao2.png", nil, 10, 5, 1, 1, 1000, 9999, nil, 1, },
	id_60019 = {60019, "进化石", "用于将5星武将进化6星，在普通和军团副本、神秘商店、竞技场、试练塔、占星中获得。", "jinhuashi.png", nil, 10, 6, 1, 1, 1000, 9999, nil, 1, },
	id_60101 = {60101, "金之精魄", "蕴含金之属性的精魄，可用于特殊活动。活动期间击败普通副本任意据点有概率掉落。", "jinzhijingpo.png", nil, 10, 1, 1, 1, 1000, 9999, nil, 1, },
	id_60102 = {60102, "木之精魄", "蕴含木之属性的精魄，可用于特殊活动。活动期间击败普通副本任意据点有概率掉落。", "muzhijingpo.png", nil, 10, 1, 1, 1, 1000, 9999, nil, 1, },
	id_60103 = {60103, "水之精魄", "蕴含水之属性的精魄，可用于特殊活动。活动期间击败普通副本任意据点有概率掉落。", "shuizhijingpo.png", nil, 10, 1, 1, 1, 1000, 9999, nil, 1, },
	id_60104 = {60104, "火之精魄", "蕴含火之属性的精魄，可用于特殊活动。活动期间击败普通副本任意据点有概率掉落。", "huozhijingpo.png", nil, 10, 1, 1, 1, 1000, 9999, nil, 1, },
	id_60105 = {60105, "土之精魄", "蕴含土之属性的精魄，可用于特殊活动。活动期间击败普通副本任意据点有概率掉落。", "tuzhijingpo.png", nil, 10, 1, 1, 1, 1000, 9999, nil, 1, },
	id_60201 = {60201, "魔石", "内有流光闪动，蕴含着神奇魔力的石头，是铸造橙装必备的材料之一。", "moshi.png", nil, 10, 5, 0, nil, nil, 9999, nil, 1, },
	id_60202 = {60202, "乌金", "金里透黑迷一般的金属，可收纳灵性，是铸造橙装必备的材料之一。", "wujin.png", nil, 10, 5, 0, nil, nil, 9999, nil, 1, },
	id_60203 = {60203, "玄铁", "千年玄铁，颜色深黑，透出隐隐寒光，是铸造橙装必备的材料之一。", "xuantie.png", nil, 10, 5, 0, nil, nil, 9999, nil, 1, },
	id_60204 = {60204, "翎羽", "由凤凰身上掉落的羽毛，极为罕见，是铸造橙装必备的材料之一。", "lingyu.png", nil, 10, 5, 0, nil, nil, 9999, nil, 1, },
	id_60205 = {60205, "神玉", "晶莹剔透，似为补天之玉，是铸造橙装必备的材料之一。", "shenyu.png", nil, 10, 5, 0, nil, nil, 9999, nil, 1, },
	id_60301 = {60301, "散件武器图纸", "散件武器图纸，记载着橙装武器的铸造之法，是铸造橙装必备的材料之一。", "sanwuqi.png", nil, 10, 5, 0, nil, nil, 9999, nil, 1, },
	id_60302 = {60302, "散件防具图纸", "散件防具图纸，记载着橙装防具的铸造之法，是铸造橙装必备的材料之一。", "sanfangju.png", nil, 10, 5, 0, nil, nil, 9999, nil, 1, },
	id_60303 = {60303, "散件项链图纸", "散件项链图纸，记载着橙装项链的铸造之法，是铸造橙装必备的材料之一。", "sanxianglian.png", nil, 10, 5, 0, nil, nil, 9999, nil, 1, },
	id_60311 = {60311, "套装武器图纸", "套装武器图纸，记载着橙装武器的铸造之法，是铸造橙装必备的材料之一。", "taowuqi.png", nil, 10, 5, 0, nil, nil, 9999, nil, 1, },
	id_60312 = {60312, "套装防具图纸", "套装防具图纸，记载着橙装防具的铸造之法，是铸造橙装必备的材料之一。", "taofangju.png", nil, 10, 5, 0, nil, nil, 9999, nil, 1, },
	id_60313 = {60313, "套装项链图纸", "套装项链图纸，记载着橙装项链的铸造之法，是铸造橙装必备的材料之一。", "taoxianglian.png", nil, 10, 5, 0, nil, nil, 9999, nil, 1, },
	id_60501 = {60501, "紫色宝物碎片", "可随机获得一个紫色战马碎片或者紫色兵书碎片。", "baowubao.png", nil, 10, 5, 1, 1, 1000, 999, nil, 1, },
	id_60601 = {60601, "玫瑰", "先生，买朵玫瑰送旁边的妹子吧！“别闹，那是我妈！”可用于七夕限时兑换。", "rose.png", nil, 10, 6, 1, 1, 30000, 9999, nil, 1, },
	id_60602 = {60602, "七彩绫", "传闻织女亲手所织的七彩华绫，是恋爱中宝贝的最爱，可用于七夕限时兑换。", "qicailing.png", nil, 10, 5, 1, 1, 10000, 9999, nil, 1, },
	id_60603 = {60603, "鹊羽", "调皮的喜鹊们牛郎织女搭建鹊桥时，会用鹊羽挠他们的脚掌，可用于七夕限时兑换。", "yumao.png", nil, 10, 4, 1, 1, 1000, 9999, nil, 1, },
	id_60604 = {60604, "五仁月饼", "精选五种奢侈食材以黄金比例揉制而成的传奇月饼，可用于中秋限时兑换。", "yuebing.png", nil, 10, 4, 1, 1, 3000, 9999, nil, 1, },
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
	local id_data = Item_normal["id_" .. key_id]
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
	for k, v in pairs(Item_normal) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Item_normal"] = nil
	package.loaded["DB_Item_normal"] = nil
	package.loaded["db/DB_Item_normal"] = nil
end

