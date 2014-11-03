-- Filename：	EquioInfoLayer.lua
-- Author：		Cheng Liang
-- Date：		2013-7-25
-- Purpose：		装备信息的展示

module("EquipInfoLayer", package.seeall)


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
local _showType 			= nil    -- 2 <=>好运
local _isShowLock 			= false -- 是否显示加锁按钮 false 不显示
local _lockBtn 				= nil -- 加锁按钮
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
	_showType 			= nil
	_isShowLock 		= false
	_lockBtn 			= nil
	_unlockBtn 			= nil
end 

-- 关闭按钮
function closeAction( ... )

	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/guanbi.mp3")
	-- if(_showType == 1 )then
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
		print("enter")

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
		closeAction_2()
		HeroModel.removeEquipFromHeroBy(_hid, _pos_index)
		FormationLayer.refreshEquipAndBottom()
		
		ItemUtil.showAttrChangeInfo(t_numerial, nil)
	end
end

-- 
function menuAction( tag, itemBtn )
	if(tag == 12345)then
		closeAction()
		return
	end
	-- 音效
	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
	---[==[铁匠铺 新手引导屏蔽层
	---------------------新手引导---------------------------------
	--add by licong 2013.09.26
	require "script/guide/NewGuide"
	if(NewGuide.guideClass == ksGuideSmithy) then
		require "script/guide/EquipGuide"
		EquipGuide.changLayer()
	end
	---------------------end-------------------------------------
	--]==]

	
	if(tag == Tag_Water) then
		-- TODO
		-- 洗练装备
		if(not DataCache.getSwitchNodeState(ksSwitchEquipFixed, true)) then
			return	
		end
		require "script/ui/item/EquipFixedLayer"
		EquipFixedLayer.show(_item_id)
		closeAction()
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
		if(ItemUtil.isEquipBagFull(true, closeAction_2))then
			return
		end
		local args = Network.argsHandler(_hid, _pos_index)
		RequestCenter.hero_removeArming(removeArmingCallback,args )
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




-- 
local function create()

	local bgSize = _bgLayer:getContentSize()
	-- local myScale = _bgLayer:getContentSize().width/640/_bgLayer:getElementScale()

	-- 获取装备数据
	require "db/DB_Item_arm"
	local equip_desc = DB_Item_arm.getDataById(_item_tmpl_id)
	--DB_Item_arm.release()
	--package.loaded["db/DB_Item_arm"] = nil

	-- 获得相关数值
	local t_numerial, t_numerial_PL, t_equip_score = ItemUtil.getTop2NumeralByTmplID(_item_tmpl_id)
	local level = 0
	local equipData = nil
	if(_item_id) then
		t_numerial, t_numerial_PL, t_equip_score = ItemUtil.getTop2NumeralByIID(_item_id)
		-- 获取装备数据
		local a_bagInfo = DataCache.getBagInfo()
		
		for k,s_data in pairs(a_bagInfo.arm) do
	--		print("s_data.item_id==", s_data.item_id,  "i_id ===", i_id)
			if( tonumber(s_data.item_id) == _item_id ) then
				equipData = s_data
				level = s_data.va_item_text.armReinforceLevel
				break
			end
		end
		-- 如果为空则是武将身上的装备
		if(table.isEmpty(equipData))then
			equipData = ItemUtil.getEquipInfoFromHeroByItemId(_item_id)
			if( not table.isEmpty(equipData))then
				level = equipData.va_item_text.armReinforceLevel
			end
		end
	end
	-- 基础属性的条数
	local base_nums = 1
	-- 洗练的结果
	local water_result = nil
	if(equipData and equipData.va_item_text and (not table.isEmpty(equipData.va_item_text.armPotence)))then
		water_result = table.hcopy(equipData.va_item_text.armPotence, {})
	end

	-- 获取装备数据
	local descString = GetLocalizeStringBy("key_2137") .. level .. "/"..equip_desc.level_limit_ratio * UserModel.getHeroLevel() .. "\n"
	-- 映射关系
	local potentialityConfig = { hp = 1, gen_att = 9, phy_att = 2, magic_att =3, phy_def = 4, magic_def = 5}

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
		base_nums = base_nums + 1
	end

	-- 背景
	local fullRect = CCRectMake(0,0,196, 198)
	local insetRect = CCRectMake(50,50,96,98)
	local bgSprite = CCScale9Sprite:create("images/item/equipinfo/bg_9s.png")
	bgSprite:setContentSize(CCSizeMake(640, 640))
	bgSprite:setAnchorPoint(ccp(0.5, 0.5))
	bgSprite:setPosition(ccp(_bgLayer:getContentSize().width*0.5, _bgLayer:getContentSize().height*0.5))
	bgSprite:setScale(g_fScaleX)
	_bgLayer:addChild(bgSprite, 1)

	--
	local heightRate = 0.92
	if(_showType == 2)then
		heightRate = 0.88
		--武将名称
		local explainLabel1 = CCRenderLabel:create(GetLocalizeStringBy("key_1682"), g_sFontPangWa,33,1,ccc3(0x00,0x00,0x00),type_shadow)
		explainLabel1:setPosition(ccp(bgSprite:getContentSize().width/2-100, bgSprite:getContentSize().height-50))
		explainLabel1:setColor(ccc3(0xff,0xf0,0x00))
		explainLabel1:setAnchorPoint(ccp(0.5,0.5))
		bgSprite:addChild(explainLabel1)
		
		
		local explainLabel2 = CCRenderLabel:create(equip_desc.name, g_sFontPangWa,33,1,ccc3(0x00,0x00,0x00),type_shadow)
		explainLabel2:setPosition(ccp(bgSprite:getContentSize().width/2+20, bgSprite:getContentSize().height-50))
		explainLabel2:setColor(ccc3(0x0b,0xe5,0x00))
		explainLabel2:setAnchorPoint(ccp(0,0.5))
		bgSprite:addChild(explainLabel2)
	end

	-- 卡牌
	local cardSprite = EquipCardSprite.createSprite(_item_tmpl_id, _item_id, t_equip_score)
	cardSprite:setAnchorPoint(ccp(0.5, 1))
	cardSprite:setPosition(ccp(bgSprite:getContentSize().width*0.25, bgSprite:getContentSize().height*heightRate))
	bgSprite:addChild(cardSprite)
	-- cardSprite:setScale(MainScene.elementScale)

----------------------------------------------- 属性介绍 -----------------------------------------
	local fullRect_attr = CCRectMake(0,0,61,47)
	local insetRect_attr = CCRectMake(10,10,41,27)
	-- 属性背景
	local attrBg = CCScale9Sprite:create("images/copy/fort/textbg.png", fullRect_attr, insetRect_attr)
	attrBg:setPreferredSize(CCSizeMake(260, 440))
	attrBg:setAnchorPoint(ccp(0.5, 1))
	attrBg:setPosition(ccp(bgSprite:getContentSize().width*0.75, bgSprite:getContentSize().height*heightRate))
	bgSprite:addChild(attrBg)
	-- attrBg:setScale(MainScene.elementScale)

	-- 顶部
	local topSprite = CCSprite:create("images/item/equipinfo/topbg.png")
	topSprite:setAnchorPoint(ccp(0.5, 0.5))
	topSprite:setPosition(ccp(bgSprite:getContentSize().width*0.5, bgSprite:getContentSize().height))
	bgSprite:addChild(topSprite, 2)
	-- topSprite:setScale(myScale)

	-- 关闭按钮bar
	local closeMenuBar = CCMenu:create()
	closeMenuBar:setPosition(ccp(0, 0))
	topSprite:addChild(closeMenuBar)

	-- 标题
	if(_showType == 1)then
		-- 正常
		local titleLabel = CCRenderLabel:create(GetLocalizeStringBy("key_2541"), g_sFontPangWa, 35, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	    titleLabel:setColor(ccc3(0xff, 0xf6, 0x00))
	    titleLabel:setAnchorPoint(ccp(0.5,0.5))
	    titleLabel:setPosition(ccp( ( topSprite:getContentSize().width)/2, topSprite:getContentSize().height*0.6))
	    topSprite:addChild(titleLabel)
	elseif(_showType == 2)then
		-- 好运
		local goodluck = CCSprite:create("images/common/luck.png")
		goodluck:setPosition(ccp(topSprite:getContentSize().width/2,topSprite:getContentSize().height*0.6))
		goodluck:setAnchorPoint(ccp(0.5,0.5))
		topSprite:addChild(goodluck)
	end
	
	-- 关闭按钮
	local closeBtn = LuaMenuItem.createItemImage("images/common/btn_close_n.png", "images/common/btn_close_h.png", closeAction_2 )
	closeBtn:setAnchorPoint(ccp(1, 0.5))
    closeBtn:setPosition(ccp(topSprite:getContentSize().width*1.01, topSprite:getContentSize().height*0.54))
    -- closeBtn:registerScriptTapHandler(closeAction)
	closeMenuBar:addChild(closeBtn)
	closeMenuBar:setTouchPriority(_menu_priority-1)

	-- 简介
	local infoTitleLabel = CCRenderLabel:create(GetLocalizeStringBy("key_2371"), g_sFontName, 25, 2, ccc3( 0x00, 0x00, 0x0d), type_stroke)
    -- nameLabel:setSourceAndTargetColor(ccc3( 0xff, 0xf0, 0x49), ccc3( 0xff, 0xa2, 0x00));
    infoTitleLabel:setColor(ccc3(0x8a, 0xff, 0x00))
    infoTitleLabel:setAnchorPoint(ccp(0, 0))
    infoTitleLabel:setPosition(ccp( attrBg:getContentSize().width*0.08, attrBg:getContentSize().height*0.9))
    attrBg:addChild(infoTitleLabel)

    -- 分割线
	local lineSprite_0 = CCSprite:create("images/item/equipinfo/line.png")
	lineSprite_0:setAnchorPoint(ccp(0, 1))
	lineSprite_0:setScaleX(2)
	lineSprite_0:setPosition(ccp(attrBg:getContentSize().width*0.02, attrBg:getContentSize().height*0.88))
	attrBg:addChild(lineSprite_0)

	-- 描述
	local noLabel = CCLabelTTF:create(equip_desc.info, g_sFontName, 23, CCSizeMake(250, 100), kCCTextAlignmentLeft, kCCVerticalTextAlignmentTop)
	noLabel:setColor(ccc3(0x78, 0x25, 0x00))
	noLabel:setAnchorPoint(ccp(0, 1))
	noLabel:setPosition(ccp(attrBg:getContentSize().width*0.07, attrBg:getContentSize().height*0.85))
	attrBg:addChild(noLabel)

    -- 本体属性
	local attrLabelTitle = CCRenderLabel:create(GetLocalizeStringBy("key_1293"), g_sFontName, 25, 2, ccc3( 0x00, 0x00, 0x0d), type_stroke)
	attrLabelTitle:setColor(ccc3(0x8a, 0xff, 0x00))
	attrLabelTitle:setAnchorPoint(ccp(0, 0.5))
	attrLabelTitle:setPosition(ccp(attrBg:getContentSize().width*0.08, attrBg:getContentSize().height*0.59))
	attrBg:addChild(attrLabelTitle)

	-- 分割线
	local lineSprite = CCSprite:create("images/item/equipinfo/line.png")
	lineSprite:setAnchorPoint(ccp(0, 0))
	lineSprite:setScaleX(2)
	lineSprite:setPosition(ccp(attrBg:getContentSize().width*0.02, attrBg:getContentSize().height*0.54))
	attrBg:addChild(lineSprite)

	-- 描述
	local descLabel = CCLabelTTF:create(descString, g_sFontName, 23, CCSizeMake(225, 80), kCCTextAlignmentLeft, kCCVerticalTextAlignmentTop)
	descLabel:setColor(ccc3(0x78, 0x25, 0x00))
	descLabel:setAnchorPoint(ccp(0, 1))
	descLabel:setPosition(ccp(attrBg:getContentSize().width*0.1, attrBg:getContentSize().height*0.54))
	attrBg:addChild(descLabel)
	-- 洗练的属性
	if( not table.isEmpty(water_result) )then
		for attr_id, attr_num in pairs(water_result) do
			if(attr_num~=nil)then
				local affixDesc, displayNum = ItemUtil.getAtrrNameAndNum(tonumber(attr_id), tonumber(attr_num) )
				local display_text = affixDesc.sigleName .. ": " .. displayNum
				local displayTextLabel = CCLabelTTF:create(display_text, g_sFontName, 23)
				displayTextLabel:setColor(ccc3(0x00, 0x4b, 0xc8))
				displayTextLabel:setAnchorPoint(ccp(0, 1))
				displayTextLabel:setPosition(ccp(attrBg:getContentSize().width*0.1, attrBg:getContentSize().height*0.54-base_nums*25))
				attrBg:addChild(displayTextLabel)	
				base_nums = base_nums+1
			end
		end
	end

	-- 每级强化成长
	local enchanceLabelTitle = CCRenderLabel:create(GetLocalizeStringBy("key_2336"), g_sFontName, 25, 2, ccc3( 0x00, 0x00, 0x0d), type_stroke)
	enchanceLabelTitle:setColor(ccc3(0x8a, 0xff, 0x00))
	enchanceLabelTitle:setAnchorPoint(ccp(0, 0.5))
	enchanceLabelTitle:setPosition(ccp(attrBg:getContentSize().width*0.08, attrBg:getContentSize().height*0.2))
	attrBg:addChild(enchanceLabelTitle)

	-- 分割线
	local lineSprite2 = CCSprite:create("images/item/equipinfo/line.png")
	lineSprite2:setAnchorPoint(ccp(0, 0))
	lineSprite2:setScaleX(2)
	lineSprite2:setPosition(ccp(attrBg:getContentSize().width*0.02, attrBg:getContentSize().height*0.15))
	attrBg:addChild(lineSprite2)

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

	-- 描述
	local descLabel_PL = CCLabelTTF:create(descString_PL, g_sFontName, 23, CCSizeMake(225, 80), kCCTextAlignmentLeft, kCCVerticalTextAlignmentTop)
	descLabel_PL:setColor(ccc3(0x78, 0x25, 0x00))
	descLabel_PL:setAnchorPoint(ccp(0, 1))
	descLabel_PL:setPosition(ccp(attrBg:getContentSize().width*0.1, attrBg:getContentSize().height*0.15))
	attrBg:addChild(descLabel_PL)


-------------------------------- 几个按钮 ------------------------------
	local actionMenuBar = CCMenu:create()
	actionMenuBar:setPosition(ccp(0, 0))	
	actionMenuBar:setTouchPriority(_menu_priority - 1)
	bgSprite:addChild(actionMenuBar)

	-- 洗练
	-- if(_isWater == true) then
	-- 	local xilianBtn = LuaMenuItem.createItemImage("images/item/equipinfo/btn_xilian_n.png", "images/item/equipinfo/btn_xilian_h.png", menuAction )
	-- 	xilianBtn:setAnchorPoint(ccp(0.5, 0.5))
	--     xilianBtn:setPosition(ccp(bgSprite:getContentSize().width*0.2, bgSprite:getContentSize().height*0.1))
	--     -- xilianBtn:registerScriptTapHandler(menuAction)
	-- 	actionMenuBar:addChild(xilianBtn, 1, Tag_Water)
	-- 	xilianBtn:setScale(MainScene.elementScale)
	-- end
	-- 更换
	local changeBtn = nil
	local removeBtn = nil
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
	print("EquipInfoLayer _isShowLock equipInfo")
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
		changeBtn:setPosition(ccp(bgSprite:getContentSize().width*0.15, bgSprite:getContentSize().height*0.1))
		enhanceBtn:setPosition(ccp(bgSprite:getContentSize().width*0.615, bgSprite:getContentSize().height*0.1))
		removeBtn:setPosition(ccp(bgSprite:getContentSize().width*0.385, bgSprite:getContentSize().height*0.1))
		waterBtn:setPosition(ccp(bgSprite:getContentSize().width*0.85, bgSprite:getContentSize().height*0.1))
	elseif(_isEnhance == true and _isShowLock == true and tonumber(equipInfo.itemDesc.quality) == 5)then
		enhanceBtn:setPosition(ccp(bgSprite:getContentSize().width*0.7, bgSprite:getContentSize().height*0.1))
		_lockBtn:setPosition(ccp(bgSprite:getContentSize().width*0.3, bgSprite:getContentSize().height*0.1))
		_unlockBtn:setPosition(ccp(bgSprite:getContentSize().width*0.3, bgSprite:getContentSize().height*0.1))
	elseif(_isEnhance == true) then
		enhanceBtn:setPosition(ccp(bgSprite:getContentSize().width*0.5, bgSprite:getContentSize().height*0.1))
	end

	if(_showType == 2)then
		-- 确定按钮
		local normalBtn = LuaCC.create9ScaleMenuItem("images/common/btn/btn_green_n.png","images/common/btn/btn_green_h.png",CCSizeMake(200, 71),GetLocalizeStringBy("key_1985"),ccc3(0xfe, 0xdb, 0x1c),35,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00))
		normalBtn:setAnchorPoint(ccp(0.5, 0.5))
		normalBtn:setPosition(ccp(bgSprite:getContentSize().width*0.5, bgSprite:getContentSize().height*0.1))
		normalBtn:registerScriptTapHandler(menuAction)
		actionMenuBar:addChild(normalBtn,1, 12345)
	end
end

-- 创建Layer
function createLayer( template_id,  item_id, isEnhance, isWater, isChange, itemDelegateAction, hid_c, pos_index, menu_priority, showType, p_isShowLock)
	print("itemDelegateAction", template_id,  item_id, isEnhance, isWater, isChange, itemDelegateAction, menu_priority,showType)
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
	if(_showType == 2)then
		_menu_priority = -520
	end
	_bgLayer = CCLayerColor:create(ccc4(0,0,0,155)) --MainScene.createBaseLayer(nil, false, false, true)
	-- _bgLayer:setContentSize(CCSizeMake(640, 560))
	_bgLayer:registerScriptHandler(onNodeEvent)
	create()

	-- 铁匠铺 第4步 点击武器信息面板 强化按钮
	local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.3),CCCallFunc:create(function ( ... )
		addGuideEquipGuide4()
	end))
	_bgLayer:runAction(seq)

	return _bgLayer;
end

-- 新手引导
function getGuideObject()
	return enhanceBtn
end

---[==[铁匠铺 第4步
---------------------新手引导---------------------------------
function addGuideEquipGuide4( ... )
	require "script/guide/NewGuide"
	require "script/guide/EquipGuide"
    if(NewGuide.guideClass ==  ksGuideSmithy and EquipGuide.stepNum == 3) then
    	EquipGuide.changLayer()
        local equipButton = getGuideObject()
        local touchRect   = getSpriteScreenRect(equipButton)
        EquipGuide.show(4, touchRect)
    end
end
---------------------end-------------------------------------
--]==]
