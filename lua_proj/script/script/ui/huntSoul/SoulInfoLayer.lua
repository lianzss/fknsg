-- FileName: SoulInfoLayer.lua 
-- Author: Zhang zihang
-- Date: 14-2-17 
-- Purpose: 战魂信息面板

module("SoulInfoLayer", package.seeall)

require "script/ui/main/MainScene"
require "script/audio/AudioUtil"
require "script/ui/item/ItemUtil"
require "script/ui/item/ItemSprite"
require "script/ui/huntSoul/HuntSoulData"
require "script/utils/BaseUI"
require "script/model/DataCache"

local _bgLayer
local myScale
local mySize
local spriteBg

local _itemTempId
local _itemId
local _priority
local _zOrder
local _isChange
local _huntData
local _attributeData
local _h_id 
local _h_pos

local function init()
	_bgLayer = nil
	myScale = nil
	mySize = nil
	spriteBg = nil
	_itemTempId = nil
	_itemId = nil
	_priority = nil
	_zOrder = nil
	_isChange = nil
	_huntData = {}
	_attributeData = {}
	_h_id = nil
	_h_pos = nil
end

local function layerToucCb(eventType, x, y)
	return true
end

local function closeAction()
	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/guanbi.mp3")
	_bgLayer:removeFromParentAndCleanup(true)
	_bgLayer = nil
end

local function createBg()
	spriteBg = CCScale9Sprite:create("images/common/viewbg1.png")
	spriteBg:setContentSize(CCSizeMake(mySize.width,mySize.height))
	spriteBg:setPosition(_bgLayer:getContentSize().width*0.5,_bgLayer:getContentSize().height*0.5)
	spriteBg:setScale(myScale)
	spriteBg:setAnchorPoint(ccp(0.5,0.5))
	_bgLayer:addChild(spriteBg)

	local titileSprite = CCSprite:create("images/common/viewtitle1.png")
	titileSprite:setPosition(ccp(spriteBg:getContentSize().width/2,spriteBg:getContentSize().height))
	titileSprite:setAnchorPoint(ccp(0.5,0.5))
	spriteBg:addChild(titileSprite)

	local menuLabel =  CCRenderLabel:create(GetLocalizeStringBy("key_1489"), g_sFontPangWa, 33, 1,ccc3(0x00,0x00,0x00), type_stroke)
	menuLabel:setColor(ccc3(0xff,0xe4,0x00))
	menuLabel:setPosition(ccp(titileSprite:getContentSize().width*0.5,titileSprite:getContentSize().height*0.5+3))
	menuLabel:setAnchorPoint(ccp(0.5,0.5))
	titileSprite:addChild(menuLabel)

	local menu = CCMenu:create()
    menu:setPosition(ccp(0,0))
    menu:setTouchPriority(_priority-1)
    spriteBg:addChild(menu,99)
    local closeBtn = CCMenuItemImage:create("images/common/btn_close_n.png", "images/common/btn_close_h.png")
    closeBtn:setPosition(ccp(spriteBg:getContentSize().width*1.03,spriteBg:getContentSize().height*1.03))
    closeBtn:setAnchorPoint(ccp(1,1))
    closeBtn:registerScriptTapHandler(closeAction)
    menu:addChild(closeBtn)
end

local function upgradeAction()
	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
	require "script/ui/huntSoul/UpgradeFightSoulLayer"

	if not DataCache.getSwitchNodeState(ksSwitchBattleSoul) then
		return
	end

	local upgradeFightSoulLayer 

	local tArgs = {}
	tArgs.hid = _h_id

	--_isChange为真表示在阵容中，为假表示在背包中
	if _isChange == true then
		tArgs.sign = "equipFightSoul"
	else
		tArgs.sign = "fightSoulBag"
	end

	upgradeFightSoulLayer = UpgradeFightSoulLayer.createUpgradeFightSoulLayer(_itemId,tArgs)

	_bgLayer:removeFromParentAndCleanup(true)
	_bgLayer = nil

	MainScene.changeLayer(upgradeFightSoulLayer,"upgradeFightSoulLayer")
end

local function changeAction()
	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
	require "script/ui/formation/ChangeEquipLayer"
	local changeEquipLayer = ChangeEquipLayer.createLayer( nil, _h_id, _h_pos, false, true)
	require "script/ui/main/MainScene"
	MainScene.changeLayer(changeEquipLayer, "changeEquipLayer")
	closeAction()
end

local function createContent()
	--图片
	local flowerBg = CCScale9Sprite:create("images/common/bg/bg_ng_attr.png")
	flowerBg:setContentSize(CCSizeMake(455,275))
	flowerBg:setPosition(ccp(spriteBg:getContentSize().width/2,spriteBg:getContentSize().height-40))
	flowerBg:setAnchorPoint(ccp(0.5,1))
	spriteBg:addChild(flowerBg)

	local huntSprite

	if _itemId ~= nil then
		huntSprite = ItemSprite.getItemSpriteByItemId(_itemTempId,_huntData.va_item_text.fsLevel,false)
	else
		huntSprite = ItemSprite.getItemSpriteByItemId(_itemTempId,0,false)
	end
	huntSprite:setPosition(ccp(100,flowerBg:getContentSize().height/2))
	huntSprite:setAnchorPoint(ccp(0.5,0.5))
	flowerBg:addChild(huntSprite)

	if(table.isEmpty(_huntData.itemDesc))then
		_huntData.itemDesc = ItemUtil.getItemById(_itemTempId)
	end

	require "script/ui/hero/HeroPublicLua"

	local huntName = CCRenderLabel:create(_huntData.itemDesc.name,  g_sFontPangWa, 30, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	huntName:setPosition(flowerBg:getContentSize().width/2, flowerBg:getContentSize().height-10)
	huntName:setAnchorPoint(ccp(0.5,1))
	huntName:setColor(HeroPublicLua.getCCColorByStarLevel(_huntData.itemDesc.quality))
	flowerBg:addChild(huntName)

	print(GetLocalizeStringBy("key_2987"))
	print_t(_huntData)

	local beginY = 55
	local downLen = 0
	if not table.isEmpty(_attributeData) then
		for k,v in pairs(_attributeData) do
			print(GetLocalizeStringBy("key_2145"))
			print_t(_attributeData)
			print(v.desc.displayName)
			local attributeName = CCRenderLabel:create(v.desc.displayName .. "：",  g_sFontPangWa, 24, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
			attributeName:setColor(ccc3(0xff, 0xe4, 0x00))
			local attributeNum = CCRenderLabel:create("+" .. v.displayNum,  g_sFontPangWa, 24, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
			attributeNum:setColor(ccc3(0xff, 0xff, 0xff))

			local attributeInfo = BaseUI.createHorizontalNode({attributeName, attributeNum})
		    attributeInfo:setAnchorPoint(ccp(0, 0.5))
			attributeInfo:setPosition(ccp(flowerBg:getContentSize().width/2, beginY-downLen))
			flowerBg:addChild(attributeInfo)

			downLen = downLen+30
		end
	else
		local expName = CCRenderLabel:create(GetLocalizeStringBy("key_2004"),  g_sFontPangWa, 24, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
		expName:setColor(ccc3(0xff, 0xe4, 0x00))
		local expNum = CCRenderLabel:create("+" .. _huntData.itemDesc.baseExp,  g_sFontPangWa, 24, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
		expNum:setColor(ccc3(0xff, 0xff, 0xff))

		local expInfo = BaseUI.createHorizontalNode({expName, expNum})
	    expInfo:setAnchorPoint(ccp(0, 0.5))
		expInfo:setPosition(ccp(flowerBg:getContentSize().width/2, beginY))
		flowerBg:addChild(expInfo)
	end

	--按钮
	local menu = CCMenu:create()
    menu:setPosition(ccp(0,0))
    menu:setTouchPriority(_priority-1)
    spriteBg:addChild(menu,99)

    local buttonPositionY = spriteBg:getContentSize().height-70-flowerBg:getContentSize().height

	local upgradeButton = LuaCC.create9ScaleMenuItem("images/common/btn/btn1_d.png","images/common/btn/btn1_n.png",CCSizeMake(200, 73),GetLocalizeStringBy("key_2298"),ccc3(0xfe, 0xdb, 0x1c),35,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00))
	upgradeButton:setAnchorPoint(ccp(0.5, 0.5))
    upgradeButton:setPosition(ccp(spriteBg:getContentSize().width/3-30,buttonPositionY/2))
    upgradeButton:registerScriptTapHandler(upgradeAction)
	menu:addChild(upgradeButton)

	local changeButton = LuaCC.create9ScaleMenuItem("images/common/btn/btn1_d.png","images/common/btn/btn1_n.png",CCSizeMake(200, 73),GetLocalizeStringBy("key_2761"),ccc3(0xfe, 0xdb, 0x1c),35,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00))
	changeButton:setAnchorPoint(ccp(0.5, 0.5))
    changeButton:setPosition(ccp(spriteBg:getContentSize().width/3-30,buttonPositionY/2))
    changeButton:registerScriptTapHandler(changeAction)
	menu:addChild(changeButton)

	local closeButton = LuaCC.create9ScaleMenuItem("images/common/btn/btn1_d.png","images/common/btn/btn1_n.png",CCSizeMake(200, 73),GetLocalizeStringBy("key_1284"),ccc3(0xfe, 0xdb, 0x1c),35,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00))
	closeButton:setAnchorPoint(ccp(0.5, 0.5))
    closeButton:setPosition(ccp(spriteBg:getContentSize().width*2/3+30,buttonPositionY/2))
    closeButton:registerScriptTapHandler(closeAction)
	menu:addChild(closeButton)

	if _isChange == true then
		closeButton:setVisible(false)
		upgradeButton:setPosition(ccp(spriteBg:getContentSize().width*2/3+30,buttonPositionY/2))
	else
		changeButton:setVisible(false)
	end

	if _itemId == nil then
		closeButton:setVisible(true)
		upgradeButton:setVisible(false)
		changeButton:setVisible(false)
		closeButton:setPosition(ccp(spriteBg:getContentSize().width/2,buttonPositionY/2))
	end

	local starPositionJ = {0,-35,35,-70,70,-105,105}
	local starPositionO = {-17.5,17.5,-52.5,52.5,-87.5,87.5}

	local JorO = tonumber(_huntData.itemDesc.quality)%2

	local flowerBgSize = flowerBg:getContentSize()

	for i = 1,tonumber(_huntData.itemDesc.quality) do
		local starSprite = CCSprite:create("images/formation/changeequip/star.png")
		starSprite:setAnchorPoint(ccp(0.5,0.5))
		if JorO == 0 then
			starSprite:setPosition(ccp(100+starPositionO[i],55))
		else
			starSprite:setPosition(ccp(100+starPositionJ[i],55))
		end
		flowerBg:addChild(starSprite)
	end

	local lineSprite = CCSprite:create("images/hunt/brownline.png")
	lineSprite:setAnchorPoint(ccp(0.5,0.5))
	lineSprite:setPosition(ccp(flowerBgSize.width*3/4,82.5))
	lineSprite:setScaleX(flowerBgSize.width/2/116)
	flowerBg:addChild(lineSprite)

	local levelName = CCRenderLabel:create( GetLocalizeStringBy("key_1986"),  g_sFontPangWa, 24, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	levelName:setColor(ccc3(0xff, 0xe4, 0x00))
	print("裂魂数据")
	print_t(_huntData)
	local levelNum
	if _itemId ~= nil then
		levelNum = CCRenderLabel:create(_huntData.va_item_text.fsLevel .. "/" .. HuntSoulData.getMaxLvByFSTempId(_itemTempId),  g_sFontPangWa, 24, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	else
		levelNum = CCRenderLabel:create("0/" .. HuntSoulData.getMaxLvByFSTempId(_itemTempId),  g_sFontPangWa, 24, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	end
	levelNum:setColor(ccc3(0xff, 0xff, 0xff))

	local levelInfo = BaseUI.createHorizontalNode({levelName, levelNum})
    levelInfo:setAnchorPoint(ccp(0, 0.5))
	levelInfo:setPosition(ccp(flowerBg:getContentSize().width/2, 110))
	flowerBg:addChild(levelInfo)

	local lineSprite2 = CCSprite:create("images/hunt/brownline.png")
	lineSprite2:setAnchorPoint(ccp(0.5,0.5))
	lineSprite2:setPosition(ccp(flowerBgSize.width*3/4,137.5))
	lineSprite2:setScaleX(flowerBgSize.width/2/116)
	flowerBg:addChild(lineSprite2)

	local descName = CCRenderLabel:create( GetLocalizeStringBy("key_3024"),  g_sFontPangWa, 24, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	descName:setColor(ccc3(0xff, 0xe4, 0x00))

	local descContent = CCRenderLabel:create(_huntData.itemDesc.desc,  g_sFontPangWa, 24, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	descContent:setColor(ccc3(0xff, 0xff, 0xff))

	local descInfo = BaseUI.createHorizontalNode({descName, descContent})
    descInfo:setAnchorPoint(ccp(0, 0.5))
	descInfo:setPosition(ccp(flowerBg:getContentSize().width/2, 165))
	flowerBg:addChild(descInfo)

	local fightSoulDes = CCRenderLabel:create(GetLocalizeStringBy("zzh_1033"),  g_sFontPangWa, 24, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	fightSoulDes:setColor(HeroPublicLua.getCCColorByStarLevel(3))
	fightSoulDes:setAnchorPoint(ccp(0.5,0))
	fightSoulDes:setPosition(ccp(spriteBg:getContentSize().width/2,100))
	spriteBg:addChild(fightSoulDes)
end

local function createUI()
	--信息处理
	if _itemId ~= nil then
		_huntData = ItemUtil.getItemInfoByItemId(_itemId)
		if( _huntData == nil )then
			-- 背包中没有 检查英雄身上是否有该战魂
			_huntData = ItemUtil.getFightSoulInfoFromHeroByItemId(_itemId)
			local tempInfo = ItemUtil.getItemById(_huntData.item_template_id)
			_huntData.itemDesc = tempInfo
		end
		-- print("----------")
		-- print_t(_huntData)
		_attributeData = HuntSoulData.getFightSoulAttrByItem_id(_itemId)
	else
		local tempInfo = ItemUtil.getItemById(_itemTempId)
		_huntData.itemDesc = tempInfo
		_attributeData = HuntSoulData.getFSoulAttrBaseDescByTempId(_itemTempId)
	end

	print(GetLocalizeStringBy("key_1489"))
	print_t(_huntData)

	createBg()

	createContent()
end

function showLayer(item_template_id,item_id,isChange, h_id, h_pos, priority,zOrder)
	init()

	_itemTempId = item_template_id
	_itemId = item_id
	_isChange = isChange
	_h_id = h_id
	_h_pos = h_pos

	if priority ~= nil then
		_priority = priority
	else
		_priority = -550
	end

	if zOrder ~= nil then
		_zOrder = zOrder
	else
		_zOrder = 999
	end

	_bgLayer = CCLayerColor:create(ccc4(11,11,11,166))

    _bgLayer:setTouchEnabled(true)
    _bgLayer:registerScriptTouchHandler(layerToucCb,false,_priority,true)
    
    local scene = CCDirector:sharedDirector():getRunningScene()
    scene:addChild(_bgLayer,_zOrder,2013)

	myScale = MainScene.elementScale
	mySize = CCSizeMake(520,460)

	createUI()
end
