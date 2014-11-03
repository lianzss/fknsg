-- Filename：	CopyCell.lua
-- Author：		Cheng Liang
-- Date：		2013-7-3
-- Purpose：		活动副本Cell

module("CopyCell", package.seeall)



local Status_Display 		= 0 			-- 只显示
local Status_Fire 			= 1 			-- 可攻打
local Status_Passed 		= 2 			-- 已通过

local Tag_NameBg 			= 1001 			
local Tag_NameSprite		= 1002
local Tag_PreConditionText 	= 1003
local Tag_CostEnergy 		= 1004

--[[
	@desc	副本Cell的创建
	@para 	table cellValues,
			int animatedIndex, 
			boolean isAnimate
	@return CCTableViewCell
--]]
function createCopyCell(cellValues, animatedIndex, isAnimate)
	print("createCopyCell ------AAAAAA")
	local tCell = CCTableViewCell:create()

	-- cell的外框 
    local cellFrame = CCSprite:create("images/copy/acopy/copyframe.png")
    
    cellFrame:setAnchorPoint(ccp(0,0))

    -- cell的背景 缩略图
    local cellBgIconName = "images/copy/acopy/thumbnail/" .. cellValues.copyInfo.thumbnail
	local cellBg = CCSprite:create(cellBgIconName)
   
	if( cellValues.copyInfo.id == 300004 and CopyUtil.isHeroExpCopyOpen() == false )then
		cellBg = BTGraySprite:create(cellBgIconName)
		local numLabel = CCRenderLabel:create(GetLocalizeStringBy("key_2093"), g_sFontName, 20, 2, ccc3( 0x00, 0x00, 0x00), type_stroke)
	    numLabel:setColor(ccc3(0x36, 0xff, 0x00))
	    numLabel:setAnchorPoint(ccp(0.5, 0.5))
	    numLabel:setPosition(ccp(cellBg:getContentSize().width*0.5 , cellBg:getContentSize().height*0.3))
	    cellBg:addChild(numLabel)
	end

	cellBg:setAnchorPoint(ccp(0,0))
    cellBg:setPosition(ccp(cellFrame:getContentSize().width*0.02, (cellFrame:getContentSize().height-cellBg:getContentSize().height)/2))
    cellFrame:addChild(cellBg,-1,-1)
	tCell:addChild(cellFrame,1,1)
	local cellFrameSize = cellFrame:getContentSize()
    
    --名称背景图
    local nameBg = CCSprite:create("images/copy/acopy/namebg.png" )
    if( cellValues.copyInfo.id == 300004 and CopyUtil.isHeroExpCopyOpen() == false )then
		nameBg = BTGraySprite:create("images/copy/acopy/namebg.png" )
	end
    nameBg:setPosition(ccp(cellFrame:getContentSize().width*0.05, cellFrame:getContentSize().height*0.65))
    cellFrame:addChild(nameBg, Tag_NameBg, Tag_NameBg)

    --副本名称
    local nameSprite = CCSprite:create("images/copy/acopy/nameimage/" .. cellValues.copyInfo.image)
    if( cellValues.copyInfo.id == 300004 and CopyUtil.isHeroExpCopyOpen() == false )then
		nameSprite = BTGraySprite:create("images/copy/acopy/nameimage/" .. cellValues.copyInfo.image)
	end
    nameSprite:setAnchorPoint(ccp(0.5,0.5))
    nameSprite:setPosition(nameBg:getContentSize().width/2, nameBg:getContentSize().height/2);
    nameBg:addChild(nameSprite, Tag_NameSprite, Tag_NameSprite)

    -- if( cellValues.copyInfo.id == 300001 or cellValues.copyInfo.id == 300002 or cellValues.copyInfo.id == 300004)then
    	-- 摇钱树
    	-- 次数
    	local leftTimes = cellValues.can_defeat_num
    	if( cellValues.copyInfo.id == 300004 )then
    		leftTimes = DataCache.getHeroExpDefeatNum()
    	end
	    local numLabel = CCRenderLabel:create(GetLocalizeStringBy("key_1992") .. leftTimes, g_sFontName, 20, 2, ccc3( 0x00, 0x00, 0x00), type_stroke)
	    numLabel:setColor(ccc3(0x36, 0xff, 0x00))
	    numLabel:setAnchorPoint(ccp(1, 0.5))
	    numLabel:setPosition(ccp(cellBg:getContentSize().width*0.9 , cellBg:getContentSize().height*0.8))
	    cellBg:addChild(numLabel)

	    if(cellValues.copyInfo.id == 300001)then
		    local tipSprite = CCSprite:create("images/copy/acopy/tip_" .. cellValues.copyInfo.id .. ".png")
		    tipSprite:setAnchorPoint(ccp(0.5,0.5))
		    tipSprite:setPosition(cellBg:getContentSize().width/2, cellBg:getContentSize().height*0.1);
		    cellBg:addChild(tipSprite)
			
			local item_temp_id = CopyUtil.getCanDefeatItemTemplateIdBy(300001)
			local number = ItemUtil.getCacheItemNumBy( item_temp_id )
			local itemName = ItemUtil.getItemNameByItmTid(item_temp_id)

			-- 消耗的物品 80 00 80
			local fontLabel = CCRenderLabel:create(GetLocalizeStringBy("key_1698"), g_sFontName, 20, 2, ccc3( 0x00, 0x00, 0x00), type_stroke)
		    fontLabel:setColor(ccc3(0x36, 0xff, 0x00))
		    -- fontLabel:setAnchorPoint(ccp(0, 0.5))
		    -- fontLabel:setPosition(ccp( cellBg:getContentSize().width*0.67 , cellBg:getContentSize().height*0.6))
		    -- cellBg:addChild(fontLabel)

			local energyLabel = CCRenderLabel:create(itemName, g_sFontName, 20, 2, ccc3( 0x00, 0x00, 0x00), type_stroke)
		    energyLabel:setColor(ccc3(255, 0, 0xe1))
		    -- energyLabel:setAnchorPoint(ccp(0, 0.5))
		    -- energyLabel:setPosition(ccp( fontLabel:getPositionX()+fontLabel:getContentSize().width, cellBg:getContentSize().height*0.6))
		    -- cellBg:addChild(energyLabel)

		    local fontLabel2 = CCRenderLabel:create(GetLocalizeStringBy("key_3316"), g_sFontName, 20, 2, ccc3( 0x00, 0x00, 0x00), type_stroke)
		    fontLabel2:setColor(ccc3(0x36, 0xff, 0x00))
		    -- fontLabel2:setAnchorPoint(ccp(0, 0.5))
		    -- fontLabel2:setPosition(ccp( energyLabel:getPositionX()+energyLabel:getContentSize().width , cellBg:getContentSize().height*0.6))
		    -- cellBg:addChild(fontLabel2)

		    -- 拥有
		    local fontLabel3 = CCRenderLabel:create(GetLocalizeStringBy("key_2032") .. number .. ")", g_sFontName, 20, 2, ccc3( 0x00, 0x00, 0x00), type_stroke)
		    fontLabel3:setColor(ccc3(0x36, 0xff, 0x00))
		    -- fontLabel:setAnchorPoint(ccp(1, 0.5))
		    -- fontLabel:setPosition(ccp( cellBg:getContentSize().width*0.96 , cellBg:getContentSize().height*0.4))
		    -- cellBg:addChild(fontLabel)

		    -- change by zhz
		    require "script/utils/BaseUI"
		    local fontNode=  BaseUI.createHorizontalNode({fontLabel,energyLabel,fontLabel2, fontLabel3})
		    fontNode:setPosition( cellBg:getContentSize().width*0.99 , cellBg:getContentSize().height*0.6)
		    fontNode:setAnchorPoint(ccp(1,0.5))
		    cellBg:addChild(fontNode)
		else
		 --    -- 体力 去掉，changed by zhz
			-- local energyLabel = CCRenderLabel:create(GetLocalizeStringBy("key_1299") .. cellValues.copyInfo.attack_energy, g_sFontName, 20, 2, ccc3( 0x00, 0x00, 0x00), type_stroke)
		 --    energyLabel:setColor(ccc3(0x36, 0xff, 0x00))
		 --    energyLabel:setAnchorPoint(ccp(1, 0.5))
		 --    energyLabel:setPosition(ccp( cellBg:getContentSize().width*0.95 , cellBg:getContentSize().height*0.6))
		 --    cellBg:addChild(energyLabel)
	    end

	    if( cellValues.copyInfo.id == 300001 or cellValues.copyInfo.id == 300002) then
	      -- 增加次数的按钮
		    local menuBar= CCMenu:create()
		    menuBar:setPosition(ccp(0,0))
		    cellBg:addChild(menuBar)

		    local addAtkBtn = CCMenuItemImage:create("images/common/btn/btn_plus_h.png", "images/common/btn/btn_plus_n.png")
		    addAtkBtn:setPosition(ccp(cellBg:getContentSize().width*0.9 , cellBg:getContentSize().height*0.82 ))
		    addAtkBtn:setAnchorPoint(ccp(0,0.5))
		    addAtkBtn:registerScriptTapHandler(addAtkAction)
		    menuBar:addChild(addAtkBtn, 11,cellValues.copyInfo.id )
		end
    -- end

	if(isAnimate == true) then
		print("createCopyCell......" .. animatedIndex)
		cellFrame:setPosition(ccp(cellFrame:getContentSize().width, 0))
		cellFrame:runAction(CCMoveTo:create(0.05 * (animatedIndex ),ccp(0,0)))
	end

	return tCell
end


-- added by zhz
function addAtkAction( tag, item )
	require "script/ui/tip/BuyCopyAtkLayer"
	local copyId = tonumber(tag)
	local cType = nil
	local buyAtkNum = 0
	local defaultNum =0 
	-- 摇钱树
	if(copyId == 300001) then
		cType = 2
		buyAtkNum= DataCache.getGoldTreeAtkNum()
		defaultNum= DataCache.getGoldTreeDefeatNum()

	-- 经验书
	elseif(copyId == 300002 ) then
		cType = 3
		buyAtkNum = DataCache.getTreasureBuyAtkNum()
		defaultNum = DataCache.getTreasureExpDefeatNum()
	end	

	if(defaultNum >0) then
		AnimationTip.showTip(GetLocalizeStringBy("key_1607"))
		return
	end


	BuyCopyAtkLayer.showLayer( cType ,buyAtkNum , CopyLayer.refreshACopyView )
end

function setCellValue( copyCell, cellValues, animatedIndex, isAnimate)
	local cellFrame = tolua.cast(copyCell:getChildByTag(1), "CCSprite")
	--获取名称背景
	local nameBg = tolua.cast(cellFrame:getChildByTag(Tag_NameBg), "CCSprite")
	--获取副本名称
	local nameSprite = tolua.cast(nameBg:getChildByTag(Tag_NameSprite), "CCSprite")
	if (nameSprite) then
		nameSprite:removeFromParentAndCleanup(true)
	end
	nameSprite = CCSprite:create("images/copy/ecopy/nameimage/" .. cellValues.copyInfo.image)
    nameSprite:setAnchorPoint(ccp(0.5,0.5))
    nameSprite:setPosition(nameBg:getContentSize().width/2, nameBg:getContentSize().height/2);
    nameBg:addChild(nameSprite, Tag_NameSprite, Tag_NameSprite)

    --开启条件
    local preConditionLabel = tolua.cast(cellFrame:getChildByTag(Tag_PreConditionText), "CCLabelTTF")
    if (preConditionLabel) then
		preConditionLabel:removeFromParentAndCleanup(true)
	end
	preConditionLabel = CCLabelTTF:create("开启条件：12432423", g_sFontName, 20)
	preConditionLabel:setColor(ccc3(0xff, 0x90, 0x00))
	preConditionLabel:setPosition(ccp(cellFrame:getContentSize().width*0.7, cellFrame:getContentSize().height*0.8))
    cellFrame:addChild(preConditionLabel, Tag_PreConditionText, Tag_PreConditionText)

    --体力
    local costEnergyLabel = tolua.cast(cellFrame:getChildByTag(Tag_CostEnergy), "CCLabelTTF")
    costEnergyLabel = CCLabelTTF:create(GetLocalizeStringBy("key_1299") .. cellValues.copyInfo.energy, g_sFontName, 20)
	costEnergyLabel:setColor(ccc3(0x36, 0xff, 0x00))
	costEnergyLabel:setPosition(ccp(cellFrame:getContentSize().width*0.8, cellFrame:getContentSize().height*0.1))
    cellFrame:addChild(costEnergyLabel, Tag_CostEnergy, Tag_CostEnergy)

	if(isAnimate == true) then
		print("setCellValue-------" .. animatedIndex)
		cellFrame:setPosition(ccp(cellFrame:getContentSize().width, 0))
		cellFrame:runAction(CCMoveTo:create(g_cellAnimateDuration * (animatedIndex ),ccp(0,0)))
	end
end

