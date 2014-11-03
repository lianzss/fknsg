-- Filename: RecycleMain.lua
-- Author: zhang zihang
-- Date: 2013-11-28
-- Purpose: 该文件用于: 武将分解重生主界面

module ("RecycleMain", package.seeall)

require "script/ui/main/MainScene"
require "script/model/user/UserModel"
require "script/ui/shop/RechargeLayer"
require "script/audio/AudioUtil"

--初始化
function init()
	_whereILocate = "breakdown"

	_tParam = nil

	_tArr = nil

	_bgLayer = nil
	_breakDownLayer = nil
	_resurrectLayer = nil
	
	_layerSize = nil

	_menuBreakDown = nil
	_menuResurrect = nil

	_ksTagBreakDown = 1001
	_ksTagResurrect = 1002
	_ksTagExplanation = 1003
	_ksTagMysteryStore = 1004

	silverLabel = nil
	goldLabel = nil

	menuMysteryStore = nil
	menuExplanation = nil
end

function onNodeEvent(event)
	if (event == "enter") then
	elseif (event == "exit") then
		RechargeLayer.registerChargeGoldCb(nil)
	end
end

--创建用户战斗力，财产信息栏
function createTopUI()
	--用户信息栏
	local topBg = CCSprite:create("images/hero/avatar_attr_bg.png")
    topBg:setAnchorPoint(ccp(0,1))
    topBg:setPosition(0,_layerSize.height-32*MainScene.elementScale)
    topBg:setScale(g_fScaleX)
    _bgLayer:addChild(topBg)

    --添加战斗力文字图片
    local powerDescLabel = CCSprite:create("images/common/fight_value.png")
    powerDescLabel:setAnchorPoint(ccp(0.5,0.5))
    powerDescLabel:setPosition(topBg:getContentSize().width*0.13,topBg:getContentSize().height*0.43)
    topBg:addChild(powerDescLabel)

    --读取用户信息
    local userInfo = UserModel.getUserInfo()
    if userInfo == nil then
        return
    end
    
    --战斗力
    local powerLabel = CCRenderLabel:create("" .. UserModel.getFightForceValue(), g_sFontName, 23, 1.5, ccc3( 0x00, 0x00, 0x00), type_stroke)
    powerLabel:setColor(ccc3(0xff, 0xf6, 0x00))
    --m_powerLabel:setAnchorPoint(ccp(0,0.5))
    powerLabel:setPosition(topBg:getContentSize().width*0.23,topBg:getContentSize().height*0.66)
    topBg:addChild(powerLabel)
    
    --银币    
    silverLabel = CCLabelTTF:create(tostring(userInfo.silver_num),g_sFontName,18)
    silverLabel:setColor(ccc3(0xe5,0xf9,0xff))
    silverLabel:setAnchorPoint(ccp(0,0.5))
    silverLabel:setPosition(topBg:getContentSize().width*0.61,topBg:getContentSize().height*0.43)
    topBg:addChild(silverLabel)
    
    --金币
    goldLabel = CCLabelTTF:create(tostring(userInfo.gold_num),g_sFontName,18)
    goldLabel:setColor(ccc3(0xff,0xe2,0x44))
    goldLabel:setAnchorPoint(ccp(0,0.5))
    goldLabel:setPosition(topBg:getContentSize().width*0.82,topBg:getContentSize().height*0.43)
    topBg:addChild(goldLabel)

    RechargeLayer.registerChargeGoldCb(chargeCb)
end

function chargeCb()
	updateSilver()
	updateGold()
end

--创建分解界面
function createBreakDownLayer()
	require "script/ui/recycle/BreakDownLayer"
	if _whereILocate == "resurrect" then
		_tParam = nil
	end
	_breakDownLayer = BreakDownLayer.createLayer(_tParam)
	_whereILocate = "breakdown"
	_bgLayer:addChild(_breakDownLayer)
end

--创建复活界面
function createResurrectLayer()
	require "script/ui/recycle/ResurrectLayer"
	if _whereILocate == "breakdown" then
		_tParam = nil
	end
	_resurrectLayer = ResurrectLayer.createLayer(_tParam)
	_whereILocate = "resurrect"
	_bgLayer:addChild(_resurrectLayer)
end

--按钮回调
function fnHandlerOfButtons(tag, obj)
	if tag == _ksTagBreakDown then
		AudioUtil.playEffect("audio/effect/changtiaoxing.mp3")
		_menuBreakDown:selected()
		_menuResurrect:unselected()
		--删除复活界面
		if _resurrectLayer ~= nil then
			_resurrectLayer:removeAllChildrenWithCleanup(true)
			_resurrectLayer = nil
		end
		--创建分解界面
		if _whereILocate ~= "breakdown" then
			createBreakDownLayer()
			_whereILocate = "breakdown"
		end
	elseif tag == _ksTagResurrect then
		AudioUtil.playEffect("audio/effect/changtiaoxing.mp3")
		_menuResurrect:selected()
		_menuBreakDown:unselected()
		--删除分解界面
		if _breakDownLayer ~= nil then
			_breakDownLayer:removeAllChildrenWithCleanup(true)
			_breakDownLayer = nil
		end
		--创建复活界面
		if _whereILocate ~= "resurrect" then
			createResurrectLayer()
			_whereILocate = "resurrect"
		end
	elseif tag == _ksTagExplanation then
		AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
		if _whereILocate == "breakdown" then
			require "script/ui/recycle/BreakDownSay"
			local showLayer = BreakDownSay.createLayer()
			local runningScene = CCDirector:sharedDirector():getRunningScene()
			print("showLayer  is : ", showLayer)
			runningScene:addChild(showLayer, 9999)
		elseif _whereILocate == "resurrect" then
			require "script/ui/recycle/ResurrectSay"
			local showLayer = ResurrectSay.createLayer()
			local runningScene = CCDirector:sharedDirector():getRunningScene()
			print("showLayer  is : ", showLayer)
			runningScene:addChild(showLayer, 999)
		end
	elseif tag == _ksTagMysteryStore then
		AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
		---[==[炼化炉 新手引导屏蔽层 第3步changLayer
		---------------------新手引导---------------------------------
			--add by licong 2013.09.06
			require "script/guide/NewGuide"
			require "script/guide/ResolveGuide"
			if(NewGuide.guideClass ==  ksGuideResolve and ResolveGuide.stepNum == 3) then
				ResolveGuide.changLayer()
			end
		---------------------end-------------------------------------
		--]==]
		require "script/ui/rechargeActive/RechargeActiveMain"
		require "script/ui/rechargeActive/MysteryShopLayer"
		local showLayer = RechargeActiveMain.create(RechargeActiveMain._tagMysteryShop)
		-- local mysteryLayer= MysteryShopLayer.createLayer()
		-- showLayer.changeButtomLayer(mysteryLayer)
		MainScene.changeLayer(showLayer,"showLayer")
	end
end

--创建页面主菜单按钮
function createTopMenu()
	--创建主菜单标签
	local tArgs = {}
	tArgs[1] = {text=GetLocalizeStringBy("key_3040"), x=10, tag=_ksTagBreakDown, handler=fnHandlerOfButtons}
	tArgs[2] = {text=GetLocalizeStringBy("key_2251"), x=200, tag=_ksTagResurrect, handler=fnHandlerOfButtons}

	--创建主菜单
	require "script/libs/LuaCCSprite"
	local topMenuBar = LuaCCSprite.createTitleBar(tArgs)
	topMenuBar:setAnchorPoint(ccp(0, 1))
	topMenuBar:setPosition(0, _layerSize.height-50*MainScene.elementScale)
	topMenuBar:setScale(g_fScaleX)
	_bgLayer:addChild(topMenuBar)

	--获取两个分标签
	local topBottomMenu = tolua.cast(topMenuBar:getChildByTag(10001), "CCMenu")
	_menuBreakDown = tolua.cast(topBottomMenu:getChildByTag(_ksTagBreakDown), "CCMenuItem")
	_menuResurrect = tolua.cast(topBottomMenu:getChildByTag(_ksTagResurrect), "CCMenuItem")

	if _tParam == nil or _tArr == "BreakDownLayer" then
	--初始状态为选中分解
		_whereILocate = "breakdown"
		_menuBreakDown:selected()
		--创建分解界面
		createBreakDownLayer()
	else 
		_whereILocate = "resurrect"
		_menuResurrect:selected()
		createResurrectLayer()
	end
end

--创建说明，神秘商店按钮
function createOtherMenu()
	local menu = CCMenu:create()
    menu:setPosition(ccp(0,0))
    _bgLayer:addChild(menu)

	menuExplanation = CCMenuItemImage:create("images/recycle/btn/btn_explanation_h.png", "images/recycle/btn/btn_explanation_n.png")
	menuExplanation:registerScriptTapHandler(fnHandlerOfButtons)
	menuExplanation:setScale(MainScene.elementScale)
	menuExplanation:setAnchorPoint(ccp(0.5,0.5))
	menuExplanation:setPosition(60*MainScene.elementScale,_layerSize.height-230*MainScene.elementScale)
	menu:addChild(menuExplanation,1,_ksTagExplanation)

	menuMysteryStore = CCMenuItemImage:create("images/recycle/btn/btn_mysterystore_h.png", "images/recycle/btn/btn_mysterystore_n.png")
	menuMysteryStore:registerScriptTapHandler(fnHandlerOfButtons)
	menuMysteryStore:setScale(MainScene.elementScale)
	menuMysteryStore:setAnchorPoint(ccp(0.5,0.5))
	menuMysteryStore:setPosition(_layerSize.width-60*MainScene.elementScale,_layerSize.height-230*MainScene.elementScale)
	menu:addChild(menuMysteryStore,1,_ksTagMysteryStore)
end

function createBg()
	--背景
	local bgPicture = CCSprite:create("images/recycle/recyclebg.png")
	bgPicture:setAnchorPoint(ccp(0.5,0.5))
	bgPicture:setPosition(g_winSize.width/2,g_winSize.height/2)
	bgPicture:setScale(g_fBgScaleRatio)
	_bgLayer:addChild(bgPicture)

	--传说中的神炉出场~~~~~
	local owenPic = CCSprite:create("images/recycle/owen.png")
	owenPic:setAnchorPoint(ccp(0.5,0.5))
	owenPic:setPosition(g_winSize.width/2,g_winSize.height/2+50*g_fScaleY)
	owenPic:setScale(g_fBgScaleRatio)
	_bgLayer:addChild(owenPic)
end

--用于分解和重生层调用
function getLayerSize()
	return _layerSize
end

function createUI()
	_layerSize = _bgLayer:getContentSize()

	--创建背景
	createBg()

	--创建主菜单
	createTopMenu()
	
	--创建用户战斗力，财产信息栏
	createTopUI()

	--创建说明与神秘商店按钮
	createOtherMenu()
end

function create(tParam)
	init()

	_tParam = tParam
	if tParam and tParam.sign ~= nil then
		_tArr = tParam.sign
	end
	
	MainScene.getAvatarLayerObj():setVisible(false)
	require "script/ui/main/MenuLayer"
	MenuLayer.getObject():setVisible(true)

	_bgLayer = CCLayer:create()
	_bgLayer:registerScriptHandler(onNodeEvent)

	createUI()

	-- 炼化炉 第2步 内部提示
	local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.3),CCCallFunc:create(function ( ... )
			addGuideResolveGuide2()
		end))
	_bgLayer:runAction(seq)
	
	return _bgLayer
end

function updateSilver()
	local userInfo = UserModel.getUserInfo()
	silverLabel:setString(userInfo.silver_num)
end

function updateGold()
	local userInfo = UserModel.getUserInfo()
	goldLabel:setString(userInfo.gold_num)
end

--返回神秘商店按钮
function returnMysteryStore()
	return menuMysteryStore
end


---[==[炼化炉 第2步 内部提示
---------------------新手引导---------------------------------
function addGuideResolveGuide2( ... )
	require "script/guide/NewGuide"
	require "script/guide/ResolveGuide"
    if(NewGuide.guideClass ==  ksGuideResolve and ResolveGuide.stepNum == 1) then
        ResolveGuide.show(2, nil)
    end
end
---------------------end-------------------------------------
--]==]





function createSomethingAmazing(dictData)
	--owenPic:setVisible(false
	menuExplanation:setEnabled(false)
	if _whereILocate == "breakdown" then
		_menuResurrect:setEnabled(false)
	else
		_menuBreakDown:setEnabled(false)
	end
	require "script/audio/AudioUtil"

	AudioUtil.playEffect("audio/effect/chongshen.mp3")

	local spellEffectSprite = CCLayerSprite:layerSpriteWithName(CCString:create("images/base/effect/recycle/chongsheng" ), -1,CCString:create(""))
	spellEffectSprite:setScale(g_fBgScaleRatio)
	spellEffectSprite:setPosition(ccp(g_winSize.width/2,g_winSize.height/2+110*g_fScaleY))
    spellEffectSprite:setAnchorPoint(ccp(0.5, 0.5))
    _bgLayer:addChild(spellEffectSprite,9999)

    local animationEnd = function(actionName,xmlSprite)
    	require "script/ui/recycle/BreakDownLayer"
    	require "script/ui/recycle/ResurrectLayer"
    	print("@@@@@@@@@@@@@@@@@@@@@")
        spellEffectSprite:removeFromParentAndCleanup(true)
        menuExplanation:setEnabled(true)
        --spellEffectSprite1:removeFromParentAndCleanup(true)
        if _whereILocate == "breakdown" then
        	BreakDownLayer.animateCallBack(dictData)
        	_menuResurrect:setEnabled(true)
        else
        	ResurrectLayer.animateCallBack(dictData)
        	_menuBreakDown:setEnabled(true)
        end
    end
    -- 每次回调
    local animationFrameChanged = function(frameIndex,xmlSprite)
        print("$$$$$$$$$$$$$@@@@@@@@@@@@@@@@@@@@@")
    end

    --增加动画监听
    local delegate = BTAnimationEventDelegate:create()
    delegate:registerLayerEndedHandler(animationEnd)
    delegate:registerLayerChangedHandler(animationFrameChanged)
    
    spellEffectSprite:setDelegate(delegate)

    local spellEffectSprite1 = CCLayerSprite:layerSpriteWithName(CCString:create("images/base/effect/recycle/fazhen" ), -1,CCString:create(""))
	spellEffectSprite1:setScale(g_fBgScaleRatio)
	spellEffectSprite1:setPosition(ccp(g_winSize.width/2,g_winSize.height/2-90*g_fScaleY))
    spellEffectSprite1:setAnchorPoint(ccp(0.5, 0.5))
    _bgLayer:addChild(spellEffectSprite1,9999)

    local animationEnd1 = function(actionName,xmlSprite)
    	--require "script/ui/recycle/BreakDownLayer"
    	print("@@@@@@@@@@@@@@@@@@@@@")
    	spellEffectSprite1:retain()
		spellEffectSprite1:autorelease()
        spellEffectSprite1:removeFromParentAndCleanup(true)
        --BreakDownLayer.animateCallBack()
    end
    -- 每次回调
    local animationFrameChanged1 = function(frameIndex,xmlSprite)
        print("$$$$$$$$$$$$$@@@@@@@@@@@@@@@@@@@@@")
    end

    --增加动画监听
    local delegate1 = BTAnimationEventDelegate:create()
    delegate1:registerLayerEndedHandler(animationEnd1)
    delegate1:registerLayerChangedHandler(animationFrameChanged1)
    
    spellEffectSprite1:setDelegate(delegate1)
end

