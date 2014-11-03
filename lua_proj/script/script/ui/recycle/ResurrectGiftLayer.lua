-- Filename: ResurrectGiftLayer.lua
-- Author: zhang zihang
-- Date: 2013-12-3
-- Purpose: 该文件用于: 武将重生的奖励窗口

module ("ResurrectGiftLayer", package.seeall)

function init()
	_giftTable = {}

	_otherGift = {}

	_giftNum = 0

	_myScale = nil
	_mySize = nil

	_bgLayer = nil
end

local function onTouchesHandler( eventType, x, y )
	if (eventType == "began") then
		-- print("began")
	    return true
    elseif (eventType == "moved") then
  
    else
        -- print("end")
	end
end

local function onNodeEvent( event )
	if (event == "enter") then
		_bgLayer:registerScriptTouchHandler(onTouchesHandler, false, -435, true)
		_bgLayer:setTouchEnabled(true)
	elseif (event == "exit") then

		_bgLayer:unregisterScriptTouchHandler()
	end
end

function closeCb()
	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/guanbi.mp3")
	_bgLayer:removeFromParentAndCleanup(true)
	_bgLayer = nil
end

function createBackGround()
	-- 背景
	local fullRect = CCRectMake(0, 0, 213, 171)
	local insetRect = CCRectMake(84, 84, 2, 3)
    local breakDownGiftBg = CCScale9Sprite:create("images/common/viewbg1.png",fullRect,insetRect)
    breakDownGiftBg:setContentSize(_mySize)
    breakDownGiftBg:setScale(0.01*_myScale)
    breakDownGiftBg:setPosition(ccp(g_winSize.width*0.5,g_winSize.height*0.5))
    breakDownGiftBg:setAnchorPoint(ccp(0.5,0.5))
    _bgLayer:addChild(breakDownGiftBg)

    local titleBg= CCSprite:create("images/common/viewtitle1.png")
	titleBg:setPosition(ccp(breakDownGiftBg:getContentSize().width*0.5, breakDownGiftBg:getContentSize().height-6))
	titleBg:setAnchorPoint(ccp(0.5, 0.5))
	breakDownGiftBg:addChild(titleBg)

	--奖励的标题文本
	local labelTitle = CCRenderLabel:create(GetLocalizeStringBy("key_2698"), g_sFontPangWa,33,2,ccc3(0x00,0x00,0x0),type_shadow)
    labelTitle:setAnchorPoint(ccp(0.5,0.5))
	labelTitle:setColor(ccc3(0xff,0xe4,0x00))
	labelTitle:setPosition(ccp(titleBg:getContentSize().width*0.5,titleBg:getContentSize().height*0.5))
	titleBg:addChild(labelTitle)

	-- 关闭按钮
    local menu = CCMenu:create()
    menu:setPosition(ccp(0,0))
    menu:setTouchPriority(-551)
    breakDownGiftBg:addChild(menu,99)
    local closeBtn = CCMenuItemImage:create("images/common/btn_close_n.png", "images/common/btn_close_h.png")
    closeBtn:setPosition(ccp(_mySize.width*1.03,_mySize.height*1.03))
    closeBtn:setAnchorPoint(ccp(1,1))
    closeBtn:registerScriptTapHandler(closeCb)
    menu:addChild(closeBtn)

    local explainLabel = CCRenderLabel:create(GetLocalizeStringBy("key_1303"), g_sFontPangWa,30,1,ccc3(0x00,0x00,0x00),type_shadow)
    explainLabel:setColor(ccc3(0xff,0xf0,0x00))
    explainLabel:setPosition(ccp(40,breakDownGiftBg:getContentSize().height-100))
    explainLabel:setAnchorPoint(ccp(0,0))
    breakDownGiftBg:addChild(explainLabel)

    local itemInfoSpite = CCScale9Sprite:create("images/recycle/reward/rewardbg.png")
    if _giftNum <= 4 then
		itemInfoSpite:setContentSize(CCSizeMake(556,150))
	elseif _giftNum >4 and _giftNum <= 8 then
		itemInfoSpite:setContentSize(CCSizeMake(556,300))
	elseif _giftNum > 8 and _giftNum <= 12 then
		itemInfoSpite:setContentSize(CCSizeMake(556,450))
	else
		itemInfoSpite:setContentSize(CCSizeMake(556,600))
	end
    --itemInfoSpite:setContentSize(CCSizeMake(556,150))
    itemInfoSpite:setPosition(ccp(_mySize.width*0.5,breakDownGiftBg:getContentSize().height-120))
    itemInfoSpite:setAnchorPoint(ccp(0.5,1))
    breakDownGiftBg:addChild(itemInfoSpite)

    require "script/ui/item/ItemSprite"
    local positionx = {0,itemInfoSpite:getContentSize().width*0.7/3,itemInfoSpite:getContentSize().width*0.7*2/3,itemInfoSpite:getContentSize().width*0.7}

    local i = 1
    if _giftTable.soul and tonumber(_giftTable.soul) ~= 0 then
        local px = i%4
        if px == 0 then
            px = 4
        end
        local py = math.ceil((i-1)/4)
        if (i-1)%4 == 0 then
            py = py+1
        end

        local soulReward = ItemSprite.getSoulIconSprite()
        soulReward:setAnchorPoint(ccp(0.5,0.4))
        soulReward:setPosition(ccp(itemInfoSpite:getContentSize().width*0.15+positionx[px],itemInfoSpite:getContentSize().height-75-150*(py-1)))
        itemInfoSpite:addChild(soulReward)

        local soulNum = CCRenderLabel:create(tostring(_giftTable.soul), g_sFontName,21,2,ccc3(0x00,0x00,0x00),type_shadow)
        soulNum:setColor(ccc3(0x00,0xff,0x18))
        soulNum:setPosition(ccp(soulReward:getContentSize().width,0))
        soulNum:setAnchorPoint(ccp(1,0))
        soulReward:addChild(soulNum)

        local soulDescript = CCLabelTTF:create(GetLocalizeStringBy("key_1616"), g_sFontName , 21)
        soulDescript:setColor(ccc3(0x78,0x25,0x00))
        soulDescript:setPosition(ccp(itemInfoSpite:getContentSize().width*0.15+positionx[px],itemInfoSpite:getContentSize().height-115-150*(py-1)))
        soulDescript:setAnchorPoint(ccp(0.5,1))
        itemInfoSpite:addChild(soulDescript)
        i = i+1
    end

    if _giftTable.silver and tonumber(_giftTable.silver) ~= 0 then
        local px = i%4
        if px == 0 then
            px = 4
        end
        local py = math.ceil((i-1)/4)
        if (i-1)%4 == 0 then
            py = py+1
        end
        
        local silverReward = ItemSprite.getSiliverIconSprite()
        silverReward:setAnchorPoint(ccp(0.5,0.4))
        silverReward:setPosition(ccp(itemInfoSpite:getContentSize().width*0.15+positionx[px],itemInfoSpite:getContentSize().height-75-150*(py-1)))
        itemInfoSpite:addChild(silverReward)

        local silverNum = CCRenderLabel:create(tostring(_giftTable.silver), g_sFontName,21,2,ccc3(0x00,0x00,0x00),type_shadow)
        silverNum:setColor(ccc3(0x00,0xff,0x18))
        silverNum:setPosition(ccp(silverReward:getContentSize().width,0))
        silverNum:setAnchorPoint(ccp(1,0))
        silverReward:addChild(silverNum)

        local silverDescript = CCLabelTTF:create(GetLocalizeStringBy("key_1687"), g_sFontName , 21)
        silverDescript:setColor(ccc3(0x78,0x25,0x00))
        silverDescript:setPosition(ccp(itemInfoSpite:getContentSize().width*0.15+positionx[px],itemInfoSpite:getContentSize().height-115-150*(py-1)))
        silverDescript:setAnchorPoint(ccp(0.5,1))
        itemInfoSpite:addChild(silverDescript)
        i = i+1
    end

    --local i = 3
    require "script/ui/item/ItemUtil"
    if _giftTable and _giftTable.item then
        for k,v in pairs(_giftTable.item) do
            local itemSprite = ItemSprite.getItemSpriteById(tonumber(k))
            itemSprite:setAnchorPoint(ccp(0.5,0.4))
            
            local px = i%4
            if px == 0 then
                px = 4
            end
            local py = math.ceil((i-1)/4)
            if (i-1)%4 == 0 then
                py = py+1
            end
            
            itemSprite:setPosition(ccp(itemInfoSpite:getContentSize().width*0.15+positionx[px],itemInfoSpite:getContentSize().height-75-150*(py-1)))
            itemInfoSpite:addChild(itemSprite)

            local itemNum = CCRenderLabel:create(tostring(v), g_sFontName,21,2,ccc3(0x00,0x00,0x00),type_shadow)
            itemNum:setColor(ccc3(0x00,0xff,0x18))
            itemNum:setPosition(ccp(itemSprite:getContentSize().width,0))
            itemNum:setAnchorPoint(ccp(1,0))
            itemSprite:addChild(itemNum)


            local itemDescript = CCLabelTTF:create(ItemUtil.getItemById(k).name, g_sFontName , 21)
            itemDescript:setColor(ccc3(0x78,0x25,0x00))
            itemDescript:setPosition(ccp(itemInfoSpite:getContentSize().width*0.15+positionx[px],itemInfoSpite:getContentSize().height-115-150*(py-1)))
            itemDescript:setAnchorPoint(ccp(0.5,1))
            itemInfoSpite:addChild(itemDescript)
            
            i = i+1
        end
    end

    require "db/DB_Heroes"
    if _giftTable and _giftTable.hero then
        print(GetLocalizeStringBy("key_2463"))
        print_t(_giftTable.hero)
        for k,v in pairs(_giftTable.hero) do
            local thisHero = DB_Heroes.getDataById(v.htid)
            print(GetLocalizeStringBy("key_1934"))
            print_t(thisHero)
            local heroSprite = CCSprite:create("images/base/hero/head_icon/" .. thisHero.head_icon_id)
            local heroSpriteBg = CCSprite:create("images/hero/quality/"..thisHero.star_lv .. ".png")
            heroSprite:setAnchorPoint(ccp(0.5,0.5))
            heroSprite:setPosition(ccp(heroSpriteBg:getContentSize().width/2,heroSpriteBg:getContentSize().height/2))
            heroSpriteBg:addChild(heroSprite)
            heroSpriteBg:setAnchorPoint(ccp(0.5,0.4))

            local px = i%4
            if px == 0 then
                px = 4
            end
            local py = math.ceil((i-1)/4)
            if (i-1)%4 == 0 then
                py = py+1
            end
            
            heroSpriteBg:setPosition(ccp(itemInfoSpite:getContentSize().width*0.15+positionx[px],itemInfoSpite:getContentSize().height-75-150*(py-1)))
            itemInfoSpite:addChild(heroSpriteBg)

            local heroNum = CCRenderLabel:create(tostring(v.num), g_sFontName,21,2,ccc3(0x00,0x00,0x00),type_shadow)
            heroNum:setColor(ccc3(0x00,0xff,0x18))
            heroNum:setPosition(ccp(heroSpriteBg:getContentSize().width,0))
            heroNum:setAnchorPoint(ccp(1,0))
            heroSpriteBg:addChild(heroNum)

            local heroDescript = CCLabelTTF:create(thisHero.name, g_sFontName , 21)
            heroDescript:setColor(ccc3(0x78,0x25,0x00))
            heroDescript:setPosition(ccp(itemInfoSpite:getContentSize().width*0.15+positionx[px],itemInfoSpite:getContentSize().height-115-150*(py-1)))
            heroDescript:setAnchorPoint(ccp(0.5,1))
            itemInfoSpite:addChild(heroDescript)

            i = i+1
        end
    end

    i = nil
    --[[local jewelReward = ItemSprite.getJewelSprite()
    jewelReward:setAnchorPoint(ccp(0.5,0.4))
    jewelReward:setPosition(ccp(itemInfoSpite:getContentSize().width*0.15+itemInfoSpite:getContentSize().width*0.7*2/3,itemInfoSpite:getContentSize().height*0.5))
    itemInfoSpite:addChild(jewelReward)

    local jewelNum = CCRenderLabel:create(tostring(_giftTable.jewel), g_sFontName,21,2,ccc3(0x00,0x00,0x00),type_shadow)
    jewelNum:setColor(ccc3(0x00,0xff,0x18))
    jewelNum:setPosition(ccp(jewelReward:getContentSize().width,0))
    jewelNum:setAnchorPoint(ccp(1,0))
    jewelReward:addChild(jewelNum)

    local jewelDescript = CCLabelTTF:create(GetLocalizeStringBy("key_1510"), g_sFontName , 21)
    jewelDescript:setColor(ccc3(0x78,0x25,0x00))
    jewelDescript:setPosition(ccp(itemInfoSpite:getContentSize().width*0.15+itemInfoSpite:getContentSize().width*0.7*2/3,itemInfoSpite:getContentSize().height*0.5-40))
    jewelDescript:setAnchorPoint(ccp(0.5,1))
    itemInfoSpite:addChild(jewelDescript)]]

	local makeSureButton = LuaCC.create9ScaleMenuItem("images/common/btn/btn_bg_n.png","images/common/btn/btn_bg_h.png",CCSizeMake(200, 73),GetLocalizeStringBy("key_1465"),ccc3(0xfe, 0xdb, 0x1c),35,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00))
	makeSureButton:setAnchorPoint(ccp(0.5, 0.5))
    makeSureButton:setPosition(ccp(_mySize.width/2, 80))
    makeSureButton:registerScriptTapHandler(closeCb)
	menu:addChild(makeSureButton)

    local array = CCArray:create()
    local scale1 = CCScaleTo:create(0.08,1.2*_myScale)
    local fade = CCFadeIn:create(0.06)
    local spawn = CCSpawn:createWithTwoActions(scale1,fade)
    local scale2 = CCScaleTo:create(0.07,0.9*_myScale)
    local scale3 = CCScaleTo:create(0.07,1*_myScale)
    array:addObject(scale1)
    array:addObject(scale2)
    array:addObject(scale3)
    local seq = CCSequence:create(array)

    breakDownGiftBg:runAction(seq)
end

function createLayer(giftArray)
	init()

    print(GetLocalizeStringBy("key_1263"))
    print_t(giftArray)
	
	_bgLayer = CCLayerColor:create(ccc4(0,0,0,155))
	_bgLayer:registerScriptHandler(onNodeEvent)

	require "script/ui/main/MainScene"
    _myScale = MainScene.elementScale

    _giftNum = 0

    if giftArray.soul and tonumber(giftArray.soul) ~= 0 then
        _giftNum = _giftNum+1
    end
    
    if giftArray.silver and tonumber(giftArray.silver) ~= 0 then
        _giftNum = _giftNum+1
    end
    

    if giftArray and giftArray.item then
    	_giftNum = _giftNum+(table.count(giftArray.item))
    	--[[for i=1,#giftArray.item do
    		table.insert(_otherGift,giftArray.item[i])
    	end]] 
    end

    if giftArray and giftArray.hero then
    	_giftNum = _giftNum+(table.count(giftArray.hero))
    	--[[for i=1,#giftArray.hero do
    		table.insert(_otherGift,giftArray.hero[i])
    	end]]
    end

    print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
    print(_giftNum)
    if _giftNum <= 4 then
		_mySize = CCSizeMake(620,410)
	elseif _giftNum >4 and _giftNum <= 8 then
		_mySize = CCSizeMake(620,560)
	elseif _giftNum > 8 and _giftNum <= 12 then
		_mySize = CCSizeMake(620,710)
	else
		_mySize = CCSizeMake(620,860)
	end

	_giftTable = giftArray

	createBackGround()
	return _bgLayer
end
