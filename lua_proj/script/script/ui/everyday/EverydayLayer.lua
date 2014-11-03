-- FileName: EverydayLayer.lua 
-- Author: Li Cong 
-- Date: 14-3-18 
-- Purpose: function description of module 


module("EverydayLayer", package.seeall)

require "script/utils/BaseUI"
require "script/libs/LuaCC"
require "script/ui/everyday/EverydayData"
require "script/ui/everyday/EverydayService"

local _bgLayer                  = nil
local backGround 				= nil
local _addProgressBar 			= nil
local second_bg  				= nil
local menuBar 					= nil
local proress_bg1 				= nil
function init( ... )
	_bgLayer                    = nil
	backGround 					= nil
	_addProgressBar 			= nil
	second_bg  					= nil
	menuBar 					= nil
	proress_bg1 				= nil
end

-- touch事件处理
local function cardLayerTouch(eventType, x, y)
   
    return true
    
end

-- 关闭按钮回调
function closeButtonCallback( tag, sender )
    -- 音效
    require "script/audio/AudioUtil"
    AudioUtil.playEffect("audio/effect/guanbi.mp3")
	-- print("closeButtonCallback")
	if(_bgLayer)then
		_bgLayer:removeFromParentAndCleanup(true)
		_bgLayer = nil
	end

	require "script/ui/main/MainBaseLayer"
	local isShowTip = EverydayData.getIsShowTipSprite()
	local menuItem = MainBaseLayer.getEverydayBtn()
	print("menuItem==",menuItem)
	MainBaseLayer.showTipSprite(menuItem,isShowTip)
end

-- 创建layer
function initEverydayLayer( ... )
	init()

	_bgLayer = CCLayerColor:create(ccc4(11,11,11,200))
    _bgLayer:setTouchEnabled(true)
    _bgLayer:registerScriptTouchHandler(cardLayerTouch,false,-420,true)
    local scene = CCDirector:sharedDirector():getRunningScene()
    scene:addChild(_bgLayer,1000,1)

	-- 创建背景
	backGround = CCScale9Sprite:create(CCRectMake(100, 80, 10, 20),"images/common/viewbg1.png")
    backGround:setContentSize(CCSizeMake(630, 770))
    backGround:setAnchorPoint(ccp(0.5,0.5))
    backGround:setPosition(ccp(g_winSize.width*0.5,g_winSize.height*0.5 - 24))
    _bgLayer:addChild(backGround)
    -- 适配
    setAdaptNode(backGround)
    -- 标题
    local titlePanel = CCSprite:create("images/common/viewtitle1.png")
	titlePanel:setAnchorPoint(ccp(0.5, 0.5))
	titlePanel:setPosition(ccp(backGround:getContentSize().width/2, backGround:getContentSize().height-6.6 ))
	backGround:addChild(titlePanel)
	local titleLabel = CCLabelTTF:create(GetLocalizeStringBy("key_2426"), g_sFontPangWa, 33)
	titleLabel:setColor(ccc3(0xff, 0xe4, 0x00))
	titleLabel:setAnchorPoint(ccp(0.5,0.5))
	titleLabel:setPosition(ccp(titlePanel:getContentSize().width*0.5, titlePanel:getContentSize().height*0.5))
	titlePanel:addChild(titleLabel)

	-- 关闭按钮
	local menu = CCMenu:create()
    menu:setTouchPriority(-420)
	menu:setPosition(ccp(0, 0))
	menu:setAnchorPoint(ccp(0, 0))
	backGround:addChild(menu,3)
	local closeButton = CCMenuItemImage:create("images/common/btn_close_n.png", "images/common/btn_close_h.png")
	closeButton:setAnchorPoint(ccp(0.5, 0.5))
	closeButton:setPosition(ccp(backGround:getContentSize().width * 0.955, backGround:getContentSize().height*0.975 ))
	closeButton:registerScriptTapHandler(closeButtonCallback)
	menu:addChild(closeButton)

	-- 花纹 右边
 	local hua1 = CCSprite:create("images/hunt/hua.png")
 	hua1:setAnchorPoint(ccp(1,1))
 	hua1:setPosition(ccp(backGround:getContentSize().width-33,backGround:getContentSize().height-55))
 	backGround:addChild(hua1)
 	-- 左边
 	local hua2 = CCSprite:create("images/hunt/hua.png")
 	hua2:setAnchorPoint(ccp(1,1))
 	hua2:setPosition(ccp(33,backGround:getContentSize().height-55))
 	backGround:addChild(hua2)
 	hua2:setRotation(270)
 	
	-- 当前积分
	local curScoreFont = CCSprite:create("images/everyday/cur_score_font.png")
	curScoreFont:setAnchorPoint(ccp(0,0))
	curScoreFont:setPosition(ccp(198,680))
	backGround:addChild(curScoreFont)
	local curScoreNum = EverydayData.getCurScore()
	local totalNum = EverydayData.getMaxScore()
	local curScoreNumFont = CCLabelTTF:create(curScoreNum .. "/",g_sFontPangWa,25)
	curScoreNumFont:setColor(ccc3(0x0e,0x79,0x00))
	curScoreNumFont:setAnchorPoint(ccp(0,0))
	curScoreNumFont:setPosition(ccp(curScoreFont:getPositionX()+curScoreFont:getContentSize().width+5,678))
	backGround:addChild(curScoreNumFont)
	local totalNumFont = CCLabelTTF:create(totalNum,g_sFontPangWa,25)
	totalNumFont:setColor(ccc3(0xa1,0x35,0x00))
	totalNumFont:setAnchorPoint(ccp(0,0))
	totalNumFont:setPosition(ccp(curScoreNumFont:getPositionX()+curScoreNumFont:getContentSize().width+2,678))
	backGround:addChild(totalNumFont)

	-- 进度条
	local rate = curScoreNum/totalNum
	if(rate > 1)then
		rate = 1
	end
	local proress_bg = CCSprite:create("images/everyday/progress3.png")
	proress_bg:setAnchorPoint(ccp(0.5,0))
	proress_bg:setPosition(ccp(backGround:getContentSize().width*0.5,560))
	backGround:addChild(proress_bg)

	_addProgressBar = CCSprite:create("images/everyday/progress2.png")
    local _nEnergyProgressOriWidth = _addProgressBar:getContentSize().width
    local width = math.floor(rate*_nEnergyProgressOriWidth)
    if(width>_nEnergyProgressOriWidth ) then
        width = _nEnergyProgressOriWidth
    end
    _addProgressBar:setTextureRect(CCRectMake(0, 0, width, _addProgressBar:getContentSize().height))
    _addProgressBar:setAnchorPoint(ccp(0,0))
    _addProgressBar:setPosition(45, 12)
    proress_bg:addChild(_addProgressBar)

    if(width < _nEnergyProgressOriWidth ) then
	    local xing = CCSprite:create("images/everyday/xing.png")
	    xing:setAnchorPoint(ccp(0.5,0.5))
	    xing:setPosition(ccp(width,_addProgressBar:getContentSize().height*0.5))
	    _addProgressBar:addChild(xing)
	end

	proress_bg1 = CCSprite:create("images/everyday/progress1.png")
	proress_bg1:setAnchorPoint(ccp(0.5,0))
	proress_bg1:setPosition(ccp(proress_bg:getContentSize().width*0.5,4))
	proress_bg:addChild(proress_bg1,3)

	-- 二级背景
	second_bg = BaseUI.createContentBg(CCSizeMake(584,435))
 	second_bg:setAnchorPoint(ccp(0.5,0))
 	second_bg:setPosition(ccp(backGround:getContentSize().width*0.5,114))
 	backGround:addChild(second_bg)

 	-- 两行字
 	local str1 = GetLocalizeStringBy("key_3235")
 	local str2 = GetLocalizeStringBy("key_1358")
 	local str1_font = CCLabelTTF:create(str1,g_sFontPangWa,21)
 	str1_font:setColor(ccc3(0x0e,0x79,0x00))
 	str1_font:setAnchorPoint(ccp(0.5,0))
 	str1_font:setPosition(ccp(backGround:getContentSize().width*0.5,75))
 	backGround:addChild(str1_font)
 	local str2_font = CCLabelTTF:create(str2,g_sFontPangWa,25)
 	str2_font:setColor(ccc3(0xa1,0x35,0x00))
 	str2_font:setAnchorPoint(ccp(0.5,0))
 	str2_font:setPosition(ccp(backGround:getContentSize().width*0.5,35))
 	backGround:addChild(str2_font)

 	-- 金银铜箱子
 	menuBar = CCMenu:create()
 	menuBar:setAnchorPoint(ccp(0,0))
 	menuBar:setPosition(ccp(0,0))
 	menuBar:setTouchPriority(-420)
 	proress_bg1:addChild(menuBar)
 	local posX = {0.2,0.5,0.8}
 	-- 铜 状态 需要分数
 	local tongStatus,tongNeedScore = EverydayData.getBoxStateInfoById(1)
 	local tongBoxBtn = createBoxBtn("tong",tongStatus,tongNeedScore)
 	tongBoxBtn:setAnchorPoint(ccp(0.5,0))
 	tongBoxBtn:setPosition(ccp(proress_bg1:getContentSize().width*posX[1],15))
 	menuBar:addChild(tongBoxBtn,1,1)
 	tongBoxBtn:registerScriptTapHandler(boxBtnCallFun)

 	-- 银 状态 需要分数
 	local yinStatus,yinNeedScore = EverydayData.getBoxStateInfoById(2)
 	local yinBoxBtn = createBoxBtn("yin",yinStatus,yinNeedScore)
 	yinBoxBtn:setAnchorPoint(ccp(0.5,0))
 	yinBoxBtn:setPosition(ccp(proress_bg1:getContentSize().width*posX[2],15))
 	menuBar:addChild(yinBoxBtn,1,2)
 	yinBoxBtn:registerScriptTapHandler(boxBtnCallFun)

 	-- 金 状态 需要分数
 	local jinStatus,jinNeedScore = EverydayData.getBoxStateInfoById(3)
 	local jinBoxBtn = createBoxBtn("jin",jinStatus,jinNeedScore)
 	jinBoxBtn:setAnchorPoint(ccp(0.5,0))
 	jinBoxBtn:setPosition(ccp(proress_bg1:getContentSize().width*posX[3],15))
 	menuBar:addChild(jinBoxBtn,1,3)
 	jinBoxBtn:registerScriptTapHandler(boxBtnCallFun)

 	-- 创建任务列表
 	createTasksTableView()

end

-- status 1 2 3 
function createBoxBtn( type_str, status, score )
	local menuItem = CCMenuItemImage:create("images/everyday/" .. type_str .. "_" .. status .. "_n.png", "images/everyday/" .. type_str .. "_" .. status .. "_h.png")

	if( tonumber(status) == 2)then
		if("tong" == type_str)then
			-- 铜宝箱
			local spellEffectSprite = CCLayerSprite:layerSpriteWithName(CCString:create("images/base/effect/copy/copperBox/tongxiangzi"), -1,CCString:create(""));
		    spellEffectSprite:retain()
		    spellEffectSprite:setPosition(menuItem:getContentSize().width*0.5,menuItem:getContentSize().height*0.5+5)
		    menuItem:addChild(spellEffectSprite)
		    spellEffectSprite:release()
		elseif("yin" == type_str)then
			-- 银宝箱
			local spellEffectSprite = CCLayerSprite:layerSpriteWithName(CCString:create("images/base/effect/copy/silverBox/yinxiangzi"), -1,CCString:create(""));
		    spellEffectSprite:retain()
		    spellEffectSprite:setPosition(menuItem:getContentSize().width*0.5,menuItem:getContentSize().height*0.5+5)
		    menuItem:addChild(spellEffectSprite)
		    spellEffectSprite:release()
		elseif("jin" == type_str)then
			-- 金宝箱
			local spellEffectSprite = CCLayerSprite:layerSpriteWithName(CCString:create("images/base/effect/copy/goldBox/jinxiangzi"), -1,CCString:create(""));
		    spellEffectSprite:retain()
		    spellEffectSprite:setPosition(menuItem:getContentSize().width*0.5+3,menuItem:getContentSize().height*0.5+5)
		    menuItem:addChild(spellEffectSprite)
		    spellEffectSprite:release()
		end
	end


	-- 积分数
	local sprite1 = LuaCC.createNumberSprite02("images/everyday",score)
    menuItem:addChild(sprite1)

	-- 积分sp
	local sprite2 = CCSprite:create("images/everyday/score_font.png")
	sprite2:setAnchorPoint(ccp(0,0))
	menuItem:addChild(sprite2)
	local posX = (menuItem:getContentSize().width-sprite1:getContentSize().width+sprite2:getContentSize().width)*0.5
	sprite1:setPosition(ccp(2,-14))
	sprite2:setPosition(ccp(sprite1:getPositionX()+sprite1:getContentSize().width,0))
	return menuItem
end

-- 创建任务列表
function createTasksTableView( ... )
	local tasksTab = EverydayData.getTaskInfo()
	require "script/ui/everyday/EverydayCell"
	local cellSize = CCSizeMake(574, 164)
	local h = LuaEventHandler:create(function(fn, table, a1, a2) 	--创建
		local r
		if fn == "cellSize" then
			r = cellSize
		elseif fn == "cellAtIndex" then
			r = EverydayCell.createCell(tasksTab[a1+1])
		elseif fn == "numberOfCells" then
			r =  #tasksTab
		else
		end
		return r
	end)

	local tableView = LuaTableView:createWithHandler(h, CCSizeMake(574, 430))
	tableView:setBounceable(true)
	tableView:setTouchPriority(-423)
	tableView:ignoreAnchorPointForPosition(false)
	tableView:setAnchorPoint(ccp(0.5,0.5))
	tableView:setPosition(ccp(second_bg:getContentSize().width*0.5,second_bg:getContentSize().height*0.5))
	second_bg:addChild(tableView)
end

-- 箱子回调
function boxBtnCallFun( tag, itemBtn )
	require "script/ui/everyday/ShowBoxLayer"
	ShowBoxLayer.showBoxRewardLayer(tag,refreshBoxBtn)
end

-- 刷新箱子回调
function refreshBoxBtn( boxId )
	local menuItem = tolua.cast(menuBar:getChildByTag(tonumber(boxId)),"CCMenuItemImage")
	if(menuItem)then
		menuItem:removeFromParentAndCleanup(true)
	end
	require "db/DB_Daytask_reward"
	local data = DB_Daytask_reward.getDataById(boxId)
	local nameArr = {"tong","yin","jin"}
	local posX = {0.2,0.5,0.8}
	local boxBtn = createBoxBtn(nameArr[tonumber(boxId)],3,data.needScore)
 	boxBtn:setAnchorPoint(ccp(0.5,0))
 	boxBtn:setPosition(ccp(proress_bg1:getContentSize().width*posX[tonumber(boxId)],28))
 	menuBar:addChild(boxBtn,1,tonumber(boxId))
 	boxBtn:registerScriptTapHandler(boxBtnCallFun)
end

-- 显示layer
function showEverydayLayer( ... )
	EverydayService.getActiveInfo(initEverydayLayer)
end










































