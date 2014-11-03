-- Filename: DB_Aster.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Aster", package.seeall)

keys = {
	"id", "name", "des", "icon", "coin", "star", "weight", 
}

Aster = {
	id_1 = {1, "白虎", nil, "baihu.png", 0, 1, 1000, },
	id_2 = {2, "青龙", nil, "qinglong.png", 0, 1, 1000, },
	id_3 = {3, "朱雀", nil, "zhuque.png", 0, 1, 1000, },
	id_4 = {4, "玄武", nil, "xuanwu.png", 0, 1, 1000, },
	id_5 = {5, "天罗", nil, "tianluo.png", 0, 1, 1000, },
	id_6 = {6, "地网", nil, "diwang.png", 0, 1, 1000, },
	id_7 = {7, "贪狼", nil, "tanlang.png", 0, 1, 1000, },
	id_8 = {8, "阴错", nil, "yincuo.png", 0, 1, 1000, },
	id_9 = {9, "阳差", nil, "yangcha.png", 0, 1, 1000, },
	id_10 = {10, "五岳", nil, "wuyue.png", 0, 1, 1000, },
	id_11 = {11, "招摇", nil, "zhaoyao.png", 0, 1, 1000, },
	id_12 = {12, "碎破", nil, "suipo.png", 0, 1, 1000, },
	id_13 = {13, "天狗", nil, "tiangou.png", 0, 1, 1000, },
	id_14 = {14, "天罡", nil, "tiangang.png", 0, 1, 1000, },
	id_15 = {15, "地魁", nil, "dikui.png", 0, 1, 1000, },
	id_16 = {16, "恶煞", nil, "esha.png", 0, 1, 1000, },
	id_17 = {17, "吉耀", nil, "jiyao.png", 0, 1, 1000, },
	id_18 = {18, "昊天", nil, "haotian.png", 0, 1, 1000, },
	id_19 = {19, "破军", nil, "pojun.png", 0, 1, 1000, },
	id_20 = {20, "天马", nil, "tianma.png", 0, 1, 1000, },
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
	local id_data = Aster["id_" .. key_id]
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
	for k, v in pairs(Aster) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Aster"] = nil
	package.loaded["DB_Aster"] = nil
	package.loaded["db/DB_Aster"] = nil
end

