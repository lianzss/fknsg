-- Filename: BreakDownSay.lua
-- Author: zhang zihang
-- Date: 2013-11-28
-- Purpose: 该文件用于: 分解说明页面

module ("BreakDownSay", package.seeall)

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
	local mySize = CCSizeMake(620,620)

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


    -- added by zhz
    local tParam= {
                    GetLocalizeStringBy("key_1262"),
                    GetLocalizeStringBy("key_1146"),
                    GetLocalizeStringBy("key_1550"),
                    GetLocalizeStringBy("key_1145"),
                    GetLocalizeStringBy("key_1726"),
                    GetLocalizeStringBy("key_1026"),
                    GetLocalizeStringBy("key_1587"),
                    GetLocalizeStringBy("key_3161"),
                    GetLocalizeStringBy("key_1365"),
                    GetLocalizeStringBy("key_1117"),
                    GetLocalizeStringBy("key_3119"),

                }


    for i=1, #tParam do
        local content = CCLabelTTF:create(tParam[i] , g_sFontName ,24)
        content:setColor(ccc3(0x78,0x25,0x00))
        content:setPosition(ccp(40,breakSayBg:getContentSize().height-35- 45*i))
        content:setAnchorPoint(ccp(0,1))
        breakSayBg:addChild(content)
    end     


	-- local content = CCLabelTTF:create(GetLocalizeStringBy("key_1262"), g_sFontName ,24)
	-- content:setColor(ccc3(0x78,0x25,0x00))
 --    content:setPosition(ccp(40,breakSayBg:getContentSize().height-80))
 --    content:setAnchorPoint(ccp(0,1))
 --    breakSayBg:addChild(content)

 --    local content = CCLabelTTF:create(GetLocalizeStringBy("key_1146"), g_sFontName ,24)
	-- content:setColor(ccc3(0x78,0x25,0x00))
 --    content:setPosition(ccp(40,breakSayBg:getContentSize().height-125))
 --    content:setAnchorPoint(ccp(0,1))
 --    breakSayBg:addChild(content)

 --    local content = CCLabelTTF:create(GetLocalizeStringBy("key_1550"), g_sFontName ,24)
	-- content:setColor(ccc3(0x78,0x25,0x00))
 --    content:setPosition(ccp(40,breakSayBg:getContentSize().height-170))
 --    content:setAnchorPoint(ccp(0,1))
 --    breakSayBg:addChild(content)


 --    local content = CCLabelTTF:create(GetLocalizeStringBy("key_1145"), g_sFontName ,24)
 --    content:setColor(ccc3(0x78,0x25,0x00))
 --    content:setPosition(ccp(40,breakSayBg:getContentSize().height-215))
 --    content:setAnchorPoint(ccp(0,1))
 --    breakSayBg:addChild(content)


 --    local content = CCLabelTTF:create(GetLocalizeStringBy("key_1726"), g_sFontName ,24)
	-- content:setColor(ccc3(0x78,0x25,0x00))
 --    content:setPosition(ccp(40,breakSayBg:getContentSize().height-260))
 --    content:setAnchorPoint(ccp(0,1))
 --    breakSayBg:addChild(content)

 --    local content = CCLabelTTF:create(GetLocalizeStringBy("key_1026"), g_sFontName ,24)
 --    content:setColor(ccc3(0x78,0x25,0x00))
 --    content:setPosition(ccp(40,breakSayBg:getContentSize().height-305))
 --    content:setAnchorPoint(ccp(0,1))
 --    breakSayBg:addChild(content)

 --    local content = CCLabelTTF:create(GetLocalizeStringBy("key_1587"), g_sFontName ,24)
	-- content:setColor(ccc3(0x78,0x25,0x00))
 --    content:setPosition(ccp(40,breakSayBg:getContentSize().height-350))
 --    content:setAnchorPoint(ccp(0,1))
 --    breakSayBg:addChild(content)

 --    local content = CCLabelTTF:create(GetLocalizeStringBy("key_3161"), g_sFontName ,24)
 --    content:setColor(ccc3(0x78,0x25,0x00))
 --    content:setPosition(ccp(40,breakSayBg:getContentSize().height-395))
 --    content:setAnchorPoint(ccp(0,1))
 --    breakSayBg:addChild(content)

 --    local content = CCLabelTTF:create(GetLocalizeStringBy("key_1365"), g_sFontName ,24)
 --    content:setColor(ccc3(0x78,0x25,0x00))
 --    content:setPosition(ccp(40,breakSayBg:getContentSize().height-440))
 --    content:setAnchorPoint(ccp(0,1))
 --    breakSayBg:addChild(content)

 --    local content = CCLabelTTF:create(GetLocalizeStringBy("key_1117"), g_sFontName ,24)
 --    content:setColor(ccc3(0x78,0x25,0x00))
 --    content:setPosition(ccp(40,breakSayBg:getContentSize().height-485))
 --    content:setAnchorPoint(ccp(0,1))
 --    breakSayBg:addChild(content)

 --    local content = CCLabelTTF:create(GetLocalizeStringBy("key_3119"), g_sFontName ,24)
 --    content:setColor(ccc3(0x78,0x25,0x00))
 --    content:setPosition(ccp(40,breakSayBg:getContentSize().height-530))
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
