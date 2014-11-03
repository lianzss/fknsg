-- Filename：	SuitInfoLayer.lua
-- Author：		Cheng Liang
-- Date：		2013-9-26
-- Purpose：		套装信息的展示

module("SuitInfoLayer", package.seeall)


require "script/ui/item/ItemUtil"
require "script/ui/main/MainScene"
require "script/ui/common/LuaMenuItem"

require "script/ui/item/EquipCardSprite"
require "script/ui/formation/ChangeEquipLayer"

require "script/ui/item/EquipReinforceLayer"

local Tag_Water 	= 9001
local Tag_Enforce	= 9002
local Tag_Change 	= 9003
local Tag_Remove 	= 9004
local kTagLock 		= 10000
local kTagUnlock 	= 10001

local _bgLayer 				= nil
local _item_tmpl_id 		= nil
local _item_id 				= nil
local _isEnhance 			= false
local _isWater 				= false 
local _isChange 			= false 
local _itemDelegateAction	= nil
local _hid					= nil
local _pos_index			= nil	
local _menu_priority 		= nil	
local enhanceBtn 			= nil
-- 底部
local bottomSprite 			= nil
local bgSprite				= nil
-- 顶部
local topSprite				= nil
local contentSprite			= nil

local equips_ids_status, suit_attr_infos, suit_name = {}, {}, nil

-- 
local _showType 			= nil  --  2 <=> 好运

local _isShowLock 			= false -- 是否显示加锁按钮 false 不显示
local _lockBtn 				= nil  -- 加锁按钮
local _unlockBtn 			= nil -- 解锁按钮

-- 初始化
local function init()
	_bgLayer 			= nil
	_item_tmpl_id 		= nil
	_item_id 			= nil
	_isEnhance 			= false
	_isWater 			= false 
	_isChange 			= false 
	_itemDelegateAction	= nil
	_hid				= nil
	_pos_index			= nil	
	_menu_priority		= nil
	enhanceBtn 			= nil
	bottomSprite 		= nil
	bgSprite			= nil
	-- 顶部
	topSprite			= nil
	contentSprite		= nil
	equips_ids_status, suit_attr_infos, suit_name = {}, {}, nil
	_showType 			= nil
	_isShowLock 		= false
	_lockBtn 			= nil
	_unlockBtn 			= nil 
end 

-- 关闭按钮
function closeAction( ... )
	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/guanbi.mp3")
	-- if(_showType == 1)then
	-- 	MainScene.setMainSceneViewsVisible(true, true, true)
	-- end
	_bgLayer:removeFromParentAndCleanup(true)
	_bgLayer=nil
	-- if(_itemDelegateAction)then
	-- 	_itemDelegateAction()
	-- end
	
end

function closeAction_2( ... )
	closeAction()
	if(_itemDelegateAction)then
		_itemDelegateAction()
	end
	
end

--[[
 @desc	 处理touches事件
 @para 	 string event
 @return 
--]]
local function onTouchesHandler( eventType, x, y )
	
	if (eventType == "began") then
		-- print("began")

	    return true
    elseif (eventType == "moved") then
    	
    else
        -- print("end")
	end
end


--[[
 @desc	 回调onEnter和onExit时间
 @para 	 string event
 @return void
 --]]
local function onNodeEvent( event )
	if (event == "enter") then

		_bgLayer:registerScriptTouchHandler(onTouchesHandler, false, _menu_priority, true)
		_bgLayer:setTouchEnabled(true)
	elseif (event == "exit") then
		print("exit")
		_bgLayer:unregisterScriptTouchHandler()
	end
end

-- 卸装回调
function removeArmingCallback( cbFlag, dictData, bRet )
	if(dictData.err == "ok")then
		local t_numerial = ItemUtil.getTop2NumeralByIID(_item_id)
		closeAction()
		HeroModel.removeEquipFromHeroBy(_hid, _pos_index)

		FormationLayer.refreshEquipAndBottom()
		if(_itemDelegateAction)then
			_itemDelegateAction()
		end
		
		ItemUtil.showAttrChangeInfo(t_numerial, nil)
	end
end


-- 
function menuAction( tag, itemBtn )
	-- 音效
	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")

	if(tag == 12345)then
		closeAction()
		return
	end

	if(tag == Tag_Water) then
		-- TODO
		-- 洗练装备
		if(not DataCache.getSwitchNodeState(ksSwitchEquipFixed, true)) then
			return	
		end		
		require "script/ui/item/EquipFixedLayer"
		EquipFixedLayer.show(_item_id)
		closeAction_2()
	elseif(tag == Tag_Enforce)then
		-- 强化装备
		local enforceLayer = EquipReinforceLayer.createLayer(_item_id, _itemDelegateAction)
		local onRunningLayer = MainScene.getOnRunningLayer()
		onRunningLayer:addChild(enforceLayer, 10)
		closeAction()
	elseif(tag == Tag_Change)then
		-- 更换装备
		local changeEquipLayer = ChangeEquipLayer.createLayer( nil, tonumber(_hid) ,tonumber(_pos_index))
		MainScene.changeLayer(changeEquipLayer, "changeEquipLayer")
		closeAction_2()
	elseif(tag == Tag_Remove)then
		-- 卸装
		if(ItemUtil.isEquipBagFull(true, closeAction_2))then
			return
		end
		local args = Network.argsHandler(_hid, _pos_index)
		RequestCenter.hero_removeArming(removeArmingCallback, args )
	elseif(tag == kTagLock)then
		-- 加锁
		print("加锁")
		-- 网络回调
		local serviceCallFun = function ( cbFlag, dictData, bRet )
			if( dictData.err == "ok" )then
				if(dictData.ret == "ok" )then
					-- 修改缓存数据
					if(_hid)then
						-- 武将身上装备
						HeroModel.setHeroEquipLockStatusByHid(_hid,_item_id,1)
					else
						-- 背包装备
						DataCache.setBagEquipLockStatusByItemId(_item_id,1)
					end
					_lockBtn:setVisible(false)
					_unlockBtn:setVisible(true)
					-- 提示
					require "script/ui/tip/AnimationTip"
        			AnimationTip.showTip(GetLocalizeStringBy("lic_1162"))
				end
			end
		end
		local args = Network.argsHandler(_item_id)
		Network.rpc(serviceCallFun, "forge.lock", "forge.lock", args, true)
	elseif(tag == kTagUnlock)then
		-- 解锁
		print("解锁")
		-- 网络回调
		local serviceCallFun = function ( cbFlag, dictData, bRet )
			if( dictData.err == "ok" )then
				if(dictData.ret == "ok" )then
					-- 修改缓存数据
					if(_hid)then
						-- 武将身上装备
						HeroModel.setHeroEquipLockStatusByHid(_hid,_item_id,0)
					else
						-- 背包装备
						DataCache.setBagEquipLockStatusByItemId(_item_id,0)
					end
					_lockBtn:setVisible(true)
					_unlockBtn:setVisible(false)
					-- 提示
					require "script/ui/tip/AnimationTip"
        			AnimationTip.showTip(GetLocalizeStringBy("lic_1163"))
				end
			end
		end
		local args = Network.argsHandler(_item_id)
		Network.rpc(serviceCallFun, "forge.unlock", "forge.unlock", args, true)
	else
	end
end

-- 创建各种按钮
function createMenuBtn( )

	if(_showType == 2)then
		local m_actionMenuBar = CCMenu:create()
		m_actionMenuBar:setPosition(ccp(0, 0))	
		m_actionMenuBar:setTouchPriority(_menu_priority - 1)
		bgSprite:addChild(m_actionMenuBar)
		-- 确定按钮
		local normalBtn = LuaCC.create9ScaleMenuItem("images/common/btn/btn_green_n.png","images/common/btn/btn_green_h.png",CCSizeMake(200, 71),GetLocalizeStringBy("key_1985"),ccc3(0xfe, 0xdb, 0x1c),35,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00))
		normalBtn:setAnchorPoint(ccp(0.5, 0.5))
		normalBtn:setPosition(ccp(bgSprite:getContentSize().width*0.5, bgSprite:getContentSize().height*0.08))
		normalBtn:registerScriptTapHandler(menuAction)
		m_actionMenuBar:addChild(normalBtn,1, 12345)
		return
	end

	-------------------------------- 几个按钮 ------------------------------
	local actionMenuBar = CCMenu:create()
	actionMenuBar:setPosition(ccp(0, 0))	
	actionMenuBar:setTouchPriority(_menu_priority-1)
	bottomSprite:addChild(actionMenuBar)

	-- 更换
	local changeBtn = nil
	local waterBtn 	= nil
	if(_isChange == true) then
		changeBtn = LuaCC.create9ScaleMenuItem("images/common/btn/btn1_d.png","images/common/btn/btn1_n.png",CCSizeMake(160, 73),GetLocalizeStringBy("key_1543"),ccc3(0xfe, 0xdb, 0x1c),35,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00))
		-- LuaMenuItem.createItemImage("images/item/equipinfo/btn_change_n.png", "images/item/equipinfo/btn_change_h.png", menuAction )
		changeBtn:setAnchorPoint(ccp(0.5, 0.5))
	    changeBtn:registerScriptTapHandler(menuAction)
		actionMenuBar:addChild(changeBtn, 1, Tag_Change)
		-- changeBtn:setScale(MainScene.elementScale)

		removeBtn = LuaCC.create9ScaleMenuItem("images/common/btn/btn1_d.png","images/common/btn/btn1_n.png",CCSizeMake(160, 73),GetLocalizeStringBy("key_2933"),ccc3(0xfe, 0xdb, 0x1c),35,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00))
		removeBtn:setAnchorPoint(ccp(0.5, 0.5))
	    removeBtn:registerScriptTapHandler(menuAction)
		actionMenuBar:addChild(removeBtn, 1, Tag_Remove)
		-- removeBtn:setScale(MainScene.elementScale)
		-- 洗练
		waterBtn = LuaCC.create9ScaleMenuItem("images/common/btn/btn1_d.png","images/common/btn/btn1_n.png",CCSizeMake(160, 73),GetLocalizeStringBy("key_2475"),ccc3(0xfe, 0xdb, 0x1c),35,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00))
		waterBtn:setAnchorPoint(ccp(0.5, 0.5))
	    waterBtn:registerScriptTapHandler(menuAction)
		actionMenuBar:addChild(waterBtn, 1, Tag_Water)
	end
	-- 强化
	if(_isEnhance == true) then
		enhanceBtn = LuaCC.create9ScaleMenuItem("images/common/btn/btn1_d.png","images/common/btn/btn1_n.png",CCSizeMake(160, 73),GetLocalizeStringBy("key_3391"),ccc3(0xfe, 0xdb, 0x1c),35,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00))
		-- LuaMenuItem.createItemImage("images/item/equipinfo/btn_enhance_n.png", "images/item/equipinfo/btn_enhance_h.png", menuAction )
		enhanceBtn:setAnchorPoint(ccp(0.5, 0.5))
	    enhanceBtn:registerScriptTapHandler(menuAction)
		actionMenuBar:addChild(enhanceBtn, 1, Tag_Enforce)
		-- enhanceBtn:setScale(MainScene.elementScale)
	end

	-- 加锁
	local equipInfo = nil
	if(_item_id)then
		if(_hid)then
			equipInfo = ItemUtil.getEquipInfoFromHeroByItemId(_item_id)
		else
			equipInfo = ItemUtil.getItemInfoByItemId(_item_id)
		end
	end
	print("SuitInfoLayer _isShowLock equipInfo")
	print_t(equipInfo)
	-- 五星装备才有加锁功能
	if(_isShowLock == true and tonumber(equipInfo.itemDesc.quality) == 5)then
		_lockBtn = LuaCC.create9ScaleMenuItem("images/common/btn/btn1_d.png","images/common/btn/btn1_n.png", CCSizeMake(215,73), GetLocalizeStringBy("lic_1160"), ccc3(255,222,0))
		_lockBtn:registerScriptTapHandler(menuAction)
		_lockBtn:setAnchorPoint(ccp(0.5,0.5))
		actionMenuBar:addChild(_lockBtn,1, kTagLock)
		local lockIcon = CCSprite:create("images/hero/unlock.png")
	    lockIcon:setAnchorPoint(ccp(1,0.5))
	    lockIcon:setPosition(_lockBtn:getContentSize().width- 19,_lockBtn:getContentSize().height/2)
	    _lockBtn:addChild(lockIcon)

		_unlockBtn =LuaCC.create9ScaleMenuItem("images/common/btn/btn1_d.png","images/common/btn/btn1_n.png", CCSizeMake(215,73), GetLocalizeStringBy("lic_1161"), ccc3(255,222,0))
		_unlockBtn:registerScriptTapHandler(menuAction)
		_unlockBtn:setAnchorPoint(ccp(0.5,0.5))
		actionMenuBar:addChild(_unlockBtn,1, kTagUnlock )
		local unlockIcon = CCSprite:create("images/hero/lock.png")
	    unlockIcon:setAnchorPoint(ccp(1,0.5))
	    unlockIcon:setPosition(_unlockBtn:getContentSize().width-19,_unlockBtn:getContentSize().height/2)
	    _unlockBtn:addChild(unlockIcon)

		if(equipInfo.va_item_text.lock and tonumber(equipInfo.va_item_text.lock)== 1  ) then
			_lockBtn:setVisible(false)
			_unlockBtn:setVisible(true)
		else
			_lockBtn:setVisible(true)
			_unlockBtn:setVisible(false)
		end
	end

	if(_isChange == true)then
		changeBtn:setPosition(ccp(bottomSprite:getContentSize().width*0.15, bottomSprite:getContentSize().height*0.4))
		enhanceBtn:setPosition(ccp(bottomSprite:getContentSize().width*0.615, bottomSprite:getContentSize().height*0.4))
		removeBtn:setPosition(ccp(bottomSprite:getContentSize().width*0.385, bottomSprite:getContentSize().height*0.4))
		waterBtn:setPosition(ccp(bottomSprite:getContentSize().width*0.85, bottomSprite:getContentSize().height*0.4))
	elseif(_isEnhance == true and _isShowLock == true and tonumber(equipInfo.itemDesc.quality) == 5)then
		enhanceBtn:setPosition(ccp(bottomSprite:getContentSize().width*0.7, bottomSprite:getContentSize().height*0.4))
		_lockBtn:setPosition(ccp(bottomSprite:getContentSize().width*0.3, bottomSprite:getContentSize().height*0.4))
		_unlockBtn:setPosition(ccp(bottomSprite:getContentSize().width*0.3, bottomSprite:getContentSize().height*0.4))
	elseif(_isEnhance == true ) then
		enhanceBtn:setPosition(ccp(bottomSprite:getContentSize().width*0.5, bottomSprite:getContentSize().height*0.4))
	else
	end
	
end

-- 创建scrollview中的套装信息内容
function createSuitUI()
	local contentSize = contentSprite:getContentSize()
	-- 套装背景
	local suitSprite = CCSprite:create("images/common/suit.png")
	suitSprite:setAnchorPoint(ccp(0.5, 1))
	suitSprite:setPosition(ccp(contentSize.width*0.5, contentSize.height - 485))
	contentSprite:addChild(suitSprite)

	-- 套装名称
	suit_name = suit_name or ""
	local suitNameLabel = CCRenderLabel:create(suit_name, g_sFontPangWa, 30, 1, ccc3( 0xff, 0xff, 0xff), type_stroke)
    suitNameLabel:setColor(ccc3(0x78, 0x25, 0x00))
    suitNameLabel:setAnchorPoint(ccp(0.5,1))
    suitNameLabel:setPosition(ccp(suitSprite:getContentSize().width/2, suitSprite:getContentSize().height+10))
    suitSprite:addChild(suitNameLabel)

    local position_scale_x = {0.2, 0.4, 0.6, 0.8, 0.9}
    -- 物品展示
    local index = 0
    for item_tmpl_id, hadUnlock in pairs(equips_ids_status) do
    	index = index + 1
    	-- 头像
    	local itemBtn = nil

    	if(hadUnlock)then
    		itemBtn = ItemSprite.getItemSpriteByItemId(tonumber(item_tmpl_id))
    	else
    		itemBtn = ItemSprite.getItemGraySpriteByItemId(tonumber(item_tmpl_id))
    	end
    	
    	itemBtn:setAnchorPoint(ccp(0.5, 0.5))
    	itemBtn:setPosition(ccp(suitSprite:getContentSize().width*position_scale_x[index], suitSprite:getContentSize().height *0.55))
    	suitSprite:addChild(itemBtn)
    	-- 名字
    	local itemDesc = ItemUtil.getItemById(item_tmpl_id)
    	local nameColor = HeroPublicLua.getCCColorByStarLevel(itemDesc.quality)
    	local nameLabel = CCRenderLabel:create(itemDesc.name, g_sFontName, 18, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	    nameLabel:setColor(nameColor)
	    nameLabel:setPosition(ccp(itemBtn:getContentSize().width*0.5 - nameLabel:getContentSize().width*0.5, 0))
	    itemBtn:addChild(nameLabel)
    end

    --  套装属性的状态
    local suitTitleColor = ccc3(0x00, 0xff, 0x2a)
    local suitAttrColor  = ccc3(0x78, 0x25, 0x00)
    local sideColor = ccc3( 0x00, 0x00, 0x00)

    local s_height = contentSize.height - 485 - 220

    local suit_position_x = {180, 375, 180, 375, 180, 375}
    local suit_position_y_add = {0, 0, 30, 0, 30, 0}

    for k, suit_attr_info in pairs(suit_attr_infos) do
    	s_height = s_height -10
    	if(suit_attr_info.hadUnlock == false) then
    		suitTitleColor = ccc3(155, 155, 155)
    		suitAttrColor = ccc3(0,0,0)
    		sideColor = ccc3(0,0,0)
    	end
    	-- 套装个数
    	local numLabel = CCRenderLabel:create(GetLocalizeStringBy("key_2025") .. suit_attr_info.lock_num .. GetLocalizeStringBy("key_2625"), g_sFontName, 25, 1, sideColor, type_stroke)
	    numLabel:setColor(suitTitleColor)
	    numLabel:setAnchorPoint(ccp(0, 1))
	    numLabel:setPosition(ccp(50, s_height))
	    contentSprite:addChild(numLabel)
	    s_height = s_height - 5
	    local a_index = 0
	    for attr_id, attr_num in pairs(suit_attr_info.astAttr) do
	    	a_index = a_index + 1
	    	s_height = s_height-suit_position_y_add[a_index]

	    	local affixDesc, displayNum = ItemUtil.getAtrrNameAndNum(attr_id, attr_num)
	    	-- 属性名称
	    	local attr_name_num_label = CCLabelTTF:create( affixDesc.sigleName .. ": +" .. displayNum, g_sFontName, 20)
			attr_name_num_label:setColor(suitAttrColor)
			attr_name_num_label:setAnchorPoint(ccp(0, 1))
			attr_name_num_label:setPosition(ccp(suit_position_x[a_index], s_height))
			contentSprite:addChild(attr_name_num_label)
	    end
	    s_height = s_height - 30

	    -- 分割线
		local lineSprite = CCSprite:create("images/item/equipinfo/line.png")
		lineSprite:setAnchorPoint(ccp(0.5, 1))
		lineSprite:setScaleX(5)
		lineSprite:setPosition(ccp(contentSize.width*0.5, s_height))
		contentSprite:addChild(lineSprite)
		s_height = s_height - 20
    end
end

-- scrollview
function createInfoScrollview()

	-- 获取装备数据
	require "db/DB_Item_arm"
	local equip_desc = DB_Item_arm.getDataById(_item_tmpl_id)

	-- 获得相关数值
	local t_numerial, t_numerial_PL, t_equip_score
	if(_item_id) then
		t_numerial, t_numerial_PL, t_equip_score = ItemUtil.getTop2NumeralByIID(_item_id)
	else
		t_numerial, t_numerial_PL, t_equip_score = ItemUtil.getTop2NumeralByTmplID(_item_tmpl_id)
	end

	-- scrollView的高度
	local scrollviewHeight = 0
	if(_showType == 1)then
		scrollviewHeight = bgSprite:getContentSize().height-topSprite:getContentSize().height - bottomSprite:getContentSize().height
	else
		scrollviewHeight = bgSprite:getContentSize().height-topSprite:getContentSize().height - 150
	end
	-- 内容的高度
	local contentHeight = 485 + 220
	-- 算
	for k, suit_attr_info in pairs(suit_attr_infos) do
    	contentHeight = contentHeight + 30
	    contentHeight = contentHeight + 5
	    local t_count = math.ceil(table.count(suit_attr_info.astAttr)/2)
	    contentHeight = contentHeight + t_count*30
	    contentHeight = contentHeight + 30
    end
    -- 减去最后一个
    contentHeight = contentHeight -50

	if(contentHeight<scrollviewHeight)then
		contentHeight = scrollviewHeight
	end

	contentSprite = CCSprite:create()
	contentSprite:setContentSize(CCSizeMake(bgSprite:getContentSize().width, contentHeight))

	-- 卡牌
	local cardSprite = EquipCardSprite.createSprite(_item_tmpl_id, _item_id, t_equip_score)
	cardSprite:setAnchorPoint(ccp(0.5, 1))
	cardSprite:setPosition(ccp(contentSprite:getContentSize().width*0.25, contentSprite:getContentSize().height-10))
	contentSprite:addChild(cardSprite)
	-- cardSprite:setScale(MainScene.elementScale)

----------------------------------------------- 属性介绍 -----------------------------------------
	-- 属性背景
	local attrBg = CCScale9Sprite:create("images/copy/fort/textbg.png")
	attrBg:setContentSize(CCSizeMake(260, 440))
	attrBg:setAnchorPoint(ccp(0.5, 1))
	attrBg:setPosition(ccp(contentSprite:getContentSize().width*0.75, contentSprite:getContentSize().height-10))
	contentSprite:addChild(attrBg)
	-- attrBg:setScale(MainScene.elementScale)

-- 简介
	local descTitleLabel = CCLabelTTF:create(GetLocalizeStringBy("key_2371"), g_sFontName, 25)
	descTitleLabel:setColor(ccc3(0x00, 0x6d, 0x2f))
	descTitleLabel:setAnchorPoint(ccp(0.5, 1))
	descTitleLabel:setPosition(ccp(attrBg:getContentSize().width*0.5, attrBg:getContentSize().height-10))
	attrBg:addChild(descTitleLabel)
	-- 分割线
	local lineSprite = CCSprite:create("images/item/equipinfo/line.png")
	lineSprite:setAnchorPoint(ccp(0.5, 0.5))
	lineSprite:setScaleX(2)
	lineSprite:setPosition(ccp(attrBg:getContentSize().width*0.5, attrBg:getContentSize().height - 40))
	attrBg:addChild(lineSprite)
	-- 描述
	local noLabel = CCLabelTTF:create(equip_desc.info, g_sFontName, 20, CCSizeMake(210, 100), kCCTextAlignmentLeft, kCCVerticalTextAlignmentTop)
	noLabel:setColor(ccc3(0x78, 0x25, 0x00))
	noLabel:setAnchorPoint(ccp(0.5, 1))
	noLabel:setPosition(ccp(attrBg:getContentSize().width*0.5, attrBg:getContentSize().height-50))
	attrBg:addChild(noLabel)

	local enhanceLv = 0
	local equipInfo = nil
	if(_item_id)then
		
		if(_hid)then
			equipInfo = ItemUtil.getEquipInfoFromHeroByItemId(_item_id)
		else
			equipInfo = ItemUtil.getItemInfoByItemId(_item_id)
		end
		enhanceLv = equipInfo.va_item_text.armReinforceLevel
	end
	

-- 基础属性的条数
	local base_nums = 1
	-- 洗练的结果
	local water_result = nil
	if(equipInfo and equipInfo.va_item_text and (not table.isEmpty(equipInfo.va_item_text.armPotence)))then
		water_result = table.hcopy(equipInfo.va_item_text.armPotence, {})
	end
	-- 映射关系
	local potentialityConfig = { hp = 1, gen_att = 9, phy_att = 2, magic_att =3, phy_def = 4, magic_def = 5}
-- 当前属性
	local descString = GetLocalizeStringBy("key_2137") .. enhanceLv .. "/" .. equip_desc.level_limit_ratio * UserModel.getHeroLevel() .."\n"
	for key,v_num in pairs(t_numerial) do
		if (key == "hp") then
			descString = descString .. GetLocalizeStringBy("key_2356") 
		elseif (key == "gen_att") then
			descString = descString .. GetLocalizeStringBy("key_2489")
		elseif(key == "phy_att"  )then
			descString = descString .. GetLocalizeStringBy("key_2328") 
		elseif(key == "magic_att")then
			descString = descString .. GetLocalizeStringBy("key_3236")
		elseif(key == "phy_def"  )then
			descString = descString .. GetLocalizeStringBy("key_1779") 
		elseif(key == "magic_def")then
			descString = descString .. GetLocalizeStringBy("key_1246") 
		end
		if( not table.isEmpty(water_result) )then
			for k,v in pairs(water_result) do
				if(potentialityConfig[key] == tonumber(k))then
					water_result[k] = nil
					v_num = tonumber(v_num) + tonumber(v)
					break
				end
			end
		end
		descString = descString .. v_num .. "\n"
		base_nums = base_nums +1
	end

	local attrTitleLabel = CCLabelTTF:create(GetLocalizeStringBy("key_1293"), g_sFontName, 25)
	attrTitleLabel:setColor(ccc3(0x00, 0x6d, 0x2f))
	attrTitleLabel:setAnchorPoint(ccp(0.5, 1))
	attrTitleLabel:setPosition(ccp(attrBg:getContentSize().width*0.5, attrBg:getContentSize().height-150))
	attrBg:addChild(attrTitleLabel)
	-- 分割线
	local lineSprite_2 = CCSprite:create("images/item/equipinfo/line.png")
	lineSprite_2:setAnchorPoint(ccp(0.5, 0.5))
	lineSprite_2:setScaleX(2)
	lineSprite_2:setPosition(ccp(attrBg:getContentSize().width*0.5, attrBg:getContentSize().height - 180))
	attrBg:addChild(lineSprite_2)
	-- 当前属性
	local attrLabel = CCLabelTTF:create(descString, g_sFontName, 20, CCSizeMake(225, 150), kCCTextAlignmentLeft, kCCVerticalTextAlignmentTop)
	attrLabel:setColor(ccc3(0x00, 0x00, 0x00))
	attrLabel:setAnchorPoint(ccp(0, 1))
	attrLabel:setPosition(ccp(attrBg:getContentSize().width*0.25, attrBg:getContentSize().height- 190))
	attrBg:addChild(attrLabel)


	-- 洗练的属性
	if( not table.isEmpty(water_result) )then
		for attr_id, attr_num in pairs(water_result) do
			if(attr_num~=nil)then
				local affixDesc, displayNum = ItemUtil.getAtrrNameAndNum(tonumber(attr_id), tonumber(attr_num) )
				local display_text = affixDesc.sigleName .. ": " .. displayNum
				local displayTextLabel = CCLabelTTF:create(display_text, g_sFontName, 23)
				displayTextLabel:setColor(ccc3(0x00, 0x4b, 0xc8))
				displayTextLabel:setAnchorPoint(ccp(0, 1))
				displayTextLabel:setPosition(ccp(attrBg:getContentSize().width*0.25, attrBg:getContentSize().height-190-base_nums*22))
				attrBg:addChild(displayTextLabel)	
				base_nums = base_nums+1
			end
		end
	end

-- 每级属性强化
	local descString_PL = ""
	for key,v_num in pairs(t_numerial_PL) do
		if (key == "hp") then
			descString_PL = descString_PL .. GetLocalizeStringBy("key_2744") 
		elseif(key == "gen_att"  )then
			descString_PL = descString_PL .. GetLocalizeStringBy("key_1345") 
		elseif(key == "phy_att"  )then
			descString_PL = descString_PL .. GetLocalizeStringBy("key_2594") 
		elseif(key == "magic_att")then
			descString_PL = descString_PL .. GetLocalizeStringBy("key_1346")
		elseif(key == "phy_def"  )then
			descString_PL = descString_PL .. GetLocalizeStringBy("key_1396") 
		elseif(key == "magic_def")then
			descString_PL = descString_PL .. GetLocalizeStringBy("key_2529") 
		end
		descString_PL = descString_PL .. v_num .. "\n"
	end

	local attrTitleLabel_PL = CCLabelTTF:create(GetLocalizeStringBy("key_3188"), g_sFontName, 25)
	attrTitleLabel_PL:setColor(ccc3(0x00, 0x6d, 0x2f))
	attrTitleLabel_PL:setAnchorPoint(ccp(0.5, 1))
	attrTitleLabel_PL:setPosition(ccp(attrBg:getContentSize().width*0.5, attrBg:getContentSize().height-340))
	attrBg:addChild(attrTitleLabel_PL)
	-- 分割线
	local lineSprite_3 = CCSprite:create("images/item/equipinfo/line.png")
	lineSprite_3:setAnchorPoint(ccp(0.5, 0.5))
	lineSprite_3:setScaleX(2)
	lineSprite_3:setPosition(ccp(attrBg:getContentSize().width*0.5, attrBg:getContentSize().height - 370))
	attrBg:addChild(lineSprite_3)
	-- 当前属性
	local attrLabel_PL = CCLabelTTF:create(descString_PL, g_sFontName, 20, CCSizeMake(225, 100), kCCTextAlignmentLeft, kCCVerticalTextAlignmentTop)
	attrLabel_PL:setColor(ccc3(0x78, 0x25, 0x00))
	attrLabel_PL:setAnchorPoint(ccp(0, 1))
	attrLabel_PL:setPosition(ccp(attrBg:getContentSize().width*0.25, attrBg:getContentSize().height- 380))
	attrBg:addChild(attrLabel_PL)

	-- scrollView
	local suitScrollView = CCScrollView:create()
	suitScrollView:setContainer(contentSprite)
	suitScrollView:setTouchEnabled(true)
	suitScrollView:setDirection(kCCScrollViewDirectionVertical)
	suitScrollView:setViewSize( CCSizeMake(bgSprite:getContentSize().width, scrollviewHeight) )
	suitScrollView:setBounceable(true)
	if(_showType == 1)then
		suitScrollView:setPosition(ccp(0, bottomSprite:getContentSize().height))
	else
		suitScrollView:setPosition(ccp(0, 100))
	end
	suitScrollView:setTouchPriority(_menu_priority-1)
	suitScrollView:setContentOffset(ccp(0, -(contentHeight - scrollviewHeight) ))
	bgSprite:addChild(suitScrollView)

end

-- 
local function create()

	local bgSize = _bgLayer:getContentSize()
	local myScale = _bgLayer:getContentSize().width/640/MainScene.elementScale

	local anchorPoint = ccp(0.5,1)
	local contengSize = CCSizeMake(_bgLayer:getContentSize().width/MainScene.elementScale,  _bgLayer:getContentSize().height/MainScene.elementScale)
	local position = ccp(_bgLayer:getContentSize().width*0.5, _bgLayer:getContentSize().height)
	if(_showType == 2)then
		anchorPoint = ccp(0.5, 0.5)
		contengSize = CCSizeMake(640, 750)
		position = ccp(_bgLayer:getContentSize().width*0.5, _bgLayer:getContentSize().height*0.5)
	end
	bgSprite = CCScale9Sprite:create("images/item/equipinfo/bg_9s.png")
	bgSprite:setContentSize(contengSize)
	bgSprite:setAnchorPoint(anchorPoint)
	bgSprite:setPosition(position)
	_bgLayer:addChild(bgSprite, 1)
	if(_showType == 2)then
		myScale = _bgLayer:getContentSize().width/640
		bgSprite:setScale(myScale)
	end

	-- 顶部
	topSprite = CCSprite:create("images/item/equipinfo/topbg.png")
	topSprite:setAnchorPoint(ccp(0.5, 1))
	topSprite:setPosition(ccp(bgSprite:getContentSize().width*0.5, bgSprite:getContentSize().height))
	bgSprite:addChild(topSprite, 2)
	if(_showType == 1)then
		topSprite:setScale(myScale)
		-- 标题
		local titleLabel = CCRenderLabel:create(GetLocalizeStringBy("key_2541"), g_sFontPangWa, 33, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	    titleLabel:setColor(ccc3(0xff, 0xe4, 0x00))
	    titleLabel:setAnchorPoint(ccp(0.5,0.5))
	    titleLabel:setPosition(ccp( ( topSprite:getContentSize().width )/2, topSprite:getContentSize().height*0.6))
	    topSprite:addChild(titleLabel)
	
	elseif(_showType == 2)then
		-- 好运
		local goodluck = CCSprite:create("images/common/luck.png")
		goodluck:setPosition(ccp(topSprite:getContentSize().width/2,topSprite:getContentSize().height*0.6))
		goodluck:setAnchorPoint(ccp(0.5,0.5))
		topSprite:addChild(goodluck)
	end
	

	-- 关闭按钮bar
	local closeMenuBar = CCMenu:create()
	closeMenuBar:setPosition(ccp(0, 0))
	topSprite:addChild(closeMenuBar)
	-- 关闭按钮
	local closeBtn = LuaMenuItem.createItemImage("images/common/btn_close_n.png", "images/common/btn_close_h.png" )
	closeBtn:setAnchorPoint(ccp(1, 0.5))
    closeBtn:setPosition(ccp(topSprite:getContentSize().width*1.01, topSprite:getContentSize().height*0.54))
    closeBtn:registerScriptTapHandler(closeAction_2)
	closeMenuBar:addChild(closeBtn)
	closeMenuBar:setTouchPriority(_menu_priority-1)

	if(_showType == 2)then
		--武将名称
		local explainLabel1 = CCRenderLabel:create(GetLocalizeStringBy("key_1682"), g_sFontPangWa,33,1,ccc3(0x00,0x00,0x00),type_shadow)
		explainLabel1:setPosition(ccp(bgSprite:getContentSize().width/2-100, bgSprite:getContentSize().height-90))
		explainLabel1:setColor(ccc3(0xff,0xf0,0x00))
		explainLabel1:setAnchorPoint(ccp(0.5,0.5))
		bgSprite:addChild(explainLabel1)
		
		-- 获取装备数据
		require "db/DB_Item_arm"
		local equip_desc = DB_Item_arm.getDataById(_item_tmpl_id)
		
		local explainLabel2 = CCRenderLabel:create(equip_desc.name, g_sFontPangWa,33,1,ccc3(0x00,0x00,0x00),type_shadow)
		explainLabel2:setPosition(ccp(bgSprite:getContentSize().width/2+20, bgSprite:getContentSize().height-90))
		explainLabel2:setColor(ccc3(0x0b,0xe5,0x00))
		explainLabel2:setAnchorPoint(ccp(0,0.5))
		bgSprite:addChild(explainLabel2)
	end

	if(_showType == 1)then
		-- 底部
		bottomSprite = CCSprite:create("images/common/sell_bottom.png")
		bottomSprite:setAnchorPoint(ccp(0.5, 0))
		bottomSprite:setPosition(ccp(_bgLayer:getContentSize().width/2,0))
		_bgLayer:addChild(bottomSprite,2)
		bottomSprite:setScale(myScale)
	end
	

end

-- 处理数据
local function handleData()
	equips_ids_status, suit_attr_infos, suit_name = ItemUtil.getSuitInfoByIds(_item_tmpl_id, _hid)
	print("======>")
	print("suit_name",suit_name)
	print("equips_ids_status")
	print_t(equips_ids_status)
	print("suit_attr_infos")
	print_t(suit_attr_infos)
end 

-- 创建Layer
function createLayer( template_id,  item_id, isEnhance, isWater, isChange, itemDelegateAction, hid_c, pos_index, menu_priority, showType,p_isShowLock)
	print("itemDelegateAction", template_id,  item_id, isEnhance, isWater, isChange, itemDelegateAction, menu_priority)
	init()
	_menu_priority		= menu_priority
	_item_tmpl_id 		= template_id
	_item_id 			= item_id
	_isEnhance			= isEnhance
	_isWater 			= isWater
	_isChange 			= isChange
	_itemDelegateAction = itemDelegateAction
	_hid				= hid_c
	_pos_index 			= pos_index
	_showType			= showType or 1
	_isShowLock 		= p_isShowLock

	if(_menu_priority == nil) then
		_menu_priority = -434
	end

	if(_showType == 1)then
		_bgLayer = MainScene.createBaseLayer(nil, false, false, true)  
	elseif(_showType == 2)then
		_bgLayer = CCLayerColor:create(ccc4(0,0,0,155))
		_menu_priority = -520
		-- _bgLayer:setContentSize(CCSizeMake(640, 640))
	end
	_bgLayer:registerScriptHandler(onNodeEvent)
	handleData()
	create()
	createMenuBtn()
	createInfoScrollview()
	-- 创建scrollview中的套装信息内容
	createSuitUI()

	return _bgLayer
end

-- 新手引导
function getGuideObject()
	return enhanceBtn
end

