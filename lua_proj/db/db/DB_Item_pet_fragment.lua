-- Filename: DB_Item_pet_fragment.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Item_pet_fragment", package.seeall)

keys = {
	"id", "name", "desc", "itemSmall", "itemBig", "quality", "sellable", "sellType", "sellNum", "maxStacking", "canDestroy", "need_part_num", "aimPet", 
}

Item_pet_fragment = {
	id_6000001 = {6000001, "烈焰马精华", "集齐10个可合成烈焰马。最多领悟3个蓝色技能。技能等级上限：6（可锁定2个技能）", "pet_head_zaoma.png", nil, 3, 0, nil, nil, 10, nil, 10, 1, },
	id_6000002 = {6000002, "火羽神鹰精华", "集齐15个可合成火羽神鹰。最多领悟4个蓝色技能。技能等级上限：6（可锁定2个技能）", "pet_head_huoying.png", nil, 4, 0, nil, nil, 15, nil, 15, 2, },
	id_6000003 = {6000003, "三尾灵狐精华", "集齐15个可合成三尾灵狐。最多领悟4个蓝色技能。技能等级上限：7（可锁定2个技能）", "pet_head_huli.png", nil, 4, 0, nil, nil, 15, nil, 15, 3, },
	id_6000004 = {6000004, "霸影云虎精华", "集齐20个可合成霸影云虎。最多领悟4个蓝色技能。技能等级上限：8（可锁定2个技能）", "pet_head_laohu.png", nil, 5, 0, nil, nil, 20, nil, 20, 4, },
	id_6000005 = {6000005, "幽火冥狼精华", "集齐20个可合成幽火冥狼。最多领悟5个蓝色技能。技能等级上限：8（可锁定2个技能）", "pet_head_minglang.png", nil, 5, 0, nil, nil, 20, nil, 20, 5, },
	id_6000006 = {6000006, "青羽应龙精华", "集齐20个可合成青羽应龙。最多领悟5个紫色技能。技能等级上限：9（可锁定2个技能）", "pet_head_qinglong.png", nil, 5, 0, nil, nil, 20, nil, 20, 6, },
	id_6000007 = {6000007, "小鹿精华", nil, "pet_head_lu.png", nil, 5, 0, nil, nil, 20, nil, 20, 7, },
	id_6000008 = {6000008, "天马精华", "集齐20个可合成乾神飞马。最多领悟5个紫色技能。技能等级上限：10（可锁定2个技能）", "pet_head_tianma.png", nil, 5, 0, nil, nil, 20, nil, 20, 8, },
	id_6000009 = {6000009, "熊精华", nil, "pet_head_xiong.png", nil, 5, 0, nil, nil, 20, nil, 20, 9, },
	id_6000010 = {6000010, "狮子精华", nil, "pet_head_shizi.png", nil, 5, 0, nil, nil, 20, nil, 20, 10, },
	id_6000011 = {6000011, "麒麟精华", "集齐20个可合成六翼麒麟。最多领悟6个紫色技能。技能等级上限：11（可锁定3个技能）", "pet_head_qilin.png", nil, 5, 0, nil, nil, 20, nil, 20, 11, },
	id_6000012 = {6000012, "宠物精华", nil, "pet_head_qinglong.png", nil, 5, 0, nil, nil, 20, nil, 20, 12, },
	id_6000013 = {6000013, "宠物精华", nil, "pet_head_qinglong.png", nil, 5, 0, nil, nil, 20, nil, 20, 13, },
	id_6000014 = {6000014, "宠物精华", nil, "pet_head_qinglong.png", nil, 5, 0, nil, nil, 20, nil, 20, 14, },
	id_6000015 = {6000015, "宠物精华", nil, "pet_head_qinglong.png", nil, 5, 0, nil, nil, 20, nil, 20, 15, },
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
	local id_data = Item_pet_fragment["id_" .. key_id]
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
	for k, v in pairs(Item_pet_fragment) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Item_pet_fragment"] = nil
	package.loaded["DB_Item_pet_fragment"] = nil
	package.loaded["db/DB_Item_pet_fragment"] = nil
end

