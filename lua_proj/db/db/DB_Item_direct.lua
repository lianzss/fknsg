-- Filename: DB_Item_direct.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Item_direct", package.seeall)

keys = {
	"id", "name", "desc", "icon_small", "icon_big", "item_type", "quality", "sellable", "sell_type", "sell_num", "max_stack", "fix_type", "can_destroy", "process_mode", "coins", "golds", "energy", "general_soul", "endurance", "award_item_id", "award_card_id", "add_challenge_times", "need_level", "getPet", 
}

Item_direct = {
	id_10001 = {10001, "三国大礼包", "我是三国大礼包", "datili.png", nil, 3, 3, 1, 1, 1000, 99, nil, 0, nil, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_10002 = {10002, "竞技恢复丹", "吃了以后会让人总想去找人打架，使用后可以恢复竞技场挑战次数5点。", "junqi.png", nil, 3, 3, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, 5, nil, nil, },
	id_10011 = {10011, "1万银币", "汉朝通用的银质钱币，使用后可获得1万银币。", "yinbi.png", nil, 3, 2, 0, nil, nil, 999, nil, 0, nil, 10000, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_10012 = {10012, "5万银币", "一大堆银币，使用后可获得5万银币。", "yinbi_xiao.png", nil, 3, 3, 0, nil, nil, 999, nil, 0, nil, 50000, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_10013 = {10013, "10万银币", "满满一大兜的银币，放在腰间沉甸甸的，使用后可获得10万银币。", "yinbi_da.png", nil, 3, 4, 0, nil, nil, 999, nil, 0, nil, 100000, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_10014 = {10014, "50万银币", "这袋银币已经满满的快要漫出来了！使用后可获得50万银币。", "yindai_xiao.png", nil, 3, 5, 0, nil, nil, 999, nil, 0, nil, 500000, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_10015 = {10015, "100万银币", "仿佛无穷无尽的银币包，使用后可获得100万银币。", "yindai_da.png", nil, 3, 5, 0, nil, nil, 999, nil, 0, nil, 1000000, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_10016 = {10016, "2万银币", "银币万两X2，使用后可获得2万银币。", "yinbi_xiao.png", nil, 3, 3, 0, nil, nil, 999, nil, 0, nil, 20000, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_10017 = {10017, "5千银币", "主公们最喜欢大喊的“白银千两”X5，使用后可获得5千银币。", "yinbi_xiao.png", nil, 3, 3, 0, nil, nil, 999, nil, 0, nil, 5000, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_10018 = {10018, "200万银币", "几乎无穷无尽的银币包，使用后可获得200万银币。", "yindai_da.png", nil, 3, 5, 0, nil, nil, 999, nil, 0, nil, 2000000, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_10019 = {10019, "20万银币", "沉甸甸的一兜银币，使用后可获得20万银币。", "yinbi_xiao.png", nil, 3, 3, 0, nil, nil, 999, nil, 0, nil, 200000, nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_10021 = {10021, "10金币", "刻有“招财进宝”的金币，摸起来会让人有点小兴奋，使用后可获得10金币。", "jinbi.png", nil, 3, 4, 0, nil, nil, 999, nil, 0, nil, nil, 10, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_10022 = {10022, "50金币", "数十枚堆叠在一起足以闪瞎双眼的金币，使用后可获得50金币。", "jinbi_xiao.png", nil, 3, 5, 0, nil, nil, 999, nil, 0, nil, nil, 50, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_10023 = {10023, "100金币", "土豪们最喜欢将金币堆高来炫富，使用后可获得100金币。", "jinbi_da.png", nil, 3, 5, 0, nil, nil, 999, nil, 0, nil, nil, 100, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_10024 = {10024, "500金币", "即使是土豪，也会两眼发直的金币塔，使用后可获得500金币。", "jinbi_da.png", nil, 3, 5, 0, nil, nil, 999, nil, 0, nil, nil, 500, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_10025 = {10025, "1000金币", "一个平衡感很强的土豪终于将这些金币堆成了金字塔，使用后可获得1000金币。", "jinbi_da.png", nil, 3, 5, 0, nil, nil, 999, nil, 0, nil, nil, 1000, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_10026 = {10026, "150金币", "超值的金币包，平铺起来可绕土豪一圈，使用后可获得150金币。", "jinbi_da.png", nil, 3, 5, 0, nil, nil, 999, nil, 0, nil, nil, 150, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_10027 = {10027, "250金币", "土豪们最喜欢将金币堆高来炫富，使用后可获得250金币。", "jinbi_da.png", nil, 3, 5, 0, nil, nil, 999, nil, 0, nil, nil, 250, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_10028 = {10028, "300金币", "即使是土豪，也会两眼发直的金币塔，使用后可获得300金币。", "jinbi_da.png", nil, 3, 5, 0, nil, nil, 999, nil, 0, nil, nil, 300, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_10031 = {10031, "大力丸", "江湖卖艺人士必备的大力丸，使用后可获得5点体力。", "tili_xiao.png", nil, 3, 2, 0, nil, nil, 999, nil, 0, nil, nil, nil, 5, nil, nil, nil, nil, nil, nil, nil, },
	id_10032 = {10032, "体力丹", "将数颗大力丸糅在一起后做成的体力丹，使用后可获得25点体力。", "tili_zhong.png", nil, 3, 3, 0, nil, nil, 999, nil, 0, nil, nil, nil, 25, nil, nil, nil, nil, nil, nil, nil, },
	id_10033 = {10033, "大体力丹", "如同压缩饼干一般的大体力丹，使用后可获得50点体力。", "tili_da.png", nil, 3, 4, 0, nil, nil, 999, nil, 0, nil, nil, nil, 50, nil, nil, nil, nil, nil, nil, nil, },
	id_10034 = {10034, "特大体力包", "不仅仅大一点点的特大体力丹，使用后可获得100点体力。", "tili_da.png", nil, 3, 5, 0, nil, nil, 999, nil, 0, nil, nil, nil, 100, nil, nil, nil, nil, nil, nil, nil, },
	id_10035 = {10035, "超级体力包", "本来是专门给大象吃的超级体力丹，使用后可获得500点体力。", "tili_da.png", nil, 3, 5, 0, nil, nil, 999, nil, 0, nil, nil, nil, 500, nil, nil, nil, nil, nil, nil, nil, },
	id_10041 = {10041, "耐力丸", "由多种中草药混制而成，使用后可获得2点耐力。", "naili_xiao.png", nil, 3, 2, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, 2, nil, nil, nil, nil, nil, },
	id_10042 = {10042, "耐力丹", "男人们追捧的耐力神器，使用后可获得10点耐力。", "naili_zhong.png", nil, 3, 3, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, 10, nil, nil, nil, nil, nil, },
	id_10043 = {10043, "大耐力丹", "他，爱不释手，她，欲罢不能，使用后可获得20点耐力。", "naili_da.png", nil, 3, 4, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, 20, nil, nil, nil, nil, nil, },
	id_10044 = {10044, "特大耐力丹", "就连南华老仙都极力推荐的补耐圣品，使用后可获得50点耐力。", "naili_da.png", nil, 3, 5, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, 50, nil, nil, nil, nil, nil, },
	id_10045 = {10045, "超级耐力丹", "使用获得100点耐力", "naili_da.png", nil, 3, 5, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, 100, nil, nil, nil, nil, nil, },
	id_10051 = {10051, "小将魂玉", "寄宿有武将之魂的勾玉，使用后可获得1000点将魂。", "jianghun.png", nil, 3, 2, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, 1000, nil, nil, nil, nil, nil, nil, },
	id_10052 = {10052, "中将魂玉", "放在耳边可以听到武将耳语的将魂玉，使用后可获得5000点将魂。", "jianghun.png", nil, 3, 3, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, 5000, nil, nil, nil, nil, nil, nil, },
	id_10053 = {10053, "大将魂玉", "嘘，这些将魂好像在里面吵架，使用后可获得10000点将魂。", "jianghun.png", nil, 3, 4, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, 10000, nil, nil, nil, nil, nil, nil, },
	id_10054 = {10054, "特大将魂玉", "感觉就像有名将要从里面诞生一样，使用后可获得5万点将魂。", "jianghun.png", nil, 3, 5, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, 50000, nil, nil, nil, nil, nil, nil, },
	id_10055 = {10055, "超级将魂玉", "收集了古今几千年将魂的魔玉，使用后可获得10万点将魂。", "jianghun.png", nil, 3, 5, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, 100000, nil, nil, nil, nil, nil, nil, },
	id_10061 = {10061, "竞技帖", "买通后门扫地大妈后获得的竞技场通行证，使用后可获得1点竞技场次数。", "jingjitie.png", nil, 3, 2, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, 1, nil, nil, },
	id_10062 = {10062, "中竞技包", "使用获得10竞技场次数", "jingjitie.png", nil, 3, 3, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, 5, nil, nil, },
	id_10063 = {10063, "大竞技包", "使用获得50竞技场次数", "jingjitie.png", nil, 3, 4, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, 10, nil, nil, },
	id_10064 = {10064, "特大竞技包", "使用获得200竞技场次数", "jingjitie.png", nil, 3, 5, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, 50, nil, nil, },
	id_10065 = {10065, "超级竞技包", "使用获得500竞技场次数", "jingjitie.png", nil, 3, 5, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, nil, nil, nil, 100, nil, nil, },
	id_11001 = {11001, "关平", "武将“关平”的卡牌，使用后可获得武将“关平”。", "head_guanping.png", nil, 3, 4, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, nil, nil, "10068|1", nil, nil, nil, },
	id_11002 = {11002, "王异", "武将“王异”的卡牌，使用后可获得武将“王异”。", "head_heshi.png", nil, 3, 4, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, nil, nil, "10089|1", nil, nil, nil, },
	id_11003 = {11003, "强弩兵", "武将“强弩兵”的卡牌，使用后可获得武将“强弩兵”。", "head_qiangnu.png", nil, 3, 1, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, nil, nil, "30005|1", nil, nil, nil, },
	id_11004 = {11004, "强弩兵", "武将“强弩兵”的卡牌，使用后可获得武将“强弩兵”。", "head_qiangnu.png", nil, 3, 1, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, nil, nil, "30005|1", nil, nil, nil, },
	id_11005 = {11005, "强弩兵", "武将“强弩兵”的卡牌，使用后可获得武将“强弩兵”。", "head_qiangnu.png", nil, 3, 1, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, nil, nil, "30005|1", nil, nil, nil, },
	id_11006 = {11006, "强弩兵", "武将“强弩兵”的卡牌，使用后可获得武将“强弩兵”。", "head_qiangnu.png", nil, 3, 1, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, nil, nil, "30005|1", nil, nil, nil, },
	id_11007 = {11007, "强弩兵", "武将“强弩兵”的卡牌，使用后可获得武将“强弩兵”。", "head_qiangnu.png", nil, 3, 1, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, nil, nil, "30005|1", nil, nil, nil, },
	id_11008 = {11008, "强弩兵", "武将“强弩兵”的卡牌，使用后可获得武将“强弩兵”。", "head_qiangnu.png", nil, 3, 1, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, nil, nil, "30005|1", nil, nil, nil, },
	id_11009 = {11009, "强弩兵", "武将“强弩兵”的卡牌，使用后可获得武将“强弩兵”。", "head_qiangnu.png", nil, 3, 1, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, nil, nil, "30005|1", nil, nil, nil, },
	id_11010 = {11010, "强弩兵", "武将“强弩兵”的卡牌，使用后可获得武将“强弩兵”。", "head_qiangnu.png", nil, 3, 1, 0, nil, nil, 999, nil, 0, nil, nil, nil, nil, nil, nil, nil, "30005|1", nil, nil, nil, },
	id_12001 = {12001, "vip0成长礼包", "vip0成长礼包，vip等级达到0以上可以购买。", "vip_libao.png", nil, 3, 5, 0, nil, nil, 9999, nil, 0, nil, 10000, nil, nil, nil, nil, "10032|1,10042|1,60006|5", nil, nil, nil, nil, },
	id_12002 = {12002, "vip1成长礼包", "vip1成长礼包，vip等级达到1以上可以购买。", "vip_libao.png", nil, 3, 5, 0, nil, nil, 9999, nil, 0, nil, 50000, nil, nil, nil, nil, "30001|5,30011|5,60006|5", nil, nil, nil, nil, },
	id_12003 = {12003, "vip2成长礼包", "vip2成长礼包，vip等级达到2以上可以购买。", "vip_libao.png", nil, 3, 5, 0, nil, nil, 9999, nil, 0, nil, 100000, nil, nil, nil, nil, "104204|1,30001|10,30011|10,60006|5", nil, nil, nil, nil, },
	id_12004 = {12004, "vip3成长礼包", "vip3成长礼包，vip等级达到3以上可以购买。", "vip_libao.png", nil, 3, 5, 0, nil, nil, 9999, nil, 0, nil, 200000, nil, nil, nil, nil, "103312|1,30001|20,30011|20,60006|10", nil, nil, nil, nil, },
	id_12005 = {12005, "vip4成长礼包", "vip4成长礼包，vip等级达到4以上可以购买。", "vip_libao.png", nil, 3, 5, 0, nil, nil, 9999, nil, 0, nil, 200000, nil, nil, nil, nil, "102312|1,30002|15,30012|15,60006|15", nil, nil, nil, nil, },
	id_12006 = {12006, "vip5成长礼包", "vip5成长礼包，vip等级达到5以上可以购买。", "vip_libao.png", nil, 3, 5, 0, nil, nil, 9999, nil, 0, nil, 300000, nil, nil, nil, nil, "104312|1,30002|20,30012|20,60006|20", nil, nil, nil, nil, },
	id_12007 = {12007, "vip6成长礼包", "vip6成长礼包，vip等级达到6以上可以购买。", "vip_libao.png", nil, 3, 5, 0, nil, nil, 9999, nil, 0, nil, 300000, nil, nil, nil, nil, "101312|1,502506|1,30002|30,30012|30,60006|20", nil, nil, nil, nil, },
	id_12008 = {12008, "vip7成长礼包", "vip7成长礼包，vip等级达到7以上可以购买。", "vip_libao.png", nil, 3, 5, 0, nil, nil, 9999, nil, 0, nil, 400000, nil, nil, nil, nil, "102412|1,103301|1,30003|25,30013|25", nil, nil, nil, nil, },
	id_12009 = {12009, "vip8成长礼包", "vip8成长礼包，vip等级达到8以上可以购买。", "vip_libao.png", nil, 3, 5, 0, nil, nil, 9999, nil, 0, nil, 400000, nil, nil, nil, nil, "103412|1,102301|1,30003|50,30013|50", nil, nil, nil, nil, },
	id_12010 = {12010, "vip9成长礼包", "vip9成长礼包，vip等级达到9以上可以购买。", "vip_libao.png", nil, 3, 5, 0, nil, nil, 9999, nil, 0, nil, 500000, nil, nil, nil, nil, "101412|1,104301|1,30003|75,30013|75", nil, nil, nil, nil, },
	id_12011 = {12011, "vip10成长礼包", "vip10成长礼包，vip等级达到10以上可以购买。", "vip_libao.png", nil, 3, 5, 0, nil, nil, 9999, nil, 0, nil, 500000, nil, nil, nil, nil, "501504|1,104412|1,101401|1,30003|100,30013|100", nil, nil, nil, nil, },
	id_12012 = {12012, "vip11成长礼包", "vip11成长礼包，vip等级达到11以上可以购买。", "vip_libao.png", nil, 3, 5, 0, nil, nil, 9999, nil, 0, nil, 800000, nil, nil, nil, nil, "20021|1,20011|1,103412|1,103403|1,30003|100,30013|100", nil, nil, nil, nil, },
	id_12013 = {12013, "vip12成长礼包", "vip12成长礼包，vip等级达到12以上可以购买。", "vip_libao.png", nil, 3, 5, 0, nil, nil, 9999, nil, 0, nil, 1000000, nil, nil, nil, nil, "20021|1,20012|1,102412|1,102403|1,30003|100,30013|100", nil, nil, nil, nil, },
	id_12014 = {12014, "vip13成长礼包", "vip13成长礼包，vip等级达到13以上可以购买。", "vip_libao.png", nil, 3, 5, 0, nil, nil, 9999, nil, 0, nil, 1500000, nil, nil, nil, nil, "20014|1,20013|1,104412|1,104403|1,30003|100,30013|100", nil, nil, nil, nil, },
	id_12015 = {12015, "vip14成长礼包", "vip14成长礼包，vip等级达到14以上可以购买。", "vip_libao.png", nil, 3, 5, 0, nil, nil, 9999, nil, 0, nil, 2000000, nil, nil, nil, nil, "20014|1,20013|1,101412|1,101403|1,30003|100,30013|100", nil, nil, nil, nil, },
	id_13001 = {13001, "烈焰马", "最多可领悟3个蓝色及以下品质的宠物技能。技能等级上限：6（可锁定2个技能）", "pet_head_zaoma.png", nil, 3, 3, 0, nil, nil, 999, nil, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1, },
	id_13002 = {13002, "火羽神鹰", "最多可领悟4个蓝色及以下品质宠物技能。技能等级上限：6（可锁定2个技能）", "pet_head_huoying.png", nil, 3, 4, 0, nil, nil, 999, nil, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 2, },
	id_13003 = {13003, "三尾灵狐", "最多可领悟4个蓝色及以下品质宠物技能。技能等级上限：7（可锁定2个技能）", "pet_head_huli.png", nil, 3, 4, 0, nil, nil, 999, nil, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 3, },
	id_13004 = {13004, "霸影云虎", "最多可领悟4个蓝色及以下品质宠物技能。技能等级上限：8（可锁定2个技能）", "pet_head_laohu.png", nil, 3, 5, 0, nil, nil, 999, nil, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 4, },
	id_13005 = {13005, "幽火冥狼", "最多可领悟5个蓝色及以下品质宠物技能。技能等级上限：8（可锁定2个技能）", "pet_head_minglang.png", nil, 3, 5, 0, nil, nil, 999, nil, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 5, },
	id_13006 = {13006, "青羽应龙", "最多可领悟5个紫色及以下品质宠物技能。技能等级上限：9（可锁定2个技能）", "pet_head_qinglong.png", nil, 3, 5, 0, nil, nil, 999, nil, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 6, },
	id_13007 = {13007, "小鹿", nil, "pet_head_lu.png", nil, 3, 5, 0, nil, nil, 999, nil, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 7, },
	id_13008 = {13008, "乾神飞马", "最多可领悟5个紫色及以下品质宠物技能。技能等级上限：10（可锁定2个技能）", "pet_head_tianma.png", nil, 3, 5, 0, nil, nil, 999, nil, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 8, },
	id_13009 = {13009, "熊", nil, "pet_head_xiong.png", nil, 3, 5, 0, nil, nil, 999, nil, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 9, },
	id_13010 = {13010, "狮子", nil, "pet_head_shizi.png", nil, 3, 5, 0, nil, nil, 999, nil, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 10, },
	id_13011 = {13011, "六翼麒麟", "最多可领悟6个紫色及以下品质宠物技能。技能等级上限：11（可锁定3个技能）", "pet_head_qilin.png", nil, 3, 5, 0, nil, nil, 999, nil, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 11, },
	id_13012 = {13012, "宠物", nil, "pet_head_zaoma.png", nil, 3, 5, 0, nil, nil, 999, nil, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 12, },
	id_13013 = {13013, "宠物", nil, "pet_head_zaoma.png", nil, 3, 5, 0, nil, nil, 999, nil, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 13, },
	id_13014 = {13014, "宠物", nil, "pet_head_zaoma.png", nil, 3, 5, 0, nil, nil, 999, nil, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 14, },
	id_13015 = {13015, "宠物", nil, "pet_head_zaoma.png", nil, 3, 5, 0, nil, nil, 999, nil, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 15, },
	id_13016 = {13016, "宠物", nil, "pet_head_zaoma.png", nil, 3, 5, 0, nil, nil, 999, nil, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 16, },
	id_13017 = {13017, "宠物", nil, "pet_head_zaoma.png", nil, 3, 5, 0, nil, nil, 999, nil, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 15, },
	id_13018 = {13018, "宠物", nil, "pet_head_zaoma.png", nil, 3, 5, 0, nil, nil, 999, nil, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 16, },
	id_13019 = {13019, "宠物", nil, "pet_head_zaoma.png", nil, 3, 5, 0, nil, nil, 999, nil, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 15, },
	id_13020 = {13020, "宠物", nil, "pet_head_zaoma.png", nil, 3, 5, 0, nil, nil, 999, nil, 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 16, },
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
	local id_data = Item_direct["id_" .. key_id]
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
	for k, v in pairs(Item_direct) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Item_direct"] = nil
	package.loaded["DB_Item_direct"] = nil
	package.loaded["db/DB_Item_direct"] = nil
end

