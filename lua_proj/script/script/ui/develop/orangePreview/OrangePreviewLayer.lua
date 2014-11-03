-- Filename：	OrangePreviewLayer.lua
-- Author：		Zhang Zihang
-- Date：		2014-9-9
-- Purpose：		橙卡武将预览界面

module ("OrangePreviewLayer", package.seeall)

require "script/ui/main/MainScene"
require "script/utils/BaseUI"
require "script/ui/develop/DevelopData"

local _touchPriority	
local _zOrder
local _bgLayer				--背景层
local _curTag				--当前按钮的tag
local _bgMenu 				--背景按钮层
local _secondSprite 		--二级背景
local _beginX = 100 		--按钮开始位置
local _gapX = 140 			--按钮间隔长度
local kButtomTag = 1000 	--按钮tag开始字段

----------------------------------------初始化函数----------------------------------------
local function init()
	_touchPriority = nil
	_zOrder = nil
	_bgLayer = nil
	_bgMenu = nil
	_secondSprite = nil
	_curTag = 0
end

----------------------------------------触摸事件函数----------------------------------------
local function onTouchesHandler(eventType,x,y)
	if (eventType == "began") then
	    return true
    elseif (eventType == "moved") then
    	print("moved")
    else
        print("end")
	end
end

local function onNodeEvent(event)
	if event == "enter" then
		_bgLayer:registerScriptTouchHandler(onTouchesHandler, false, _touchPriority, true)
		_bgLayer:setTouchEnabled(true)
	elseif eventType == "exit" then
		_bgLayer:unregisterScriptTouchHandler()
	end
end

----------------------------------------回调函数----------------------------------------
--[[
	@des 	:更换国家回调
	@param 	:按钮tag值
	@return :
--]]
function changeCountryCB(p_tag,p_item)
	local indexNum = p_tag - kButtomTag
	_pointSprite:setPositionX(_beginX + _gapX*(indexNum - 1))
	p_item:selected()

	if p_tag ~= _curTag then
		local previousMenuItem = tolua.cast(_bgMenu:getChildByTag(_curTag),"CCMenuItemImage")
		previousMenuItem:unselected()

		_secondSprite:removeChildByTag(_curTag,true)

		--传入相应国家的橙将信息，进行创建TableView
		local tagTableView = OrangeTableView.createTableView(DevelopData.getOrangeHeroByCountry(p_tag - kButtomTag))
		tagTableView:setAnchorPoint(ccp(0,0))
		tagTableView:setPosition(ccp(0,0))
        tagTableView:setTouchPriority(_touchPriority - 20)
		_secondSprite:addChild(tagTableView,1,p_tag)

		_curTag = p_tag
	end
end

--[[
	@des 	:关闭按钮回调
	@param 	:
	@return :
--]]
function closeCallBack()
	AudioUtil.playEffect("audio/effect/guanbi.mp3")
	_bgLayer:removeFromParentAndCleanup(true)
	_bgLayer = nil
end

----------------------------------------UI函数----------------------------------------
--[[
	@des 	:创建UI
	@param 	:
	@return :
--]]
function createUI()
	--主背景图片
	local bgSprite = CCScale9Sprite:create("images/common/viewbg1.png")
	bgSprite:setContentSize(CCSizeMake(620,700))
	bgSprite:setAnchorPoint(ccp(0.5,0.5))
	bgSprite:setPosition(ccp(g_winSize.width/2,g_winSize.height/2))
	bgSprite:setScale(MainScene.elementScale)
	_bgLayer:addChild(bgSprite)

	--标题背景
	local titleSprite = CCSprite:create("images/common/viewtitle1.png")
	titleSprite:setAnchorPoint(ccp(0.5,0.5))
	titleSprite:setPosition(ccp(bgSprite:getContentSize().width/2,bgSprite:getContentSize().height - 6))
	bgSprite:addChild(titleSprite)

	--标题
	local titleLabel = CCLabelTTF:create(GetLocalizeStringBy("zzh_1137"), g_sFontPangWa, 33)
	titleLabel:setColor(ccc3(0xff,0xe4,0x00))
	titleLabel:setAnchorPoint(ccp(0.5,0.5))
	titleLabel:setPosition(ccp(titleSprite:getContentSize().width/2,titleSprite:getContentSize().height/2))
	titleSprite:addChild(titleLabel)

	--背景层
	_bgMenu = CCMenu:create()
	_bgMenu:setAnchorPoint(ccp(0,0))
	_bgMenu:setPosition(ccp(0,0))
	_bgMenu:setTouchPriority(_touchPriority - 1)
	bgSprite:addChild(_bgMenu)

	--关闭按钮
	local closeMenuItem = CCMenuItemImage:create("images/common/btn_close_n.png", "images/common/btn_close_h.png")
    closeMenuItem:setPosition(ccp(bgSprite:getContentSize().width*1.03,bgSprite:getContentSize().height*1.03))
    closeMenuItem:setAnchorPoint(ccp(1,1))
    closeMenuItem:registerScriptTapHandler(closeCallBack)
    _bgMenu:addChild(closeMenuItem)

    --4个国家按钮
    local nameTable = {
    						[1] = "wei",
    						[2] = "shu",
    						[3] = "wu",
    						[4] = "qun",
					  }
    for i = 1,4 do
    	local nameString = "images/illustrate/hero/" .. nameTable[i] .. "/" .. nameTable[i]
    	local countryMenuItem = CCMenuItemImage:create(nameString .. "_n.png", nameString .. "_h.png")
    	countryMenuItem:setAnchorPoint(ccp(0.5,1))
    	countryMenuItem:setPosition(ccp(_beginX + _gapX*(i - 1),bgSprite:getContentSize().height - 50))
    	countryMenuItem:registerScriptTapHandler(changeCountryCB)
    	if i == 1 then
    		countryMenuItem:selected()
    	else
    		countryMenuItem:unselected()
    	end
    	_bgMenu:addChild(countryMenuItem,1,kButtomTag + i)
    end

    _curTag = kButtomTag + 1

    --箭头的高度变量
    local arrowPosY = bgSprite:getContentSize().height - 115

    --指示箭头
    _pointSprite = CCSprite:create("images/illustrate/bottom_trangle.png")
    _pointSprite:setAnchorPoint(ccp(0.5,1))
    _pointSprite:setPosition(ccp(_beginX,arrowPosY))
    bgSprite:addChild(_pointSprite)

    --二级背景
    _secondSprite = CCScale9Sprite:create("images/common/bg/bg_ng_attr.png")
    _secondSprite:setContentSize(CCSizeMake(580,475))
    _secondSprite:setAnchorPoint(ccp(0.5,1))
    _secondSprite:setPosition(ccp(bgSprite:getContentSize().width/2,arrowPosY - _pointSprite:getContentSize().height))
    bgSprite:addChild(_secondSprite)

    --提示文字
    local desLabel_1 = CCLabelTTF:create(GetLocalizeStringBy("zzh_1138"),g_sFontPangWa,21)
    desLabel_1:setColor(ccc3(0x78,0x25,0x00))
    local desLabel_2 = CCLabelTTF:create(GetLocalizeStringBy("zzh_1139"),g_sFontPangWa,21)
    desLabel_2:setColor(ccc3(0x00,0x6d,0x2f))
    --伟大的拼接过程
    local tipNode = BaseUI.createHorizontalNode({desLabel_1,desLabel_2})
    tipNode:setAnchorPoint(ccp(0.5,0.5))
    tipNode:setPosition(ccp(bgSprite:getContentSize().width/2,60))
    bgSprite:addChild(tipNode)

    require "script/ui/develop/orangePreview/OrangeTableView"
    --创建魏国tableView
    local weiTableView = OrangeTableView.createTableView(DevelopData.getOrangeHeroByCountry(1))
    weiTableView:setAnchorPoint(ccp(0,0))
	weiTableView:setPosition(ccp(0,0))
	weiTableView:setTouchPriority(_touchPriority - 20)
	_secondSprite:addChild(weiTableView,1,kButtomTag + 1)
end

----------------------------------------入口函数----------------------------------------
function showLayer(p_touchPriority,p_zOrder)
	init()

	_touchPriority = p_touchPriority or -550
	_zOrder = p_zOrder or 999

	_bgLayer = CCLayerColor:create(ccc4(0,0,0,155))
	_bgLayer:registerScriptHandler(onNodeEvent)
    local scene = CCDirector:sharedDirector():getRunningScene()
    scene:addChild(_bgLayer,_zOrder)

    --创建UI层
    createUI()
end