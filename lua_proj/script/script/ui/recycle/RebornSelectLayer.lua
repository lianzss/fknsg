-- Filename: RebornSelectLayer.lua
-- Author: zhang zihang
-- Date: 2014-2-11
-- Purpose: 该文件用于: 重生选择界面

module ("RebornSelectLayer", package.seeall)

require "script/ui/main/MainScene"
require "script/ui/bag/EquipBagCell"
require "script/model/user/UserModel"
require "db/DB_Heroes"

function init()
	_ksTagSure = 5001

	_ksTagChooseHero = 1001
	_ksTagChooseItem = 1002
	_ksTagChooseCloth = 1003
	_ksTagChooseGood = 1004
	_ksTagCheckBg = 3001
	_ksTagTableViewBg = 201

	_nSelectedCount = 0
	_nItemCount = 0
	_nClothCount = 0
	_nGoodCount = 0

	--已选择武将数目栏
	_ccHeroCount = nil
	ccLabelSelected = nil
	_layerSize = nil
	layer = nil

	_menuHero = nil
	_menuItem = nil
	_menuCloth = nil
	_menuGood = nil

	_whereILocate = nil
	_heroLayer = nil
	_itemLayer = nil
	_clothLayer = nil
	_goodLayer = nil

	tBottomSize = nil
	topMenuBar = nil
	bulletinLayerSize = nil
	_tParentParam = nil
	_arrSelectedHeroes = nil
	_arrSelectedItems = nil
	_arrSelectedCloths = nil
	_arrSelectedGoods = nil
	_arrSign = nil
	_arrViewLocation = nil

	_arrHeroesValue = nil
	_arrItemValue = nil

	_scrollview_height = nil
	_selectId = nil

	_itemId = nil
	_clothId = nil
	_goodId = nil
end

function fnHandlerOfItemTouched(itemMenu,curBox)
	local isIn = curBox.isSelected
	if(isIn == true) then
		itemMenu:unselected()
		curBox.isSelected = false
		_nItemCount = _nItemCount-1
		_itemId = nil
	else
		--print("---------")
		--print_t(_tParentParam.filtersItem)
		for i = 1 ,#_tParentParam.filtersItem do
			local v = _tParentParam.filtersItem[i]
			if v.isSelected == true then
				local cellObject = tolua.cast(v.ccObj,"CCTableViewCell")
				if v and cellObject ~= nil then
					local cellBg = tolua.cast(cellObject:getChildByTag(1), "CCSprite")
					local menubar_m = tolua.cast(cellBg:getChildByTag(9898), "CCMenu")
					--print("+++++++++++++++",v.gid)
					local menuBtn_M = tolua.cast(menubar_m:getChildByTag(tonumber(v.gid)), "CCMenuItemSprite")
					menuBtn_M:unselected()
				end
				v.isSelected = false
				_nItemCount = _nItemCount-1
			end
		end
		_itemId = curBox.gid
		itemMenu:selected()
		curBox.isSelected = true
		_nItemCount = _nItemCount+1
	end
	fnUpdateSelectionInfo(_nItemCount)
end

function fnHandlerOfClothTouched(itemMenu,curBox)
	local isIn = curBox.isSelected
	if(isIn == true) then
		itemMenu:unselected()
		curBox.isSelected = false
		_nClothCount = _nClothCount-1
		_clothId = nil
	else
		--print("---------")
		--print_t(_tParentParam.filtersItem)
		for i = 1 ,#_tParentParam.filtersCloth do
			local v = _tParentParam.filtersCloth[i]
			if v.isSelected == true then
				local cellObject = tolua.cast(v.ccObj,"CCTableViewCell")
				if v and cellObject ~= nil then
					local cellBg = tolua.cast(cellObject:getChildByTag(1), "CCSprite")
					local menubar_m = tolua.cast(cellBg:getChildByTag(9898), "CCMenu")
					--print("+++++++++++++++",v.gid)
					local menuBtn_M = tolua.cast(menubar_m:getChildByTag(tonumber(v.gid)), "CCMenuItemSprite")
					menuBtn_M:unselected()
				end
				v.isSelected = false
				_nClothCount = _nClothCount-1
			end
		end
		_clothId = curBox.gid
		itemMenu:selected()
		curBox.isSelected = true
		_nClothCount = _nClothCount+1
	end
	fnUpdateSelectionInfo(_nClothCount)
end

function fnHandlerOfGoodTouched(itemMenu,curBox)
	local isIn = curBox.isSelected
	if(isIn == true) then
		itemMenu:unselected()
		curBox.isSelected = false
		_nGoodCount = _nGoodCount-1
		_goodId = nil
	else
		--print("---------")
		--print_t(_tParentParam.filtersItem)
		for i = 1 ,#_tParentParam.filtersGood do
			local v = _tParentParam.filtersGood[i]
			if v.isSelected == true then
				local cellObject = tolua.cast(v.ccObj,"CCTableViewCell")
				if v and cellObject ~= nil then
					local cellBg = tolua.cast(cellObject:getChildByTag(1), "CCSprite")
					local menubar_m = tolua.cast(cellBg:getChildByTag(9898), "CCMenu")
					--print("+++++++++++++++",v.gid)
					local menuBtn_M = tolua.cast(menubar_m:getChildByTag(tonumber(v.gid)), "CCMenuItemSprite")
					menuBtn_M:unselected()
				end
				v.isSelected = false
				_nGoodCount = _nGoodCount-1
			end
		end
		_goodId = curBox.gid
		itemMenu:selected()
		curBox.isSelected = true
		_nGoodCount = _nGoodCount+1
	end
	fnUpdateSelectionInfo(_nGoodCount)
end

function checkedAction(tag, itemMenu)
	for k,v in pairs(_tParentParam.filtersItem) do
		if tonumber(v.gid) == tonumber(itemMenu:getTag()) then
			fnHandlerOfItemTouched(itemMenu,v)
		end
	end
end

function checkedClothAction(tag, itemMenu)
	for k,v in pairs(_tParentParam.filtersCloth) do
		if tonumber(v.gid) == tonumber(itemMenu:getTag()) then
			fnHandlerOfClothTouched(itemMenu,v)
		end
	end
end

function  checkedGoodAction(tag, itemMenu)
	for k,v in pairs(_tParentParam.filtersGood) do
		if tonumber(v.gid) == tonumber(itemMenu:getTag()) then
			fnHandlerOfGoodTouched(itemMenu,v)
		end
	end
end

function createEquipCell( equipData, isSell)
	local tCell = CCTableViewCell:create()
	--背景
	local cellBg = CCSprite:create("images/bag/equip/equip_cellbg.png")
	cellBg:setAnchorPoint(ccp(0,0))
	tCell:addChild(cellBg,1,1)
	local cellBgSize = cellBg:getContentSize()

	-- icon
	local iconSprite = ItemSprite.getItemSpriteByItemId( tonumber(equipData.item_template_id))
	iconSprite:setAnchorPoint(ccp(0.5, 0.5))
	iconSprite:setPosition(ccp(cellBgSize.width * 0.1, cellBgSize.height * 0.55))
	cellBg:addChild(iconSprite)

	if(equipData.itemDesc.jobLimit and equipData.itemDesc.jobLimit > 0)then
		local suitTagSprite = CCSprite:create("images/common/suit_tag.png")
		suitTagSprite:setAnchorPoint(ccp(0.5, 0.5))
		suitTagSprite:setPosition(ccp(iconSprite:getContentSize().width*0.25, iconSprite:getContentSize().height*0.9))
		iconSprite:addChild(suitTagSprite)
	end

	-- 等级
	local levelLabel = CCRenderLabel:create(equipData.va_item_text.armReinforceLevel, g_sFontName, 21, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
    -- levelLabel:setSourceAndTargetColor(ccc3( 0x36, 0xff, 0x00), ccc3( 0x36, 0xff, 0x00));
    levelLabel:setColor(ccc3(0xff, 0xf6, 0x00))
    -- levelLabel:setAnchorPoint(ccp(0,0))
    levelLabel:setPosition(ccp(cellBgSize.width*0.1, cellBgSize.height*0.26))
    cellBg:addChild(levelLabel)

	-- 印章
    local sealSprite = BagUtil.getSealSpriteByItemTempId(equipData.item_template_id)
    sealSprite:setAnchorPoint(ccp(0, 0.5))
    sealSprite:setPosition(ccp(cellBgSize.width*0.2, cellBgSize.height*0.8))
    cellBg:addChild(sealSprite)

	-- 名称
	local nameColor = HeroPublicLua.getCCColorByStarLevel(equipData.itemDesc.quality)
	local nameLabel = CCRenderLabel:create(equipData.itemDesc.name, g_sFontName, 28, 2, ccc3( 0x00, 0x00, 0x00), type_stroke)
    nameLabel:setColor(nameColor)
    nameLabel:setAnchorPoint(ccp(0,0.5))
    nameLabel:setPosition(ccp(cellBgSize.width*0.2 + sealSprite:getContentSize().width + 0.5, cellBgSize.height*0.8))
    cellBg:addChild(nameLabel)

	-- 品质
    local starSp = CCSprite:create("images/formation/changeequip/star.png")
    starSp:setAnchorPoint(ccp(0.5, 0.5))
    starSp:setPosition(ccp( cellBgSize.width*370.0/640, cellBgSize.height*0.8))
    cellBg:addChild(starSp)

	-- 星级
    local potentialLabel = CCRenderLabel:create(equipData.itemDesc.quality, g_sFontName,25, 1, ccc3(0x00, 0x00, 0x00), type_stroke)
    potentialLabel:setColor(ccc3(0xff, 0xf6, 0x00))
    potentialLabel:setPosition(cellBgSize.width*330.0/640, cellBgSize.height*0.87)
    cellBg:addChild(potentialLabel)

    -- 获得相关数值
	local t_numerial, t_numerial_pl, t_equip_score = ItemUtil.getTop2NumeralByIID( tonumber(equipData.item_id))
	local descString = ""
	for key,v_num in pairs(t_numerial) do
		if (key == "hp") then
			descString = descString .. GetLocalizeStringBy("key_1765")
		elseif (key == "gen_att") then
			descString = descString .. GetLocalizeStringBy("key_2980")
		elseif(key == "phy_att"  )then
			descString = descString .. GetLocalizeStringBy("key_2958") 
		elseif(key == "magic_att")then
			descString = descString .. GetLocalizeStringBy("key_1536")
		elseif(key == "phy_def"  )then
			descString = descString .. GetLocalizeStringBy("key_1588") 
		elseif(key == "magic_def")then
			descString = descString .. GetLocalizeStringBy("key_3133") 
		end
		descString = descString .."+".. v_num .. "\n"
	end

	-- 描述
	local descLabel = CCLabelTTF:create(descString, g_sFontName, 23, CCSizeMake(300, 80), kCCTextAlignmentLeft, kCCVerticalTextAlignmentTop)
	descLabel:setColor(ccc3(0x78, 0x25, 0x00))
	descLabel:setAnchorPoint(ccp(0, 0.5))
	descLabel:setPosition(ccp(cellBgSize.width*0.21, cellBgSize.height*0.4))
	cellBg:addChild(descLabel)

	-- 评分
	local equipScoreLabel = CCRenderLabel:create(t_equip_score, g_sFontName, 22, 1, ccc3( 0x00, 0x00, 0x0d), type_stroke)
    equipScoreLabel:setColor(ccc3(0x8a, 0xff, 0x00))
    equipScoreLabel:setPosition(ccp((cellBgSize.width*1.05-equipScoreLabel:getContentSize().width)/2, cellBgSize.height*0.35))
    cellBg:addChild(equipScoreLabel)

    -- 按钮
	local menuBar = CCMenu:create()
	menuBar:setPosition(ccp(0,0))
	cellBg:addChild(menuBar,1, 9898)
	-- local enhanceBtn = LuaMenuItem.createItemImage("images/bag/item/btn_use_n.png", "images/bag/item/btn_use_h.png" )
	-- enhanceBtn:setAnchorPoint(ccp(0.5, 0.5))
 	-- enhanceBtn:setPosition(MainScene.getMenuPositionInTruePoint(cellBgSize.width*520/640, cellBgSize.height*0.5))
 	-- enhanceBtn:registerScriptTapHandler(enhanceAction)
	-- menuBar:addChild(enhanceBtn, 1, equipData.gid)

	-- 复选框
	local checkedBtn = CheckBoxItem.create()
	checkedBtn:setAnchorPoint(ccp(0.5, 0.5))
    checkedBtn:setPosition(ccp(cellBgSize.width*580/640, cellBgSize.height*0.5))
    checkedBtn:registerScriptTapHandler(checkedAction)
    print("======== ",equipData.gid)
	menuBar:addChild(checkedBtn, 1, tonumber(equipData.gid))
	if isSell == true then
		checkedBtn:selected()
	else
		checkedBtn:unselected()
	end
	--handleCheckedBtn(checkedBtn)

	if(equipData.equip_hid and tonumber(equipData.equip_hid) > 0)then
		-- local being_front = CCSprite:create("images/hero/being_fronted.png")
		-- being_front:setPosition(ccp(532, 88))
		-- cellBg:addChild(being_front)
		local localHero = HeroUtil.getHeroInfoByHid(equipData.equip_hid)
		local heroName = localHero.localInfo.name
		if(HeroModel.isNecessaryHeroByHid(equipData.equip_hid)) then
			heroName = UserModel.getUserName()
		end
		local onFormationText =  CCRenderLabel:create(GetLocalizeStringBy("key_1783").. heroName, g_sFontName, 22, 1, ccc3( 0x00, 0x00, 0x0d), type_stroke)
	    onFormationText:setColor(ccc3(0x8a, 0xff, 0x00))
	    onFormationText:setPosition(ccp(cellBgSize.width*0.7, cellBgSize.height*0.85))
	    cellBg:addChild(onFormationText)
	end

	return tCell
end

function createClothCell(treasData, isSell)
	local tCell = CCTableViewCell:create()

	--背景
	print("the treasData is ")
	print_t(treasData)
	local cellBg = CCSprite:create("images/bag/equip/treas_cellbg.png")
	cellBg:setAnchorPoint(ccp(0,0))
	tCell:addChild(cellBg,1,1)
	local cellBgSize = cellBg:getContentSize()

	-- require "db/DB_Item_dress"
	-- local fashionInfo = HeroModel.getNecessaryHero().equip.dress
	-- print_t(fashionInfo)
	local dressHtid = treasData.item_template_id
	print("the dressHtid is >>>>>>",dressHtid)
	-- icon
	local iconSprite = ItemSprite.getItemSpriteByItemId(dressHtid)
	iconSprite:setAnchorPoint(ccp(0.5, 0.5))
	iconSprite:setPosition(ccp(cellBgSize.width * 0.1, cellBgSize.height * 0.55))
	cellBg:addChild(iconSprite)

	-- 等级
    local lvSprite = CCSprite:create("images/common/lv.png")
    lvSprite:setPosition(ccp(30, cellBgSize.height*0.2))
    lvSprite:setAnchorPoint(ccp(0, 0.5))
    cellBg:addChild(lvSprite)

	local t_level = 0
	if( (not table.isEmpty(treasData.va_item_text) and treasData.va_item_text.dressLevel ))then
		t_level = treasData.va_item_text.dressLevel
	end
	local levelLabel = CCRenderLabel:create(t_level, g_sFontPangWa, 21, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
    levelLabel:setColor(ccc3(0x2c, 0xdb, 0x23))
    levelLabel:setAnchorPoint(ccp(0.5,0.5))
    levelLabel:setPosition(ccp(80, cellBgSize.height*0.2))
    cellBg:addChild(levelLabel)

    --时装标签
 	local iconName = CCSprite:create("images/fashion/fashion_icon2.png")
    iconName:setAnchorPoint(ccp(0.5, 0))
    iconName:setPosition(ccp(150, 120))
    cellBg:addChild(iconName)

-- 名称
	local name = nil
	local nameColor = HeroPublicLua.getCCColorByStarLevel(treasData.itemDesc.quality)

	local oldhtid = UserModel.getAvatarHtid()
	local model_id = DB_Heroes.getDataById(tonumber(oldhtid)).model_id
	print("the model_id is"..model_id)
	print_t(treasData.itemDesc.name)

    local nameArray = lua_string_split(treasData.itemDesc.name, ",")
    for k,v in pairs(nameArray) do
    	local array = lua_string_split(v, "|")
    	print("the array is")
    	print_t(array)
    	if(tonumber(array[1]) == tonumber(model_id)) then
			name = array[2]
			break
    	end
    end

	local nameLabel = CCRenderLabel:create(name, g_sFontName, 28, 2, ccc3( 0x00, 0x00, 0x00), type_stroke)
    nameLabel:setColor(nameColor)
    nameLabel:setAnchorPoint(ccp(0, 0.5))
    nameLabel:setPosition(ccp(cellBgSize.width*0.2+ iconName:getContentSize().width+5, cellBgSize.height*0.8))
    cellBg:addChild(nameLabel)    

-- 品质
    local starSp = CCSprite:create("images/formation/changeequip/star.png")
    starSp:setAnchorPoint(ccp(0.5, 0.5))
    starSp:setPosition(ccp( cellBgSize.width*370.0/640 + 50, cellBgSize.height*0.8))
    cellBg:addChild(starSp)

	-- 星级
    local potentialLabel = CCRenderLabel:create(treasData.itemDesc.quality, g_sFontName,25, 1, ccc3(0x00, 0x00, 0x00), type_stroke)
    potentialLabel:setColor(ccc3(0xff, 0xf6, 0x00))
    potentialLabel:setPosition(cellBgSize.width*330.0/640 + 50, cellBgSize.height*0.87)
    cellBg:addChild(potentialLabel)

    -- 获得相关数值
    require "db/DB_Item_dress"
    require "script/ui/fashion/FashionData"
	local localData = DB_Item_dress.getDataById(dressHtid)
	local monsterIds = FashionData.getAttrByItemData(treasData,t_level)
	local descString = "" --GetLocalizeStringBy("key_2137") .. enhanceLv .. "\n"
	local i = 0
	for k,v in pairs(monsterIds) do
		i = i+1
		descString = descString .. v.desc.displayName .."+".. v.displayNum .. "\n"
		if(i == 4)then
			break
		end
	end

	-- 描述
	local descLabel = CCLabelTTF:create(descString, g_sFontName, 21, CCSizeMake(300, 80), kCCTextAlignmentLeft, kCCVerticalTextAlignmentTop)
	descLabel:setColor(ccc3(0x78, 0x25, 0x00))
	descLabel:setAnchorPoint(ccp(0, 0.5))
	descLabel:setPosition(ccp(cellBgSize.width*0.21, cellBgSize.height*0.4))
	cellBg:addChild(descLabel)

	-- 评分
	local equipScoreLabel = CCRenderLabel:create(localData.score or 0, g_sFontName, 22, 1, ccc3( 0x00, 0x00, 0x0d), type_stroke)
    equipScoreLabel:setColor(ccc3(0x8a, 0xff, 0x00))
    -- equipScoreLabel:setAnchorPoint(ccp(0,0))
    equipScoreLabel:setPosition(ccp((cellBgSize.width*1.05-equipScoreLabel:getContentSize().width)/2, cellBgSize.height*0.35))
    cellBg:addChild(equipScoreLabel)

    -- 选择框
    local menuBar = CCMenu:create()
	menuBar:setPosition(ccp(0,0))
	cellBg:addChild(menuBar,1, 9898)

	local checkedBtn = CheckBoxItem.create()
	checkedBtn:setAnchorPoint(ccp(0.5, 0.5))
    checkedBtn:setPosition(ccp(cellBgSize.width*580/640, cellBgSize.height*0.5))
    checkedBtn:registerScriptTapHandler(checkedClothAction)
    checkedBtn:setEnabled(false)
    
	menuBar:addChild(checkedBtn, 1, treasData.gid)

	if isSell == true then
		checkedBtn:selected()
	else
		checkedBtn:unselected()
	end

	return tCell
end

function createGoodCell(treasData, isSell)
	local tCell = CCTableViewCell:create()
	--背景
	local cellBg = CCSprite:create("images/bag/equip/treas_cellbg.png")
	cellBg:setAnchorPoint(ccp(0,0))
	tCell:addChild(cellBg,1,1)
	local cellBgSize = cellBg:getContentSize()

	-- icon
	local iconSprite = ItemSprite.getItemSpriteByItemId( tonumber(treasData.item_template_id))
	iconSprite:setAnchorPoint(ccp(0.5, 0.5))
	iconSprite:setPosition(ccp(cellBgSize.width * 0.1, cellBgSize.height * 0.55))
	cellBg:addChild(iconSprite)

	-- 等级
	local t_level = 0
	if( (not table.isEmpty(treasData.va_item_text) and treasData.va_item_text.treasureLevel ))then
		t_level = treasData.va_item_text.treasureLevel
	end
	local levelLabel = CCRenderLabel:create("+" .. t_level, g_sFontPangWa, 21, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
    levelLabel:setColor(ccc3(0x2c, 0xdb, 0x23))
    levelLabel:setAnchorPoint(ccp(0.5,0.5))
    levelLabel:setPosition(ccp(cellBgSize.width*0.1, cellBgSize.height*0.2))
    cellBg:addChild(levelLabel)

    -- 印章
    local sealSprite = BagUtil.getSealSpriteByItemTempId(treasData.item_template_id)
    sealSprite:setAnchorPoint(ccp(0, 0.5))
    sealSprite:setPosition(ccp(cellBgSize.width*0.2, cellBgSize.height*0.8))
    cellBg:addChild(sealSprite)

	-- 名称
	local nameColor = HeroPublicLua.getCCColorByStarLevel(treasData.itemDesc.quality)
	local nameLabel = CCRenderLabel:create(treasData.itemDesc.name, g_sFontName, 28, 2, ccc3( 0x00, 0x00, 0x00), type_stroke)
    nameLabel:setColor(nameColor)
    nameLabel:setAnchorPoint(ccp(0, 0.5))
    nameLabel:setPosition(ccp(cellBgSize.width*0.2+ sealSprite:getContentSize().width+5, cellBgSize.height*0.8))
    cellBg:addChild(nameLabel)

	-- 品质
    local starSp = CCSprite:create("images/formation/changeequip/star.png")
    starSp:setAnchorPoint(ccp(0.5, 0.5))
    starSp:setPosition(ccp( cellBgSize.width*370.0/640, cellBgSize.height*0.8))
    cellBg:addChild(starSp)

	-- 星级
    local potentialLabel = CCRenderLabel:create(treasData.itemDesc.quality, g_sFontName,25, 1, ccc3(0x00, 0x00, 0x00), type_stroke)
    potentialLabel:setColor(ccc3(0xff, 0xf6, 0x00))
    potentialLabel:setPosition(cellBgSize.width*330.0/640, cellBgSize.height*0.87)
    cellBg:addChild(potentialLabel)

    -- 获得相关数值
	local attr_arr, score_t, ext_active = ItemUtil.getTreasAttrByItemId( tonumber(treasData.item_id), treasData)
	local descString = ""
	for key,attr_info in pairs(attr_arr) do
	    local affixDesc, displayNum = ItemUtil.getAtrrNameAndNum(attr_info.attId, attr_info.num)
	    descString = descString .. affixDesc.sigleName .. " +"
		descString = descString .. displayNum .. "\n"
	end

	-- 描述
	local descLabel = CCLabelTTF:create(descString, g_sFontName, 23, CCSizeMake(300, 80), kCCTextAlignmentLeft, kCCVerticalTextAlignmentTop)
	descLabel:setColor(ccc3(0x78, 0x25, 0x00))
	descLabel:setAnchorPoint(ccp(0, 0.5))
	descLabel:setPosition(ccp(cellBgSize.width*0.21, cellBgSize.height*0.4))
	cellBg:addChild(descLabel)

	-- 评分
	local equipScoreLabel = CCRenderLabel:create(score_t.num, g_sFontName, 22, 1, ccc3( 0x00, 0x00, 0x0d), type_stroke)
    equipScoreLabel:setColor(ccc3(0x8a, 0xff, 0x00))
    -- equipScoreLabel:setAnchorPoint(ccp(0,0))
    equipScoreLabel:setPosition(ccp((cellBgSize.width*1.05-equipScoreLabel:getContentSize().width)/2, cellBgSize.height*0.35))
    cellBg:addChild(equipScoreLabel)

    -- 按钮
	local menuBar = CCMenu:create()
	menuBar:setPosition(ccp(0,0))
	cellBg:addChild(menuBar,1, 9898)
	
	-- local coinBg = CCSprite:create("images/common/coin.png")
	-- coinBg:setAnchorPoint(ccp(0.5, 0.5))
	-- coinBg:setPosition(ccp(cellBgSize.width*0.7, cellBgSize.height*0.5))
	-- cellBg:addChild(coinBg)

	-- 卖多少
	-- local coinLabel = CCRenderLabel:create( BagLayer.getPriceByEquipData(treasData), g_sFontName, 24, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	-- coinLabel:setColor(ccc3(0x6c, 0xff, 0x00))
	-- coinLabel:setAnchorPoint(ccp(0, 0.5))
	-- coinLabel:setPosition(ccp(cellBgSize.width*0.73, cellBgSize.height*0.5))
	-- cellBg:addChild(coinLabel)

	-- 复选框
	local checkedBtn = CheckBoxItem.create()
	checkedBtn:setAnchorPoint(ccp(0.5, 0.5))
    checkedBtn:setPosition(ccp(cellBgSize.width*580/640, cellBgSize.height*0.5))
    checkedBtn:registerScriptTapHandler(checkedGoodAction)
    checkedBtn:setEnabled(false)
    
	menuBar:addChild(checkedBtn, 1, treasData.gid)
	--handleCheckedBtn(checkedBtn)

	if isSell == true then
		checkedBtn:selected()
	else
		checkedBtn:unselected()
	end

	return tCell
end

--武将列表更新底栏
function fnUpdateSelectionInfo(num)
	_ccHeroCount:setString(tostring(num) .. "/1")
end

--武将列表
function getHeroList(tParam)
	require "script/model/hero/HeroModel"
	require "db/DB_Heroes"
	local hids = HeroModel.getAllHeroesHid()
	local heroesValue = {}

	-- scrollview内容cell中的按钮
	local _cell_menu_item_data = {
		{normal="images/common/checkbg.png", highlighted="images/common/checkbg.png", 
		pos_x=548, pos_y=46, tag=_ksTagCheckBg, 
		ccObj=nil, focus=true, cb=menu_item_tap_handler}
	}

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
			local thisHero = DB_Heroes.getDataById(value.htid)
			value.name = thisHero.name
			value.rebirth_gold = thisHero.rebirth_basegold
			value.level = hero.level
			value.evolve_level = hero.evolve_level

			print("##################################")
			print(value.level)

			local db_hero = DB_Heroes.getDataById(value.htid)
			value.country_icon = HeroModel.getCiconByCidAndlevel(db_hero.country, db_hero.star_lv)
			value.name = db_hero.name

			value.star_lv = db_hero.star_lv
			print(value.star_lv)
			value.head_icon = "images/base/hero/head_icon/" .. db_hero.head_icon_id
			value.quality_bg = "images/hero/quality/"..value.star_lv .. ".png"
			value.quality_h = "images/hero/quality/highlighted.png"

			value.withoutExp = true

			--添加选择按钮
			value.menu_items = {}
			table.hcopy(_cell_menu_item_data, value.menu_items)
			for j=1, #value.menu_items do
				value.menu_items[j].tag = value.menu_items[j].tag + #heroesValue
			end
			value.type = "HeroSelect"

			-- 判断是否默认为选中
			local bIsSelected = false
			if _arrSelectedHeroes and _arrSelectedHeroes.hid ~= nil then
				if value.hid == _arrSelectedHeroes.hid then
					bIsSelected = true
				end
			end
			value.checkIsSelected = bIsSelected
			value.menu_tag = _ksTagTableViewMenu
			value.tag_bg = _ksTagTableViewBg
			--value.fight_value = HeroFightForce.getAllForceValues(value).fightForce
			heroesValue[#heroesValue+1] = value
		end
	end
	print("heroesValue = :")
	print_t(heroesValue)

	-- 按战斗力值排序
	local function sort(w1, w2)
		if tonumber(w1.star_lv) < tonumber(w2.star_lv) then
			return true
		elseif tonumber(w1.star_lv) == tonumber(w2.star_lv) then
			if tonumber(w1.level) < tonumber(w2.level) then
				return true
			else 
				return false 
			end
		else 
			return false
		end
		--return w1.star_lv < w2.star_lv
	end

	table.sort(heroesValue, sort)

	return heroesValue
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
		for i = 1, #_arrHeroesValue do
			if _arrHeroesValue[i].checkIsSelected == true then
				print(GetLocalizeStringBy("key_2465"))
				print(_arrHeroesValue[i].hid)
				print(_arrHeroesValue[i].name)
				print("****************************************")

				local cellObject = tolua.cast(_arrHeroesValue[i].ccObj,"CCTableView")
				-- local cellSprite = _arrHeroesValue[i].ccObj:getChildByTag(_ksTagTableViewBg)
				if _arrHeroesValue[i] and  cellObject~= nil then
					local ccCellObj1 = tolua.cast(_arrHeroesValue[i].ccObj:getChildByTag(_ksTagTableViewBg), "CCSprite")
					local ccSpriteCheckBox1 = tolua.cast(ccCellObj1:getChildByTag(10001), "CCSprite")
					local ccSpriteSelected1 =  tolua.cast(ccSpriteCheckBox1:getChildByTag(10002), "CCSprite")
					ccSpriteSelected1:setVisible(false)
				end
				_arrHeroesValue[i].checkIsSelected = false
				_nSelectedCount = _nSelectedCount - 1
			end
		end
		_selectId = nIndex
		_arrHeroesValue[nIndex].checkIsSelected = true
		ccSpriteSelected:setVisible(true)
		print(GetLocalizeStringBy("key_2051"),_nSelectedCount)
		_nSelectedCount = _nSelectedCount + 1
	else
		_selectId = nil
		_arrHeroesValue[nIndex].checkIsSelected = false
		ccSpriteSelected:setVisible(false)
		_nSelectedCount = _nSelectedCount - 1
	end
	fnUpdateSelectionInfo(_nSelectedCount)
end

--创建武将选择tableView
function createHeroSellTableView()
	local cellBg = CCSprite:create("images/hero/attr_bg.png")
	local cellSize = cellBg:getContentSize()
	cellSize.width = cellSize.width * g_fScaleX
	cellSize.height = cellSize.height * g_fScaleX
	cellBg = nil

	local _visiableCellNum = math.floor(_scrollview_height/(cellSize.height*g_fScaleX))
	_arrHeroesValue = getHeroList(_tParentParam)

	require "script/ui/hero/HeroLayerCell"
	require "script/ui/hero/HeroFightSimple"
	local handler = LuaEventHandler:create(function(fn, table, a1, a2)
		local r
		if (fn == "cellSize") then
			r = CCSizeMake(cellSize.width, cellSize.height)
		elseif (fn == "cellAtIndex") then
			local len = #_arrHeroesValue
			local value = _arrHeroesValue[len-a1]
			if value.fight_value == nil or value.fight_value==0 then
				value.force_values =  HeroFightSimple.getAllForceValues(value)
				value.fight_value = value.force_values.fightForce
			end
			a2 = HeroLayerCell.createCell(value)
			a2:setScale(g_fScaleX)
			_arrHeroesValue[len-a1].ccObj = a2
			r = a2
		elseif (fn == "numberOfCells") then
			r = #_arrHeroesValue
		elseif (fn == "cellTouched") then
			fnHandlerOfCellTouched(a1:getIdx())
		end
		
		return r
	end)
	local tableView = LuaTableView:createWithHandler(handler, CCSizeMake(layer:getContentSize().width, _scrollview_height))
	tableView:setAnchorPoint(ccp(0, 0))
	tableView:setBounceable(true)

	return tableView
end

--创建装备tableView
function createItemSellTableview()
	local cellBg = CCSprite:create("images/bag/item/item_cellbg.png")
	local cellSize = cellBg:getContentSize()			--计算cell大小
	cellSize.width = cellSize.width * g_fScaleX
	cellSize.height = cellSize.height * g_fScaleX
	cellBg = nil

	local _visiableCellNum = math.floor(_scrollview_height/(cellSize.height*g_fScaleX))
	--_arrItemValue = getItemList(_tParentParam)

	local handler = LuaEventHandler:create(function(fn, table, a1, a2) 	--创建
		local r
		if fn == "cellSize" then
			r = CCSizeMake(cellSize.width, cellSize.height)
		elseif fn == "cellAtIndex" then
			if _tParentParam.filtersItem[a1+1].isSelected == true then
				a2 = createEquipCell(_tParentParam.filtersItem[a1 + 1], true)
			else
				a2 = createEquipCell(_tParentParam.filtersItem[a1 + 1], false)
			end
			a2:setScale(g_fScaleX)
			print("a1a1a1",a1)
			_tParentParam.filtersItem[a1+1].ccObj = a2
			r = a2
		elseif fn == "numberOfCells" then
			r = #_tParentParam.filtersItem
		elseif (fn == "cellTouched") then
			print("hihihi")
			local m_data = _tParentParam.filtersItem[a1:getIdx()+1]

			local cellBg = tolua.cast(a1:getChildByTag(1), "CCSprite")
			local menubar_m = tolua.cast(cellBg:getChildByTag(9898), "CCMenu")
			local menuBtn_M = tolua.cast(menubar_m:getChildByTag(tonumber(m_data.gid)), "CCMenuItemSprite")
			
			fnHandlerOfItemTouched(menuBtn_M,m_data)
		end
		
		return r
	end)
	local tableView = LuaTableView:createWithHandler(handler, CCSizeMake(layer:getContentSize().width, _scrollview_height))
	tableView:setAnchorPoint(ccp(0, 0))
	tableView:setBounceable(true)

	return tableView
end

function createClothTableView()
	local cellBg = CCSprite:create("images/bag/item/item_cellbg.png")
	local cellSize = cellBg:getContentSize()			--计算cell大小
	cellSize.width = cellSize.width * g_fScaleX
	cellSize.height = cellSize.height * g_fScaleX
	cellBg = nil

	local _visiableCellNum = math.floor(_scrollview_height/(cellSize.height*g_fScaleX))
	--_arrItemValue = getItemList(_tParentParam)

	local handler = LuaEventHandler:create(function(fn, table, a1, a2) 	--创建
		local r
		if fn == "cellSize" then
			r = CCSizeMake(cellSize.width, cellSize.height)
		elseif fn == "cellAtIndex" then
			if _tParentParam.filtersCloth[a1+1].isSelected == true then
				a2 = createClothCell(_tParentParam.filtersCloth[a1 + 1], true)
			else
				a2 = createClothCell(_tParentParam.filtersCloth[a1 + 1], false)
			end
			a2:setScale(g_fScaleX)
			print("a1a1a1",a1)
			_tParentParam.filtersCloth[a1+1].ccObj = a2
			r = a2
		elseif fn == "numberOfCells" then
			r = #_tParentParam.filtersCloth
		elseif (fn == "cellTouched") then
			print("hihihi")
			local m_data = _tParentParam.filtersCloth[a1:getIdx()+1]

			local cellBg = tolua.cast(a1:getChildByTag(1), "CCSprite")
			local menubar_m = tolua.cast(cellBg:getChildByTag(9898), "CCMenu")
			local menuBtn_M = tolua.cast(menubar_m:getChildByTag(tonumber(m_data.gid)), "CCMenuItemSprite")
			
			fnHandlerOfClothTouched(menuBtn_M,m_data)
		end
		
		return r
	end)
	local tableView = LuaTableView:createWithHandler(handler, CCSizeMake(layer:getContentSize().width, _scrollview_height))
	tableView:setAnchorPoint(ccp(0, 0))
	tableView:setBounceable(true)

	return tableView
end

function createGoodTableView()
	local cellBg = CCSprite:create("images/bag/item/item_cellbg.png")
	local cellSize = cellBg:getContentSize()			--计算cell大小
	cellSize.width = cellSize.width * g_fScaleX
	cellSize.height = cellSize.height * g_fScaleX
	cellBg = nil

	local _visiableCellNum = math.floor(_scrollview_height/(cellSize.height*g_fScaleX))
	--_arrItemValue = getItemList(_tParentParam)

	local handler = LuaEventHandler:create(function(fn, table, a1, a2) 	--创建
		local r
		if fn == "cellSize" then
			r = CCSizeMake(cellSize.width, cellSize.height)
		elseif fn == "cellAtIndex" then
			if _tParentParam.filtersGood[a1+1].isSelected == true then
				a2 = createGoodCell(_tParentParam.filtersGood[a1 + 1], true)
			else
				a2 = createGoodCell(_tParentParam.filtersGood[a1 + 1], false)
			end
			a2:setScale(g_fScaleX)
			print("a1a1a1",a1)
			_tParentParam.filtersGood[a1+1].ccObj = a2
			r = a2
		elseif fn == "numberOfCells" then
			r = #_tParentParam.filtersGood
		elseif (fn == "cellTouched") then
			print("hihihi")
			local m_data = _tParentParam.filtersGood[a1:getIdx()+1]

			local cellBg = tolua.cast(a1:getChildByTag(1), "CCSprite")
			local menubar_m = tolua.cast(cellBg:getChildByTag(9898), "CCMenu")
			local menuBtn_M = tolua.cast(menubar_m:getChildByTag(tonumber(m_data.gid)), "CCMenuItemSprite")
			
			fnHandlerOfGoodTouched(menuBtn_M,m_data)
		end
		
		return r
	end)
	local tableView = LuaTableView:createWithHandler(handler, CCSizeMake(layer:getContentSize().width, _scrollview_height))
	tableView:setAnchorPoint(ccp(0, 0))
	tableView:setBounceable(true)

	return tableView
end

function createChooseHeroLayer()
	local nHeightOfBottom = (tBottomSize.height-12)*g_fScaleX
	local nHeightOfTitle = (topMenuBar:getContentSize().height-16)*g_fScaleX
	_scrollview_height = g_winSize.height - bulletinLayerSize.height*g_fScaleX - nHeightOfBottom - nHeightOfTitle
	
	_heroLayer = createHeroSellTableView()
	
	local i
	if _arrHeroesValue ~= nil then
		for i = 1,#_arrHeroesValue do
			if _arrHeroesValue[i].checkIsSelected == true then
				_nSelectedCount = _nSelectedCount + 1
				_ccHeroCount:setString("1/1")
			end
		end
	end
	
	_heroLayer:setPosition(0, nHeightOfBottom)
	_whereILocate = "heroView"
	layer:addChild(_heroLayer)
end

function createChooseItemLayer()
	local nHeightOfBottom = (tBottomSize.height-12)*g_fScaleX
	local nHeightOfTitle = (topMenuBar:getContentSize().height-16)*g_fScaleX
	_scrollview_height = g_winSize.height - bulletinLayerSize.height*g_fScaleX - nHeightOfBottom - nHeightOfTitle
			
	_itemLayer = createItemSellTableview()

	local i
	if _tParentParam.filtersItem ~= nil then
		for i = 1,#_tParentParam.filtersItem do
			if _tParentParam.filtersItem[i].isSelected == true then
				_nItemCount = _nItemCount+1
				_ccHeroCount:setString("1/1")
			end
		end
	end

	_itemLayer:setPosition(0,nHeightOfBottom)
	_whereILocate = "itemView"
	layer:addChild(_itemLayer)
end

function createChooseClothLayer()
	local nHeightOfBottom = (tBottomSize.height-12)*g_fScaleX
	local nHeightOfTitle = (topMenuBar:getContentSize().height-16)*g_fScaleX
	_scrollview_height = g_winSize.height - bulletinLayerSize.height*g_fScaleX - nHeightOfBottom - nHeightOfTitle
			
	_clothLayer = createClothTableView()

	local i
	if _tParentParam.filtersCloth ~= nil then
		for i = 1,#_tParentParam.filtersCloth do
			if _tParentParam.filtersCloth[i].isSelected == true then
				_nClothCount = _nClothCount+1
				_ccHeroCount:setString("1/1")
			end
		end
	end

	_clothLayer:setPosition(0,nHeightOfBottom)
	_whereILocate = "clothView"
	layer:addChild(_clothLayer)
end

function createChooseGoodLayer()
	local nHeightOfBottom = (tBottomSize.height-12)*g_fScaleX
	local nHeightOfTitle = (topMenuBar:getContentSize().height-16)*g_fScaleX
	_scrollview_height = g_winSize.height - bulletinLayerSize.height*g_fScaleX - nHeightOfBottom - nHeightOfTitle
			
	_goodLayer = createGoodTableView()

	local i
	if _tParentParam.filtersGood ~= nil then
		for i = 1,#_tParentParam.filtersGood do
			if _tParentParam.filtersGood[i].isSelected == true then
				_nGoodCount = _nGoodCount+1
				_ccHeroCount:setString("1/1")
			end
		end
	end

	_goodLayer:setPosition(0,nHeightOfBottom)
	_whereILocate = "goodView"
	layer:addChild(_goodLayer)
end

--切换武将和装备选择
function fnHandlerOfButtons(tag, obj)
	if tag == _ksTagChooseHero then
		AudioUtil.playEffect("audio/effect/changtiaoxing.mp3")
		_menuHero:selected()
		_menuItem:unselected()
		_menuCloth:unselected()
		_menuGood:unselected()
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
		--删除宝物界面
		if _goodLayer ~= nil then
			_goodLayer:removeAllChildrenWithCleanup(true)
			layer:removeChild(_goodLayer,true)
			_goodLayer = nil
		end
		--创建武将界面
		if _whereILocate ~= "heroView" then
			_selectId = nil
			_nSelectedCount = 0
			_arrSelectedHeroes = nil
			local i
			if _arrHeroesValue ~= nil then
				for i = 1, #_arrHeroesValue do
					_arrHeroesValue[i].checkIsSelected = false
				end
			end
			createChooseHeroLayer()
			ccLabelSelected:setString(GetLocalizeStringBy("key_1529"))
			_ccHeroCount:setString("0/1")
			_whereILocate = "heroView"
		end
	elseif tag == _ksTagChooseItem then
		AudioUtil.playEffect("audio/effect/changtiaoxing.mp3")
		_menuItem:selected()
		_menuHero:unselected()
		_menuCloth:unselected()
		_menuGood:unselected()
		--删除武将界面
		if _heroLayer ~= nil then
			_heroLayer:removeAllChildrenWithCleanup(true)
			layer:removeChild(_heroLayer,true)
			_heroLayer = nil
		end
		--删除时装界面
		if _clothLayer ~= nil then
			_clothLayer:removeAllChildrenWithCleanup(true)
			layer:removeChild(_clothLayer,true)
			_clothLayer = nil
		end
		--删除宝物界面
		if _goodLayer ~= nil then
			_goodLayer:removeAllChildrenWithCleanup(true)
			layer:removeChild(_goodLayer,true)
			_goodLayer = nil
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
			_ccHeroCount:setString("0/1")
			_whereILocate = "itemView"
		end
	elseif tag == _ksTagChooseCloth then
		AudioUtil.playEffect("audio/effect/changtiaoxing.mp3")
		_menuCloth:selected()
		_menuItem:unselected()
		_menuHero:unselected()
		_menuGood:unselected()
		--删除武将界面
		if _heroLayer ~= nil then
			_heroLayer:removeAllChildrenWithCleanup(true)
			layer:removeChild(_heroLayer,true)
			_heroLayer = nil
		end
		--删除物品界面
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
		--创建装备界面
		if _whereILocate ~= "clothView" then
			local i
			_nClothCount = 0
			if _tParentParam.filtersCloth ~= nil then
				for i = 1, #_tParentParam.filtersCloth do
					_tParentParam.filtersCloth[i].isSelected = false
				end
			end
			createChooseClothLayer()
			ccLabelSelected:setString(GetLocalizeStringBy("key_2806"))
			_ccHeroCount:setString("0/1")
			_whereILocate = "clothView"
		end
	elseif tag == _ksTagChooseGood then
		AudioUtil.playEffect("audio/effect/changtiaoxing.mp3")
		_menuGood:selected()
		_menuItem:unselected()
		_menuHero:unselected()
		_menuCloth:unselected()
		--删除武将界面
		if _heroLayer ~= nil then
			_heroLayer:removeAllChildrenWithCleanup(true)
			layer:removeChild(_heroLayer,true)
			_heroLayer = nil
		end
		--删除物品界面
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
		--创建装备界面
		if _whereILocate ~= "goodView" then
			local i
			_nGoodCount = 0
			if _tParentParam.filtersGood ~= nil then
				for i = 1, #_tParentParam.filtersGood do
					_tParentParam.filtersGood[i].isSelected = false
				end
			end
			createChooseGoodLayer()
			ccLabelSelected:setString(GetLocalizeStringBy("key_1979"))
			_ccHeroCount:setString("0/1")
			_whereILocate = "goodView"
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
	if _whereILocate == "clothView" then
		tArgs.selectedHeroes = _arrSelectedCloths
		tArgs.nowSit = "clothList"
	end
	if _whereILocate == "goodView" then
		tArgs.selectedHeroes = _arrSelectedGoods
		tArgs.nowSit = "goodList"
	end
	tArgs.sign = _arrSign
	if _arrSign == "ResurrectLayer" then
		MainScene.changeLayer(ResurrectLayer.createLayerAfterSelectHero(tArgs), _tParentParam.sign)
	end
end

function createTitleLayer(layerRect)
	local tArgs = {}
-- 	tArgs[1] = {text="武将", x=-10, tag=_ksTagChooseHero, handler=fnHandlerOfButtons,normalN = "images/recycle/btn_title_h.png",normalH = "images/recycle/btn_title_n.png",nFontsize = 33}
-- 	tArgs[2] = {text="装备", x=125, tag=_ksTagChooseItem, handler=fnHandlerOfButtons,normalN = "images/recycle/btn_title_h.png",normalH = "images/recycle/btn_title_n.png",nFontsize = 33}
-- 	tArgs[3] = {text="宝物", x=260, tag=_ksTagChooseGood, handler=fnHandlerOfButtons,normalN = "images/recycle/btn_title_h.png",normalH = "images/recycle/btn_title_n.png",nFontsize = 33}
-- 	tArgs[4] = {text="时装", x=395, tag=_ksTagChooseCloth, handler=fnHandlerOfButtons,normalN = "images/recycle/btn_title_h.png",normalH = "images/recycle/btn_title_n.png",nFontsize = 33}
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

	--获取两个分标签
	local topBottomMenu = tolua.cast(topMenuBar:getChildByTag(10001), "CCMenu")
	_menuHero = tolua.cast(topBottomMenu:getChildByTag(_ksTagChooseHero), "CCMenuItem")
	_menuItem = tolua.cast(topBottomMenu:getChildByTag(_ksTagChooseItem), "CCMenuItem")
	_menuCloth = tolua.cast(topBottomMenu:getChildByTag(_ksTagChooseCloth), "CCMenuItem")
	_menuGood = tolua.cast(topBottomMenu:getChildByTag(_ksTagChooseGood),"CCMenuItem")

	if _arrViewLocation == "heroList" then
		_menuHero:selected()
		--创建选择武将界面
		createChooseHeroLayer()
	elseif _arrViewLocation == "itemList" then
		_menuItem:selected()
		createChooseItemLayer()
	elseif _arrViewLocation == "clothList" then
		_menuCloth:selected()
		createChooseClothLayer()
	elseif _arrViewLocation == "goodList" then
		_menuGood:selected()
		createChooseGoodLayer()
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
		if _nSelectedCount == 1 then
			if _selectId == nil then
				tArgs.selectedHeroes = _arrSelectedHeroes
			else
				tArgs.selectedHeroes = _arrHeroesValue[_selectId]
			end
		else
			tArgs.selectedHeroes = {}
		end
		if _arrSign == "ResurrectLayer" then
			MainScene.changeLayer(ResurrectLayer.createLayerAfterSelectHero(tArgs), _tParentParam.sign)
		end
	end
	if _whereILocate == "itemView" then
		local tArgs = {}
		tArgs.sign = _arrSign
		tArgs.nowSit = "itemList"
		if _nItemCount == 1 then
			if _itemId == nil then
				tArgs.selectedHeroes = _arrSelectedItems
			else
				for i = 1,#_tParentParam.filtersItem do
					if _tParentParam.filtersItem[i].gid == _itemId then
						tArgs.selectedHeroes = _tParentParam.filtersItem[i]
						print("ZZZHHH")
						print_t(_tParentParam.filtersItem[i])
						break
					end
				end
			end
		else
			tArgs.selectedHeroes = {}
		end
		if _arrSign == "ResurrectLayer" then
			MainScene.changeLayer(ResurrectLayer.createLayerAfterSelectHero(tArgs), _tParentParam.sign)
		end
	end
	if _whereILocate == "clothView" then
		local tArgs = {}
		tArgs.sign = _arrSign
		tArgs.nowSit = "clothList"
		if _nClothCount == 1 then
			if _clothId == nil then
				tArgs.selectedHeroes = _arrSelectedCloths
			else
				for i = 1,#_tParentParam.filtersCloth do
					if _tParentParam.filtersCloth[i].gid == _clothId then
						tArgs.selectedHeroes = _tParentParam.filtersCloth[i]
						print("ZZZHHH")
						print_t(_tParentParam.filtersCloth[i])
						break
					end
				end
			end
		else
			tArgs.selectedHeroes = {}
		end
		if _arrSign == "ResurrectLayer" then
			MainScene.changeLayer(ResurrectLayer.createLayerAfterSelectHero(tArgs), _tParentParam.sign)
		end
	end
	if _whereILocate == "goodView" then
		local tArgs = {}
		tArgs.sign = _arrSign
		tArgs.nowSit = "goodList"
		if _nGoodCount == 1 then
			if _goodId == nil then
				tArgs.selectedHeroes = _arrSelectedGoods
			else
				for i = 1,#_tParentParam.filtersGood do
					if _tParentParam.filtersGood[i].gid == _goodId then
						tArgs.selectedHeroes = _tParentParam.filtersGood[i]
						print("ZZZHHH")
						print_t(_tParentParam.filtersGood[i])
						break
					end
				end
			end
		else
			tArgs.selectedHeroes = {}
		end
		if _arrSign == "ResurrectLayer" then
			MainScene.changeLayer(ResurrectLayer.createLayerAfterSelectHero(tArgs), _tParentParam.sign)
		end
	end
end

function createBottomPanel()
	-- 背景
	local bg = CCSprite:create("images/common/sell_bottom.png")
	bg:setScale(g_fScaleX)
	-- 已选择武将(label)

	if _tParentParam.nowIn == "heroList" then
		ccLabelSelected = CCLabelTTF:create (GetLocalizeStringBy("key_1529"), g_sFontName, 25)
	elseif _tParentParam.nowIn == "itemList" then
		ccLabelSelected = CCLabelTTF:create (GetLocalizeStringBy("key_1351"), g_sFontName, 25)
	elseif _tParentParam.nowIn == "clothList" then
		ccLabelSelected = CCLabelTTF:create (GetLocalizeStringBy("key_2806"), g_sFontName, 25)
	elseif _tParentParam.nowIn == "goodList" then
		ccLabelSelected = CCLabelTTF:create (GetLocalizeStringBy("key_1979"), g_sFontName, 25)
	end
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

	_tParentParam = tParam
	if _tParentParam.nowIn == "heroList" then
		_arrSelectedHeroes = _tParentParam.selected
	end
	if _tParentParam.nowIn == "itemList" then
		_arrSelectedItems = _tParentParam.selected
	end
	if _tParentParam.nowIn == "clothList" then
		_arrSelectedCloths = _tParentParam.selected
	end
	if _tParentParam.nowIn == "goodList" then
		_arrSelectedGoods = _tParentParam.selected
	end
	_arrSign = _tParentParam.sign
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
	createTitleLayer(layerRect)

	return layer
end
