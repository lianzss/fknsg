-- Filename: MenuLayer.lua.
-- Author: fang.
-- Date: 2013-05-23
-- Purpose: 该文件用于实现主菜单模块


module ("MenuLayer", package.seeall)
require "script/ui/shop/GiftService"

-- 模块状态, 0 -> uninitialized, 1 -> showed, 2 -> hidden.
local ksModStatusUninitialized = 0
local ksModStatusShowed = 1
local ksModStatusHidden = 2
local mod_status = ksModStatusUninitialized

local menuLayer = nil
local IMG_PATH = "images/main/menu/"		-- 主城场景菜单图片路径

local _menu_bg

local mainMenu1stCallback = nil
local mainMenu2stCallback = nil
local mainMenu3stCallback = nil
local mainMenu4stCallback = nil
local mainMenu5stCallback = nil
local mainMenu6stCallback = nil

-- 获取主页菜单图片完整路径
local getMenuImageFullPath = function (filename, isHighlighted)
	if isHighlighted then
		return IMG_PATH..filename.."_h.png"
	end
	return IMG_PATH..filename.."_n.png"
end

-- 菜单图片对应名称，n表示普通图片，h表示高亮图片
local menu_items = {"mainpage", "formation", "copy", "promotion", "shop", "bag"}

-- 菜单项对象数组
local menu_item_objs = {}
-- 菜单项tap事件处理函数
local function menu_item_tap_handler(tag, item_obj)
	local runningScene = CCDirector:sharedDirector():getRunningScene()
    
    --点击音效
    require "script/audio/AudioUtil"
    AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
	require "script/ui/main/MainScene"
	require "script/model/DataCache"
	require "script/ui/tip/AnimationTip"
	print (GetLocalizeStringBy("key_1349"), tag)
	if(tag == 1001) then
		---[==[名将 新手引导屏蔽层
		---------------------新手引导---------------------------------
		--add by licong 2013.09.29
		require "script/guide/NewGuide"
		if(NewGuide.guideClass == ksGuideGreatSoldier) then
			require "script/guide/StarHeroGuide"
			StarHeroGuide.changLayer()
		end
		---------------------end-------------------------------------
		--]==]
		if(mainMenu1stCallback ~= nil) then
			mainMenu1stCallback()
		end
		require "script/ui/main/MainBaseLayer"
		local main_base_layer = MainBaseLayer.create()
		MainScene.changeLayer(main_base_layer, "main_base_layer",MainBaseLayer.exit)
        MainScene.setMainSceneViewsVisible(true,true,true)
	elseif tag == 1002 then
		if(mainMenu2stCallback ~= nil) then
			mainMenu2stCallback()
		end
		if not DataCache.getSwitchNodeState(ksSwitchFormation) then
			return
		end
        ----------------新手引导代码----------------
        require "script/guide/NewGuide"
	    if(NewGuide.guideClass ==  ksGuideFormation) then
		    --add by lichenyang 2013.08.29
		    require "script/guide/FormationGuide"
		    FormationGuide.changLayer()
		end
	    -------------------end--------------------

	    ---[==[等级礼包新手引导屏蔽层
		---------------------新手引导---------------------------------
		--add by licong 2013.09.09
		require "script/guide/NewGuide"
		if(NewGuide.guideClass == ksGuideFiveLevelGift) then
			require "script/guide/LevelGiftBagGuide"
			LevelGiftBagGuide.changLayer()
		end
		---------------------end-------------------------------------
		--]==]
		
		---[==[第4个上阵栏位开启 新手引导屏蔽层
		---------------------新手引导---------------------------------
		--add by licong 2013.09.09
		require "script/guide/NewGuide"
		if(NewGuide.guideClass == ksGuideForthFormation) then
			require "script/guide/ForthFormationGuide"
			ForthFormationGuide.changLayer()
		end
		---------------------end-------------------------------------
		--]==]
		
		---[==[铁匠铺 新手引导屏蔽层
		---------------------新手引导---------------------------------
		--add by licong 2013.09.26
		require "script/guide/NewGuide"
		if(NewGuide.guideClass == ksGuideSmithy) then
			require "script/guide/EquipGuide"
			EquipGuide.changLayer()
		end
		---------------------end-------------------------------------
		--]==]
		
	    require("script/ui/formation/FormationLayer")
        local formationLayer = FormationLayer.createLayer()
        MainScene.changeLayer(formationLayer, "formationLayer")


    elseif(tag == 1003) then

    	if(mainMenu3stCallback ~= nil) then
    		mainMenu3stCallback()
    	end

    	---[==[强化所新手引导屏蔽层
		---------------------新手引导---------------------------------
			--add by licong 2013.09.06
			require "script/guide/NewGuide"
			if(NewGuide.guideClass ==  ksGuideForge) then
				require "script/guide/StrengthenGuide"
				StrengthenGuide.changLayer()
			end
		---------------------end-------------------------------------
		--]==]
		
		---[==[等级礼包新手引导屏蔽层
		---------------------新手引导---------------------------------
		--add by licong 2013.09.09
		require "script/guide/NewGuide"
		if(NewGuide.guideClass == ksGuideFiveLevelGift) then
			require "script/guide/LevelGiftBagGuide"
			LevelGiftBagGuide.changLayer()
		end
		---------------------end-------------------------------------
		--]==]

    	----------------新手引导代码----------------
        require "script/guide/NewGuide"
	    if(NewGuide.guideClass ==  ksGuideFormation) then
		    --add by lichenyang 2013.08.29
		    require "script/guide/FormationGuide"
		    FormationGuide.changLayer()
		end
	    -------------------end--------------------

	    ---[==[副本箱子 新手引导屏蔽层
		---------------------新手引导---------------------------------
			--add by licong 2013.09.11
			require "script/guide/NewGuide"
			if(NewGuide.guideClass ==  ksGuideCopyBox) then
				require "script/guide/CopyBoxGuide"
				CopyBoxGuide.changLayer()
			end
		---------------------end-------------------------------------
		--]==]

		---[==[精英副本 新手引导屏蔽层
		---------------------新手引导---------------------------------
			--add by licong 2013.09.26
			require "script/guide/NewGuide"
			if(NewGuide.guideClass == ksGuideEliteCopy) then
				require "script/guide/EliteCopyGuide"
				EliteCopyGuide.changLayer()
			end
		---------------------end-------------------------------------
		--]==]
		require "script/ui/copy/CopyLayer"

		local didCreateTableView = function ( ... )
			---------------------新手引导---------------------------------
		    require "script/guide/NewGuide"
		    print("g_guideClass = ", NewGuide.guideClass)
		    if(NewGuide.guideClass ==  ksGuideFormation and FormationGuide.stepNum == 5) then
			    --add by lichenyang 2013.08.29
			    require "script/guide/FormationGuide"
			    local formationButton = CopyLayer.getGuideObject()
			    local touchRect       = getSpriteScreenRect(formationButton)
			    FormationGuide.show(6, touchRect)
			end
		    ---------------------end-------------------------------------
		end
		local didClickCopyCallback = function ( ... )
			----------------新手引导代码----------------
	        require "script/guide/NewGuide"
		    if(NewGuide.guideClass ==  ksGuideFormation) then
			    --add by lichenyang 2013.08.29
			    require "script/guide/FormationGuide"
			    FormationGuide.cleanLayer()
			end
		    -------------------end--------------------
		end
		require "script/guide/NewGuide"
		require "script/guide/GeneralUpgradeGuide"
	    if(NewGuide.guideClass ==  ksGuideGeneralUpgrade) then
	        GeneralUpgradeGuide.changeLayer()
	    end

	    ---[==[铁匠铺 新手引导屏蔽层
		---------------------新手引导---------------------------------
		--add by licong 2013.09.26
		require "script/guide/NewGuide"
		if(NewGuide.guideClass == ksGuideSmithy) then
			require "script/guide/EquipGuide"
			EquipGuide.changLayer()
		end
		---------------------end-------------------------------------
		--]==]
		CopyLayer.registerDidTableViewCallBack(didCreateTableView)
		CopyLayer.registerSelectCopyCallback(didClickCopyCallback)

		local copyLayer = CopyLayer.createLayer()
		MainScene.changeLayer(copyLayer, "copyLayer")



	elseif(tag == 1004) then
		---[==[竞技场 新手引导屏蔽层
		---------------------新手引导---------------------------------
		--add by licong 2013.09.29
		require "script/guide/NewGuide"
		if(NewGuide.guideClass == ksGuideArena) then
			require "script/guide/ArenaGuide"
			ArenaGuide.changLayer()
		end
		---------------------end-------------------------------------
		--]==]

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

		---[==[寻龙 新手引导屏蔽层
		---------------------新手引导---------------------------------
		require "script/guide/NewGuide"
		if(NewGuide.guideClass == ksGuideFindDragon) then
			require "script/guide/XunLongGuide"
			XunLongGuide.changLayer()
		end
		---------------------end-------------------------------------
		--]==]
		if(mainMenu4stCallback ~= nil) then
			mainMenu4stCallback()
		end
		local runningScene = CCDirector:sharedDirector():getRunningScene()
		print("FormationGuide runningScene = ", runningScene)
		-- 活动入口
		require "script/ui/active/ActiveList"
		local  activeList = ActiveList.createActiveListLayer()
		MainScene.changeLayer(activeList, "activeList")
	elseif(tag == 1005) then

		if(mainMenu5stCallback ~= nil) then
			mainMenu5stCallback()
		end
		---[==[签到 新手引导屏蔽层
		---------------------新手引导---------------------------------
		--add by licong 2013.09.29
		require "script/guide/NewGuide"
		if(NewGuide.guideClass == ksGuideSignIn) then
			require "script/guide/SignInGuide"
			SignInGuide.changLayer()
		end
		---------------------end-------------------------------------
		--]==]
		---[==[等级礼包新手引导屏蔽层
			---------------------新手引导---------------------------------
			--add by licong 2013.09.09
			require "script/guide/NewGuide"
			if(NewGuide.guideClass == ksGuideFiveLevelGift) then
				require "script/guide/LevelGiftBagGuide"
				LevelGiftBagGuide.changLayer()
			end
			---------------------end-------------------------------------
		--]==]

		---[==[副本箱子 新手引导屏蔽层
		---------------------新手引导---------------------------------
			--add by licong 2013.09.11
			require "script/guide/NewGuide"
			if(NewGuide.guideClass ==  ksGuideCopyBox) then
				require "script/guide/CopyBoxGuide"
				CopyBoxGuide.changLayer()
			end
		---------------------end-------------------------------------
		--]==]
		
		if not DataCache.getSwitchNodeState(ksSwitchShop) then
			return
		end

		if(MainScene.getOnRunningLayerSign()== "shopLayer") then
			return
		end
		require "script/ui/shop/ShopLayer"
		local  shopLayer = ShopLayer.createLayer()
		MainScene.changeLayer(shopLayer, "shopLayer", ShopLayer.layerWillDisappearDelegate)

		-- 5级等级礼包断点重进并且点击了招募神将按钮,show第6步
		require "script/guide/NewGuide"
		if(NewGuide.guideClass == ksGuideFiveLevelGift)then
			if(NewGuide.isBackFiveGiftGuide == true and NewGuide.getFiveLevelClick()) then
				local levelGiftBagGuide_button = PubLayer.getGuideObject()
	       	 	local touchRect = getSpriteScreenRect(levelGiftBagGuide_button)
	        	LevelGiftBagGuide.show(5, touchRect)
			end
		end
		-- --10级等级礼包断点重进并且点击了招募神将按钮，则跳过第5步
		-- if(NewGuide.guideClass == ksGuideTenLevelGift)then
	 --        if(NewGuide.isBackTenGiftGuide == true and NewGuide.getTenLevelClick()) then
	 --            TenLevelGiftGuide.cleanLayer()
	 --            -- TenLevelGiftGuide.stepNum = 5
	 --        end
	 --    end
		---[==[ 第5步等级礼包 招将
			---------------------新手引导---------------------------------
		    --add by licong 2013.09.09
			require "script/ui/shop/PubLayer"
		    local didCreateShop = function ( ... )
			    require "script/guide/NewGuide"
				print("g_guideClass = ", NewGuide.guideClass)
			    require "script/guide/LevelGiftBagGuide"
			    if(NewGuide.guideClass ==  ksGuideFiveLevelGift and LevelGiftBagGuide.stepNum == 4) then
		        	local levelGiftBagGuide_button = PubLayer.getGuideObject()
		       	 	local touchRect = getSpriteScreenRect(levelGiftBagGuide_button)
		        	LevelGiftBagGuide.show(5, touchRect)
		        	LevelGiftBagGuide.stepNum = 7
			    end
			end
			PubLayer.registerDidCreateShopCallBack(didCreateShop)
			---------------------end-------------------------------------
		--]==]

		addLevelGiftGuide()


    elseif(tag == 1006) then
		if(mainMenu6stCallback ~= nil) then
			mainMenu6stCallback()
		end
		require "script/ui/bag/BagLayer"
		local bagLayer = BagLayer.createLayer()
		MainScene.changeLayer(bagLayer, "bagLayer")
	end
end

local function init ()
	local layer = CCLayer:create()
	
	_menu_bg = CCSprite:create("images/main/menu/menu_bg.png")
	local point = CCPointMake(0.5, 0.5)
	layer:addChild(_menu_bg)
	local menuBar = CCMenu:create()
	menuBar:setPosition(0, 0)
    menuBar:setTouchPriority(-401)

	local tmpSprite = CCSprite:create(getMenuImageFullPath(menu_items[1]))
	local x_space = (_menu_bg:getContentSize().width - tmpSprite:getContentSize().width*(#menu_items))/#menu_items
	
	local spriteWidth = tmpSprite:getContentSize().width
	local y = _menu_bg:getContentSize().height/2
	tmpSprite = nil

	-- 主页菜单项
	for i=1, #menu_items do
		-- 生成主页菜单项
		menu_item_objs[i] = CCMenuItemImage:create(getMenuImageFullPath(menu_items[i]), getMenuImageFullPath(menu_items[i], true))
		menu_item_objs[i]:setAnchorPoint(point)
		menu_item_objs[i]:setPositionX((x_space+spriteWidth)/2 + (x_space+spriteWidth)*(i-1))
		menu_item_objs[i]:setPositionY(y)
		menu_item_objs[i]:registerScriptTapHandler(menu_item_tap_handler)
		-- 添加主页菜单项
		menuBar:addChild(menu_item_objs[i], 0, 1000+i)

		-- 添加提示小图片
		addTipSprite(menu_item_objs[i], i)
	end

	layer:addChild(menuBar)
	local top_border = CCSprite:create("images/main/base_bottom_border.png")
	top_border:setPosition(0, y*2)
	layer:addChild(top_border)

	layer:setScale(g_fScaleX)
    
    local function menuLayerTouch( eventType, x, y )
        
        local menuPoint = _menu_bg:convertToNodeSpace(ccp(x,y))
        
        if (menuPoint.x>=0 and menuPoint.y>=0 and menuPoint.x<=_menu_bg:getContentSize().width and menuPoint.y<=_menu_bg:getContentSize().height) then
            return true
        else
            return false
        end
    end
    
    layer:setTouchEnabled(true)
    layer:registerScriptTouchHandler(menuLayerTouch,false,-400,true)

    layer:registerScriptHandler(function ( nodeType )
    	if(nodeType == "enter")then
	    	MenuLayer.refreshMenuItemTipSprite()
	    end
		if(nodeType == "exit") then
			GiftService.regirsterBuyVipGiftCb( nil )
		end
	end)
    
	return layer
end

-- 显示菜单栏
local function show ()
	if mod_status == ksModStatusHidden then
		menuLayer:setVisible(true)
		mod_status = ksModStatusShowed
	elseif mod_status == ksModStatusUninitialized then
		menuLayer = init()
		mod_status = ksModStatusShowed
	end
end

-- 隐藏菜单栏
local function hide ()
	if mod_status ~= ksModStatusShowed then
		return
	else
		menuLayer:setVisible (false)
		mod_status = ksModStatusHidden
	end
end

-- 退出该模块，释放相应资源
function release()
	MenuLayer = nil
	package.loaded["MenuLayer"] = nil
	package.loaded["script/ui/main/MenuLayer"] = nil
end

-- 设置菜单栏显示或隐藏
function setVisible(visible)
	if visible == true then
		show()
	else 
		hide()
	end
end

function getObject()
	return menuLayer
end
-- 获得菜单项各个项的对象
function getMenuItemNode(index)
	return menu_item_objs[index]
end

function getHeight( ... )
	if (_menu_bg ~= nil) then
		return _menu_bg:getContentSize().height*g_fScaleX
	end
end

function getLayerContentSize()
	return _menu_bg:getContentSize()
end

--得到实际显示大小
function getLayerFactSize( ... )
    local  size = getLayerContentSize()
    local  factSize = CCSizeMake(size.width * g_fScaleX, size.height * g_fScaleX)
    return factSize
end

-- 给按钮增加提示
function addTipSprite( item,i )
	require "script/model/DataCache"
	-- 商店时
	if(i==5) then
		local num = DataCache.getShopGiftForFree()
		print("getShopGiftForFree    is : ", num)
		local tipSprite = getTipSpriteWithNum(num) 	
		tipSprite:setPosition(item:getContentSize().width*0.97, item:getContentSize().height*0.98)
		tipSprite:setAnchorPoint(ccp(1,1))
		item:addChild(tipSprite,1,i)	
		GiftService.regirsterBuyVipGiftCb(refreshMenuItemTipSprite)
	elseif(i==6)then
		-- 背包
		local num = PreRequest.getNewUseItemNum()
		require "script/utils/ItemDropUtil"
		local tipSprite = ItemDropUtil.getTipSpriteByNum(num)
		tipSprite:setPosition(item:getContentSize().width*0.97, item:getContentSize().height*0.98)
		tipSprite:setAnchorPoint(ccp(1,1))
		tipSprite:setVisible(false)
		item:addChild(tipSprite,1,i)	
	elseif(i==3)then
		-- 副本
		local num = DataCache.getEliteCopyLeftNum() + DataCache.getActiveCopyLeftNum()
		require "script/utils/ItemDropUtil"
		local tipSprite = getTipSpriteWithNum(num) 	
		tipSprite:setPosition(item:getContentSize().width*0.97, item:getContentSize().height*0.98)
		tipSprite:setAnchorPoint(ccp(1,1))
		tipSprite:setVisible(false)
		item:addChild(tipSprite,1,i)
	elseif(i==4)then
		-- 活动
		require "script/ui/tower/TowerCache"
		local num = TowerCache.getResetTowerTimes()
		local tipSprite = getTipSpriteWithNum(num)
		tipSprite:setPosition(item:getContentSize().width*0.97, item:getContentSize().height*0.98)
		tipSprite:setAnchorPoint(ccp(1,1))
		tipSprite:setVisible(false)
		item:addChild(tipSprite,1,i)
	elseif(i==2)then
		-- 阵容
		require "script/ui/formation/LittleFriendData"
		local isShow,b = LittleFriendData.getIsShowTipNewLittle()
		local num = nil
		if(isShow)then
			num = 1
		else
			num = 0
		end
		local tipSprite = getTipSpriteWithNum(num)
		tipSprite:setPosition(item:getContentSize().width*0.97, item:getContentSize().height*0.98)
		tipSprite:setAnchorPoint(ccp(1,1))
		tipSprite:setVisible(false)
		item:addChild(tipSprite,1,100)
	else
	end
end

-- 背包加入提示气泡
function refreshBagItemTip()
	local bagItem = menu_item_objs[6]

end

-- 创建提示sprite 
-- 参数num 为提示里的数字
function getTipSpriteWithNum(num  )
	require "script/ui/rechargeActive/ActiveCache"
	local tipSprite= CCSprite:create("images/common/tip_2.png")
	tipSprite:setAnchorPoint(ccp(1,1))
	tipSprite:setVisible(false)
	if(num>0) then
		tipSprite:setVisible(true)
	end

	return tipSprite
end

-- 刷新第I个按钮函数
function refreshMenuItemTipSprite()
	print("refresh   ===== ===== ==== = ===   ")
	local i=5
	local num = DataCache.getShopGiftForFree()
	local tipSprite = getMenuItemNode(i):getChildByTag(i)
	if(num>0 ) then
		tipSprite:setVisible(true)
	else
		tipSprite:setVisible(false)
	end

	-- 背包 add by chengliang 
	local bagTipSprite = getMenuItemNode(6):getChildByTag(6)
	local b_num = PreRequest.getNewUseItemNum()
	if(b_num>0 ) then
		bagTipSprite:setVisible(true)
		ItemDropUtil.refreshNum(bagTipSprite, b_num)
	else
		bagTipSprite:setVisible(false)
	end

	-- 副本
	local c_num = DataCache.getEliteCopyLeftNum() + DataCache.getActiveCopyLeftNum()
	local copyTipSprite = getMenuItemNode(3):getChildByTag(3)
	if(c_num>0 ) then
		copyTipSprite:setVisible(true)
	else
		copyTipSprite:setVisible(false)
	end

	-- 活动
	require "script/ui/tower/TowerCache"
	local num = TowerCache.getResetTowerTimes()
	local activeTipSprite = getMenuItemNode(4):getChildByTag(4)
	if(num>0 ) then
		activeTipSprite:setVisible(true)
	else
		activeTipSprite:setVisible(false)
	end
	
	-- 阵容
	require "script/ui/formation/LittleFriendData"
	local isShow,b = LittleFriendData.getIsShowTipNewLittle()
	local formationTipSprite = getMenuItemNode(2):getChildByTag(100)
	formationTipSprite:setVisible(isShow)
end



--add by lichenyang

function registerMainMenu1stCallback( p_callback )
 	mainMenu1stCallback = p_callback
 end 
function registerMainMenu2stCallback( p_callback )
 	mainMenu2stCallback = p_callback
 end 
function registerMainMenu3stCallback( p_callback )
 	mainMenu3stCallback = p_callback
 end 
function registerMainMenu4stCallback( p_callback )
 	mainMenu4stCallback = p_callback
 end 
function registerMainMenu5stCallback( p_callback )
 	mainMenu5stCallback = p_callback
 end 
function registerMainMenu6stCallback( p_callback )
 	mainMenu6stCallback = p_callback
 end 

function addLevelGiftGuide( ... )
	---[==[ 等级礼包第8步 
	---------------------新手引导---------------------------------
    --add by licong 2013.09.09
	require "script/ui/shop/HeroDisplayerLayer"
    local didGetHero = function ( ... )
	    require "script/guide/NewGuide"
		print("g_guideClass = ", NewGuide.guideClass)
	    require "script/guide/LevelGiftBagGuide"
	    if(NewGuide.guideClass ==  ksGuideFiveLevelGift and LevelGiftBagGuide.stepNum == 7) then
	        local levelGiftBagGuide_button = HeroDisplayerLayer.getGuideObject()
	        local touchRect = getSpriteScreenRect(levelGiftBagGuide_button)
	        LevelGiftBagGuide.show(8, touchRect)
	    end
	end
	HeroDisplayerLayer.registerDidGetHeroCallBack(didGetHero)
	---------------------end-------------------------------------
	--]==]
end

