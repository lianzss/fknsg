-- Filename：	ItemSprite.lua
-- Author：		Cheng Liang
-- Date：		2013-7-10
-- Purpose：		物品Item

module("ItemSprite", package.seeall)


require "script/ui/item/ItemUtil"
require "script/ui/item/EquipInfoLayer"
require "script/ui/main/MainScene"
require "script/ui/item/SuitInfoLayer"
require "script/ui/item/NewTreasInfoLayer"
require "script/ui/item/TreasInfoLayer"

local _itemDelegateAction 	= nil
local _menu_priority 		= nil
local _zOrderNum 			= nil
local _info_layer_priority 	= nil
local _isRobTreasure 		= nil
local _isDisplayLevel 		= nil
--[[
	直接使用类：10001~30000
	礼包类物品：30001~40000
	随机礼包类：40001~50000
	坐骑饲料类：50001~80000
	武将技能书：80001~100000
	好感礼物类：100001~120000
	碎片类物品：120001~150000
	装备类：	  200001~230000
	宝物：	  500001~600000
	时装碎片（在装备碎片类里面）：1800000~1900000  added by zhz

--]]

-- show 装备详细信息
-- 
local function showEquipInfoLayer( template_id, item_id, isEnhance, isWater, isChange, hid_c, pos_index, p_isShowLock)


	-- 获取装备数据
	require "db/DB_Item_arm"
	local equip_desc = DB_Item_arm.getDataById(template_id)
	local equipInfoLayer = nil
	if(equip_desc.jobLimit and equip_desc.jobLimit > 0)then
		-- 套装   
		equipInfoLayer = SuitInfoLayer.createLayer(template_id,  item_id, isEnhance, isWater, isChange, _itemDelegateAction, hid_c, pos_index, _info_layer_priority,nil,p_isShowLock)
	else
		-- 非套装
		equipInfoLayer = EquipInfoLayer.createLayer(template_id,  item_id, isEnhance, isWater, isChange, _itemDelegateAction, hid_c, pos_index, _info_layer_priority,nil,p_isShowLock)
	end
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	runningScene:addChild(equipInfoLayer, _zOrderNum)
end 

-- show时装详细信息
local function showDressInfoLayer( item_template_id, item_id, isEnhance, isChange, _itemDelegateAction )
	require "script/ui/fashion/FashionInfo"
	FashionInfo.create(item_template_id,item_id, isEnhance, isChange, _itemDelegateAction)
end

-- show战魂详细信息
local function showFightSoulInfoLayer(item_template_id, item_id, isChange, hid_c, pos_index )
	require "script/ui/huntSoul/SoulInfoLayer"
	SoulInfoLayer.showLayer(item_template_id, item_id, isChange, hid_c, pos_index, _menu_priority, _zOrderNum)
end

-- tag 的组成 id ..type  1/2/3 <=> item_tmpl_id、无强化、无洗练、无更换/item_id 无更换/item_id 有更换
local function clickBtnAction( tag, itemMenu )
	-- 音效
	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
	print("tag==", tag)
	
	tag = tag .. ""
	local item_template_id  = nil
	local item_id 			= nil
	local isEnhance 		= false
	local isWater 			= false
	local isChange 			= false
	local isShowLock 		= false
	local hid_c 			= nil
	local pos_index 		= nil

	local userObject =   tolua.cast(itemMenu:getUserObject(), "CCString")
	local type_tag = tonumber(userObject:intValue())
	print("type_tag===", type_tag)

	local id = tag

	if(type_tag == 1) then
		item_template_id = tonumber(id)
	else
		
		item_id = tonumber(id)
		local itemInfo = ItemUtil.getItemInfoByItemId(item_id)
		if(itemInfo == nil) then
			-- 是否武将身上的装备
			itemInfo = ItemUtil.getEquipInfoFromHeroByItemId( item_id )
		end
		if(itemInfo == nil)then
			-- 是否武将身上的宝物
			itemInfo = ItemUtil.getTreasInfoFromHeroByItemId( item_id )
		end
		if(itemInfo == nil)then
			itemInfo = ItemUtil.getFightSoulInfoFromHeroByItemId( item_id )
		end
		if(itemInfo == nil)then
			-- 主角身上的时装
			itemInfo = ItemUtil.getFashionFromHeroByItemId( item_id )
		end
		if(not table.isEmpty(itemInfo) )then
			hid_c = itemInfo.hid
			pos_index = itemInfo.pos
		end

		item_template_id = tonumber(itemInfo.item_template_id)
		isEnhance = true
		isWater = true
		if(type_tag == 3) then
			isChange = true
		elseif(type_tag == 4)then
			isShowLock = true
		else
		end
	end

	if(item_template_id >= 100001 and item_template_id <= 200000) then
		-- 装备信息
		showEquipInfoLayer(item_template_id, item_id, isEnhance, isWater, isChange, hid_c, pos_index, isShowLock)
	elseif(item_template_id >= 500001 and item_template_id <= 600000)then
		-- 宝物信息
		local treasInfoLayer
		print(GetLocalizeStringBy("key_1552"),item_template_id)
		if ItemUtil.isExpTreasById(item_template_id,item_id) then
			print(GetLocalizeStringBy("key_2993"))
			treasInfoLayer = TreasInfoLayer.createLayer(item_template_id, item_id, isEnhance, isWater, isChange, _itemDelegateAction, hid_c, pos_index, _info_layer_priority,  nil,_isRobTreasure)
		else
			print(GetLocalizeStringBy("key_2053"))
			treasInfoLayer = NewTreasInfoLayer.createLayer(item_template_id, item_id, isEnhance, isWater, isChange, _itemDelegateAction, hid_c, pos_index, _info_layer_priority,  nil,_isRobTreasure)
		end
		-- local treasInfoLayer = TreasInfoLayer.createLayer(item_template_id, item_id, isEnhance, isWater, isChange, _itemDelegateAction, hid_c, pos_index, _info_layer_priority,  nil,_isRobTreasure)
		local runningScene = CCDirector:sharedDirector():getRunningScene()
		runningScene:addChild(treasInfoLayer, _zOrderNum)
	elseif( item_template_id >= 5000001 and item_template_id <= 6000000 )then
		-- 宝物碎片
		require "script/ui/treasure/TreasureFragmentInfoView"
		TreasureFragmentInfoView.show( item_template_id, _zOrderNum)
	elseif( item_template_id >= 1000001 and item_template_id <= 5000000 )then
		-- 装备碎片
		
		local itemInfo = ItemUtil.getItemById(item_template_id)
		-- added by zhz
		if(item_template_id>= 1800000 and item_template_id<= 1900000 ) then
			showDressInfoLayer(itemInfo.aimItem, nil, false, false)
		else
			showEquipInfoLayer(itemInfo.aimItem)
		end
	elseif(item_template_id >= 80001 and item_template_id <= 90000 )then
		-- 时装
		showDressInfoLayer(item_template_id, item_id, isEnhance, isChange,_itemDelegateAction)
	elseif(item_template_id >= 70001 and item_template_id <= 80000)then
		-- 战魂
		showFightSoulInfoLayer(item_template_id, item_id, isChange, hid_c, pos_index)
	else
		local itemData = ItemUtil.getItemById(item_template_id)
		if(itemData.item_type == 6 and itemData.choose_items ~= nil)then
			local iteTab = ItemUtil.getItemsDataByStr(itemData.choose_items)
			require "script/ui/item/ReceiveReward"
			ReceiveReward.showRewardWindow(iteTab,nil,_zOrderNum,_info_layer_priority,GetLocalizeStringBy("key_3213"))
		else
			-- 普通道具信息
			require "script/ui/item/ItemInfoLayer"
			local infoLayer = ItemInfoLayer.createItemInfoLayer(item_id, item_template_id, _info_layer_priority)
			local runningScene = CCDirector:sharedDirector():getRunningScene()
			runningScene:addChild(infoLayer, _zOrderNum)
		end
	end
	
end

-- 根据 item_tmpl_id 返回物品的icon的按钮显示,  包括装备 param menu_priority:按钮的优先级，info_layer_priority:展示界面的优先级
function getItemSpriteById( item_tmpl_id, item_id, itemDelegateAction, isNeedChangeBtn, menu_priority, zOrderNum, info_layer_priority, isRobTreasure, isDisplayLevel, enhanceLv, p_isShowLock )
	_menu_priority = menu_priority
	_itemDelegateAction = itemDelegateAction
	item_tmpl_id = tonumber(item_tmpl_id)
	print("item_tmpl_id", item_tmpl_id)
	_zOrderNum = zOrderNum or 1010
	print("_zOrderNum",_zOrderNum)
	_info_layer_priority =  info_layer_priority or _menu_priority
	_isRobTreasure = isRobTreasure
	if(isDisplayLevel == nil)then
		_isDisplayLevel = true
	else
		_isDisplayLevel = isDisplayLevel
	end
	local bgFile = nil
	local iconFile = nil

	local i_data = ItemUtil.getItemById(item_tmpl_id)

	if(item_tmpl_id >= 100001 and item_tmpl_id <= 200000) then
		-- 装备类：
		bgFile = "images/base/potential/props_" .. i_data.quality .. ".png"
		iconFile = "images/base/equip/small/" .. i_data.icon_small 
	elseif(item_tmpl_id >= 400001 and item_tmpl_id <= 500000)then
		-- 武将碎片类
		bgFile = "images/base/potential/props_" .. i_data.quality .. ".png"
		iconFile = "images/base/hero/head_icon/" .. i_data.icon_small 
	elseif(item_tmpl_id >= 500001 and item_tmpl_id <= 600000)then
		-- 宝物
		bgFile = "images/base/potential/props_" .. i_data.quality .. ".png"
		iconFile = "images/base/treas/small/" .. i_data.icon_small 

	elseif( item_tmpl_id >= 1000001 and item_tmpl_id <= 5000000 )then
		-- 装备碎片类：
		bgFile = "images/base/potential/props_" .. i_data.quality .. ".png"
		iconFile = "images/base/equip/small/" .. i_data.icon_small 
		-- added by zhz
		if(item_tmpl_id >= 1800000 and item_tmpl_id<= 1900000 ) then
			bgFile = "images/base/potential/props_" .. i_data.quality .. ".png"
			iconFile = "images/base/fashion/small/" .. getStringByFashionString(i_data.icon_small)
		end
	elseif( item_tmpl_id >= 5000001 and item_tmpl_id <= 6000000 )then
		-- 宝物碎片
		bgFile = "images/base/potential/props_" .. i_data.quality .. ".png"
		iconFile = "images/base/treas_frag/" .. i_data.icon_small 
	elseif(item_tmpl_id >= 70001 and item_tmpl_id < 80000 )then
		-- 战魂
		bgFile = "images/common/f_bg.png"
		iconFile = "images/common/f_bg.png" 
	elseif(item_tmpl_id >= 80001 and item_tmpl_id < 90000 )then
		-- 时装
		bgFile = "images/base/potential/props_" .. i_data.quality .. ".png"
		iconFile = "images/base/fashion/small/" .. getStringByFashionString(i_data.icon_small)
	elseif ( item_tmpl_id >= 6000001 and item_tmpl_id <= 7000000) then
		-- 宠物碎片
		bgFile = "images/base/potential/props_" .. i_data.quality .. ".png"
		iconFile = "images/pet/head_icon/" .. i_data.itemSmall 
	elseif ( item_tmpl_id >= 13001 and item_tmpl_id <= 14000) then
		-- 宠物碎片 added by zhz ,
		bgFile = "images/base/potential/props_" .. i_data.quality .. ".png"
		iconFile = "images/pet/head_icon/" .. i_data.icon_small
	else
		-- 道具
		bgFile = "images/base/potential/props_" .. i_data.quality .. ".png"
		iconFile = "images/base/props/" .. i_data.icon_small 
	end

	local item_sprite = CCSprite:create(bgFile)


	-- 不得已而为之
	local c_tag = 0
	local type_tag = "1"
	if(item_tmpl_id and item_tmpl_id>0)then
		c_tag = item_tmpl_id
		type_tag = "1"
	end
	if(item_id and item_id>0)then
		c_tag = item_id
		type_tag = "2"
	end
	if(isNeedChangeBtn and isNeedChangeBtn == true) then
		c_tag = item_id
		type_tag = "3"
	end
	-- 装备加锁
	if(p_isShowLock and p_isShowLock == true) then
		c_tag = item_id
		type_tag = "4"
	end

	-- added by zhz 亦是不得已为止
	if(item_tmpl_id >= 400001 and item_tmpl_id <= 500000) then
		local heroSealSp = CCSprite:create("images/common/soul_tag.png")
		heroSealSp:setAnchorPoint(ccp(0.5, 0.5))
		heroSealSp:setPosition(ccp(item_sprite:getContentSize().width*0.25, item_sprite:getContentSize().height*0.9))
		item_sprite:addChild(heroSealSp,10)
	end

	--添加宠物碎片和装备碎片标识，added by Zhang Zihang
	--宠物碎片标识
	if item_tmpl_id >= 6000001 and item_tmpl_id <= 7000000 then
		local petFragSp = CCSprite:create("images/common/petfrag_tag.png")
		petFragSp:setAnchorPoint(ccp(0.5, 0.5))
		petFragSp:setPosition(ccp(item_sprite:getContentSize().width*0.4, item_sprite:getContentSize().height*0.9))
		item_sprite:addChild(petFragSp,10)
	end

	--装备碎片标识，时装碎片也算装备碎片
	if item_tmpl_id >= 1000001 and item_tmpl_id <= 5000000 then
		local itemFragSp = CCSprite:create("images/common/itemfrag_tag.png")
		itemFragSp:setAnchorPoint(ccp(0.5, 0.5))
		itemFragSp:setPosition(ccp(item_sprite:getContentSize().width*0.4, item_sprite:getContentSize().height*0.9))
		item_sprite:addChild(itemFragSp,10)
	end

	-- 按钮Bar
	local menuBar = BTSensitiveMenu:create()
	if(menuBar:retainCount()>1)then
		menuBar:release()
		menuBar:autorelease()
	end
	menuBar:setPosition(ccp(0, 0))
	item_sprite:addChild(menuBar)
	-- 按钮
	local item_btn = CCMenuItemImage:create(iconFile,iconFile)
	item_btn:registerScriptTapHandler(clickBtnAction)
	item_btn:setAnchorPoint(ccp(0.5, 0.5))
	item_btn:setPosition(ccp(item_sprite:getContentSize().width/2, item_sprite:getContentSize().height/2))
	menuBar:addChild(item_btn, 1, tonumber(c_tag))
	item_btn:setUserObject(CCString:create(type_tag))

	if(item_tmpl_id >= 500001 and item_tmpl_id <= 600000)then
		if(item_id and item_id >0)then
				-- 宝物的精炼信息
			local evolve_level = 0
			local treas_info = ItemUtil.getTreasInfoFromHeroByItemId(item_id)
			if(table.isEmpty(treas_info))then
				local a_bagInfo = DataCache.getBagInfo()
				for k,s_data in pairs(a_bagInfo.treas) do
					if( tonumber(s_data.item_id) == item_id ) then
						treas_info = s_data
						break
					end
				end
			end

			if(treas_info and treas_info.va_item_text.treasureEvolve)then
				evolve_level = treas_info.va_item_text.treasureEvolve
			end

			local treasureEvolveLabel = CCRenderLabel:create(evolve_level,  g_sFontName , 21, 2, ccc3( 0x00, 0x00, 0x00), type_stroke)
			treasureEvolveLabel:setColor(ccc3(0x00, 0xff, 0x18))
			treasureEvolveLabel:setAnchorPoint(ccp(1, 0))
			treasureEvolveLabel:setPosition(ccp( item_sprite:getContentSize().width*0.9, item_sprite:getContentSize().height*0.05))
			item_sprite:addChild(treasureEvolveLabel)

			-- 精炼等级
			local treasureEvolveSprite = CCSprite:create("images/common/gem.png")
			treasureEvolveSprite:setAnchorPoint(ccp(1, 0))
			treasureEvolveSprite:setPosition(ccp(item_sprite:getContentSize().width*0.9 - treasureEvolveLabel:getContentSize().width, item_sprite:getContentSize().height*0.05))
			item_sprite:addChild(treasureEvolveSprite)
		end
	elseif( item_tmpl_id >= 70001 and item_tmpl_id < 80000 )then
		if( enhanceLv == nil )then
			enhanceLv = 0
		end

		-- if(item_id and item_id>0)then
			-- local fightSoulInfo = {}
			-- local a_bagInfo = DataCache.getBagInfo()
			-- if(not table.isEmpty(a_bagInfo.fightSoul) )then
			-- 	for k,s_data in pairs(a_bagInfo.fightSoul) do
			-- 		if( tonumber(s_data.item_id) == item_id ) then
			-- 			fightSoulInfo = s_data
			-- 			break
			-- 		end
			-- 	end
			-- end
			-- if(table.isEmpty(fightSoulInfo))then
			-- 	fightSoulInfo = ItemUtil.getFightSoulInfoFromHeroByItemId(item_id)
			-- end
			-- if(fightSoulInfo)then
			-- 	enhanceLv = fightSoulInfo.va_item_text.fsLevel
			-- end
		-- end
		-- local i_data = ItemUtil.getItemById(item_tmpl_id)
		if( not table.isEmpty(i_data) )then
			local s_effect = getFightSoulEffect(i_data.icon_small)
			s_effect:setPosition(ccp(item_sprite:getContentSize().width*0.5, item_sprite:getContentSize().height*0.5))
			item_sprite:addChild(s_effect, 2)
			-- local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.1),CCCallFunc:create(function ( ... )
	  --   		local s_effect = getFightSoulEffect(i_data.icon_small)
			-- 	s_effect:setPosition(ccp(item_sprite:getContentSize().width*0.5, item_sprite:getContentSize().height*0.5))
			-- 	item_sprite:addChild(s_effect, 2)
			-- end))
			-- item_sprite:runAction(seq)
			
		end

		if(_isDisplayLevel  and _isDisplayLevel == true)then
			-- 等级底
			local lvSprite = CCSprite:create("images/common/f_level_bg.png")
			lvSprite:setAnchorPoint(ccp(0,0))
			lvSprite:setPosition(ccp(item_sprite:getContentSize().width*0.5, item_sprite:getContentSize().height*0))
			item_sprite:addChild(lvSprite, 3)
			-- 等级
			local lvLabel = CCLabelTTF:create(enhanceLv,  g_sFontName , 18) --CCRenderLabel:create(enhanceLv,  g_sFontName , 18, 2, ccc3( 0x00, 0x00, 0x00), type_stroke)
			lvLabel:setColor(ccc3(0xff, 0xff, 0xff))
			lvLabel:setAnchorPoint(ccp(0.5, 0.5))
			lvLabel:setPosition(ccp( lvSprite:getContentSize().width*0.45, lvSprite:getContentSize().height*0.6))
			lvSprite:addChild(lvLabel)
		end
	elseif( item_tmpl_id >= 80001 and item_tmpl_id < 90000  )then
		-- 时装
		local e_name = "jinzhuan"
		local s_effect = getFashionEffect(e_name)
		s_effect:setPosition(ccp(item_sprite:getContentSize().width*0.5, item_sprite:getContentSize().height*0.5))
		item_sprite:addChild(s_effect)
	elseif( item_tmpl_id >= 100001 and item_tmpl_id <= 200000 )then
		-- 装备
		if(i_data.jobLimit and i_data.jobLimit>0 )then
			-- 套装
			local e_name = "lzgreen"
			if(i_data.quality == 3)then
				e_name = "lzgreen"
			elseif(i_data.quality == 4)then
				e_name = "lzpurple"
			elseif(i_data.quality == 5)then
				e_name = "lzzise"
			else
				e_name = "lzgreen"
			end

			local s_effect = getSuitEquipEffect(e_name)
			s_effect:setPosition(ccp(item_sprite:getContentSize().width*0.5, item_sprite:getContentSize().height*0.5))
			item_sprite:addChild(s_effect)

		end
	end


	if(menu_priority) then
		menuBar:setTouchPriority(menu_priority)
	end

	return item_sprite

end

-- 根据 item_tmpl_id 返回物品的icon的非按钮显示,  包括装备
function getItemSpriteByItemId( item_tmpl_id, enhanceLv, isDisplayLevel )
	if(isDisplayLevel == nil)then
		_isDisplayLevel = true
	else
		_isDisplayLevel = isDisplayLevel
	end
	enhanceLv = enhanceLv or 0
	item_tmpl_id = tonumber(item_tmpl_id)
	print("item_tmpl_id", item_tmpl_id)
	local bgFile = nil
	local iconFile = nil
	local i_data = ItemUtil.getItemById(item_tmpl_id)
	if(item_tmpl_id >= 100001 and item_tmpl_id <= 200000) then
		-- 装备类：
		bgFile = "images/base/potential/props_" .. i_data.quality .. ".png"
		iconFile = "images/base/equip/small/" .. i_data.icon_small 
	elseif(item_tmpl_id >= 400001 and item_tmpl_id <= 500000)then
		-- 武将碎片类
		bgFile = "images/base/potential/props_" .. i_data.quality .. ".png"
		iconFile = "images/base/hero/head_icon/" .. i_data.icon_small 
	elseif(item_tmpl_id >= 500001 and item_tmpl_id <= 600000)then
		-- 宝物
		bgFile = "images/base/potential/props_" .. i_data.quality .. ".png"
		iconFile = "images/base/treas/small/" .. i_data.icon_small 
	elseif( item_tmpl_id >= 1000001 and item_tmpl_id <= 5000000 )then
		-- 装备碎片类：
		bgFile = "images/base/potential/props_" .. i_data.quality .. ".png"
		iconFile = "images/base/equip/small/" .. i_data.icon_small 

		if(item_tmpl_id >= 1800000 and item_tmpl_id<= 1900000 ) then
			bgFile = "images/base/potential/props_" .. i_data.quality .. ".png"
			iconFile = "images/base/fashion/small/" .. getStringByFashionString(i_data.icon_small)
		end
	elseif( item_tmpl_id >= 5000001 and item_tmpl_id <= 6000000 )then
		-- 宝物碎片
		bgFile = "images/base/potential/props_" .. i_data.quality .. ".png"
		iconFile = "images/base/treas_frag/" .. i_data.icon_small 
	elseif(item_tmpl_id >= 70001 and item_tmpl_id < 80000 )then
		-- 战魂
		bgFile = "images/common/f_bg.png"
		iconFile = "images/common/f_bg.png" 
	elseif(item_tmpl_id >= 80001 and item_tmpl_id < 90000 )then
		-- 时装
		bgFile = "images/base/potential/props_" .. i_data.quality .. ".png"
		iconFile = "images/base/fashion/small/" .. getStringByFashionString(i_data.icon_small )
	elseif ( item_tmpl_id >= 6000001 and item_tmpl_id <= 7000000) then
		-- 宠物碎片 added by zhz ,
		bgFile = "images/base/potential/props_" .. i_data.quality .. ".png"
		iconFile = "images/pet/head_icon/" .. i_data.itemSmall 
	elseif ( item_tmpl_id >= 13001 and item_tmpl_id <= 14000) then
		-- 宠物碎片 added by zhz ,
		bgFile = "images/base/potential/props_" .. i_data.quality .. ".png"
		iconFile = "images/pet/head_icon/" .. i_data.icon_small 
	else
		bgFile = "images/base/potential/props_" .. i_data.quality .. ".png"
		iconFile = "images/base/props/" .. i_data.icon_small 
	end

	local item_sprite = CCSprite:create(bgFile)

		-- added by zhz 亦是不得已为止
	if(item_tmpl_id >= 400001 and item_tmpl_id <= 500000) then
		local heroSealSp = CCSprite:create("images/common/soul_tag.png")
		heroSealSp:setAnchorPoint(ccp(0.5, 0.5))
		heroSealSp:setPosition(ccp(item_sprite:getContentSize().width*0.25, item_sprite:getContentSize().height*0.9))
		item_sprite:addChild(heroSealSp,10)
	end
	-- 物品头像
	local icon_sprite = CCSprite:create(iconFile)
	icon_sprite:setAnchorPoint(ccp(0.5, 0.5))
	icon_sprite:setPosition(ccp(item_sprite:getContentSize().width/2, item_sprite:getContentSize().height/2))	
	item_sprite:addChild(icon_sprite)
	
	if( item_tmpl_id >= 70001 and item_tmpl_id < 80000 )then
		-- 战魂
		local i_data = ItemUtil.getItemById(item_tmpl_id)
		if( not table.isEmpty(i_data) )then
			local s_effect = getFightSoulEffect(i_data.icon_small)
			s_effect:setPosition(ccp(item_sprite:getContentSize().width*0.5, item_sprite:getContentSize().height*0.5))
			item_sprite:addChild(s_effect)
			-- local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.1),CCCallFunc:create(function ( ... )
	  --   		local s_effect = getFightSoulEffect(i_data.icon_small)
			-- 	s_effect:setPosition(ccp(item_sprite:getContentSize().width*0.5, item_sprite:getContentSize().height*0.5))
			-- 	item_sprite:addChild(s_effect,2)
			-- end))
			-- item_sprite:runAction(seq)
		end
		if(_isDisplayLevel  and _isDisplayLevel == true)then
			-- 等级底
			local lvSprite = CCSprite:create("images/common/f_level_bg.png")
			lvSprite:setAnchorPoint(ccp(0,0))
			lvSprite:setPosition(ccp(item_sprite:getContentSize().width*0.5, item_sprite:getContentSize().height*0))
			item_sprite:addChild(lvSprite,3)

			-- 等级
			local lvLabel = CCLabelTTF:create(enhanceLv,  g_sFontName , 18)  -- CCRenderLabel:create(enhanceLv,  g_sFontName , 18, 2, ccc3( 0x00, 0x00, 0x00), type_stroke)
			lvLabel:setColor(ccc3(0xff, 0xff, 0xff))
			lvLabel:setAnchorPoint(ccp(0.5, 0.5))
			lvLabel:setPosition(ccp( lvSprite:getContentSize().width*0.45, lvSprite:getContentSize().height*0.6))
			lvSprite:addChild(lvLabel)
		end
	elseif( item_tmpl_id >= 80001 and item_tmpl_id < 90000  )then
		-- 时装
		local e_name = "jinzhuan"
		local s_effect = getFashionEffect(e_name)
		s_effect:setPosition(ccp(item_sprite:getContentSize().width*0.5, item_sprite:getContentSize().height*0.5))
		item_sprite:addChild(s_effect)
	elseif( item_tmpl_id >= 100001 and item_tmpl_id <= 200000 )then
		-- 装备
		if(i_data.jobLimit and i_data.jobLimit>0 )then
			-- 套装
			local e_name = "lzgreen"
			if(i_data.quality == 3)then
				e_name = "lzgreen"
			elseif(i_data.quality == 4)then
				e_name = "lzpurple"
			elseif(i_data.quality == 5)then
				e_name = "lzzise"
			else
				e_name = "lzgreen"
			end

			local s_effect = getSuitEquipEffect(e_name)
			s_effect:setPosition(ccp(item_sprite:getContentSize().width*0.5, item_sprite:getContentSize().height*0.5))
			item_sprite:addChild(s_effect)

		end
	end
	

	return item_sprite
end

-- 套装的特效
function getSuitEquipEffect( e_name )
	local spellEffectSprite = CCLayerSprite:layerSpriteWithName(CCString:create("images/base/effect/suit/" .. e_name), -1,CCString:create(""));
	spellEffectSprite:retain()
	-- spellEffectSprite:release()
    return spellEffectSprite
end

-- 时装的特效
function getFashionEffect( e_name )
	local spellEffectSprite = CCLayerSprite:layerSpriteWithName(CCString:create("images/base/effect/jinzhuan/" .. e_name), -1,CCString:create(""));
	spellEffectSprite:retain()
	-- spellEffectSprite:release()
    return spellEffectSprite
end

-- 战魂的特效
function getFightSoulEffect(e_name)
	local spellEffectSprite = CCLayerSprite:layerSpriteWithName(CCString:create("images/base/effect/fightSoul/" .. e_name), -1,CCString:create(""));
	-- spellEffectSprite:retain()
	-- spellEffectSprite:release()
    return spellEffectSprite
end


-- 分男女 解析时装的字段
function getStringByFashionString( fashion_str )
	local t_fashion = splitFashionString(fashion_str)
	if(UserModel.getUserSex() == 1)then
		return t_fashion["20001"]
	else
		return t_fashion["20002"]
	end

end

function splitFashionString( fashion_str )
	local fashion_t = {}
	local f_t = string.split(fashion_str, ",")
	for k,ff_t in pairs(f_t) do
		local s_t = string.split(ff_t, "|")
		fashion_t[s_t[1]] = s_t[2]
	end

	return fashion_t
end

-- 根据 item_tmpl_id 返回物品的icon的非按钮灰色显示,  包括装备
function getItemGraySpriteByItemId( item_tmpl_id )
	print("item_tmpl_id", item_tmpl_id)
	item_tmpl_id = tonumber(item_tmpl_id)
	local bgFile = "images/base/potential/props_1.png"
	local iconFile = nil
	local i_data = ItemUtil.getItemById(item_tmpl_id)

	if(item_tmpl_id >= 100001 and item_tmpl_id <= 200000) then
		-- 装备类：
		iconFile = "images/base/equip/small/" .. i_data.icon_small 
	elseif(item_tmpl_id >= 400001 and item_tmpl_id <= 500000)then
		-- 武将碎片类
		iconFile = "images/base/hero/head_icon/" .. i_data.icon_small 
	elseif(item_tmpl_id >= 500001 and item_tmpl_id <= 600000)then
		-- 宝物类
		iconFile = "images/base/treas/small/" .. i_data.icon_small 
	elseif( item_tmpl_id >= 5000001 and item_tmpl_id <= 6000000 )then
		-- 宝物碎片类
		iconFile = "images/base/treas_frag/" .. i_data.icon_small 
	elseif ( item_tmpl_id >= 600001 and item_tmpl_id <= 7000000) then
		-- 宠物碎片 added by zhz 
		iconFile = "images/pet/head_icon/" .. i_data.headIcon 
	else
		iconFile = "images/base/props/" .. i_data.icon_small 
	end

	local item_sprite = CCSprite:create(bgFile)
	-- 物品头像
	local icon_sprite = BTGraySprite:create(iconFile)
	icon_sprite:setAnchorPoint(ccp(0.5, 0.5))
	icon_sprite:setPosition(ccp(item_sprite:getContentSize().width/2, item_sprite:getContentSize().height/2))	
	item_sprite:addChild(icon_sprite)

	return item_sprite
end

-- 银币icon
function getSiliverIconSprite()
	local potentialSprite = CCSprite:create("images/base/potential/props_2.png")
	local iconSprite  = CCSprite:create("images/common/siliver_big.png")
	iconSprite:setAnchorPoint(ccp(0.5, 0.5))
	iconSprite:setPosition(ccp(potentialSprite:getContentSize().width*0.5, potentialSprite:getContentSize().height*0.5))
	potentialSprite:addChild(iconSprite)

	return potentialSprite
end

-- added by zhz
-- 获得银币的品质，写死的
function getSilverQuality( )
	return 2
end

-- 荣誉icon
function getHonorIconSprite()
	local potentialSprite = CCSprite:create("images/base/potential/props_5.png")
	local iconSprite  = CCSprite:create("images/common/honor.png")
	iconSprite:setAnchorPoint(ccp(0.5, 0.5))
	iconSprite:setPosition(ccp(potentialSprite:getContentSize().width*0.5, potentialSprite:getContentSize().height*0.5))
	potentialSprite:addChild(iconSprite)

	return potentialSprite
end

-- 获得荣誉的品质，写死的
function getHonorQuality( )
	return 5
end


--贡献
function getContriIconSprite()
	local potentialSprite = CCSprite:create("images/base/potential/props_5.png")
	local iconSprite  = CCSprite:create("images/common/contribution.png")
	iconSprite:setAnchorPoint(ccp(0.5, 0.5))
	iconSprite:setPosition(ccp(potentialSprite:getContentSize().width*0.5, potentialSprite:getContentSize().height*0.5))
	potentialSprite:addChild(iconSprite)

	return potentialSprite
end

-- 获得荣誉的品质，写死的
function getContriQuality( )
	return 5
end

-- 金币icon
function getGoldIconSprite()
	local potentialSprite = CCSprite:create("images/base/potential/props_5.png")
	local iconSprite  = CCSprite:create("images/common/gold_big.png")
	iconSprite:setAnchorPoint(ccp(0.5, 0.5))
	iconSprite:setPosition(ccp(potentialSprite:getContentSize().width*0.5, potentialSprite:getContentSize().height*0.5))
	potentialSprite:addChild(iconSprite)
	return potentialSprite
end

-- 获得金币的品质，写死的
function getGoldQuality( )
	return 5
end

-- 将魂icon
function getSoulIconSprite()
	local potentialSprite = CCSprite:create("images/base/potential/props_3.png")
	local iconSprite  = CCSprite:create("images/common/soul_big.png")
	iconSprite:setAnchorPoint(ccp(0.5, 0.5))
	iconSprite:setPosition(ccp(potentialSprite:getContentSize().width*0.5, potentialSprite:getContentSize().height*0.5))
	potentialSprite:addChild(iconSprite)
	return potentialSprite
end

--声望Icon
function getPrestigeSprite()
	local potentialSprite = CCSprite:create("images/base/potential/props_3.png")
	local iconSprite  = CCSprite:create("images/base/props/shengwang.png")
	iconSprite:setAnchorPoint(ccp(0.5, 0.5))
	iconSprite:setPosition(ccp(potentialSprite:getContentSize().width*0.5, potentialSprite:getContentSize().height*0.5))
	potentialSprite:addChild(iconSprite)
	return potentialSprite
end

-- 获得声望的品质，写死的
function getPrestigeQuality( )
	return 3
end

-- 获得金币的品质，写死的
function getSoulQuality( )
	return 3
end

-- 获得特殊的金币
function getSpceicalGoldSprite(  )
	local potentialSprite = CCSprite:create("images/base/potential/props_5.png")
	local iconSprite  = CCSprite:create("images/common/gold_special.png")
	iconSprite:setAnchorPoint(ccp(0.5, 0.5))
	iconSprite:setPosition(ccp(potentialSprite:getContentSize().width*0.5, potentialSprite:getContentSize().height*0.5))
	potentialSprite:addChild(iconSprite)
	return potentialSprite
end

-- 问号图标
function getWenHaoIconSprite()
	local potentialSprite = CCSprite:create("images/base/potential/props_2.png")
	local iconSprite  = CCSprite:create("images/common/question_mask.png")
	iconSprite:setAnchorPoint(ccp(0.5, 0.5))
	iconSprite:setPosition(ccp(potentialSprite:getContentSize().width*0.5, potentialSprite:getContentSize().height*0.5))
	potentialSprite:addChild(iconSprite)

	return potentialSprite
end


-- 银币icon
function getSiliverIconSpriteForShop()
	local potentialSprite = CCSprite:create("images/base/potential/props_4.png")
	local iconSprite  = CCSprite:create("images/common/money.png")
	iconSprite:setAnchorPoint(ccp(0.5, 0.5))
	iconSprite:setPosition(ccp(potentialSprite:getContentSize().width*0.5, potentialSprite:getContentSize().height*0.5))
	potentialSprite:addChild(iconSprite)

	return potentialSprite
end

-- 首冲礼包的银币
function getBigSilverSprite( )

	local potentialSprite = CCSprite:create("images/base/potential/props_3.png")
	local iconSprite  = CCSprite:create("images/base/props/yinbi_da.png")
	iconSprite:setAnchorPoint(ccp(0.5, 0.5))
	iconSprite:setPosition(ccp(potentialSprite:getContentSize().width*0.5, potentialSprite:getContentSize().height*0.5))
	potentialSprite:addChild(iconSprite)

	return potentialSprite
end

--魂玉图标
function getJewelSprite()
	local potentialSprite = CCSprite:create("images/base/potential/props_5.png")
	local iconSprite = CCSprite:create("images/base/props/dahunyu.png")
	iconSprite:setAnchorPoint(ccp(0.5,0.5))
	iconSprite:setPosition(ccp(potentialSprite:getContentSize().width*0.5, potentialSprite:getContentSize().height*0.5))
	potentialSprite:addChild(iconSprite)

	return potentialSprite
end

-- 获得魂玉的品质，写死的
function getJewelQuality( )
	return 5
end

--体力图标
function getExecutionSprite()
	local potentialSprite = CCSprite:create("images/base/potential/props_3.png")
	local iconSprite = CCSprite:create("images/base/props/tili_zhong.png")
	iconSprite:setAnchorPoint(ccp(0.5,0.5))
	iconSprite:setPosition(ccp(potentialSprite:getContentSize().width*0.5, potentialSprite:getContentSize().height*0.5))
	potentialSprite:addChild(iconSprite)

	return potentialSprite
end

-- 获得体力的品质，写死的
function getExecutionQuality( )
	return 3
end

--耐力图标
function getStaminaSprite()
	local potentialSprite = CCSprite:create("images/base/potential/props_3.png")
	local iconSprite = CCSprite:create("images/base/props/naili_zhong.png")
	iconSprite:setAnchorPoint(ccp(0.5,0.5))
	iconSprite:setPosition(ccp(potentialSprite:getContentSize().width*0.5, potentialSprite:getContentSize().height*0.5))
	potentialSprite:addChild(iconSprite)

	return potentialSprite
end

-- 获得耐力的品质，写死的
function getStaminaQuality( )
	return 3
end

-- 将魂icon
function getSoulIconSpriteForShop()
	local potentialSprite = CCSprite:create("images/base/potential/props_4.png")
	local iconSprite  = CCSprite:create("images/common/soul.png")
	iconSprite:setAnchorPoint(ccp(0.5, 0.5))
	iconSprite:setPosition(ccp(potentialSprite:getContentSize().width*0.5, potentialSprite:getContentSize().height*0.5))
	potentialSprite:addChild(iconSprite)
	return potentialSprite
end


-- 获得英雄的信息
local function getHeroData( htid)
	require "script/model/hero/HeroModel"
    value = {}
    value.htid = htid
    require "db/DB_Heroes"
    local db_hero = DB_Heroes.getDataById(htid)
    value.country_icon = HeroModel.getCiconByCidAndlevel(db_hero.country, db_hero.star_lv)
    value.name = db_hero.name
    value.level = db_hero.lv
    value.star_lv = db_hero.star_lv
    value.hero_cb = menu_item_tap_handler
    value.head_icon = "images/base/hero/head_icon/" .. db_hero.head_icon_id
    value.quality_bg = "images/hero/quality/"..value.star_lv .. ".png"
    value.quality_h = "images/hero/quality/highlighted.png"
    value.type = "HeroFragment"
    value.isRecruited = false
    value.evolve_level = 0
    return value
end


-- 得到英雄头像icon  按钮
-- 参数：1.htid:英雄htid, 
-- 		2.menu_priority: 返回的英雄item的touch优先级 
-- 		3.zOrderNum:z轴 默认1000
-- 		4.info_layer_priority:展示界面的优先级
--      5.p_soulType:如果想得到带有物品底的武将头像，而不是武将底的头像（用于对应于武魂的那种情况）
--					 如果这句话没看懂，来问Zhang Zihang
--					 因为这个需求实在是太特殊蛋疼了，- - ！
function getHeroIconItemByhtid( htid, menu_priority,zOrderNum,info_layer_priority,p_soulType)
	local this_zOrder = zOrderNum or 1000
	local this_priority = menu_priority or -228
	local info_priority = info_layer_priority or -688
	local soulType = p_soulType or false
	-- 点击英雄头像的回调函数
	local function heroSpriteCb( tag,menuItem )
	    local data = getHeroData(tag)
	   
	    -- local tArgs = {}
	    -- tArgs.sign = s_sign
	    -- tArgs.fnCreate = fn_fnCreate
	    -- tArgs.reserved =  {index= 10001}
	    HeroInfoLayer.createLayer(data, {isPanel=true},this_zOrder,info_priority)
	end

	require "db/DB_Heroes"
	-- print("htid  is : ", htid)
	local db_hero = DB_Heroes.getDataById(tonumber(htid))
	local sHeadIconImg="images/base/hero/head_icon/" .. db_hero.head_icon_id
	local sQualityBgImg
	--如果需要物品底的头像背景的话
	--added by Zhang Zihang
	if soulType then
		sQualityBgImg ="images/base/potential/props_" .. db_hero.star_lv .. ".png"
	--原来的武将底头像背景
	else
		sQualityBgImg ="images/hero/quality/"..db_hero.star_lv .. ".png"
	end
	-- 头像item背景
	local item_bg = CCSprite:create(sQualityBgImg)
	local menu = BTSensitiveMenu:create()
	if(menu:retainCount()>1)then
		menu:release()
		menu:autorelease()
	end
	menu:setPosition(ccp(0,0))
	menu:setTouchPriority(this_priority)
	item_bg:addChild(menu)
	-- 武将头像图标item
	local headIcon_n = CCSprite:create(sHeadIconImg)
	local headIcon_h = CCSprite:create(sHeadIconImg)
	local headIconItem = CCMenuItemSprite:create(headIcon_n, headIcon_h)
	headIconItem:setAnchorPoint(ccp(0.5,0.5))
	headIconItem:setPosition(ccp(item_bg:getContentSize().width*0.5,item_bg:getContentSize().height*0.5))
	menu:addChild(headIconItem,1,tonumber(htid))
	headIconItem:registerScriptTapHandler(heroSpriteCb)

	return item_bg
end


--[[
	@des 	:通过武魂的item_temple_id 来获得按钮，点击显示该武将信息
	@param 	: item_temple_id 
	@return :icon
	added by zhz 
]]
function getHeroFragIconByItemId(item_template_id ,s_sign, menu_priority )

	-- 点击英雄头像的回调函数
	local function heroSpriteCb( tag,menuItem )
	    local data = getHeroData(tag)
	    local tArgs = {}
	    tArgs.sign = s_sign
	    tArgs.fnCreate = nil 
	    tArgs.reserved =  {index= 10001}
	    HeroInfoLayer.createLayer(data, {isPanel=true})
	end

	require "db/DB_Item_hero_fragment"
	require "db/DB_Heroes"

	local htid= DB_Item_hero_fragment.getDataById(item_template_id).aimItem
	print("htid  is : ", htid)

	local db_hero = DB_Heroes.getDataById(tonumber(htid))
	local sHeadIconImg="images/base/hero/head_icon/" .. db_hero.head_icon_id
	local sQualityBgImg="images/hero/quality/"..db_hero.star_lv .. ".png"
	-- 头像item背景
	local item_bg = CCSprite:create(sQualityBgImg)
	local menu = BTSensitiveMenu:create()
	if(menu:retainCount()>1)then
		menu:release()
		menu:autorelease()
	end
	menu:setPosition(ccp(0,0))
	item_bg:addChild(menu)
	if(menu_priority) then
		menu:setTouchPriority(menu_priority)
	end
	-- 武将头像图标item
	local headIcon_n = CCSprite:create(sHeadIconImg)
	local headIcon_h = CCSprite:create(sHeadIconImg)
	local headIconItem = CCMenuItemSprite:create(headIcon_n, headIcon_h)
	headIconItem:setAnchorPoint(ccp(0.5,0.5))
	headIconItem:setPosition(ccp(item_bg:getContentSize().width*0.5,item_bg:getContentSize().height*0.5))
	menu:addChild(headIconItem,1,tonumber(htid))
	headIconItem:registerScriptTapHandler(heroSpriteCb)

	-- 武魂的印章
	local heroSealSp = CCSprite:create("images/common/soul_tag.png")
	heroSealSp:setAnchorPoint(ccp(0.5, 0.5))
	heroSealSp:setPosition(ccp(item_bg:getContentSize().width*0.25, item_bg:getContentSize().height*0.9))
	item_bg:addChild(heroSealSp)

	return item_bg
	
end


-- 创建带闪烁的加号按钮
-- 返回一个sprite
function createAddSprite( ... )
	local itemSprite = CCSprite:create("images/common/border.png")
	local addSprite = CCSprite:create("images/common/add_new.png")
	addSprite:setAnchorPoint(ccp(0.5,0.5))
	addSprite:setPosition(ccp(itemSprite:getContentSize().width*0.5, itemSprite:getContentSize().height*0.5))
	
	local arrActions_2 = CCArray:create()
	arrActions_2:addObject(CCFadeOut:create(1))
	arrActions_2:addObject(CCFadeIn:create(1))
	
	local sequence_2 = CCSequence:create(arrActions_2)
	local action_2 = CCRepeatForever:create(sequence_2)
	addSprite:runAction(action_2)
	itemSprite:addChild(addSprite)
	return itemSprite
end

--创建一个通用图标 add by lichenyang
--p_type	图标类型
-- 1、银币
-- 2、将魂
-- 3、金币
-- 4、体力
-- 5、耐力
-- 6、物品
-- 7、多个物品
-- 8、等级*银币
-- 9、等级*将魂
-- 10、英雄ID（单个英雄）
-- 11、魂玉（新加）
-- 12、声望（新加）
-- 13、多个英雄（数量可大于1）
-- 14、宝物碎片（填写方式与7相同）
-- p_tid 如果 type == 6 or type = 7 则表面是个物品
function createCommonIcon(p_type, p_tid, p_num)

	local iconBg = nil
	local iconName = nil
	local nameColor = nil
	if(p_type ==1) then
		-- 银币
		iconBg= ItemSprite.getSiliverIconSprite()
		iconName = GetLocalizeStringBy("key_1687")
		local quality = ItemSprite.getSilverQuality()
        nameColor = HeroPublicLua.getCCColorByStarLevel(quality)
	elseif(p_type ==2) then
		-- 将魂
		iconBg= ItemSprite.getSoulIconSprite()
		iconName = GetLocalizeStringBy("key_1616")
		local quality = ItemSprite.getSoulQuality()
        nameColor = HeroPublicLua.getCCColorByStarLevel(quality)
	elseif(p_type ==3) then
		-- 金币
		iconBg= ItemSprite.getGoldIconSprite()
		iconName = GetLocalizeStringBy("key_1491")
		local quality = ItemSprite.getGoldQuality()
        nameColor = HeroPublicLua.getCCColorByStarLevel(quality)
	elseif(p_type ==7 or 14) then
		-- 物品
		iconBg =  ItemSprite.getItemSpriteById(tonumber(p_tid))
		local itemData = ItemUtil.getItemById(p_tid)
        iconName = itemData.name
        nameColor = HeroPublicLua.getCCColorByStarLevel(itemData.quality)
	elseif(p_type ==10) then
		-- 英雄
		require "db/DB_Heroes"
		iconBg = ItemSprite.getHeroIconItemByhtid(p_tid,menu_priority,zOrderNum,info_layer_priority)
		local heroData = DB_Heroes.getDataById(p_tid)
		iconName = heroData.name
		nameColor = HeroPublicLua.getCCColorByStarLevel(heroData.star_lv)
	elseif(p_type ==12) then
		-- 声望
		iconBg= ItemSprite.getPrestigeSprite()
		iconName = GetLocalizeStringBy("key_2231")
		local quality = ItemSprite.getPrestigeQuality()
        nameColor = HeroPublicLua.getCCColorByStarLevel(quality)
    elseif(p_type ==11) then
		-- 魂玉
		iconBg= ItemSprite.getJewelSprite()
		iconName = GetLocalizeStringBy("key_1510")
		local quality = ItemSprite.getJewelQuality()
        nameColor = HeroPublicLua.getCCColorByStarLevel(quality)
    elseif(p_type ==4) then
		-- 体力
		iconBg= ItemSprite.getExecutionSprite()
		iconName = GetLocalizeStringBy("key_1032")
		local quality = ItemSprite.getExecutionQuality()
        nameColor = HeroPublicLua.getCCColorByStarLevel(quality)
    elseif(p_type ==5) then
		-- 耐力
		iconBg= ItemSprite.getStaminaSprite()
		iconName = GetLocalizeStringBy("key_2021")
		local quality = ItemSprite.getStaminaQuality()
        nameColor = HeroPublicLua.getCCColorByStarLevel(quality)
	end

	-- 物品数量
	if( tonumber(p_num) > 1 )then
		local numberLabel =  CCRenderLabel:create("" .. p_num , g_sFontName,21,0.5,ccc3(0x00,0x00,0x00),type_stroke)
		numberLabel:setColor(ccc3(0x00,0xff,0x18))
		numberLabel:setAnchorPoint(ccp(0,0))
		local width = iconBg:getContentSize().width - numberLabel:getContentSize().width - 6
		numberLabel:setPosition(ccp(width,5))
		iconBg:addChild(numberLabel)
	end
	return iconBg
end

--[[
	@des 	:得到带有武将详细信息回调的武魂头像（听着蛋疼吧 - - ！） 
	@param 	:$ p_itemId 武魂物品id
	@param 	:$ menu_priority 返回的英雄item的touch优先级 
	@param 	:$ zOrderNum z轴 默认1000
	@param 	:$ info_layer_priority 展示界面的优先级
	@return :带有武将详细信息的武魂头像
--]]
function getHeroSoulSprite(p_itemId,menu_priority,zOrderNum,info_layer_priority)
	require "db/DB_Heroes"
	require "db/DB_Item_hero_fragment"
	--通过武将碎片信息，得到对应的武将的id
	local aimHeroInfo = DB_Item_hero_fragment.getDataById(p_itemId)
	local iconBg = ItemSprite.getHeroIconItemByhtid(tonumber(aimHeroInfo.aimItem),menu_priority,zOrderNum,info_layer_priority,true)

	--武魂标识
	local heroSealSp = CCSprite:create("images/common/soul_tag.png")
	heroSealSp:setAnchorPoint(ccp(0.5, 0.5))
	heroSealSp:setPosition(ccp(iconBg:getContentSize().width*0.25, iconBg:getContentSize().height*0.9))
	iconBg:addChild(heroSealSp,10)

	return iconBg
end




