-- Filename：	ClothResolveCell.lua
-- Author：		zhang zihang
-- Date：		2014-4-18
-- Purpose：		时装Cell和tableView

module ("ClothResolveCell", package.seeall)

require "script/ui/recycle/ResolveSelectLayer"
require "script/model/user/UserModel"
require "db/DB_Heroes"

function createClothCell( treasData, isSell)
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
    checkedBtn:registerScriptTapHandler(ResolveSelectLayer.checkedClothAction)
    checkedBtn:setEnabled(false)
    
	menuBar:addChild(checkedBtn, 1, treasData.gid)

	if isSell == true then
		checkedBtn:selected()
	else
		checkedBtn:unselected()
	end

	return tCell
end

function createClothTableView(_tParentParam,layerWidth,_scrollview_height)
	--require "script/ui/recycle/EquipResolveCell"
	local cellBg = CCSprite:create("images/bag/item/item_cellbg.png")
	local cellSize = cellBg:getContentSize()			--计算cell大小
	cellSize.width = cellSize.width * g_fScaleX
	cellSize.height = cellSize.height * g_fScaleX
	cellBg = nil
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
			--_tParentParam.filtersItem[a1+1].ccObj = a2
			ResolveSelectLayer.updateClothParentParam(a1,a2)
			r = a2
		elseif fn == "numberOfCells" then
			r = #_tParentParam.filtersCloth
		elseif (fn == "cellTouched") then
			print("hihihi")
			local m_data = _tParentParam.filtersCloth[a1:getIdx()+1]

			local cellBg = tolua.cast(a1:getChildByTag(1), "CCSprite")
			local menubar_m = tolua.cast(cellBg:getChildByTag(9898), "CCMenu")
			local menuBtn_M = tolua.cast(menubar_m:getChildByTag(tonumber(m_data.gid)), "CCMenuItemSprite")
			
			ResolveSelectLayer.fnHandlerOfClothTouched(menuBtn_M,m_data)
		end
		
		return r
	end)
	local tableView = LuaTableView:createWithHandler(handler, CCSizeMake(layerWidth, _scrollview_height))
	tableView:setAnchorPoint(ccp(0, 0))
	tableView:setBounceable(true)

	return tableView,cellSize.height
end
