-- Filename: ChatMainLayer.lua
-- Author: k
-- Date: 2013-08-16
-- Purpose: 聊天主界面



require "script/utils/extern"
require "script/utils/LuaUtil"
--require "amf3"
-- 主城场景模块声明
module("ChatMainLayer", package.seeall)

require "script/network/RequestCenter"
require "script/network/Network"
require "script/libs/LuaCCLabel"
require "script/ui/chat/ChatCache"
require "script/libs/LuaCCSprite"

local IMG_PATH = "images/chat/"				-- 图片主路径

local m_chatMainLayer
local m_chatLayerBg
local worldButton
local pmButton
local unionButton
local gmButton
local _new_pm_count  = 0
local _pm_tip_node = nil

local m_chatInfoList

local isOpen = false

local isBusy = false
local _cur_index

function init()
    _pm_tip_node = nil
end

local function cardLayerTouch(eventType, x, y)
    return true
end

function closeClick()
    
    --点击音效
    require "script/audio/AudioUtil"
    AudioUtil.playEffect("audio/effect/guanbi.mp3")
    close()
end

function showWorldView()
    if(isBusy==true)then
        return
    end
    
    isBusy = true
    --点击音效
    require "script/audio/AudioUtil"
    AudioUtil.playEffect("audio/effect/changtiaoxing.mp3")
    require "script/ui/chat/ChatWorldLayer"
    local view = ChatWorldLayer.getChatWorldLayer()
    if(view~=nil)then
        m_chatLayerBg:removeChildByTag(9121,true)
        m_chatLayerBg:addChild(view,1,9121)
    end
    isBusy = false
end

function showpmView()
    
    if(isBusy==true)then
        return
    end
    
    isBusy = true
    --点击音效
    require "script/audio/AudioUtil"
    AudioUtil.playEffect("audio/effect/changtiaoxing.mp3")
    require "script/ui/chat/ChatPmLayer"
    m_chatLayerBg:removeChildByTag(9121,true)
    local view = ChatPmLayer.getChatPmLayer()
    m_chatLayerBg:addChild(view,1,9121)
    isBusy = false
end

function showUnionView()
    
    if(isBusy==true)then
        return
    end
    print("chat4")
    isBusy = true
    --点击音效
    require "script/audio/AudioUtil"
    AudioUtil.playEffect("audio/effect/changtiaoxing.mp3")
    
    require "script/ui/chat/ChatUnionLayer"
    local view = ChatUnionLayer.getChatUnionLayer()
    if(view~=nil)then
        m_chatLayerBg:removeChildByTag(9121,true)
        m_chatLayerBg:addChild(view,1,9121)
    end
    isBusy = false
end

function showgmView()
    
    if(isBusy==true)then
        return
    end
    
    isBusy = true
    --点击音效
    require "script/audio/AudioUtil"
    AudioUtil.playEffect("audio/effect/changtiaoxing.mp3")
    require "script/ui/chat/ChatGmLayer"
    local view = ChatGmLayer.getChatGmLayer()
    if(view~=nil)then
        m_chatLayerBg:removeChildByTag(9121,true)
        m_chatLayerBg:addChild(view,1,9121)
    end
    isBusy = false
end

function showBroadCastView()
    require "script/ui/chat/ChatBroadCastLayer"
    ChatBroadCastLayer.showChatBroadCastLayer()
end

function closeBroadCastView()
    
end

function closeFriendView()
    
end

function worldClick()
    worldButton:selected()
    pmButton:unselected()
    unionButton:unselected()
    gmButton:unselected()
    showWorldView()
    _cur_index = 1
end

function pmClick()
    worldButton:unselected()
    pmButton:selected()
    unionButton:unselected()
    gmButton:unselected()
    showpmView()
    _cur_index = 2
    _new_pm_count = 0
    MainBaseLayer.showChatTip(_new_pm_count)
    refreshPmTip()
end

function unionClick()
    
    worldButton:unselected()
    pmButton:unselected()
    unionButton:selected()
    gmButton:unselected()
    
    showUnionView()
    _cur_index = 3
end

function gmClick()
    worldButton:unselected()
    pmButton:unselected()
    unionButton:unselected()
    gmButton:selected()
    showgmView()
    _cur_index = 4
end

function showFriendView(uname,ulevel,power,htid,uid,uGender,dressInfo)
    require "script/model/user/UserModel"
    if(tonumber(uid)==tonumber(UserModel.getUserInfo().uid))then
        require "script/ui/main/AvatarInfoLayer"
        if AvatarInfoLayer.getObject() == nil then
            local scene = CCDirector:sharedDirector():getRunningScene()
            local ccLayerAvatarInfo = AvatarInfoLayer.createLayer()
            scene:addChild(ccLayerAvatarInfo,1999,3122)
        end
        return
    end
    
    require "script/ui/chat/ChatUserInfoLayer"
    require "db/DB_Heroes"
    local hero = DB_Heroes.getDataById(htid)
    
    local imageFile = hero.head_icon_id
    ChatUserInfoLayer.showChatUserInfoLayer(uname,ulevel,power,"images/base/hero/head_icon/" .. imageFile,uid,uGender,htid,dressInfo)
end

function addChat(chatInfos)
    local chat_infos_temp = nil
    require "script/utils/LuaUtil"
    if(#chatInfos==0)then
        chat_infos_temp = {}
        table.insert(chat_infos_temp, chatInfos)
    else
        chat_infos_temp = chatInfos
    end
    print_t(chat_infos_temp)
    for i=1,#chat_infos_temp do
        local chatInfo = chat_infos_temp[i]
        if not ChatCache.isShieldedPlayer(chatInfo.sender_uid) then
             if tonumber(chatInfo.channel)==2 or tonumber(chatInfo.channel)==3 or tonumber(chatInfo.channel)==5 or tonumber(chatInfo.channel)==4 or tonumber(chatInfo.channel)==101 then
                 if isOpen==false then   -- 界面没有打开
                    require "script/ui/main/MainBaseLayer"
                    MainBaseLayer.showChatAnimation(true)
                    require "script/ui/guild/GuildBottomSprite"
                    GuildBottomSprite.setGuildChatItemAnimation(true)
                end
                if(tonumber(chatInfo.channel)==2 or tonumber(chatInfo.channel)==3 or tonumber(chatInfo.channel)==5)then
                    require "script/ui/chat/ChatWorldLayer"
                    ChatWorldLayer.addChatInfo(chatInfo)
                elseif(tonumber(chatInfo.channel)==4)then
                    require "script/ui/chat/ChatPmLayer"
                    ChatPmLayer.addChatInfo(chatInfo)
                    if _cur_index ~= 2 or isOpen == false then
                        _new_pm_count = _new_pm_count + 1
                        refreshPmTip()
                        MainBaseLayer.showChatTip(_new_pm_count)
                    end
                elseif(tonumber(chatInfo.channel)==101)then
                    require "script/ui/chat/ChatUnionLayer"
                    ChatUnionLayer.addChatInfo(chatInfo)
                end
            end
        end
    end
end

function getNewPmCount()
    return _new_pm_count
end

function close()
    local scene = CCDirector:sharedDirector():getRunningScene()
    scene:removeChildByTag(3121, true)
    scene:removeChildByTag(3122, true)
    scene:removeChildByTag(1251, true)
    isOpen = false
    require "script/ui/chat/ChangeHeadLayer"
    ChangeHeadLayer.callbackClose()
end

function onNodeEvent(event)
    if event == "enter" then
        isOpen  = true
        refreshPmTip()
    elseif event == "exit" then
        isOpen = false
    end
    
    require "script/ui/main/MainBaseLayer"
    MainBaseLayer.showChatAnimation(false)
    require "script/ui/guild/GuildBottomSprite"
    GuildBottomSprite.setGuildChatItemAnimation(false)
    
end

-- 获得卡牌层
function showChatLayer(viewIndex)
    if isOpen == true then
        return
    end
    create(viewIndex)
    local scene = CCDirector:sharedDirector():getRunningScene()
    scene:addChild(m_chatMainLayer,1200,3121)
    
    isOpen = true
end


function create(index)
    init()
    _cur_index = index
     viewIndex = index==nil and 1 or index
    
    local m_layerSize = CCSizeMake(620,757)
    
    local scale = CCDirector:sharedDirector():getWinSize().width/g_originalDeviceSize.width
    
    m_chatMainLayer = CCLayerColor:create(ccc4(11,11,11,166))
    local m_reportInfoLayer = CCLayer:create()
    m_reportInfoLayer:setScale(scale)
    m_reportInfoLayer:setPosition(ccp((CCDirector:sharedDirector():getWinSize().width-m_layerSize.width*scale)/2,(CCDirector:sharedDirector():getWinSize().height-m_layerSize.height*scale)/2))
    m_chatMainLayer:addChild(m_reportInfoLayer)
    
    
    m_chatLayerBg = CCScale9Sprite:create(CCRectMake(100, 80, 10, 20),"images/common/viewbg1.png")
    m_chatLayerBg:setContentSize(m_layerSize)
    m_chatLayerBg:setAnchorPoint(ccp(0,0))
    m_chatLayerBg:setPosition(ccp(0,0))
    m_reportInfoLayer:addChild(m_chatLayerBg)
    
    -- 标题
   local titleSp = CCSprite:create("images/formation/changeformation/titlebg.png")
	titleSp:setAnchorPoint(ccp(0.5,0.5))
	titleSp:setPosition(ccp(m_chatLayerBg:getContentSize().width * 0.5, m_chatLayerBg:getContentSize().height - 6))
	m_chatLayerBg:addChild(titleSp)
	local titleLabel = CCLabelTTF:create("聊天", g_sFontPangWa, 33)
	titleLabel:setColor(ccc3(0xff, 0xe4, 0x00))
	titleLabel:setAnchorPoint(ccp(0.5, 0.5))
	titleLabel:setPosition(ccp(titleSp:getContentSize().width/2, titleSp:getContentSize().height/2))
	titleSp:addChild(titleLabel)
    
    
    local m_chatViewBg = CCScale9Sprite:create(CCRectMake(30, 30, 15, 15),"images/common/bg/bg_ng_attr.png")
    m_chatViewBg:setContentSize(CCSizeMake(570,480))
    m_chatViewBg:setAnchorPoint(ccp(0,1))
    m_chatViewBg:setPosition(ccp(25,660))
    m_chatLayerBg:addChild(m_chatViewBg)
    
    -- 按钮Bar
    local menuBar = CCMenu:create()
    menuBar:setPosition(ccp(0,0))
    menuBar:setTouchPriority(-405)
    m_chatLayerBg:addChild(menuBar)
    
    -- 关闭按钮
    local closeBtn = LuaMenuItem.createItemImage("images/common/btn_close_n.png", "images/common/btn_close_h.png" )
	closeBtn:setAnchorPoint(ccp(1, 1))
    closeBtn:setPosition(ccp(m_layerSize.width*1.02, m_layerSize.height*1.02))
	menuBar:addChild(closeBtn)
	closeBtn:registerScriptTapHandler(closeClick)
    
    --创建标签
    require "script/libs/LuaCCMenuItem"
    
	local image_n = "images/common/bg/button/ng_tab_n.png"
	local image_h = "images/common/bg/button/ng_tab_h.png"
	local rect_full_n 	= CCRectMake(0,0,63,43)
	local rect_inset_n 	= CCRectMake(25,20,13,3)
	local rect_full_h 	= CCRectMake(0,0,73,53)
	local rect_inset_h 	= CCRectMake(35,25,3,3)
	local btn_size_n	= CCSizeMake(175, 50)
	local btn_size_n2	= CCSizeMake(115, 50)
	local btn_size_h	= CCSizeMake(180, 55)
	local btn_size_h2	= CCSizeMake(120, 55)
	
	local text_color_n	= ccc3(0xf2, 0xe0, 0xcc)
	local text_color_h	= ccc3(0xff, 0xff, 0xff)
	local font			= g_sFontPangWa
	local font_size		= 30
	local strokeCor_n	= ccc3(0xf2, 0xe0, 0xcc)
	local strokeCor_h	= ccc3(0x00, 0x00, 0x00)
	local stroke_size_n	= 0
    local stroke_size_h = 1

     worldButton = LuaCCMenuItem.createMenuItemOfRender2(  image_n, image_h, rect_full_n, rect_inset_n, rect_full_h, rect_inset_h, btn_size_n2, btn_size_h2, GetLocalizeStringBy("key_1664"), text_color_n, text_color_h, font, font_size, strokeCor_n, strokeCor_h, stroke_size_n, stroke_size_h)
	worldButton:setAnchorPoint(ccp(0.5, 1))
    worldButton:setPosition(ccp(m_layerSize.width*0.15, m_layerSize.height*0.935))
	menuBar:addChild(worldButton)
    worldButton:registerScriptTapHandler(worldClick)
    
    pmButton = LuaCCMenuItem.createMenuItemOfRender2(  image_n, image_h, rect_full_n, rect_inset_n, rect_full_h, rect_inset_h, btn_size_n2, btn_size_h2, GetLocalizeStringBy("key_1608"), text_color_n, text_color_h, font, font_size, strokeCor_n, strokeCor_h, stroke_size_n, stroke_size_h )
	pmButton:setAnchorPoint(ccp(0.5, 1))
    pmButton:setPosition(ccp(m_layerSize.width*0.35, m_layerSize.height*0.935))
	menuBar:addChild(pmButton)
    pmButton:registerScriptTapHandler(pmClick)
    
    unionButton = LuaCCMenuItem.createMenuItemOfRender2(  image_n, image_h, rect_full_n, rect_inset_n, rect_full_h, rect_inset_h, btn_size_n2, btn_size_h2, GetLocalizeStringBy("key_3406"), text_color_n, text_color_h, font, font_size, strokeCor_n, strokeCor_h, stroke_size_n, stroke_size_h )
	unionButton:setAnchorPoint(ccp(0.5, 1))
    unionButton:setPosition(ccp(m_layerSize.width*0.55, m_layerSize.height*0.935))
	menuBar:addChild(unionButton)
    unionButton:registerScriptTapHandler(unionClick)
    
     gmButton = LuaCCMenuItem.createMenuItemOfRender2(  image_n, image_h, rect_full_n, rect_inset_n, rect_full_h, rect_inset_h, btn_size_n, btn_size_h, GetLocalizeStringBy("key_1531"), text_color_n, text_color_h, font, font_size, strokeCor_n, strokeCor_h, stroke_size_n, stroke_size_h )
	gmButton:setAnchorPoint(ccp(0.5, 1))
    gmButton:setPosition(ccp(m_layerSize.width*0.8, m_layerSize.height*0.935))
	menuBar:addChild(gmButton)
    gmButton:registerScriptTapHandler(gmClick)
    
    m_chatMainLayer:setTouchEnabled(true)
    m_chatMainLayer:registerScriptTouchHandler(cardLayerTouch,false,-402,true)
    
    --默认显示世界对话
    if(viewIndex==1)then
        worldButton:selected()
        showWorldView()
    elseif(viewIndex==2)then
        pmButton:selected()
        showpmView()
    elseif(viewIndex==3)then
        unionButton:selected()
        showUnionView()
    else
        gmButton:selected()
        showGmView()
    end
    m_chatMainLayer:setTag(3121)
    m_chatMainLayer:registerScriptHandler(onNodeEvent)
    
    return m_chatMainLayer
end

function refreshPmTip()
    if isOpen == false then
        return
    end
    if _pm_tip_node ~= nil then
        _pm_tip_node:removeFromParentAndCleanup(true)
        _pm_tip_node = nil
    end
    if _new_pm_count > 0 then
        _new_pm_count = _new_pm_count > 99 and 99 or _new_pm_count
        _pm_tip_node = LuaCCSprite.createTipSpriteWithNum(_new_pm_count)
        pmButton:addChild(_pm_tip_node)
        _pm_tip_node:setPosition(pmButton:getContentSize().width - 10, pmButton:getContentSize().height - 10)
    end
end

--[[ test 模拟服务器发送聊天消息
function sendWorldChatInfo()
    local chat_info = {
              message_text = "Www",
              sender_uid = "22408",
              sender_uname = "1392866209",
              sender_utype = "0",
              sender_vip = "2",
              sender_level = "85",
              sender_fight = "119090",
              send_time = "1401351305.000000",
              channel = "4",
              sender_tmpl = "20002",
              sender_gender = "0",
              guild_status = "1",
              figure = {
                ["1"] = "80001",
              },
              headpic = "0",
  }
  require "script/ui/chat/ChatPmLayer"
  ChatPmLayer.addChatInfo(chat_info)
end
--]]
-- 退出场景，释放不必要资源
function release (...) 

end
