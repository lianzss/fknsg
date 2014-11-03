-- Filename: ChatUnionLayer.lua
-- Author: k
-- Date: 2013-08-16
-- Purpose: 世界聊天


require "script/utils/extern"
require "script/utils/LuaUtil"
--require "amf3"
-- 主城场景模块声明
module("ChatUnionLayer", package.seeall)

require "script/network/RequestCenter"
require "script/network/Network"
require "script/libs/LuaCCLabel"
require "script/ui/chat/ChatInfoCell"
require "script/ui/chat/ChatUtil"
require "script/ui/tip/AlertTip"

local IMG_PATH = "images/chat/"				-- 图片主路径

local m_ChatUnionLayer  = nil
local m_chatLayerBg
local worldButton
local pmButton
local gmButton
local talkEditBox
local hornNumberLabel
local chatInterface
local chatItemId
local scrollView
local m_layerSize

local m_chatUnionInfo = {}

function addChatInfo(chatInfo)
    ChatUtil.cleanChatInfos(m_chatUnionInfo)
    m_chatUnionInfo[#m_chatUnionInfo+1] = chatInfo
    if m_ChatUnionLayer ~= nil then
        refreshChatView()
    end
end

local function cardLayerTouch(eventType, x, y)
    
    return true
    
end

function closeClick()
    m_ChatUnionLayer:removeFromParentAndCleanup(true)
end


function sendClickCallback(cbFlag, dictData, bRet )
	if(dictData.err ~= "ok") then
        return
    end
    if(dictData.ret == "true") then
        talkEditBox:setText("")
    elseif(dictData.ret == "noguild")then
        AlertTip.showAlert( GetLocalizeStringBy("key_1043"), nil, false, nil)
    elseif(dictData.err == "noguild" or dictData.err == "guild id is null!") then
        AlertTip.showAlert( GetLocalizeStringBy("key_1043"), nil, false, nil)
	end
end


function sendClick()
    require "script/audio/AudioUtil"
    AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
    ChatUtil.sendChatinfo(talkEditBox:getText(), ChatCache.ChatInfoType.normal, ChatCache.ChannelType.union, sendClickCallback)
end

function showBroadCastView()
    AlertTip.showAlert( GetLocalizeStringBy("key_3021"), nil, false, nil)
end

function showFriendView(tag,node)
    local index = node:getTag()
    local chatInfo = m_chatUnionInfo[index]
    ChatMainLayer.showFriendView(chatInfo.sender_uname,chatInfo.sender_level,chatInfo.sender_fight,chatInfo.sender_tmpl,chatInfo.sender_uid,chatInfo.sender_gender,chatInfo.figure)
end

function refreshChatView()
    local index = #m_chatUnionInfo
    local chat_info = m_chatUnionInfo[index]
    local chat_info_cell = ChatInfoCell.create(ChatInfoCell.ChatInfoCellType.normal, chat_info, index, showFriendView)
    ChatUtil.addChatInfoCell(scrollView, chat_info_cell)
end

-- 获得军团层
function getChatUnionLayer()
    m_layerSize = CCSizeMake(620,700)
    
    m_ChatUnionLayer = CCLayer:create()
    m_ChatUnionLayer:registerScriptHandler(onNodeEvent)
    m_ChatUnionLayer:setAnchorPoint(ccp(0,0))
    m_ChatUnionLayer:setPosition(ccp(0,0))
    
    scrollView = CCScrollView:create()
    scrollView:setTouchPriority(-410)
	scrollView:setContentSize(CCSizeMake(m_layerSize.width*0.9,m_layerSize.height*0.68))
	scrollView:setViewSize(CCSizeMake(m_layerSize.width*0.9,m_layerSize.height*0.68))
	scrollView:setDirection(kCCScrollViewDirectionVertical)
    scrollView:setAnchorPoint(ccp(0,0))
	scrollView:setPosition(ccp(m_layerSize.width*0.05,m_layerSize.height*0.26))
    m_ChatUnionLayer:addChild(scrollView)
    
    local chatInfoLayer = CCLayer:create()
    scrollView:setContainer(chatInfoLayer)
    chatInfoLayer:setAnchorPoint(ccp(0,0))
    chatInfoLayer:setPosition(ccp(0,0))
    local startIndex = #m_chatUnionInfo>60 and #m_chatUnionInfo-60 or 1
    for i=startIndex,#m_chatUnionInfo do
        local chatInfo = m_chatUnionInfo[i]
        local chat_info_cell = ChatInfoCell.create(ChatInfoCell.ChatInfoCellType.normal, chatInfo, i, showFriendView)
        ChatUtil.addChatInfoCell(scrollView, chat_info_cell)
    end
    
    
    local menu = CCMenu:create()
    menu:setAnchorPoint(ccp(0,0))
    menu:setPosition(ccp(0,0))
    menu:setTouchPriority(-411)
    m_ChatUnionLayer:addChild(menu)
    
    --scale changed by zhang zihang

    talkEditBox = CCEditBox:create (CCSizeMake(450,60), CCScale9Sprite:create("images/chat/input_bg.png"))
	talkEditBox:setPosition(ccp(m_layerSize.width*0.05, m_layerSize.height*0.1))
	talkEditBox:setAnchorPoint(ccp(0, 0.5))
	talkEditBox:setPlaceHolder(GetLocalizeStringBy("key_2499"))
	talkEditBox:setPlaceholderFontColor(ccc3(0xc3, 0xc3, 0xc3))
	talkEditBox:setMaxLength(40)
	talkEditBox:setReturnType(kKeyboardReturnTypeDone)
	talkEditBox:setInputFlag (kEditBoxInputFlagInitialCapsWord)
    talkEditBox:setTouchPriority(-412)
    
    if(talkEditBox:getChildByTag(1001)~=nil)then
        tolua.cast(talkEditBox:getChildByTag(1001),"CCLabelTTF"):setColor(ccc3(0xff,0xfb,0xd9))
    end
    if(talkEditBox:getChildByTag(1002)~=nil)then
        tolua.cast(talkEditBox:getChildByTag(1002),"CCLabelTTF"):setColor(ccc3(0xc3,0xc3,0xc3))
    end
    talkEditBox:setFont(g_sFontName,23)
    
    m_ChatUnionLayer:addChild(talkEditBox)
    
    require "script/libs/LuaCC"
    local sendButton = LuaCC.create9ScaleMenuItem("images/star/intimate/btn_blue_n.png","images/star/intimate/btn_blue_h.png",CCSizeMake(120,64),GetLocalizeStringBy("key_1138"),ccc3(255,222,0))
    sendButton:setAnchorPoint(ccp(0.5,0.5))
    sendButton:setPosition(ccp(m_layerSize.width*0.87,m_layerSize.height*0.1))
    sendButton:registerScriptTapHandler(sendClick)
    menu:addChild(sendButton)
    
    return m_ChatUnionLayer
end

function onNodeEvent(event)
    if event == "enter" then
    elseif event == "exit" then
        m_ChatUnionLayer = nil
    end
end

-- 退出场景，释放不必要资源
function release (...) 

end
