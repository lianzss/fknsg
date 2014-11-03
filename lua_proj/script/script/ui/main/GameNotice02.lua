-- Filename: GameNotice02.lua.
-- Author: fang.
-- Date: 2013-12-06
-- Purpose: 该文件用于实现进入主场景前的游戏公告

module("GameNotice02", package.seeall)

-- "|0xff,0xff,0xff|活动公告内容0000000000001111======|0x00,0xFF,0x18|活动公告内容0000000000002222"
--[[
local _noticeText = 	"|0x00,0x0F,0x18|公告标题|0x4a,0x15,0x03|        活动公告内容000000000000fdafdsafdasfasd公告内容fsafasdfsdafsd公告内容afasfddas公告内容fsa1111======"..
					"|0x00,0x0F,0x18|公告标题|0x4a,0x15,0x03|        活动公公告内容告内容活动公公告内容告内容活动公公告内容告内容活动公公告内容告内容\n活动公公告内容告内容活动公公告内容告内容活动公公告内容告内容\n活动公公告内容告内容活动公公告内容告内容活动公公告内容告内容\n0公告内容0公告内容0公告内容00000公告内容000公告内容02222======"..
					"|0x00,0xFF,0x18|公告标题|0xf0,0xFF,0x18|活动公告内容000\n0000000003333======"..
					"|0x0f,0x0F,0x18|公告标题|0x0f,0xFF,0x18|活动公告内容0000000000004444======"..
					"|0xff,0xF0,0x18|公告标题|0xff,0x00,0x18|活动公告内容0000000000005555======"..
					"|0xf0,0xFF,0x18|公告标题|0xf0,0x0F,0x00|活动公告内容0000000000006666"
--]]
local _noticeText = nil
local _tagOfNotice02Layer=200123

-- 拉公告的服务器关键字
local _serverKey

--local _noticeText 


-- 进入游戏按钮事件处理
function fnHandlerOfEnterGame(tag, obj)
    if(tag~=nil)then
        require "script/audio/AudioUtil"
        AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
    end
    -- 移除公告面板
    local runningScene = CCDirector:sharedDirector():getRunningScene()
    local noticeLayer = runningScene:getChildByTag(_tagOfNotice02Layer)
    if noticeLayer ~= nil then
        noticeLayer:removeFromParentAndCleanup(true)
    end
   -- _noticeText = nil
end

-- 游戏公告单元格
function createCell(tParam)
	local tPreferredSize = {width=400, height=200}
    local cs9Bg = CCScale9Sprite:create(CCRectMake(52, 44, 6, 4), "images/game_notice/cell_bg.png")
    local size = cs9Bg:getContentSize()

    local csTitleBg = CCSprite:create("images/game_notice/title_bg.png")
    csTitleBg:setAnchorPoint(ccp(0.5, 1))
    cs9Bg:addChild(csTitleBg)

    local clTitle = CCRenderLabel:create(tParam[3], g_sFontPangWa, 25, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
    local colors = string.split(tParam[2], ",")
    clTitle:setColor(ccc3(colors[1], colors[2], colors[3]))
    -- clTitle:setColor(ccc3(0x00, 0xff, 0x18)  --固定标题颜色
    clTitle:setAnchorPoint(ccp(0.5, 0.5))
    clTitle:setPosition(ccp(csTitleBg:getContentSize().width/2, csTitleBg:getContentSize().height/2))
    csTitleBg:addChild(clTitle)

    -- 文本内容区
    -- print("createCell text:",tParam[5])
    local str = "Wrong Platform"

    if g_system_type == kBT_PLATFORM_IOS then
        str = string.gsub(tParam[5], "\n", " \n")
    else
        str = tParam[5]
    end

    print("str  is ", str)
	local clTextContent = CCLabelTTF:create(str, g_sFontName, 21, CCSizeMake(tPreferredSize.width-10, 0), kCCTextAlignmentLeft)
	local colors = string.split(tParam[4], ",")
    clTextContent:setColor(ccc3(colors[1], colors[2], colors[3]))
    clTextContent:setAnchorPoint(ccp(0, 1))
    cs9Bg:addChild(clTextContent)

    local tTitleSize = csTitleBg:getContentSize()
    local tTextContentSize = clTextContent:getContentSize()
    local nBgHeight = tTitleSize.height + 6 + tTextContentSize.height + 6
	if nBgHeight < 151 then
		nBgHeight = 151
	end
    nBgHeight = nBgHeight 
    cs9Bg:setContentSize(CCSizeMake(410, nBgHeight))
    csTitleBg:setPosition(ccp(cs9Bg:getContentSize().width/2, nBgHeight))
    clTextContent:setPosition(ccp(5, nBgHeight-tTitleSize.height))

    return cs9Bg, nBgHeight
end


local function fnHandlerOfOnTouchLayer(event, x, y)
--    printB("..........................................event: ", event)
    return true
end

function showGameNotice()
    if _noticeText == nil or string.len(_noticeText) < 2 then
        return
    end


    -- require "script/model/user/UserModel"
    -- if UserModel.getAvatarLevel() < 7 then
    --     return
    -- end

	require "script/utils/LuaUtil"
    local runningScene = CCDirector:sharedDirector():getRunningScene()
    if runningScene == nil then
        runningScene = CCScene:create()
        CCDirector:sharedDirector():runWithScene(runningScene)
    end

    local layer = CCLayerColor:create(ccc4(0,0,0,100))
    runningScene:addChild(layer, 10001, _tagOfNotice02Layer)
    layer:registerScriptTouchHandler(fnHandlerOfOnTouchLayer, false, -5701, true)
    layer:setTouchEnabled(true)

-- 层背景图
    local csBg = CCSprite:create("images/game_notice/background.png")
    layer:addChild(csBg)
    csBg:setScale(g_fElementScaleRatio)
    csBg:setAnchorPoint(ccp(0.5, 0.5))
    csBg:setPosition(ccp(g_winSize.width/2, g_winSize.height/2))

-- 灰色背景
    local preferredSize = CCSizeMake(443, 410) -- {width=562, height=666}
    -- local cs9Bg = CCScale9Sprite:create(CCRectMake(30, 30, 15, 15), "images/common/bg/bg_ng_attr.png")
    -- cs9Bg:setContentSize(preferredSize)
    -- cs9Bg:setAnchorPoint(ccp(0.5, 0))
    -- cs9Bg:setPosition(ccp(csBg:getContentSize().width/2, 138))
    -- csBg:addChild(cs9Bg)

    local csvContent = CCScrollView:create()
    csvContent:setViewSize(CCSizeMake(preferredSize.width, preferredSize.height))
    csvContent:setDirection(kCCScrollViewDirectionVertical)
    csvContent:setTouchPriority(-5703)
    csvContent:setBounceable(true)
    local clContentContainer = CCLayer:create()
	csvContent:setContainer(clContentContainer)
	csvContent:setPosition(ccp(108, 186))
	csBg:addChild(csvContent)
    
    local tArrContents = {}
    local tArrData = string.split(_noticeText, "======")
	for i=1, #tArrData do 
		local colorAndText = string.split(tArrData[i], "|")
		table.insert(tArrContents, colorAndText)
	end

	local vCellOffset = 2
	local nAccuHeight=0
	local x_pos = preferredSize.width/2
	local y_pos = 0
	local anchorPoint = ccp(0.5, 1)
	for i=1, #tArrContents do
		local cell, nHeight = createCell(tArrContents[#tArrContents-i+1])
	    cell:setAnchorPoint(anchorPoint)
	    cell:setPosition(ccp(x_pos, y_pos+nHeight))
	    clContentContainer:addChild(cell)
	    y_pos = y_pos + nHeight + vCellOffset
	end
    clContentContainer:setContentSize(CCSizeMake(preferredSize.width, y_pos))
    clContentContainer:setPosition(ccp(0, 650-y_pos))
    csvContent:setContentOffset(ccp(0,csvContent:getViewSize().height-clContentContainer:getContentSize().height))
    require "script/libs/LuaCC"
    local menu = CCMenu:create()
    menu:setPosition(ccp(0, 0))
    menu:setAnchorPoint(ccp(0, 0))
    menu:setTouchPriority(-5703)
    csBg:addChild(menu)


    -- local btnEnterGame= LuaCC.create9ScaleMenuItem("images/common/btn/btn1_d.png","images/common/btn/btn1_n.png", CCSizeMake(198,73), GetLocalizeStringBy("key_2281"), ccc3(255,222,0))
    btnEnterGame = CCMenuItemImage:create("images/game_notice/enter_button_n.png", "images/game_notice/enter_button_h.png")
    btnEnterGame:registerScriptTapHandler(fnHandlerOfEnterGame)
    btnEnterGame:setPosition(ccp(320, 58))
    btnEnterGame:setAnchorPoint(ccp(0.5, 0.5))
    menu:addChild(btnEnterGame)

    
   
end

function setNoticeText(pText)
    _noticeText = pText
end

-- http://124.205.151.82/phone/notice?pl=91phone&gn=sanguo&os=ios&action=get&returntype=sgstr&reserve01=1&reserve02=1&serverKey=4000001
-- 通过服务器标识serverKey拉取第二类通知
function fetchNotice02FromServer(serverKey)
    _serverKey = serverKey
    require "script/Platform"
    local plName = Platform.getPlName()
    local OS = Platform.getOS()
    local url
    if g_debug_mode then
        url = "http://124.205.151.82/phone/notice?pl="..plName.."&gn=sanguo&os="..OS.."&action=get&returntype=sgstr&reserve01=1&reserve02=1&serverKey="..serverKey
    else
        require "script/Platform"
        url = "http://mapifknsg.zuiyouxi.com/phone/notice?pl="..plName.."&gn=sanguo&os="..OS.."&action=get&returntype=sgstr&reserve01=1&reserve02=1&serverKey="..serverKey
    end
    print("notice url = ", url)
    local httpClient = CCHttpRequest:open(url, kHttpGet)
    httpClient:sendWithHandler(function(res, hnd)
        if res:getResponseCode() == 200 then
            setNoticeText(res:getResponseData())
        end
    end)
end
