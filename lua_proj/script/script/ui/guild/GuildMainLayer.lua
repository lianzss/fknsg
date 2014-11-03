-- Filename：	GuildMainLayer.lua
-- Author：		Cheng Liang
-- Date：		2013-12-20
-- Purpose：		军团主界面

module ("GuildMainLayer", package.seeall)


require "script/ui/guild/GuildBottomSprite"
require "script/ui/guild/GuildUtil"
require "script/ui/guild/GuildBuildingItem"
require "script/ui/guild/UpgradeAlertTip"
require "db/DB_Legion_feast"
require "db/DB_Legion_shop"
require "db/DB_Legion_copy"
require "script/ui/guild/city/CityData"
------------------------------------------- added by bzx
require "script/ui/guild/city/CityData"

local CityFireStatus = {
    sign_up     = 1,
    fighting    = 2,
    reward      = 3
}
local _city_fire_status_tag     = nil           -- 城池争夺下面显示的状态
local _timer_refresh_status     = nil
-------------------------------------------


Tag_Hall 		= 2001 -- 军团大厅/忠义堂
Tag_Guanyu 		= 2002 -- 关公殿
Tag_Shop 		= 2003 -- 军团商城
Tag_Guanxintai 	= 2004 -- 观星台
Tag_Book 		= 2005 -- 军团书院
Tag_Military	= 2006 -- 军机大厅




local va_hall_index 		= 1 	-- 公告等信息的下标
local va_zhongyitang_index 	= 2 	-- 忠义堂的下标
local va_guanyu_index 		= 3 	-- 关公殿的下标
local va_shop_index 		= 4 	-- 关公殿的下标
local va_military_index 	= 5 	-- 军机大厅下标
local va_book_index			= 6     -- 军团任务下标

local buildingPosArr 		= {} 	-- 建筑的坐标



local _bgLayer 			= nil
local _noticeLabel		= nil 	-- 公告	


local _hallLvLabel		= nil 	-- 军团等级
local _guanyuLvLabel	= nil 	-- 关公殿等级
local _shopLvLabel 		= nil 	-- 商店等级
local _militaryLvLabel 	= nil 	-- 军机大厅等级


local _guildInfo 		= nil 	-- 军团信息
local _sigleGuildInfo 	= nil 	-- 个人在军团中的信息

-- local _guildLevelLabel 	= nil 	-- 军团等级
local _guildNameLabel 	= nil 	-- 军团名称
local _sigleDonateLabel	= nil 	-- 个人贡献
local _guildDonateLabel = nil 	-- 军团贡献
local _memberNumLable 	= nil 	-- 成员


local sigleDonateSprite = nil 	-- 个人贡献
local memberSprite 		= nil 	-- 成员
local guildSprite 		= nil 	-- 军团贡献

local _bottomSpite 		= nil 	-- 底部	
local b_Sprite 			= nil 	-- 黑色的底


local _upgradeHallItem 		= nil 	-- 军团大厅升级按钮
local _upgradeGuanyuItem 	= nil 	-- 关公殿升级按钮
local _upgradeShopItem 		= nil 	-- 商城升级按钮
local _upgradeMilitaryItem 	= nil 	-- 军机大厅升级按钮
local cityFireItem 			= nil   -- 城战按钮
local tipSprite 			= nil 	-- 提示按钮

local timesInfo 			= nil   -- 时间表

local function init()
	_bgLayer 			= nil
	_noticeLabel		= nil

	_hallLvLabel		= nil
	_guanyuLvLabel		= nil
	_shopLvLabel 		= nil 	-- 商店等级

	_guildInfo 			= nil

	buildingPosArr 		= {} 	-- 建筑的坐标

	_bottomSpite 		= nil

	-- _guildLevelLabel 	= nil
	_guildNameLabel 	= nil
	_sigleDonateLabel	= nil
	_guildDonateLabel 	= nil
	_memberNumLable 	= nil
	_sigleGuildInfo 	= nil

	_upgradeHallMenu	= nil
	_upgradeGuanyuMenu 	= nil

	_upgradeHallItem 	= nil 	-- 军团大厅升级按钮
	_upgradeGuanyuItem 	= nil 	-- 关公殿升级按钮
	_upgradeShopItem 	= nil 	-- 商城升级按钮

	sigleDonateSprite 	= nil 	-- 个人贡献
	memberSprite 		= nil 	-- 成员
	guildSprite 		= nil 	-- 军团贡献
	b_Sprite 			= nil 	-- 黑色的底
    
    _city_fire_status_tag   = nil
    -- _timer_refresh_status   = nil
    _citys_report           = {}
    
	cityFireItem 		= nil   -- 城战按钮
end


--@desc	 回调onEnter和onExit时间
local function onNodeEvent( event )
	if (event == "enter") then
		GuildDataCache.setIsInGuildFunc(true)
	elseif (event == "exit") then
		GuildDataCache.setIsInGuildFunc(false)
        timerRefreshStatusEnd()
	end
end

-- 刷新所有UI
function refreshAllUI()
	-- 刷新公告
	refreshNotice()
	-- 刷新建筑等级
	refreshBuildingStatus()
	-- 刷新军团等级等
	refreshGuildAttr()
	-- 刷新建筑物升级状态
	refreshBuildingUpgradeStatus()
end

-- 刷新公告
function refreshNotice()
	_noticeLabel:setString(_guildInfo.va_info[va_hall_index].post)
end

-- 刷新建筑等级
function refreshBuildingStatus()
	-- body
	_hallLvLabel:setString("Lv." .. _guildInfo.guild_level)
	_guanyuLvLabel:setString("Lv." .. _guildInfo.va_info[va_guanyu_index].level)
	_shopLvLabel:setString("Lv." .. _guildInfo.va_info[va_shop_index].level)
	_militaryLvLabel:setString("Lv." .. _guildInfo.va_info[va_military_index].level)
	_bookLvLabel:setString("Lv." .._guildInfo.va_info[va_book_index].level  )
end

-- 刷新军团等级等
function refreshGuildAttr()
	local myScale = _bgLayer:getContentSize().width/_bottomSpite:getContentSize().width/_bgLayer:getElementScale()
	local bottomSpiteSize = _bottomSpite:getContentSize()
	local bgLayerSize = _bgLayer:getContentSize()
	-- 军团名字标题
	if(_guildNameLabel)then
		_guildNameLabel:removeFromParentAndCleanup(true)
		_guildNameLabel = nil
	end
	_guildNameLabel = CCRenderLabel:create(_guildInfo.guild_name .. "  Lv." .. _guildInfo.guild_level, g_sFontPangWa, 20, 1, ccc3(0,0,0), type_stroke)
	_guildNameLabel:setColor(ccc3(0xfe, 0xdb, 0x1c))
	_guildNameLabel:setAnchorPoint(ccp(0.5, 0.5))
	_guildNameLabel:setPosition(ccp(b_Sprite:getContentSize().width*0.2, b_Sprite:getContentSize().height*0.7))
	-- _guildNameLabel:setScale(myScale)
	b_Sprite:addChild(_guildNameLabel)

	-- 个人贡献Label
	if(_sigleDonateLabel)then
		_sigleDonateLabel:removeFromParentAndCleanup(true)
		_sigleDonateLabel = nil
	end
	_sigleDonateLabel = CCRenderLabel:create(_sigleGuildInfo.contri_point, g_sFontPangWa, 20, 1, ccc3(0,0,0), type_stroke)
	_sigleDonateLabel:setColor(ccc3(0xff, 0xff, 0xff))
	_sigleDonateLabel:setAnchorPoint(ccp(0, 0.5))
	_sigleDonateLabel:setPosition(ccp( sigleDonateSprite:getContentSize().width+ 5, sigleDonateSprite:getContentSize().height*0.5))
	-- _sigleDonateLabel:setScale(myScale)
	sigleDonateSprite:addChild(_sigleDonateLabel)

	-- 成员Label
	if(_memberNumLable)then
		_memberNumLable:removeFromParentAndCleanup(true)
		_memberNumLable = nil
	end
	require "script/ui/guild/GuildDataCache"
	_memberNumLable = CCRenderLabel:create(_guildInfo.member_num .. "/" .. GuildDataCache.getMemberLimit(), g_sFontPangWa, 20, 1, ccc3(0,0,0), type_stroke)
	_memberNumLable:setColor(ccc3(0xff, 0xff, 0xff))
	_memberNumLable:setAnchorPoint(ccp(0, 0.5))
	_memberNumLable:setPosition(ccp( memberSprite:getContentSize().width+ 5, memberSprite:getContentSize().height*0.5))
	-- _memberNumLable:setScale(myScale)
	memberSprite:addChild(_memberNumLable)

	-- 军团贡献Label
	if(_guildDonateLabel)then
		_guildDonateLabel:removeFromParentAndCleanup(true)
		_guildDonateLabel = nil
	end
	_guildDonateLabel = CCRenderLabel:create(_guildInfo.curr_exp, g_sFontPangWa, 20, 1, ccc3(0,0,0), type_stroke)
	_guildDonateLabel:setColor(ccc3(0xff, 0xff, 0xff))
	_guildDonateLabel:setAnchorPoint(ccp(0, 0.5))
	_guildDonateLabel:setPosition(ccp( guildSprite:getContentSize().width + 5, guildSprite:getContentSize().height*0.5))
	-- _guildDonateLabel:setScale(myScale)
	guildSprite:addChild(_guildDonateLabel)

end

-- 刷新建筑物升级状态
function refreshBuildingUpgradeStatus()

	local mineSigleInfo = GuildDataCache.getMineSigleGuildInfo()
	if(tonumber(mineSigleInfo.member_type) == 0 )then

		_upgradeHallItem:setVisible(false)
		_upgradeGuanyuItem:setVisible(false)
		_upgradeShopItem:setVisible(false)
		_upgradeMilitaryItem:setVisible(false)
		_upgradeBookItem:setVisible(false)

		return
	end

	-- 军团大厅
	local hallNeedExp = GuildUtil.getNeedExpByLv(tonumber(_guildInfo.guild_level) +1 ) 
	if(tonumber(_guildInfo.curr_exp)>= tonumber(hallNeedExp) and tonumber(_guildInfo.guild_level) < GuildUtil.getMaxGuildLevel() )then
		_upgradeHallItem:setVisible(true)
	else
		_upgradeHallItem:setVisible(false)
	end

	-- 关公殿
	local guanyuNeedExp = GuildUtil.getGuanyuNeedExpByLv(tonumber(_guildInfo.va_info[va_guanyu_index].level) + 1)
	if( tonumber(_guildInfo.curr_exp)>= tonumber(guanyuNeedExp) and tonumber(_guildInfo.va_info[va_guanyu_index].level) < math.ceil(tonumber(_guildInfo.guild_level)*DB_Legion_feast.getDataById(1).levelRatio/100) )then
		_upgradeGuanyuItem:setVisible(true)
	else
		_upgradeGuanyuItem:setVisible(false)
	end

	-- 商城
	local shopNeedExp = GuildUtil.getShopNeedExpByLv(tonumber(_guildInfo.va_info[va_shop_index].level) + 1)
	if( tonumber(_guildInfo.curr_exp)>= tonumber(shopNeedExp) and tonumber(_guildInfo.va_info[va_shop_index].level) < math.ceil(tonumber(_guildInfo.guild_level)*DB_Legion_shop.getDataById(1).levelRatio/100) )then
		_upgradeShopItem:setVisible(true)
	else
		_upgradeShopItem:setVisible(false)
	end

	-- 军机大厅
	local militaryNeedExp = GuildUtil.getMilitaryNeedExpByLv(tonumber(_guildInfo.va_info[va_military_index].level) + 1)
	if( tonumber(_guildInfo.curr_exp)>= tonumber(militaryNeedExp) and tonumber(_guildInfo.va_info[va_military_index].level) < math.ceil(tonumber(_guildInfo.guild_level)*DB_Legion_copy.getDataById(1).levelRatio/100) )then
		_upgradeMilitaryItem:setVisible(true)
	else
		_upgradeMilitaryItem:setVisible(false)
	end

	-- 军团书院（军团任务）
	local NeedExp = GuildUtil.getMilitaryNeedExpByLv(tonumber(_guildInfo.va_info[va_book_index].level) + 1)
	if( tonumber(_guildInfo.curr_exp)>= tonumber(NeedExp) and tonumber(_guildInfo.va_info[va_book_index].level) < math.ceil(tonumber(_guildInfo.guild_level)*DB_Legion_copy.getDataById(1).levelRatio/100) )then
		_upgradeBookItem:setVisible(true)
	else
		_upgradeBookItem:setVisible(false)
	end



end

-- 修改公告
function modifyAction( tag, itemBtn )
	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
	require "script/ui/guild/GuildDeclarationLayer"
	GuildDeclarationLayer.showLayer(1002)
end

-- 创建公告
function createTop()
	local topSprite = CCSprite:create("images/guild/bg_notice.png")
	local myScale = _bgLayer:getContentSize().width/topSprite:getContentSize().width/_bgLayer:getElementScale()
	topSprite:setAnchorPoint(ccp(0.5, 1))
	topSprite:setPosition(ccp(_bgLayer:getContentSize().width*0.5, _bgLayer:getContentSize().height))
	topSprite:setScale(myScale)
	_bgLayer:addChild(topSprite)

	-- 标题
	local noticeTittleSprite = CCSprite:create("images/guild/notice_title.png")
	noticeTittleSprite:setAnchorPoint(ccp(0.5, 1))
	noticeTittleSprite:setPosition(ccp(topSprite:getContentSize().width*0.5, topSprite:getContentSize().height))
	topSprite:addChild(noticeTittleSprite)

	local topSpriteSize = topSprite:getContentSize()

	-- 公告
	_noticeLabel = CCLabelTTF:create("", g_sFontName, 22, CCSizeMake(580, 80), kCCTextAlignmentLeft, kCCVerticalTextAlignmentCenter)
	_noticeLabel:setAnchorPoint(ccp(0.5, 0.5))
	_noticeLabel:setPosition(ccp(topSpriteSize.width*0.5, topSpriteSize.height*0.5))
	topSprite:addChild(_noticeLabel)

	local topMenuBar = CCMenu:create()
	topMenuBar:setPosition(ccp(0,0))
	topSprite:addChild(topMenuBar)

	local mineSigleInfo = GuildDataCache.getMineSigleGuildInfo()
	if( tonumber(mineSigleInfo.member_type) == 1 or tonumber(mineSigleInfo.member_type) == 2)then
		-- 修改的按钮
		local modifyBtn = CCMenuItemImage:create("images/guild/btn_modify_n.png","images/guild/btn_modify_h.png")
		modifyBtn:setAnchorPoint(ccp(0.5, 0.5))
		modifyBtn:registerScriptTapHandler(modifyAction)
		modifyBtn:setPosition(ccp(topSpriteSize.width*0.85, topSpriteSize.height*0.25))
		topMenuBar:addChild(modifyBtn)
	end
end

-- 创建底部
function createBottom()
	_bottomSpite = GuildBottomSprite.createBottomSprite(true)
	_bgLayer:addChild(_bottomSpite)
	local myScale = _bgLayer:getContentSize().width/_bottomSpite:getContentSize().width/_bgLayer:getElementScale()
	_bottomSpite:setScale(myScale)
end

-- 建筑Action
function buildingAction( tag, itemBtn )
	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
	if(tag == Tag_Hall)then
		-- 军团大厅
		-- require "script/ui/guild/GuildHallLayer"
		-- local guildHallLayer = GuildHallLayer.createLayer() 
		-- MainScene.changeLayer(guildHallLayer, "guildHallLayer")

		RequestCenter.guild_record(recordCallBack)

	elseif(tag == Tag_Guanyu)then
		-- 关公殿
		require "script/ui/guild/GuangongTempleLayer"
		local guangongTempleLayer = GuangongTempleLayer.showLayer() 
		MainScene.changeLayer(guangongTempleLayer, "guangongTempleLayer")
	elseif( tag == Tag_Shop )then
		-- 商城
		require "script/ui/guild/GuildShopLayer"
		local guildShopLayer= GuildShopLayer.createLayer()
		MainScene.changeLayer(guildShopLayer, "guildShopLayer")
	elseif( tag == Tag_Military)then
		-- 军机大厅
		require "script/ui/guild/copy/GuildCopyLayer"
		local guildCopyLayer= GuildCopyLayer.createLayer()
		MainScene.changeLayer(guildCopyLayer, "guildCopyLayer")
	elseif (tag == Tag_Book) then
		require "script/ui/battlemission/MissionLayer"
		MissionLayer.showLayer()
	else
		AnimationTip.showTip(GetLocalizeStringBy("key_3212"))

	end
end

-- 拉数据回调
function recordCallBack( cbFlag, dictData, bRet )
	if(dictData.err == "ok") then
		GuildDataCache._recordList = dictData.ret

		require "script/ui/guild/GuildHallLayer"
		local guildHallLayer = GuildHallLayer.createLayer() 
		MainScene.changeLayer(guildHallLayer, "guildHallLayer")
	end
end

-- 升级回调
function afterUpgradeDelegate( upgrade_building_type )
	if(upgrade_building_type == Tag_Hall)then

	elseif(upgrade_building_type == Tag_Guanyu)then

	elseif(upgrade_building_type == Tag_Shop)then

	end

	-- 特效特效
	local spellEffectSprite = CCLayerSprite:layerSpriteWithName(CCString:create("images/base/effect/guild/jianzhushengji"), 1,CCString:create(""));
    spellEffectSprite:retain()
    spellEffectSprite:setScale(g_fElementScaleRatio)
    spellEffectSprite:setPosition(buildingPosArr[upgrade_building_type])
   	_bgLayer:addChild(spellEffectSprite,9999);
    spellEffectSprite:release()

    local animationEnd = function(actionName,xmlSprite)
    	spellEffectSprite:retain()
		spellEffectSprite:autorelease()
        spellEffectSprite:removeFromParentAndCleanup(true)
    end
    -- 每次回调
    local animationFrameChanged = function(frameIndex,xmlSprite)
        
    end

    --增加动画监听
    local delegate = BTAnimationEventDelegate:create()
    delegate:registerLayerEndedHandler(animationEnd)
    delegate:registerLayerChangedHandler(animationFrameChanged)
    spellEffectSprite:setDelegate(delegate)

	refreshAllUI()
end

-- 升级建筑物
function upgradeBuildingAction( tag, itemBtn )
	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
	if(tag == Tag_Hall)then
		--(GetLocalizeStringBy("key_2614"))
		local hallNeedExp = GuildUtil.getNeedExpByLv( tonumber(_guildInfo.guild_level) + 1 )
		UpgradeAlertTip.showAlert(Tag_Hall, hallNeedExp, tonumber(_guildInfo.guild_level), afterUpgradeDelegate)
	elseif(tag == Tag_Guanyu)then
		--(GetLocalizeStringBy("key_1389"))
		local guanyuNeedExp = GuildUtil.getGuanyuNeedExpByLv(tonumber(_guildInfo.va_info[va_guanyu_index].level) + 1 )
		UpgradeAlertTip.showAlert(Tag_Guanyu, guanyuNeedExp, tonumber(_guildInfo.va_info[va_guanyu_index].level), afterUpgradeDelegate)
	elseif(tag == Tag_Shop)then
		--(GetLocalizeStringBy("key_1383"))
		local shopNeedExp = GuildUtil.getShopNeedExpByLv(tonumber(_guildInfo.va_info[va_shop_index].level) + 1 )
		UpgradeAlertTip.showAlert(Tag_Shop, shopNeedExp, tonumber(_guildInfo.va_info[va_shop_index].level), afterUpgradeDelegate)
	elseif(tag == Tag_Military)then
		--(GetLocalizeStringBy("key_1383"))
		local militaryNeedExp = GuildUtil.getMilitaryNeedExpByLv(tonumber(_guildInfo.va_info[va_military_index].level) + 1 )
		UpgradeAlertTip.showAlert(Tag_Military, militaryNeedExp, tonumber(_guildInfo.va_info[va_military_index].level), afterUpgradeDelegate)
	elseif(tag== Tag_Book ) then
		-- 军团建筑的升级
		local bookNeedExp =	GuildUtil.getMilitaryNeedExpByLv(tonumber(_guildInfo.va_info[ va_book_index].level) + 1 )
		UpgradeAlertTip.showAlert(Tag_Book, bookNeedExp, tonumber(_guildInfo.va_info[va_book_index].level), afterUpgradeDelegate)

	else
		print(GetLocalizeStringBy("key_2411"))

	end
end

-- 其他军团的Action
function otherGuildAction( tag, itemBtn )
	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
	require "script/ui/guild/GuildListLayer"
	local guildListLayer = GuildListLayer.createLayer(true)
	MainScene.changeLayer(guildListLayer, "guildListLayer")
end



-- 城池争夺Action
function cityFireAction( tag, itemBtn )
	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
	-- 城战限制 军团大厅限制和人物等级限制
	require "script/ui/tip/AnimationTip"
	local hallLv,userLv = CityData.getLimitForCityWar()
	local my_userLv = UserModel.getHeroLevel()
	local my_hallLv = GuildDataCache.getGuildHallLevel()
	if(my_userLv < userLv and my_hallLv < hallLv)then
		local str = GetLocalizeStringBy("lic_1114") .. hallLv .. GetLocalizeStringBy("lic_1115") .. userLv .. GetLocalizeStringBy("lic_1116")
		AnimationTip.showTip(str)
		return
	elseif(my_userLv < userLv)then
		local str = GetLocalizeStringBy("lic_1117") .. userLv .. GetLocalizeStringBy("lic_1116")
		AnimationTip.showTip(str)
		return
	elseif(my_hallLv < hallLv)then
		local str = GetLocalizeStringBy("lic_1118") .. hallLv .. GetLocalizeStringBy("lic_1116")
		AnimationTip.showTip(str)
		return
	else
		-- 小红圈 设置false
		-- CityData.setIsShowTip(false)

		require "script/ui/copy/BigMap"
		local fortsLayer = BigMap.createFortsLayout()
		MainScene.changeLayer(fortsLayer, "BigMap")
	end
end

local function leaveMessage()
	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
	require "script/ui/guild/MessageBoardLayer"
	MessageBoardLayer.showLayer()
end

-- 创建主场景, 建筑物 UI
function createMainUI()

	local mainMenuBar = CCMenu:create()
	mainMenuBar:setPosition(ccp(0,0))
	-- mainMenuBar:setTouchPriority(-425)
	_bgLayer:addChild(mainMenuBar)

	local bgLayerSize = _bgLayer:getContentSize()

------ 建筑物的坐标
	buildingPosArr[Tag_Hall]		= ccp(bgLayerSize.width*0.5, bgLayerSize.height*0.55)	
	buildingPosArr[Tag_Guanyu]		= ccp(bgLayerSize.width*0.52, bgLayerSize.height*0.33)
	buildingPosArr[Tag_Book]		= ccp(bgLayerSize.width*0.18, bgLayerSize.height*0.67)
	buildingPosArr[Tag_Guanxintai]	= ccp(bgLayerSize.width*0.85, bgLayerSize.height*0.67)
	buildingPosArr[Tag_Shop]		= ccp(bgLayerSize.width*0.165, bgLayerSize.height*0.435)
	buildingPosArr[Tag_Military]		= ccp(bgLayerSize.width*550/640, bgLayerSize.height*0.44)

----- 五个建筑
----- 军团大厅
	local hallItem = GuildBuildingItem.createBuildingItemBy(Tag_Hall)
	hallItem:setAnchorPoint(ccp(0.5, 0.5))
	hallItem:registerScriptTapHandler(buildingAction)
	hallItem:setPosition( MainScene.getMenuPositionInTruePoint(buildingPosArr[Tag_Hall].x, buildingPosArr[Tag_Hall].y)) --   ccp(bottomSize.width*0.6, bottomSize.height*0.4))
	mainMenuBar:addChild(hallItem, 1, Tag_Hall)
	-- 标题
	local hallTitleSprite = CCSprite:create("images/guild/title_hall.png")
	hallTitleSprite:setAnchorPoint(ccp(0.5, 0))
	hallTitleSprite:setPosition(ccp(130, 280))
	hallItem:addChild(hallTitleSprite, 2)
	-- 军团等级
	_hallLvLabel = CCRenderLabel:create("Lv.99", g_sFontPangWa, 18, 1, ccc3(0,0,0), type_stroke)
	_hallLvLabel:setColor(ccc3(0xfe, 0xdb, 0x1c))
	_hallLvLabel:setAnchorPoint(ccp(1,0))
	_hallLvLabel:setPosition(ccp(hallTitleSprite:getContentSize().width, hallTitleSprite:getContentSize().height))
	hallTitleSprite:addChild(_hallLvLabel)

------ 关公殿MissionAfterBattle
	local guanyuItem = GuildBuildingItem.createBuildingItemBy(Tag_Guanyu)
	guanyuItem:setAnchorPoint(ccp(0.5, 0.5))
	guanyuItem:registerScriptTapHandler(buildingAction)
	guanyuItem:setPosition( MainScene.getMenuPositionInTruePoint(buildingPosArr[Tag_Guanyu].x, buildingPosArr[Tag_Guanyu].y)) --   ccp(bottomSize.width*0.6, bottomSize.height*0.4))
	mainMenuBar:addChild(guanyuItem, 1, Tag_Guanyu)
	-- 标题
	local guanyuTitleSprite = CCSprite:create("images/guild/title_guanyu.png")
	guanyuTitleSprite:setAnchorPoint(ccp(0.5, 0))
	guanyuTitleSprite:setPosition(ccp(100, 170))
	guanyuItem:addChild(guanyuTitleSprite)
	-- 关公殿等级
	_guanyuLvLabel = CCRenderLabel:create("Lv.99", g_sFontPangWa, 18, 1, ccc3(0,0,0), type_stroke)
	_guanyuLvLabel:setColor(ccc3(0xfe, 0xdb, 0x1c))
	_guanyuLvLabel:setAnchorPoint(ccp(1,0))
	_guanyuLvLabel:setPosition(ccp(guanyuTitleSprite:getContentSize().width, guanyuTitleSprite:getContentSize().height))
	guanyuTitleSprite:addChild(_guanyuLvLabel)

	--策划要求，增加可以参拜提示
	require "script/ui/guild/GuildDataCache"
	if GuildDataCache.isCanBaiGuangong() then
		local alertSprite = CCSprite:create("images/common/tip_2.png")
        alertSprite:setAnchorPoint(ccp(0.5,0.5))
        alertSprite:setPosition(ccp(guanyuItem:getContentSize().width*0.8,guanyuItem:getContentSize().height*0.8))
        guanyuItem:addChild(alertSprite)
	end

----- 军团商城
	local shopItem = GuildBuildingItem.createBuildingItemBy(Tag_Shop)
	shopItem:setAnchorPoint(ccp(0.5, 0.5))
	shopItem:registerScriptTapHandler(buildingAction)
	shopItem:setPosition( MainScene.getMenuPositionInTruePoint(buildingPosArr[Tag_Shop].x, buildingPosArr[Tag_Shop].y)) --   ccp(bottomSize.width*0.6, bottomSize.height*0.4))
	mainMenuBar:addChild(shopItem, 1, Tag_Shop)
	-- 标题
	local shopTitleSprite = CCSprite:create("images/guild/title_shop.png")
	shopTitleSprite:setAnchorPoint(ccp(0.5, 0))
	shopTitleSprite:setPosition(ccp(70, 180))
	shopItem:addChild(shopTitleSprite)
	-- 商店等级
	_shopLvLabel = CCRenderLabel:create("Lv.99", g_sFontPangWa, 18, 1, ccc3(0,0,0), type_stroke)
	_shopLvLabel:setColor(ccc3(0xfe, 0xdb, 0x1c))
	_shopLvLabel:setAnchorPoint(ccp(1,0))
	_shopLvLabel:setPosition(ccp(shopTitleSprite:getContentSize().width, shopTitleSprite:getContentSize().height))
	shopTitleSprite:addChild(_shopLvLabel)

----- 军机大厅
	local militaryItem = GuildBuildingItem.createBuildingItemBy(Tag_Military)
	militaryItem:setAnchorPoint(ccp(0.5, 0.5))
	militaryItem:registerScriptTapHandler(buildingAction)
	militaryItem:setPosition( MainScene.getMenuPositionInTruePoint(buildingPosArr[Tag_Military].x, buildingPosArr[Tag_Military].y)) --   ccp(bottomSize.width*0.6, bottomSize.height*0.4))
	mainMenuBar:addChild(militaryItem, 1, Tag_Military)

	-- 按照策划的要求，增加提示提示
	require "script/utils/ItemDropUtil"
	require "script/ui/guild/copy/GuildTeamData"
	local atkNum=  GuildTeamData.getLeftGuildAtkNum()
	print("atkNum  is : ",atkNum)
	if( atkNum > 0) then
		local militaryTipSp= ItemDropUtil.getTipSpriteByNum(atkNum)
		militaryTipSp:setPosition(militaryItem:getContentSize().width*0.8 ,militaryItem:getContentSize().height*0.8)
		militaryItem:addChild(militaryTipSp)
	end

	-- 标题
	local militaryTitleSprite = CCSprite:create("images/guild/title_military.png")
	militaryTitleSprite:setAnchorPoint(ccp(0.5, 0))
	militaryTitleSprite:setPosition(ccp(70, 180))
	militaryItem:addChild(militaryTitleSprite)
	-- 商店等级
	_militaryLvLabel = CCRenderLabel:create("Lv.99", g_sFontPangWa, 18, 1, ccc3(0,0,0), type_stroke)

	_militaryLvLabel:setColor(ccc3(0xfe, 0xdb, 0x1c))
	_militaryLvLabel:setAnchorPoint(ccp(1,0))
	_militaryLvLabel:setPosition(ccp(militaryTitleSprite:getContentSize().width, militaryTitleSprite:getContentSize().height))
	militaryTitleSprite:addChild(_militaryLvLabel)
	
----- 观星台
	local guanxitaiItem = GuildBuildingItem.createBuildingItemBy(Tag_Guanxintai)
	guanxitaiItem:setAnchorPoint(ccp(0.5, 0.5))
	guanxitaiItem:registerScriptTapHandler(buildingAction)
	guanxitaiItem:setPosition( MainScene.getMenuPositionInTruePoint(buildingPosArr[Tag_Guanxintai].x, buildingPosArr[Tag_Guanxintai].y)) --   ccp(bottomSize.width*0.6, bottomSize.height*0.4))
	mainMenuBar:addChild(guanxitaiItem, 1, Tag_Guanxintai)

----- 军团书院（军团任务）
	local bookItem = GuildBuildingItem.createBuildingItemBy(Tag_Book)
	bookItem:setAnchorPoint(ccp(0.5, 0.5))
	bookItem:registerScriptTapHandler(buildingAction)
	bookItem:setPosition( MainScene.getMenuPositionInTruePoint(buildingPosArr[Tag_Book].x, buildingPosArr[Tag_Book].y)) --   ccp(bottomSize.width*0.6, bottomSize.height*0.4))
	mainMenuBar:addChild(bookItem, 1, Tag_Book)

	-- 标题
	local boolTitleSprite = CCSprite:create("images/guild/title_task.png")
	boolTitleSprite:setAnchorPoint(ccp(0.5, 0))
	boolTitleSprite:setPosition(ccp(70, 180))
	bookItem:addChild(boolTitleSprite)
	-- 商店等级
	_bookLvLabel = CCRenderLabel:create("Lv.99", g_sFontPangWa, 18, 1, ccc3(0,0,0), type_stroke)
	_bookLvLabel:setColor(ccc3(0xfe, 0xdb, 0x1c))
	_bookLvLabel:setAnchorPoint(ccp(1,0))
	_bookLvLabel:setPosition(ccp(boolTitleSprite:getContentSize().width, boolTitleSprite:getContentSize().height))
	boolTitleSprite:addChild(_bookLvLabel)


---------- 各个建筑升级的按钮
	local upgradeMenuBar = CCMenu:create()
	upgradeMenuBar:setAnchorPoint(ccp(0,0))
	upgradeMenuBar:setPosition(ccp(0,0))
	_bgLayer:addChild(upgradeMenuBar)

	-- 大厅
	_upgradeHallItem = CCMenuItemImage:create("images/guild/btn_upgrade_n.png", "images/guild/btn_upgrade_h.png")
	_upgradeHallItem:setAnchorPoint(ccp(1,0))
	_upgradeHallItem:setPosition(MainScene.getMenuPositionInTruePoint(buildingPosArr[Tag_Hall].x, buildingPosArr[Tag_Hall].y))
	_upgradeHallItem:registerScriptTapHandler(upgradeBuildingAction)
	upgradeMenuBar:addChild(_upgradeHallItem, 1, Tag_Hall)

	-- 关公殿
	_upgradeGuanyuItem = CCMenuItemImage:create("images/guild/btn_upgrade_n.png", "images/guild/btn_upgrade_h.png")
	_upgradeGuanyuItem:setAnchorPoint(ccp(0,0))
	_upgradeGuanyuItem:setPosition(MainScene.getMenuPositionInTruePoint(buildingPosArr[Tag_Guanyu].x, buildingPosArr[Tag_Guanyu].y))
	_upgradeGuanyuItem:registerScriptTapHandler(upgradeBuildingAction)
	upgradeMenuBar:addChild(_upgradeGuanyuItem, 1, Tag_Guanyu)

	-- 商城
	_upgradeShopItem = CCMenuItemImage:create("images/guild/btn_upgrade_n.png", "images/guild/btn_upgrade_h.png")
	_upgradeShopItem:setAnchorPoint(ccp(0,0))
	_upgradeShopItem:setPosition(MainScene.getMenuPositionInTruePoint(buildingPosArr[Tag_Shop].x, buildingPosArr[Tag_Shop].y))
	_upgradeShopItem:registerScriptTapHandler(upgradeBuildingAction)
	upgradeMenuBar:addChild(_upgradeShopItem, 1, Tag_Shop)

	-- 军机大厅
	_upgradeMilitaryItem = CCMenuItemImage:create("images/guild/btn_upgrade_n.png", "images/guild/btn_upgrade_h.png")
	_upgradeMilitaryItem:setAnchorPoint(ccp(0,0))
	_upgradeMilitaryItem:setPosition(MainScene.getMenuPositionInTruePoint(buildingPosArr[Tag_Military].x, buildingPosArr[Tag_Military].y))
	_upgradeMilitaryItem:registerScriptTapHandler(upgradeBuildingAction)
	upgradeMenuBar:addChild(_upgradeMilitaryItem, 1, Tag_Military)

	-- 军团书院(也就是军团任务)
	_upgradeBookItem = CCMenuItemImage:create("images/guild/btn_upgrade_n.png", "images/guild/btn_upgrade_h.png")
	_upgradeBookItem:setAnchorPoint(ccp(0,0))
	_upgradeBookItem:setPosition(MainScene.getMenuPositionInTruePoint(buildingPosArr[Tag_Book].x, buildingPosArr[Tag_Book].y))
	_upgradeBookItem:registerScriptTapHandler(upgradeBuildingAction)
	upgradeMenuBar:addChild(_upgradeBookItem, 1, Tag_Book )


----------
	local myScale = _bgLayer:getContentSize().width/_bottomSpite:getContentSize().width/_bgLayer:getElementScale()
	local bottomSpiteSize = _bottomSpite:getContentSize()

----- 底部黑色背景
	b_Sprite = CCScale9Sprite:create("images/common/bg/9s_guild.png")
	b_Sprite:setContentSize(CCSizeMake(640, 100))
	b_Sprite:setAnchorPoint(ccp(0.5, 0))
	b_Sprite:setScale(myScale)
	b_Sprite:setPosition(ccp(_bgLayer:getContentSize().width*0.5, (bottomSpiteSize.height-15)*g_fScaleX))
	_bgLayer:addChild(b_Sprite)

	local b_Sprite_size = b_Sprite:getContentSize()

	-- 个人贡献
	sigleDonateSprite = CCSprite:create("images/guild/sigle_donate.png")
	sigleDonateSprite:setAnchorPoint(ccp(0.5, 0.5))
	sigleDonateSprite:setPosition(ccp(b_Sprite_size.width*0.2, b_Sprite_size.height*0.3))
	sigleDonateSprite:setScale(myScale)
	b_Sprite:addChild(sigleDonateSprite)
	

	-- 成员
	memberSprite = CCSprite:create("images/guild/member.png")
	memberSprite:setAnchorPoint(ccp(0.5, 0.5))
	memberSprite:setPosition(ccp(b_Sprite_size.width*0.7, b_Sprite_size.height*0.7))
	memberSprite:setScale(myScale)
	b_Sprite:addChild(memberSprite)
	

	-- 军团贡献
	guildSprite = CCSprite:create("images/guild/guild_donate.png")
	guildSprite:setAnchorPoint(ccp(0.5, 0.5))
	guildSprite:setPosition(ccp(b_Sprite_size.width*0.7, b_Sprite_size.height*0.3))
	guildSprite:setScale(myScale)
	b_Sprite:addChild(guildSprite)
	

--------其他军团的按钮
	local otherGuildMenuBar = CCMenu:create()
	otherGuildMenuBar:setAnchorPoint(ccp(0,0))
	otherGuildMenuBar:setPosition(ccp(0,0))
	_bgLayer:addChild(otherGuildMenuBar)

	-- 按钮
	local otherGuildItem = CCMenuItemImage:create("images/guild/btn_otherguild_n.png", "images/guild/btn_otherguild_h.png")
	otherGuildItem:setAnchorPoint(ccp(0.5,0))
	otherGuildItem:setPosition(MainScene.getMenuPositionInTruePoint(bgLayerSize.width*0.9, (bottomSpiteSize.height + 100)*g_fScaleX))--bgLayerSize.height*0.2))
	otherGuildItem:registerScriptTapHandler(otherGuildAction)
	otherGuildMenuBar:addChild(otherGuildItem)

	-- 城池争夺
	cityFireItem = CCMenuItemImage:create("images/guild/city_n.png", "images/guild/city_h.png")
	cityFireItem:setAnchorPoint(ccp(0.5, 1))
	cityFireItem:setPosition(MainScene.getMenuPositionInTruePoint(bgLayerSize.width*0.9, (bgLayerSize.height )*0.85))--bgLayerSize.height*0.2))
	cityFireItem:registerScriptTapHandler(cityFireAction)
	otherGuildMenuBar:addChild(cityFireItem)
	-- 小红圈
	tipSprite = CCSprite:create("images/common/tip_2.png")
    tipSprite:setAnchorPoint(ccp(0.5,0.5))
    tipSprite:setPosition(ccp(cityFireItem:getContentSize().width*0.8,cityFireItem:getContentSize().height*0.8))
    cityFireItem:addChild(tipSprite,1,10)
    tipSprite:setVisible(false)

    --军团留言板
    local messageBoard = CCMenuItemImage:create("images/guild/note_n.png","images/guild/note_h.png")
    messageBoard:setAnchorPoint(ccp(0.5,1))
    messageBoard:setPosition(MainScene.getMenuPositionInTruePoint(bgLayerSize.width*0.7, (bgLayerSize.height )*0.85))
    messageBoard:registerScriptTapHandler(leaveMessage)
    otherGuildMenuBar:addChild(messageBoard)


    _city_fire_status_tag = CCSprite:create("images/citybattle/signup.png")
    cityFireItem:addChild(_city_fire_status_tag)
    _city_fire_status_tag:setAnchorPoint(ccp(0.5, 1))
    _city_fire_status_tag:setPosition(ccp(cityFireItem:getContentSize().width * 0.5, 0))
    _city_fire_status_tag:setVisible(false)
    
    -- 城战限制 军团大厅限制和人物等级限制
	require "script/ui/guild/city/CityData"
	require "script/model/user/UserModel"
	local hallLv,userLv = CityData.getLimitForCityWar()
	local my_userLv = UserModel.getHeroLevel()
	local my_hallLv = GuildDataCache.getGuildHallLevel()
	if(my_userLv >= userLv and my_hallLv >= hallLv)then
    	-- 时间表
		timesInfo = CityData.getTimeTable()
		if(table.isEmpty(timesInfo))then
			local function signUpCallBack( cbFlag, dictData, bRet )
				-- 改数据
				CityData.setCityServiceInfo(dictData)
				timesInfo = CityData.getTimeTable()
	            ---------------------------- added by bzx
	            timerRefreshStatusStart()
	            ----------------------------
			end 
			local data = GuildDataCache.getMineSigleGuildInfo()
			local tempArgs = CCArray:create()
			tempArgs:addObject(CCInteger:create(data.guild_id))
			RequestCenter.GuildSignUpInfo(signUpCallBack, tempArgs)
		else
	        ---------------------------- added by bzx
	        timerRefreshStatusStart()
	        ----------------------------
		end
	end
end

-- 加报名成功可参战时小红圈提示
-- function addRedTip( ... )
-- 	-- 加可以参加军团战时 小红圈
-- 	local function showStepTip( ... )
-- 		if(MainScene.getOnRunningLayerSign() == "guildMainLayer")then
-- 			CityData.askIsShowTip()
-- 			if(tipSprite)then
-- 				local isShow = CityData.getIsShowTip()
-- 				tipSprite:setVisible(isShow)
-- 			end
-- 		end
-- 	end

-- 	if(TimeUtil.getSvrTimeByOffset() > timesInfo.signupEnd and TimeUtil.getSvrTimeByOffset() < tonumber(timesInfo.arrAttack[2][2]) )then
-- 		CityData.askIsShowTip()
-- 	elseif(TimeUtil.getSvrTimeByOffset() <= timesInfo.signupEnd)then
-- 		local actionArray = CCArray:create()
-- 		actionArray:addObject(CCDelayTime:create( timesInfo.signupEnd - TimeUtil.getSvrTimeByOffset() ))
-- 		actionArray:addObject(CCCallFunc:create(showStepTip))
-- 		_bgLayer:runAction(CCSequence:create(actionArray)) 
-- 	else
-- 		print(GetLocalizeStringBy("key_3172"))
-- 	end
-- end


function timerRefreshStatus(time)
    
    if _city_fire_status_tag == nil then
        return
    end
    
    local status = getCityFireStatus()
    local status_frame = nil
    if status == CityFireStatus.sign_up then
        status_frame = CCSpriteFrame:create("images/citybattle/signup.png", CCRectMake(0, 0, 83, 36))
    elseif status == CityFireStatus.fighting then
        status_frame = CCSpriteFrame:create("images/citybattle/battle.png", CCRectMake(0, 0, 83, 36))
    elseif status == CityFireStatus.reward then
        status_frame = CCSpriteFrame:create("images/citybattle/reward.png", CCRectMake(0, 0, 83, 36))
    end
    if status_frame ~= nil then
        _city_fire_status_tag:setDisplayFrame(status_frame)
        _city_fire_status_tag:setVisible(true)
        -- 加小红圈 add by licong
        tipSprite:setVisible(true)
        -- CityData.setIsShowTip(true)
    else
        _city_fire_status_tag:setVisible(false)
        -- 加小红圈 add by licong
        tipSprite:setVisible(false)
        -- CityData.setIsShowTip(false)
    end
end

---------------------------------- added by bzx
function getCityFireStatus()
    local time_table = timesInfo
    local current_time = BTUtil:getSvrTimeInterval()
    local status = nil
    if current_time > time_table.signupStart and current_time < time_table.signupEnd then
        status = CityFireStatus.sign_up
    elseif current_time > time_table.signupEnd and
    current_time < tonumber(time_table.arrAttack[2][2]) then
        if not table.isEmpty(CityData.getSignCity()) then
            status = CityFireStatus.fighting
        end
    elseif current_time > time_table.rewardStart and current_time < time_table.rewardEnd then
        local reward_city_id = CityData.getRewardCity()
        if reward_city_id ~= "0" then
            status = CityFireStatus.reward
        end
    end
    return status
end

-- 加按钮下标签
function timerRefreshStatusStart()
    timerRefreshStatus(nil)
    if _timer_refresh_status == nil then
        local director = CCDirector:sharedDirector()
        _timer_refresh_status = director:getScheduler():scheduleScriptFunc(timerRefreshStatus, 1, false)
    end
end

function timerRefreshStatusEnd()
    local director = CCDirector:sharedDirector()
    if _timer_refresh_status ~= nil then
        director:getScheduler():unscheduleScriptEntry(_timer_refresh_status)
        _timer_refresh_status = nil
    end
end
----------------------------------


-- 创建UI
function createUI()
-- 创建Top
	createTop()
-- 创建Bottom
	createBottom()
-- 创建主场景, 建筑物 UI	
	createMainUI()
end


-- 军团请求回调
function getGuildInfoCallback(  cbFlag, dictData, bRet  )
	if(dictData.err == "ok")then
		_guildInfo 		= dictData.ret
		_sigleGuildInfo = GuildDataCache.getMineSigleGuildInfo()
		if(not table.isEmpty(_guildInfo))then
			require "script/ui/guild/GuildDataCache"
			GuildDataCache.setGuildInfo(_guildInfo)
			loadingUI()
		end
	end
end

-- 开始加载界面
function loadingUI()
	createUI()
	refreshAllUI()
end
 
-- 创建 param 是否强制拉数据
function createLayer( isForceRequest )
	init()
	isForceRequest = isForceRequest or false

	_bgLayer = MainScene.createBaseLayer("images/guild/guild_bg.jpg", false, false, true)
	_bgLayer:registerScriptHandler(onNodeEvent)

	if(isForceRequest == true )then
		RequestCenter.guild_getGuildInfo(getGuildInfoCallback)
	else
		_guildInfo 		= GuildDataCache.getGuildInfo()
		_sigleGuildInfo = GuildDataCache.getMineSigleGuildInfo()
		if(not table.isEmpty(_guildInfo))then
			loadingUI()
		else
			RequestCenter.guild_getGuildInfo(getGuildInfoCallback)
		end
	end

	return _bgLayer
end
