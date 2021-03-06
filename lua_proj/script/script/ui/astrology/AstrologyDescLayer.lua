-- Filename: AstrologyDescLayer.lua
-- Author: k
-- Date: 2013-08-06
-- Purpose: 占星说明



require "script/utils/extern"
--require "amf3"
-- 主城场景模块声明
module("AstrologyDescLayer", package.seeall)

local IMG_PATH = "images/battle/report/"				-- 图片主路径

local m_astrologyDescLayer

local function cardLayerTouch(eventType, x, y)
    
    return true
    
end

function closeClick()
    
    --点击音效
    require "script/audio/AudioUtil"
    AudioUtil.playEffect("audio/effect/guanbi.mp3")
    local scene = CCDirector:sharedDirector():getRunningScene()
    scene:removeChildByTag(1231,true)
    --print("==========closeClick===============")
end

-- 获得卡牌层
function showAstrologyDescLayer()
    require "script/ui/main/MainScene"
    
    local m_layerSize = CCSizeMake(514,620)
    
    local scale = MainScene.elementScale
    
    m_astrologyDescLayer = CCLayerColor:create(ccc4(11,11,11,166))
    local m_reportInfoLayer = CCLayer:create()
    m_reportInfoLayer:setScale(scale)
    m_reportInfoLayer:setPosition((CCDirector:sharedDirector():getWinSize().width-m_layerSize.width*scale)/2,CCDirector:sharedDirector():getWinSize().height*0.2)
    m_astrologyDescLayer:addChild(m_reportInfoLayer)
    
    
    local m_reportBg = CCScale9Sprite:create(CCRectMake(100, 80, 10, 20),"images/common/viewbg1.png")
    m_reportBg:setContentSize(m_layerSize)
    m_reportBg:setAnchorPoint(ccp(0,0))
    m_reportBg:setPosition(0,0)
    m_reportInfoLayer:addChild(m_reportBg)
    
    local displayName = CCRenderLabel:create(GetLocalizeStringBy("key_3022"), g_sFontPangWa, 35, 3, ccc3( 255, 255, 255), type_stroke)
    displayName:setColor(ccc3( 0x78, 0x25, 0x00));
    --displayName:setAnchorPoint(ccp(0.5,0.5))
    displayName:setPosition(m_layerSize.width*0.42,m_layerSize.height*0.93)
    m_reportBg:addChild(displayName)
    
    local descLabel = CCLabelTTF:create(GetLocalizeStringBy("key_2253"),g_sFontName,24,CCSizeMake(m_layerSize.width*0.9,m_layerSize.height*0.8),kCCTextAlignmentLeft)
    descLabel:setColor(ccc3( 0x78, 0x25, 0x00));
    descLabel:setAnchorPoint(ccp(0.5,0.5))
    descLabel:setPosition(m_layerSize.width*0.5,m_layerSize.height*0.45)
    m_reportBg:addChild(descLabel)
    
    -- 按钮Bar
    local menuBar = CCMenu:create()
    menuBar:setPosition(ccp(0,0))
    menuBar:setTouchPriority(-501)
    m_reportBg:addChild(menuBar)
    
    -- 关闭按钮
    local closeBtn = LuaMenuItem.createItemImage("images/common/btn_close_n.png", "images/common/btn_close_h.png" )
	closeBtn:setAnchorPoint(ccp(1, 1))
    closeBtn:setPosition(ccp(m_layerSize.width*1.02, m_layerSize.height*1.02))
	menuBar:addChild(closeBtn)
	closeBtn:registerScriptTapHandler(closeClick)
    
    --m_astrologyDescLayer:setScale(scale)
    m_astrologyDescLayer:setTouchEnabled(true)
    m_astrologyDescLayer:registerScriptTouchHandler(cardLayerTouch,false,-500,true)
    
    local scene = CCDirector:sharedDirector():getRunningScene()
    scene:addChild(m_astrologyDescLayer,999,1231)
end

-- 退出场景，释放不必要资源
function release (...) 

end
