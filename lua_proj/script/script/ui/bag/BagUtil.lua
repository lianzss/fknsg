-- Filename：	BagUtil.lua
-- Author：		Cheng Liang
-- Date：		2013-9-10
-- Purpose：		物品Item

module("BagUtil", package.seeall)


require "script/utils/LuaUtil"


function getNextOpenPropGridPrice()
	local price = 0
	local bagInfo = DataCache.getRemoteBagInfo()
	if( not table.isEmpty(bagInfo)) then
		price = ((bagInfo.gridMaxNum.props - 30) / 5 + 1) * 5*5
	end 
	return price
end

function getNextOpenArmFragGridPrice()
	local price = 0
	local bagInfo = DataCache.getRemoteBagInfo()
	if( not table.isEmpty(bagInfo)) then
		price = ((bagInfo.gridMaxNum.armFrag - 50) / 5 + 1) * 5*5
	end 
	return price
end

function getNextOpenArmGridPrice()
	local price = 0
	local bagInfo = DataCache.getRemoteBagInfo()
	if( not table.isEmpty(bagInfo)) then
		price = ((bagInfo.gridMaxNum.arm - 30) / 5 + 1) * 5*5
	end
	return price
end

function getNextOpenTreasGridPrice()
	local price = 0
	local bagInfo = DataCache.getRemoteBagInfo()
	if( not table.isEmpty(bagInfo)) then
		price = ((bagInfo.gridMaxNum.treas - 30) / 5 + 1) * 5*5
	end
	return price
end

function getNextOpenDressGridPrice()
	local price = 0
	local bagInfo = DataCache.getRemoteBagInfo()
	if( not table.isEmpty(bagInfo)) then
		price = ((bagInfo.gridMaxNum.dress - 100) / 5 + 1) * 5*5
	end
	return price
end

-- 装备排序算法 （策划需求的 逆序）
function equipSort( equip_1, equip_2 )
	local isPre = false
	if( tonumber(equip_1.itemDesc.quality) < tonumber(equip_2.itemDesc.quality))then
	
		isPre = true
	elseif(tonumber(equip_1.itemDesc.quality) == tonumber(equip_2.itemDesc.quality))then
		if(tonumber(equip_1.itemDesc.type) > tonumber(equip_2.itemDesc.type))then
			isPre = true
		elseif(tonumber(equip_1.itemDesc.type) == tonumber(equip_2.itemDesc.type))then
			local t_equip_score_1 = equip_1.itemDesc.base_score + tonumber(equip_1.va_item_text.armReinforceLevel) * equip_1.itemDesc.grow_score
			local t_equip_score_2 = equip_2.itemDesc.base_score + tonumber(equip_2.va_item_text.armReinforceLevel) * equip_2.itemDesc.grow_score

			if(t_equip_score_1 < t_equip_score_2)then
				isPre = true
			else
				isPre = false
			end
		else
			isPre = false
		end
	else
		isPre = false
	end
	return isPre
end

-- 宝物排序算法
function treasSort( equip_1, equip_2 )
	local isPre = false
	if( tonumber(equip_1.itemDesc.quality) < tonumber(equip_2.itemDesc.quality))then
	
		isPre = true
	elseif(tonumber(equip_1.itemDesc.quality) == tonumber(equip_2.itemDesc.quality))then
		if(tonumber(equip_1.itemDesc.type) > tonumber(equip_2.itemDesc.type))then
			isPre = true
		elseif(tonumber(equip_1.itemDesc.type) == tonumber(equip_2.itemDesc.type))then
			local t_equip_score_1 = equip_1.itemDesc.base_score + tonumber(equip_1.va_item_text.treasureLevel) * equip_1.itemDesc.increase_score
			local t_equip_score_2 = equip_2.itemDesc.base_score + tonumber(equip_2.va_item_text.treasureLevel) * equip_2.itemDesc.increase_score

			if(t_equip_score_1 < t_equip_score_2)then
				isPre = true
			else
				isPre = false
			end
		else
			isPre = false
		end
	else
		isPre = false
	end
	return isPre
end

-- 战魂排序算法
function fightSoulSort( equip_1, equip_2 )
	local isPre = false
	if( tonumber(equip_1.itemDesc.quality) < tonumber(equip_2.itemDesc.quality))then
		isPre = true
	elseif(tonumber(equip_1.itemDesc.quality) == tonumber(equip_2.itemDesc.quality))then
		if(tonumber(equip_1.itemDesc.sort) > tonumber(equip_2.itemDesc.sort))then
			isPre = true
		elseif(tonumber(equip_1.itemDesc.sort) == tonumber(equip_2.itemDesc.sort))then
			local t_equip_lv_1 = tonumber(equip_1.va_item_text.fsLevel) 
			local t_equip_lv_2 = tonumber(equip_2.va_item_text.fsLevel)
			if(t_equip_lv_1 < t_equip_lv_2)then
				isPre = true
			elseif(t_equip_lv_1 == t_equip_lv_2)then
				if(tonumber(equip_1.item_template_id) > tonumber(equip_2.item_template_id))then
					return true
				else
					return false
				end
			else
				isPre = false
			end
		else
			isPre = false
		end
	else
		isPre = false
	end
	return isPre
end

function getPropOrderPriority( item_template_id )
	item_template_id = tonumber(item_template_id)
	local orderN = 0
	if(item_template_id >= 30001 and item_template_id <= 40000) then
		orderN = 1
	elseif(item_template_id >= 20001 and item_template_id <= 30000) then
		orderN = 2
	elseif(item_template_id >= 10001 and item_template_id <= 30000) then
		orderN = 3
	elseif(item_template_id >= 40001 and item_template_id <= 50000) then
		orderN = 4
	elseif(item_template_id >= 50001 and item_template_id <= 60000) then
		orderN = 5
	else
		orderN = 6
	end
	return orderN
end

-- 道具排序 （策划需求的 逆序）
function propsSort( item_1, item_2 )
	local order_1 = getPropOrderPriority(item_1.item_template_id)
	local order_2 = getPropOrderPriority(item_2.item_template_id)
	local isPre = false

	if(order_1 > order_2) then
		isPre = true
	elseif(order_1 == order_2)then
		if( tonumber(item_1.itemDesc.quality) < tonumber(item_2.itemDesc.quality) ) then
			isPre = true
		--为了满足开箱子位置不变的策划需求添加 add by zhang zihang
		elseif ( tonumber(item_1.itemDesc.quality) == tonumber(item_2.itemDesc.quality) ) then
			if tonumber(item_2.item_template_id) < tonumber(item_1.item_template_id) then
				isPre = true
			end
		end
	end

	return isPre
end

-- 装备碎片排序
function armFragSort( item_1, item_2 )

	local isPre = false

	if( tonumber(item_1.itemDesc.quality) < tonumber(item_2.itemDesc.quality) ) then
		isPre = true
	elseif(tonumber(item_1.itemDesc.quality) == tonumber(item_2.itemDesc.quality)) then
		if(tonumber(item_1.item_num) < tonumber(item_2.item_num))then
			isPre = true
		elseif(tonumber(item_1.item_num) == tonumber(item_2.item_num))then
			if(tonumber(item_1.item_template_id) < tonumber(item_2.item_template_id))then
				isPre = true
			end
		end
	end

	return isPre
end

-- 从背包中选出宝物
function getTreasInfosExceptGid(ex_itemId, posType)
	local bagInfo = DataCache.getBagInfo()
	local treas_bag = bagInfo.treas
	if(ex_itemId and posType)then
		local temp_treas = {}
		ex_itemId = tonumber(ex_itemId)
		for k,v in pairs(treas_bag) do
			if(tonumber(v.item_id) ~= ex_itemId and tonumber(posType) == tonumber(v.itemDesc.type))then
				table.insert(temp_treas, v)
			end
		end
		treas_bag = temp_treas
	end

	return treas_bag
end

-- 解析特定字符串 (0|100,1|200)
function parseTreasString( treas_str )
	local result_arr = {}
	local t_arr = string.split(string.gsub(treas_str, " ", ""), "," )
	for k,v in pairs(t_arr) do
		local tt_arr = string.split(string.gsub(v, " ", ""), "|" )
		result_arr[tt_arr[1]] = tonumber(tt_arr[2])
	end
	return result_arr
end

-- 计算宝物的升级概率
function getTreasUpgradeRate( item_id, m_item_ids )
	local rate = 0
	if( item_id and (not table.isEmpty(m_item_ids)) )then
		local s_total = 0
		for k, itemId in pairs(m_item_ids) do
			local itemInfo = ItemUtil.getItemInfoByItemId(tonumber(itemId))
			itemInfo.itemDesc = ItemUtil.getItemById(tonumber(itemInfo.item_template_id))
			local result_arr = parseTreasString(itemInfo.itemDesc.base_exp_arr)
			s_total = s_total + result_arr["" .. itemInfo.va_item_text.treasureLevel]
		end
		local item_Info = ItemUtil.getItemInfoByItemId(tonumber(item_id))

		if(table.isEmpty(item_Info))then
			item_Info = ItemUtil.getTreasInfoFromHeroByItemId(tonumber(item_id))
		end
		item_Info.itemDesc = ItemUtil.getItemById(tonumber(item_Info.item_template_id))
		local result_arr = parseTreasString(item_Info.itemDesc.total_upgrade_exp)
		local t_total = result_arr["" .. item_Info.va_item_text.treasureLevel]
		rate = s_total/t_total
	end
	rate = rate > 1 and 1 or rate
	
	return rate
end

-- 计算宝物的获得的经验
function getTreasAddExpBy( m_item_ids )

	local totalExp = 0
	for k, m_item_id in pairs(m_item_ids) do
		local item_Info = ItemUtil.getItemInfoByItemId(tonumber(m_item_id))

		totalExp = totalExp + ItemUtil.getBaseExpBy(item_Info.item_template_id, tonumber(item_Info.va_item_text.treasureLevel)) + tonumber(item_Info.va_item_text.treasureExp)

	end

	return totalExp
end

-- 计算宝物升级所需硬币
function getCostSliverByItemId( item_id )
	local item_Info = ItemUtil.getItemInfoByItemId(tonumber(item_id))

	if(table.isEmpty(item_Info))then
		item_Info = ItemUtil.getTreasInfoFromHeroByItemId(tonumber(item_id))
	end
	item_Info.itemDesc = ItemUtil.getItemById(tonumber(item_Info.item_template_id))
	local result_arr = parseTreasString(item_Info.itemDesc.upgrade_cost_arr)
	local costSliver = result_arr["" .. item_Info.va_item_text.treasureLevel]
	local levelLimited = item_Info.itemDesc.level_limited
	costSliver = costSliver or 0
	
	return costSliver, levelLimited
end

-- 类型对应名称
local name_text_arr = {
						 {GetLocalizeStringBy("key_2338"), GetLocalizeStringBy("key_2431"), GetLocalizeStringBy("key_1977"), GetLocalizeStringBy("key_2841") },
						 "",
						 GetLocalizeStringBy("key_1870"),
						 GetLocalizeStringBy("key_3140"),
						 GetLocalizeStringBy("key_1801"),
						 GetLocalizeStringBy("key_1870"),
						 GetLocalizeStringBy("key_3237"),
						 GetLocalizeStringBy("key_1870"),
						 GetLocalizeStringBy("key_2832"),
						 GetLocalizeStringBy("key_1870"),
						 {GetLocalizeStringBy("key_1767"), GetLocalizeStringBy("key_3093")},
						 GetLocalizeStringBy("key_1801"),
						 GetLocalizeStringBy("key_1624"),
						 GetLocalizeStringBy("key_2020"),
					   }

-- 获得某个物品的印章
function getSealSpriteByItemTempId( item_template_id )
	local name_text = nil
	if(item_template_id ~= nil)then
		local item_info = ItemUtil.getItemById(item_template_id)
		if(item_info.item_type == 1 or item_info.item_type == 11)then
			local t_name_text = name_text_arr[item_info.item_type]
			name_text = t_name_text[item_info.type]
		else
			name_text = name_text_arr[item_info.item_type]
		end
	end
	if(name_text == nil)then
		name_text = GetLocalizeStringBy("key_1870")
	end
	local nameLabel = CCLabelTTF:create(name_text, g_sFontPangWa, 24)
    nameLabel:setColor(ccc3(0xff, 0xe7, 0x64))
    nameLabel:setAnchorPoint(ccp(0.5, 0.5))
    
    
    local sealSprite = CCScale9Sprite:create("images/common/bg/seal_9s_bg.png")
    sealSprite:setContentSize(CCSizeMake( nameLabel:getContentSize().width + 10, 37))
    nameLabel:setPosition(ccp( sealSprite:getContentSize().width*0.5, sealSprite:getContentSize().height*0.5))
    sealSprite:addChild(nameLabel)

    return sealSprite
end


-------------- 添加装备碎片能合成个数提示  by licong---------------    
-- 装备碎片能合成装备的个数
function getCanCompoundNumByArmFrag( ... )
	local bagInfo = DataCache.getBagInfo()
	local  armFragData = {}
	if (bagInfo) then
		armFragData = bagInfo.armFrag
	end
	-- print(GetLocalizeStringBy("key_1398"))
	-- print_t(armFragData)
	local num = 0
	for k,v in pairs(armFragData) do
		if( tonumber(v.itemDesc.need_part_num) <= tonumber(v.item_num) )then
			num = num + 1
		end
	end
	return num
end

-- 是否显示装备按钮上红圈
function isShowTipSprite( ... )
	local num = getCanCompoundNumByArmFrag()
	if(num > 0)then
		return true
	else
		return false
	end
end

----------------------------------------------------------














