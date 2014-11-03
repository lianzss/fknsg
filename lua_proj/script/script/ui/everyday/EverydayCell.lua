-- FileName: EverydayCell.lua 
-- Author: Li Cong 
-- Date: 14-3-19 
-- Purpose: function description of module 


module("EverydayCell", package.seeall)

require "script/ui/everyday/EverydayData"
require "script/ui/hero/HeroPublicUI"
require "script/ui/item/ItemUtil"

function createCell( tcellData )
	print("tcellData .. ")
	print_t(tcellData)

	local cell = CCTableViewCell:create()

	-- 背景
	local fullRect = CCRectMake(0,0,116,157)
	local insetRect = CCRectMake(50,43,16,6)
	local cellBg = CCScale9Sprite:create("images/everyday/cell_bg.png",fullRect, insetRect)
	cellBg:setContentSize(CCSizeMake(574,157))
	cellBg:setAnchorPoint(ccp(0,0))
	cellBg:setPosition(ccp(0,0))
	cell:addChild(cellBg)

	-- 图标
	local iconSpriteBg1 = CCSprite:create("images/everyday/headBg1.png")
	iconSpriteBg1:setAnchorPoint(ccp(0,0.5))
	iconSpriteBg1:setPosition(ccp(20,cellBg:getContentSize().height*0.5))
	cellBg:addChild(iconSpriteBg1)
	-- 图标底
	local iconSpriteBg2 = CCSprite:create("images/base/potential/props_" .. tcellData.dbData.quality .. ".png")
	iconSpriteBg2:setAnchorPoint(ccp(0.5,0.5))
	iconSpriteBg2:setPosition(ccp(iconSpriteBg1:getContentSize().width*0.5,iconSpriteBg1:getContentSize().height*0.5))
	iconSpriteBg1:addChild(iconSpriteBg2)
	-- 真正的图标
	local iconSprite = CCSprite:create("images/everyday/icon/".. tcellData.dbData.icon .. ".png")
	iconSprite:setAnchorPoint(ccp(0.5,0.5))
	iconSprite:setPosition(ccp(iconSpriteBg2:getContentSize().width*0.5,iconSpriteBg2:getContentSize().height*0.5))
	iconSpriteBg2:addChild(iconSprite)

	-- 名字背景
	local nameBg = CCScale9Sprite:create("images/common/bg/9s_5.png")
	nameBg:setContentSize(CCSizeMake(282,33))
	nameBg:setAnchorPoint(ccp(0,1))
	nameBg:setPosition(ccp(135,cellBg:getContentSize().height-20))
	cellBg:addChild(nameBg)
	-- 名字 进度
	local str = tcellData.dbData.name or GetLocalizeStringBy("key_3392")
	local name_font = CCLabelTTF:create(str,g_sFontPangWa,24)
 	name_font:setColor(ccc3(0xff,0xff,0xff))
 	name_font:setAnchorPoint(ccp(0,0.5))
 	name_font:setPosition(ccp(14,nameBg:getContentSize().height*0.5))
 	nameBg:addChild(name_font)

 	local str = GetLocalizeStringBy("key_1140") .. tcellData.curNum .. "/" .. tcellData.dbData.needNum
	local jindu_font = CCLabelTTF:create(str,g_sFontName,23)
 	jindu_font:setColor(ccc3(0x00,0xff,0x18))
 	jindu_font:setAnchorPoint(ccp(1,0.5))
 	jindu_font:setPosition(ccp(nameBg:getContentSize().width-10,nameBg:getContentSize().height*0.5))
 	nameBg:addChild(jindu_font)

 	-- 任务描述
 	local str = tcellData.dbData.taskDes or GetLocalizeStringBy("key_3392")
 	local taskDes = CCLabelTTF:create(str,g_sFontName,23)
 	taskDes:setColor(ccc3(0x78,0x25,0x00))
 	taskDes:setAnchorPoint(ccp(0,1))
 	taskDes:setPosition(ccp(135,cellBg:getContentSize().height-65))
 	cellBg:addChild(taskDes)

 	-- 获得的积分
 	local scoreBg = CCSprite:create("images/everyday/score_bg.png")
 	scoreBg:setAnchorPoint(ccp(0,0))
 	scoreBg:setPosition(ccp(135,20))
 	cellBg:addChild(scoreBg)
 	local str = GetLocalizeStringBy("key_2545")
 	local hude_font = CCLabelTTF:create(str,g_sFontPangWa,21)
 	hude_font:setColor(ccc3(0xff,0xe4,0x00))
 	hude_font:setAnchorPoint(ccp(0,0.5))
 	hude_font:setPosition(ccp(25,scoreBg:getContentSize().height*0.5))
 	scoreBg:addChild(hude_font)

 	local str = tcellData.dbData.score or GetLocalizeStringBy("key_3392")
 	local hude_font = CCLabelTTF:create(str,g_sFontPangWa,21)
 	hude_font:setColor(ccc3(0x00,0xff,0x18))
 	hude_font:setAnchorPoint(ccp(0,0.5))
 	hude_font:setPosition(ccp(125,scoreBg:getContentSize().height*0.5))
 	scoreBg:addChild(hude_font)

 	-- 按钮
 	if(tonumber(tcellData.curNum) >= tonumber(tcellData.dbData.needNum))then
 		-- 进度 已完成
 		local overSp = CCSprite:create("images/everyday/wancheng.png")
 		overSp:setAnchorPoint(ccp(1,0.5))
 		overSp:setPosition(ccp(cellBg:getContentSize().width-25,cellBg:getContentSize().height*0.5))
 		cellBg:addChild(overSp)
 	else
 		-- 前往按钮
		local skipMenu = BTSensitiveMenu:create()
		if(skipMenu:retainCount()>1)then
			skipMenu:release()
			skipMenu:autorelease()
		end
		skipMenu:setTouchPriority(-422)
		skipMenu:setPosition(ccp(0,0))
		cellBg:addChild(skipMenu)
		local skipMenuItem = CCMenuItemImage:create("images/common/btn/btn_blue_n.png","images/common/btn/btn_blue_h.png")
		skipMenuItem:setAnchorPoint(ccp(1,0.5))
		skipMenuItem:setPosition(ccp(cellBg:getContentSize().width-25, cellBg:getContentSize().height*0.5))
		skipMenu:addChild(skipMenuItem,1,tonumber(tcellData.dbData.type))
		-- 注册挑战回调
		skipMenuItem:registerScriptTapHandler(skipMenuItemCallFun)
		-- 阵容字体
		local item_font = CCRenderLabel:create( GetLocalizeStringBy("key_2807") , g_sFontPangWa, 30, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	    item_font:setColor(ccc3(0xfe, 0xdb, 0x1c))
	    item_font:setAnchorPoint(ccp(0.5,0.5))
	    item_font:setPosition(ccp(skipMenuItem:getContentSize().width*0.5,skipMenuItem:getContentSize().height*0.5))
	   	skipMenuItem:addChild(item_font)
 	end

	return cell
end

-- 前往 按钮回调
function skipMenuItemCallFun( tag, itemBtn )
	-- 关闭每日任务界面
	EverydayLayer.closeButtonCallback()
	if(tag == 1)then
		-- 普通副本
		require "script/ui/copy/CopyLayer"
		local copyLayer = CopyLayer.createLayer()
		MainScene.changeLayer(copyLayer, "copyLayer")
	elseif(tag == 2)then
		-- 精英副本
		if not DataCache.getSwitchNodeState(ksSwitchEliteCopy) then
			return
		end
		require "script/ui/copy/CopyLayer"
		local copyLayer = CopyLayer.createLayer(nil, CopyLayer.Elite_Copy_Tag)
		MainScene.changeLayer(copyLayer, "copyLayer")
	elseif(tag == 3)then
		-- 活动副本
		if not DataCache.getSwitchNodeState(ksSwitchActivityCopy) then
			return
		end
		require "script/ui/copy/CopyLayer"
		local copyLayer = CopyLayer.createLayer(nil, CopyLayer.Active_Copy_Tag)
		MainScene.changeLayer(copyLayer, "copyLayer")
	elseif(tag == 4)then
		-- 占星坛
		if not DataCache.getSwitchNodeState(ksSwitchStar) then
			return
		end
        require "script/ui/astrology/AstrologyLayer"
        local astrologyLayer = AstrologyLayer.createAstrologyLayer()
		MainScene.changeLayer(astrologyLayer, "AstrologyLayer",AstrologyLayer.exitAstro)
	elseif(tag == 5)then
		-- 战魂
		if not DataCache.getSwitchNodeState(ksSwitchBattleSoul) then
			return
		end
		require "script/ui/huntSoul/HuntSoulLayer"
        local layer = HuntSoulLayer.createHuntSoulLayer()
        MainScene.changeLayer(layer, "huntSoulLayer")
	elseif(tag == 6)then
		-- 夺宝
		-- 判断物品背包
		if(ItemUtil.isBagFull() == true )then
			return
		end
		-- 判断武将背包
	    if HeroPublicUI.showHeroIsLimitedUI() then
	    	return
	    end
		if( not DataCache.getSwitchNodeState( ksSwitchRobTreasure )) then
			return
		end
		require "script/ui/treasure/TreasureMainView"
		local treasureLayer = TreasureMainView.create()
		MainScene.changeLayer(treasureLayer,"treasureLayer")
	elseif(tag == 7)then
		-- 竞技场
		-- 判断物品背包
		if(ItemUtil.isBagFull() == true )then
			return
		end
		-- 判断武将背包
	    if HeroPublicUI.showHeroIsLimitedUI() then
	    	return
	    end
		if( not DataCache.getSwitchNodeState( ksSwitchArena ) ) then
			return
		end
		require "script/ui/arena/ArenaLayer"
		local arenaLayer = ArenaLayer.createArenaLayer()
		MainScene.changeLayer(arenaLayer, "arenaLayer")
	elseif(tag == 8)then
		-- 试练塔
		-- 判断物品背包
		if(ItemUtil.isBagFull() == true )then
			return
		end
		if( not DataCache.getSwitchNodeState( ksSwitchTower ) ) then
			return
		end
		require "script/ui/tower/TowerMainLayer"
		local towerMainLayer = TowerMainLayer.createLayer()
		MainScene.changeLayer(towerMainLayer, "towerMainLayer")
	elseif(tag == 9)then
		-- 世界BOOS
		if( not DataCache.getSwitchNodeState( ksSwitchWorldBoss ) ) then
			return
		end
		require "script/ui/boss/BossMainLayer"
		local bossLayer = BossMainLayer.createBoss()
		MainScene.changeLayer(bossLayer, "bossLayer")
	elseif(tag == 10)then
		-- 好友送体力
		require "script/ui/friend/FriendLayer"
		local friendLayer = FriendLayer.creatFriendLayer()
		MainScene.changeLayer(friendLayer, "friendLayer")
	elseif(tag == 11)then
		-- 名将
		if not DataCache.getSwitchNodeState(ksSwitchGreatSoldier) then
			return
		end
		require "script/ui/star/StarLayer"
		local starLayer = StarLayer.createLayer()
		MainScene.changeLayer(starLayer, "starLayer")
	elseif(tag == 12)then
		-- 装备洗练
		require "script/ui/bag/BagLayer"
		local bagLayer = BagLayer.createLayer(BagLayer.Tag_Init_Arming)
		MainScene.changeLayer(bagLayer, "bagLayer")
	elseif(tag == 13)then
		-- 军团界面 前往拜关公
		if not DataCache.getSwitchNodeState(ksSwitchGuild) then
			return
		end
		require "script/ui/guild/GuildImpl"
		GuildImpl.showLayer()	
	else
		print(GetLocalizeStringBy("key_3239"))
	end
end

























