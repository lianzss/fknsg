-- FileName: AfterTreeBoss.lua 
-- Author: Li Cong 
-- Date: 13-11-2 
-- Purpose: function description of module 

module("AfterTreeBoss", package.seeall)

local _mainLayer = nil
local afterOKCallFun = nil

-- touch事件处理
local function cardLayerTouch(eventType, x, y)
    return true
end


function creteAfterTreeBossLayer( harmData, silverData, afterOKCallFun )
	-- 点击确定按钮传入回调
    afterOKCallFun = afterOKCallFun
    
    local winSize = CCDirector:sharedDirector():getWinSize()
    _mainLayer = CCLayerColor:create(ccc4(11,11,11,200))
    _mainLayer:setTouchEnabled(true)
    _mainLayer:registerScriptTouchHandler(cardLayerTouch,false,-600,true)

    -- 创建背景框
    local bg_sprite = BaseUI.createViewBg(CCSizeMake(520,420))
    local bg_sprite = CCScale9Sprite:create("images/upgrade/upgrade_bg.png")
    bg_sprite:setContentSize(CCSizeMake(520,420))
    bg_sprite:setAnchorPoint(ccp(0.5,0.5))
    bg_sprite:setPosition(ccp(winSize.width*0.5,winSize.height*0.50))
    _mainLayer:addChild(bg_sprite)
    -- 适配
    setAdaptNode(bg_sprite)

    -- 标题
    local titlePanel = CCSprite:create("images/common/viewtitle1.png")
	titlePanel:setAnchorPoint(ccp(0.5, 0.5))
	titlePanel:setPosition(ccp(bg_sprite:getContentSize().width/2, bg_sprite:getContentSize().height-6.6 ))
	bg_sprite:addChild(titlePanel)
	local titleLabel = LuaCCLabel.createShadowLabel(GetLocalizeStringBy("key_2956"), g_sFontPangWa, 34)
	titleLabel:setColor(ccc3(0xff, 0xe4, 0x00))
	titleLabel:setPosition(ccp(90, 10))
	titlePanel:addChild(titleLabel)

	-- 按钮
	local menu = CCMenu:create()
    menu:setTouchPriority(-600)
	menu:setPosition(ccp(0, 0))
	menu:setAnchorPoint(ccp(0, 0))
	bg_sprite:addChild(menu,2)
	-- local closeButton = CCMenuItemImage:create("images/common/btn_close_n.png", "images/common/btn_close_h.png")
	-- closeButton:setAnchorPoint(ccp(0.5, 0.5))
	-- closeButton:setPosition(ccp(bg_sprite:getContentSize().width * 0.955, bg_sprite:getContentSize().height*0.965 ))
	-- closeButton:registerScriptTapHandler(closeButtonCallback)
	-- menu:addChild(closeButton)

	-- 确定
    local okItem = createButtonItem(GetLocalizeStringBy("key_1985"))
    okItem:setAnchorPoint(ccp(0.5,0.5))
    okItem:registerScriptTapHandler(closeButtonCallback)
    menu:addChild(okItem,2)
    okItem:setPosition(ccp(bg_sprite:getContentSize().width*0.5,75))

    -- 战绩如下
    local line = CCScale9Sprite:create("images/common/line2.png")
    line:setAnchorPoint(ccp(0.5,0.5))
    line:setPosition(ccp(bg_sprite:getContentSize().width*0.5,bg_sprite:getContentSize().height-85))
    bg_sprite:addChild(line)
    local font_str = GetLocalizeStringBy("key_1221")
    local font = CCRenderLabel:create(font_str, g_sFontPangWa, 30, 1, ccc3( 0xff, 0xff, 0xff), type_stroke)
    font:setAnchorPoint(ccp(0.5,0.5))
    font:setColor(ccc3(0x78,0x25,0x00))
    font:setPosition(ccp(line:getContentSize().width*0.5,line:getContentSize().height*0.5))
    line:addChild(font)

    -- 挑战伤害总值
	local bg1 = CCScale9Sprite:create("images/common/labelbg_white.png")
	bg1:setContentSize(CCSizeMake(450,45))
	bg1:setAnchorPoint(ccp(0.5,1))
	bg1:setPosition(ccp(bg_sprite:getContentSize().width*0.5,bg_sprite:getContentSize().height-125))
	bg_sprite:addChild(bg1)
	local font1 = CCRenderLabel:create(GetLocalizeStringBy("key_3105"), g_sFontPangWa, 30, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	font1:setAnchorPoint(ccp(0,0.5))
	font1:setColor(ccc3(0xfe,0xdb,0x1c))
	font1:setPosition(ccp(10,bg1:getContentSize().height*0.5))
	bg1:addChild(font1)
	-- 伤害数值
	local harm = harmData or 0
	local font2 = CCRenderLabel:create(harm, g_sFontPangWa, 30, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	font2:setAnchorPoint(ccp(0,0.5))
	font2:setColor(ccc3(0xff,0x42,0x00))
	font2:setPosition(ccp(222,bg1:getContentSize().height*0.5))
	bg1:addChild(font2)
	
    -- 获得银币奖励
    local bg2 = CCScale9Sprite:create("images/common/labelbg_white.png")
	bg2:setContentSize(CCSizeMake(450,45))
	bg2:setAnchorPoint(ccp(0.5,1))
	bg2:setPosition(ccp(bg_sprite:getContentSize().width*0.5,bg_sprite:getContentSize().height-200))
	bg_sprite:addChild(bg2)
    local coin = CCRenderLabel:create(GetLocalizeStringBy("key_2423"), g_sFontPangWa, 30, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	coin:setAnchorPoint(ccp(0,0.5))
	coin:setColor(ccc3(0xfe,0xdb,0x1c))
	coin:setPosition(ccp(10,bg2:getContentSize().height*0.5))
	bg2:addChild(coin)
    local icon = CCSprite:create("images/common/coin.png")
	icon:setAnchorPoint(ccp(0,0.5))
	icon:setPosition(ccp(222,bg2:getContentSize().height*0.5))
	bg2:addChild(icon)
	-- 获得银币数量
	local coinData = silverData or 0
	local coin_data = CCRenderLabel:create(coinData, g_sFontPangWa, 30, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	coin_data:setAnchorPoint(ccp(0,0.5))
	coin_data:setColor(ccc3(0xd7,0xd7,0xd7))
	coin_data:setPosition(ccp(252,bg2:getContentSize().height*0.5))
	bg2:addChild(coin_data)

    return _mainLayer
end

-- 按钮item
function createButtonItem( str )
    local normalSprite  =CCScale9Sprite:create("images/common/btn/btn_green_n.png")
    local selectSprite  =CCScale9Sprite:create("images/common/btn/btn_green_h.png")
    local item = CCMenuItemSprite:create(normalSprite,selectSprite)
    -- 字体
    local item_font = CCRenderLabel:create( str , g_sFontPangWa, 35, 2, ccc3( 0x00, 0x00, 0x00), type_stroke)
    item_font:setColor(ccc3(0xfe, 0xdb, 0x1c))
    item_font:setAnchorPoint(ccp(0.5,0.5))
    item_font:setPosition(ccp(item:getContentSize().width*0.5,item:getContentSize().height*0.5))
    item:addChild(item_font)
    return item
end

-- 关闭按钮回调
function closeButtonCallback( tag, sender )
    -- 音效
    require "script/audio/AudioUtil"
    AudioUtil.playEffect("audio/effect/zhujiemian.mp3")

	require "script/battle/BattleLayer"
    BattleLayer.closeLayer()
	-- 自定义回调
	if(afterOKCallFun ~= nil)then
		afterOKCallFun()
	end
end




































