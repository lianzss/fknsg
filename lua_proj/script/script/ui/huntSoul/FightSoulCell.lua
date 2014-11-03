-- FileName: FightSoulCell.lua 
-- Author: Li Cong 
-- Date:     14-2-17 
-- Purpose: function description of module 


module("FightSoulCell", package.seeall)

require "script/ui/common/CheckBoxItem"
require "script/utils/LuaUtil"
require "script/ui/item/ItemUtil"
require "script/model/utils/HeroUtil"
require "script/ui/hero/HeroPublicLua"
require "script/ui/huntSoul/HuntSoulData"
require "script/ui/hero/HeroPublicLua"

-- 升级战魂
local function levelUpItemAction( tag, itemBtn )
	-- 音效
	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")

	require "script/ui/huntSoul/UpgradeFightSoulLayer"
	local tSign = {}
	tSign.sign = "fightSoulBag"
	local layer = UpgradeFightSoulLayer.createUpgradeFightSoulLayer(tag,tSign)
    MainScene.changeLayer(layer,"UpgradeFightSoulLayer")
end 

-- 创建
function createCell( tCellData, isUp )
	local tCell = CCTableViewCell:create()
	--背景
	local cellBg = CCSprite:create("images/bag/equip/equip_cellbg.png")
	cellBg:setAnchorPoint(ccp(0,0))
	tCell:addChild(cellBg,1,1)
	local cellBgSize = cellBg:getContentSize()

	-- icon
	local iconSprite = ItemSprite.getItemSpriteById( tonumber(tCellData.item_template_id), tonumber(tCellData.item_id), nil,nil,nil,nil,nil,nil,false )
	iconSprite:setAnchorPoint(ccp(0.5, 0.5))
	iconSprite:setPosition(ccp(cellBgSize.width * 0.1, cellBgSize.height * 0.55))
	cellBg:addChild(iconSprite)

	-- 等级
	local levelLabel = CCRenderLabel:create(tCellData.va_item_text.fsLevel, g_sFontName, 21, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
    -- levelLabel:setSourceAndTargetColor(ccc3( 0x36, 0xff, 0x00), ccc3( 0x36, 0xff, 0x00));
    levelLabel:setColor(ccc3(0xff, 0xf6, 0x00))
    -- levelLabel:setAnchorPoint(ccp(0,0))
    levelLabel:setPosition(ccp(cellBgSize.width*0.1, cellBgSize.height*0.26))
    cellBg:addChild(levelLabel)

	-- 印章
    local sealSprite = BagUtil.getSealSpriteByItemTempId(tCellData.item_template_id)
    sealSprite:setAnchorPoint(ccp(0, 0.5))
    sealSprite:setPosition(ccp(cellBgSize.width*0.2, cellBgSize.height*0.8))
    cellBg:addChild(sealSprite)

    if( table.isEmpty(tCellData.itemDesc))then
    	tCellData.itemDesc = ItemUtil.getItemById(tCellData.item_template_id)
    end
	-- 名称
	local nameColor = HeroPublicLua.getCCColorByStarLevel(tCellData.itemDesc.quality)
	local nameLabel = CCRenderLabel:create(tCellData.itemDesc.name, g_sFontName, 28, 2, ccc3( 0x00, 0x00, 0x00), type_stroke)
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
    local potentialLabel = CCRenderLabel:create(tCellData.itemDesc.quality, g_sFontName,25, 1, ccc3(0x00, 0x00, 0x00), type_stroke)
    potentialLabel:setColor(ccc3(0xff, 0xf6, 0x00))
    potentialLabel:setPosition(cellBgSize.width*330.0/640, cellBgSize.height*0.87)
    cellBg:addChild(potentialLabel)

    -- 获得相关数值
	local tData = HuntSoulData.getFightSoulAttrByItem_id( tonumber(tCellData.item_id))
	-- print("-------------")
	-- print_t(tData)
	local descString = ""
	for k,v in pairs(tData) do
		descString = descString .. v.desc.displayName .."+".. v.displayNum .. "\n"
	end
	if(table.isEmpty(tData))then
		descString = GetLocalizeStringBy("key_2177") .. tCellData.itemDesc.baseExp
	end
	-- 描述
	local descLabel = CCLabelTTF:create(descString, g_sFontName, 23, CCSizeMake(300, 80), kCCTextAlignmentLeft, kCCVerticalTextAlignmentTop)
	descLabel:setColor(ccc3(0x78, 0x25, 0x00))
	descLabel:setAnchorPoint(ccp(0, 0.5))
	descLabel:setPosition(ccp(cellBgSize.width*0.21, cellBgSize.height*0.4))
	cellBg:addChild(descLabel)

	-- 评分
	local equipScoreLabel = CCRenderLabel:create(tCellData.itemDesc.scorce, g_sFontName, 22, 1, ccc3( 0x00, 0x00, 0x0d), type_stroke)
    equipScoreLabel:setColor(ccc3(0x8a, 0xff, 0x00))
    equipScoreLabel:setPosition(ccp((cellBgSize.width*1.05-equipScoreLabel:getContentSize().width)/2, cellBgSize.height*0.35))
    cellBg:addChild(equipScoreLabel)

    -- 显示升级按钮
    if(isUp)then
	    -- 按钮
		local menuBar = BTSensitiveMenu:create()
		if(menuBar:retainCount()>1)then
			menuBar:release()
			menuBar:autorelease()
		end
		menuBar:setPosition(ccp(0,0))
		cellBg:addChild(menuBar,1, 10)

		-- 升级
		local normalSprite  =CCScale9Sprite:create("images/common/btn/btn_blue_n.png")
	    normalSprite:setContentSize(CCSizeMake(122,64))
	    local selectSprite  =CCScale9Sprite:create("images/common/btn/btn_blue_h.png")
	    selectSprite:setContentSize(CCSizeMake(122,64))
	    local levelUpItem = CCMenuItemSprite:create(normalSprite,selectSprite)
	    levelUpItem:setAnchorPoint(ccp(0.5, 0.5))
	    levelUpItem:setPosition(ccp(cellBgSize.width*0.8, cellBgSize.height*0.5))
	    levelUpItem:registerScriptTapHandler(levelUpItemAction)
		menuBar:addChild(levelUpItem, 1, tCellData.item_id)
	    -- 字体
		local item_font = CCRenderLabel:create( GetLocalizeStringBy("key_1450") , g_sFontPangWa, 30, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	    item_font:setColor(ccc3(0xfe, 0xdb, 0x1c))
	    item_font:setAnchorPoint(ccp(0.5,0.5))
	    item_font:setPosition(ccp(levelUpItem:getContentSize().width*0.5,levelUpItem:getContentSize().height*0.5))
	   	levelUpItem:addChild(item_font)
	end

	if(tCellData.equip_hid and tonumber(tCellData.equip_hid) > 0)then
		-- local being_front = CCSprite:create("images/hero/being_fronted.png")
		-- being_front:setPosition(ccp(532, 88))
		-- cellBg:addChild(being_front)
		local localHero = HeroUtil.getHeroInfoByHid(tCellData.equip_hid)
		local heroName = localHero.localInfo.name
		if(HeroModel.isNecessaryHeroByHid(tCellData.equip_hid)) then
			heroName = UserModel.getUserName()
		end
		local onFormationText =  CCRenderLabel:create(GetLocalizeStringBy("key_1783") .. heroName, g_sFontName, 22, 1, ccc3( 0x00, 0x00, 0x0d), type_stroke)
	    onFormationText:setColor(ccc3(0x8a, 0xff, 0x00))
	    onFormationText:setPosition(ccp(cellBgSize.width*0.7, cellBgSize.height*0.9))
	    cellBg:addChild(onFormationText)
	end
	
	return tCell
end


