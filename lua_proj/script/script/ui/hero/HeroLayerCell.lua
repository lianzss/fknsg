-- Filename: HeroLayerCell.lua.
-- Author: fang.
-- Date: 2013-07-07
-- Purpose: 该文件用于实现GetLocalizeStringBy("key_3191")cell

module ("HeroLayerCell", package.seeall)

local function createStars(filename, count, start_position, space)
	local stars = CCSprite:create(filename)
	local size = stars:getContentSize()
	stars:setPosition(start_position)
	local x = size.width + space
	for i=2, count do
		local tmp = CCSprite:create(filename)
		tmp:setPosition(ccp(x, 0))
		x = x + size.width + space
		stars:addChild(tmp)
	end

	return stars
end

function createCell(tCellValue)
	-- print("hero list tCellValue:")
	-- print_t(tCellValue)

	local ccCell = CCTableViewCell:create()
	-- 背景
	local cellBg = CCSprite:create("images/hero/attr_bg.png")
	cellBg:setAnchorPoint(ccp(0, 0))
	if (tCellValue.tag_bg) then
		ccCell:addChild(cellBg, 1, tCellValue.tag_bg)
	else
		ccCell:addChild(cellBg, 1, 9001)
	end

	-- 武将所属国家
	if tCellValue.country_icon then
		local country = CCSprite:create(tCellValue.country_icon)
		country:setAnchorPoint(ccp(0, 0))
		country:setPosition(ccp(16, 105))
		cellBg:addChild(country)
	end
	-- 武将等级
	local lv = CCLabelTTF:create("Lv."..tCellValue.level, g_sFontName, 20, CCSizeMake(130, 30), kCCTextAlignmentCenter)
	lv:setPosition(30, 105)
	lv:setColor(ccc3(0xff, 0xee, 0x3a))
	cellBg:addChild(lv)
	-- 武将名称
	local name = CCLabelTTF:create(tCellValue.name, g_sFontName, 22, CCSizeMake(136, 30), kCCTextAlignmentCenter)
	name:setPosition(139, 106)
	local cccQuality = HeroPublicLua.getCCColorByStarLevel(tCellValue.star_lv)
	name:setColor(cccQuality)
	cellBg:addChild(name)
	-- 星级
	local ccStarLv = createStars("images/hero/star.png", tCellValue.star_lv, ccp(290, 112), 4)
	cellBg:addChild(ccStarLv)
	-- 已上阵
	if tCellValue.isBusy then
		local being_front = CCSprite:create("images/hero/being_fronted.png")
		being_front:setPosition(ccp(534, 82))
		cellBg:addChild(being_front)
	end
		-- 是不是主角
	local dressId = nil
	if(HeroModel.isNecessaryHero(tCellValue.htid)) then
		dressId = UserModel.getDressIdByPos(1)
		print("主角 dressId = ",dressId)
	end
	local head_icon_bg = HeroPublicCC.createHeroHeadIcon(tCellValue, dressId)
	if tCellValue.hero_cb then
		head_icon_bg:registerScriptTapHandler(tCellValue.hero_cb)
	end
	--新武将表示 
	require "script/model/hero/HeroModel"
	if(HeroModel.isNewHero(tCellValue.hid) == true) then
		local newAnimSprite = CCLayerSprite:layerSpriteWithName(CCString:create("images/mail/new/new"), -1,CCString:create(""));
        newAnimSprite:setPosition(ccp(head_icon_bg:getContentSize().width*0.5-20,head_icon_bg:getContentSize().height-20))
       	head_icon_bg:addChild(newAnimSprite,3,10)
	end

	-- added by zhz 
	if(tCellValue.lock and tonumber(tCellValue.lock) ==1) then
		local lockSp= CCSprite:create("images/hero/lock.png")
		lockSp:setPosition(241,44)
		cellBg:addChild(lockSp)
	end

	if tCellValue.heroQuality == nil then
		tCellValue.heroQuality = DB_Heroes.getDataById(tCellValue.htid).heroQuality
	end
	-- 战斗力值
	local force_value = CCLabelTTF:create(GetLocalizeStringBy("key_2871") .. tCellValue.heroQuality, g_sFontName, 24, CCSizeMake(200, 30), kCCTextAlignmentLeft)
	force_value:setPosition(ccp(120, 44))
	force_value:setColor(ccc3(0x48, 0x1b, 0))
	cellBg:addChild(force_value)

	-- 进阶，强化Menu，头像，均为MenuItem
	local menu_ms = CCMenu:create()
    menu_ms:setTouchPriority(-395)
	if tCellValue.hero_tag then
		menu_ms:addChild(head_icon_bg, 0, tCellValue.hero_tag)
	else
		menu_ms:addChild(head_icon_bg)
	end
	if (tCellValue.type == nil) then
		createTSMenuItems(menu_ms, tCellValue)
	elseif (tCellValue.type == "StarSell") then
		local ccSilverIcon = CCSprite:create("images/common/coin_silver.png")
		ccSilverIcon:setPosition(ccp(360, 46))
		cellBg:addChild(ccSilverIcon)
		--		local ccLabelSilverNumber = CCLabelTTF:create(tCellValue.price, g_sFontName, 24)
		local ccLabelSilverNumber = CCRenderLabel:create(tCellValue.price, g_sFontName, 24, 1, ccc3(0, 0, 0), type_stroke)
		ccLabelSilverNumber:setPosition(400, 46)
		ccLabelSilverNumber:setColor(ccc3(0x6c, 0xff, 0))
		ccLabelSilverNumber:setAnchorPoint(ccp(0, 0))
		cellBg:addChild(ccLabelSilverNumber)
		--createCheckMenuItems(menu_ms, tCellValue)

		local ccSpriteCheckBg = CCSprite:create(tCellValue.menu_items[1].normal)
		ccSpriteCheckBg:setPosition(tCellValue.menu_items[1].pos_x, tCellValue.menu_items[1].pos_y)
		local ccSpriteSelected = CCSprite:create("images/common/checked.png")
		if (tCellValue.checkIsSelected) then
			ccSpriteSelected:setVisible(true)
		else
			ccSpriteSelected:setVisible(false)
		end
		ccSpriteCheckBg:addChild(ccSpriteSelected, 0, 10002)
		cellBg:addChild(ccSpriteCheckBg, 0, 10001)
	elseif tCellValue.type == "HeroSelect" then
		-- 不需要GetLocalizeStringBy("key_3417")标识
		if not tCellValue.withoutExp then
			-- 经验值图标
			local ccSpriteExp = CCSprite:create("images/common/exp.png")
			ccSpriteExp:setPosition(ccp(360, 46))
			cellBg:addChild(ccSpriteExp)
			-- 经验值数据
			local ccLabelSExp = CCRenderLabel:create(tCellValue.soul, g_sFontName, 24, 1, ccc3(0, 0, 0), type_stroke)
			ccLabelSExp:setPosition(420, 46)
			ccLabelSExp:setAnchorPoint(ccp(0, 0))
			ccLabelSExp:setColor(ccc3(0x6c, 0xff, 0))
			cellBg:addChild(ccLabelSExp)
		end
		local ccSpriteCheckBg = CCSprite:create(tCellValue.menu_items[1].normal)
		ccSpriteCheckBg:setPosition(tCellValue.menu_items[1].pos_x, tCellValue.menu_items[1].pos_y)
		local ccSpriteSelected = CCSprite:create("images/common/checked.png")
		if (tCellValue.checkIsSelected) then
			ccSpriteSelected:setVisible(true)
		else
			ccSpriteSelected:setVisible(false)
		end
		ccSpriteCheckBg:addChild(ccSpriteSelected, 0, 10002)
		cellBg:addChild(ccSpriteCheckBg, 0, 10001)
	end
	if (tCellValue.menu_tag) then
		cellBg:addChild(menu_ms, 0, tCellValue.menu_tag)
	else
		cellBg:addChild(menu_ms)
	end
	
	menu_ms:setPosition(ccp(0, 0))
	-- 如果在新手引导情况下
	if tCellValue.isNoviceGuiding then
		local rect = CCRectMake(0, 0, 3, 3)
		local rectInsets = CCRectMake(1, 1, 1, 1)
		local csTransparent = CCScale9Sprite:create("images/common/transparent.png", rect, rectInsets)
		local tBgSize = cellBg:getContentSize()
		csTransparent:setPosition(tBgSize.width/2, 0)
		csTransparent:setPreferredSize(CCSizeMake(tBgSize.width/2, tBgSize.height))
		cellBg:addChild(csTransparent, 0, 30001)
	end

	return ccCell
end
-- 进阶，强化Menu，头像，均为MenuItem
function createTSMenuItems(menu_ms, tCellValue)
	if(tCellValue.isAvatar) then 
		local item1 = tCellValue.menu_items[1]
	 	local item2 = tCellValue.menu_items[2]

		require "script/libs/LuaCCMenuItem"
	 	local tSprite = {normal="images/common/btn/btn_blue_n.png", selected="images/common/btn/btn_blue_h.png"}
	 	local tLabel = {text=GetLocalizeStringBy("key_2020"), fontsize=30, }
	 	local ccMenuItemDress = LuaCCMenuItem.createMenuItemOfRenderLabelOnSprite(tSprite, tLabel)
	 	ccMenuItemDress:setPosition(item2.pos_x, item2.pos_y)
		ccMenuItemDress:registerScriptTapHandler(function ( ... )
			require "script/audio/AudioUtil"
			AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
			--进入时装场景
			print("enter dress scene")
			MainScene.setMainSceneViewsVisible(true, false, true)
			require "script/ui/fashion/FashionLayer"
			local fashionLayer = FashionLayer:createFashion()
			MainScene.changeLayer(fashionLayer, "FashionLayer")
		end)
	 	menu_ms:addChild(ccMenuItemDress, 0, item2.tag)
	 	item2.ccObj = ccMenuItemDress


	 	tSprite = {normal="images/common/btn/green01_n.png", selected="images/common/btn/green01_h.png"}
	 	tLabel = {text=GetLocalizeStringBy("key_1730"), fontsize=30, }
	 	local ccMenuItemTransfer = LuaCCMenuItem.createMenuItemOfRenderLabelOnSprite(tSprite, tLabel)
	 	ccMenuItemTransfer:setPosition(item1.pos_x, item1.pos_y)
		ccMenuItemTransfer:registerScriptTapHandler(item1.cb)
	 	menu_ms:addChild(ccMenuItemTransfer, 0, item1.tag)
	 	item1.ccObj = ccMenuItemTransfer

	 	return
	end

	if #tCellValue.menu_items == 2 then
		local item
		local tSprite
		local tLabel

		require "script/libs/LuaCCMenuItem"

		require "script/ui/develop/DevelopData"

		if  DevelopData.doOpenDevelopByHid(tCellValue.hid) then
			item = tCellValue.menu_items[1]
			local ccMenuEvolution = CCMenuItemImage:create("images/develop/developup_btn_n.png", "images/develop/developup_btn_h.png")
			ccMenuEvolution:setAnchorPoint(ccp(0.5,0))
			ccMenuEvolution:setPosition(item.pos_x+67 , item.pos_y)
			ccMenuEvolution:registerScriptTapHandler(item.cb)
			menu_ms:addChild(ccMenuEvolution,0,item.tag)
			item.ccObj = ccMenuEvolution
		else 
			item = tCellValue.menu_items[1]
		 	tSprite = {normal="images/common/btn/green01_n.png", selected="images/common/btn/green01_h.png"}
		 	tLabel = {text=GetLocalizeStringBy("key_1730"), fontsize=30, }
		 	local ccMenuItemTransfer = LuaCCMenuItem.createMenuItemOfRenderLabelOnSprite(tSprite, tLabel)
		 	ccMenuItemTransfer:setPosition(item.pos_x, item.pos_y)
			ccMenuItemTransfer:registerScriptTapHandler(item.cb)
		 	menu_ms:addChild(ccMenuItemTransfer, 0, item.tag)
		 	item.ccObj = ccMenuItemTransfer
		end

	 	item = tCellValue.menu_items[2]
	 	tSprite = {normal="images/common/btn/purple01_n.png", selected="images/common/btn/purple01_h.png"}
	 	tLabel = {text=GetLocalizeStringBy("key_1269"), fontsize=30, }
	 	local ccMenuItemStrengthen = LuaCCMenuItem.createMenuItemOfRenderLabelOnSprite(tSprite, tLabel)
	 	ccMenuItemStrengthen:setPosition(item.pos_x, item.pos_y)
		ccMenuItemStrengthen:registerScriptTapHandler(item.cb)
	 	menu_ms:addChild(ccMenuItemStrengthen, 0, item.tag)
	 	item.ccObj = ccMenuItemStrengthen
	end
end

-- 出售界面复选框menu_item
function createCheckMenuItems(menu_ms, tCellValue)
	for i=1, #tCellValue.menu_items do
		local menu_item = CCMenuItemImage:create(tCellValue.menu_items[i].normal, tCellValue.menu_items[i].highlighted)
		menu_item:setPosition(ccp(tCellValue.menu_items[i].pos_x, tCellValue.menu_items[i].pos_y))
		local ccSpriteSelected = CCSprite:create("images/common/checked.png")
		if (tCellValue.checkIsSelected) then
			ccSpriteSelected:setVisible(true)
		else
			ccSpriteSelected:setVisible(false)
		end
		menu_item:addChild(ccSpriteSelected, 0, 4001)
		menu_item:registerScriptTapHandler(tCellValue.menu_items[i].cb)
		tCellValue.menu_items[i].ccObj = menu_item
		menu_ms:addChild(menu_item, 0, tCellValue.menu_items[i].tag)
	end
end

function startCellAnimate(cell, animatedIndex )
	local cellBg = tolua.cast(cell:getChildByTag(1), "CCSprite")
	cellBg:setPosition(ccp(cell:getContentSize().width, 0))
	cellBg:runAction(CCMoveTo:create(g_cellAnimateDuration * (animatedIndex ), ccp(0,0)))
end