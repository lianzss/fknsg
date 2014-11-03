-- Filename: DB_Npcheader.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Npcheader", package.seeall)

keys = {
	"id", "body_image", "position_x", "position_y", 
}

Npcheader = {
	id_1 = {1, "quan_jiang_zhangliao.png", 150, 150, },
	id_2 = {2, "quan_jiang_zhanghe.png", 125, 100, },
	id_3 = {3, "quan_jiang_xuhuang.png", 100, 120, },
	id_4 = {4, "quan_jiang_xiahoudun.png", 150, 120, },
	id_5 = {5, "quan_jiang_simayi.png", 100, 120, },
	id_6 = {6, "quan_jiang_dianwei.png", 150, 120, },
	id_7 = {7, "quan_jiang_guojia.png", 100, 120, },
	id_8 = {8, "quan_jiang_caocao.png", 150, 120, },
	id_9 = {9, "quan_jiang_xuchu.png", 100, 120, },
	id_10 = {10, "quan_jiang_zhenji.png", 100, 120, },
	id_11 = {11, "quan_jiang_caiwenji.png", 100, 120, },
	id_12 = {12, "quan_jiang_caopei.png", 100, 120, },
	id_13 = {13, "quan_jiang_caoren.png", 100, 120, },
	id_14 = {14, "quan_jiang_zhangchunhua.png", 100, 120, },
	id_15 = {15, "quan_jiang_wenpin.png", 100, 120, },
	id_16 = {16, "quan_jiang_manchong.png", 100, 120, },
	id_17 = {17, "quan_jiang_lidian.png", 100, 120, },
	id_18 = {18, "quan_jiang_lejin.png", 100, 120, },
	id_19 = {19, "quan_jiang_xuyou.png", 125, 120, },
	id_20 = {20, "quan_jiang_yujin.png", 100, 120, },
	id_21 = {21, "quan_jiang_xunyou.png", 100, 120, },
	id_22 = {22, "quan_jiang_caohong.png", 100, 120, },
	id_23 = {23, "quan_jiang_caoang.png", 100, 120, },
	id_24 = {24, "quan_jiang_xinxianying.png", 100, 120, },
	id_25 = {25, "quan_jiang_bianshi.png", 100, 120, },
	id_26 = {26, "quan_jiang_heshi.png", 100, 120, },
	id_27 = {27, "quan_jiang_guoshi.png", 100, 120, },
	id_28 = {28, "quan_jiang_zoushi.png", 125, 100, },
	id_29 = {29, "quan_jiang_caojie.png", 125, 140, },
	id_30 = {30, "quan_jiang_wujiang3.png", 125, 120, },
	id_31 = {31, "quan_jiang_wujiang1.png", 100, 120, },
	id_32 = {32, "quan_jiang_wenguan2.png", 125, 120, },
	id_33 = {33, "quan_jiang_wenguan5.png", 125, 120, },
	id_34 = {34, "quan_jiang_wujiang4.png", 100, 120, },
	id_35 = {35, "quan_jiang_guanyu.png", 150, 100, },
	id_36 = {36, "quan_jiang_huangzhong.png", 100, 120, },
	id_37 = {37, "quan_jiang_jiangwei.png", 100, 120, },
	id_38 = {38, "quan_jiang_liubei.png", 150, 110, },
	id_39 = {39, "quan_jiang_machao.png", 100, 120, },
	id_40 = {40, "quan_jiang_weiyan.png", 100, 120, },
	id_41 = {41, "quan_jiang_zhangfei.png", 150, 120, },
	id_42 = {42, "quan_jiang_zhaoyun.png", 100, 125, },
	id_43 = {43, "quan_jiang_zhugeliang.png", 100, 120, },
	id_44 = {44, "quan_jiang_huangyueying.png", 100, 120, },
	id_45 = {45, "quan_jiang_menghuo.png", 100, 120, },
	id_46 = {46, "quan_jiang_zhurong.png", 100, 120, },
	id_47 = {47, "quan_jiang_xushu.png", 100, 120, },
	id_48 = {48, "quan_jiang_guanyinping.png", 100, 120, },
	id_49 = {49, "quan_jiang_zhangxingcai.png", 100, 120, },
	id_50 = {50, "quan_jiang_madai.png", 100, 120, },
	id_51 = {51, "quan_jiang_zhoucang.png", 100, 120, },
	id_52 = {52, "quan_jiang_guanxing.png", 100, 120, },
	id_53 = {53, "quan_jiang_guanping.png", 100, 120, },
	id_54 = {54, "quan_jiang_zhangbao.png", 100, 120, },
	id_55 = {55, "quan_jiang_xiahoushi.png", 100, 120, },
	id_56 = {56, "quan_jiang_mifuren.png", 125, 120, },
	id_57 = {57, "quan_jiang_caifuren.png", 100, 120, },
	id_58 = {58, "quan_jiang_dazhanghuanghou.png", 100, 120, },
	id_59 = {59, "quan_jiang_ganfuren.png", 125, 120, },
	id_60 = {60, "quan_jiang_sunjian.png", 100, 120, },
	id_61 = {61, "quan_jiang_zhouyu.png", 100, 120, },
	id_62 = {62, "quan_jiang_taishici.png", 100, 120, },
	id_63 = {63, "quan_jiang_sunquan.png", 100, 120, },
	id_64 = {64, "quan_jiang_sunce.png", 100, 120, },
	id_65 = {65, "quan_jiang_lvmeng.png", 100, 120, },
	id_66 = {66, "quan_jiang_luxun.png", 100, 120, },
	id_67 = {67, "quan_jiang_lusu.png", 100, 120, },
	id_68 = {68, "quan_jiang_ganning.png", 100, 120, },
	id_69 = {69, "quan_jiang_xiaoqiao.png", 100, 120, },
	id_70 = {70, "quan_jiang_daqiao.png", 100, 120, },
	id_71 = {71, "quan_jiang_sunshangxiang.png", 100, 120, },
	id_72 = {72, "quan_jiang_huanggai.png", 125, 140, },
	id_73 = {73, "quan_jiang_zhoutai.png", 100, 120, },
	id_74 = {74, "quan_jiang_zhangzhao.png", 100, 120, },
	id_75 = {75, "quan_jiang_lingtong.png", 100, 120, },
	id_76 = {76, "quan_jiang_bulianshi.png", 100, 120, },
	id_77 = {77, "quan_jiang_zhugejin.png", 100, 120, },
	id_78 = {78, "quan_jiang_xusheng.png", 100, 120, },
	id_79 = {79, "quan_jiang_lukang.png", 100, 120, },
	id_80 = {80, "quan_jiang_chengpu.png", 125, 120, },
	id_81 = {81, "quan_jiang_wuguotai.png", 100, 120, },
	id_82 = {82, "quan_jiang_sunluyu.png", 100, 120, },
	id_83 = {83, "quan_jiang_sunluban.png", 100, 120, },
	id_84 = {84, "quan_jiang_wujiang1.png", 100, 120, },
	id_85 = {85, "quan_jiang_lvbu.png", 150, 120, },
	id_86 = {86, "quan_jiang_wenchou.png", 125, 120, },
	id_87 = {87, "quan_jiang_yanliang.png", 125, 120, },
	id_88 = {88, "quan_jiang_chendeng.png", 125, 120, },
	id_89 = {89, "quan_jiang_chengong.png", 125, 110, },
	id_90 = {90, "quan_jiang_diaochan.png", 125, 120, },
	id_91 = {91, "quan_jiang_dongzhuo.png", 150, 120, },
	id_92 = {92, "quan_jiang_zhangjiao.png", 125, 120, },
	id_93 = {93, "quan_jiang_jiaxu.png", 125, 110, },
	id_94 = {94, "quan_jiang_zuoci.png", 125, 120, },
	id_95 = {95, "quan_jiang_gaoshun.png", 125, 120, },
	id_96 = {96, "quan_jiang_huaxiong.png", 125, 120, },
	id_97 = {97, "quan_jiang_huatuo.png", 100, 120, },
	id_98 = {98, "quan_jiang_yuji.png", 125, 120, },
	id_99 = {99, "quan_jiang_dingyuan.png", 100, 120, },
	id_100 = {100, "quan_jiang_huangfusong.png", 100, 120, },
	id_101 = {101, "quan_jiang_liru.png", 125, 120, },
	id_102 = {102, "quan_jiang_jiling.png", 125, 120, },
	id_103 = {103, "quan_jiang_liubiao.png", 125, 120, },
	id_104 = {104, "quan_jiang_yuanshao.png", 125, 120, },
	id_105 = {105, "quan_jiang_yuanshu.png", 125, 120, },
	id_106 = {106, "quan_jiang_zhangbao_1.png", 125, 110, },
	id_107 = {107, "quan_jiang_chunyuqiong.png", 125, 130, },
	id_108 = {108, "quan_jiang_yuanshang.png", 125, 120, },
	id_109 = {109, "quan_jiang_lisu.png", 100, 120, },
	id_110 = {110, "quan_jiang_luzhi.png", 100, 120, },
	id_111 = {111, "quan_jiang_zhangxiu.png", 125, 120, },
	id_112 = {112, "quan_jiang_wujiang7.png", 100, 120, },
	id_113 = {113, "quan_jiang_wangyun.png", 125, 120, },
	id_114 = {114, "quan_jiang_wenguan6.png", 100, 120, },
	id_115 = {115, "quan_jiang_wujiang5.png", 100, 120, },
	id_116 = {116, "quan_jiang_wujiang1.png", 100, 120, },
	id_117 = {117, "quan_jiang_wujiang2.png", 100, 120, },
	id_118 = {118, "quan_jiang_wujiang3.png", 100, 120, },
	id_119 = {119, "quan_jiang_wujiang4.png", 125, 130, },
	id_120 = {120, "quan_jiang_wenguan4.png", 100, 120, },
	id_121 = {121, "quan_jiang_wujiang1.png", 100, 120, },
	id_122 = {122, "quan_jiang_wujiang2.png", 125, 120, },
	id_123 = {123, "quan_jiang_wujiang3.png", 100, 120, },
	id_124 = {124, "quan_jiang_wenguan1.png", 100, 120, },
	id_125 = {125, "quan_jiang_wujiang5.png", 125, 120, },
	id_126 = {126, "quan_jiang_wujiang2.png", 125, 120, },
	id_127 = {127, "quan_jiang_wujiang3.png", 125, 120, },
	id_128 = {128, "quan_jiang_wujiang4.png", 125, 120, },
	id_129 = {129, "quan_jiang_wujiang1.png", 125, 120, },
	id_130 = {130, "quan_jiang_wenguan4.png", 125, 120, },
	id_131 = {131, "quan_jiang_wenguan2.png", 100, 120, },
	id_132 = {132, "quan_jiang_wujiang5.png", 125, 120, },
	id_133 = {133, "quan_jiang_wujiang5.png", 125, 120, },
	id_134 = {134, "quan_jiang_wujiang3.png", 100, 120, },
	id_135 = {135, "quan_jiang_wenguan3.png", 125, 120, },
	id_136 = {136, "quan_jiang_wujiang2.png", 125, 120, },
	id_137 = {137, "quan_jiang_wujiang3.png", 125, 120, },
	id_138 = {138, "quan_jiang_wenguan3.png", 125, 120, },
	id_139 = {139, "quan_jiang_wujiang4.png", 100, 120, },
	id_140 = {140, "quan_jiang_wujiang1.png", 125, 120, },
	id_141 = {141, "quan_jiang_wujiang2.png", 100, 120, },
	id_142 = {142, "quan_jiang_wenguan5.png", 100, 120, },
	id_143 = {143, "quan_jiang_wujiang3.png", 100, 120, },
	id_144 = {144, "quan_jiang_wenguan2.png", 125, 120, },
	id_145 = {145, "quan_jiang_wujiang1.png", 100, 120, },
	id_146 = {146, "quan_jiang_wenguan1.png", 125, 120, },
	id_147 = {147, "quan_jiang_wujiang4.png", 100, 120, },
	id_148 = {148, "quan_jiang_mowang_1.png", 150, 140, },
	id_149 = {149, "quan_jiang_mowang.png", 100, 140, },
	id_150 = {150, "quan_jiang_xiaotao.png", 100, 100, },
	id_151 = {151, "quan_jiang_mozhangjiao.png", 150, 120, },
	id_152 = {152, "quan_jiang_modongzhuo.png", 150, 120, },
	id_153 = {153, "quan_jiang_molvbu.png", 100, 120, },
	id_154 = {154, "quan_jiang_yuanshu.png", 100, 120, },
	id_155 = {155, "quan_jiang_zhangxiu.png", 100, 120, },
	id_156 = {156, "quan_jiang_sunjian.png", 100, 120, },
	id_157 = {157, "quan_jiang_yuanshao.png", 150, 120, },
	id_160 = {160, "quan_bin_mowangbing.png", 100, 120, },
	id_161 = {161, "quan_jiang_nanzhu.png", 125, 120, },
	id_162 = {162, "quan_jiang_nvzhu.png", 125, 120, },
	id_163 = {163, "quan_jiang_wenguan3.png", 125, 120, },
	id_164 = {164, "quan_jiang_nanzhu2.png", 125, 120, },
	id_165 = {165, "quan_jiang_nvzhu2.png", 125, 120, },
	id_166 = {166, "quan_jiang_zhuyi.png", 125, 120, },
	id_167 = {167, "quan_jiang_caimao.png", 125, 120, },
	id_168 = {168, "quan_jiang_guansuo.png", 125, 120, },
	id_169 = {169, "quan_jiang_jianggan.png", 125, 120, },
	id_170 = {170, "quan_jiang_feiyi.png", 125, 120, },
	id_171 = {171, "quan_jiang_wujiang4.png", 125, 120, },
	id_172 = {172, "quan_jiang_yanyan.png", 125, 120, },
	id_173 = {173, "quan_jiang_xiahouyuan.png", 125, 120, },
	id_174 = {174, "quan_jiang_wujiang2.png", 125, 120, },
	id_175 = {175, "quan_jiang_wujiang3.png", 125, 120, },
	id_176 = {176, "quan_jiang_simazhao.png", 125, 120, },
	id_177 = {177, "quan_jiang_wenyang.png", 125, 120, },
	id_178 = {178, "quan_jiang_wenguan4.png", 125, 120, },
	id_179 = {179, "quan_jiang_xunyu.png", 125, 120, },
	id_180 = {180, "quan_jiang_wenguan5.png", 125, 120, },
	id_181 = {181, "quan_jiang_dengai.png", 125, 120, },
	id_182 = {182, "quan_jiang_liaohua.png", 125, 120, },
	id_183 = {183, "quan_jiang_pangde.png", 125, 120, },
	id_184 = {184, "quan_jiang_maliang.png", 125, 120, },
	id_185 = {185, "quan_jiang_zhugeke.png", 125, 120, },
	id_186 = {186, "quan_jiang_wujiang4.png", 125, 120, },
	id_187 = {187, "quan_jiang_pangtong.png", 125, 120, },
	id_188 = {188, "quan_jiang_xunyu.png", 125, 120, },
	id_189 = {189, "quan_jiang_guyong.png", 125, 120, },
	id_190 = {190, "quan_jiang_wujiang2.png", 125, 120, },
	id_191 = {191, "quan_jiang_zhuhuan.png", 125, 120, },
	id_192 = {192, "quan_jiang_shuijingxiansheng.png", 125, 120, },
	id_193 = {193, "quan_jiang_mateng.png", 125, 120, },
	id_194 = {194, "quan_jiang_gongsunzan.png", 125, 120, },
	id_195 = {195, "quan_jiang_zhangzhongjing.png", 125, 120, },
	id_196 = {196, "quan_bin_hubaoqi.png", 125, 120, },
	id_197 = {197, "quan_jiang_wujiang4.png", 125, 120, },
	id_198 = {198, "quan_jiang_liuxie.png", 125, 120, },
	id_199 = {199, "quan_jiang_nanhualaoxian.png", 125, 120, },
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
	local id_data = Npcheader["id_" .. key_id]
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
	for k, v in pairs(Npcheader) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Npcheader"] = nil
	package.loaded["DB_Npcheader"] = nil
	package.loaded["db/DB_Npcheader"] = nil
end

