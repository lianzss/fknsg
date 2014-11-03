-- Filename: ChatPmLayer.lua
-- Author: k
-- Date: 2013-08-16
-- Purpose: 私聊



require "script/utils/extern"
require "script/utils/LuaUtil"
--require "amf3"
-- 主城场景模块声明
module("ChatPmLayer", package.seeall)

require "script/network/RequestCenter"
require "script/network/Network"
require "script/libs/LuaCCLabel"
require "script/ui/chat/ChatInfoCell"
require "script/ui/chat/ChatCache"
require "script/ui/chat/ChatUtil"

local IMG_PATH = "images/chat/"				-- 图片主路径

local m_chatPmLayer     = nil
local m_chatLayerBg
local nameEditBox
local talkEditBox
local targetName
local uid
local utid
local htid
local fight
local ulevel
local dressInfo
local scrollView
local m_layerSize

local m_chatPmInfo = {}

function setTargetName(name)
    targetName = name
end

function addChatInfo(chatInfo)
    ChatUtil.cleanChatInfos(m_chatPmInfo)
    m_chatPmInfo[#m_chatPmInfo+1] = chatInfo
    if m_chatPmLayer ~= nil then
        refreshChatView()
    end
end

local function cardLayerTouch(eventType, x, y)
    return true
    
end

function closeClick()
    m_chatPmLayer:removeFromParentAndCleanup(true)
end

function sendClickCallback(cbFlag, dictData, bRet )
	if(dictData.err == "ok") then
        if(dictData.ret == "userOffline")then
            
            require "script/ui/tip/AlertTip"
            AlertTip.showAlert( GetLocalizeStringBy("key_2664"), nil, false, nil)
            return
        elseif dictData.ret == "beBlack" then
            AlertTip.showAlert("您在对方的黑名单中，无法发送私聊信息", nil, false, nil)
        end
        if(dictData.ret ~=nil and dictData.ret.message ~=nil)then
            local chatInfo = {}
            chatInfo.message_text = talkEditBox:getText()
            chatInfo.sender_uid = tostring(UserModel.getUserUid())
            chatInfo.sender_uname = UserModel.getUserName()
            chatInfo.sender_vip = tostring(UserModel.getVipLevel())
            chatInfo.sender_level = tostring(UserModel.getHeroLevel())
            chatInfo.sender_tmpl = tostring(UserModel.getAvatarHtid())
            chatInfo.channel = tostring(4)
            chatInfo.sender_gender = tostring(UserModel.getUserSex() == 1 and 1 or 0)
            chatInfo.figure = {}
            chatInfo.figure["1"] = UserModel.getDressIdByPos(1)
            chatInfo.headpic = tostring(UserModel.getFigureId())
            chatInfo.isSelfSend = true
            m_chatPmInfo[#m_chatPmInfo+1] = chatInfo
            
            require "script/ui/chat/ChatMainLayer"
            ChatMainLayer.showpmView()
            
            talkEditBox:setText("")
        end
    end
end

function dopmSend(userInfo)
    uid = tonumber(userInfo.uid)
    ChatUtil.sendChatinfo(talkEditBox:getText(), ChatCache.ChatInfoType.normal,  ChatCache.ChannelType.pm, sendClickCallback, uid)
end

function getUidCallBack(cbFlag, dictData, bRet )
    require "script/utils/LuaUtil"
	if(dictData.err == "ok") then
		if(dictData.ret == nil or dictData.ret.err ~= "ok" ) then
            require "script/ui/tip/AlertTip"
            AlertTip.showAlert( GetLocalizeStringBy("key_2686"), nil, false, nil)
        elseif ChatCache.isShieldedPlayer(dictData.ret.uid) then
             AlertTip.showAlert("对方在您的黑名单中，无法发送私聊信息", nil, false, nil)
        else
            setTargetName(nameEditBox:getText())
            dopmSend(dictData.ret)
		end
	end
end

function sendClick()
    -- 音效
    require "script/audio/AudioUtil"
    AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
    require "script/model/user/UserModel"
    require "script/ui/tip/AlertTip"
    local receiver_name = nameEditBox:getText()
    if(receiver_name ==UserModel.getUserName())then
        AlertTip.showAlert( GetLocalizeStringBy("key_1495"), nil, false, nil)
    elseif receiver_name == "" then
        AlertTip.showAlert( GetLocalizeStringBy("key_2050"), nil, false, nil)
    end
     RequestCenter.user_getUserInfoByUname(getUidCallBack,Network.argsHandler(receiver_name))
end

function showBroadCastView()
    
end

function showFriendView(tag,node)
    local index = node:getTag()
    local chatInfo = m_chatPmInfo[index]
    
    ChatMainLayer.showFriendView(chatInfo.sender_uname,chatInfo.sender_level,chatInfo.sender_fight,chatInfo.sender_tmpl,chatInfo.sender_uid,chatInfo.sender_gender,chatInfo.figure)
end

function refreshChatView()
    local index = #m_chatPmInfo
    local chat_info = m_chatPmInfo[index]
    require "script/ui/chat/ChatInfoCell"
    local chat_info_cell = ChatInfoCell.create(ChatInfoCell.ChatInfoCellType.normal, chat_info, index, showFriendView)
    ChatUtil.addChatInfoCell(scrollView, chat_info_cell)
end

-- 获得私聊层
function getChatPmLayer()
    m_layerSize = CCSizeMake(620,700)
    
    m_chatPmLayer = CCLayer:create()
    m_chatPmLayer:registerScriptHandler(onNodeEvent)
    m_chatPmLayer:setAnchorPoint(ccp(0,0))
    m_chatPmLayer:setPosition(ccp(0,0))
    
     scrollView = CCScrollView:create()
    scrollView:setTouchPriority(-410)
	scrollView:setContentSize(CCSizeMake(m_layerSize.width*0.9,m_layerSize.height*0.68))
	scrollView:setViewSize(CCSizeMake(m_layerSize.width*0.9,m_layerSize.height*0.68))
	scrollView:setDirection(kCCScrollViewDirectionVertical)
    scrollView:setAnchorPoint(ccp(0,0))
	scrollView:setPosition(ccp(m_layerSize.width*0.05,m_layerSize.height*0.26))
    m_chatPmLayer:addChild(scrollView)
    
    local chatInfoLayer = CCLayer:create()
    scrollView:setContainer(chatInfoLayer)
    chatInfoLayer:setAnchorPoint(ccp(0,0))
    chatInfoLayer:setPosition(ccp(0,0))
    
    require "script/libs/LuaCCLabel"
    
    local startIndex = #m_chatPmInfo>60 and #m_chatPmInfo-60 or 1
    for i=startIndex,#m_chatPmInfo do
        local chatInfo = m_chatPmInfo[i]
        local chat_info_cell = ChatInfoCell.create(ChatInfoCell.ChatInfoCellType.normal, chatInfo, i, showFriendView)
        ChatUtil.addChatInfoCell(scrollView, chat_info_cell)
    end

    --聊天
	local nameDescLabel = CCLabelTTF:create(GetLocalizeStringBy("key_3267"),g_sFontName,23)
    nameDescLabel:setAnchorPoint(ccp(0,0))
    nameDescLabel:setPosition(ccp(m_layerSize.width*0.05, m_layerSize.height*0.17))
    nameDescLabel:setColor(ccc3(0x00,0x6d,0x2f))
    m_chatPmLayer:addChild(nameDescLabel)
    

    --add by zhang zihang
    --local nameEditBoxLength = 300
    
    --scale changed by zhang zihang
    nameEditBox = CCEditBox:create (CCSizeMake(250,60), CCScale9Sprite:create("images/chat/input_bg.png"))
	nameEditBox:setPosition(ccp(m_layerSize.width*0.1, m_layerSize.height*0.19))
	nameEditBox:setAnchorPoint(ccp(0, 0.5))
	nameEditBox:setPlaceHolder(GetLocalizeStringBy("key_1397"))
    --nameEditBox:setScale(g_originalDeviceSize.width/g_winSize.width)
	nameEditBox:setPlaceholderFontColor(ccc3(0xc3, 0xc3, 0xc3))
	nameEditBox:setMaxLength(13)
	nameEditBox:setReturnType(kKeyboardReturnTypeDone)
	nameEditBox:setInputFlag (kEditBoxInputFlagInitialCapsWord)
    nameEditBox:setTouchPriority(-412)
    if(targetName~=nil)then
        nameEditBox:setText(targetName)
    end
    
    if(nameEditBox:getChildByTag(1001)~=nil)then
        tolua.cast(nameEditBox:getChildByTag(1001),"CCLabelTTF"):setColor(ccc3(0x00,0xe4,0xff))
    end
    
    if(nameEditBox:getChildByTag(1002)~=nil)then
        tolua.cast(nameEditBox:getChildByTag(1002),"CCLabelTTF"):setColor(ccc3(0x00,0xe4,0xff))
    end
    
    nameEditBox:setFont(g_sFontName,23)
    
    m_chatPmLayer:addChild(nameEditBox)

    local nameTalkLabel = CCLabelTTF:create(GetLocalizeStringBy("key_2978"),g_sFontName,23)
    nameTalkLabel:setAnchorPoint(ccp(0,0))
    --position changed by zhang zihang
    nameTalkLabel:setPosition(ccp(m_layerSize.width*0.05+300, m_layerSize.height*0.17))
    nameTalkLabel:setColor(ccc3(0x00,0x6d,0x2f))
    m_chatPmLayer:addChild(nameTalkLabel)
    
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
    
    m_chatPmLayer:addChild(talkEditBox)
    
    local menu = CCMenu:create()
    menu:setAnchorPoint(ccp(0,0))
    menu:setPosition(ccp(0,0))
    menu:setTouchPriority(-411)
    m_chatPmLayer:addChild(menu)
    
    require "script/libs/LuaCC"
    local sendButton = LuaCC.create9ScaleMenuItem("images/star/intimate/btn_blue_n.png","images/star/intimate/btn_blue_h.png",CCSizeMake(120,64),GetLocalizeStringBy("key_1138"),ccc3(255,222,0))
    sendButton:setAnchorPoint(ccp(0.5,0.5))
    sendButton:setPosition(ccp(m_layerSize.width*0.87,m_layerSize.height*0.1))
    sendButton:registerScriptTapHandler(sendClick)
    
    menu:addChild(sendButton)
    
    return m_chatPmLayer
end

function onNodeEvent(event)
    if event == "enter" then
    elseif event == "exit" then
        m_chatPmLayer = nil
    end
end

-- 退出场景，释放不必要资源
function release (...) 

end
