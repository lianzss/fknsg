-- Filename: GuildManagementLayer.lua
-- Author: zhang zihang
-- Date: 2013-12-22
-- Purpose: 该文件用于: 军团管理

module ("GuildManagementLayer", package.seeall)

require "script/audio/AudioUtil"
require "script/ui/tip/AnimationTip"

function init()
	_bgLayer = nil
end

function closeCb()
	AudioUtil.playEffect("audio/effect/guanbi.mp3")
	_bgLayer:removeFromParentAndCleanup(true)
	_bgLayer = nil
end

function onTouchesHandler( eventType, x, y )
	if (eventType == "began") then
		-- print("began")
	    return true
    elseif (eventType == "moved") then
    else
        -- print("end")
	end
end

function onNodeEvent(event)
	if event == "enter" then
		_bgLayer:registerScriptTouchHandler(onTouchesHandler, false, -550, true)
		_bgLayer:setTouchEnabled(true)
	elseif (event == "exit") then
		_bgLayer:unregisterScriptTouchHandler()
	end
end

function xuanYan()
	require "script/ui/guild/GuildDeclarationLayer"
	GuildDeclarationLayer.showLayer(1001)
	_bgLayer:removeFromParentAndCleanup(true)
	_bgLayer = nil
end

function miMa()
    require "script/ui/guild/GuildDataCache"
    local myMessage = GuildDataCache.getMineSigleGuildInfo()
    if tonumber(myMessage.member_type) == 2 then
        AnimationTip.showTip(GetLocalizeStringBy("key_1847"))
    end
    if tonumber(myMessage.member_type) == 1 then
    	require "script/ui/guild/GuildCodeLayer"
    	GuildCodeLayer.showLayer()
    	_bgLayer:removeFromParentAndCleanup(true)
    	_bgLayer = nil
    end
end

function check()
    -- 审核  add by chengliang
    require "script/ui/guild/MemberListLayer"
    local memberListLayer = MemberListLayer.createLayer(MemberListLayer.Tag_CheckedList) 
    MainScene.changeLayer(memberListLayer, "memberListLayer")

	_bgLayer:removeFromParentAndCleanup(true)
	_bgLayer = nil
end

function dismiss()
    _bgLayer:removeFromParentAndCleanup(true)
    _bgLayer = nil

    require "script/ui/guild/GuildDataCache"
    require "script/ui/guild/ConfirmCodeLayer"

    local myMessage = GuildDataCache.getMineSigleGuildInfo()
    print_t(myMessage)

    if tonumber(myMessage.member_type) == 2 then
        AnimationTip.showTip(GetLocalizeStringBy("key_2609"))
    end
    if tonumber(myMessage.member_type) == 1 then
        local guildInfo = GuildDataCache.getGuildInfo()
        print_t(guildInfo)

        if tonumber(guildInfo.guild_level) >= 5 then
            AnimationTip.showTip(GetLocalizeStringBy("key_1860"))
        elseif tonumber(guildInfo.member_num) > 1 then
            AnimationTip.showTip(GetLocalizeStringBy("key_1466"))
        else
            ConfirmCodeLayer.showLayer(myMessage.uid,2002)
        end
    end
end

function showLayer()
	init()

	_bgLayer = CCLayerColor:create(ccc4(0,0,0,155))
	_bgLayer:registerScriptHandler(onNodeEvent)
    local scene = CCDirector:sharedDirector():getRunningScene()
    scene:addChild(_bgLayer,999,1500)

    require "script/ui/main/MainScene"
	local myScale = MainScene.elementScale
	local mySize = CCSizeMake(550,454)

	local fullRect = CCRectMake(0, 0, 213, 171)
	local insetRect = CCRectMake(84, 84, 2, 3)
    local guildManagementBg = CCScale9Sprite:create("images/common/viewbg1.png",fullRect,insetRect)
    guildManagementBg:setContentSize(mySize)
    guildManagementBg:setScale(myScale)
    guildManagementBg:setPosition(ccp(g_winSize.width*0.5,g_winSize.height*0.5))
    guildManagementBg:setAnchorPoint(ccp(0.5,0.5))
    _bgLayer:addChild(guildManagementBg)

    local titleBg= CCSprite:create("images/common/viewtitle1.png")
	titleBg:setPosition(ccp(guildManagementBg:getContentSize().width*0.5, guildManagementBg:getContentSize().height-6))
	titleBg:setAnchorPoint(ccp(0.5, 0.5))
	guildManagementBg:addChild(titleBg)

	--奖励的标题文本
	local labelTitle = CCRenderLabel:create(GetLocalizeStringBy("key_1711"), g_sFontPangWa,33,2,ccc3(0x00,0x00,0x0),type_shadow)
	labelTitle:setColor(ccc3(0xff,0xe4,0x00))
    labelTitle:setAnchorPoint(ccp(0.5,0.5))
	labelTitle:setPosition(ccp(titleBg:getContentSize().width*0.5,titleBg:getContentSize().height*0.5))
	titleBg:addChild(labelTitle)

	   -- 关闭按钮
    local menu = CCMenu:create()
    menu:setPosition(ccp(0,0))
    menu:setTouchPriority(-551)
    guildManagementBg:addChild(menu,99)
    local closeBtn = CCMenuItemImage:create("images/common/btn_close_n.png", "images/common/btn_close_h.png")
    closeBtn:setPosition(ccp(mySize.width*1.03,mySize.height*1.03))
    closeBtn:setAnchorPoint(ccp(1,1))
    closeBtn:registerScriptTapHandler(closeCb)
    menu:addChild(closeBtn)

    --军团宣言
    local buttomN = CCScale9Sprite:create("images/common/btn/btn_blue_n.png")
	buttomN:setContentSize(CCSizeMake(200,64))

	local buttomH = CCScale9Sprite:create("images/common/btn/btn_blue_h.png")
	buttomH:setContentSize(CCSizeMake(200,64))

	local xuanYanBtn = CCMenuItemSprite:create(buttomN, buttomH)
    xuanYanBtn:setPosition(ccp(guildManagementBg:getContentSize().width/2,guildManagementBg:getContentSize().height*4/5-25))
    xuanYanBtn:setAnchorPoint(ccp(0.5,0))
    menu:addChild(xuanYanBtn)
    local xuanYanLabel = CCRenderLabel:create(GetLocalizeStringBy("key_2768"), g_sFontPangWa,30,1,ccc3(0x00,0x00,0x0),type_stroke)
    xuanYanLabel:setColor(ccc3(0xfe,0xdb,0x1c))
    local width = (xuanYanBtn:getContentSize().width - xuanYanLabel:getContentSize().width)/2
    local height = xuanYanBtn:getContentSize().height/2
    xuanYanLabel:setPosition(width,54)
    xuanYanBtn:addChild(xuanYanLabel)
    xuanYanBtn:registerScriptTapHandler(xuanYan)

    --军团密码
    local buttomN1 = CCScale9Sprite:create("images/common/btn/btn_blue_n.png")
	buttomN1:setContentSize(CCSizeMake(200,64))

	local buttomH1 = CCScale9Sprite:create("images/common/btn/btn_blue_h.png")
	buttomH1:setContentSize(CCSizeMake(200,64))

	local miMaBtn = CCMenuItemSprite:create(buttomN1, buttomH1)
    miMaBtn:setPosition(ccp(guildManagementBg:getContentSize().width/2,guildManagementBg:getContentSize().height*3/5-25))
    miMaBtn:setAnchorPoint(ccp(0.5,0))
    menu:addChild(miMaBtn)
    local miMaLabel = CCRenderLabel:create(GetLocalizeStringBy("key_3130"), g_sFontPangWa,30,1,ccc3(0x00,0x00,0x0),type_stroke)
    miMaLabel:setColor(ccc3(0xfe,0xdb,0x1c))
    local width = (miMaBtn:getContentSize().width - miMaLabel:getContentSize().width)/2
    local height = miMaBtn:getContentSize().height/2
    miMaLabel:setPosition(width,54)
    miMaBtn:addChild(miMaLabel)
    miMaBtn:registerScriptTapHandler(miMa)

    --成员审核
    local buttomN2 = CCScale9Sprite:create("images/common/btn/btn_blue_n.png")
	buttomN2:setContentSize(CCSizeMake(200,64))

	local buttomH2 = CCScale9Sprite:create("images/common/btn/btn_blue_h.png")
	buttomH2:setContentSize(CCSizeMake(200,64))

	local checkBtn = CCMenuItemSprite:create(buttomN2, buttomH2)
    checkBtn:setPosition(ccp(guildManagementBg:getContentSize().width/2,guildManagementBg:getContentSize().height*2/5-25))
    checkBtn:setAnchorPoint(ccp(0.5,0))
    menu:addChild(checkBtn)
    local checkLabel = CCRenderLabel:create(GetLocalizeStringBy("key_3192"), g_sFontPangWa,30,1,ccc3(0x00,0x00,0x0),type_stroke)
    checkLabel:setColor(ccc3(0xfe,0xdb,0x1c))
    local width = (checkBtn:getContentSize().width - checkLabel:getContentSize().width)/2
    local height = checkBtn:getContentSize().height/2
    checkLabel:setPosition(width,54)
    checkBtn:addChild(checkLabel)
    checkBtn:registerScriptTapHandler(check)

    --解散军团
    local buttomN3 = CCScale9Sprite:create("images/common/btn/btn_blue_n.png")
	buttomN3:setContentSize(CCSizeMake(200,64))

	local buttomH3 = CCScale9Sprite:create("images/common/btn/btn_blue_h.png")
	buttomH3:setContentSize(CCSizeMake(200,64))

	local dismissBtn = CCMenuItemSprite:create(buttomN3, buttomH3)
    dismissBtn:setPosition(ccp(guildManagementBg:getContentSize().width/2,guildManagementBg:getContentSize().height*1/5-25))
    dismissBtn:setAnchorPoint(ccp(0.5,0))
    menu:addChild(dismissBtn)
    local dismissLabel = CCRenderLabel:create(GetLocalizeStringBy("key_1571"), g_sFontPangWa,30,1,ccc3(0x00,0x00,0x0),type_stroke)
    dismissLabel:setColor(ccc3(0xfe,0xdb,0x1c))
    local width = (dismissBtn:getContentSize().width - dismissLabel:getContentSize().width)/2
    local height = dismissBtn:getContentSize().height/2
    dismissLabel:setPosition(width,54)
    dismissBtn:addChild(dismissLabel)
    dismissBtn:registerScriptTapHandler(dismiss)
end
