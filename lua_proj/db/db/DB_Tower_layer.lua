-- Filename: DB_Tower_layer.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Tower_layer", package.seeall)

keys = {
	"id", "name", "layerName", "coin", "silver", "soul", "excution", "stamina", "items", "nextTier", "needLevel", "stronghold", "isShow", "monsterType", "monsterQuality", "monsterModel", "star_condition", 
}

Tower_layer = {
	id_1 = {1, "试炼塔1层", "试炼塔1层", nil, 200, 20, nil, nil, nil, 2, 1, 800101, nil, 1, 2, "head_gongbing.png", nil, },
	id_2 = {2, "试炼塔2层", "试炼塔2层", nil, 200, 20, nil, nil, nil, 3, 1, 800102, nil, 1, 2, "head_changqiang.png", nil, },
	id_3 = {3, "试炼塔3层", "试炼塔3层", nil, 200, 20, nil, nil, nil, 4, 1, 800103, nil, 1, 2, "head_feibiao.png", nil, },
	id_4 = {4, "试炼塔4层", "试炼塔4层", nil, 200, 20, nil, nil, nil, 5, 1, 800104, nil, 1, 2, "head_feibiao.png", nil, },
	id_5 = {5, "张角", "试炼塔5层", nil, 1000, 100, nil, nil, "60002|10,60007|5", 6, 1, 800105, 1, 2, 3, "10042", nil, },
	id_6 = {6, "试炼塔6层", "试炼塔6层", nil, 200, 20, nil, nil, nil, 7, 1, 800106, nil, 1, 2, "head_dajishi.png", nil, },
	id_7 = {7, "试炼塔7层", "试炼塔7层", nil, 200, 20, nil, nil, nil, 8, 1, 800107, nil, 1, 2, "head_qiangnu.png", nil, },
	id_8 = {8, "试炼塔8层", "试炼塔8层", nil, 200, 20, nil, nil, nil, 9, 1, 800108, nil, 1, 2, "head_cike.png", nil, },
	id_9 = {9, "试炼塔9层", "试炼塔9层", nil, 200, 20, nil, nil, nil, 10, 1, 800109, nil, 1, 2, "head_wushushi.png", nil, },
	id_10 = {10, "董卓", "试炼塔10层", nil, 1000, 100, nil, nil, "30022|1,30001|1,30011|1", 11, 1, 800110, 1, 2, 3, "10045", nil, },
	id_11 = {11, "试炼塔11层", "试炼塔11层", nil, 200, 20, nil, nil, nil, 12, 1, 800201, nil, 1, 2, "head_qibing.png", nil, },
	id_12 = {12, "试炼塔12层", "试炼塔12层", nil, 200, 20, nil, nil, nil, 13, 1, 800202, nil, 1, 2, "head_jianwunvshen.png", nil, },
	id_13 = {13, "试炼塔13层", "试炼塔13层", nil, 200, 20, nil, nil, nil, 14, 1, 800203, nil, 1, 2, "head_piliche.png", nil, },
	id_14 = {14, "试炼塔14层", "试炼塔14层", nil, 200, 20, nil, nil, nil, 15, 1, 800204, nil, 1, 2, "head_xiandengsishi.png", nil, },
	id_15 = {15, "夏侯惇", "试炼塔15层", nil, 1000, 100, nil, nil, "60002|10,60007|5,10021|1", 16, 1, 800205, 1, 2, 3, "10005", nil, },
	id_16 = {16, "试炼塔16层", "试炼塔16层", nil, 200, 20, nil, nil, nil, 17, 1, 800206, nil, 1, 2, "head_cike.png", nil, },
	id_17 = {17, "试炼塔17层", "试炼塔17层", nil, 200, 20, nil, nil, nil, 18, 1, 800207, nil, 1, 2, "head_cike.png", nil, },
	id_18 = {18, "试炼塔18层", "试炼塔18层", nil, 200, 20, nil, nil, nil, 19, 1, 800208, nil, 1, 2, "head_yingwei.png", nil, },
	id_19 = {19, "试炼塔19层", "试炼塔19层", nil, 200, 20, nil, nil, nil, 20, 1, 800209, nil, 1, 2, "head_yingwei.png", nil, },
	id_20 = {20, "孙坚", "试炼塔20层", nil, 1000, 100, nil, nil, "50201|1,30002|1,30012|1", 21, 1, 800210, 1, 2, 3, "10035", "1|6", },
	id_21 = {21, "试炼塔21层", "试炼塔21层", nil, 200, 20, nil, nil, nil, 22, 1, 800301, nil, 1, 2, "head_feibiao.png", nil, },
	id_22 = {22, "试炼塔22层", "试炼塔22层", nil, 200, 20, nil, nil, nil, 23, 1, 800302, nil, 1, 2, "head_feibiao.png", nil, },
	id_23 = {23, "试炼塔23层", "试炼塔23层", nil, 200, 20, nil, nil, nil, 24, 1, 800303, nil, 1, 2, "head_feixiong.png", "2|5000", },
	id_24 = {24, "试炼塔24层", "试炼塔24层", nil, 200, 20, nil, nil, nil, 25, 1, 800304, nil, 1, 2, "head_feixiong.png", "1|9", },
	id_25 = {25, "文丑", "试炼塔25层", nil, 1000, 100, nil, nil, "60002|10,60006|1", 26, 1, 800305, 1, 2, 3, "10040", "4|1", },
	id_26 = {26, "试炼塔26层", "试炼塔26层", nil, 200, 20, nil, nil, nil, 27, 1, 800306, nil, 1, 2, "head_wuji.png", nil, },
	id_27 = {27, "试炼塔27层", "试炼塔27层", nil, 200, 20, nil, nil, nil, 28, 1, 800307, nil, 1, 2, "head_changqiang.png", "4|1", },
	id_28 = {28, "试炼塔28层", "试炼塔28层", nil, 200, 20, nil, nil, nil, 29, 1, 800308, nil, 1, 2, "head_hubaoqi.png", nil, },
	id_29 = {29, "试炼塔29层", "试炼塔29层", nil, 200, 20, nil, nil, nil, 30, 1, 800309, nil, 1, 2, "head_baimayicong.png", "1|10", },
	id_30 = {30, "陈宫", "试炼塔30层", nil, 1000, 100, nil, nil, "30003|1,30013|1", 31, 1, 800310, 1, 2, 3, "10044", "2|6000", },
	id_31 = {31, "试炼塔31层", "试炼塔31层", nil, 200, 20, nil, nil, nil, 32, 1, 800401, nil, 1, 2, "head_baimayicong.png", nil, },
	id_32 = {32, "试炼塔32层", "试炼塔32层", nil, 200, 20, nil, nil, nil, 33, 1, 800402, nil, 1, 2, "head_baimayicong.png", nil, },
	id_33 = {33, "试炼塔33层", "试炼塔33层", nil, 200, 20, nil, nil, nil, 34, 1, 800403, nil, 1, 2, "head_qibing.png", "2|6000", },
	id_34 = {34, "试炼塔34层", "试炼塔34层", nil, 200, 20, nil, nil, nil, 35, 1, 800404, nil, 1, 2, "head_jianwunvshen.png", "4|2", },
	id_35 = {35, "许褚", "试炼塔35层", nil, 1000, 100, nil, nil, "60002|10,60007|5,50203|1", 36, 1, 800405, 1, 2, 3, "10025", "1|11", },
	id_36 = {36, "试炼塔36层", "试炼塔36层", nil, 200, 20, nil, nil, nil, 37, 1, 800406, nil, 1, 2, "head_piliche.png", nil, },
	id_37 = {37, "试炼塔37层", "试炼塔37层", nil, 200, 20, nil, nil, nil, 38, 1, 800407, nil, 1, 2, "head_xiandengsishi.png", nil, },
	id_38 = {38, "试炼塔38层", "试炼塔38层", nil, 200, 20, nil, nil, nil, 39, 1, 800408, nil, 1, 2, "head_yingwei.png", "4|2", },
	id_39 = {39, "试炼塔39层", "试炼塔39层", nil, 200, 20, nil, nil, nil, 40, 1, 800409, nil, 1, 2, "head_baimayicong.png", "2|7000", },
	id_40 = {40, "孙尚香", "试炼塔40层", nil, 1000, 100, nil, nil, "30022|1,30001|1,30011|1", 41, 1, 800410, 1, 2, 3, "10037", "1|12", },
	id_41 = {41, "试炼塔41层", "试炼塔41层", nil, 200, 20, nil, nil, nil, 42, 1, 800501, nil, 1, 2, "head_piliche.png", nil, },
	id_42 = {42, "试炼塔42层", "试炼塔42层", nil, 200, 20, nil, nil, nil, 43, 1, 800502, nil, 1, 2, "head_qiangnu.png", nil, },
	id_43 = {43, "试炼塔43层", "试炼塔43层", nil, 200, 20, nil, nil, nil, 44, 1, 800503, nil, 1, 2, "head_wenguan3.png", "2|7000", },
	id_44 = {44, "试炼塔44层", "试炼塔44层", nil, 200, 20, nil, nil, nil, 45, 1, 800504, nil, 1, 2, "head_jinweijun.png", "4|3", },
	id_45 = {45, "华雄", "试炼塔45层", nil, 1000, 100, nil, nil, "60002|10,60007|5,10021|1,50301|1", 46, 1, 800505, 1, 2, 3, "10043", "1|12", },
	id_46 = {46, "试炼塔46层", "试炼塔46层", nil, 200, 20, nil, nil, nil, 47, 1, 800506, nil, 1, 2, "head_longxiang.png", nil, },
	id_47 = {47, "试炼塔47层", "试炼塔47层", nil, 200, 20, nil, nil, nil, 48, 1, 800507, nil, 1, 2, "head_daoche.png", "2|7000", },
	id_48 = {48, "试炼塔48层", "试炼塔48层", nil, 200, 20, nil, nil, nil, 49, 1, 800508, nil, 1, 2, "head_wenguan4.png", "4|3", },
	id_49 = {49, "试炼塔49层", "试炼塔49层", nil, 200, 20, nil, nil, nil, 50, 1, 800509, nil, 1, 2, "head_wenguan6.png", nil, },
	id_50 = {50, "甄姬", "试炼塔50层", nil, 1000, 100, nil, nil, "6000005|1,30002|1,30012|1", 51, 1, 800510, 1, 2, 3, "10026", "1|15", },
	id_51 = {51, "试练塔51层", "试炼塔51层", nil, 200, 20, nil, nil, nil, 52, 1, 800601, nil, 1, 2, "head_guanyinping.png", nil, },
	id_52 = {52, "试练塔52层", "试炼塔52层", nil, 200, 20, nil, nil, nil, 53, 1, 800602, nil, 1, 2, "head_zoushi.png", "2|7500", },
	id_53 = {53, "试练塔53层", "试炼塔53层", nil, 200, 20, nil, nil, nil, 54, 1, 800603, nil, 1, 2, "head_dazhanghuanghou.png", nil, },
	id_54 = {54, "试练塔54层", "试炼塔54层", nil, 200, 20, nil, nil, nil, 55, 1, 800604, nil, 1, 2, "head_zhugejin.png", "1|13", },
	id_55 = {55, "司马懿", "试炼塔55层", nil, 1000, 100, nil, nil, "60002|10,60001|1,50302|1", 56, 1, 800605, 1, 2, 3, "10002", "4|3", },
	id_56 = {56, "试练塔56层", "试炼塔56层", nil, 200, 20, nil, nil, nil, 57, 1, 800606, nil, 1, 2, "head_zhangbao_1.png", nil, },
	id_57 = {57, "试练塔57层", "试炼塔57层", nil, 200, 20, nil, nil, nil, 58, 1, 800607, nil, 1, 2, "head_guoshi.png", "4|3", },
	id_58 = {58, "试练塔58层", "试炼塔58层", nil, 200, 20, nil, nil, nil, 59, 1, 800608, nil, 1, 2, "head_luzhi.png", nil, },
	id_59 = {59, "试练塔59层", "试炼塔59层", nil, 200, 20, nil, nil, nil, 60, 1, 800609, nil, 1, 2, "head_wenpin.png", "2|7500", },
	id_60 = {60, "貂蝉", "试炼塔60层", nil, 1000, 100, nil, nil, "30003|1,30013|1", 61, 1, 800610, 1, 2, 3, "10018", "1|15", },
	id_61 = {61, "试练塔61层", "试炼塔61层", nil, 200, 20, nil, nil, nil, 62, 1, 800701, nil, 1, 2, "head_handang.png", nil, },
	id_62 = {62, "试练塔62层", "试炼塔62层", nil, 200, 20, nil, nil, nil, 63, 1, 800702, nil, 1, 2, "head_yuanshu.png", "2|7500", },
	id_63 = {63, "试练塔63层", "试炼塔63层", nil, 200, 20, nil, nil, nil, 64, 1, 800703, nil, 1, 2, "head_wenguan2.png", nil, },
	id_64 = {64, "试练塔64层", "试炼塔64层", nil, 200, 20, nil, nil, nil, 65, 1, 800704, nil, 1, 2, "head_caohong.png", "2|7500", },
	id_65 = {65, "刘备", "试炼塔65层", nil, 1000, 100, nil, nil, "60002|10,10016|1,50305|1", 66, 1, 800705, 1, 2, 3, "10032", "4|3", },
	id_66 = {66, "试练塔66层", "试炼塔66层", nil, 200, 20, nil, nil, nil, 67, 1, 800706, nil, 1, 2, "head_xinxianying.png", "1|15", },
	id_67 = {67, "试练塔67层", "试炼塔67层", nil, 200, 20, nil, nil, nil, 68, 1, 800707, nil, 1, 2, "head_huangfusong.png", nil, },
	id_68 = {68, "试练塔68层", "试炼塔68层", nil, 200, 20, nil, nil, nil, 69, 1, 800708, nil, 1, 2, "head_wujiang7.png", nil, },
	id_69 = {69, "试练塔69层", "试炼塔69层", nil, 200, 20, nil, nil, nil, 70, 1, 800709, nil, 1, 2, "head_guanping.png", "2|7500", },
	id_70 = {70, "郭嘉", "试炼塔70层", nil, 1000, 100, nil, nil, "30103|1,60019|1", 71, 1, 800710, 1, 2, 3, "10003", "1|15", },
	id_71 = {71, "试练塔71层", "试炼塔71层", nil, 200, 20, nil, nil, nil, 72, 1, 800801, nil, 1, 2, "head_lingtong.png", nil, },
	id_72 = {72, "试练塔72层", "试炼塔72层", nil, 200, 20, nil, nil, nil, 73, 1, 800802, nil, 1, 2, "head_wuguotai.png", "2|8000", },
	id_73 = {73, "试练塔73层", "试炼塔73层", nil, 200, 20, nil, nil, nil, 74, 1, 800803, nil, 1, 2, "head_caimao.png", "1|16", },
	id_74 = {74, "试练塔74层", "试炼塔74层", nil, 200, 20, nil, nil, nil, 75, 1, 800804, nil, 1, 2, "head_zhangchunhua.png", nil, },
	id_75 = {75, "诸葛亮", "试炼塔75层", nil, 1000, 100, nil, nil, "72001|1,60019|1", 76, 1, 800805, 1, 2, 3, "10009", "4|4", },
	id_76 = {76, "试练塔76层", "试炼塔76层", nil, 200, 20, nil, nil, nil, 77, 1, 800806, nil, 1, 2, "head_chengpu.png", "1|16", },
	id_77 = {77, "试练塔77层", "试炼塔77层", nil, 200, 20, nil, nil, nil, 78, 1, 800807, nil, 1, 2, "head_wenguan6.png", nil, },
	id_78 = {78, "试练塔78层", "试炼塔78层", nil, 200, 20, nil, nil, nil, 79, 1, 800808, nil, 1, 2, "head_zhangbao_1.png", "2|8000", },
	id_79 = {79, "试练塔79层", "试炼塔79层", nil, 200, 20, nil, nil, nil, 80, 1, 800809, nil, 1, 2, "head_heshi.png", nil, },
	id_80 = {80, "曹操", "试炼塔80层", nil, 1000, 100, nil, nil, "60006|1,60019|1", 81, 1, 800810, 1, 2, 3, "10004", "1|16", },
	id_81 = {81, "试练塔81层", "试炼塔81层", nil, 200, 20, nil, nil, nil, 82, 1, 800901, nil, 1, 2, "head_caimao.png", nil, },
	id_82 = {82, "试练塔82层", "试炼塔82层", nil, 200, 20, nil, nil, nil, 83, 1, 800902, nil, 1, 2, "head_guanyinping.png", "2|8000", },
	id_83 = {83, "试练塔83层", "试炼塔83层", nil, 200, 20, nil, nil, nil, 84, 1, 800903, nil, 1, 2, "head_yuanshu.png", "4|4", },
	id_84 = {84, "试练塔84层", "试炼塔84层", nil, 200, 20, nil, nil, nil, 85, 1, 800904, nil, 1, 2, "head_caiwenji.png", "4|4", },
	id_85 = {85, "张辽", "试炼塔85层", nil, 1000, 100, nil, nil, "72001|1,60019|1", 86, 1, 800905, 1, 2, 3, "10001", "1|16", },
	id_86 = {86, "试练塔86层", "试炼塔86层", nil, 200, 20, nil, nil, nil, 87, 1, 800906, nil, 1, 2, "head_lejin.png", nil, },
	id_87 = {87, "试练塔87层", "试炼塔87层", nil, 200, 20, nil, nil, nil, 88, 1, 800907, nil, 1, 2, "head_yujin.png", "2|8000", },
	id_88 = {88, "试练塔88层", "试炼塔88层", nil, 200, 20, nil, nil, nil, 89, 1, 800908, nil, 1, 2, "head_menghuo.png", "1|16", },
	id_89 = {89, "试练塔89层", "试炼塔89层", nil, 200, 20, nil, nil, nil, 90, 1, 800909, nil, 1, 2, "head_dingfeng.png", "2|8000", },
	id_90 = {90, "吕布", "试炼塔90层", nil, 1000, 100, nil, nil, "30701|1,60019|1", 91, 1, 800910, 1, 2, 3, "10016", "4|4", },
	id_91 = {91, "试练塔91层", "试炼塔91层", nil, 200, 20, nil, nil, nil, 92, 1, 801001, nil, 1, 2, "head_zhangzhongjing.png", "1|16", },
	id_92 = {92, "试练塔92层", "试炼塔92层", nil, 200, 20, nil, nil, nil, 93, 1, 801002, nil, 1, 2, "head_shuijingxiansheng.png", nil, },
	id_93 = {93, "试练塔93层", "试炼塔93层", nil, 200, 20, nil, nil, nil, 94, 1, 801003, nil, 1, 2, "head_pangde.png", "4|4", },
	id_94 = {94, "试练塔94层", "试炼塔94层", nil, 200, 20, nil, nil, nil, 95, 1, 801004, nil, 1, 2, "head_wenyang.png", "1|16", },
	id_95 = {95, "庞统", "试炼塔95层", nil, 1000, 100, nil, nil, "30022|1,60019|1", nil, 1, 801005, 1, 2, 3, "10199", "2|8000", },
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
	local id_data = Tower_layer["id_" .. key_id]
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
	for k, v in pairs(Tower_layer) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Tower_layer"] = nil
	package.loaded["DB_Tower_layer"] = nil
	package.loaded["db/DB_Tower_layer"] = nil
end

