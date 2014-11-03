-- Filename：	RichAnimationTip.lua
-- Author：		bzx
-- Date：		2013-9-24
-- Purpose：		一段文字提示，淡出的提示

module("RichAnimationTip", package.seeall)
require "script/libs/LuaCCLabel"

local function fnEndCallback( tipSprite )
	tipSprite:removeFromParentAndCleanup(true)
	tipSprite = nil
end 

function showTip(richInfo)
	local fullRect = CCRectMake(0,0,58,58)
	local insetRect = CCRectMake(20,20,18,18)

	local hSpace=30
	local vSpace=40
	local nWidth=510
    
    richInfo.width = nWidth-hSpace
    richInfo.alignment = 2                       -- 对齐方式  1 左对齐，2 居中， 3右对齐
    richInfo.labelDefaultFont = g_sFontName      -- 默认字体
    richInfo.labelDefaultSize = 28               -- 默认字体大小
    local descLabel = LuaCCLabel.createRichLabel(richInfo)
	local runningScene = CCDirector:sharedDirector():getRunningScene()

	--提示背景
	local tipSprite = CCScale9Sprite:create("images/tip/animate_tip_bg.png", fullRect, insetRect)
    local nHeight=descLabel:getContentSize().height + vSpace
	tipSprite:setPreferredSize(CCSizeMake(nWidth, nHeight))
    descLabel:setAnchorPoint(ccp(0.5, 0.5))
    descLabel:setPosition(ccpsprite(0.5, 0.5, tipSprite))
	tipSprite:setAnchorPoint(ccp(0.5, 0.5))
	tipSprite:setPosition(ccp(runningScene:getContentSize().width/2 , runningScene:getContentSize().height/2))
	-- btnFrameSp:setScale(bgLayer:getBgScale()/bgLayer:getElementScale())
	runningScene:addChild(tipSprite,2000)
	-- tipSprite:setCascadeOpacityEnabled(true)
	tipSprite:setScale(g_fScaleX)	
	tipSprite:addChild(descLabel)

	-- 文字消失效果
	local desActionArr = CCArray:create()
	desActionArr:addObject(CCDelayTime:create(2.0))
	desActionArr:addObject(CCFadeOut:create(1.0))
	descLabel:runAction(CCSequence:create(desActionArr))
    descLabel:setCascadeOpacityEnabled(true)

	-- 背景消失效果
	local spActionArr = CCArray:create()
	spActionArr:addObject(CCDelayTime:create(2.0))
	spActionArr:addObject(CCFadeOut:create(1.0))
	spActionArr:addObject(CCCallFuncN:create(fnEndCallback))
	tipSprite:runAction(CCSequence:create(spActionArr))
end