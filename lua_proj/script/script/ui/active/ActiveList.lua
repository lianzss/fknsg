-- FileName: ActiveList.lua 
-- Author: Li Cong 
-- Date: 13-8-10 
-- Purpose: function description of module 
-- 活动入口

require "script/model/DataCache"
require "script/ui/item/ItemUtil"
module("ActiveList", package.seeall)

-- 新手按钮对象
local menuItem_arr = {}
-- local 全局变量
local IMG_PATH = "images/active/activeList/"					-- 图片主路径
local m_activeList = nil       							    	-- 活动列表层
local layerSize    = nil                                     	-- 活动列表层大小
local titleSize    = nil										-- 上方标题栏宽高
local cellHeight = 232                                          -- 单元格高度
local cellInterval = 5                                         	-- 单元格间隔距离
local refreshActiveListGold = nil								-- 刷新金币函数
local liebiao      = nil  										-- 列表
-- 各个活动itme的tag值
_ksTagTreasure 		= 1 -- 夺宝
_ksTagjingjichang 	= 2 -- 竞技场
_ksTagziyuankuang 	= 3 -- 资源矿
_ksTagxunlong 	  	= 4 -- 寻龙探宝
_ksTagshilianta 	= 5 -- 试练塔
_ksTagbiwu 			= 6  -- 比武
_ksTagshijieboos 	= 7 -- 世界boos
_ksTagOlympic 		= 8 -- 擂台争霸
-- 活动的名字表
local tActiveList = {	
						{name = "duobao",tag = _ksTagTreasure },
						{name = "jingjichang",tag = _ksTagjingjichang },
						{name = "ziyuankuang",tag = _ksTagziyuankuang },
						{name = "xunlong",tag = _ksTagxunlong },
						{name = "shilianta",tag = _ksTagshilianta },
						{name = "biwu",tag = _ksTagbiwu },
						{name = "shijieboos",tag = _ksTagshijieboos },
						{name = "olympic",tag = _ksTagOlympic },
}
-- 活动列表的个数   		
local nActiveNum = table.count(tActiveList) 
-- tag查询表                            
local tTag = {
		
}

--[[
	@des 	:处理enter和exit事件
	@param 	:
	@return :
--]]
local function onNodeEvent( event )
	if (event == "enter") then
		require "script/ui/shop/RechargeLayer"
		RechargeLayer.registerChargeGoldCb(refreshActiveListGold)
	elseif (event == "exit") then
		require "script/ui/shop/RechargeLayer"
		RechargeLayer.registerChargeGoldCb(nil)
		-- 记忆列表offset
		local offset = liebiao:getContentOffset()
		MainScene.setOffsetForList(offset)
		-- layer置nil
		m_activeList = nil
	end
end

--  活动入口MenuItme回调
local function activeItemCallFun( tag, item_obj )
	-- 音效
    require "script/audio/AudioUtil"
    require "script/guide/ArenaGuide"
    require "script/guide/MineralGuide"
    AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
	if (tag == _ksTagjingjichang) then
		-- print (GetLocalizeStringBy("key_2467"))
		if(ItemUtil.isBagFull() == true )then
			ArenaGuide.closeGuide()
			return
		end
		-- 判断武将满了
		require "script/ui/hero/HeroPublicUI"
	    if HeroPublicUI.showHeroIsLimitedUI() then
	    	
	    	return
	    end
		---[==[竞技场 清除新手引导
		---------------------新手引导---------------------------------
		--add by licong 2013.09.29
		require "script/guide/NewGuide"
		if(NewGuide.guideClass == ksGuideArena) then
			require "script/guide/ArenaGuide"
			ArenaGuide.cleanLayer()
		end
		---------------------end-------------------------------------
		--]==]
		local canEnter = DataCache.getSwitchNodeState( ksSwitchArena )
		if( canEnter ) then
			require "script/ui/arena/ArenaLayer"
			local arenaLayer = ArenaLayer.createArenaLayer()
			MainScene.changeLayer(arenaLayer, "arenaLayer")
		end
	elseif (tag == _ksTagziyuankuang) then
		-- print (GetLocalizeStringBy("key_2551"))
		---[==[资源矿 新手引导屏蔽层
		---------------------新手引导---------------------------------
		--add by licong 2013.09.29
		require "script/guide/NewGuide"
		if(NewGuide.guideClass == ksGuideResource) then
			require "script/guide/MineralGuide"
			MineralGuide.changLayer()
		end
		---------------------end-------------------------------------
		--]==]
		local canEnter = DataCache.getSwitchNodeState( ksSwitchResource )
		if( canEnter ) then
			require "script/ui/active/MineralLayer"
			local mineralLayer = MineralLayer.createLayer()
			MainScene.changeLayer(mineralLayer, "mineralLayer")
		end
	elseif (tag == _ksTagbiwu) then
		-- print (GetLocalizeStringBy("key_1842"))
		if(ItemUtil.isBagFull() == true )then
			return
		end
		-- 判断武将满了
		require "script/ui/hero/HeroPublicUI"
	    if HeroPublicUI.showHeroIsLimitedUI() then
	    	return
	    end
		---[==[比武 新手引导屏蔽层
		---------------------新手引导---------------------------------
		--add by licong 2013.09.29
		require "script/guide/NewGuide"
		if(NewGuide.guideClass == ksGuideContest) then
			require "script/guide/MatchGuide"
			MatchGuide.changLayer()
		end
		---------------------end-------------------------------------
		--]==]
		local canEnter = DataCache.getSwitchNodeState( ksSwitchContest )
		if( canEnter ) then
			-- require "script/ui/active/ActiveLayer"
			-- local activeLayer = ActiveLayer.createLayer()
			-- MainScene.changeLayer(activeLayer, "activeLayer")
			
			require "script/ui/match/MatchLayer"
			local matchLayer = MatchLayer.createMatchLayer()
			MainScene.changeLayer(matchLayer, "matchLayer")
		end
	elseif(tag == _ksTagTreasure) then
		require "script/guide/NewGuide"
		if(ItemUtil.isBagFull() == true )then
			if(NewGuide.guideClass == ksGuideRobTreasure) then
				--	如果背包满的话，关闭夺宝新手引导
				RobTreasureGuide.cleanLayer()
				RobTreasureGuide.stepNum =0
				NewGuide.guideClass = ksGuideClose
				BTUtil:setGuideState(false)
			end
			return
		end
		-- 判断武将满了
		require "script/ui/hero/HeroPublicUI"
	    if HeroPublicUI.showHeroIsLimitedUI() then
			if(NewGuide.guideClass == ksGuideRobTreasure) then
				--	如果武将满的话，关闭夺宝新手引导
				RobTreasureGuide.cleanLayer()
				RobTreasureGuide.stepNum =0
				NewGuide.guideClass = ksGuideClose
				BTUtil:setGuideState(false)
			end
	    	return
	    end
		if(DataCache.getSwitchNodeState( ksSwitchRobTreasure ) ~= true) then
			return
		end
		require "script/ui/treasure/TreasureMainView"
		local treasureLayer = TreasureMainView.create()
		MainScene.changeLayer(treasureLayer,"treasureLayer")

		require "script/guide/NewGuide"
		if(NewGuide.guideClass == ksGuideRobTreasure) then
			RobTreasureGuide.changLayer()
		end
	elseif (tag == _ksTagshilianta) then
		print (GetLocalizeStringBy("key_1704"))
		if(ItemUtil.isBagFull() == true )then
			return
		end
		local canEnter = DataCache.getSwitchNodeState( ksSwitchTower )
		if( canEnter ) then
			require "script/ui/tower/TowerMainLayer"
			local towerMainLayer = TowerMainLayer.createLayer()
			MainScene.changeLayer(towerMainLayer, "towerMainLayer")
		end
	elseif (tag == _ksTagshijieboos) then
		print ("世界boos入口")
		local canEnter = DataCache.getSwitchNodeState( ksSwitchWorldBoss )
		if( canEnter ) then
			--世界boss
			require "script/ui/boss/BossMainLayer"
			local bossLayer = BossMainLayer.createBoss()
			MainScene.changeLayer(bossLayer, "bossLayer")
		end
	elseif(tag == _ksTagxunlong) then
		---[==[寻龙 新手引导屏蔽层
		---------------------新手引导---------------------------------
		require "script/guide/NewGuide"
		if(NewGuide.guideClass == ksGuideFindDragon) then
			require "script/guide/XunLongGuide"
			XunLongGuide.changLayer()
		end
		---------------------end-------------------------------------
		--]==]
  		--寻龙探宝入口
  		if not DataCache.getSwitchNodeState(ksFindDragon) then
			return
		end
        require "script/ui/forge/FindTreasureLayer"
        FindTreasureLayer.show()
  	elseif(tag == _ksTagOlympic) then
  		if not DataCache.getSwitchNodeState(ksOlympic) then
			return
		end
		if(NewGuide.guideClass == ksGuideOlympic) then
			require "script/guide/RobTreasureGuide"
			OlympicGuild.closeGuide()
		end
  		require "script/ui/olympic/OlympicPrepareLayer"
        OlympicPrepareLayer.enter()
  	else
  		
	end
end 


-- 创建活动入口层
function initActiveListLayer()
	-- 列表layer大小
	layerSize = m_activeList:getContentSize()

	require "script/model/user/UserModel"
    local userInfo = UserModel.getUserInfo()
    if userInfo == nil then
        return
    end

	-- 上标题栏 显示战斗力，银币，金币
	local topBg = CCSprite:create("images/hero/avatar_attr_bg.png")
    topBg:setAnchorPoint(ccp(0,1))
    topBg:setPosition(0,layerSize.height)
    topBg:setScale(g_fScaleX/MainScene.elementScale)
    m_activeList:addChild(topBg)
    titleSize = topBg:getContentSize()
    
    local powerDescLabel = CCSprite:create("images/common/fight_value.png")
    powerDescLabel:setAnchorPoint(ccp(0.5,0.5))
    powerDescLabel:setPosition(topBg:getContentSize().width*0.13,topBg:getContentSize().height*0.43)
    topBg:addChild(powerDescLabel)
    
    m_powerLabel = CCRenderLabel:create( tonumber(UserModel.getFightForceValue()), g_sFontName, 23, 1.5, ccc3( 0x00, 0x00, 0x00), type_stroke)
    m_powerLabel:setColor(ccc3(0xff, 0xf6, 0x00))
    m_powerLabel:setPosition(topBg:getContentSize().width*0.23,topBg:getContentSize().height*0.66)
    topBg:addChild(m_powerLabel)
    
    m_silverLabel = CCLabelTTF:create( tonumber(userInfo.silver_num),g_sFontName,18)
    m_silverLabel:setColor(ccc3(0xe5,0xf9,0xff))
    m_silverLabel:setAnchorPoint(ccp(0,0.5))
    m_silverLabel:setPosition(topBg:getContentSize().width*0.61,topBg:getContentSize().height*0.43)
    topBg:addChild(m_silverLabel)
    
    m_goldLabel = CCLabelTTF:create( tonumber(userInfo.gold_num),g_sFontName,18)
    m_goldLabel:setColor(ccc3(0xff,0xe2,0x44))
    m_goldLabel:setAnchorPoint(ccp(0,0.5))
    m_goldLabel:setPosition(topBg:getContentSize().width*0.82,topBg:getContentSize().height*0.43)
    topBg:addChild(m_goldLabel)
    
    -- 创建滑动列表
    createScrollViewLayer()

    -- 上边箭头
    local upArrow = CCSprite:create("images/formation/btn_right.png")
    upArrow:setAnchorPoint(ccp(0.5,0.5))
    upArrow:setRotation(270)
    upArrow:setPosition(ccp(m_activeList:getContentSize().width-upArrow:getContentSize().width*0.5*MainScene.elementScale-10*MainScene.elementScale,topBg:getPositionY()-topBg:getContentSize().height*MainScene.elementScale-18*MainScene.elementScale))
    m_activeList:addChild(upArrow,10)
    upArrow:setScale(g_fScaleX/MainScene.elementScale)

    -- 下边箭头
    local downArrow = CCSprite:create("images/formation/btn_right.png")
    downArrow:setAnchorPoint(ccp(0.5,0.5))
    downArrow:setRotation(90)
    downArrow:setPosition(ccp(m_activeList:getContentSize().width-downArrow:getContentSize().width*0.5*MainScene.elementScale-10*MainScene.elementScale,downArrow:getContentSize().height*0.5*MainScene.elementScale+10*MainScene.elementScale))
    m_activeList:addChild(downArrow,10)
    downArrow:setScale(g_fScaleX/MainScene.elementScale)

end

-- 创建滑动列表ScrollViewLayer
function createScrollViewLayer( ... )
	-- scrollView
	liebiao = CCScrollView:create()
	liebiao:setContentSize(CCSizeMake(layerSize.width,layerSize.height - titleSize.height*g_fScaleX))
	liebiao:setViewSize(CCSizeMake(layerSize.width,layerSize.height - titleSize.height*g_fScaleX ))
    liebiao:setScale(1/MainScene.elementScale)
	-- 设置弹性属性
	-- liebiao:setBounceable(false)
	-- 设置滑动列表的优先级
	liebiao:setTouchPriority(-130)
	-- 垂直方向滑动
	liebiao:setDirection(kCCScrollViewDirectionVertical)
	liebiao:setPosition(ccp(0,0))
	m_activeList:addChild(liebiao)
	-- 创建显示内容layer Container
	local container_layer = CCLayer:create()
	container_layer:setContentSize(CCSizeMake(liebiao:getViewSize().width, ((cellInterval+cellHeight)*nActiveNum + cellInterval)*g_fScaleX))
	liebiao:setContainer(container_layer)
	-- 如果是点击比武cell时，列表显示最底部。 列表不用设偏移量
	require "script/guide/NewGuide"
	require "script/guide/MatchGuide"
    if(NewGuide.guideClass ==  ksGuideRobTreasure) then
    	-- 夺宝
    	-- 默认显示最上方(设置偏移值)
		liebiao:setContentOffset(ccp(0,liebiao:getViewSize().height-container_layer:getContentSize().height))
    elseif(NewGuide.guideClass ==  ksGuideArena)then
    	-- 竞技场
    	-- 默认显示最上方(设置偏移值)
    	liebiao:setContentOffset(ccp(0,liebiao:getViewSize().height-container_layer:getContentSize().height))
    elseif(NewGuide.guideClass ==  ksGuideResource)then
    	-- 资源矿
    	-- 默认显示最上方(设置偏移值)
    	liebiao:setContentOffset(ccp(0,liebiao:getViewSize().height-container_layer:getContentSize().height))
    elseif(NewGuide.guideClass ==  ksGuideFindDragon)then
    	-- 寻龙探宝
    	-- 默认显示最第3个(设置偏移值) 
    	liebiao:setContentOffset(ccp(0,liebiao:getViewSize().height-container_layer:getContentSize().height+((cellInterval+cellHeight)*2 + cellInterval)*g_fScaleX))
    elseif(NewGuide.guideClass ==  ksGuideContest)then
    	-- 比武
    	-- 默认显示最第5个(设置偏移值) 
    	liebiao:setContentOffset(ccp(0,liebiao:getViewSize().height-container_layer:getContentSize().height+((cellInterval+cellHeight)*4 + cellInterval)*g_fScaleX))
    elseif(NewGuide.guideClass ==  ksGuideOlympic)then
    	--擂台争霸
    	liebiao:setContentOffset(ccp(0,0))
    else
    	local offset = MainScene.getOffsetForList()
    	if(offset)then
    		-- 读取记忆偏移量
	    	liebiao:setContentOffset(offset)
    	else
	    	-- 默认显示最上方(设置偏移值)
	    	liebiao:setContentOffset(ccp(0,liebiao:getViewSize().height-container_layer:getContentSize().height))
	    end
	end
	
	-- 创建活动单元格
	for i=1, nActiveNum do
		-- 创建最上层单元格背景
		local bgSprite = CCSprite:create(IMG_PATH .. "activeItem_bg.png")
		bgSprite:setAnchorPoint(ccp(0.5,0))
		bgSprite:setPosition(ccp(container_layer:getContentSize().width*0.5,
    	container_layer:getContentSize().height-(cellHeight+cellInterval)*i*g_fScaleX))
		container_layer:addChild(bgSprite,3,i)
        bgSprite:setScale(g_fScaleX)
		-- print("i",i, bgSprite:getContentSize().width,bgSprite:getContentSize().height)
		-- print("Position",bgSprite:getPositionX(),bgSprite:getPositionY())
		
		-- 创建活动入口menu
		local activeMenu = BTSensitiveMenu:create()
		if(activeMenu:retainCount()>1)then
			activeMenu:release()
			activeMenu:autorelease()
		end
		activeMenu:setPosition(ccp(0,0))
		bgSprite:addChild(activeMenu,-1)
		-- 创建各个活动对应的MenuItem
		local meunItem = createActiveMenuItem(tActiveList[i].name)
		meunItem:setAnchorPoint(ccp(0.5,0.5))
		meunItem:setPosition(ccp(bgSprite:getContentSize().width*0.5,bgSprite:getContentSize().height*0.5-2.5))
		activeMenu:addChild(meunItem,1,tActiveList[i].tag)
		-- 注册item回调
		meunItem:registerScriptTapHandler(activeItemCallFun)
		-- 新手需求
		menuItem_arr[i] = bgSprite
	end

end


-- 创建列表menuItem
function createActiveMenuItem( sCellValue )
	if(sCellValue ~= nil)then
		local normalSprite = CCSprite:create(IMG_PATH .. sCellValue .. "Item.png")
		local selectSprite = CCSprite:create(IMG_PATH .. sCellValue .. "Item.png")
		-- 创建第二层阴影边框
		local itemBox = CCSprite:create(IMG_PATH .. "activeItem_box.png")
		itemBox:setAnchorPoint(ccp(0.5,0.5))
		itemBox:setPosition(ccp(selectSprite:getContentSize().width*0.5,selectSprite:getContentSize().height*0.5))
		selectSprite:addChild(itemBox,2)
		local item = CCMenuItemSprite:create(normalSprite,selectSprite)
		-- 添加各个活动的标题
		local titleSprite = CCSprite:create(IMG_PATH .. sCellValue .. ".png")
		titleSprite:setAnchorPoint(ccp(0,1))
		titleSprite:setPosition(ccp(25,item:getContentSize().height-10))
		item:addChild(titleSprite,1,1)
		-- 添加各个活动描述
		local desSprite = CCSprite:create(IMG_PATH .. sCellValue .. "_des.png")
		desSprite:setAnchorPoint(ccp(0.5,0))
		desSprite:setPosition(ccp(item:getContentSize().width*0.5,10))
		item:addChild(desSprite,1,2)
		-- 返回item
		return item
	end
end

-- 创建活动列层
function createActiveListLayer()
    m_activeList = MainScene.createBaseLayer(IMG_PATH .. "activeList_bg.jpg",true,false,true)
    m_activeList:registerScriptHandler(onNodeEvent)
    
    -- 初始化
    initActiveListLayer()

    --添加需要的红点提示
    addRebTip()
    
    --添加擂台赛红圈提示
    addRebTip()

    local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.3),CCCallFunc:create(function ( ... )
    		-- 竞技场
			addGuideArenaGuide2()
			-- 资源矿
			addGuideMineralGuide2()
			-- 比武
			addGuideMatchGuide2()
			--夺宝
			addGuideRobTreasure()
			-- 寻龙探宝
			addGuideXunLongGuide2()
			-- 擂台争霸
			addGuideOlympic()
		end))
	m_activeList:runAction(seq)
	
	-- 爬塔添加提示重置次数
	addTipSprite( _ksTagshilianta )

    return m_activeList
end

-- 添加提示
function addTipSprite( index )
	local item = getMenuItemNode(tonumber(index))
	local itemNode = tolua.cast(item,"CCMenuItemSprite")
	if( itemNode:getChildByTag(100) ~= nil )then
		itemNode:getChildByTag(100):removeFromParentAndCleanup(true)
	end
	require "script/utils/ItemDropUtil"
	if(tonumber(index) == _ksTagshilianta )then
		-- 试练塔
		require "script/ui/tower/TowerCache"
		local num = TowerCache.getResetTowerTimes()
		local tipSprite = ItemDropUtil.getTipSpriteByNum(num)
		tipSprite:setPosition(itemNode:getContentSize().width*0.95, itemNode:getContentSize().height*0.9)
		tipSprite:setAnchorPoint(ccp(1,1))
		itemNode:addChild(tipSprite,1,100)
		if(num<=0)then
			tipSprite:setVisible(false)
		end
	end
end

-- 新手引导
-- num:第几个itme 自上而下从1开始
function getMenuItemNode( num )
	return menuItem_arr[num]
end


--[[
	@des ： 添加红圈提示
--]]
function addRebTip( ... )
	
	--添加擂台赛红圈提示
	local olympicItem = getMenuItemNode(8)
	local tipSprite   = CCSprite:create("images/common/tip_1.png")
	tipSprite:setAnchorPoint(ccp(0.5, 0.5))
	tipSprite:setPosition(ccpsprite(0.92, 0.8, olympicItem))
	olympicItem:addChild(tipSprite)
	-- 添加擂台赛开启时间描述
	require "script/ui/olympic/OlympicData"

	local durTime = OlympicData.getOlympicOpenTime() + 1800 - BTUtil:getSvrTimeInterval() 
	if(OlympicData.getOlympicOpenTime() > BTUtil:getSvrTimeInterval() or (OlympicData.getOlympicOpenTime() + 1800) < BTUtil:getSvrTimeInterval()) then
		tipSprite:setVisible(false)
	else
		local actionArray = CCArray:create()
		actionArray:addObject(CCDelayTime:create(durTime))
		actionArray:addObject(CCCallFunc:create(function ( ... )
			tipSprite:setVisible(false)
		end))
		local seq =  CCSequence:create(actionArray)
		local runningScene = CCDirector:sharedDirector():getRunningScene()
		tipSprite:runAction(seq)
	end

	local openTimeLabel = CCRenderLabel:create(OlympicData.getStartTimeDes(), g_sFontPangWa, 26, 1, ccc3( 0x00, 0x00, 0x00), type_shadow)
	openTimeLabel:setAnchorPoint(ccp(0.5,0.5))
	openTimeLabel:setPosition(303, 82)
	openTimeLabel:setColor(ccc3(237, 184, 0))
	olympicItem:addChild(openTimeLabel)

end

---[==[竞技场 第2步∏
---------------------新手引导---------------------------------
function addGuideArenaGuide2( ... )
	require "script/guide/NewGuide"
	require "script/guide/ArenaGuide"
    if(NewGuide.guideClass == ksGuideArena and ArenaGuide.stepNum == 1) then
        local arenaButton = getMenuItemNode(ActiveList._ksTagjingjichang)
        local touchRect   = getSpriteScreenRect(arenaButton)
        ArenaGuide.show(2, touchRect)
    end
end
---------------------end-------------------------------------
--]==]


---[==[资源矿 第2步
---------------------新手引导---------------------------------
function addGuideMineralGuide2( ... )
	require "script/guide/NewGuide"
	require "script/guide/MineralGuide"
    if(NewGuide.guideClass ==  ksGuideResource and MineralGuide.stepNum == 1) then
        local mineralButton = getMenuItemNode(ActiveList._ksTagziyuankuang)
        local touchRect   = getSpriteScreenRect(mineralButton)
        MineralGuide.show(2, touchRect)
    end
end
---------------------end-------------------------------------
--]==]


---[==[比武 第2步
---------------------新手引导---------------------------------
function addGuideMatchGuide2( ... )
	require "script/guide/NewGuide"
	require "script/guide/MatchGuide"
    if(NewGuide.guideClass ==  ksGuideContest and MatchGuide.stepNum == 1) then
        local matchGuidButton = getMenuItemNode(ActiveList._ksTagbiwu)
        local touchRect   = getSpriteScreenRect(matchGuidButton)
        MatchGuide.show(2, touchRect)
    end
end
---------------------end-------------------------------------
--]==]

---[==[寻龙 第2步
---------------------新手引导---------------------------------
function addGuideXunLongGuide2( ... )
	require "script/guide/NewGuide"
	require "script/guide/XunLongGuide"
    if(NewGuide.guideClass ==  ksGuideFindDragon and XunLongGuide.stepNum == 1) then
        local button = getMenuItemNode(ActiveList._ksTagxunlong)
        local touchRect   = getSpriteScreenRect(button)
        XunLongGuide.show(2, touchRect)
    end
end
---------------------end-------------------------------------
--]==]


--[[
	@des:	夺宝系统
]]
function addGuideRobTreasure( ... )
	require "script/guide/RobTreasureGuide"
    if(NewGuide.guideClass ==  ksGuideRobTreasure and RobTreasureGuide.stepNum == 0) then
       	require "script/ui/active/ActiveList"
        local robTreasure = ActiveList.getMenuItemNode(ActiveList._ksTagTreasure)
        local touchRect   = getSpriteScreenRect(robTreasure)
        RobTreasureGuide.show(1, touchRect)
    end
    if(NewGuide.guideClass ==  ksGuideRobTreasure and RobTreasureGuide.stepNum == 11) then
       	require "script/ui/active/ActiveList"
       	RobTreasureGuide.changLayer()
        local robTreasure = ActiveList.getMenuItemNode(ActiveList._ksTagTreasure)
        local touchRect   = getSpriteScreenRect(robTreasure)
        RobTreasureGuide.show(12, touchRect)
    end
end

--[[
	@des :	擂台争霸
--]]
function addGuideOlympic( ... )

	require "script/guide/OlympicGuild"
    if(NewGuide.guideClass ==  ksGuideOlympic and OlympicGuild.stepNum == 0) then
       	require "script/ui/active/ActiveList"
        local olympicBtn = ActiveList.getMenuItemNode(ActiveList._ksTagOlympic)
        local touchRect   = getSpriteScreenRect(olympicBtn)
        OlympicGuild.show(1, touchRect)
    end
 
end


-- 刷新活动列表界面金币
refreshActiveListGold = function ( ... )
	if(m_goldLabel)then
		m_goldLabel:setString( UserModel.getGoldNumber() )
	end
end


function closeNewGuide( ... )
	require "script/guide/ArenaGuide"
    require "script/guide/MineralGuide"
    require "script/guide/MatchGuide"
    require "script/guide/RobTreasureGuide"

    if(NewGuide.guideClass == ksGuideArena) then
		require "script/guide/ArenaGuide"
		ArenaGuide.closeGuide()
	end

    if(NewGuide.guideClass == ksGuideResource) then
		require "script/guide/MineralGuide"
		MineralGuide.closeGuide()
	end
	if(NewGuide.guideClass == ksGuideContest) then
		require "script/guide/MatchGuide"
		MatchGuide.closeGuide()
	end
	if(NewGuide.guideClass == ksGuideRobTreasure) then
		require "script/guide/RobTreasureGuide"
		RobTreasureGuide.closeGuide()
	end
	if(NewGuide.guideClass == ksGuideOlympic) then
		require "script/guide/RobTreasureGuide"
		OlympicGuild.closeGuide()
	end
end


