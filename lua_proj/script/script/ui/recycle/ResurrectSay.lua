-- Filename: ResurrectSay.lua
-- Author: zhang zihang
-- Date: 2013-12-3
-- Purpose: 该文件用于: 重生说明页面

module ("ResurrectSay", package.seeall)

function init()
	bgLayer = nil
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
		bgLayer:registerScriptTouchHandler(onTouchesHandler, false, -555, true)
		bgLayer:setTouchEnabled(true)
	elseif (event == "exit") then

		bgLayer:unregisterScriptTouchHandler()
	end
end

function closeCb()
	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/guanbi.mp3")
	bgLayer:removeFromParentAndCleanup(true)
	bgLayer = nil
end

function createLayer()
	init()

	bgLayer = CCLayerColor:create(ccc4(0,0,0,155))
	bgLayer:registerScriptHandler(onNodeEvent)

	require "script/ui/main/MainScene"
    local myScale = MainScene.elementScale
	local mySize = CCSizeMake(620,720)

	local fullRect = CCRectMake(0, 0, 213, 171)
	local insetRect = CCRectMake(84, 84, 2, 3)
    local breakSayBg = CCScale9Sprite:create("images/common/viewbg1.png",fullRect,insetRect)
    breakSayBg:setContentSize(mySize)
    breakSayBg:setScale(myScale)
    breakSayBg:setPosition(ccp(g_winSize.width*0.5,g_winSize.height*0.5))
    breakSayBg:setAnchorPoint(ccp(0.5,0.5))
    bgLayer:addChild(breakSayBg)

    local labelTitle = CCRenderLabel:create(GetLocalizeStringBy("key_3223"), g_sFontPangWa,35,2,ccc3(0xff,0xff,0xff),type_shadow)
	labelTitle:setPosition(ccp(breakSayBg:getContentSize().width/2, breakSayBg:getContentSize().height-20))
	labelTitle:setAnchorPoint(ccp(0.5,1))
	labelTitle:setColor(ccc3(0x78,0x25,0x00))
	breakSayBg:addChild(labelTitle)

    local tParam = {

                 GetLocalizeStringBy("key_1436"),
                 GetLocalizeStringBy("key_2530"),
                 GetLocalizeStringBy("key_3385"),
                 GetLocalizeStringBy("key_2683"),
                 GetLocalizeStringBy("key_3101"),
                 GetLocalizeStringBy("key_1485"),
                 GetLocalizeStringBy("key_3102"),
                 GetLocalizeStringBy("key_2904"),
                 GetLocalizeStringBy("key_2801"),
                 GetLocalizeStringBy("key_4004"),
                 GetLocalizeStringBy("key_4005"),
                 GetLocalizeStringBy("key_4006"),
                 GetLocalizeStringBy("key_2651"),


            }

    for i=1, #tParam do
        local content = CCLabelTTF:create(tParam[i] , g_sFontName ,24)
        content:setColor(ccc3(0x78,0x25,0x00))
        content:setPosition(ccp(40,breakSayBg:getContentSize().height-35- 45*i))
        content:setAnchorPoint(ccp(0,1))
        breakSayBg:addChild(content)

    end        

	-- local content = CCLabelTTF:create(GetLocalizeStringBy("key_1436"), g_sFontName ,24)
	-- content:setColor(ccc3(0x78,0x25,0x00))
 --    content:setPosition(ccp(40,breakSayBg:getContentSize().height-80))
 --    content:setAnchorPoint(ccp(0,1))
 --    breakSayBg:addChild(content)

 --    local content = CCLabelTTF:create(GetLocalizeStringBy("key_2530"), g_sFontName ,24)
	-- content:setColor(ccc3(0x78,0x25,0x00))
 --    content:setPosition(ccp(40,breakSayBg:getContentSize().height-125))
 --    content:setAnchorPoint(ccp(0,1))
 --    breakSayBg:addChild(content)

 --    local content = CCLabelTTF:create(GetLocalizeStringBy("key_3385"), g_sFontName ,24)
	-- content:setColor(ccc3(0x78,0x25,0x00))
 --    content:setPosition(ccp(40,breakSayBg:getContentSize().height-170))
 --    content:setAnchorPoint(ccp(0,1))
 --    breakSayBg:addChild(content)

 --    local content = CCLabelTTF:create(GetLocalizeStringBy("key_2683"), g_sFontName ,24)
	-- content:setColor(ccc3(0x78,0x25,0x00))
 --    content:setPosition(ccp(40,breakSayBg:getContentSize().height-215))
 --    content:setAnchorPoint(ccp(0,1))
 --    breakSayBg:addChild(content)

 --    local content = CCLabelTTF:create(GetLocalizeStringBy("key_3101"), g_sFontName ,24)
 --    content:setColor(ccc3(0x78,0x25,0x00))
 --    content:setPosition(ccp(40,breakSayBg:getContentSize().height-260))
 --    content:setAnchorPoint(ccp(0,1))
 --    breakSayBg:addChild(content)


 --    local content = CCLabelTTF:create(GetLocalizeStringBy("key_1485"), g_sFontName ,24)
	-- content:setColor(ccc3(0x78,0x25,0x00))
 --    content:setPosition(ccp(40,breakSayBg:getContentSize().height-305))
 --    content:setAnchorPoint(ccp(0,1))
 --    breakSayBg:addChild(content)

 --    local content = CCLabelTTF:create(GetLocalizeStringBy("key_3102"), g_sFontName ,24)
 --    content:setColor(ccc3(0x78,0x25,0x00))
 --    content:setPosition(ccp(40,breakSayBg:getContentSize().height-350))
 --    content:setAnchorPoint(ccp(0,1))
 --    breakSayBg:addChild(content)

 --    local content = CCLabelTTF:create(GetLocalizeStringBy("key_2904"), g_sFontName ,24)
 --    content:setColor(ccc3(0x78,0x25,0x00))
 --    content:setPosition(ccp(40,breakSayBg:getContentSize().height-395))
 --    content:setAnchorPoint(ccp(0,1))
 --    breakSayBg:addChild(content)

 --    local content = CCLabelTTF:create(GetLocalizeStringBy("key_2801"), g_sFontName ,24)
 --    content:setColor(ccc3(0x78,0x25,0x00))
 --    content:setPosition(ccp(40,breakSayBg:getContentSize().height-440))
 --    content:setAnchorPoint(ccp(0,1))
 --    breakSayBg:addChild(content)


 --    -- added by zhz 
 --    local content = CCLabelTTF:create(GetLocalizeStringBy("key_4004"), g_sFontName ,24)
 --    content:setColor(ccc3(0x78,0x25,0x00))
 --    content:setPosition(ccp(40,breakSayBg:getContentSize().height-485))
 --    content:setAnchorPoint(ccp(0,1))
 --    breakSayBg:addChild(content)
    
 --    local content = CCLabelTTF:create(GetLocalizeStringBy("key_4005"), g_sFontName ,24)
 --    content:setColor(ccc3(0x78,0x25,0x00))
 --    content:setPosition(ccp(40,breakSayBg:getContentSize().height-530 ))
 --    content:setAnchorPoint(ccp(0,1))
 --    breakSayBg:addChild(content)

 --    -- 
 --    local content = CCLabelTTF:create(GetLocalizeStringBy("key_4006"), g_sFontName ,24)
 --    content:setColor(ccc3(0x78,0x25,0x00))
 --    content:setPosition(ccp(40,breakSayBg:getContentSize().height-575 ))
 --    content:setAnchorPoint(ccp(0,1))
 --    breakSayBg:addChild(content)

 --    local content = CCLabelTTF:create(GetLocalizeStringBy("key_2651"), g_sFontName ,24)
 --    content:setColor(ccc3(0x78,0x25,0x00))
 --    content:setPosition(ccp(40,breakSayBg:getContentSize().height-616))
 --    content:setAnchorPoint(ccp(0,1))
 --    breakSayBg:addChild(content)



	-- 关闭按钮
    local menu = CCMenu:create()
    menu:setPosition(ccp(0,0))
    menu:setTouchPriority(-600)
    breakSayBg:addChild(menu,99)
    local closeBtn = CCMenuItemImage:create("images/common/btn_close_n.png", "images/common/btn_close_h.png")
    closeBtn:setPosition(ccp(mySize.width*1.03,mySize.height*1.03))
    closeBtn:setAnchorPoint(ccp(1,1))
    closeBtn:registerScriptTapHandler(closeCb)
    menu:addChild(closeBtn)

    return bgLayer
end
