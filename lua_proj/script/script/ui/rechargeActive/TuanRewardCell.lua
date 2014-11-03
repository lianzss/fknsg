-- FileName: TuanRewardCell.lua 
-- Author: licong 
-- Date: 14-5-22 
-- Purpose: 团购奖励cell


module("TuanRewardCell", package.seeall)

require "script/model/user/UserModel"
require "script/ui/item/ItemSprite"
require "script/ui/item/ItemUtil"
require "script/ui/hero/HeroPublicLua"
require "script/ui/hero/HeroPublicCC"

function createCell(tCellValues)
	-- print("tCellValues--")
	-- print_t(tCellValues)
	local tCell = CCTableViewCell:create()
	-- 背景
	local fullRect = CCRectMake(0,0,116,124)
    local insetRect = CCRectMake(52,44,6,4)
    local cellBg = CCScale9Sprite:create("images/common/bg/change_bg.png",fullRect, insetRect)
	cellBg:setContentSize(CCSizeMake(612,232))
	cellBg:setAnchorPoint(ccp(0,0))
	cellBg:setPosition(ccp(0,0))
	tCell:addChild(cellBg)
	-- 描述
	local  descBg= CCScale9Sprite:create("images/sign/sign_bottom.png")
	descBg:setContentSize(CCSizeMake(244,55))
	descBg:setPosition(ccp(3,cellBg:getContentSize().height*0.72))
	cellBg:addChild(descBg)
	local needNum = tCellValues.needNum
	local desLabelNum = CCRenderLabel:create( needNum, g_sFontPangWa,21,1,ccc3(0x00,0x00,0x00),type_stroke)
	desLabelNum:setColor(ccc3(0x00,0xff,0x18))
	desLabelNum:setAnchorPoint(ccp(0,0.5))
	descBg:addChild(desLabelNum)
	local desStr = GetLocalizeStringBy("lic_1028")
	local desLabel = CCRenderLabel:create( desStr,  g_sFontPangWa,25,1,ccc3(0x00,0x00,0x00),type_stroke)
	desLabel:setAnchorPoint(ccp(0,0.5))
	desLabel:setColor(ccc3(0xff,0xff,0xff))
	descBg:addChild(desLabel)
	local posX = (descBg:getContentSize().width-desLabelNum:getContentSize().width-desLabel:getContentSize().width)/2
	desLabelNum:setPosition(ccp(posX,descBg:getContentSize().height*0.5+2))
	desLabel:setPosition(ccp(desLabelNum:getPositionX()+desLabelNum:getContentSize().width,desLabelNum:getPositionY()))

	-- 团购满
    local font1 = CCLabelTTF:create(GetLocalizeStringBy("lic_1029"),g_sFontName,21)
    font1:setColor(ccc3(0x7E,0x1c,0x00))
    font1:setAnchorPoint(ccp(0,1))
    font1:setPosition(ccp(250,cellBg:getContentSize().height-18))
    cellBg:addChild(font1)
    -- 最大人数
    local maxNum = tCellValues.needNum
    local font2 = CCLabelTTF:create(maxNum,g_sFontName,21)
    font2:setColor(ccc3(0x7E,0x1c,0x00))
    font2:setAnchorPoint(ccp(0,1))
    font2:setPosition(ccp(font1:getPositionX()+font1:getContentSize().width,font1:getPositionY()))
    cellBg:addChild(font2)
    -- 人可领取此奖励
    local font3 = CCLabelTTF:create(GetLocalizeStringBy("lic_1030"),g_sFontName,21)
    font3:setColor(ccc3(0x7E,0x1c,0x00))
    font3:setAnchorPoint(ccp(0,1))
    font3:setPosition(ccp(font2:getPositionX()+font2:getContentSize().width,font1:getPositionY()))
    cellBg:addChild(font3)
    -- 购买人数/最大人数
    local haveNum = tCellValues.haveNum
    local maxNum = tCellValues.needNum
    local numFont = CCLabelTTF:create("(" .. haveNum .. "/" .. maxNum .. ")",g_sFontName,21)
    numFont:setColor(ccc3(0x00,0x8d,0x3d))
    numFont:setAnchorPoint(ccp(0,1))
    numFont:setPosition(ccp(font3:getPositionX()+font3:getContentSize().width+2,font1:getPositionY()))
    cellBg:addChild(numFont)

	-- 领取回调
	local function itemCallFun( tag, item)
		-- 判断活动是否结束
		if( BTUtil:getSvrTimeInterval()<tonumber(ActivityConfig.ConfigCache.groupon.start_time) or BTUtil:getSvrTimeInterval() > tonumber(ActivityConfig.ConfigCache.groupon.end_time) ) then
			AnimationTip.showTip(GetLocalizeStringBy("key_1857"))
			return
		end	
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
		local function requestCallback( )
			-- 弹出奖励物品
	        local rewardData = ItemUtil.getItemsDataByStr( tCellValues.rewardStr )
	        -- 修改本地数据 加奖励
	        -- print("rewardDat goodsId,id",tCellValues.goodsId,tCellValues.id)
	        -- print_t(rewardData)
	        ItemUtil.addRewardByTable(rewardData)
	        -- 展现领取奖励列表
	        require "script/ui/item/ReceiveReward"
	        ReceiveReward.showRewardWindow( rewardData, nil , 1001, -455 )
	        -- 加领取的奖励id
	        TuanData.addHaveRewardIndex(tCellValues.goodsId,tCellValues.id)
	        -- 刷新tableView
	        TuanLayer.refreshTableView()
		end
		TuanService.recReward( tCellValues.goodsId, tCellValues.id, requestCallback )
	end
	-- 领取按钮
	local menu = CCMenu:create()
	menu:setPosition(ccp(0,0))
	cellBg:addChild(menu)
	menu:setTouchPriority(-330)
	local normalSprite  = CCSprite:create("images/common/btn/btn_blue_n.png")
    local selectSprite  = CCSprite:create("images/common/btn/btn_blue_n.png")
    local disabledSprite = CCSprite:create("images/common/btn/btn_blue_hui.png")
    local item = CCMenuItemSprite:create(normalSprite,selectSprite,disabledSprite)
    item:setAnchorPoint(ccp(1,0.5))
    item:setPosition(ccp(cellBg:getContentSize().width-35,cellBg:getContentSize().height*0.5))
    menu:addChild(item,1,tonumber(tCellValues.id))
    item:registerScriptTapHandler(itemCallFun)
   
	-- 先判断是否领取过
	local isHaveGet = TuanData.isHaveReward(tCellValues.goodsId, tCellValues.id )
	if(isHaveGet)then
		-- 已经领取
		local fontStr = GetLocalizeStringBy("key_1369")
		local itemFont = CCRenderLabel:create(fontStr,  g_sFontPangWa, 30, 1, ccc3(0x00, 0x00, 0x00), type_stroke)
		itemFont:setColor(ccc3(0xf1,0xf1,0xf1))
		itemFont:setAnchorPoint(ccp(0.5,0.5))
		itemFont:setPosition(ccp(item:getContentSize().width*0.5,item:getContentSize().height*0.5))
		item:addChild(itemFont,1,123)
		-- 按钮不可点，文字颜色置灰
		item:setEnabled(false)
	else
		-- 没有领取的
		local fontStr = GetLocalizeStringBy("key_1085")
		local itemFont = CCRenderLabel:create(fontStr,  g_sFontPangWa, 30, 1, ccc3(0x00, 0x00, 0x00), type_stroke)
		itemFont:setColor(ccc3(0xfe,0xdb,0x1c))
		itemFont:setAnchorPoint(ccp(0.5,0.5))
		itemFont:setPosition(ccp(item:getContentSize().width*0.5,item:getContentSize().height*0.5))
		item:addChild(itemFont,1,123)
		-- 判断是否够资格领取
		if( tCellValues.state == 0)then
			-- 没参团不够资格
			item:setEnabled(false)
			itemFont:setColor(ccc3(0xf1,0xf1,0xf1))
		else
			-- 参团人数不足 不能领
			if(tCellValues.needNum > tCellValues.haveNum )then
				-- 已购买人数不够 不够资格领取 按钮不可点且置灰
				item:setEnabled(false)
				itemFont:setColor(ccc3(0xf1,0xf1,0xf1))
			end
		end
	end
	

	-- 物品背景
	-- 二级背景
    local fullRect = CCRectMake(0, 0, 75, 75)
    local insetRect = CCRectMake(30, 30, 15, 10)
    local rewardBg = CCScale9Sprite:create("images/common/bg/goods_bg.png",fullRect, insetRect)
	rewardBg:setContentSize(CCSizeMake(423,155))
	rewardBg:setPosition(ccp(20,20))
	cellBg:addChild(rewardBg)

	-- 创建goods列表
	-- print("reward str",tCellValues.rewardStr)
	local all_good = ItemUtil.getItemsDataByStr(tCellValues.rewardStr)
	-- print("all_good++")
	-- print_t(all_good)
	local cellSize = CCSizeMake(101, 120)
	local h = LuaEventHandler:create(function(fn, table, a1, a2) 	--创建
		local r
		if fn == "cellSize" then
			r = cellSize
		elseif fn == "cellAtIndex" then
           a2 = createGoodListCell(all_good[a1+1])
			r = a2
		elseif fn == "numberOfCells" then
			local num = #all_good
			r = num
		elseif fn == "cellTouched" then
			
		elseif (fn == "scroll") then
			
		end
		return r
	end)
	local goodTableView = LuaTableView:createWithHandler(h, CCSizeMake(420, 120))
	goodTableView:setBounceable(true)
	goodTableView:setTouchEnabled(false)
	if( table.count(all_good) > 4) then
		goodTableView:setTouchEnabled(true)
	end
	goodTableView:setDirection(kCCScrollViewDirectionHorizontal)
	goodTableView:setPosition(ccp(1, 10))
	goodTableView:setVerticalFillOrder(kCCTableViewFillTopDown)
	rewardBg:addChild(goodTableView)
	goodTableView:setTouchPriority(-133)

	--添加一个右侧屏蔽layer 优先级为-131
	-- touch事件处理
	local pingbiLayer = CCLayer:create()
	local function cardLayerTouch(eventType, x, y)
		local rect = getSpriteScreenRect(pingbiLayer)
		if(rect:containsPoint(ccp(x,y))) then
			return true
		else
			return false
		end
	end
	-- local pingbiLayer = CCLayerColor:create(ccc4(255,0,0,255))
	pingbiLayer:setContentSize(CCSizeMake(155,185))
	pingbiLayer:setTouchEnabled(true)
	pingbiLayer:registerScriptTouchHandler(cardLayerTouch,false,-131,true)
	pingbiLayer:ignoreAnchorPointForPosition(false)
	pingbiLayer:setAnchorPoint(ccp(1,0))
	pingbiLayer:setPosition(cellBg:getContentSize().width,0)
	cellBg:addChild(pingbiLayer)

	return tCell
end

-- 创建展示物品列表cell
function createGoodListCell( cellValues )
	-- print("//////////")
	-- print_t(cellValues)
	local cell = CCTableViewCell:create()
	local iconBg = nil
	local iconName = nil
	local nameColor = nil
	if(cellValues.type == "silver") then
		-- 银币
		iconBg= ItemSprite.getSiliverIconSprite()
		iconName = GetLocalizeStringBy("key_1687")
		local quality = ItemSprite.getSilverQuality()
        nameColor = HeroPublicLua.getCCColorByStarLevel(quality)
	elseif(cellValues.type == "soul") then
		-- 将魂
		iconBg= ItemSprite.getSoulIconSprite()
		iconName = GetLocalizeStringBy("key_1616")
		local quality = ItemSprite.getSoulQuality()
        nameColor = HeroPublicLua.getCCColorByStarLevel(quality)
	elseif(cellValues.type == "gold") then
		-- 金币
		iconBg= ItemSprite.getGoldIconSprite()
		iconName = GetLocalizeStringBy("key_1491")
		local quality = ItemSprite.getGoldQuality()
        nameColor = HeroPublicLua.getCCColorByStarLevel(quality)
	elseif(cellValues.type == "item") then
		-- 物品
		iconBg =  ItemSprite.getItemSpriteById(tonumber(cellValues.tid),nil, nil, nil, -130, nil, -500)
		local itemData = ItemUtil.getItemById(cellValues.tid)
        iconName = itemData.name
        nameColor = HeroPublicLua.getCCColorByStarLevel(itemData.quality)
	elseif(cellValues.type == "hero") then
		-- 英雄
		require "db/DB_Heroes"
		iconBg = ItemSprite.getHeroIconItemByhtid(cellValues.tid,-130)
		local heroData = DB_Heroes.getDataById(cellValues.tid)
		iconName = heroData.name
		nameColor = HeroPublicLua.getCCColorByStarLevel(heroData.star_lv)
	elseif(cellValues.type == "prestige") then
		-- 声望
		iconBg= ItemSprite.getPrestigeSprite()
		iconName = GetLocalizeStringBy("key_2231")
		local quality = ItemSprite.getPrestigeQuality()
        nameColor = HeroPublicLua.getCCColorByStarLevel(quality)
    elseif(cellValues.type == "jewel") then
		-- 魂玉
		iconBg= ItemSprite.getJewelSprite()
		iconName = GetLocalizeStringBy("key_1510")
		local quality = ItemSprite.getJewelQuality()
        nameColor = HeroPublicLua.getCCColorByStarLevel(quality)
    elseif(cellValues.type == "execution") then
		-- 体力
		iconBg= ItemSprite.getExecutionSprite()
		iconName = GetLocalizeStringBy("key_1032")
		local quality = ItemSprite.getExecutionQuality()
        nameColor = HeroPublicLua.getCCColorByStarLevel(quality)
    elseif(cellValues.type == "stamina") then
		-- 耐力
		iconBg= ItemSprite.getStaminaSprite()
		iconName = GetLocalizeStringBy("key_2021")
		local quality = ItemSprite.getStaminaQuality()
        nameColor = HeroPublicLua.getCCColorByStarLevel(quality)
	end
	iconBg:setAnchorPoint(ccp(0,1))
	iconBg:setPosition(ccp(10,120))
	cell:addChild(iconBg)

	-- 物品数量
	if( tonumber(cellValues.num) > 1 )then
		local numberLabel =  CCRenderLabel:create("" .. cellValues.num , g_sFontName,21,2,ccc3(0x00,0x00,0x00),type_stroke)
		numberLabel:setColor(ccc3(0x00,0xff,0x18))
		numberLabel:setAnchorPoint(ccp(0,0))
		local width = iconBg:getContentSize().width - numberLabel:getContentSize().width - 6
		numberLabel:setPosition(ccp(width,5))
		iconBg:addChild(numberLabel)
	end

	--- desc 物品名字
	local descLabel = CCRenderLabel:create("" .. iconName , g_sFontName,21,1,ccc3(0x00,0x00,0x00),type_stroke)
	descLabel:setColor(nameColor)
	descLabel:setAnchorPoint(ccp(0.5,0.5))
	descLabel:setPosition(ccp(iconBg:getContentSize().width*0.5 ,-iconBg:getContentSize().height*0.1-2))
	iconBg:addChild(descLabel)

	return cell
end




