-- Filename: ResolveSelectLayer.lua
-- Author: zhang zihang
-- Date: 2013-12-27
-- Purpose: 该文件用于: 炼化选择界面

module ("ResolveSelectLayer", package.seeall)

require "script/ui/main/MainScene"
require "script/ui/bag/EquipBagCell"

function init()
	_ksTagSure = 5001

	_ksTagChooseHero = 1001
	_ksTagChooseItem = 1002
	_ksTagChooseGood = 1003
	_ksTagChooseCloth = 1004
	_ksTagCheckBg = 3001
	_ksTagTableViewBg = 201

	_nSelectedCount = 0
	_nItemCount = 0

	--已选择武将数目栏
	_ccHeroCount = nil
	ccLabelSelected = nil
	_layerSize = nil
	layer = nil

	_menuHero = nil
	_menuItem = nil
	_menuGood = nil

	_whereILocate = nil
	_heroLayer = nil
	_itemLayer = nil
	_goodLayer = nil
	_clothLayer = nil

	tBottomSize = nil
	topMenuBar = nil
	bulletinLayerSize = nil
	_tParentParam = nil

	_arrSelectedHeroes = {}
	_arrSelectedItems = {}
	_arrSelectedGoods = {}
	_arrSelectedCloths = {}

	_arrSign = nil
	_arrViewLocation = nil

	_arrHeroesValue = nil
	_arrItemValue = nil

	_selectId = false

	_itemId = false

	_goodId = false

	_clothId = false
end

function fnHandlerOfClothTouched(clothMenu,curBox)
	local isIn = curBox.isSelected
	if(isIn == true) then
		clothMenu:unselected()
		curBox.isSelected = false
		_nItemCount = _nItemCount-1
		_clothId = true
	else
		if tonumber(_nItemCount) == 5 then
			clothMenu:unselected()
			AnimationTip.showTip(GetLocalizeStringBy("key_3164"))
		else 
			_clothId = true
			clothMenu:selected()
			curBox.isSelected = true
			_nItemCount = _nItemCount+1
		end
	end
	fnUpdateSelectionInfo(_nItemCount)
end

function fnHandlerOfItemTouched(itemMenu,curBox)
	local isIn = curBox.isSelected
	if(isIn == true) then
		itemMenu:unselected()
		curBox.isSelected = false
		_nItemCount = _nItemCount-1
		_itemId = true
	else
		--print("---------")
		--print_t(_tParentParam.filtersItem)
		-- for i = 1 ,#_tParentParam.filtersItem do
		-- 	local v = _tParentParam.filtersItem[i]
		-- 	if v.isSelected == true then
		-- 		local cellObject = tolua.cast(v.ccObj,"CCTableViewCell")
		-- 		if v and cellObject ~= nil then
		-- 			local cellBg = tolua.cast(cellObject:getChildByTag(1), "CCSprite")
		-- 			local menubar_m = tolua.cast(cellBg:getChildByTag(9898), "CCMenu")
		-- 			--print("+++++++++++++++",v.gid)
		-- 			local menuBtn_M = tolua.cast(menubar_m:getChildByTag(tonumber(v.gid)), "CCMenuItemSprite")
		-- 			menuBtn_M:unselected()
		-- 		end
		-- 		v.isSelected = false
		-- 		_nItemCount = _nItemCount-1
		-- 	end
		-- end
		if tonumber(_nItemCount) == 5 then
			itemMenu:unselected()
			AnimationTip.showTip(GetLocalizeStringBy("key_3124"))
		else 
			_itemId = true
			itemMenu:selected()
			curBox.isSelected = true
			_nItemCount = _nItemCount+1
		end
	end
	fnUpdateSelectionInfo(_nItemCount)
end

function fnHandlerOfGoodTouched(goodMenu,curBox)
	local isIn = curBox.isSelected
	if(isIn == true) then
		goodMenu:unselected()
		curBox.isSelected = false
		_nItemCount = _nItemCount-1
		_goodId = true
	else
		--print("---------")
		--print_t(_tParentParam.filtersItem)
		-- for i = 1 ,#_tParentParam.filtersGood do
		-- 	local v = _tParentParam.filtersGood[i]
		-- 	if v.isSelected == true then
		-- 		local cellObject = tolua.cast(v.ccObj,"CCTableViewCell")
		-- 		if v and cellObject ~= nil then
		-- 			local cellBg = tolua.cast(cellObject:getChildByTag(1), "CCSprite")
		-- 			local menubar_m = tolua.cast(cellBg:getChildByTag(9898), "CCMenu")
		-- 			--print("+++++++++++++++",v.gid)
		-- 			local menuBtn_M = tolua.cast(menubar_m:getChildByTag(tonumber(v.gid)), "CCMenuItemSprite")
		-- 			menuBtn_M:unselected()
		-- 		end
		-- 		v.isSelected = false
		-- 		_nItemCount = _nItemCount-1
		-- 	end
		-- end
		if tonumber(_nItemCount) == 5 then
			goodMenu:unselected()
			AnimationTip.showTip(GetLocalizeStringBy("key_3124"))
		else 
			_goodId = true
			goodMenu:selected()
			curBox.isSelected = true
			_nItemCount = _nItemCount+1
		end
	end
	fnUpdateSelectionInfo(_nItemCount)
end

function checkedItemAction(tag, itemMenu)
	for k,v in pairs(_tParentParam.filtersItem) do
		if tonumber(v.gid) == tonumber(itemMenu:getTag()) then
			fnHandlerOfItemTouched(itemMenu,v)
		end
	end
end

function checkedGoodAction(tag,goodMenu)
	for k,v in pairs(_tParentParam.filtersGood) do
		if tonumber(v.gid) == tonumber(goodMenu:getTag()) then
			fnHandlerOfGoodTouched(goodMenu,v)
		end
	end
end

function  checkedClothAction(tag,clothMenu)
	for k,v in pairs(_tParentParam.filtersCloth) do
		if tonumber(v.gid) == tonumber(clothMenu:getTag()) then
			fnHandlerOfClothTouched(clothMenu,v)
		end
	end
end

--武将列表更新底栏
function fnUpdateSelectionInfo(num)
	_ccHeroCount:setString(tostring(num) .. "/5")
end

--选中武将
function fnHandlerOfCellTouched(pIndex)
	local nIndex = #_arrHeroesValue - pIndex

	local ccCellObj = tolua.cast(_arrHeroesValue[nIndex].ccObj:getChildByTag(_ksTagTableViewBg), "CCSprite")
	local ccSpriteCheckBox = tolua.cast(ccCellObj:getChildByTag(10001), "CCSprite")
	local ccSpriteSelected =  tolua.cast(ccSpriteCheckBox:getChildByTag(10002), "CCSprite")

	if (_arrHeroesValue[nIndex].checkIsSelected == false) then
		print(GetLocalizeStringBy("key_2892"))
		print(_arrHeroesValue[nIndex].hid)
		print(_arrHeroesValue[nIndex].name)
		print("#####################################")
		--[[if _nSelectedCount >= 1 then
			require "script/ui/tip/AnimationTip"
			AnimationTip.showTip(GetLocalizeStringBy("key_1703"))
			return
		end]]
		-- for i = 1, #_arrHeroesValue do
		-- 	if _arrHeroesValue[i].checkIsSelected == true then
		-- 		print(GetLocalizeStringBy("key_2465"))
		-- 		print(_arrHeroesValue[i].hid)
		-- 		print(_arrHeroesValue[i].name)
		-- 		print("****************************************")

		-- 		local cellObject = tolua.cast(_arrHeroesValue[i].ccObj,"CCTableView")
		-- 		-- local cellSprite = _arrHeroesValue[i].ccObj:getChildByTag(_ksTagTableViewBg)
		-- 		if _arrHeroesValue[i] and  cellObject~= nil then
		-- 			local ccCellObj1 = tolua.cast(_arrHeroesValue[i].ccObj:getChildByTag(_ksTagTableViewBg), "CCSprite")
		-- 			local ccSpriteCheckBox1 = tolua.cast(ccCellObj1:getChildByTag(10001), "CCSprite")
		-- 			local ccSpriteSelected1 =  tolua.cast(ccSpriteCheckBox1:getChildByTag(10002), "CCSprite")
		-- 			ccSpriteSelected1:setVisible(false)
		-- 		end
		-- 		_arrHeroesValue[i].checkIsSelected = false
		-- 		_nSelectedCount = _nSelectedCount - 1
		-- 	end
		-- end
		if _nSelectedCount == 5 then
			AnimationTip.showTip(GetLocalizeStringBy("key_3027"))
		else
			_selectId = true
			_arrHeroesValue[nIndex].checkIsSelected = true
			ccSpriteSelected:setVisible(true)
			print(GetLocalizeStringBy("key_2051"),_nSelectedCount)
			_nSelectedCount = _nSelectedCount + 1
		end
	else
		_arrHeroesValue[nIndex].checkIsSelected = false
		ccSpriteSelected:setVisible(false)
		_nSelectedCount = _nSelectedCount - 1
		_selectId = true
	end
	fnUpdateSelectionInfo(_nSelectedCount)
end

function updateItemParentParam(a1,a2)
	_tParentParam.filtersItem[a1+1].ccObj = a2
end

function updateHeroValue(heroValue)
	_arrHeroesValue = heroValue
end

function updateGoodParentParam(a1,a2)
	_tParentParam.filtersGood[a1+1].ccObj = a2
end

function updateClothParentParam(a1,a2)
	_tParentParam.filtersCloth[a1+1].ccObj = a2
end

function createChooseHeroLayer()
	local nHeightOfBottom = (tBottomSize.height-12)*g_fScaleX
	local nHeightOfTitle = (topMenuBar:getContentSize().height-16)*g_fScaleX
	local _scrollview_height = g_winSize.height - bulletinLayerSize.height*g_fScaleX - nHeightOfBottom - nHeightOfTitle
	

	local cellHeight
	require "script/ui/recycle/HeroResolveCell"
	_heroLayer , cellHeight= HeroResolveCell.createHeroSellTableView(_arrSelectedHeroes,_tParentParam,layer:getContentSize().width,_scrollview_height)
	
	local i

	--_arrHeroesValue为createHeroSellTableView中得到选择武将列表后的过滤后的信息

	if _arrHeroesValue ~= nil then
		for i = 1,#_arrHeroesValue do
			if _arrHeroesValue[i].checkIsSelected == true then
				_nSelectedCount = _nSelectedCount + 1
				_ccHeroCount:setString(_nSelectedCount .. "/5")
			end
		end
	end

	local firstPos = 1
	if _arrHeroesValue ~= nil then
		for i = 1,#_arrHeroesValue do
			if _arrHeroesValue[i].checkIsSelected == true then
				firstPos = i
				break
			end
		end
	end
	
	_heroLayer:setPosition(0, nHeightOfBottom)
	_heroLayer:setContentOffset(ccp(0,_scrollview_height-(#_arrHeroesValue-firstPos+1)*cellHeight))
	_whereILocate = "heroView"
	layer:addChild(_heroLayer)
end

function createChooseItemLayer()
	local nHeightOfBottom = (tBottomSize.height-12)*g_fScaleX
	local nHeightOfTitle = (topMenuBar:getContentSize().height-16)*g_fScaleX
	local _scrollview_height = g_winSize.height - bulletinLayerSize.height*g_fScaleX - nHeightOfBottom - nHeightOfTitle
	local cellHeight
	require "script/ui/recycle/EquipResolveCell"
	_itemLayer , cellHeight= EquipResolveCell.createItemSellTableview(_tParentParam,layer:getContentSize().width,_scrollview_height)

	local i

	--_tParentParam.filtersItem为createLayer传入参数的装备的过滤信息

	local firstPos = 1
	if _tParentParam.filtersItem ~= nil then
		firstPos = #_tParentParam.filtersItem
		for i = 1,#_tParentParam.filtersItem do
			if _tParentParam.filtersItem[i].isSelected == true then
				firstPos = i
				_nItemCount = _nItemCount+1
				_ccHeroCount:setString(_nItemCount .. "/5")
			end
		end
	end

	_itemLayer:setPosition(0,nHeightOfBottom)
	_itemLayer:setContentOffset(ccp(0,_scrollview_height-(firstPos)*cellHeight))
	_whereILocate = "itemView"
	layer:addChild(_itemLayer)
end

function createChooseGoodLayer()
	local nHeightOfBottom = (tBottomSize.height-12)*g_fScaleX
	local nHeightOfTitle = (topMenuBar:getContentSize().height-16)*g_fScaleX
	local _scrollview_height = g_winSize.height - bulletinLayerSize.height*g_fScaleX - nHeightOfBottom - nHeightOfTitle
	local cellHeight
	require "script/ui/recycle/GoodResolveCell"
	_goodLayer ,cellHeight= GoodResolveCell.createGoodSellTableview(_tParentParam,layer:getContentSize().width,_scrollview_height)

	local i
	local firstPos = 1
	--_tParentParam.filtersGood为符合筛选的宝物信息
	if _tParentParam.filtersGood ~= nil then
		firstPos = #_tParentParam.filtersGood
		for i = 1,#_tParentParam.filtersGood do
			if _tParentParam.filtersGood[i].isSelected == true then
				firstPos = i
				_nItemCount = _nItemCount+1
				_ccHeroCount:setString(_nItemCount .. "/5")
			end
		end
	end

	_goodLayer:setPosition(0,nHeightOfBottom)
	_goodLayer:setContentOffset(ccp(0,_scrollview_height-(firstPos)*cellHeight))

	--whereILocate表示目前显示的是哪个界面
	_whereILocate = "goodView"
	layer:addChild(_goodLayer)
end

function createChooseClothLayer()
	local nHeightOfBottom = (tBottomSize.height-12)*g_fScaleX
	local nHeightOfTitle = (topMenuBar:getContentSize().height-16)*g_fScaleX
	local _scrollview_height = g_winSize.height - bulletinLayerSize.height*g_fScaleX - nHeightOfBottom - nHeightOfTitle
	local cellHeight
	require "script/ui/recycle/ClothResolveCell"
	_clothLayer,cellHeight = ClothResolveCell.createClothTableView(_tParentParam,layer:getContentSize().width,_scrollview_height)

	local i
	local firstPos = 1
	if _tParentParam.filtersCloth ~= nil then
		firstPos = #_tParentParam.filtersCloth
		for i = 1,#_tParentParam.filtersCloth do
			if _tParentParam.filtersCloth[i].isSelected == true then
				firstPos = i
				_nItemCount = _nItemCount+1
				_ccHeroCount:setString(_nItemCount .. "/5")
			end
		end
	end

	_clothLayer:setPosition(0,nHeightOfBottom)
	_clothLayer:setContentOffset(ccp(0,_scrollview_height-(firstPos)*cellHeight))

	_whereILocate = "clothView"
	layer:addChild(_clothLayer)
end

--切换武将、装备和宝物选择
function fnHandlerOfButtons(tag, obj)
	if tag == _ksTagChooseHero then
		AudioUtil.playEffect("audio/effect/changtiaoxing.mp3")
		_menuHero:selected()
		_menuItem:unselected()
		_menuGood:unselected()
		_menuCloth:unselected()
		--删除装备界面
		if _itemLayer ~= nil then
			_itemLayer:removeAllChildrenWithCleanup(true)
			layer:removeChild(_itemLayer,true)
			_itemLayer = nil
		end
		--删除宝物界面
		if _goodLayer ~= nil then
			print(GetLocalizeStringBy("key_2484"))
			_goodLayer:removeAllChildrenWithCleanup(true)
			layer:removeChild(_goodLayer,true)
			_goodLayer = nil
		end

		--删除时装界面
		if _clothLayer ~= nil then
			_clothLayer:removeAllChildrenWithCleanup(true)
			layer:removeChild(_clothLayer,true)
			_clothLayer = nil
		end
		--创建武将界面
		if _whereILocate ~= "heroView" then
			_selectId = false
			_nSelectedCount = 0
			_arrSelectedHeroes = {}
			local i
			if _arrHeroesValue ~= nil then
				for i = 1, #_arrHeroesValue do
					_arrHeroesValue[i].checkIsSelected = false
				end
			end
			createChooseHeroLayer()
			ccLabelSelected:setString(GetLocalizeStringBy("key_1529"))
			_ccHeroCount:setString("0/5")
			_whereILocate = "heroView"
		end
	elseif tag == _ksTagChooseItem then
		AudioUtil.playEffect("audio/effect/changtiaoxing.mp3")
		_menuItem:selected()
		_menuHero:unselected()
		_menuGood:unselected()
		_menuCloth:unselected()
		--删除武将界面
		if _heroLayer ~= nil then
			_heroLayer:removeAllChildrenWithCleanup(true)
			layer:removeChild(_heroLayer,true)
			_heroLayer = nil
		end
		--删除宝物界面
		if _goodLayer ~= nil then
			print(GetLocalizeStringBy("key_2484"))
			_goodLayer:removeAllChildrenWithCleanup(true)
			layer:removeChild(_goodLayer,true)
			_goodLayer = nil
		end

		--删除时装界面
		if _clothLayer ~= nil then
			_clothLayer:removeAllChildrenWithCleanup(true)
			layer:removeChild(_clothLayer,true)
			_clothLayer = nil
		end
		--创建装备界面
		if _whereILocate ~= "itemView" then
			local i
			_nItemCount = 0
			if _tParentParam.filtersItem ~= nil then
				for i = 1, #_tParentParam.filtersItem do
					_tParentParam.filtersItem[i].isSelected = false
				end
			end
			createChooseItemLayer()
			ccLabelSelected:setString(GetLocalizeStringBy("key_1351"))
			_ccHeroCount:setString("0/5")
			_whereILocate = "itemView"
		end
	elseif tag == _ksTagChooseGood then
		AudioUtil.playEffect("audio/effect/changtiaoxing.mp3")
		_menuGood:selected()
		_menuHero:unselected()
		_menuItem:unselected()
		_menuCloth:unselected()
		--删除武将界面
		if _heroLayer ~= nil then
			_heroLayer:removeAllChildrenWithCleanup(true)
			layer:removeChild(_heroLayer,true)
			_heroLayer = nil
		end
		--删除装备界面
		if _itemLayer ~= nil then
			_itemLayer:removeAllChildrenWithCleanup(true)
			layer:removeChild(_itemLayer,true)
			_itemLayer = nil
		end

		--删除时装界面
		if _clothLayer ~= nil then
			_clothLayer:removeAllChildrenWithCleanup(true)
			layer:removeChild(_clothLayer,true)
			_clothLayer = nil
		end

		--创建宝物界面
		if _whereILocate ~= "goodView" then
			local i
			_nItemCount = 0
			if _tParentParam.filtersGood ~= nil then
				for i = 1, #_tParentParam.filtersGood do
					_tParentParam.filtersGood[i].isSelected = false
				end
			end
			createChooseGoodLayer()
			ccLabelSelected:setString(GetLocalizeStringBy("key_1979"))
			_ccHeroCount:setString("0/5")
			_whereILocate = "goodView"
		end
	elseif tag == _ksTagChooseCloth then
		AudioUtil.playEffect("audio/effect/changtiaoxing.mp3")
		_menuCloth:selected()
		_menuHero:unselected()
		_menuItem:unselected()
		_menuGood:unselected()
		--删除武将界面
		if _heroLayer ~= nil then
			_heroLayer:removeAllChildrenWithCleanup(true)
			layer:removeChild(_heroLayer,true)
			_heroLayer = nil
		end
		--删除装备界面
		if _itemLayer ~= nil then
			_itemLayer:removeAllChildrenWithCleanup(true)
			layer:removeChild(_itemLayer,true)
			_itemLayer = nil
		end
		--删除宝物界面
		if _goodLayer ~= nil then
			_goodLayer:removeAllChildrenWithCleanup(true)
			layer:removeChild(_goodLayer,true)
			_goodLayer = nil
		end

		if _whereILocate ~= "clothView" then
			local isSelected
			_nItemCount = 0
			if _tParentParam.filtersCloth ~= nil then
				for i = 1,#_tParentParam.filtersCloth do
					_tParentParam.filtersCloth[i].isSelected = false
				end
			end
			createChooseClothLayer()
			ccLabelSelected:setString(GetLocalizeStringBy("key_2806"))
			_ccHeroCount:setString("0/5")
			_whereILocate = "clothView"
		end
	end
end

function fnHandlerOfClose()
	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/guanbi.mp3")
	require "script/ui/recycle/BreakDownLayer"
	require "script/ui/recycle/ResurrectLayer"
	local tArgs = {}
	if _whereILocate == "heroView" then
		tArgs.selectedHeroes = _arrSelectedHeroes
		tArgs.nowSit = "heroList"
	end
	if _whereILocate == "itemView" then
		tArgs.selectedHeroes = _arrSelectedItems
		tArgs.nowSit = "itemList"
	end
	if _whereILocate == "goodView" then
		tArgs.selectedHeroes = _arrSelectedGoods
		tArgs.nowSit = "goodList"
	end
	if _whereILocate == "clothView" then
		tArgs.selectedHeroes = _arrSelectedCloths
		tArgs.nowSit = "clothList"
	end
	tArgs.sign = _arrSign
	if _arrSign == "BreakDownLayer" then
		MainScene.changeLayer(BreakDownLayer.createLayerAfterSelectHero(tArgs), _tParentParam.sign)
	end
end

function createTitleLayer(layerRect)
	local tArgs = {}

	--待选择的项目标题
	--tag值见全局变量
	tArgs[1] = {text=GetLocalizeStringBy("key_1453"), x=-10, tag=_ksTagChooseHero, handler=fnHandlerOfButtons,normalN = "images/recycle/btn_title_h.png",normalH = "images/recycle/btn_title_n.png",nFontsize = 33}
	tArgs[2] = {text=GetLocalizeStringBy("key_2025"), x=125, tag=_ksTagChooseItem, handler=fnHandlerOfButtons,normalN = "images/recycle/btn_title_h.png",normalH = "images/recycle/btn_title_n.png",nFontsize = 33}
	tArgs[3] = {text=GetLocalizeStringBy("key_1848"), x=260, tag=_ksTagChooseGood, handler=fnHandlerOfButtons,normalN = "images/recycle/btn_title_h.png",normalH = "images/recycle/btn_title_n.png",nFontsize = 33}
	tArgs[4] = {text=GetLocalizeStringBy("key_2020"), x=395, tag=_ksTagChooseCloth, handler=fnHandlerOfButtons,normalN = "images/recycle/btn_title_h.png",normalH = "images/recycle/btn_title_n.png",nFontsize = 33}

	--创建主菜单
	require "script/libs/LuaCCSprite"
	topMenuBar = LuaCCSprite.createTitleBar(tArgs)
	topMenuBar:setAnchorPoint(ccp(0, 1))
	topMenuBar:setPosition(0, layerRect.height)
	topMenuBar:setScale(g_fScaleX)
	layer:addChild(topMenuBar)

	local tItems = {
		{normal="images/common/close_btn_n.png", highlighted="images/common/close_btn_h.png", pos_x=550, pos_y=20, cb=fnHandlerOfClose},
	}
	local menu = LuaCC.createMenuWithItems(tItems)
	menu:setPosition(ccp(0, 0))
	topMenuBar:addChild(menu)

	--获取分标签
	local topBottomMenu = tolua.cast(topMenuBar:getChildByTag(10001), "CCMenu")
	_menuHero = tolua.cast(topBottomMenu:getChildByTag(_ksTagChooseHero), "CCMenuItem")
	_menuItem = tolua.cast(topBottomMenu:getChildByTag(_ksTagChooseItem), "CCMenuItem")
	_menuGood = tolua.cast(topBottomMenu:getChildByTag(_ksTagChooseGood), "CCMenuItem")
	_menuCloth = tolua.cast(topBottomMenu:getChildByTag(_ksTagChooseCloth),"CCMenuItem")

	--对应选择不同的标题，创建不同的下拉列表界面
	--_arrViewLocation是createLayer中tParam.nowIn值
	if _arrViewLocation == "heroList" then
		_menuHero:selected()
		--创建选择武将界面
		createChooseHeroLayer()
	elseif _arrViewLocation == "itemList" then
		_menuItem:selected()
		createChooseItemLayer()
	elseif _arrViewLocation == "goodList" then
		_menuGood:selected()
		createChooseGoodLayer()
	elseif _arrViewLocation == "clothList" then
		_menuCloth:selected()
		createChooseClothLayer()
	end
end

function fnHandlerOfReturn(tag, item_obj)
	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/guanbi.mp3")
	require "script/ui/recycle/BreakDownLayer"
	if _whereILocate == "heroView" then
		local tArgs = {}
		tArgs.sign = _arrSign
		tArgs.nowSit = "heroList"
		if _nSelectedCount ~= 0 then
			if _selectId == false then
				tArgs.selectedHeroes = _arrSelectedHeroes
			else
				local heroValueTable = {}
				for i = 1,#_arrHeroesValue do
					if _arrHeroesValue[i].checkIsSelected == true then
						table.insert(heroValueTable,_arrHeroesValue[i])
					end
				end
				tArgs.selectedHeroes = heroValueTable
			end
		else
			tArgs.selectedHeroes = {}
		end
		if _arrSign == "BreakDownLayer" then
			MainScene.changeLayer(BreakDownLayer.createLayerAfterSelectHero(tArgs), _tParentParam.sign)
		end
	end
	if _whereILocate == "itemView" then
		local tArgs = {}
		tArgs.sign = _arrSign
		tArgs.nowSit = "itemList"
		if _nItemCount ~= 0 then
			if _itemId == false then
				tArgs.selectedHeroes = _arrSelectedItems
			else
				local allItemTable = {}
				for i = 1,#_tParentParam.filtersItem do
					if _tParentParam.filtersItem[i].isSelected == true then
						table.insert(allItemTable,_tParentParam.filtersItem[i])
						print("ZZZHHH")
						print_t(_tParentParam.filtersItem[i])
					end
				end
				tArgs.selectedHeroes = allItemTable
			end
		else
			tArgs.selectedHeroes = {}
		end
		if _arrSign == "BreakDownLayer" then
			MainScene.changeLayer(BreakDownLayer.createLayerAfterSelectHero(tArgs), _tParentParam.sign)
		end
	end
	if _whereILocate == "goodView" then
		local tArgs = {}
		tArgs.sign = _arrSign
		tArgs.nowSit = "goodList"
		if _nItemCount ~= 0 then
			if _goodId == false then
				tArgs.selectedHeroes = _arrSelectedGoods
			else
				local allGoodTable = {}
				for i = 1,#_tParentParam.filtersGood do
					if _tParentParam.filtersGood[i].isSelected == true then
						table.insert(allGoodTable,_tParentParam.filtersGood[i])
						print_t(_tParentParam.filtersGood[i])
					end
				end
				tArgs.selectedHeroes = allGoodTable
			end
		else
			tArgs.selectedHeroes = {}
		end
		if _arrSign == "BreakDownLayer" then
			MainScene.changeLayer(BreakDownLayer.createLayerAfterSelectHero(tArgs), _tParentParam.sign)
		end
	end
	if _whereILocate == "clothView" then
		print("clothView")
		print_t(_tParentParam.filtersCloth)
		local tArgs = {}
		tArgs.sign = _arrSign
		tArgs.nowSit = "clothList"
		print("_nItemCount,_clothId",_nItemCount,_clothId)
		if _nItemCount ~= 0 then
			if _clothId == false then
				tArgs.selectedHeroes = _arrSelectedCloths
			else
				local allClothTable = {}
				for i = 1,#_tParentParam.filtersCloth do
					if _tParentParam.filtersCloth[i].isSelected == true then
						table.insert(allClothTable,_tParentParam.filtersCloth[i])
					end
				end
				tArgs.selectedHeroes = allClothTable
			end
		else
			tArgs.selectedHeroes = {}
		end
		print("tArgs是啥")
		print_t(tArgs)
		if _arrSign == "BreakDownLayer" then
			MainScene.changeLayer(BreakDownLayer.createLayerAfterSelectHero(tArgs),_tParentParam.sign)

		end
	end
end

function createBottomPanel()
	-- 背景
	local bg = CCSprite:create("images/common/sell_bottom.png")
	bg:setScale(g_fScaleX)

	if _tParentParam.nowIn == "heroList" then
		ccLabelSelected = CCLabelTTF:create (GetLocalizeStringBy("key_1529"), g_sFontName, 25)
	end
	if _tParentParam.nowIn == "itemList" then
		ccLabelSelected = CCLabelTTF:create (GetLocalizeStringBy("key_1351"), g_sFontName, 25)
	end
	if _tParentParam.nowIn == "goodList" then
		ccLabelSelected = CCLabelTTF:create (GetLocalizeStringBy("key_1979"), g_sFontName, 25)
	end 
	if _tParentParam.nowIn == "clothList" then
		ccLabelSelected = CCLabelTTF:create (GetLocalizeStringBy("key_2806"), g_sFontName, 25)
	end

	-- 已选择武将(label)
	--ccLabelSelected = CCLabelTTF:create (GetLocalizeStringBy("key_1529"), g_sFontName, 25)
	ccLabelSelected:setAnchorPoint(ccp(1,0))
	ccLabelSelected:setPosition(ccp(bg:getContentSize().width/2, 26))
	bg:addChild(ccLabelSelected)

	-- 出售英雄个数背景(9宫格)
	local fullRect = CCRectMake(0, 0, 34, 32)
	local insetRect = CCRectMake(12, 12, 10, 6)
	local ccHeroNumberBG = CCScale9Sprite:create("images/common/checkbg.png", fullRect, insetRect)
	ccHeroNumberBG:setPreferredSize(CCSizeMake(70, 36))
	ccHeroNumberBG:setAnchorPoint(ccp(1,0))
	ccHeroNumberBG:setPosition(ccp(ccLabelSelected:getContentSize().width+ccLabelSelected:getPositionX()-60, ccLabelSelected:getPositionY()))
	bg:addChild(ccHeroNumberBG)
	-- 已选择英雄个数
	_ccHeroCount = CCLabelTTF:create ("0/1", g_sFontName, 25, CCSizeMake(70, 36), kCCTextAlignmentCenter, kCCVerticalTextAlignmentBottom)
	_ccHeroCount:setAnchorPoint(ccp(1,0))
	_ccHeroCount:setPosition(ccHeroNumberBG:getPositionX(), ccHeroNumberBG:getPositionY()+2)
	bg:addChild(_ccHeroCount)

	-- 确定按钮
	local menu = CCMenu:create()
	menu:setTouchPriority(-403)
	local cmiiSure = CCMenuItemImage:create("images/tip/btn_confirm_n.png", "images/tip/btn_confirm_h.png")
	--_cmiiSureButton = cmiiSure
	cmiiSure:registerScriptTapHandler(fnHandlerOfReturn)
	menu:addChild(cmiiSure, 0, _ksTagSure)
	menu:setPosition(ccp(504, 10))
	bg:addChild(menu)

	return bg
end

function createLayer(tParam)
	init()

	--判断目前在哪个选择界面
	_tParentParam = tParam

	--_tParentParam.selected为选中的项目

	if _tParentParam.nowIn == "heroList" then
		_arrSelectedHeroes = _tParentParam.selected
	end
	if _tParentParam.nowIn == "itemList" then
		_arrSelectedItems = _tParentParam.selected
	end
	if _tParentParam.nowIn == "goodList" then
		_arrSelectedGoods = _tParentParam.selected
	end 
	if _tParentParam.nowIn == "clothList" then
		_arrSelectedCloths = _tParentParam.selected
	end
	_arrSign = _tParentParam.sign

	--用于判断在哪个界面，创建对应的选择列表
	_arrViewLocation = _tParentParam.nowIn

	print("HHYY")
	print_t(_tParentParam.filtersItem)
	layer = CCLayer:create()
	-- 加载模块背景图
	local bg = CCSprite:create("images/main/module_bg.png")
	bg:setScale(g_fBgScaleRatio)
	layer:addChild(bg)

	_layerSize = layer:getContentSize()

	require "script/ui/main/BulletinLayer"
	require "script/ui/main/MenuLayer"
	bulletinLayerSize = BulletinLayer.getLayerContentSize()
	MenuLayer.getObject():setVisible(false)

	--底层框
	local ccBottomPanel = createBottomPanel()
	layer:addChild(ccBottomPanel)

	local ccObjAvatar = MainScene.getAvatarLayerObj()
	ccObjAvatar:setVisible(false)

	local layerRect = {}
	layerRect.width = g_winSize.width
	layerRect.height = g_winSize.height - bulletinLayerSize.height*g_fScaleX
	layer:setContentSize(CCSizeMake(g_winSize.width, layerRect.height))

	tBottomSize = ccBottomPanel:getContentSize()

	--创建选择项目标题栏
	createTitleLayer(layerRect)

	return layer
end

function getFastHeroList(tParam)
	require "script/model/hero/HeroModel"
	require "db/DB_Heroes"
	local hids = HeroModel.getAllHeroesHid()
	local heroesValue = {}

	for i=1, #hids do
		-- 去除需要过滤的武将们
		local bIsFiltered = false
		if tParam.filters then
			for k=1, #tParam.filters do
				if tParam.filters[k] == hids[i] then
					bIsFiltered = true
					break
				end
			end 
		end
		--如果符合条件
		if not bIsFiltered then
			local value = {}
			value.hid = hids[i]
			value.isBusy=false
			local hero = HeroModel.getHeroByHid(value.hid)
			value.htid = hero.htid
			value.level = hero.level
			value.evolve_level = hero.evolve_level

			local db_hero = DB_Heroes.getDataById(value.htid)
			value.country_icon = HeroModel.getCiconByCidAndlevel(db_hero.country, db_hero.star_lv)
			value.name = db_hero.name

			value.star_lv = db_hero.star_lv
			value.head_icon = "images/base/hero/head_icon/" .. db_hero.head_icon_id
			value.quality_bg = "images/hero/quality/"..value.star_lv .. ".png"
			value.quality_h = "images/hero/quality/highlighted.png"

			value.withoutExp = true
			value.heroQuality = db_hero.heroQuality
			value.type = "HeroSelect"

			-- 判断是否默认为选中
			local bIsSelected = false
			--[[if tParam.selected then
				for k=1, #tParam.selected do
					if tParam.selected[k] == hids[i] then
						bIsSelected = true
						break
					end
				end 
			end]]
			value.checkIsSelected = bIsSelected
			value.menu_tag = _ksTagTableViewMenu
			value.tag_bg = _ksTagTableViewBg
			--value.fight_value = HeroFightForce.getAllForceValues(value).fightForce
			heroesValue[#heroesValue+1] = value
		end
	end

	-- 按战斗力值排序
	-- local function sort(w1, w2)
	-- 	if tonumber(w1.star_lv) < tonumber(w2.star_lv) then
	-- 		return true
	-- 	elseif tonumber(w1.star_lv) == tonumber(w2.star_lv) then
	-- 		if tonumber(w1.level) < tonumber(w2.level) then
	-- 			return true
	-- 		else 
	-- 			return false 
	-- 		end
	-- 	else 
	-- 		return false
	-- 	end
	-- 	--return w1.star_lv < w2.star_lv
	-- end

	-- table.sort(heroesValue, sort)
	require "script/ui/hero/HeroSort"
	heroesValue = HeroSort.sortForHeroList(heroesValue)
	local newTable = {}
	for i = #heroesValue,1,-1 do
		table.insert(newTable,heroesValue[i])
	end
	return newTable
end
