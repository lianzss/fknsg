-- Filename：	BagLayer.lua
-- Author：		Cheng Liang
-- Date：		2013-7-10
-- Purpose：		背包入口

module ("BagLayer", package.seeall)

require "script/network/RequestCenter"
require "script/model/DataCache"
require "script/ui/bag/ItemCell"
require "script/ui/bag/EquipBagCell"
require "script/ui/bag/TreasBagCell"
require "script/ui/bag/FashionCell"


require "script/ui/tip/AnimationTip"
require "script/ui/main/MainScene"
require "script/ui/item/ItemUtil"
require "script/utils/LuaUtil"
require "script/ui/bag/BagUtil"
require "script/model/user/UserModel"
require "script/ui/tip/AlertTip"
require "script/ui/bag/UseItemLayer"


Tag_Init_Props  = 10001
Tag_Init_Arming = 10002
Tag_Init_Treas	= 10003
Tag_Init_ArmFrag= 10004
Tag_Init_Dress	= 10005


Type_Bag_Arm_Frag	= 250
Type_Bag_Prop_Treas	= 251

local _initTag = nil

local IMG_PATH = "images/common/"	

local bgLayer 
local myTableView 
		
local title_item = {GetLocalizeStringBy("key_1870"), GetLocalizeStringBy("key_2025")}

local menu 										-- 按钮Menu

local toolsMenuItem								-- 道具按钮
local equipMenuItem 							-- 装备按钮
local treasMenuItem								-- 宝物按钮
local armFragMenuItem = nil						-- 装备碎片按钮
local dressMenuItem = nil 						-- 时装按钮

local expandBtn									-- 扩充按钮
local sellBtn									-- 出售按钮

local curMenuItem  								-- 当前按钮

local whichSell = nil							-- 判断哪类的卖出

local curData = {} 								-- 背包的数据源


local visiableCellNum							--当前机型可视的cell个数

local bagInfo = nil

-------------- 使用 -----------------
local curUseItemTempID 		= nil				-- 使用物品的ID
local curUseItemNum 		= nil				-- 使用物品的个数 
local curUseItemGid 		= nil				-- 使用物品的GID
local curUserItemInfo 		= nil				-- 当前使用物品的详细信息

--------------  出售 -----------------
local _sellEquipList 		= nil				-- 选择出售物品的列表 
local _sellBottomSprite 	= nil				-- 出售时的底部背景 

local _itemNumLabel 		= nil 				-- 出售的数量
local _itemTotalCoinLabel 	= nil				-- 总获得


local middleSellMenuBar		= nil				-- 出售时的按钮Bar

local isNeedAnimation 		= true 				-- 是否需要cell动画 

local itemNumbersSprite 	= nil 				-- 装备个数
local btnFrameSp			= nil

local _useItemTableViewOffset = nil

local _bag_type 			= nil 				-- 是他妈的哪个背包

local _lastOffset	 		= 0 				--上次的偏移量

--------------- 星级出售 ----------------------------------------
-- 按星级出售层tag
local _ksTagLayerStarSell = 5001
-- 星级出售tag
local _ksTagStarLevelSell = 6001
-- 星级出售面板GetLocalizeStringBy("key_1284")按钮tag
local _ksTagStarSellPanelCloseBtn = 7001
-- 星级出售面板“取消选择”按钮tag
local _ksTagStarSellPanelSelectAll = 7002
-- 星级出售面板“选择全部”按钮tag
local _ksTagStarSellPanelCancel = 7003
-- 星级出售面板“确定”按钮tag
local _ksTagStarSellPanelSure = 7004
-- 星级出售面板菜单tag
local _ksTagStarSellPanelMenu = 8001
-- 全部选择按钮
local _ccButtonSelectAll  = nil
-- 取消选择按钮
local _ccButtonCancel  = nil
-- 按星级出售菜单上的menu
local _ccMenuStarSell	= nil
-- 按星级出售按钮
local starSellBtn = nil
--------------------------------------------
local _tipSprite      = nil        -- 装备碎片标签提示数字
local _tipNum         = 0 		   -- 提示数字	

local _f_tableView_offset = 1

local _curLoc = 0 		--当前使用物品的位置（为防止点击时滑动） add by zhangzihang
local _curLen = 0

-- 增加GetLocalizeStringBy("key_2314")提示
function addBringSprite()
	-- 物品个数背景
    itemNumbersSprite = CCScale9Sprite:create("images/common/bgng_lefttimes.png", CCRectMake(0,0,33,33), CCRectMake(20,8,5,1))
    
    itemNumbersSprite:setAnchorPoint(ccp(0.5, 0))
    itemNumbersSprite:setPosition(bgLayer:getContentSize().width/2, bgLayer:getContentSize().height*0.015)
    
    bgLayer:addChild(itemNumbersSprite, 2)

    -- 携带数标题：
    local bringNumLabel = CCRenderLabel:create(GetLocalizeStringBy("key_1838"), g_sFontName, 24, 1, ccc3(0, 0, 0), type_stroke)
    bringNumLabel:setAnchorPoint(ccp(0.5, 0.5))
    local hOffset = 6
    local tSizeOfText = bringNumLabel:getContentSize()
    bringNumLabel:setPosition(tSizeOfText.width/2+hOffset, itemNumbersSprite:getContentSize().height/2-1)
    itemNumbersSprite:addChild(bringNumLabel)

    local allBagInfo = DataCache.getRemoteBagInfo()
    local bagInfo = DataCache.getBagInfo()
    local displayNum = 0
    if(curMenuItem == toolsMenuItem) then
    	displayNum = #curData .. "/" .. allBagInfo.gridMaxNum.props
    elseif(curMenuItem == equipMenuItem) then
    	local bagArm = bagInfo.arm
    	local length = 0
    	if( not table.isEmpty(bagArm) )then
    		length = #bagArm
    	end
    	displayNum = length .. "/" .. allBagInfo.gridMaxNum.arm
    elseif(curMenuItem == treasMenuItem)then

    	local bagTreas = bagInfo.treas
    	local length = 0
    	if( not table.isEmpty(bagTreas) )then
    		length = #bagTreas
    	end
    	displayNum = length .. "/" .. allBagInfo.gridMaxNum.treas
    elseif(curMenuItem == armFragMenuItem)then
    	local bagArmFrag = bagInfo.armFrag
    	local length = 0
    	if( not table.isEmpty(bagArmFrag) )then
    		length = #bagArmFrag
    	end
    	displayNum = length .. "/" .. allBagInfo.gridMaxNum.armFrag
    elseif(curMenuItem == dressMenuItem)then
    	local bagDress = bagInfo.dress
    	local length = 0
    	if( not table.isEmpty(bagDress) )then
    		length = #bagDress
    	end
    	displayNum = length .. "/" .. allBagInfo.gridMaxNum.dress
    end
    -- 携带数数据：
    local numLabel = CCRenderLabel:create(displayNum, g_sFontName, 24, 1, ccc3(0, 0, 0), type_stroke)
    numLabel:setColor(ccc3(0x36, 255, 0))
    numLabel:setAnchorPoint(ccp(0.5, 0.5))
    local tSizeOfNum = numLabel:getContentSize()
    local x = tSizeOfText.width + hOffset + tSizeOfNum.width/2
    numLabel:setPosition(x-10, itemNumbersSprite:getContentSize().height/2-2)
    itemNumbersSprite:addChild(numLabel)

    local nWidth = x + tSizeOfNum.width/2
	
    itemNumbersSprite:setPreferredSize(CCSizeMake(nWidth, 33))
    -- itemNumbersSprite:setScale(g_fScaleX)
end

-- 物品个数
function createItemNumbersSprite( ... )
	if(itemNumbersSprite)then
		itemNumbersSprite:removeFromParentAndCleanup(true)
		itemNumbersSprite = nil
	end
	addBringSprite()
end 


-- 添加出售列表
local function checkedSellCell( gid )

	local isIn = false
	local sellList = BagLayer.getSellEquipList()
	if ( table.isEmpty(sellList) ) then
		sellList = {}
		table.insert(sellList, gid)
	else
		
		local index = -1
		for k,g_id in pairs(sellList) do
			if ( tonumber(g_id) == tonumber(gid) ) then
				isIn = true
				index = k
				break
			end
		end
		if (isIn) then
			table.remove(sellList, index)
		else
			table.insert(sellList, gid)
		end
	end
	BagLayer.setSellEquipList(sellList)
	return isIn
end

--[[
	@desc   背包tableView的创建
	@para 	none
	@return void
--]]
local function createBagTableView( ... )
	if(itemNumbersSprite)then
		itemNumbersSprite:removeFromParentAndCleanup(true)
		itemNumbersSprite = nil
	end
	if(curMenuItem == toolsMenuItem or curMenuItem == equipMenuItem or curMenuItem == treasMenuItem or curMenuItem == armFragMenuItem or curMenuItem == dressMenuItem ) then
		createItemNumbersSprite()
	end
	local cellBg = CCSprite:create("images/bag/item/item_cellbg.png")
	cellSize = cellBg:getContentSize()			--计算cell大小

    local myScale = bgLayer:getContentSize().width/cellBg:getContentSize().width/bgLayer:getElementScale()
    

	visiableCellNum = math.floor(bgLayer:getContentSize().height*0.885/bgLayer:getElementScale() /cellSize.height) + 1 --计算可视的有几个cell
	
	local h = LuaEventHandler:create(function(fn, table, a1, a2) 	--创建
		local r
		if fn == "cellSize" then
			r = CCSizeMake(cellSize.width*myScale, cellSize.height*myScale)
		elseif fn == "cellAtIndex" then
			-- if not a2 then
			if (curMenuItem == toolsMenuItem)then	
                a2 = ItemCell.createItemCell(curData[a1 + 1], false, useItemAction,refreshMyTableView)
            elseif (curMenuItem == armFragMenuItem)then	
                a2 = ItemCell.createItemCell(curData[a1 + 1], false, useItemAction, refreshMyTableView)
            elseif (curMenuItem == equipMenuItem) then
            	a2 = EquipBagCell.createEquipCell(curData[a1 + 1], false, refreshMyTableView)
            elseif (curMenuItem == treasMenuItem) then
            	a2 = TreasBagCell.createTreasCell(curData[a1 + 1], false, refreshMyTableView)
            elseif (curMenuItem == dressMenuItem) then
            	a2 = FashionCell.createFashionCell(curData[a1 + 1], false, refreshMyTableView)
        	elseif (curMenuItem == sellBtn) then
        		if(whichSell == 1)then
        			-- print("11111")
        			a2 = ItemCell.createItemCell(curData[a1 + 1], true, nil,refreshMyTableView)
        		elseif(whichSell == 2)then
        			-- print("22222")
        			a2 = EquipBagCell.createEquipCell(curData[a1 + 1], true, refreshMyTableView)
        		elseif(whichSell == 3)then
        			-- print("22222")
        			a2 = TreasBagCell.createTreasCell(curData[a1 + 1], true, refreshMyTableView)
        		elseif(whichSell == 4)then
        			-- print("22222")
        			a2 = ItemCell.createItemCell(curData[a1 + 1], true, nil,refreshMyTableView)
        		elseif(whichSell == 5)then
        			-- print("22222")
            		a2 = FashionCell.createFashionCell(curData[a1 + 1], false,refreshMyTableView)
        		end
        	end
            a2:setScale(myScale)
   --          else
   --          	ItemCell.setCellValue( a2, curData[a1 + 1])
			-- end
			r = a2
		elseif fn == "numberOfCells" then
			r = #curData
		elseif fn == "cellTouched" then
			
			if (curMenuItem == sellBtn) then
				local m_data = curData[a1:getIdx()+1]

				local cellBg = tolua.cast(a1:getChildByTag(1), "CCSprite")
				local menubar_m = tolua.cast(cellBg:getChildByTag(9898), "CCMenu")
				local menuBtn_M = tolua.cast(menubar_m:getChildByTag(tonumber(m_data.gid)), "CCMenuItemSprite")
				
				local isIn = checkedSellCell(tonumber(m_data.gid))
				if(isIn == true) then
					menuBtn_M:unselected()
				else
					menuBtn_M:selected()
				end
			end
		elseif (fn == "scroll") then
			
		end
		return r
	end)
	myTableView = LuaTableView:createWithHandler(h, CCSizeMake(bgLayer:getContentSize().width/bgLayer:getElementScale(),bgLayer:getContentSize().height*0.885/bgLayer:getElementScale()))
    myTableView:setAnchorPoint(ccp(0,0))
    print(GetLocalizeStringBy("key_1253"),myTableView:getContentOffset().y)
	myTableView:setBounceable(true)
	-- myTableView:setVerticalFillOrder(kCCTableViewFillTopDown)
	bgLayer:addChild(myTableView)

	local maxAnimateIndex = visiableCellNum
	if (visiableCellNum > #curData) then
		maxAnimateIndex = #curData
	end
	for i=1, maxAnimateIndex do
		local itemCell = myTableView:cellAtIndex( #curData -i )
		if (itemCell) then
			ItemCell.startItemCellAnimate(itemCell, i)
		end
	end
end


-- 获得准备出售的装备列表
function  getSellEquipList( )
	return _sellEquipList
end

-- 设置准备出售的装备列表
function setSellEquipList( sellList )
	-- print_table("sellList", sellList)
	-- print("sellList:")
	-- print_t(sellList)
	_sellEquipList = sellList

	local totalNumber = 0
	local totalPrice = 0
	if (table.isEmpty(_sellEquipList) == false) then
		for k,g_id in pairs(_sellEquipList) do
			for k,m_data in pairs(curData) do
				if(tonumber(m_data.gid) == tonumber(g_id)) then
					totalNumber = totalNumber +1
					totalPrice = totalPrice + getPriceByEquipData(m_data) * tonumber(m_data.item_num)
					break
				end
			end
		end
	end
	print("totalNumber--------",totalNumber,"totalPrice-------",totalPrice)
	_itemNumLabel:setString(totalNumber)
	_itemTotalCoinLabel:setString(totalPrice)
	-- myTableView:reloadData()
end

function getPriceByEquipData( equip_data )
	-- print(GetLocalizeStringBy("key_2210"))
	-- print_t(equip_data)
	local price = 0
	if(whichSell == 1)then
		price = tonumber(equip_data.itemDesc.sell_num)
		-- print("price",price)
	elseif(whichSell == 2)then
		price = tonumber(equip_data.itemDesc.sellNum)
		-- 获取强化相关数值
		-- if( not table.isEmpty(equip_data.va_item_text) and equip_data.va_item_text.armReinforceLevel and tonumber(equip_data.va_item_text.armReinforceLevel)>0)then
		-- 	local fee_id = "" .. equip_data.itemDesc.quality .. equip_data.itemDesc.type
		-- 	require "db/DB_Reinforce_fee"
		-- 	local fee_data = DB_Reinforce_fee.getDataById( tonumber(fee_id) )
		-- 	local enhanceLevel = tonumber(equip_data.va_item_text.armReinforceLevel)
		-- 	for i=1, enhanceLevel do
		-- 		price = price + fee_data["coin_lv" .. (i)]*0.2
		-- 	end
		-- end
		if( not table.isEmpty(equip_data.va_item_text) and equip_data.va_item_text.armReinforceCost )then
			
			price = price + tonumber(equip_data.va_item_text.armReinforceCost)
		end
	elseif(whichSell == 3)then
		price = tonumber(equip_data.itemDesc.sellNum)
	elseif(whichSell == 4)then
		price = tonumber(equip_data.itemDesc.sell_num)
	elseif(whichSell == 5)then
		price = tonumber(equip_data.itemDesc.sell_num)
	end


	return tonumber(price)
end

-- 出售的回调
function sellActionCallback( cbFlag, dictData, bRet )
	if (dictData.err == "ok") then
		local coinStr = _itemTotalCoinLabel:getString()
		AnimationTip.showTip(GetLocalizeStringBy("key_1675") .. coinStr)
		UserModel.addSilverNumber(tonumber(coinStr))
		-- for k,i_gid in pairs(_sellEquipList) do
		-- 	ItemUtil.reduceItemByGid(i_gid,nil,true)
		-- end
		setSellEquipList(nil)
	end
end

-- 刷新Tableview
function refreshMyTableView()
	--  当前不是出售按钮时
	if(curMenuItem ~= sellBtn)then
		MainScene.setMainSceneViewsVisible(true,true,true)
	end
	
	if (curMenuItem == toolsMenuItem or curMenuItem == equipMenuItem or curMenuItem == treasMenuItem or curMenuItem == armFragMenuItem or curMenuItem == dressMenuItem) then
		if(myTableView)then
			local contentOffset = myTableView:getContentOffset() 
			-- print("老数据")
			-- print_t(curData)
			-- print("旧位移",contentOffset.y)
			myTableView:reloadData()
			local t_contentOffset = myTableView:getContentOffset() 
			-- print("新位移",t_contentOffset.y)
			-- print("原来长度",_curLen)
			-- print("现在长度",#curData)
			-- print("原来位置",_curLoc)
			-- print("t_contentOffset==", contentOffset.x, t_contentOffset.y, myTableView:maxContainerOffset().y)
			if(contentOffset.y<t_contentOffset.y)then
				contentOffset = ccp(contentOffset.x, t_contentOffset.y)
			--防止点击后乱跑添加
			--add by zhang zihang
			elseif (_curLen <= #curData) and (_curLoc ~= 0) then
				-- print(GetLocalizeStringBy("key_1755"),curUseItemTempID)
				-- print(GetLocalizeStringBy("key_2926"),_curLoc)
				-- print("当时的ID",curData[_curLoc].item_template_id)
				-- print("当前数据")
				-- print_t(curData)
				-- print("使用物品")
				-- print_t(curUseItemTempID)
				if curData[_curLoc].item_template_id ~= curUseItemTempID then
					local cellBg = CCSprite:create("images/bag/item/item_cellbg.png")
	    			local myScale = bgLayer:getContentSize().width/cellBg:getContentSize().width/bgLayer:getElementScale()
	    			-- print("单元格长度",cellSize.height*myScale)
	    			--循环是为了一次开多个，统计偏移量
	    			--因为增加的时候如果在开的箱子的后面添加的宝物，则位移不变，而在前面添加的位移才改变
	    			--所以，从当前位置开始遍历，省内存
	    			local c_e = _curLoc
	    			for e = _curLoc , #curData do
	    				c_e = e
	    				if curData[e].item_template_id == curUseItemTempID then
	    					break
	    				end
	    			end
					contentOffset = ccp(contentOffset.x,contentOffset.y - (c_e-_curLoc)*cellSize.height*myScale)
					-- print("更新后长度",contentOffset.y)
				end
				if contentOffset.y < t_contentOffset.y then
					contentOffset = ccp(contentOffset.x, t_contentOffset.y)
				end
			end
			myTableView:setContentOffset(contentOffset) 
		end
		createItemNumbersSprite()
	elseif( curMenuItem == sellBtn)then
		myTableView:reloadData()
	else
		print("this is what?")
	end
end

-- 批量出售的action
function sellAction( tag, item )
	-- 音效
	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
	if (table.isEmpty(_sellEquipList) ) then
		AnimationTip.showTip(GetLocalizeStringBy("key_1077"))
	else
		local hasHighQuality = false
		local equipArgs = CCArray:create()
		for k,g_id in pairs(_sellEquipList) do
			for k,m_data in pairs(curData) do
				if(tonumber(m_data.gid) == tonumber(g_id)) then
					-- totalPrice = totalPrice + m_data.itemDesc.sellNum
					local equipArr = CCArray:create()
					equipArr:addObject(CCInteger:create(g_id))
					equipArr:addObject(CCInteger:create(tonumber(m_data.item_id)))
					equipArr:addObject(CCInteger:create(tonumber(m_data.item_num)))
					equipArgs:addObject(equipArr)
					if(m_data.itemDesc.quality > 4) then
						hasHighQuality = true
					end
					break
				end
			end
		end
		local tempArgs = CCArray:create()
		tempArgs:addObject(equipArgs)
		RequestCenter.bag_sellItems(sellActionCallback, tempArgs)

	end
end

-- 返回到非出售界面
function sellMenuBarAction( tag, itemMenu  )
	-- 音效
	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
	local bagInfo = DataCache.getBagInfo()
	if (tag == 50001) then
		if(whichSell == 1)then
			middleSellMenuBar:setVisible(false)
			menu:setVisible(true)
			MainScene.setMainSceneViewsVisible(true, true,true)

			curMenuItem:unselected()
			curMenuItem = toolsMenuItem
			curMenuItem:selected()
			myTableView:removeFromParentAndCleanup(true)
			myTableView = nil

			curData = {}
			for k,v in pairs(bagInfo.props) do
				table.insert(curData, v)
			end
			expandBtn:setVisible(true)
			sellBtn:setVisible(true)
			createBagTableView()

			setSellEquipList(nil)
			if(_sellBottomSprite)then
				_sellBottomSprite:removeFromParentAndCleanup(true)
				_sellBottomSprite = nil
			end
		elseif(whichSell == 2)then
			middleSellMenuBar:setVisible(false)
			menu:setVisible(true)
			MainScene.setMainSceneViewsVisible(true, true,true)

			curMenuItem:unselected()
			curMenuItem = equipMenuItem
			curMenuItem:selected()
			myTableView:removeFromParentAndCleanup(true)
			myTableView = nil

			curData = {}
			local herosEquips = ItemUtil.getEquipsOnFormation()
			for k,v in pairs(bagInfo.arm) do
				table.insert(curData, v)
			end
			for k,v in pairs(herosEquips) do
				table.insert(curData, v)
			end
			expandBtn:setVisible(true)
			sellBtn:setVisible(true)
			createBagTableView()

			setSellEquipList(nil)
			if(_sellBottomSprite)then
				_sellBottomSprite:removeFromParentAndCleanup(true)
				_sellBottomSprite = nil
			end
		elseif(whichSell == 3)then
			middleSellMenuBar:setVisible(false)
			menu:setVisible(true)
			MainScene.setMainSceneViewsVisible(true, true,true)

			curMenuItem:unselected()
			curMenuItem = treasMenuItem
			curMenuItem:selected()
			myTableView:removeFromParentAndCleanup(true)
			myTableView = nil

			curData = {}
			local herosTreas = ItemUtil.getTreasOnFormation()
			for k,v in pairs(bagInfo.treas) do
				table.insert(curData, v)
			end
			for k,v in pairs(herosTreas) do
				table.insert(curData, v)
			end
			expandBtn:setVisible(true)
			sellBtn:setVisible(true)
			createBagTableView()

			setSellEquipList(nil)
			if(_sellBottomSprite)then
				_sellBottomSprite:removeFromParentAndCleanup(true)
				_sellBottomSprite = nil
			end
		elseif(whichSell == 4)then
			middleSellMenuBar:setVisible(false)
			menu:setVisible(true)
			MainScene.setMainSceneViewsVisible(true, true,true)

			curMenuItem:unselected()
			curMenuItem = armFragMenuItem
			curMenuItem:selected()
			myTableView:removeFromParentAndCleanup(true)
			myTableView = nil

			curData = {}
			for k,v in pairs(bagInfo.armFrag) do
				table.insert(curData, v)
			end
			expandBtn:setVisible(true)
			sellBtn:setVisible(true)
			createBagTableView()

			setSellEquipList(nil)
			if(_sellBottomSprite)then
				_sellBottomSprite:removeFromParentAndCleanup(true)
				_sellBottomSprite = nil
			end
		elseif(whichSell == 5)then
			middleSellMenuBar:setVisible(false)
			menu:setVisible(true)
			MainScene.setMainSceneViewsVisible(true, true,true)

			curMenuItem:unselected()
			curMenuItem = dressMenuItem
			curMenuItem:selected()
			myTableView:removeFromParentAndCleanup(true)
			myTableView = nil

			curData = {} 
			for k,v in pairs(bagInfo.dress) do
				table.insert(curData, v)
			end
			expandBtn:setVisible(true)
			sellBtn:setVisible(true)
			createBagTableView()

			setSellEquipList(nil)
			if(_sellBottomSprite)then
				_sellBottomSprite:removeFromParentAndCleanup(true)
				_sellBottomSprite = nil
			end
		end
	elseif (tag == 50002) then
		print(GetLocalizeStringBy("key_1487"))
		createLayerStarSell()
	end
end 

-- 出售 的背景
local function createSellBottom()
	_sellBottomSprite = CCSprite:create("images/common/sell_bottom.png")
	_sellBottomSprite:setAnchorPoint(ccp(0.5, 1))
	_sellBottomSprite:setPosition(ccp(bgLayer:getContentSize().width/2,0))
	bgLayer:addChild(_sellBottomSprite)
	local myScale = bgLayer:getContentSize().width/_sellBottomSprite:getContentSize().width/bgLayer:getElementScale()
	_sellBottomSprite:setScale(myScale)
	
	-- 已选择装备
	local equipLabel = CCLabelTTF:create(GetLocalizeStringBy("key_3299"), g_sFontName, 25)
	equipLabel:setColor(ccc3(0xff, 0xff, 0xff))
	equipLabel:setAnchorPoint(ccp(0.5, 0.5))
	equipLabel:setPosition(ccp(_sellBottomSprite:getContentSize().width*0.11, _sellBottomSprite:getContentSize().height*0.4))
	_sellBottomSprite:addChild(equipLabel)

	-- 总计出售
	local sellTitleLabel = CCLabelTTF:create(GetLocalizeStringBy("key_2274"), g_sFontName, 25)
	sellTitleLabel:setColor(ccc3(0xff, 0xff, 0xff))
	sellTitleLabel:setAnchorPoint(ccp(0.5, 0.5))
	sellTitleLabel:setPosition(ccp(_sellBottomSprite:getContentSize().width*0.45, _sellBottomSprite:getContentSize().height*0.4))
	_sellBottomSprite:addChild(sellTitleLabel) 

	-- 物品数量背景
	local fullRect = CCRectMake(0,0,34,32)
	local insetRect = CCRectMake(10,10,14,12)
	local itemNumSprite = CCScale9Sprite:create("images/common/checkbg.png", fullRect, insetRect)
	itemNumSprite:setPreferredSize(CCSizeMake(65, 38))
	itemNumSprite:setAnchorPoint(ccp(0.5,0.5))
	itemNumSprite:setPosition(ccp(_sellBottomSprite:getContentSize().width* 172/640, _sellBottomSprite:getContentSize().height*0.4))
	_sellBottomSprite:addChild(itemNumSprite)

	-- 物品数量
	_itemNumLabel = CCLabelTTF:create(0, g_sFontName, 25)
	_itemNumLabel:setColor(ccc3(0xff, 0xff, 0xff))
	_itemNumLabel:setAnchorPoint(ccp(0.5, 0.5))
	_itemNumLabel:setPosition(ccp(itemNumSprite:getContentSize().width*0.5, itemNumSprite:getContentSize().height*0.4))
	itemNumSprite:addChild(_itemNumLabel)

	-- 总计出售背景
	local totalSellSprite = CCScale9Sprite:create("images/common/checkbg.png", fullRect, insetRect)
	totalSellSprite:setPreferredSize(CCSizeMake(150, 38))
	totalSellSprite:setAnchorPoint(ccp(0.5,0.5))
	totalSellSprite:setPosition(ccp(_sellBottomSprite:getContentSize().width* 420/640, _sellBottomSprite:getContentSize().height*0.4))
	_sellBottomSprite:addChild(totalSellSprite)
	-- 钱币背景
	local coinBg = CCSprite:create("images/common/coin.png")
	coinBg:setAnchorPoint(ccp(0.5, 0.5))
	coinBg:setPosition(ccp(totalSellSprite:getContentSize().width*0.13, totalSellSprite:getContentSize().height*0.45))
	totalSellSprite:addChild(coinBg)

	-- 物品数量
	_itemTotalCoinLabel = CCLabelTTF:create(0, g_sFontName, 25)
	_itemTotalCoinLabel:setColor(ccc3(0xff, 0xff, 0xff))
	_itemTotalCoinLabel:setAnchorPoint(ccp(0.5, 0.5))
	_itemTotalCoinLabel:setPosition(ccp(totalSellSprite:getContentSize().width*0.6, totalSellSprite:getContentSize().height*0.4))
	totalSellSprite:addChild(_itemTotalCoinLabel)

	-- 出售按钮
	local sellMenuBar = CCMenu:create()
	sellMenuBar:setPosition(ccp(0,0))
	_sellBottomSprite:addChild(sellMenuBar)
	sellMenuBar:setTouchPriority(-402)
	local sellBtn =  LuaMenuItem.createItemImage("images/bag/equip/btn_sell_n.png", "images/bag/equip/btn_sell_h.png" )
	sellBtn:setAnchorPoint(ccp(0.5, 0.5))
    sellBtn:setPosition(ccp(_sellBottomSprite:getContentSize().width*560/640, _sellBottomSprite:getContentSize().height*0.4))
    sellBtn:registerScriptTapHandler(sellAction)

	sellMenuBar:addChild(sellBtn)


end

-- 道具
function openPropGridsCallback( cbFlag, dictData, bRet )
	if(dictData.err == "ok") then
		UserModel.addGoldNumber(-BagUtil.getNextOpenPropGridPrice())
		AnimationTip.showTip(GetLocalizeStringBy("key_3328"))
		DataCache.addGidNumBy( 2, 5 )
		createItemNumbersSprite()
	end
end

-- 装备
function openArmGridsCallback( cbFlag, dictData, bRet )
	if(dictData.err == "ok") then
		UserModel.addGoldNumber(-BagUtil.getNextOpenArmGridPrice())
		AnimationTip.showTip(GetLocalizeStringBy("key_2869"))
		DataCache.addGidNumBy( 1, 5 )
		createItemNumbersSprite()
	end
end

-- 装备碎片
function openArmFragCallback( cbFlag, dictData, bRet )
	if(dictData.err == "ok") then
		UserModel.addGoldNumber(-BagUtil.getNextOpenArmFragGridPrice())
		AnimationTip.showTip(GetLocalizeStringBy("key_2104"))
		DataCache.addGidNumBy( 4, 5 )
		createItemNumbersSprite()
	end
end

-- 宝物
function openTreasGridsCallback( cbFlag, dictData, bRet )
	if(dictData.err == "ok") then
		UserModel.addGoldNumber(-BagUtil.getNextOpenTreasGridPrice())
		AnimationTip.showTip(GetLocalizeStringBy("key_2570"))
		DataCache.addGidNumBy( 3, 5 )
		createItemNumbersSprite()
	end
end

-- 时装
function openDressGridsCallback( cbFlag, dictData, bRet )
	if(dictData.err == "ok") then
		UserModel.addGoldNumber(-BagUtil.getNextOpenDressGridPrice())
		AnimationTip.showTip(GetLocalizeStringBy("key_3152"))
		DataCache.addGidNumBy( 5, 5 )
		createItemNumbersSprite()
	end
end

-- 开启装备格子
function realOpenEquipGrid(isConfirm)
	if(isConfirm == true) then
		local args = Network.argsHandler(5, 1)
		RequestCenter.bag_openGridByGold(openArmGridsCallback, args)
	end
end

-- 开启装备碎片格子
function realOpenArmFragGrid(isConfirm)
	if(isConfirm == true) then
		local args = Network.argsHandler(5, 4)
		RequestCenter.bag_openGridByGold(openArmFragCallback, args)
	end
end

-- 开启道具格子
function realOpenPropsGrid(isConfirm)
	if(isConfirm == true)then
		local args = Network.argsHandler(5, 2)
		RequestCenter.bag_openGridByGold(openPropGridsCallback, args)
	end
end

-- 开启宝物格子
function realOpenTreasGrid(isConfirm)
	if(isConfirm == true)then
		local args = Network.argsHandler(5, 3)
		RequestCenter.bag_openGridByGold(openTreasGridsCallback, args)
	end
end

-- 开启时装格子
function realOpenDressGrid(isConfirm)
	if(isConfirm == true)then
		local args = Network.argsHandler(5, 5)
		RequestCenter.bag_openGridByGold(openDressGridsCallback, args)
	end
end

--[[
	@desc	背包按钮切换的Action
	@para 	tag， menuItem
	@return void
--]]
function itemMenuAction( tag, menuItem )
	-- print("tag---->",tag)
	menuItem:selected()
	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/changtiaoxing.mp3")
	if( curMenuItem ~= menuItem) then
		if (menuItem ~= expandBtn and menuItem ~= sellBtn) then
			curMenuItem:unselected()
			curMenuItem = menuItem
			if(myTableView) then
				myTableView:removeFromParentAndCleanup(true)
				myTableView = nil
			end
		else
			menuItem:unselected()
		end
		bagInfo = DataCache.getBagInfo()
		if(menuItem == expandBtn) then
			if(curMenuItem == toolsMenuItem) then
				if(BagUtil.getNextOpenPropGridPrice() <= UserModel.getGoldNumber())then
					local tipText = GetLocalizeStringBy("key_2303") .. BagUtil.getNextOpenPropGridPrice() .. GetLocalizeStringBy("key_1491")
					AlertTip.showAlert(tipText, realOpenPropsGrid, true)
				else
					require "script/ui/tip/LackGoldTip"
					LackGoldTip.showTip()
					--AnimationTip.showTip(GetLocalizeStringBy("key_1300") .. BagUtil.getNextOpenPropGridPrice() .. GetLocalizeStringBy("key_1911"))
				end
			elseif(curMenuItem == equipMenuItem) then
				if(BagUtil.getNextOpenArmGridPrice() <= UserModel.getGoldNumber())then
					local tipText = GetLocalizeStringBy("key_2590") .. BagUtil.getNextOpenArmGridPrice() .. GetLocalizeStringBy("key_1491")
					AlertTip.showAlert(tipText, realOpenEquipGrid, true)
				else
					require "script/ui/tip/LackGoldTip"
					LackGoldTip.showTip()
					--AnimationTip.showTip(GetLocalizeStringBy("key_1300") .. BagUtil.getNextOpenArmGridPrice() .. GetLocalizeStringBy("key_1911"))
				end
			elseif(curMenuItem == treasMenuItem) then
				if(BagUtil.getNextOpenTreasGridPrice() <= UserModel.getGoldNumber())then
					local tipText = GetLocalizeStringBy("key_2646") .. BagUtil.getNextOpenTreasGridPrice() .. GetLocalizeStringBy("key_1491")
					AlertTip.showAlert(tipText, realOpenTreasGrid, true)
				else
					require "script/ui/tip/LackGoldTip"
					LackGoldTip.showTip()
					--AnimationTip.showTip(GetLocalizeStringBy("key_1300") .. BagUtil.getNextOpenTreasGridPrice() .. GetLocalizeStringBy("key_1911"))
				end
			elseif(curMenuItem == armFragMenuItem) then
				if(BagUtil.getNextOpenArmFragGridPrice() <= UserModel.getGoldNumber())then
					local tipText = GetLocalizeStringBy("key_2598") .. BagUtil.getNextOpenArmFragGridPrice() .. GetLocalizeStringBy("key_1491")
					AlertTip.showAlert(tipText, realOpenArmFragGrid, true)
				else
					require "script/ui/tip/LackGoldTip"
					LackGoldTip.showTip()
					--AnimationTip.showTip(GetLocalizeStringBy("key_1300") .. BagUtil.getNextOpenArmFragGridPrice() .. GetLocalizeStringBy("key_1911"))
				end
			elseif(curMenuItem == dressMenuItem) then
				if(BagUtil.getNextOpenDressGridPrice() <= UserModel.getGoldNumber())then
					local tipText = GetLocalizeStringBy("key_2740") .. BagUtil.getNextOpenDressGridPrice() .. GetLocalizeStringBy("key_1491")
					AlertTip.showAlert(tipText, realOpenDressGrid, true)
				else
					require "script/ui/tip/LackGoldTip"
					LackGoldTip.showTip()
					--AnimationTip.showTip(GetLocalizeStringBy("key_1300") .. BagUtil.getNextOpenArmFragGridPrice() .. GetLocalizeStringBy("key_1911"))
				end
			end
		
		elseif (curMenuItem == toolsMenuItem) then
			curData = {}
			if (bagInfo) then
				curData = bagInfo.props
			end
			expandBtn:setVisible(true)
			sellBtn:setVisible(true)
		elseif(curMenuItem == equipMenuItem) then
			curData = {}
			local herosEquips = ItemUtil.getEquipsOnFormation()
			for k,v in pairs(bagInfo.arm) do
				table.insert(curData, v)
			end
			for k,v in pairs(herosEquips) do
				table.insert(curData, v)
			end
			expandBtn:setVisible(true)
			sellBtn:setVisible(true)
		elseif (curMenuItem == treasMenuItem) then
			curData = {}
			if (bagInfo) then
				curData = bagInfo.treas
			end
			local herosTreas = ItemUtil.getTreasOnFormation()
			for k,v in pairs(herosTreas) do
				table.insert(curData, v)
			end
			expandBtn:setVisible(true)
			sellBtn:setVisible(true)
		elseif (curMenuItem == armFragMenuItem) then
			curData = {}
			if (bagInfo) then
				-- 把能合成的提出来 能合成的排在最前边
				local data = {}
				for k,v in pairs(bagInfo.armFrag) do
					if(tonumber(v.itemDesc.need_part_num) <= tonumber(v.item_num))then
						table.insert(data,v)
					else
						table.insert(curData,v)
					end
				end
				for k,v in pairs(data) do
					table.insert(curData,v)
				end
			end
			expandBtn:setVisible(true)
			sellBtn:setVisible(true)
		elseif (curMenuItem == dressMenuItem) then
			curData = {}

			if (bagInfo) then
				curData = bagInfo.dress
			end
			local herosDress = ItemUtil.getDressOnFormation()
			for k,v in pairs(herosDress) do
				table.insert(curData, v)
			end
			expandBtn:setVisible(true)
			sellBtn:setVisible(false)
		end
		--  出售按钮
		if(menuItem == sellBtn) then
			if(myTableView) then
				myTableView:removeFromParentAndCleanup(true)
				myTableView = nil
			end
			-- print("------------>>>")
			middleSellMenuBar:setVisible(true)
			menu:setVisible(false)
			MainScene.setMainSceneViewsVisible(false, true,true)
			createSellBottom()
			curData = {}
			if(curMenuItem == toolsMenuItem) then
				-- print("111")
				if (bagInfo) then
					-- print_t(bagInfo.props)
					for k,v in pairs(bagInfo.props) do
						if(v.itemDesc.sellable ~= nil)then
							if(tonumber(v.itemDesc.sellable) == 1)then
								curData[#curData+1] = v
							end
						end
					end
					-- print_t(curData)
				end
				curMenuItem = menuItem
				whichSell = 1
				-- 隐藏按星级卖出按钮
				starSellBtn:setVisible(false)
			elseif(curMenuItem == equipMenuItem) then
				if (bagInfo) then
					curData = {}
					for k,v in pairs(bagInfo.arm) do
						-- 三星一下才能卖
						if(v.itemDesc.quality<=3)then
							table.insert(curData, v)
						end
					end
				end
				curMenuItem = menuItem
				whichSell = 2
				-- 隐藏按星级卖出按钮
				starSellBtn:setVisible(true)
			elseif(curMenuItem == treasMenuItem)then
				curData = {}
				bagInfo = DataCache.getBagInfo()
				for k,v in pairs(bagInfo.treas) do
					-- 三星一下才能卖
					if(v.itemDesc.quality<=3)then
						table.insert(curData, v)
					end
				end
				curMenuItem = menuItem
				whichSell = 3
				-- 隐藏按星级卖出按钮
				starSellBtn:setVisible(false)
			elseif (curMenuItem == armFragMenuItem) then
				curData = {}
				if (bagInfo) then
					curData = bagInfo.armFrag
				end
				curMenuItem = menuItem
				whichSell = 4
				-- 隐藏按星级卖出按钮
				starSellBtn:setVisible(false)
			elseif (curMenuItem == dressMenuItem) then
				curData = {}
				if (bagInfo) then
					curData = bagInfo.dress
				end
				print(GetLocalizeStringBy("key_3228"))
				print_t(curData)
				curMenuItem = menuItem
				whichSell = 5
				-- 隐藏按星级卖出按钮
				starSellBtn:setVisible(false)
			end
		end

		if (menuItem ~= expandBtn) then
			createBagTableView()
		end
	end	
end

--[[
	@desc	添加背包按钮
	@para 	void
	@return void
--]]
local function addBagMenus()
	menu = CCMenu:create()
	menu:setTouchPriority(-130)
    
	local fullRect = CCRectMake(0,0,58,99)
	local insetRect = CCRectMake(20,20,18,59)
	--条件背景
	btnFrameSp = CCScale9Sprite:create("images/common/menubg.png", fullRect, insetRect)
	btnFrameSp:setPreferredSize(CCSizeMake(640, 120))
	btnFrameSp:setAnchorPoint(ccp(0.5, 0))
	btnFrameSp:setPosition(ccp(bgLayer:getContentSize().width/2 , bgLayer:getContentSize().height*0.88))
	btnFrameSp:setScale(g_fScaleX/MainScene.elementScale)
	bgLayer:addChild(btnFrameSp)

	-- require "script/ui/common/LuaMenuItem"
	-- local title_item = {GetLocalizeStringBy("key_1409"),GetLocalizeStringBy("key_1791"), GetLocalizeStringBy("key_3280"), GetLocalizeStringBy("key_1971")}
	-- for i=1,4 do
	-- 	local itemImage =  LuaMenuItem.createMenuItemSprite( title_item[i])
	-- 	itemImage:setAnchorPoint(ccp(0,0))
 --        itemImage:setPosition(ccp(btnFrameSp:getContentSize().width*(i-1) * 0.24, 10))
 --        itemImage:registerScriptTapHandler(itemMenuAction)
	-- 	menu:addChild(itemImage, i, 1000+i)
	-- 	if (i == 1) then
	-- 		toolsMenuItem = itemImage
	-- 	elseif (i == 2) then
	-- 		equipMenuItem = itemImage
	-- 	elseif (i == 3) then
	-- 		treasMenuItem = itemImage
	-- 	elseif (i == 4) then
	-- 		armFragMenuItem = itemImage
	-- 	end 
	-- end

	require "script/ui/common/LuaMenuItem"
	if(_bag_type == Type_Bag_Arm_Frag)then
		local title_item = {GetLocalizeStringBy("key_1791"), GetLocalizeStringBy("key_1971"), GetLocalizeStringBy("key_1312")}
		for i=1,3 do
			local itemImage =  LuaMenuItem.createMenuItemSprite( title_item[i], 30)
			itemImage:setAnchorPoint(ccp(0,0))
	        itemImage:setPosition(ccp(btnFrameSp:getContentSize().width*(i-1) * 0.24, 10))
	        itemImage:registerScriptTapHandler(itemMenuAction)
			menu:addChild(itemImage, i, 1000+i)
			if (i == 1) then
				equipMenuItem = itemImage
			elseif (i == 2) then
				armFragMenuItem = itemImage
			elseif (i == 3) then
				dressMenuItem = itemImage
			end 
		end
	elseif(_bag_type == Type_Bag_Prop_Treas)then
		local title_item = {GetLocalizeStringBy("key_1409"), GetLocalizeStringBy("key_3280")}
		for i=1,2 do
			local itemImage =  LuaMenuItem.createMenuItemSprite( title_item[i])
			itemImage:setAnchorPoint(ccp(0,0))
	        itemImage:setPosition(ccp(btnFrameSp:getContentSize().width*(i-1) * 0.24, 10))
	        itemImage:registerScriptTapHandler(itemMenuAction)
			menu:addChild(itemImage, i, 1000+i)
			if (i == 1) then
				toolsMenuItem = itemImage
			elseif (i == 2) then
				treasMenuItem = itemImage
			end 
		end
	end


	if(_initTag == Tag_Init_Props)then
		curMenuItem = toolsMenuItem
	elseif(_initTag == Tag_Init_Arming)then
		curMenuItem = equipMenuItem
	elseif(_initTag == Tag_Init_Treas)then
		curMenuItem = treasMenuItem
	elseif(_initTag == Tag_Init_ArmFrag)then
		curMenuItem = armFragMenuItem
	elseif(_initTag == Tag_Init_Dress)then
		curMenuItem = dressMenuItem
	end
	curMenuItem:selected()
    menu:setAnchorPoint(ccp(0,0))
	menu:setPosition(ccp(0,0))
	btnFrameSp:addChild(menu)

	-- 扩充按钮
	expandBtn =  LuaMenuItem.createItemImage("images/common/btn/btn_expand_n.png", "images/common/btn/btn_expand_h.png" )
	expandBtn:setAnchorPoint(ccp(0.5, 0))
    expandBtn:setPosition(ccp(btnFrameSp:getContentSize().width*510/640,btnFrameSp:getContentSize().height*0.1))
    expandBtn:registerScriptTapHandler(itemMenuAction)
    -- expandBtn:setScale(0.8)
	menu:addChild(expandBtn, 3, 1003)


	-- 出售按钮
	sellBtn =  LuaMenuItem.createItemImage("images/common/btn/btn_sale_n.png", "images/common/btn/btn_sale_h.png" )
	sellBtn:setAnchorPoint(ccp(0.5, 0))
    sellBtn:setPosition(ccp(btnFrameSp:getContentSize().width*600/640,btnFrameSp:getContentSize().height*0.1))
    sellBtn:registerScriptTapHandler(itemMenuAction)
    -- sellBtn:setScale(0.8)
	menu:addChild(sellBtn, 4, 1004)

	--出手时的按钮Bar
	middleSellMenuBar = CCMenu:create()
	middleSellMenuBar:setTouchPriority(-130)
	middleSellMenuBar:setPosition(ccp(0,0))
	-- middleSellMenuBar:setTouchPriority(MenuBtnPriority)
	btnFrameSp:addChild(middleSellMenuBar)

	-- 返回到非出售界面
	local backBtn = LuaMenuItem.createItemImage("images/formation/changeequip/btn_back_n.png",  "images/formation/changeequip/btn_back_h.png", sellMenuBarAction)
	backBtn:setAnchorPoint(ccp(0.5, 0))
	backBtn:setPosition(ccp(btnFrameSp:getContentSize().width*560/640,btnFrameSp:getContentSize().height*0.1))
	-- backBtn:registerScriptTapHandler(sellMenuBarAction)
	middleSellMenuBar:addChild(backBtn, 1, 50001)

	-- 按星级出售按钮 add by licong
	starSellBtn = LuaMenuItem.createItemImage("images/hero/btn_star_sell_n.png",  "images/hero/btn_star_sell_h.png", sellMenuBarAction)
	starSellBtn:setAnchorPoint(ccp(0.5, 0))
	starSellBtn:setPosition(ccp(btnFrameSp:getContentSize().width*330/640,btnFrameSp:getContentSize().height*0.1))
	middleSellMenuBar:addChild(starSellBtn, 1, 50002)

	middleSellMenuBar:setVisible(false)

	------------------ 装备碎片标签上的提示数字 by licong ----------------------
	-- 显示红色数字
	if(_bag_type == Type_Bag_Arm_Frag)then
		require "script/utils/ItemDropUtil"
		_tipNum = BagUtil.getCanCompoundNumByArmFrag()
		print(GetLocalizeStringBy("key_1321"), _tipNum)
		_tipSprite = ItemDropUtil.getTipSpriteByNum( _tipNum )
		_tipSprite:setAnchorPoint(ccp(1,1))
		_tipSprite:setPosition(armFragMenuItem:getContentSize().width *0.98, armFragMenuItem:getContentSize().height*0.97)
		armFragMenuItem:addChild(_tipSprite)
		if(_tipNum <= 0)then
			_tipSprite:setVisible(false)
		end
	end
	-------------------------------------------------------------------------

end 

-- 使用回调
function useItemCallback( cbFlag, dictData, bRet )
	if (dictData.err == "ok" and (not table.isEmpty(dictData.ret)) ) then
		if(curUserItemInfo.itemDesc.item_type == 5)then
			local itemData = ItemUtil.getItemById(curUserItemInfo.itemDesc.aimItem)
			local itemName= ItemUtil.getItemNameByItmTid(curUserItemInfo.itemDesc.aimItem)  --itemData.name
			-- if( aimItem )

			AnimationTip.showTip(  GetLocalizeStringBy("key_3311") ..  itemName)
			
			----------------------- 刷新提示数字 ----------------
			require "script/utils/ItemDropUtil"
			_tipNum = _tipNum - 1
			print(GetLocalizeStringBy("key_1321"), _tipNum)
			-- 刷新小红圈数字
			ItemDropUtil.refreshNum( _tipSprite, _tipNum )
			----------------------------------------------------
		elseif( not table.isEmpty(dictData.ret.drop) )then

			UseItemLayer.showDropResult( dictData.ret.drop, 1 ,0,true)
			-- local runningScene = CCDirector:sharedDirector():getRunningScene()
			-- useLayer:setAnchorPoint(ccp(0.5, 0.5))
			-- -- useLayer:setPosition(ccp(runningScene:getContentSize().width/2 , runningScene:getContentSize().height/2))
			-- runningScene:addChild(useLayer,2000)
		else
			UseItemLayer.showResult( curUseItemTempID )

			if( tonumber(curUseItemTempID) >= 13001 and tonumber(curUseItemTempID) <= 14000 and DataCache.getSwitchNodeState(ksSwitchPet))then
				-- 使用的是宠物蛋
				require "script/ui/pet/PetData"
				if( not table.isEmpty(dictData.ret.pet) )then
					for k,v in pairs(dictData.ret.pet) do
						PetData.addPetInfo(v)
					end
				end
			end

			-- local useLayer = UseItemLayer.createLayer( curUseItemTempID )
			-- local runningScene = CCDirector:sharedDirector():getRunningScene()
			-- useLayer:setAnchorPoint(ccp(0.5, 0.5))
			-- useLayer:setPosition(ccp(runningScene:getContentSize().width/2 , runningScene:getContentSize().height/2))
			-- runningScene:addChild(useLayer,2000)
		end

		-- -- 减去使用改物品的消耗品  多堆物品 前端不知道后端减的时哪堆的 靠后端推送。。
		-- if(curUserItemInfo.itemDesc.item_type == 8)then
		-- 	if(curUserItemInfo.itemDesc.use_needItem and curUserItemInfo.itemDesc.use_needItem > 0)then
		-- 		local t_info = ItemUtil.getCacheItemInfoBy( curUserItemInfo.itemDesc.use_needItem )
		-- 		if( (not table.isEmpty(t_info)) )then
		-- 			ItemUtil.reduceItemByGid(t_info.gid, tonumber(curUserItemInfo.itemDesc.use_needNum))
		-- 		end
		-- 	end
		-- end
		-- -- 修改 by licong
		-- refreshProps( curUseItemGid, curUseItemNum )
	end
	
end

-- 道具背包刷新 add by liong
function refreshProps( curUseItemGid, curUseItemNum )
	-- ItemUtil.reduceItemByGid(curUseItemGid, curUseItemNum)
	bagInfo = DataCache.getBagInfo()
	curData = bagInfo.props
	_useItemTableViewOffset = myTableView:getContentOffset()
	refreshMyTableView()
	-- createItemNumbersSprite()
end

-- 刷新
function refreshDataByType()
	print("==============+++++++++++++++++++++")
	bagInfo = DataCache.getBagInfo()
	if (curMenuItem == toolsMenuItem) then
		curData = {}
		if (bagInfo) then
			curData = bagInfo.props
		end
	elseif(curMenuItem == equipMenuItem) then
		curData = {}
		local herosEquips = ItemUtil.getEquipsOnFormation()
		for k,v in pairs(bagInfo.arm) do
			table.insert(curData, v)
		end
		for k,v in pairs(herosEquips) do
			table.insert(curData, v)
		end
	elseif(curMenuItem == armFragMenuItem) then
		curData = {}
		if (bagInfo) then
			-- 把能合成的提出来 能合成的排在最前边
			local data = {}
			for k,v in pairs(bagInfo.armFrag) do
				if(tonumber(v.itemDesc.need_part_num) <= tonumber(v.item_num))then
					table.insert(data,v)
				else
					table.insert(curData,v)
				end
			end
			for k,v in pairs(data) do
				table.insert(curData,v)
			end
		end
	elseif (curMenuItem == treasMenuItem) then
		curData = {}
		if (bagInfo) then
			curData = bagInfo.treas
		end
		local herosTreas = ItemUtil.getTreasOnFormation()
		for k,v in pairs(herosTreas) do
			table.insert(curData, v)
		end
	end

	-- 出售
	if( curMenuItem == sellBtn)then
		if(whichSell == 1)then
			-- 道具出售
			curData = {}
			for k,v in pairs(bagInfo.props) do
				if(v.itemDesc.sellable ~= nil)then
					if(tonumber(v.itemDesc.sellable) == 1)then
						curData[#curData+1] = v
					end
				end
			end
		elseif(whichSell == 2)then
			-- 装备出售
			curData = {}
			for k,v in pairs(bagInfo.arm) do
				-- 三星一下才能卖
				if(tonumber(v.itemDesc.quality)<=3)then
					table.insert(curData, v)
				end
			end
		elseif(whichSell == 3)then
			-- 宝物出售
			curData = {}
			for k,v in pairs(bagInfo.treas) do
				-- 三星一下才能卖
				if(tonumber(v.itemDesc.quality)<=3)then
					table.insert(curData, v)
				end
			end
		elseif(whichSell == 4)then
			-- 装备碎片出售
			curData = {}
			curData = bagInfo.armFrag
			-------------  添加出售后 小红圈数字重新算 add by licong -----------
			_tipNum = BagUtil.getCanCompoundNumByArmFrag()
			-- 刷新小红圈数字
			ItemDropUtil.refreshNum( _tipSprite, _tipNum )
			----------------------------------------------------------------
		elseif(whichSell == 5)then
			-- 时装出售
			curData = {}
			curData = bagInfo.dress
		end
	end

	refreshMyTableView()
end

-- 判断ItemId 是否为随机礼包 added by zhz
function isItemTidInRandGift( itemTid )
	itemTid = tonumber(itemTid)
	if(itemTid >= 30001 and itemTid <= 40000) then
		return true
	end
	return false
end

-- 使用物品 tag = gid
function useItemAction( tag, itemMenu )
	-- 音效
	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
	curUserItemInfo = nil
	--防止点击后产生位移添加
	--add by zhangzihang
	_curLen = #curData
	for k, m_itemData in pairs(curData) do
		if(tonumber( m_itemData.gid )== tag) then
			curUseItemTempID = m_itemData.item_template_id
			curUseItemNum = 1
			curUseItemGid = m_itemData.gid
			curUserItemInfo = m_itemData
			--为防止点击后产生位移添加
			--add by zhangzihang
			_curLoc = k
			break
		end
	end

	if (curUserItemInfo) then
		print("CURUSERITEMINFO")
		print_t(curUserItemInfo)

		print(" useItemAction useItemAction useItemAction")
		if( tonumber(curUserItemInfo.item_template_id ) == 60012) then
			require "script/ui/main/ChangeUserNameLayer"
			ChangeUserNameLayer.showLayer(1)
			return
		end
		if( curUserItemInfo.itemDesc.award_item_id )then
			if(ItemUtil.isBagFull() == true)then
				-- AnimationTip.showTip(GetLocalizeStringBy("key_1419"))
				return
			end
		end
		print("curUserItemInfocurUserItemInfocurUserItemInfo.getSwitchNodeState(ksSwitchPet)")
		if( curUserItemInfo.itemDesc.getPet)then

			print("DataCache.getSwitchNodeState(ksSwitchPet)")
			-- 蠢物
			if not DataCache.getSwitchNodeState(ksSwitchPet) then
				return
			end
			require "script/ui/pet/PetData"
			if tonumber(PetData.getPetNum()) >= tonumber(PetData.getOpenBagNum()) then
				require "script/ui/tip/AnimationTip"
				AnimationTip.showTip(GetLocalizeStringBy("key_2357"))
				return
			end
		end
		-- 当奖励为 award_card_id( 即奖励的可能为武将时)存在并且 item_template_id 在 随机礼包的范围时
		if( curUserItemInfo.itemDesc.award_card_id or  isItemTidInRandGift(curUserItemInfo.item_template_id ) ) then
            require "script/ui/hero/HeroPublicUI"
            if HeroPublicUI.showHeroIsLimitedUI() then
                return
            end
		end

		-- 4星将魂包 和 5星将魂包 不做判断
		if(curUserItemInfo.itemDesc.item_type == 8 and curUserItemInfo.itemDesc.id ~= 30021 and curUserItemInfo.itemDesc.id ~= 30022) then
			-- 5星武将包
			if(curUserItemInfo.itemDesc.id == 30201)then
	            if HeroPublicUI.showHeroIsLimitedUI() then
	                return
	            end
			elseif(ItemUtil.isBagFull() == true)then
				-- AnimationTip.showTip(GetLocalizeStringBy("key_1419"))
				return
			end
		end
		
		if(curUserItemInfo.itemDesc.item_type == 5)then
			if(ItemUtil.isEquipBagFull(true) == true)then
				return
			end

			if( tonumber(curUserItemInfo.itemDesc.need_part_num) > tonumber(curUserItemInfo.item_num) )then
				AnimationTip.showTip( curUserItemInfo.itemDesc.need_part_num .. GetLocalizeStringBy("key_1632"))
			else
				curUseItemNum = tonumber(curUserItemInfo.itemDesc.need_part_num)
				local args = Network.argsHandler(curUserItemInfo.gid, curUserItemInfo.item_id, curUseItemNum,1)
				RequestCenter.bag_useItem(useItemCallback, args)
			end
		elseif(curUserItemInfo.itemDesc.item_type == 8 )then
			if(curUserItemInfo.itemDesc.use_needItem and curUserItemInfo.itemDesc.use_needItem > 0)then
				local t_info = ItemUtil.getCacheItemInfoBy( curUserItemInfo.itemDesc.use_needItem )
				if( table.isEmpty(t_info) or (tonumber(t_info.item_num) < tonumber(curUserItemInfo.itemDesc.use_needNum)) )then
					local tt_info = ItemUtil.getItemById(curUserItemInfo.itemDesc.use_needItem)
					AnimationTip.showTip(GetLocalizeStringBy("key_2702") .. curUserItemInfo.itemDesc.use_needNum .. GetLocalizeStringBy("key_2557") .. tt_info.name )
				else
					local maxNum = math.floor( tonumber(t_info.item_num)/tonumber(curUserItemInfo.itemDesc.use_needNum) )
					local maxCanUseNum = math.min(maxNum, tonumber(curUserItemInfo.item_num))
					if(maxCanUseNum > 1)then
						require "script/ui/bag/BatchUseLayer"
						BatchUseLayer.showBatchUseLayer(curUserItemInfo, maxCanUseNum)
					else
						local args = Network.argsHandler(curUserItemInfo.gid, curUserItemInfo.item_id, curUseItemNum,1)
						RequestCenter.bag_useItem(useItemCallback, args)
					end
				end
			else
				if(tonumber(curUserItemInfo.item_num) > 1)then
					-- 批量
					require "script/ui/bag/BatchUseLayer"
					BatchUseLayer.showBatchUseLayer(curUserItemInfo, curUserItemInfo.item_num)
				else
					local args = Network.argsHandler(curUserItemInfo.gid, curUserItemInfo.item_id, curUseItemNum,1)
					RequestCenter.bag_useItem(useItemCallback, args)
				end
			end
		elseif(curUserItemInfo.itemDesc.item_type == 3 )then
			-- 使用宠物蛋限制
			if( tonumber(curUserItemInfo.item_template_id) >= 13001 and tonumber(curUserItemInfo.item_template_id) <= 14000 )then
				-- 功能节点未开启
				if not DataCache.getSwitchNodeState(ksSwitchPet) then
					return
				end
				-- 宠物背包满了
				require "script/ui/pet/PetUtil"
				if PetUtil.isPetBagFull() == true then
					return
				end
			end
			if(tonumber(curUserItemInfo.item_num) > 1)then
				-- 批量
				require "script/ui/bag/BatchUseLayer"
				BatchUseLayer.showBatchUseLayer(curUserItemInfo, curUserItemInfo.item_num)
			else
				-- 一个
				local args = Network.argsHandler(curUserItemInfo.gid, curUserItemInfo.item_id, curUseItemNum,1)
				RequestCenter.bag_useItem(useItemCallback, args)
			end
		elseif(curUserItemInfo.itemDesc.item_type == 9)then
			-- 名将礼物
			if not DataCache.getSwitchNodeState(ksSwitchGreatSoldier) then
				return
			end
            require "script/ui/star/StarLayer"
            local starLayer = StarLayer.createLayer()
            MainScene.changeLayer(starLayer, "starLayer")

		elseif(curUserItemInfo.itemDesc.item_type == 4)then
			-- 蠢物
			if not DataCache.getSwitchNodeState(ksSwitchPet) then
				return
			end
			require "script/ui/pet/PetMainLayer"
    		local layer= PetMainLayer.createLayer()
    		MainScene.changeLayer(layer, "PetMainLayer")
    	elseif(curUserItemInfo.itemDesc.item_type == 6 )then
    		-- 物品背包满了
			require "script/ui/item/ItemUtil"
			if(ItemUtil.isBagFull() == true )then
				return
			end
			-- 武将满了
			require "script/ui/hero/HeroPublicUI"
		    if HeroPublicUI.showHeroIsLimitedUI() then
		    	return
		    end
		    if(curUserItemInfo.itemDesc.choose_items ~= nil)then
				-- 礼包类物品 使用后选择一个领取
				require "script/ui/bag/UseGiftLayer"
				UseGiftLayer.showTipLayer(curUserItemInfo)
			end
		else
			local args = Network.argsHandler(curUserItemInfo.gid, curUserItemInfo.item_id, curUseItemNum,1)
			RequestCenter.bag_useItem(useItemCallback, args)
		end
	end
end

function bagInfoCallbck( cbFlag, dictData, bRet )
	if (dictData.err == "ok") then
		DataCache.setBagInfo(dictData.ret)
	end
	local bagInfo = DataCache.getBagInfo()
	if (bagInfo)then
		if(_initTag == Tag_Init_Props  and bagInfo.props) then
			curData = bagInfo.props
		elseif( _initTag == Tag_Init_Arming and bagInfo.arm)then
			
			curData = {}
			local herosEquips = ItemUtil.getEquipsOnFormation()
			for k,v in pairs(bagInfo.arm) do
				table.insert(curData, v)
			end
			for k,v in pairs(herosEquips) do
				table.insert(curData, v)
			end
		elseif( _initTag == Tag_Init_Treas and bagInfo.treas)then
			curData = bagInfo.treas
			local herosTreas = ItemUtil.getTreasOnFormation()
			for k,v in pairs(herosTreas) do
				table.insert(curData, v)
			end
		elseif( _initTag == Tag_Init_ArmFrag and bagInfo.armFrag)then
			curData = bagInfo.armFrag
		elseif( _initTag == Tag_Init_Dress and bagInfo.dress)then
			curData = bagInfo.dress
			local herosDress = ItemUtil.getDressOnFormation()
			for k,v in pairs(herosDress) do
				table.insert(curData, v)
			end
		end
	end 
	createBagTableView()
end


--[[
 @desc	 回调onEnter和onExit时间
 @para 	 string event
 @return void
 --]]
local function onNodeEvent( event )
	if (event == "enter") then
		PreRequest.setBagDataChangedDelete(refreshDataByType)
	elseif (event == "exit") then
		PreRequest.setBagDataChangedDelete(nil)
	end
end

function createLayer(init_tag, bag_type)
	-- PreRequest.setBagDataChangedDelete(refreshDataByType)
	print("init_tag===", init_tag)
	_initTag = init_tag or Tag_Init_Props
	_bag_type = bag_type
	if(_bag_type == nil)then
		if(_initTag == Tag_Init_Props or _initTag == Tag_Init_Treas)then
			_bag_type = Type_Bag_Prop_Treas
			
			-- 清除提示小气泡
			PreRequest.clearNewuseItemNum()
			MenuLayer.refreshMenuItemTipSprite()
		else
			_bag_type = Type_Bag_Arm_Frag
		end
	end
	

	BagUtil.getSealSpriteByItemTempId(101101)

	itemNumbersSprite = nil
	_sellEquipList = nil
	require "script/ui/main/MainScene"
	bgLayer = MainScene.createBaseLayer("images/main/module_bg.png")
	bgLayer:registerScriptHandler(onNodeEvent)
	addBagMenus()
	bagInfo = DataCache.getBagInfo()
	if (bagInfo == nil) then
		RequestCenter.bag_bagInfo(BagLayer.bagInfoCallbck)
	else 
		if (bagInfo)then
			if(_initTag == Tag_Init_Props  and bagInfo.props) then
				curData = bagInfo.props
			elseif( _initTag == Tag_Init_Arming and bagInfo.arm)then
				curData = {}
				local herosEquips = ItemUtil.getEquipsOnFormation()
				for k,v in pairs(bagInfo.arm) do
					table.insert(curData, v)
				end
				for k,v in pairs(herosEquips) do
					table.insert(curData, v)
				end
			elseif( _initTag == Tag_Init_Treas and bagInfo.treas)then
				curData = bagInfo.treas
				local herosTreas = ItemUtil.getTreasOnFormation()
				for k,v in pairs(herosTreas) do
					table.insert(curData, v)
				end
			elseif( _initTag == Tag_Init_ArmFrag and bagInfo.armFrag)then
				curData = bagInfo.armFrag
			elseif( _initTag == Tag_Init_Dress and bagInfo.dress)then
				curData = bagInfo.dress
				local herosDress = ItemUtil.getDressOnFormation()
				for k,v in pairs(herosDress) do
					table.insert(curData, v)
				end
			end
		end 
		createBagTableView()
	end
	
	return bgLayer
end 

------------------------------------------------ 按星级出售 -------------------------------------

-- 星级数据数组
local _star_level_data = {
	{number=1, tag=_ksTagStarLevelSell+1, },
	{number=2, tag=_ksTagStarLevelSell+2, },
	{number=3, tag=_ksTagStarLevelSell+3, },
}

-- 按星级出售菜单项回调处理
local function fnHandlerOfMenuItemStarLevelSell(tag, item_obj)
	-- “关闭”按钮事件处理
	if tag==_ksTagStarSellPanelCloseBtn or tag==_ksTagStarSellPanelSure then
		for i=1, #_star_level_data do
			local item = tolua.cast(_ccMenuStarSell:getChildByTag(_star_level_data[i].tag), "CCMenuItemImage")
			if item then
				local ccSelected = tolua.cast(item:getChildByTag(_star_level_data[i].tag), "CCSprite")
				if (ccSelected:isVisible()) then
					_star_level_data[i].isSelected = true
				end
			end
		end
		local runningScene = CCDirector:sharedDirector():getRunningScene()
		runningScene:removeChildByTag(_ksTagLayerStarSell, true)
		fnUpdateTableViewAfterStarSell()
	-- “全部选择”按钮事件处理
	elseif (tag == _ksTagStarSellPanelSelectAll) then
		_ccButtonSelectAll:setVisible(false)
		_ccButtonCancel:setVisible(true)
		for i=1, #_star_level_data do
			local item = tolua.cast(_ccMenuStarSell:getChildByTag(_star_level_data[i].tag), "CCMenuItemImage")
			if item then
				local ccSelected = tolua.cast(item:getChildByTag(_star_level_data[i].tag), "CCSprite")
				ccSelected:setVisible(true)
			end
		end
	-- “取消选择”按钮事件处理
	elseif tag == _ksTagStarSellPanelCancel then
		_ccButtonSelectAll:setVisible(true)
		_ccButtonCancel:setVisible(false)
		for i=1, #_star_level_data do
			local item = tolua.cast(_ccMenuStarSell:getChildByTag(_star_level_data[i].tag), "CCMenuItemImage")
			if item then
				local ccSelected = tolua.cast(item:getChildByTag(_star_level_data[i].tag), "CCSprite")
				ccSelected:setVisible(false)
			end
		end
	-- 各星级点击事件处理
	elseif (tag >= _ksTagStarLevelSell and tag <= _ksTagStarLevelSell+#_star_level_data) then
		local item = tolua.cast(_ccMenuStarSell:getChildByTag(tag), "CCMenuItemImage")
		local ccSelected = tolua.cast(item:getChildByTag(tag), "CCSprite")
		if (ccSelected:isVisible() == true) then
			ccSelected:setVisible(false)
		else
			ccSelected:setVisible(true)
		end
	end
end

-- 创建星级菜单项方法
local function createStarLevelMenuItem(star_level_data)
	local item = CCMenuItemImage:create("images/hero/star_sell/item_bg_n.png", "images/hero/star_sell/item_bg_h.png")
	item:registerScriptTapHandler(fnHandlerOfMenuItemStarLevelSell)
	-- 几星文本显示
	local ccLabelNumber = CCLabelTTF:create(star_level_data.number, g_sFontName, 30)
	ccLabelNumber:setColor(ccc3(0xff, 0xed, 0x55))
	ccLabelNumber:setPosition(ccp(78, 8))
	item:addChild(ccLabelNumber)
	-- 星图片
	local ccSpriteStar = CCSprite:create("images/hero/star.png")
	ccSpriteStar:setPosition(ccp(120, 14))
	item:addChild(ccSpriteStar)
	-- 是否选中显示
	local ccSpriteSelected = CCSprite:create("images/common/checked.png")
	ccSpriteSelected:setPosition(ccp(176, 10))
	ccSpriteSelected:setVisible(false)
	item:addChild(ccSpriteSelected, 0, star_level_data.tag)

	return item
end
local function fnFilterTouchEvent(event, x, y)
	return true
end

-- 创建按星级出售层  add by licong
function createLayerStarSell()
	local layer = CCLayerColor:create(ccc4(11,11,11,166))
	-- 背景九宫格图片
	local fullRect = CCRectMake(0, 0, 213, 171)
	local insetRect = CCRectMake(84, 84, 2, 3)
	local ccStarSellBG = CCScale9Sprite:create("images/common/viewbg1.png", fullRect, insetRect)
	ccStarSellBG:setPreferredSize(CCSizeMake(524, 438))
	local bg_size = ccStarSellBG:getContentSize()
	ccStarSellBG:setPosition(ccp(g_winSize.width/2, g_winSize.height/2))
	ccStarSellBG:setAnchorPoint(ccp(0.5, 0.5))
	-- 按星级出售标题背景
	local ccTitleBG = CCSprite:create("images/common/viewtitle1.png")
	ccTitleBG:setPosition(ccp(bg_size.width/2, bg_size.height-6))
	ccTitleBG:setAnchorPoint(ccp(0.5, 0.5))
	ccStarSellBG:addChild(ccTitleBG)
	-- 按星级出售标题文本
	local ccLabelTitle = CCLabelTTF:create (GetLocalizeStringBy("key_1487"), g_sFontName, 35, CCSizeMake(315, 61), kCCTextAlignmentCenter, kCCVerticalTextAlignmentCenter)
	ccLabelTitle:setPosition(ccp(ccTitleBG:getContentSize().width/2, (ccTitleBG:getContentSize().height-1)/2))
	ccLabelTitle:setAnchorPoint(ccp(0.5, 0.5))
	ccLabelTitle:setColor(ccc3(0xff, 0xf0, 0x49))
	ccTitleBG:addChild(ccLabelTitle)
	-- “请选择星级”文本显示
	local ccLabelTip = CCRenderLabel:create(GetLocalizeStringBy("key_3317"), g_sFontName, 30, 1, ccc3(0, 0, 0), type_stroke)
	ccLabelTip:setAnchorPoint(ccp(0.5, 0))
	ccLabelTip:setPositionX(bg_size.width/2)
	ccLabelTip:setColor(ccc3(0xff, 0xed, 0x55))
	ccLabelTip:setPositionY(356)
	ccStarSellBG:addChild(ccLabelTip)

	local menu = CCMenu:create()
	menu:setContentSize(bg_size)
	menu:setPosition(ccp(0, 0))
	menu:setTouchPriority(-454)
	-- 星级MenuItem
	local pos_y = 140
	for i=1, #_star_level_data do
		local item = createStarLevelMenuItem(_star_level_data[#_star_level_data-i+1])
		item:setPosition(ccp(bg_size.width/2, pos_y))
		item:setAnchorPoint(ccp(0.5, 0))
		menu:addChild(item, 0, _star_level_data[#_star_level_data-i+1].tag)
		pos_y = pos_y + item:getContentSize().height+10
	end

	local ccButtonClose = CCMenuItemImage:create("images/common/btn_close_n.png", "images/common/btn_close_h.png")
	ccButtonClose:setAnchorPoint(ccp(1, 1))
	ccButtonClose:setPosition(ccp(bg_size.width+14, bg_size.height+14))
	ccButtonClose:registerScriptTapHandler(fnHandlerOfMenuItemStarLevelSell)
	menu:addChild(ccButtonClose, 0, _ksTagStarSellPanelCloseBtn)

	ccStarSellBG:addChild(menu, 0, _ksTagStarSellPanelMenu)

	require "script/libs/LuaCC"
	_ccButtonSelectAll = LuaCC.create9ScaleMenuItem("images/star/intimate/btn_blue_n.png", "images/star/intimate/btn_blue_h.png",CCSizeMake(160, 64), GetLocalizeStringBy("key_2776"), ccc3(0xfe, 0xdb, 0x1c),28,g_sFontPangWa,1, ccc3(0, 0, 0))

	-- 全部选择按钮
	_ccButtonSelectAll:setAnchorPoint(ccp(0.5, 0))
	_ccButtonSelectAll:setPosition(bg_size.width*0.3, 48)
	_ccButtonSelectAll:registerScriptTapHandler(fnHandlerOfMenuItemStarLevelSell)
	menu:addChild(_ccButtonSelectAll, 0, _ksTagStarSellPanelSelectAll)
	-- 取消选择按钮
	_ccButtonCancel = LuaCC.create9ScaleMenuItem("images/star/intimate/btn_blue_n.png", "images/star/intimate/btn_blue_h.png",CCSizeMake(160, 64), GetLocalizeStringBy("key_2982"), ccc3(0xfe, 0xdb, 0x1c),28,g_sFontPangWa,1, ccc3(0, 0, 0))

	_ccButtonCancel:setAnchorPoint(ccp(0.5, 0))
	_ccButtonCancel:setPosition(bg_size.width*0.3, 48)
	_ccButtonCancel:setVisible(false)
	_ccButtonCancel:registerScriptTapHandler(fnHandlerOfMenuItemStarLevelSell)
	menu:addChild(_ccButtonCancel, 0, _ksTagStarSellPanelCancel)

-- 确定按钮
	local ccBtnSure = LuaCC.create9ScaleMenuItem("images/star/intimate/btn_blue_n.png", "images/star/intimate/btn_blue_h.png",CCSizeMake(160, 64), GetLocalizeStringBy("key_2229"), ccc3(0xfe, 0xdb, 0x1c),28,g_sFontPangWa,1, ccc3(0, 0, 0))

	ccBtnSure:setAnchorPoint(ccp(0.5, 0))
	ccBtnSure:setPosition(bg_size.width*0.7, 48)
	ccBtnSure:registerScriptTapHandler(fnHandlerOfMenuItemStarLevelSell)
	menu:addChild(ccBtnSure, 0, _ksTagStarSellPanelSure)

	_ccMenuStarSell = menu

	setAdaptNode(ccStarSellBG)
	layer:addChild(ccStarSellBG)
	layer:setTouchPriority(-451)
	layer:setTouchEnabled(true)
	layer:registerScriptTouchHandler(fnFilterTouchEvent,false,-450, true)

	local runningScene = CCDirector:sharedDirector():getRunningScene()
	runningScene:addChild(layer, 1000, _ksTagLayerStarSell)
end

-- 更新英雄列表勾选状态方法(在按星级出售选择之后)
fnUpdateTableViewAfterStarSell = function ()
	local t_sellList = {}
	for i=1, #_star_level_data do
		if _star_level_data[i].isSelected then
			fnUpdateTableViewCellSelectionStatus(_star_level_data[i].number,t_sellList)
		end
		_star_level_data[i].isSelected = nil
	end


	-- 设置出售列表
	setSellEquipList(t_sellList)
	-- 更新tableView
	myTableView:reloadData()
end

-- 打钩
fnUpdateTableViewCellSelectionStatus = function (star_lv,tab)
	-- print("star_lv:",star_lv)
	local sellList = {}
	-- print("curData:")
	-- print_t(curData)
	for i = 1, #curData do
		print("quality",curData[i].itemDesc.quality,"star_lv",star_lv)
		if ( tonumber(curData[i].itemDesc.quality) == tonumber(star_lv)) then
			table.insert(tab,curData[i].gid)
		end
	end
end


--add by lichenyang
function getTableView( ... )
	if(myTableView) then
		return myTableView
	else
		return nil
	end
end

function setLastOffset( off_set )
	_lastOffset = off_set
end

function getLastOffset( ... )
	return _lastOffset
end




