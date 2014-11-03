-- Filename: MainBaseLayer.lua
-- Author: fang
-- Date: 2013-07-04
-- Purpose: 该文件用于: 主场景中间层内容


-- 主场景中间层模块声明
module ("MainBaseLayer", package.seeall)
require "script/network/RequestCenter"
require "script/model/DataCache"
require "script/ui/main/MainScene"
require "script/ui/tip/AnimationTip"
require "script/audio/AudioUtil"
require "script/ui/mail/MailData" 
require "script/ui/friend/FriendData"
require "script/ui/guild/city/CityData"
require "script/ui/guild/GuildDataCache"
-- 图片路径
local IMG_PATH="images/main/"
local IMG_PATH_SUB = IMG_PATH .. "sub_icons/"

local _main_base_layer = nil

_ksTagRecycle     = 2002		-- 炼化炉
_ksTagMail        = 2003 		-- 邮件
_ksTagFriend      = 2004 		-- 好友
_ksTagChat        = 2005		-- 聊天
_ksTagMenu        = 2006		-- 菜单
_ksTagFair        = 3001		-- 名将
_ksTagHero        = 3002		-- 武将
_ksTagEquip       = 3003		-- 装备
_ksTagHoroscope   = 3004		-- 占星坛
_ksTagDestiny     = 3005		-- 天命
_ksTagBoss        = 3006   		-- 世界boss
_ksTagArmyTeam    = 4001		-- 军团
_ksTagFightSoul   = 4002  		-- 战魂
_ksTagEveryDay    = 4003  		-- 每日任务
_ksTagPet         = 4004 		-- 宠物
_mask_layer_tag   = 5000
_ksTagYao         = 5001		-- 军团邀请
_ksTagAchievement = 5002 		-- 成就
_ksMysterious     = 5003		-- 试炼塔神秘层
_ksCityWar   	  = 5004		-- 试炼塔神秘层
_ksLordWar   	  = 5004		-- 跨服赛入口
_ksTagRank        = 5005        -- 排行榜系统入口   add by DJN 
local ksNewEffectTag       = 10
local _ksTagOfRewardCenter = 1001  -- 奖励中心tag
local _nFirstLineCount     = 5
local _nSecondLineCount    = 11
local _isShowChatAnimation = false
local _isAstroAlert        = false
local cityWarShow 		   = true
local secretShow 		   = true
local _cmMenuBar           = nil
local everydayBtn          = nil
local menuPanel            = nil
local _menuPanelMenu       = nil
local _maksLayer           = nil
local function_button      = nil
-- 子模块结构
local _sub_modules={
	{name="recycle", tag=_ksTagRecycle, pos_x=58, pos_y=0},
	-- 军团
	{name="guild", tag=_ksTagArmyTeam, pos_x=160, pos_y=0},
	-- {name="mail", tag=_ksTagMail, pos_x=330, pos_y=0},
	{name="pet", tag=_ksTagPet, pos_x=280, pos_y=0},
	{name="chat", tag=_ksTagChat, pos_x=390, pos_y=0},
	{name="menu", tag=0, pos_x=500, pos_y=0},
	
	-- 第二栏数据
	{name="fair", tag=_ksTagFair, pos_x=20, pos_y= 0 },
	{name="hero", tag=_ksTagHero, pos_x=120, pos_y= 0},
	{name="equip", tag=_ksTagEquip, pos_x=225, pos_y=0},
	{name="horoscope", tag=_ksTagHoroscope, pos_x=330, pos_y=0},
	-- added by zhz 天命
	{name="destiny", tag=_ksTagDestiny, pos_x=420, pos_y=0},
	-- add by licong 战魂
	{name="fightSoul", tag=_ksTagFightSoul, pos_x=530, pos_y=0},
	-- 12 上排
	{name="everyday", tag=_ksTagEveryDay, pos_x=265, pos_y=0, anchorPoint = ccp(0,1)},
}

-- 获取主页菜单图片完整路径
local function getImagePath(filename, isHighlighted)
	if isHighlighted then
		return IMG_PATH_SUB .. filename .. "_h.png"
	end
	return IMG_PATH_SUB .. filename .. "_n.png"
end

local function menu_item_tap_handler(tag, item_obj)
	require "script/model/DataCache"
	
    --点击音效
    require "script/audio/AudioUtil"
    AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
    -- 炼化炉按钮事件
	if (tag == _ksTagRecycle) then
		---[==[炼化炉 新手引导屏蔽层 第1步changLayer
		---------------------新手引导---------------------------------
			--add by licong 2013.09.06
			require "script/guide/NewGuide"
			require "script/guide/ResolveGuide"
			if(NewGuide.guideClass ==  ksGuideResolve and ResolveGuide.stepNum == 1) then
				ResolveGuide.changLayer()
			end
		---------------------end-------------------------------------
		--]==]
		-- 功能节点判断
		if not DataCache.getSwitchNodeState(ksSwitchResolve) then
			return
		end
		require "script/ui/recycle/RecycleMain"
    	local RecycleLayer = RecycleMain.create()
    	MainScene.changeLayer(RecycleLayer,"RecycleLayer")
	-- 邮件按钮事件
	elseif (tag == _ksTagMail) then
		local mailButton = getMainMenuItem(_ksTagMail)
		if(mailButton ~= nil)then
			local button = tolua.cast(mailButton,"CCMenuItemImage")
			if(button:getChildByTag(10) ~= nil)then
				button:removeChildByTag(10,true)
				require "script/ui/mail/MailData"
				MailData.setHaveNewMailStatus( "false" )
			end
		end
		-- 进入邮件系统
		require "script/ui/mail/Mail"
		MainScene.changeLayer(Mail.createMailLayer(), "Mail")
	-- 好友按钮事件
	elseif tag == _ksTagFriend then
		require "script/ui/friend/FriendLayer"
		local friendLayer = FriendLayer.creatFriendLayer()
		MainScene.changeLayer(friendLayer, "friendLayer")
	-- 聊天按钮事件
	elseif (tag == _ksTagChat) then        
        require "script/ui/chat/ChatMainLayer"
        ChatMainLayer.showChatLayer()
    -- 菜单按钮事件
    elseif tag == _ksTagMenu then
		require "script/ui/menu/CCMenuLayer"
		local ccMenuLayer = CCMenuLayer.createMenuLayer()
		MainScene.changeLayer(ccMenuLayer, "ccMenu")
	-- 排行榜系统按钮事件-------------add by DJN 20140916 ----------------
    elseif tag == _ksTagRank then
    	require "script/model/user/UserModel"
	    if(tonumber(UserModel.getHeroLevel()) >= 20)then
			require "script/ui/rank/RankLayer"
			local ccRankLayer = RankLayer.showLayer()
			MainScene.changeLayer(ccRankLayer, "RankLayer")
		else
			require "script/ui/tip/AnimationTip"
			AnimationTip.showTip(GetLocalizeStringBy("djn_51"))
		end
	-------------------------------------------------------------------
	-- 装备按钮事件
	elseif (tag == _ksTagEquip) then
		require "script/ui/bag/BagLayer"
		local bagLayer = BagLayer.createLayer(BagLayer.Tag_Init_Arming)
		MainScene.changeLayer(bagLayer, "bagLayer")

		-- require "script/ui/lordWar/MyInfoLayer"
		-- local infoLayer = MyInfoLayer.show(-454,1000)
		
		-- MainScene.changeLayer(infoLayer,"infoLayer")
		-- require "script/ui/lordWar/CheersLayer"
		-- local infoLayer = CheersLayer.show()
		-- MainScene.changeLayer(infoLayer,"infoLayer")
	-- ”占星“按钮事件
	elseif (tag == _ksTagHoroscope) then
		---[==[占星 新手引导屏蔽层
		---------------------新手引导---------------------------------
		--add by licong 2013.09.29
		require "script/guide/NewGuide"
		if(NewGuide.guideClass == ksGuideAstrology) then
			require "script/guide/AstrologyGuide"
			AstrologyGuide.changLayer()
		end
		---------------------end-------------------------------------
		--]==]
		if not DataCache.getSwitchNodeState(ksSwitchStar) then
			return
		end
        require "script/ui/astrology/AstrologyLayer"
        local astrologyLayer = AstrologyLayer.createAstrologyLayer()
		MainScene.changeLayer(astrologyLayer, "AstrologyLayer",AstrologyLayer.exitAstro)
	-- ”名将“按钮事件
	elseif (tag == _ksTagFair) then
		---[==[名将 新手引导屏蔽层
		---------------------新手引导---------------------------------
		--add by licong 2013.09.29
		require "script/guide/NewGuide"
		if(NewGuide.guideClass == ksGuideGreatSoldier) then
			require "script/guide/StarHeroGuide"
			StarHeroGuide.changLayer()
		end
		---------------------end-------------------------------------
		--]==]
		---[==[武将列传 新手引导屏蔽层
		---------------------新手引导---------------------------------
		--add by licong 2014.5.27
		require "script/guide/NewGuide"
		if(NewGuide.guideClass == ksGuideHeroBiography) then
			require "script/guide/LieZhuanGuide"
			LieZhuanGuide.changLayer()
		end
		---------------------end-------------------------------------
		--]==]
		if not DataCache.getSwitchNodeState(ksSwitchGreatSoldier) then
			return
		end
		require "script/ui/star/StarLayer"
		local starLayer = StarLayer.createLayer()
		MainScene.changeLayer(starLayer, "starLayer")

		
	-- GetLocalizeStringBy("key_1453")按钮事件
	elseif (tag == _ksTagHero) then
		---[==[强化所新手引导屏蔽层
		---------------------新手引导---------------------------------
			--add by licong 2013.09.06
			require "script/guide/NewGuide"
			if(NewGuide.guideClass ==  ksGuideForge) then
				require "script/guide/StrengthenGuide"
				StrengthenGuide.changLayer()
			end
		---------------------end-------------------------------------
		--]==]
		if not DataCache.getSwitchNodeState(ksSwitchGeneralTransform) then
			return
		end
		-- 进入武将系统

		--武将进阶
		require "script/guide/NewGuide"
		require "script/guide/GeneralUpgradeGuide"
	    if(NewGuide.guideClass ==  ksGuideGeneralUpgrade) then
	        GeneralUpgradeGuide.changeLayer()
	    end

	    ---[==[武将进化 新手引导屏蔽层
		---------------------新手引导---------------------------------
		require "script/guide/NewGuide"
		if(NewGuide.guideClass == ksGuideHeroDevelop) then
			require "script/guide/HeroDevelopGuide"
			HeroDevelopGuide.changLayer()
		end
		---------------------end-------------------------------------
		--]==]
		require "script/ui/hero/HeroLayer"
		MainScene.changeLayer(HeroLayer.createLayer(), "HeroLayer")
	elseif(tag== _ksTagDestiny ) then
		---[==[天命 新手引导屏蔽层
		---------------------新手引导---------------------------------
		--add by licong 2013.09.29
		require "script/guide/NewGuide"
		if(NewGuide.guideClass == ksGuideDestiny) then
			require "script/guide/DestinyGuide"
			DestinyGuide.changLayer()
		end
		---------------------end-------------------------------------
		--]==]
		---[==[ 主角换技能 新手引导屏蔽层
		---------------------新手引导---------------------------------
		require "script/guide/NewGuide"
		if(NewGuide.guideClass == ksGuideChangeSkill) then
			require "script/guide/ChangeSkillGuide"
			ChangeSkillGuide.changLayer()
		end
		---------------------end-------------------------------------
		--]==]
		-- 天命入口
		if not DataCache.getSwitchNodeState(ksSwitchDestiny) then
			return
		end
		require "script/ui/destiny/DestinyLayer"
		local destinyLayer = DestinyLayer.createLayer()
		MainScene.changeLayer(destinyLayer, "destinyLayer")
	elseif(tag== _ksTagArmyTeam) then
		-- -- 军团入口
		if not DataCache.getSwitchNodeState(ksSwitchGuild) then
			return
		end
		-- 设置小红圈false
		GuildDataCache.setIsShowRedTip(false)
		require "script/ui/guild/GuildImpl"
		GuildImpl.showLayer()	
		
		
	elseif(tag== _ksTagFightSoul) then
		-- 战魂入口
		if not DataCache.getSwitchNodeState(ksSwitchBattleSoul) then
			return
		end
		require "script/ui/huntSoul/HuntSoulLayer"
        local layer = HuntSoulLayer.createHuntSoulLayer()
        MainScene.changeLayer(layer, "huntSoulLayer")
    elseif(tag== _ksTagEveryDay) then 
		-- -- 每日任务入口
		if not DataCache.getSwitchNodeState(ksSwitchEveryDayTask) then
			return
		end
		require "script/ui/everyday/EverydayLayer"
  		EverydayLayer.showEverydayLayer()
  	elseif(tag== _ksTagPet) then 
		-- 宠物入口
		---[==[宠物 新手引导屏蔽层
		---------------------新手引导---------------------------------
		--add by licong 2013.09.29
		require "script/guide/NewGuide"
		if(NewGuide.guideClass == ksGuidePet) then
			require "script/guide/PetGuide"
			PetGuide.changLayer()
		end
		---------------------end-------------------------------------
		--]==]
		if not DataCache.getSwitchNodeState(ksSwitchPet) then
			return
		end
  		require "script/ui/pet/PetMainLayer"
  		local layer= PetMainLayer.createLayer()
  		MainScene.changeLayer(layer, "PetMainLayer")
  	elseif(tag == _ksTagAchievement) then
  		--成就入口
  		print("achievement enter")
  		require "script/ui/achie/AchievementLayer"
		showLayer = AchievementLayer.createLayer()
		local runningScene = CCDirector:sharedDirector():getRunningScene()
		runningScene:addChild(showLayer, 1000)
  	else

	end 
end

local function fnHandlerOfBonusCenter(tag, obj)
	require "script/ui/rewardCenter/RewardCenterView"
	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
	local runScene = CCDirector:sharedDirector():getRunningScene()
	local rewardLayer  = RewardCenterView.create()
	runScene:addChild(rewardLayer,1500)
end

-- 创建tipsprite图片
function createTipSprite(item )
	require "script/ui/rechargeActive/ActiveCache"
	require "script/utils/ItemDropUtil"

	local tipSprite= CCSprite:create("images/common/tip_2.png")
	tipSprite:setPosition(ccp(item:getContentSize().width*0.97, item:getContentSize().height*0.98))
	tipSprite:setAnchorPoint(ccp(1,1))
	item:addChild(tipSprite,1)

	if(ActiveCache.hasTipInActive() == false) then
        tipSprite:setVisible(false)
    end
end

-- 添加”精彩活动“按钮
function addHighlightsButton(menu_bar)
	require "script/ui/main/MenuLayer"
	local cmiiHighlights = CCMenuItemImage:create("images/main/sub_icons/highlights_n.png", "images/main/sub_icons/highlights_h.png")
	-- 适配 changed by zhz
	-- local 	main_base_layer = MainScene.createBaseLayer(nil, true, true, true)
	cmiiHighlights:setPosition(385*g_fScaleX/MainScene.elementScale, _main_base_layer:getContentSize().height*0.98/MainScene.elementScale )
	cmiiHighlights:setAnchorPoint(ccp(0, 1))
	cmiiHighlights:registerScriptTapHandler(function ( )
		require "script/ui/rechargeActive/RechargeActiveMain"		
    	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
    	
		local layer = RechargeActiveMain.create()
		MainScene.changeLayer(layer, "layer")
		
	end)
	local menu= CCMenu:create()
	menu:setPosition(ccp(0,0))
	menu:addChild(cmiiHighlights)
	_main_base_layer:addChild(menu,101)

	-- ActivityConfigUtil.addObserver(ActiveCache.setAllNewOpenActivity)

	-- 增加提示图片，右后也可以怎家特效
	createTipSprite(cmiiHighlights)
end


-- 添加邀请的按钮
function addGuildInvite( menu_bar )
		
	-- local menu= CCMenu:create()
	-- menu:setPosition(ccp(0,0))
	-- _main_base_layer:addChild(menu,1, 7000)
	require "script/ui/teamGroup/TeamGroupData"
	
	local inviteBtn= CCMenuItemImage:create("images/guild/invite/invite_n.png", "images/guild/invite/invite_h.png")
	inviteBtn:setPosition(ccp(_main_base_layer:getContentSize().width*0.5/MainScene.elementScale,_main_base_layer:getContentSize().height*0.54/MainScene.elementScale ))
	inviteBtn:setAnchorPoint(ccp(0.5,1))
	menu_bar:addChild(inviteBtn,1,_ksTagYao)

	local newAnimSprite = CCLayerSprite:layerSpriteWithName(CCString:create("images/base/effect/yao/yao"), -1,CCString:create(""));
 	newAnimSprite:setPosition(ccp(inviteBtn:getContentSize().width*0.5,inviteBtn:getContentSize().height/2))
 	newAnimSprite:setAnchorPoint(ccp(0.5,0.5))
	inviteBtn:addChild(newAnimSprite,-1)

	if( TeamGroupData.hasInviteMem() == false) then
		inviteBtn:setVisible(false)
	end

	inviteBtn:registerScriptTapHandler(function ( )
		require "script/ui/teamGroup/ReceiveInviteLayer"		
    	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
    	ReceiveInviteLayer.showLayer(refreshYaoItem)
	end)
end


--  删除“邀请”图标
function refreshYaoItem( )

	if(_main_base_layer~=nil and _main_base_layer:getChildByTag(7327)~=nil)then
		local item = _main_base_layer:getChildByTag(7327):getChildByTag(_ksTagYao)
		print("item  is : ", item )
		print("_main_base_layer:getChildByTag(7327)  is : ", _main_base_layer:getChildByTag(7327))
		if(item ~= nil) then
			require "script/ui/teamGroup/TeamGroupData"
	        if(TeamGroupData.hasInviteMem() == false )then
	            item:setVisible(false)
	        else
	        	item:setVisible(true)
	        end
	    end
    end
end


-- 添加神秘层按钮
function addMysterious( menu_bar )
	if( not DataCache.getSwitchNodeState( ksSwitchTower, false ) ) then
		return
	end
	if(secretShow == true)then
		require "script/ui/teamGroup/TeamGroupData"
		local inviteBtn= CCMenuItemImage:create("images/main/sub_icons/mysterious_n.png", "images/main/sub_icons/mysterious_h.png")
		inviteBtn:setPosition(ccp(_main_base_layer:getContentSize().width*0.4/MainScene.elementScale,_main_base_layer:getContentSize().height*0.54/MainScene.elementScale ))
		inviteBtn:setAnchorPoint(ccp(0.5,1))
		menu_bar:addChild(inviteBtn,1,_ksMysterious)
		local newAnimSprite = CCLayerSprite:layerSpriteWithName(CCString:create("images/base/effect/yao/yao"), -1,CCString:create(""));
 		newAnimSprite:setPosition(ccp(inviteBtn:getContentSize().width*0.5,inviteBtn:getContentSize().height/2))
 		newAnimSprite:setAnchorPoint(ccp(0.5,0.5))
		inviteBtn:addChild(newAnimSprite,-1)
		if(TowerCache.haveSceretTower()==false)then
			print("you")
			inviteBtn:setVisible(false)
		else
			print("meiyou")
			inviteBtn:setVisible(true)
		end
		inviteBtn:registerScriptTapHandler(function ( )
			print("神秘层按钮")
			require "script/ui/tower/TowerMainLayer"
			local towerMainLayer = TowerMainLayer.createLayer()
			MainScene.changeLayer(towerMainLayer, "towerMainLayer")
			secretShow = false
			inviteBtn:setVisible(false)
		end)
	else
		if(menu_bar:getChildByTag(_ksMysterious)~=nil)then
			menu_bar:getChildByTag(_ksMysterious):setVisible(false)
		end
	end
end

-- 添加军团战按钮

function addCityWar( menu_bar )
	if not DataCache.getSwitchNodeState(ksSwitchGuild,false) then --23军团系统
		return
	end
	
	local data = GuildDataCache.getMineSigleGuildInfo()
	if( (not table.isEmpty(data)) and data.guild_id ~= nil and tonumber(data.guild_id) > 0 ) then
		local my_hallLv = tonumber(data.guild_level)
		-- if(not table.isEmpty(_guildInfo))then
			
		-- 	GuildDataCache.setGuildInfo(_guildInfo)
		if(tonumber(my_hallLv)>=5)then
			local signCity = CityData.getSignCity()
		    local sucCity = CityData.getSucCity()
		    local occupyCity = CityData.getOcupyCityInfos()
		    local rewardCity = CityData.getRewardCity()
		    if(signCity~=nil and not table.isEmpty(sucCity) or sucCity~=nil and not table.isEmpty(signCity) or occupyCity~=nil and not table.isEmpty(occupyCity)  or rewardCity~=nil and not table.isEmpty(rewardCity))then   
			require "script/ui/teamGroup/TeamGroupData"
			local timesInfo = CityData.getTimeTable()
				if( TimeUtil.getSvrTimeByOffset()>= timesInfo.signupStart)then
					if(cityWarShow == true)then
						local inviteBtn= CCMenuItemImage:create("images/main/sub_icons/city_war_n.png", "images/main/sub_icons/city_war_h.png")
						inviteBtn:setPosition(ccp(_main_base_layer:getContentSize().width*0.6/MainScene.elementScale,_main_base_layer:getContentSize().height*0.54/MainScene.elementScale ))
						inviteBtn:setAnchorPoint(ccp(0.5,1))
						menu_bar:addChild(inviteBtn,1,_ksCityWar)
						local newAnimSprite = CCLayerSprite:layerSpriteWithName(CCString:create("images/base/effect/yao/yao"), -1,CCString:create(""));
					 	newAnimSprite:setPosition(ccp(inviteBtn:getContentSize().width*0.5,inviteBtn:getContentSize().height/2))
					 	newAnimSprite:setAnchorPoint(ccp(0.5,0.5))
						inviteBtn:addChild(newAnimSprite,-1)
						inviteBtn:registerScriptTapHandler(function ( )
							require "script/ui/copy/CityTipLayer"
							local layer = CityTipLayer.createLayer()
							MainScene.changeLayer(layer,"layer")
							inviteBtn:setVisible(false)
							cityWarShow = false
						end)
					else
						if(menu_bar:getChildByTag(_ksCityWar)~=nil)then
							menu_bar:getChildByTag(_ksCityWar):setVisible(false)
						end
					end
				end
			end
		end
		-- end
	end
end



--[[
	@des : 添加跨服赛按钮
--]]
function addLordWarButton( ... )
	if _main_base_layer == nil then
		return 
	end
	local addButton = function ( ... )
		local menu = CCMenu:create()
		menu:setPosition(ccps(0, 0))
		menu:setAnchorPoint(ccp(0, 0))
		_main_base_layer:addChild(menu)

		local button= CCMenuItemImage:create("images/lord_war/battlenormal.png", "images/lord_war/battlehigh.png")
		button:setAnchorPoint(ccp(0.5,1))
		button:setPosition(_main_base_layer:getContentSize().width*0.3/MainScene.elementScale, _main_base_layer:getContentSize().height*0.98/MainScene.elementScale)
		button:registerScriptTapHandler(lordButtonCallback)
		menu:addChild(button,1,_ksLordWar)

		-- 按钮特效
		require "script/ui/lordWar/LordWarData"
		if( TimeUtil.getSvrTimeByOffset(0) >= LordWarData.getRoundStartTime( LordWarData.kRegister ) and TimeUtil.getSvrTimeByOffset(0) <=  LordWarData.getRoundEndTime( LordWarData.kCross2To1 ) )then
		    local buttonAnimSprite2 = CCLayerSprite:layerSpriteWithName(CCString:create("images/base/effect/zhengbasaisg/zhengbasaisg"), -1,CCString:create(""))
		    buttonAnimSprite2:setAnchorPoint(ccp(0.5, 0.5))
		    buttonAnimSprite2:setPosition(ccpsprite(0.5,0.2,button))
		    button:addChild(buttonAnimSprite2,2)
		end
	end

	require "script/model/utils/ActivityConfigUtil"
	require "script/ui/lordWar/LordWarData"
	require "script/ui/lordWar/LordWarService"
	require "script/utils/NotificationUtil"
	if(ActivityConfigUtil.isActivityOpen("lordwar") == false) then
		return
	end
	local requestCallback = function ( ... )
		if(LordWarData.getLordIsOk()) then
			addButton()
		end
	end
	
	if(LordWarData.getLordIsOk())then
		addButton()
	else
		LordWarService.getLordInfo(requestCallback)
	end
end

--[[
	@des : 跨服赛入口回调
--]]
function lordButtonCallback( tag, sender )
	require "script/ui/lordWar/LordWarMainLayer"
	LordWarMainLayer.show()
end



--  删除“邀请”图标
function refreshMysterious( )

	if(_main_base_layer~=nil and _main_base_layer:getChildByTag(7327)~=nil)then
		local item = _main_base_layer:getChildByTag(7327):getChildByTag(_ksTagYao)
		print("item  is : ", item )
		print("_main_base_layer:getChildByTag(7327)  is : ", _main_base_layer:getChildByTag(7327))
		if(item ~= nil) then
			require "script/ui/teamGroup/TeamGroupData"
	        if(TeamGroupData.hasInviteMem() == false )then
	            item:setVisible(false)
	        else
	        	item:setVisible(true)
	        end
	    end
    end
end


function create()
	everydayBtn = nil
	_main_base_layer = MainScene.createBaseLayer(nil, true, true, true)

	local menu_bar = CCMenu:create()
	_cmMenuBar = menu_bar
	-- menu_bar:setPosition(0, _main_base_layer:getContentSize().height*0.05)
	menu_bar:setPosition(0, 0)
	menu_bar:setAnchorPoint(ccp(0, 0))

	-- 第一排
	local y_01 = _main_base_layer:getContentSize().height*0.05
	-- 第二排
	local y_02 = _main_base_layer:getContentSize().height*0.23
	-- 每日任务专用
	local y_03 = _main_base_layer:getContentSize().height*0.98
	-- 资源矿临时
	local y_04 = _main_base_layer:getContentSize().height*0.5
	for i=1, _nFirstLineCount do
		_sub_modules[i].pos_y = y_01
	end
	for i=_nFirstLineCount+1, _nSecondLineCount do
		_sub_modules[i].pos_y = y_02
	end
	-- 每日任务专用
	_sub_modules[12].pos_y = y_03
 

	for i=1, #_sub_modules do

		local menu_item = nil
		if(_sub_modules[i].name == "menu") then
        	--创建功能按钮
			local normal = CCMenuItemImage:create("images/main/sub_icons/function_h.png", "images/main/sub_icons/function_h.png")
			local hight  = CCMenuItemImage:create("images/main/sub_icons/function_n.png", "images/main/sub_icons/function_n.png")
			hight:setAnchorPoint(ccp(0.5, 0.5))
			normal:setAnchorPoint(ccp(0.5, 0.5))
			menu_item = CCMenuItemToggle:create(normal)
			menu_item:setAnchorPoint(ccp(0, 0))
			menu_item:addSubItem(hight)
			menu_item:registerScriptTapHandler(function_button_callback)
			function_button = menu_item

			local menu = CCMenu:create()
			menu:setAnchorPoint(ccp(0,0))
			menu:setPosition(ccp(0, 0))
			menu:setTouchPriority(-400)
			_main_base_layer:addChild(menu,3002)
			menu:addChild(menu_item, 3, _sub_modules[i].tag)

			-- added by zhz 功能按钮，怎家小红圈
			if(FriendData.getIsShowTipSprite() or MailData.getHaveNewMailStatus()== "true" or MailData.getHaveNewMailStatus()== true ) then
				showTipSprite(menu_item,true)
			end

        else
        	menu_item=CCMenuItemImage:create(getImagePath(_sub_modules[i].name), getImagePath(_sub_modules[i].name, true))
        	menu_item:registerScriptTapHandler(menu_item_tap_handler)
        	menu_bar:addChild(menu_item, 1, _sub_modules[i].tag)
        end
		-- menu_item:setPosition(MainScene.getMenuPositionInTruePointByLayer(_main_base_layer,_main_base_layer:getContentSize().width*(_sub_modules[i].pos_x/g_originalDeviceSize.width), _sub_modules[i].pos_y))
		menu_item:setPosition(ccp(_sub_modules[i].pos_x*g_fScaleX/MainScene.elementScale, _sub_modules[i].pos_y/MainScene.elementScale))
		if(_sub_modules[i].anchorPoint)then
			menu_item:setAnchorPoint(_sub_modules[i].anchorPoint)
		else
			menu_item:setAnchorPoint(ccp(0,0))
		end
		
        if(_sub_modules[i].name=="chat")then
            local animSprite = CCLayerSprite:layerSpriteWithName(CCString:create("images/base/effect/chat/liaotian"), -1,CCString:create(""));
            animSprite:setAnchorPoint(ccp(0.5,0.5))
            animSprite:setPosition(ccp(menu_item:getContentSize().width*0.52,menu_item:getContentSize().height*0.55))
            menu_item:addChild(animSprite,1,1911)
            animSprite:setVisible(_isShowChatAnimation)

             -- 私人聊天的提示 , added by zhz
             local pChatTipSp= CCSprite:create("images/common/tip_2.png")
             pChatTipSp:setAnchorPoint(ccp(1,1))
             pChatTipSp:setPosition(ccp(menu_item:getContentSize().width*0.97 ,menu_item:getContentSize().height*0.98))
             menu_item:addChild(pChatTipSp,1,1914)
             require "script/ui/chat/ChatMainLayer"
             pChatTipSp:setVisible(ChatMainLayer.getNewPmCount() > 0)
        end

        if(_sub_modules[i].name=="horoscope")then
            local alertSprite = CCSprite:create("images/common/tip_2.png")
            alertSprite:setAnchorPoint(ccp(0.5,0.5))
            alertSprite:setPosition(ccp(menu_item:getContentSize().width*0.8,menu_item:getContentSize().height*0.8))
            menu_item:addChild(alertSprite,1,1915)
            alertSprite:setVisible(_isAstroAlert)
        end
        if _sub_modules[i].name== "guild" then
        	-- 军团小红圈
        	-- print("CityData.getIsShowTip()",CityData.getIsShowTip())
        	-- print("GuildDataCache.isShowTip()",GuildDataCache.isShowTip())
        	-- print("GuildDataCache.getIsShowRedTip()",GuildDataCache.getIsShowRedTip())
        	if( GuildDataCache.getIsShowRedTip() )then
	        	local alertSprite = CCSprite:create("images/common/tip_2.png")
	            alertSprite:setAnchorPoint(ccp(0.5,0.5))
	            alertSprite:setPosition(ccp(menu_item:getContentSize().width*0.8,menu_item:getContentSize().height*0.8))
	            menu_item:addChild(alertSprite,1,1998)
	        end
        end
        if _sub_modules[i].name== "everyday" then
        	everydayBtn = menu_item
        end

        require "script/ui/pet/PetData"
        if _sub_modules[i].name == "pet" then
        	if PetData.isShowTip() then
        	    local alertSprite = CCSprite:create("images/common/tip_2.png")
	            alertSprite:setAnchorPoint(ccp(0.5,0.5))
	            alertSprite:setPosition(ccp(menu_item:getContentSize().width*0.8,menu_item:getContentSize().height*0.8))
	            menu_item:addChild(alertSprite,1,1998)
        	end
        end

        --如果功能节点开启天命，DataCache.getSwitchNodeState(ksSwitchDestiny, false) 中的 false 表示不显示提示框
        if _sub_modules[i].name == "destiny" and DataCache.getSwitchNodeState(ksSwitchDestiny, false) then
        	require "script/ui/destiny/DestinyData"
        	--如果当前有天命可以点 
        	if DestinyData.canUpDestiny() then
        	    local alertSprite = CCSprite:create("images/common/tip_2.png")
	            alertSprite:setAnchorPoint(ccp(0.5,0.5))
	            alertSprite:setPosition(ccp(menu_item:getContentSize().width*0.8,menu_item:getContentSize().height*0.8))
	            menu_item:addChild(alertSprite,1,1998)
        	end
        end
	end

	-- init function panel
	menuPanel = CCScale9Sprite:create("images/main/sub_icons/menu_bg.png")
	menuPanel:setContentSize(CCSizeMake(520,147))
	menuPanel:setAnchorPoint(ccp(1, 0))
	menuPanel:setPosition(function_button:getPositionX()*MainScene.elementScale + function_button:getContentSize().width/2*MainScene.elementScale, function_button:getPositionY()*MainScene.elementScale + function_button:getContentSize().height/2*MainScene.elementScale)
	_main_base_layer:addChild(menuPanel, 3000)
	function_button:setSelectedIndex(0)
	menuPanel:setScale(0)

	_menuPanelMenu = CCMenu:create()
	_menuPanelMenu:setAnchorPoint(ccp(0,0))
	_menuPanelMenu:setPosition(ccp(0,0))
	menuPanel:addChild(_menuPanelMenu)
	_menuPanelMenu:setTouchPriority(-400)
   
	--好友按钮
   	local friendButton=CCMenuItemImage:create(getImagePath("friend"), getImagePath("friend", true))
	friendButton:registerScriptTapHandler(menu_item_tap_handler)
	_menuPanelMenu:addChild(friendButton, 1, _ksTagFriend)
	friendButton:setAnchorPoint(ccp(0, 0.5))
	--邮件按钮
   	local mailButton=CCMenuItemImage:create(getImagePath("mail"), getImagePath("mail", true))
	mailButton:registerScriptTapHandler(menu_item_tap_handler)
	_menuPanelMenu:addChild(mailButton, 1, _ksTagMail)
	mailButton:setAnchorPoint(ccp(0, 0.5))

	--成就按钮
   	local achievementButton=CCMenuItemImage:create(getImagePath("achiev"), getImagePath("achiev", true))
	achievementButton:registerScriptTapHandler(menu_item_tap_handler)
	_menuPanelMenu:addChild(achievementButton, 1, _ksTagAchievement)
	achievementButton:setAnchorPoint(ccp(0, 0.5))
	
	--菜单按钮
   	local menuButton=CCMenuItemImage:create(getImagePath("menu"), getImagePath("menu", true))
	menuButton:registerScriptTapHandler(menu_item_tap_handler)
	_menuPanelMenu:addChild(menuButton, 1, _ksTagMenu)
	menuButton:setAnchorPoint(ccp(0, 0.5))
    
    --add by DJN 2014/9/3 新增排行榜系统 -------------------------------------------------------------------------------
    require "script/model/user/UserModel"
	--if(UserModel.getHeroLevel()>20)then
		--排行榜系统按钮
	    local rankButton  = CCMenuItemImage:create(getImagePath("rank"), getImagePath("rank", true))
	    rankButton:registerScriptTapHandler(menu_item_tap_handler)
	    _menuPanelMenu:addChild(rankButton, 1, _ksTagRank)
		rankButton:setAnchorPoint(ccp(0, 0.5))

		menuPanel:setContentSize(CCSizeMake(540,147))
		local mw = (menuPanel:getContentSize().width - 40)/5 
		local py = menuPanel:getContentSize().height/2
		rankButton:setPosition(17 + mw*0,py)
		friendButton:setPosition(27 + mw*1, py)
		achievementButton:setPosition(27 + mw*2, py)
		mailButton:setPosition(27 +mw*3, py)
		menuButton:setPosition(27+ mw*4, py)
	-- else
	--     local mw = (menuPanel:getContentSize().width - 80)/4 --friendButton:getContentSize().width + 12
	-- 	local py = menuPanel:getContentSize().height/2
	--     friendButton:setPosition(43 + mw*0, py)
	-- 	achievementButton:setPosition(43 + mw*1, py)
	-- 	mailButton:setPosition(43 +mw*2, py)
	-- 	menuButton:setPosition(43+ mw*3, py)
 --    end
    ------------------------------------------------------------------------------------------------------------------
	addHighlightsButton(menu_bar)
	addRewardCenter()
	addGuildInvite(menu_bar)
	addMysterious(menu_bar)
	addCityWar(menu_bar)
	addLordWarButton()

	_main_base_layer:addChild(menu_bar,0,7327)

	require "script/ui/online/OnlineRewardBtn"
   	require "script/ui/main/MainScene"
 	OnlineRewardBtn.createOnlineRewardBtn(_main_base_layer)   	
   	require "script/ui/sign/SignRewardLayer"
   	SignRewardLayer.createSingBtn(_main_base_layer)

   	 -- 累计签到（也就是开服活动）
    require "script/ui/sign/AccSignRewardLayer"
   	AccSignRewardLayer.createAccSingBtn(_main_base_layer)

   	-- 等级礼包
   	require "script/ui/level_reward/LevelRewardBtn"
   	LevelRewardBtn.createLevelRewardBtn(_main_base_layer)
   	print("create level_reward_btn create")

   	-- 新邮件提示 new
   
   	MailData.isHaveNewMail = MailData.getHaveNewMailStatus()
	print("MainBaseLayer isHaveNewMail",MailData.isHaveNewMail)
	if(MailData.isHaveNewMail == "true" or MailData.isHaveNewMail == true )then
		require "script/ui/main/MainBaseLayer"
		local mailButton = MainBaseLayer.getMainMenuItem(_ksTagMail)
		if(mailButton ~= nil)then
			local button = tolua.cast(mailButton,"CCNode")
			if(button:getChildByTag(10) == nil)then
				local newAnimSprite = CCLayerSprite:layerSpriteWithName(CCString:create("images/mail/new/new"), -1,CCString:create(""));
        		newAnimSprite:setPosition(ccp(button:getContentSize().width*0.5-20,button:getContentSize().height-10))
       			button:addChild(newAnimSprite,3,10)
			end
		end
	end

	-- 天命按钮上提示红圈 added by zhangqiang
	require "script/ui/replaceSkill/ReplaceSkillData"
	local isShowTip = ReplaceSkillData.isShowTip()
	local menuItem = getMainMenuItem(_ksTagDestiny)
	showTipSprite(menuItem, isShowTip)

   	-- 好友按钮上提示红圈
   	require "script/ui/friend/FriendData"
   	local isShowTip = FriendData.getIsShowTipSprite()
	local menuItem = getMainMenuItem( _ksTagFriend )
	print("friend isShowTip ---", isShowTip)
	showTipSprite(menuItem,isShowTip)

	-- 装备按钮上的提示红圈
   	local isShowTip = BagUtil.isShowTipSprite()
	local menuItem = getMainMenuItem( _ksTagEquip )
	showTipSprite(menuItem,isShowTip)

	-- 每日任务按钮上的红点
	require "script/ui/everyday/EverydayData"
	local isShowTip = EverydayData.getIsShowTipSprite()
	local menuItem = getMainMenuItem( _ksTagEveryDay )
	showTipSprite(menuItem,isShowTip)
	
   	-- 控制台
   	if g_debug_mode then
		require "script/consoleExe/ConsoleBtn"
		ConsoleBtn.createConsoleBtn(_main_base_layer)
	end
	--武将按钮
	local heroButton = getMainMenuItem(_ksTagHero)
   	require "script/model/hero/HeroModel"
   	HeroModel.initNewHero()
	if(HeroModel.isHaveNewHero() == true) then
		local newAnimSprite = CCLayerSprite:layerSpriteWithName(CCString:create("images/mail/new/new"), -1,CCString:create(""));
	 	newAnimSprite:setPosition(ccp(heroButton:getContentSize().width*0.5-20,heroButton:getContentSize().height-20))
		heroButton:addChild(newAnimSprite,3,ksNewEffectTag)

		print("add new hero effect!!!")
	end
	require "script/ui/hero/HeroSoulLayer"
	print(GetLocalizeStringBy("key_1097"), HeroSoulLayer.getFuseSoulNum())
	if(HeroSoulLayer.getFuseSoulNum() > 0) then
		local tipSprite = CCSprite:create("images/common/tip_2.png")
		tipSprite:setAnchorPoint(ccp(0.5, 0.5))
		tipSprite:setPosition(ccpsprite(0.85,0.85, heroButton))
		heroButton:addChild(tipSprite)
	end

	return _main_base_layer
end

-- 加入“奖励中心”按钮
function addRewardCenter()
	if _main_base_layer == nil then
		return 
	end
	local ccRewardCenter = _main_base_layer:getChildByTag(_ksTagOfRewardCenter)
	if ccRewardCenter or not DataCache.getRewardCenterStatus() then
		return
	end
	-- 加入GetLocalizeStringBy("key_3087")特效按钮
	local imgPath = CCString:create("images/base/effect/baoxiang/baoxiang")
	local bonusCenter = CCLayerSprite:layerSpriteWithNameAndCount(imgPath:getCString(), -1,CCString:create(""))
	bonusCenter:setPosition(435*g_fScaleX, _main_base_layer:getContentSize().height*0.7)
	local ccMenuOnBonusCenter = CCMenu:create()
	ccMenuOnBonusCenter:setPosition(-42, 0)
	ccMenuOnBonusCenter:setAnchorPoint(ccp(0, 0))
	local spriteTransparent = CCScale9Sprite:create("images/common/transparent.png", CCRectMake(0, 0, 3, 3), CCRectMake(1, 1, 1, 1))
	spriteTransparent:setPreferredSize(CCSizeMake(84, 62))
	local ccMenuItemOfBonusCenter = CCMenuItemSprite:create(spriteTransparent, spriteTransparent)
	ccMenuItemOfBonusCenter:setPosition(0, 0)
	ccMenuItemOfBonusCenter:setAnchorPoint(ccp(0, 0))
	ccMenuItemOfBonusCenter:registerScriptTapHandler(fnHandlerOfBonusCenter)
	ccMenuOnBonusCenter:addChild(ccMenuItemOfBonusCenter)
	bonusCenter:addChild(ccMenuOnBonusCenter)
	_main_base_layer:addChild(bonusCenter, 1000, _ksTagOfRewardCenter)
end

-- 删除“奖励中心”图标
function removeRewardCenter( ... )
	require "script/model/DataCache"
	DataCache.setRewardCenterStatus(false)
	local ccRewardCenter
	if _main_base_layer then
		ccRewardCenter = _main_base_layer:getChildByTag(_ksTagOfRewardCenter)
		if ccRewardCenter then
			ccRewardCenter:removeFromParentAndCleanup(true)
		end
	end
end

function setVisible(visible)
	if (type(visible) ~= type(true)) then
		CCLuaLog ("MainBaseLayer.setVisible needs a parameter.")
		return
	end
	if visible then
		_main_base_layer:setVisible(true)
	else
		_main_base_layer:setVisible(false)
	end
end

function showChatAnimation(isShow)
    _isShowChatAnimation = isShow
    --    print("showChatAnimation:",isShow,_main_base_layer,_main_base_layer:getChildByTag(7327))
    if(_main_base_layer~=nil and _main_base_layer:getChildByTag(7327)~=nil)then
        if(_isShowChatAnimation==true)then
            local animSprite = _main_base_layer:getChildByTag(7327):getChildByTag(_ksTagChat):getChildByTag(1911)
            animSprite:setVisible(true)
        else
            local animSprite = _main_base_layer:getChildByTag(7327):getChildByTag(_ksTagChat):getChildByTag(1911)
            animSprite:setVisible(false)
        end
    end
end


-- 显示聊天的小红圈, added by zhz
function showChatTip( tipNum)

	local tipNum= tonumber(tipNum)
	if(_main_base_layer~=nil and _main_base_layer:getChildByTag(7327)~=nil)then
        if(tipNum> 0)then
			local tipSprite = _main_base_layer:getChildByTag(7327):getChildByTag(_ksTagChat):getChildByTag(1914)  
            tipSprite:setVisible(true)
            
            --[[
            local numberLabel= tolua.cast(tipSprite:getChildByTag(101),"CCLabelTTF") 
            numberLabel:setString(tipNum)
            --]]
       else
            local tipSprite = _main_base_layer:getChildByTag(7327):getChildByTag(_ksTagChat):getChildByTag(1914)  
            tipSprite:setVisible(false)
        end
    end
	
end

function showAstroAlert(isShow)
    _isAstroAlert = isShow
    --    print("showChatAnimation:",isShow,_main_base_layer,_main_base_layer:getChildByTag(7327))
    if(_main_base_layer~=nil and _main_base_layer:getChildByTag(7327)~=nil)then
        if(_isAstroAlert==true)then
            local animSprite = _main_base_layer:getChildByTag(7327):getChildByTag(_ksTagHoroscope):getChildByTag(1915)
            animSprite:setVisible(true)
        else
            local animSprite = _main_base_layer:getChildByTag(7327):getChildByTag(_ksTagHoroscope):getChildByTag(1915)
            animSprite:setVisible(false)
        end
    end
end

function exit( ... )
	_main_base_layer = nil
	_cmMenuBar	= nil
end

-- 释放“主场景中间层”所占资源
function release()

end

-- addBy licong 2013.09.06 用于新手引导
-- 获得菜单项各个项的对象
-- 参数为item的tag值
function getMainMenuItem(tag)
	print("_cmMenuBar == ",_cmMenuBar)
	print("tag == ",tag)
	if(_cmMenuBar == nil )then
		return 
	end
	if(_cmMenuBar:getChildByTag(tag) ~= nil) then
		return _cmMenuBar:getChildByTag(tag)
	else
		return _menuPanelMenu:getChildByTag(tag)
	end
end

-- 得到每日任务按钮
function getEverydayBtn( ... )
	return everydayBtn
end

-- 按钮上边的提示小红圈
-- 添加对象  item
-- isVisible 是否显示
function showTipSprite( item, isVisible )
	if(item == nil)then
		return
	end
	if( item:getChildByTag(1915) ~= nil )then
		local tipSprite = tolua.cast(item:getChildByTag(1915),"CCSprite")
		tipSprite:setVisible(isVisible)
	else
		local tipSprite = CCSprite:create("images/common/tip_2.png")
	    tipSprite:setAnchorPoint(ccp(0.5,0.5))
	    tipSprite:setPosition(ccp(item:getContentSize().width*0.8,item:getContentSize().height*0.8))
	    item:addChild(tipSprite,1,1915)
	    tipSprite:setVisible(isVisible)
	end
end


--[[
	@des :	删除新武将按钮提示	
--]]
function removeNewHeroButton( ... )
	local menuItem 	= getMainMenuItem(_ksTagHero)
	if(menuItem == nil ) then
		return
	end
	local effectNoe = tolua.cast(menuItem:getChildByTag(ksNewEffectTag), "CCNode")
	if(effectNoe == nil) then
		return
	end
	effectNoe:removeFromParentAndCleanup(true)
	print("remove new hero effect")
end

--[[
	@des 	:	武将按钮添加new提示
--]]

function addNewHeroButton( ... )
	local heroButton = getMainMenuItem(_ksTagHero)
	if(heroButton == nil) then
		return
	end
	local effectNoe = tolua.cast(heroButton:getChildByTag(ksNewEffectTag), "CCNode")
	if(heroButton ~= nil and effectNoe == nil) then
		local newAnimSprite = CCLayerSprite:layerSpriteWithName(CCString:create("images/mail/new/new"), -1,CCString:create(""));
 		newAnimSprite:setPosition(ccp(heroButton:getContentSize().width*0.5-20,heroButton:getContentSize().height-20))
		heroButton:addChild(newAnimSprite,3,ksNewEffectTag)
	end
end



function function_button_callback(tag, sender)
	local toggleItem  = tolua.cast(sender, "CCMenuItemToggle")
	local selectIndex = toggleItem:getSelectedIndex()

	if(selectIndex == 0) then
		print("toogle 0 select index:", selectIndex)
		menuPanel:stopAllActions()
		local action = CCScaleTo:create(0.2, 0)
		menuPanel:runAction(action)
		if(_maksLayer) then
			_maksLayer:removeFromParentAndCleanup(true)
		end
	else
		print("toogle select index:",selectIndex)
		showMaskLayer()
		menuPanel:stopAllActions()
		local action = CCScaleTo:create(0.2, 1 * MainScene.elementScale)
		menuPanel:runAction(action)
	end
end

function showMaskLayer( ... )
	local touchRect = getSpriteScreenRect(menuPanel)
	local layer = CCLayer:create()
    layer:setPosition(ccp(0, 0))
    layer:setAnchorPoint(ccp(0, 0))
    layer:setTouchEnabled(true)
    layer:setTouchPriority(-300)
    layer:registerScriptTouchHandler(function ( eventType,x,y )
        if(eventType == "began") then
            if(touchRect:containsPoint(ccp(x,y))) then
                return false
            else
                menuPanel:stopAllActions()
				local action = CCScaleTo:create(0.2, 0)
				menuPanel:runAction(action)
				layer:removeFromParentAndCleanup(true)
				_maksLayer = nil
				function_button:setSelectedIndex(0)
                return true
            end
        end
    end,false, -300, true)
	local gw,gh = g_winSize.width/MainScene.elementScale, g_winSize.height/MainScene.elementScale
    local layerColor = CCLayerColor:create(ccc4(0,0,0,layerOpacity or 150),gw,gh)
    layerColor:setPosition(ccp(0,0))
    layerColor:setAnchorPoint(ccp(0,0))
    layer:addChild(layerColor)
 	_maksLayer = layer
 	local onRunningLayer = MainScene.getOnRunningLayer()
 	onRunningLayer:addChild(layer,2500, _mask_layer_tag)
end


