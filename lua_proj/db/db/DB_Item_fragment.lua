-- Filename: DB_Item_fragment.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Item_fragment", package.seeall)

keys = {
	"id", "name", "desc", "icon_small", "icon_big", "item_type", "quality", "sellable", "sell_type", "sell_num", "max_stack", "fix_type", "can_destroy", "need_part_num", "aimItem", "dropStrongHold", 
}

Item_fragment = {
	id_1013014 = {1013014, "爆流双槌碎片", "集齐5个碎片可以合成武器【爆流双槌】", "small_lan_wuqi_J_1.png", nil, 5, 4, 1, 1, 2000, 5, nil, 0, 5, 101301, "11010,15010", },
	id_1013024 = {1013024, "破焰绝枪碎片", "集齐5个碎片可以合成武器【破焰绝枪】", "small_lan_wuqi_J_2.png", nil, 5, 4, 1, 1, 2000, 5, nil, 0, 5, 101302, "14010,19010", },
	id_1013034 = {1013034, "银钩剑碎片", "集齐5个碎片可以合成武器【银钩剑】", "small_lan_wuqi_J_3.png", nil, 5, 4, 1, 1, 2000, 5, nil, 0, 5, 101303, "23010", },
	id_1013044 = {1013044, "紫3武器碎片", "集齐5个碎片可以合成武器【紫3武器】", "small_lan_wuqi_J_4.png", nil, 5, 4, 1, 1, 2000, 5, nil, 0, 5, 101304, nil, },
	id_1013124 = {1013124, "七绝魔戟碎片", "集齐5个碎片可以合成武器【七绝魔戟】", "small_lan_wuqi_T_1.png", nil, 5, 4, 1, 1, 2000, 5, nil, 0, 5, 101312, nil, },
	id_1013224 = {1013224, "龙鸣雕斧碎片", "集齐5个碎片可以合成武器【龙鸣雕斧】", "small_lan_wuqi_T_2.png", nil, 5, 4, 1, 1, 2000, 5, nil, 0, 5, 101322, nil, },
	id_1014015 = {1014015, "天谕神剑碎片", "集齐10个碎片可以合成武器【天谕神剑】", "small_zi_wuqi_J_1.png", nil, 5, 5, 1, 1, 2500, 10, nil, 0, 10, 101401, "30010,31010,32010", },
	id_1014025 = {1014025, "天脉斧杖碎片", "集齐10个碎片可以合成武器【天脉斧杖】", "small_zi_wuqi_J_2.png", nil, 5, 5, 1, 1, 2500, 10, nil, 0, 10, 101402, "39010,40010,41010", },
	id_1014035 = {1014035, "紫耀映日碎片", "集齐10个碎片可以合成武器【紫耀映日】", "small_zi_wuqi_J_3.png", nil, 5, 5, 1, 1, 2500, 10, nil, 0, 10, 101403, "48010,49010,50010,53010", },
	id_1014045 = {1014045, "紫4武器碎片", "集齐10个碎片可以合成武器【紫4武器】", "small_zi_wuqi_J_4.png", nil, 5, 5, 1, 1, 2500, 10, nil, 0, 10, 101404, nil, },
	id_1014125 = {1014125, "金龙烈刀碎片", "集齐10个碎片可以合成武器【金龙烈刀】", "small_zi_wuqi_T_1.png", nil, 5, 5, 1, 1, 2500, 10, nil, 0, 10, 101412, nil, },
	id_1014235 = {1014235, "裂天青玉弓碎片", "集齐10个碎片可以合成武器【裂天青玉弓】", "small_zi_wuqi_T_2.png", nil, 5, 5, 1, 1, 2500, 10, nil, 0, 10, 101423, nil, },
	id_1023014 = {1023014, "如意战甲碎片", "集齐5个碎片可以合成护甲【如意战甲】", "small_lan_hujia_J_1.png", nil, 5, 4, 1, 1, 2000, 5, nil, 0, 5, 102301, "10010,18010", },
	id_1023024 = {1023024, "百兽甲碎片", "集齐5个碎片可以合成护甲【百兽甲】", "small_lan_hujia_J_2.png", nil, 5, 4, 1, 1, 2000, 5, nil, 0, 5, 102302, "13010,22010", },
	id_1023034 = {1023034, "狻猊铠甲碎片", "集齐5个碎片可以合成护甲【狻猊铠甲】", "small_lan_hujia_J_3.png", nil, 5, 4, 1, 1, 2000, 5, nil, 0, 5, 102303, "17010", },
	id_1023044 = {1023044, "紫3武器碎片", "集齐5个碎片可以合成护甲【紫3武器】", "small_lan_hujia_J_4.png", nil, 5, 4, 1, 1, 2000, 5, nil, 0, 5, 102304, nil, },
	id_1023124 = {1023124, "七绝兽甲碎片", "集齐5个碎片可以合成护甲【七绝兽甲】", "small_lan_hujia_T_1.png", nil, 5, 4, 1, 1, 2000, 5, nil, 0, 5, 102312, nil, },
	id_1023224 = {1023224, "龙鸣战袍碎片", "集齐5个碎片可以合成护甲【龙鸣战袍】", "small_lan_hujia_T_2.png", nil, 5, 4, 1, 1, 2000, 5, nil, 0, 5, 102322, nil, },
	id_1024015 = {1024015, "玄刺磐炎甲碎片", "集齐10个碎片可以合成护甲【玄刺磐炎甲】", "small_zi_hujia_J_1.png", nil, 5, 5, 1, 1, 2500, 10, nil, 0, 10, 102401, "27010,28010,29010", },
	id_1024025 = {1024025, "蚩尤神皇甲碎片", "集齐10个碎片可以合成护甲【蚩尤神皇甲】", "small_zi_hujia_J_2.png", nil, 5, 5, 1, 1, 2500, 10, nil, 0, 10, 102402, "36010,37010,38010", },
	id_1024035 = {1024035, "雷兽环甲碎片", "集齐10个碎片可以合成护甲【雷兽环甲】", "small_zi_hujia_J_3.png", nil, 5, 5, 1, 1, 2500, 10, nil, 0, 10, 102403, "45010,46010,47010,52010", },
	id_1024045 = {1024045, "尚武战铠碎片", "集齐10个碎片可以合成护甲【尚武战铠】", "small_zi_hujia_J_4.png", nil, 5, 5, 1, 1, 2500, 10, nil, 0, 10, 102404, nil, },
	id_1024125 = {1024125, "金龙云铠碎片", "集齐10个碎片可以合成护甲【金龙云铠】", "small_zi_hujia_T_1.png", nil, 5, 5, 1, 1, 2500, 10, nil, 0, 10, 102412, nil, },
	id_1024235 = {1024235, "裂天蚀阴铠碎片", "集齐10个碎片可以合成护甲【裂天蚀阴铠】", "small_zi_hujia_T_2.png", nil, 5, 5, 1, 1, 2500, 10, nil, 0, 10, 102423, nil, },
	id_1033014 = {1033014, "牛魔面甲碎片", "集齐5个碎片可以合成头盔【牛魔面甲】", "small_lan_toukui_J_1.png", nil, 5, 4, 1, 1, 2000, 5, nil, 0, 5, 103301, "9010,21010", },
	id_1033024 = {1033024, "雁回金盔碎片", "集齐5个碎片可以合成头盔【雁回金盔】", "small_lan_toukui_J_2.png", nil, 5, 4, 1, 1, 2000, 5, nil, 0, 5, 103302, "12010,16010", },
	id_1033034 = {1033034, "虚空纶巾碎片", "集齐5个碎片可以合成头盔【虚空纶巾】", "small_lan_toukui_J_3.png", nil, 5, 4, 1, 1, 2000, 5, nil, 0, 5, 103303, "20010", },
	id_1033044 = {1033044, "紫3武器碎片", "集齐5个碎片可以合成头盔【紫3武器】", "small_lan_toukui_J_4.png", nil, 5, 4, 1, 1, 2000, 5, nil, 0, 5, 103304, nil, },
	id_1033124 = {1033124, "七绝灵盔碎片", "集齐5个碎片可以合成头盔【七绝灵盔】", "small_lan_toukui_T_1.png", nil, 5, 4, 1, 1, 2000, 5, nil, 0, 5, 103312, nil, },
	id_1033224 = {1033224, "龙鸣斗盔碎片", "集齐5个碎片可以合成头盔【龙鸣斗盔】", "small_lan_toukui_T_2.png", nil, 5, 4, 1, 1, 2000, 5, nil, 0, 5, 103322, nil, },
	id_1034015 = {1034015, "狂战面甲碎片", "集齐10个碎片可以合成头盔【狂战面甲】", "small_zi_toukui_J_1.png", nil, 5, 5, 1, 1, 2500, 10, nil, 0, 10, 103401, "24010,25010,26010", },
	id_1034025 = {1034025, "金鳞碧眼盔碎片", "集齐10个碎片可以合成头盔【金鳞碧眼盔】", "small_zi_toukui_J_2.png", nil, 5, 5, 1, 1, 2500, 10, nil, 0, 10, 103402, "33010,34010,35010", },
	id_1034035 = {1034035, "炎神朱羽盔碎片", "集齐10个碎片可以合成头盔【炎神朱羽盔】", "small_zi_toukui_J_3.png", nil, 5, 5, 1, 1, 2500, 10, nil, 0, 10, 103403, "42010,43010,44010,51010", },
	id_1034045 = {1034045, "紫4头盔碎片", "集齐10个碎片可以合成头盔【紫4头盔】", "small_zi_toukui_J_4.png", nil, 5, 5, 1, 1, 2500, 10, nil, 0, 10, 103404, nil, },
	id_1034125 = {1034125, "金龙云盔碎片", "集齐10个碎片可以合成头盔【金龙云盔】", "small_zi_toukui_T_1.png", nil, 5, 5, 1, 1, 2500, 10, nil, 0, 10, 103412, nil, },
	id_1034235 = {1034235, "裂天凤纹盔碎片", "集齐10个碎片可以合成头盔【裂天凤纹盔】", "small_zi_toukui_T_2.png", nil, 5, 5, 1, 1, 2500, 10, nil, 0, 10, 103423, nil, },
	id_1043014 = {1043014, "碧纹琥珀碎片", "集齐5个碎片可以合成项链【碧纹琥珀】", "small_lan_xianglian_J_1.png", nil, 5, 4, 1, 1, 2000, 5, nil, 0, 5, 104301, nil, },
	id_1043024 = {1043024, "誓盟项链碎片", "集齐5个碎片可以合成项链【誓盟项链】", "small_lan_xianglian_J_2.png", nil, 5, 4, 1, 1, 2000, 5, nil, 0, 5, 104302, nil, },
	id_1043034 = {1043034, "琉璃巫环碎片", "集齐5个碎片可以合成项链【琉璃巫环】", "small_lan_xianglian_J_3.png", nil, 5, 4, 1, 1, 2000, 5, nil, 0, 5, 104303, nil, },
	id_1043044 = {1043044, "紫3武器碎片", "集齐5个碎片可以合成项链【紫3武器】", "small_lan_xianglian_J_4.png", nil, 5, 4, 1, 1, 2000, 5, nil, 0, 5, 104304, nil, },
	id_1043124 = {1043124, "七绝龙环碎片", "集齐5个碎片可以合成项链【七绝龙环】", "small_lan_xianglian_T_1.png", nil, 5, 4, 1, 1, 2000, 5, nil, 0, 5, 104312, nil, },
	id_1043224 = {1043224, "龙鸣圣环碎片", "集齐5个碎片可以合成项链【龙鸣圣环】", "small_lan_xianglian_T_2.png", nil, 5, 4, 1, 1, 2000, 5, nil, 0, 5, 104322, nil, },
	id_1044015 = {1044015, "巫山虹宇碎片", "集齐10个碎片可以合成项链【巫山虹宇】", "small_zi_xianglian_J_1.png", nil, 5, 5, 1, 1, 2500, 10, nil, 0, 10, 104401, nil, },
	id_1044025 = {1044025, "天云霞链碎片", "集齐10个碎片可以合成项链【天云霞链】", "small_zi_xianglian_J_2.png", nil, 5, 5, 1, 1, 2500, 10, nil, 0, 10, 104402, nil, },
	id_1044035 = {1044035, "月霞流云碎片", "集齐10个碎片可以合成项链【月霞流云】", "small_zi_xianglian_J_3.png", nil, 5, 5, 1, 1, 2500, 10, nil, 0, 10, 104403, nil, },
	id_1044045 = {1044045, "紫4项链碎片", "集齐10个碎片可以合成项链【紫4项链】", "small_zi_xianglian_J_4.png", nil, 5, 5, 1, 1, 2500, 10, nil, 0, 10, 104404, nil, },
	id_1044125 = {1044125, "金龙风铃碎片", "集齐10个碎片可以合成项链【金龙风铃】", "small_zi_xianglian_T_1.png", nil, 5, 5, 1, 1, 2500, 10, nil, 0, 10, 104412, nil, },
	id_1044235 = {1044235, "裂天惊鸿碎片", "集齐10个碎片可以合成项链【裂天惊鸿】", "small_zi_xianglian_T_2.png", nil, 5, 5, 1, 1, 2500, 10, nil, 0, 10, 104423, nil, },
	id_1800025 = {1800025, "帝王新装碎片", "20001|集齐10个碎片可以合成时装【帝王新装】,20002|集齐10个碎片可以合成时装【女王新装】", "20001|small_nanzhu_shizhuang_2.png,20002|small_nvzhu_shizhuang_2.png", nil, 5, 5, 0, 1, 5000, 10, nil, 0, 10, 80002, nil, },
	id_1014515 = {1014515, "宝马魔锤碎片", "集齐10个碎片可以合成【宝马魔锤】", "small_zi_wuqi_T_5.png", nil, 5, 5, 1, 1, 2500, 10, nil, 0, 10, 101451, nil, },
	id_1024515 = {1024515, "宝马兽甲碎片", "集齐10个碎片可以合成【宝马兽甲】", "small_zi_hujia_T_5.png", nil, 5, 5, 1, 1, 2500, 10, nil, 0, 10, 102451, nil, },
	id_1034515 = {1034515, "宝马灵盔碎片", "集齐10个碎片可以合成【宝马灵盔】", "small_zi_toukui_T_5.png", nil, 5, 5, 1, 1, 2500, 10, nil, 0, 10, 103451, nil, },
	id_1044515 = {1044515, "宝马金坠碎片", "集齐10个碎片可以合成【宝马金坠】", "small_zi_xianglian_T_5.png", nil, 5, 5, 1, 1, 2500, 10, nil, 0, 10, 104451, nil, },
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
	local id_data = Item_fragment["id_" .. key_id]
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
	for k, v in pairs(Item_fragment) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Item_fragment"] = nil
	package.loaded["DB_Item_fragment"] = nil
	package.loaded["db/DB_Item_fragment"] = nil
end

