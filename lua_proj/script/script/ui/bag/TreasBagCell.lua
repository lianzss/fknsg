-- Filename：	TreasBagCell.lua
-- Author：		Cheng Liang
-- Date：		2013-7-12
-- Purpose：		EquipCell

module("TreasBagCell", package.seeall)


require "script/ui/common/CheckBoxItem"
require "script/utils/LuaUtil"
require "script/ui/item/ItemUtil"
require "script/model/utils/HeroUtil"
require "script/ui/hero/HeroPublicLua"
require "script/ui/item/TreasReinforceLayer"

local _enhanceDelegate = nil

local function enhanceAction( tag, itemBtn )
	-- 音效
	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
	-- 强化装备
	local item_id = tag
	local enforceLayer = TreasReinforceLayer.createLayer(item_id, _enhanceDelegate)
	local onRunningLayer = MainScene.getOnRunningLayer()
	onRunningLayer:addChild(enforceLayer, 10)



end 

-- 洗练宝物
local function breachAction( tag, itemBtn )
	-- 音效
	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
	-- 
	if not DataCache.getSwitchNodeState(ksSwitchTreasureFixed,true) then
        return
    end

	local item_id = tag
	local treasureInfo 			= ItemUtil.getItemInfoByItemId(tonumber(item_id))
	if(table.isEmpty(treasureInfo))then
		treasureInfo 		= ItemUtil.getTreasInfoFromHeroByItemId(tonumber(item_id))
	end
	if(tonumber(treasureInfo.itemDesc.isUpgrade)  ~= 1) then
		require "script/ui/tip/AlertTip"
        AlertTip.showAlert( GetLocalizeStringBy("key_2022"), nil, false, nil)
        return
	end
	require "script/ui/treasure/evolve/TreasureEvolveMainView"
	local upgradeLayer = TreasureEvolveMainView.createLayer(item_id, _enhanceDelegate)
	TreasureEvolveMainView.setFromLayerTag(TreasureEvolveMainView.kTreasureListTag)
	MainScene.changeLayer(upgradeLayer, "evolveLayer")
end 

-- checked 的相应处理
local function checkedAction( tag, itemMenu )

	local sellList = BagLayer.getSellEquipList()
	if ( table.isEmpty(sellList) ) then
		sellList = {}
		table.insert(sellList, tag)
		itemMenu:selected()
	else
		local isIn = false
		local index = -1
		for k,g_id in pairs(sellList) do
			if ( tonumber(g_id) == tag ) then
				isIn = true
				index = k
				break
			end
		end
		if (isIn) then
			table.remove(sellList, index)
			itemMenu:unselected()
		else
			table.insert(sellList, tag)
			itemMenu:selected()
		end
	end
	BagLayer.setSellEquipList(sellList)
end

-- 检查checked按钮
local function handleCheckedBtn( checkedBtn )


	local sellList = BagLayer.getSellEquipList()
	if ( table.isEmpty(sellList) ) then
		checkedBtn:unselected()
	else
		local isIn = false
		for k,g_id in pairs(sellList) do
			if ( tonumber(g_id) == checkedBtn:getTag() ) then
				isIn = true
				break
			end
		end
		if (isIn) then
			checkedBtn:selected()
		else
			checkedBtn:unselected()
		end
	end
end

-- 检查checked 的宝物
local function handleSelectedCheckedBtn( checkedBtn )
	local selecedList = TreasReinforceLayer.getMaterialsArr()
	if ( table.isEmpty(selecedList) ) then
		checkedBtn:unselected()
	else
		local isIn = false
		for k,item_id in pairs(selecedList) do
			if ( item_id == checkedBtn:getTag() ) then
				isIn = true
				break
			end
		end
		if (isIn) then
			checkedBtn:selected()
		else
			checkedBtn:unselected()
		end
	end
end

-- 宝物强化选择的cai
local function enhanceCheckedAction( tag, itemBtn )
	
end 

-- 创建 isForEnhanceMaterial <==> 作为强化的备选材料
function createTreasCell( treasData, isSell, enhanceDelegate, isForEnhanceMaterial )
	_enhanceDelegate = enhanceDelegate
	local tCell = CCTableViewCell:create()
	--背景
	local cellBg = CCSprite:create("images/bag/equip/treas_cellbg.png")
	cellBg:setAnchorPoint(ccp(0,0))
	tCell:addChild(cellBg,1,1)
	local cellBgSize = cellBg:getContentSize()

	-- icon
	local iconSprite = ItemSprite.getItemSpriteById( tonumber(treasData.item_template_id), tonumber(treasData.item_id), enhanceDelegate )
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

	-- 处理 经验金马 经验银马 经验金书 经验银书
	if( (tonumber(treasData.itemDesc.isExpTreasure) == 1) )then
		descString = GetLocalizeStringBy("key_2531")
		
		-- 提供经验的数值
		local add_exp = (tonumber(treasData.itemDesc.base_exp_arr) + tonumber(treasData.va_item_text.treasureExp))
		local add_exp_label = CCLabelTTF:create("+" .. add_exp, g_sFontName, 23)
		add_exp_label:setColor(ccc3(0x00, 0x6d, 0x2f))
		add_exp_label:setAnchorPoint(ccp(0, 0.5))
		add_exp_label:setPosition(ccp(cellBgSize.width*0.21, cellBgSize.height*0.35))
		cellBg:addChild(add_exp_label)
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
	-- local enhanceBtn = LuaMenuItem.createItemImage("images/bag/item/btn_use_n.png", "images/bag/item/btn_use_h.png" )
	-- enhanceBtn:setAnchorPoint(ccp(0.5, 0.5))
 	-- enhanceBtn:setPosition(MainScene.getMenuPositionInTruePoint(cellBgSize.width*520/640, cellBgSize.height*0.5))
 	-- enhanceBtn:registerScriptTapHandler(enhanceAction)
	-- menuBar:addChild(enhanceBtn, 1, treasData.gid)

	if (isSell) then
		-- print_t(treasData)
		-- 钱币背景
		local coinBg = CCSprite:create("images/common/coin.png")
		coinBg:setAnchorPoint(ccp(0.5, 0.5))
		coinBg:setPosition(ccp(cellBgSize.width*0.7, cellBgSize.height*0.5))
		cellBg:addChild(coinBg)

		-- 卖多少
		local coinLabel = CCRenderLabel:create( BagLayer.getPriceByEquipData(treasData), g_sFontName, 24, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
		coinLabel:setColor(ccc3(0x6c, 0xff, 0x00))
		coinLabel:setAnchorPoint(ccp(0, 0.5))
		coinLabel:setPosition(ccp(cellBgSize.width*0.73, cellBgSize.height*0.5))
		cellBg:addChild(coinLabel)

		-- 复选框
		local checkedBtn = CheckBoxItem.create()
		checkedBtn:setAnchorPoint(ccp(0.5, 0.5))
	    checkedBtn:setPosition(ccp(cellBgSize.width*580/640, cellBgSize.height*0.5))
	    checkedBtn:registerScriptTapHandler(checkedAction)

		menuBar:addChild(checkedBtn, 1, treasData.gid)
		handleCheckedBtn(checkedBtn)
	elseif(isForEnhanceMaterial)then
		-- 经验
		local expSprite = CCSprite:create("images/common/exp.png")
		expSprite:setAnchorPoint(ccp(0.5, 0.5))
		expSprite:setPosition(ccp(cellBgSize.width*450/640, cellBgSize.height*0.5))
		cellBg:addChild(expSprite)

		-- 经验数字
		local baseExp = tonumber(treasData.itemDesc.base_exp_arr)  -- ItemUtil.getBaseExpBy(treasData.item_template_id, t_level)
		
		local expNumLabel = CCRenderLabel:create(baseExp+tonumber(treasData.va_item_text.treasureExp), g_sFontName, 23, 1, ccc3( 0x00, 0x00, 0x0d), type_stroke)
	    expNumLabel:setColor(ccc3(0x8a, 0xff, 0x00))
	    expNumLabel:setAnchorPoint(ccp(0.5,0.5))
	    expNumLabel:setPosition(ccp(cellBgSize.width*505/640, cellBgSize.height*0.5))
	    cellBg:addChild(expNumLabel)
 
		-- 复选框
		local checkedBtn = CheckBoxItem.create()
		checkedBtn:setAnchorPoint(ccp(0.5, 0.5))
	    checkedBtn:setPosition(ccp(cellBgSize.width*580/640, cellBgSize.height*0.5))
	    checkedBtn:registerScriptTapHandler(enhanceCheckedAction)

		menuBar:addChild(checkedBtn, 1, tonumber(treasData.item_id) )
		handleSelectedCheckedBtn(checkedBtn)
	else
		local enhanceBtn = LuaMenuItem.createItemImage("images/item/equipinfo/btn_enhance_n.png", "images/item/equipinfo/btn_enhance_h.png" )
		enhanceBtn:setAnchorPoint(ccp(0.5, 0.5))
	    enhanceBtn:setPosition(ccp(cellBgSize.width*0.8, cellBgSize.height*0.6))
	    enhanceBtn:registerScriptTapHandler(enhanceAction)
		menuBar:addChild(enhanceBtn, 1, treasData.item_id)

		-- 洗练
		require "script/libs/LuaCC"
		local breachBtn = LuaCC.create9ScaleMenuItem("images/common/btn/green01_n.png", "images/common/btn/green01_h.png",CCSizeMake(134, 64), GetLocalizeStringBy("key_2943"),ccc3(0xfe, 0xdb, 0x1c),30,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00))
		breachBtn:setAnchorPoint(ccp(0.5, 0.5))
		breachBtn:registerScriptTapHandler(breachAction)
		breachBtn:setPosition(ccp(cellBgSize.width*0.8, cellBgSize.height*0.25))
		menuBar:addChild(breachBtn, 1, treasData.item_id )
	end
	if(treasData.equip_hid and tonumber(treasData.equip_hid) > 0)then
		-- local being_front = CCSprite:create("images/hero/being_fronted.png")
		-- being_front:setPosition(ccp(532, 88))
		-- cellBg:addChild(being_front)
		local localHero = HeroUtil.getHeroInfoByHid(treasData.equip_hid)
		local heroName = localHero.localInfo.name
		if(HeroModel.isNecessaryHeroByHid(treasData.equip_hid)) then
			heroName = UserModel.getUserName()
		end
		local onFormationText =  CCRenderLabel:create(GetLocalizeStringBy("key_1783").. heroName, g_sFontName, 22, 1, ccc3( 0x00, 0x00, 0x0d), type_stroke)
	    onFormationText:setColor(ccc3(0x8a, 0xff, 0x00))
	    onFormationText:setPosition(ccp(cellBgSize.width*0.7, cellBgSize.height*0.9))
	    cellBg:addChild(onFormationText)
	end

	return tCell
end


function startTreasCellAnimate( equipCell, animatedIndex )
	
	local cellBg = tolua.cast(equipCell:getChildByTag(1), "CCSprite")
	cellBg:setPosition(ccp(cellBg:getContentSize().width, 0))
	cellBg:runAction(CCMoveTo:create(g_cellAnimateDuration * (animatedIndex ), ccp(0,0)))
end
