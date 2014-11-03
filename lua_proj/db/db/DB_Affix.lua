-- Filename: DB_Affix.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Affix", package.seeall)

keys = {
	"id", "displayName", "sigleName", "type", 
}

Affix = {
	id_1 = {1, "生命", "生命", 1, },
	id_2 = {2, "物理攻击", "物理攻击", 1, },
	id_3 = {3, "法术攻击", "法术攻击", 1, },
	id_4 = {4, "物防", "物防", 1, },
	id_5 = {5, "法防", "法防", 1, },
	id_6 = {6, "统帅", "统帅", 2, },
	id_7 = {7, "武力", "武力", 2, },
	id_8 = {8, "智力", "智力", 2, },
	id_9 = {9, "攻击", "攻击", 1, },
	id_10 = {10, "必防", "必防", 1, },
	id_11 = {11, "生命", "生命", 3, },
	id_12 = {12, "物攻", "物攻", 3, },
	id_13 = {13, "法攻", "法攻", 3, },
	id_14 = {14, "物防", "物防", 3, },
	id_15 = {15, "法防", "法防", 3, },
	id_16 = {16, "统帅", "统帅", 3, },
	id_17 = {17, "武力", "武力", 3, },
	id_18 = {18, "智力", "智力", 3, },
	id_19 = {19, "攻击", "攻击", 3, },
	id_20 = {20, "必防", "必防", 3, },
	id_21 = {21, "命中率", "命中率", 3, },
	id_22 = {22, "物理伤害", "物理伤害", 3, },
	id_23 = {23, "法术伤害", "法术伤害", 3, },
	id_24 = {24, "物理免伤", "物理免伤", 3, },
	id_25 = {25, "法术免伤", "法术免伤", 3, },
	id_26 = {26, "暴击率", "暴击率", 3, },
	id_27 = {27, "格挡率", "格挡率", 3, },
	id_28 = {28, "闪避率", "闪避率", 3, },
	id_29 = {29, "最终伤害", "最终伤害", 1, },
	id_30 = {30, "最终免伤", "最终免伤", 1, },
	id_31 = {31, "属性1", "属性1", 1, },
	id_32 = {32, "属性1", "属性1", 1, },
	id_33 = {33, "属性1", "属性1", 1, },
	id_34 = {34, "属性1", "属性1", 1, },
	id_35 = {35, "属性1", "属性1", 1, },
	id_36 = {36, "属性1", "属性1", 1, },
	id_37 = {37, "属性1", "属性1", 1, },
	id_38 = {38, "属性1", "属性1", 1, },
	id_39 = {39, "属性1", "属性1", 1, },
	id_40 = {40, "属性1", "属性1", 1, },
	id_41 = {41, "属性1", "属性1", 1, },
	id_42 = {42, "属性1", "属性1", 1, },
	id_43 = {43, "属性1", "属性1", 1, },
	id_44 = {44, "属性1", "属性1", 1, },
	id_45 = {45, "属性1", "属性1", 1, },
	id_46 = {46, "属性1", "属性1", 1, },
	id_47 = {47, "属性1", "属性1", 1, },
	id_48 = {48, "属性1", "属性1", 1, },
	id_49 = {49, "初始怒气", "初始怒气", 1, },
	id_50 = {50, "属性1", "属性1", 1, },
	id_51 = {51, "最终生命", "最终生命", 1, },
	id_52 = {52, "属性1", "属性1", 1, },
	id_53 = {53, "属性1", "属性1", 1, },
	id_54 = {54, "属性1", "属性1", 1, },
	id_55 = {55, "属性1", "属性1", 1, },
	id_56 = {56, "属性1", "属性1", 1, },
	id_57 = {57, "属性1", "属性1", 1, },
	id_58 = {58, "普通攻击伤害", "普通攻击伤害", 3, },
	id_59 = {59, "普通攻击免伤", "普通攻击免伤", 3, },
	id_60 = {60, "怒气攻击伤害", "怒气攻击伤害", 3, },
	id_61 = {61, "怒气攻击免伤", "怒气攻击免伤", 3, },
	id_62 = {62, "治疗率", "治疗率", 3, },
	id_63 = {63, "被治疗率", "被治疗率", 3, },
	id_64 = {64, "属性1", "属性1", 1, },
	id_65 = {65, "属性1", "属性1", 1, },
	id_66 = {66, "属性1", "属性1", 1, },
	id_67 = {67, "破魏", "破魏", 3, },
	id_68 = {68, "破蜀", "破蜀", 3, },
	id_69 = {69, "破吴", "破吴", 3, },
	id_70 = {70, "破群", "破群", 3, },
	id_71 = {71, "抗魏", "抗魏", 3, },
	id_72 = {72, "抗蜀", "抗蜀", 3, },
	id_73 = {73, "抗吴", "抗吴", 3, },
	id_74 = {74, "抗群", "抗群", 3, },
	id_75 = {75, "暴击倍数", "暴击倍数", 3, },
	id_76 = {76, "抗暴", "抗暴", 3, },
	id_77 = {77, "破挡", "破挡", 3, },
	id_78 = {78, "系统调整攻击倍率", "系统调整攻击倍率", 3, },
	id_79 = {79, "系统调整防御倍率", "系统调整防御倍率", 3, },
	id_80 = {80, "物理穿透", "物理穿透", 1, },
	id_81 = {81, "法术穿透", "法术穿透", 1, },
	id_82 = {82, "物理抗性", "物理抗性", 1, },
	id_83 = {83, "法术抗性", "法术抗性", 1, },
	id_84 = {84, "治疗值", "治疗值", 1, },
	id_85 = {85, "被治疗值", "被治疗值", 1, },
	id_86 = {86, "灼烧伤害", "灼烧伤害", 1, },
	id_87 = {87, "中毒伤害", "中毒伤害", 1, },
	id_88 = {88, "灼烧免伤", "灼烧免伤", 1, },
	id_89 = {89, "中毒免伤", "中毒免伤", 1, },
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
	local id_data = Affix["id_" .. key_id]
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
	for k, v in pairs(Affix) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Affix"] = nil
	package.loaded["DB_Affix"] = nil
	package.loaded["db/DB_Affix"] = nil
end
