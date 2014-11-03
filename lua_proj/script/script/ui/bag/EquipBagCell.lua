-- Filename：	EquipBagCell.lua
-- Author：		Cheng Liang
-- Date：		2013-7-12
-- Purpose：		EquipCell

module("EquipBagCell", package.seeall)


require "script/ui/common/CheckBoxItem"
require "script/utils/LuaUtil"
require "script/ui/item/ItemUtil"
require "script/model/utils/HeroUtil"
require "script/ui/hero/HeroPublicLua"

local _enhanceDelegate = nil

-- 强化装备
local function enhanceAction( tag, itemBtn )
	-- 音效
	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
	-- 强化装备
	local item_id = tag
	local enforceLayer = EquipReinforceLayer.createLayer(item_id, _enhanceDelegate)
	local onRunningLayer = MainScene.getOnRunningLayer()
	onRunningLayer:addChild(enforceLayer, 10)

end 

-- 洗练装备
local function breachAction( tag, itemBtn )
	-- 音效
	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
	-- 强化装备

	if(not DataCache.getSwitchNodeState(ksSwitchEquipFixed, true)) then
		return	
	end

	--记忆上次列表偏移量
	local tableView 	= BagLayer.getTableView()
	local offsetPoint 	= tableView:getContentOffset()
	BagLayer.setLastOffset(offsetPoint)

	local item_id = tag
	require "script/ui/item/EquipFixedLayer"
	EquipFixedLayer.show(item_id)
end 

-- checked 的相应处理
local function checkedAction( tag, itemMenu )

	local sellList = BagLayer.getSellEquipList()
	print(GetLocalizeStringBy("key_2153"))
	print_t(sellList)
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
		print("tag==",tag)
		print("isIn==" ,isIn)
		print("index==",index)
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
	-- print("*******************************")

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

-- 创建
function createEquipCell( equipData, isSell, enhanceDelegate )
	_enhanceDelegate = enhanceDelegate
	local tCell = CCTableViewCell:create()
	--背景
	local cellBg = CCSprite:create("images/bag/equip/equip_cellbg.png")
	cellBg:setAnchorPoint(ccp(0,0))
	tCell:addChild(cellBg,1,1)
	local cellBgSize = cellBg:getContentSize()

	-- icon  显示加锁按钮
	local iconSprite = ItemSprite.getItemSpriteById( tonumber(equipData.item_template_id), tonumber(equipData.item_id), enhanceDelegate,nil,nil,nil,nil,nil,nil,nil,true )
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
	-- 映射关系
	local potentialityConfig = { hp = 1, gen_att = 9, phy_att = 2, magic_att =3, phy_def = 4, magic_def = 5}
	-- 洗练的结果
	local water_result = nil
	if(equipData and equipData.va_item_text and (not table.isEmpty(equipData.va_item_text.armPotence)))then
		water_result = table.hcopy(equipData.va_item_text.armPotence, {})
	end

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
		if( not table.isEmpty(water_result) )then
			for k,v in pairs(water_result) do
				if(potentialityConfig[key] == tonumber(k))then
					
					v_num = tonumber(v_num) + tonumber(v)
					break
				end
			end
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
	
	

	if (isSell) then
		-- 钱币背景
		local coinBg = CCSprite:create("images/common/coin.png")
		coinBg:setAnchorPoint(ccp(0.5, 0.5))
		coinBg:setPosition(ccp(cellBgSize.width*0.7, cellBgSize.height*0.5))
		cellBg:addChild(coinBg)

		-- 卖多少
		local coinLabel = CCRenderLabel:create( BagLayer.getPriceByEquipData(equipData), g_sFontName, 24, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
		coinLabel:setColor(ccc3(0x6c, 0xff, 0x00))
		coinLabel:setAnchorPoint(ccp(0, 0.5))
		coinLabel:setPosition(ccp(cellBgSize.width*0.73, cellBgSize.height*0.5))
		cellBg:addChild(coinLabel)

		-- 复选框
		local checkedBtn = CheckBoxItem.create()
		checkedBtn:setAnchorPoint(ccp(0.5, 0.5))
	    checkedBtn:setPosition(ccp(cellBgSize.width*580/640, cellBgSize.height*0.5))
	    checkedBtn:registerScriptTapHandler(checkedAction)

		menuBar:addChild(checkedBtn, 1, tonumber(equipData.gid))
		handleCheckedBtn(checkedBtn)
	else
		-- 强化
		local enhanceBtn = LuaMenuItem.createItemImage("images/item/equipinfo/btn_enhance_n.png", "images/item/equipinfo/btn_enhance_h.png", enhanceAction )
		enhanceBtn:setAnchorPoint(ccp(0.5, 0.5))
	    enhanceBtn:setPosition(ccp(cellBgSize.width*0.8, cellBgSize.height*0.6))
	    -- enhanceBtn:registerScriptTapHandler(menuAction)
		menuBar:addChild(enhanceBtn, 1, equipData.item_id)

		-- 洗练
		require "script/libs/LuaCC"
		local breachBtn = LuaCC.create9ScaleMenuItem("images/common/btn/green01_n.png", "images/common/btn/green01_h.png",CCSizeMake(134, 64), GetLocalizeStringBy("key_1719"),ccc3(0xfe, 0xdb, 0x1c),30,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00))
		breachBtn:setAnchorPoint(ccp(0.5, 0.5))
		breachBtn:registerScriptTapHandler(breachAction)
		breachBtn:setPosition(ccp(cellBgSize.width*0.8, cellBgSize.height*0.25))
		menuBar:addChild(breachBtn, 1, equipData.item_id )

	end
	if(equipData.equip_hid and tonumber(equipData.equip_hid) > 0)then
		-- local being_front = CCSprite:create("images/hero/being_fronted.png")
		-- being_front:setPosition(ccp(532, 88))
		-- cellBg:addChild(being_front)
		local localHero = HeroUtil.getHeroInfoByHid(equipData.equip_hid)
		local heroName = localHero.localInfo.name
		if(HeroModel.isNecessaryHeroByHid(equipData.equip_hid)) then
			heroName = UserModel.getUserName()
		end
		local onFormationText =  CCRenderLabel:create(GetLocalizeStringBy("key_1381") .. heroName, g_sFontName, 22, 1, ccc3( 0x00, 0x00, 0x0d), type_stroke)
	    onFormationText:setColor(ccc3(0x8a, 0xff, 0x00))
	    onFormationText:setPosition(ccp(cellBgSize.width*0.7, cellBgSize.height*0.9))
	    cellBg:addChild(onFormationText)
	end

	-- add by licong 紫色5星装备图标 加锁icon
	if(equipData.va_item_text.lock and tonumber(equipData.va_item_text.lock) ==1) then
		local lockSp= CCSprite:create("images/hero/lock.png")
		lockSp:setAnchorPoint(ccp(1,0.5))
		lockSp:setPosition(ccp(cellBgSize.width-25, cellBgSize.height*0.5))
		cellBg:addChild(lockSp)
	end

	return tCell
end


function setCellValue( ... )

end

function startEquipCellAnimate( equipCell, animatedIndex )
	
	local cellBg = tolua.cast(equipCell:getChildByTag(1), "CCSprite")
	cellBg:setPosition(ccp(cellBg:getContentSize().width, 0))
	cellBg:runAction(CCMoveTo:create(g_cellAnimateDuration * (animatedIndex ), ccp(0,0)))
end
