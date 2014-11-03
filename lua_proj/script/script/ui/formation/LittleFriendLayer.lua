-- FileName: LittleFriendLayer.lua 
-- Author: Li Cong 
-- Date: 13-12-2 
-- Purpose: function description of module 

require "script/model/user/UserModel"
require "script/model/hero/HeroModel"
require "script/ui/formation/LittleFriendData"
require "script/ui/formation/LittleFriendService"
require "script/ui/formation/FormationUtil"
require "script/model/utils/HeroUtil"
require "script/ui/formation/LittleFriendOne"

module("LittleFriendLayer", package.seeall)


local _bgLayer 							= nil     -- 主layer
local _layerSize 						= nil	  -- 主layer宽高
local _bgLayerData 						= nil	  -- 主界面信息数据
local _mainBg 							= nil	  -- 主界面背景 黑背景
local _itemIconArr						= {}	  -- 位置上按钮图标
local _positionMenu 					= nil	  -- 位置按钮
local _flagSprite 						= nil	  -- 旗子
local cellHight 						= 0       -- cell高度
local curMark 							= nil 	  -- 当前显示哪个界面

kMarkOne 								= 10001   -- 羁绊数量界面
kMarkTwo 								= 10002   -- 羁绊效果界面

local _whichShow						= nil 	  -- 显示哪个界面

local _linkButton 						= nil     -- 羁绊效果按钮
local _backButton 						= nil 	  -- 返回按钮
local _showNodeOne 						= nil 	  -- 界面1
local _showNodeTwo 						= nil 	  -- 界面2

-- 顺序 
local btnXPositions = {-0.08, 1.08, -0.08, 1.08, -0.08, 1.08, -0.08, 1.08}
local btnYPositions = {0.87, 0.87, 0.63, 0.63, 0.39, 0.39, 0.15, 0.15}

local _touchBeganPoint 					= nil	  -- 触摸过程的 第一个触摸点 


-- 初始化数据
function init( ... )
	_bgLayer 							= nil     -- 主layer
	_layerSize 							= nil	  -- 主layer宽高
	_bgLayerData 						= nil	  -- 主界面信息数据
	_mainBg 							= nil	  -- 主界面背景 黑背景
	_touchBeganPoint 					= nil	  -- 触摸过程的 第一个触摸点 
	_itemIconArr						= {}	  -- 位置上按钮图标
	_positionMenu 						= nil	  -- 位置按钮
	_flagSprite 						= nil	  -- 旗子
	cellHight 							= 0 	  -- cell高度
	_linkButton 						= nil
	_backButton 						= nil 
end


--[[
	@des 	:刷新位置ui
--]]
function refreshLittleFriendUI()
	if(_showNodeOne ~= nil)then
		_showNodeOne:removeFromParentAndCleanup(true)
		_showNodeOne = nil
	end
	-- 重新创建小伙伴界面1
	_showNodeOne = LittleFriendOne.createLittleFriendOne()
	_showNodeOne:setAnchorPoint(ccp(0,0))
	_showNodeOne:setPosition(ccp(50,85))
	_flagSprite:addChild(_showNodeOne)

	if(_whichShow == kMarkOne)then
		_showNodeOne:setVisible(true)
	else
		_showNodeOne:setVisible(false)
	end
end


--[[
	@des 	:卸下回调
	@param 	: hid英雄hid, position:位置
	@return :
--]]
function dischargeCallBackFun( hid, position )
	local function createNext( ... )
		-- 创建阵容界面
		MainScene.changeLayer(FormationLayer.createLayer(nil, false, true),"formationLayer")
	end
	LittleFriendService.delLittleFriendService(hid,position,createNext)
end

-- 羁绊效果按钮回调 界面2
function linkButtonCallFun( tag, itemBtn )
	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
	_whichShow = kMarkTwo
	_showNodeOne:setVisible(false)
	_linkButton:setVisible(false)

	_showNodeTwo:setVisible(true)
	_backButton:setVisible(true)
end

-- 返回按钮回调 界面1
function backButtonCallFun( tag, itemBtn )
	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
	_whichShow = kMarkOne
	_showNodeTwo:setVisible(false)
	_backButton:setVisible(false)

	_showNodeOne:setVisible(true)
	_linkButton:setVisible(true)
end


--[[
	@des 	: 点击需要购买位置的回调
--]]
function buyActionCallBack( tag, menuItem )
	if(tag == 8)then
		-- 暂未开启敬请期待
		require "script/ui/tip/AnimationTip"
		AnimationTip.showTip(GetLocalizeStringBy("lic_1228"))
		return 
	end
	local openNeedLv = LittleFriendData.getOpenLv(tag)
	require "script/model/user/UserModel"
	if( openNeedLv > UserModel.getHeroLevel() ) then
		require "script/ui/tip/AnimationTip"
		AnimationTip.showTip( string.format(GetLocalizeStringBy("lic_1231"), openNeedLv) )
		return
	end

	--弹购买花费的板子
	local costNum = LittleFriendData.getOpenCostByPosition(tag)
	-- 金币不足
	if(UserModel.getGoldNumber() < costNum ) then
		require "script/ui/tip/LackGoldTip"
		LackGoldTip.showTip()
		return
	end
	-- 确定购买回调
	local yesBuyCallBack = function ( ... )
		-- 发请求
		LittleFriendService.openExtra(tag,buyServiceCallBack)
	end
	local tipFont = {}
    tipFont[1] = CCLabelTTF:create(GetLocalizeStringBy("lic_1229") ,g_sFontName,25)
    tipFont[1]:setColor(ccc3(0x78,0x25,0x00))
    tipFont[2] = CCSprite:create("images/common/gold.png")
	tipFont[3] = CCLabelTTF:create(costNum,g_sFontName,25)
	tipFont[3]:setColor(ccc3(0x78,0x25,0x00))
    tipFont[4] = CCLabelTTF:create(GetLocalizeStringBy("lic_1230"),g_sFontName,25)
    tipFont[4]:setColor(ccc3(0x78,0x25,0x00))
	require "script/utils/BaseUI"
    local tipFontNode = BaseUI.createHorizontalNode(tipFont)
	require "script/ui/tip/TipByNode"
	TipByNode.showLayer(tipFontNode,yesBuyCallBack)
end

--[[
	@des 	: 点击需要购买位置的回调
	@param  : p_position 购买的位置
--]]
function buyServiceCallBack( p_position )
	-- 扣除金币
	local costNum = LittleFriendData.getOpenCostByPosition(p_position)
	UserModel.addGoldNumber(-costNum)
	if(tolua.cast(_positionMenu:getChildByTag(p_position),"CCMenuItem") ~= nil)then
		tolua.cast(_positionMenu:getChildByTag(p_position),"CCMenuItem"):removeFromParentAndCleanup(true)
	end
	local item = getPositionIcon(p_position)
	item:setAnchorPoint(ccp(0.5,0.5))
	item:setPosition(ccp(_flagSprite:getContentSize().width*btnXPositions[p_position],_flagSprite:getContentSize().height*btnYPositions[p_position]))
	_positionMenu:addChild(item,1,p_position)
end


--[[
	@des 	:点击位置回调
--]]
function itemIconAction(tag, menuItem )
	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
	print(GetLocalizeStringBy("key_1319"),tag)
	-- 开启得到该位置上的hid
	local hid = LittleFriendData.getHidFromPosition(tag)
	if(hid > 0)then
		-- 显示武将信息 （带有 更换小伙伴 和 卸下 按钮的界面）
		print(GetLocalizeStringBy("key_2497"))
		require "script/ui/hero/HeroInfoLayer"
		require "script/ui/hero/HeroPublicLua"
		local data = HeroPublicLua.getHeroDataByHid(hid)
		local tArgs = {}
		tArgs.fnCreate = dischargeCallBackFun
		tArgs.reserved = hid
		tArgs.reserved2 = tag
		tArgs.needChangeFriend=true
		MainScene.changeLayer(HeroInfoLayer.createLayer(data, tArgs), "HeroInfoLayer")
	elseif(hid == 0)then
		-- 阵上没有英雄  （显示选择上阵界面）
		print(GetLocalizeStringBy("key_1150"))
		require "script/ui/formation/ChangeOfficerLayer"
		local changeOfficerLayer = ChangeOfficerLayer.createLayer(tag, nil,true)
		require "script/ui/main/MainScene"
		MainScene.changeLayer(changeOfficerLayer, "changeOfficerLayer")
	end
end


--[[
	@des 	:得到位置上的icon
	@param 	:position:位置
	@return :
--]]
function getPositionIcon( position )
	local itemIcon = nil
	-- 开启得到该位置上的hid
	local hid = LittleFriendData.getHidFromPosition(position)
	if(hid > 0)then
		-- 在阵上的英雄
		local heroRemoteInfo = nil
		local allHeros = HeroModel.getAllHeroes()
		for t_hid, t_hero in pairs(allHeros) do
			if( tonumber(t_hid) ==  hid) then
				heroRemoteInfo = t_hero
				break
			end
		end
		require "script/ui/hero/HeroPublicCC"
		require "db/DB_Heroes"
		itemIcon = HeroPublicCC.getCMISHeadIconByHtid(heroRemoteInfo.htid)
		-- 加英雄的名字和进阶次数
		local curHeroData = HeroUtil.getHeroInfoByHid(hid)
		local name_t = curHeroData.localInfo.name
		if(HeroModel.isNecessaryHeroByHid(hid)) then
			name_t = UserModel.getUserName()
		end
		local nameColor = HeroPublicLua.getCCColorByStarLevel(curHeroData.localInfo.potential)
		heroNameLabel = CCRenderLabel:create(name_t, g_sFontPangWa, 24, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
		heroNameLabel:setColor(nameColor)
		heroNameLabel:setAnchorPoint(ccp(0.5, 1))
		heroNameLabel:setPosition(ccp(itemIcon:getContentSize().width*0.5,-itemIcon:getContentSize().height*0.04))
		itemIcon:addChild(heroNameLabel)
		-- 进阶次数
		local evolveLevelLabel = CCRenderLabel:create("+" .. curHeroData.evolve_level, g_sFontPangWa, 24, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
		evolveLevelLabel:setColor(ccc3(0x00, 0xff, 0x18))
		evolveLevelLabel:setAnchorPoint(ccp(0.5, 0))
		evolveLevelLabel:setPosition(ccp(itemIcon:getContentSize().width*0.5,itemIcon:getContentSize().height*0.0))
		itemIcon:addChild(evolveLevelLabel)
		-- 注册回调
		itemIcon:registerScriptTapHandler(itemIconAction)
	else
		local isOpen = nil
		if(position <= 7)then
			isOpen = LittleFriendData.getIsOpenThisPosition(position)
		elseif(position == 8)then
			isOpen = false
		else
			print("no this position")
		end
		if(isOpen)then
			-- 阵上没有英雄
			require "script/ui/item/ItemSprite"
			local iconBg = ItemSprite.createAddSprite()
			itemIcon = CCMenuItemSprite:create(iconBg,iconBg)
			-- 注册回调
			itemIcon:registerScriptTapHandler(itemIconAction)
		else
			-- 没开启 返回锁
			local iconBg = CCSprite:create("images/formation/potential/officer_11.png")
			local icon = CCSprite:create("images/formation/potential/newlock.png")
			icon:setAnchorPoint(ccp(0.5,0.5))
			icon:setPosition(ccp(iconBg:getContentSize().width*0.5,iconBg:getContentSize().height*0.5))
			iconBg:addChild(icon)
			itemIcon = CCMenuItemSprite:create(iconBg,iconBg)
			if(position < 8)then
				local openLv = LittleFriendData.getOpenLv(position)
				local tishi = CCRenderLabel:create( openLv , g_sFontPangWa, 28, 1, ccc3(0x00, 0x00, 0x00), type_stroke)
				tishi:setColor(ccc3(0x45, 0xe7, 0xf1))
				tishi:setAnchorPoint(ccp(0.5,0.5))
				tishi:setPosition(ccp(itemIcon:getContentSize().width*0.5,itemIcon:getContentSize().height*0.5+5))
				local tishiSprite = CCSprite:create("images/formation/potential/jikaifang.png")
				tishiSprite:setAnchorPoint(ccp(0.5,0))
				tishiSprite:setPosition(ccp(itemIcon:getContentSize().width*0.5,6))
				itemIcon:addChild(tishiSprite,3)
				itemIcon:addChild(tishi,3)
				
				-- 金币开启位置
				local costNum = LittleFriendData.getOpenCostByPosition(position)
				if(costNum ~= nil)then
					local costFont = {}
			        costFont[1] = CCSprite:create("images/common/gold.png")
			        costFont[2] = CCLabelTTF:create(costNum, g_sFontName, 23)
			        costFont[2]:setColor(ccc3(0xfe,0xdb,0x1c))
			        local costFontNode = BaseUI.createHorizontalNode(costFont)
			        costFontNode:setAnchorPoint(ccp(0.5,1))
					costFontNode:setPosition(ccp(itemIcon:getContentSize().width*0.5,-10))
					itemIcon:addChild(costFontNode)
					-- 注册回调
					itemIcon:registerScriptTapHandler(buyActionCallBack)
				end
			elseif(position == 8)then
				-- 注册回调
				itemIcon:registerScriptTapHandler(buyActionCallBack)
			else
				print("no position")
			end
		end
	end
	return itemIcon
end


--[[
	@des 	:创建阵容羁绊列表
	@param 	:
	@return :
--]]
function createSkillScrollView( ... )
	-- 创建scrollView
	local listScrollView = CCScrollView:create()
	listScrollView:setTouchPriority(-130)
	listScrollView:setViewSize(CCSizeMake(358,416))
    listScrollView:setBounceable(true)
    listScrollView:setDirection(kCCScrollViewDirectionVertical)

	local containerLayer = createContainerLayer()
	listScrollView:setContainer(containerLayer)
	listScrollView:setContentOffset(ccp(0,listScrollView:getViewSize().height-containerLayer:getContentSize().height))
	return listScrollView
end

function createContainerLayer( ... )
	-- 得到阵上武将数据
	local heroData = LittleFriendData.getHeroInFormation()
	local heroCount = table.count(heroData)
	-- print("要显示的羁绊武将hid:")
	-- print_t(heroData)
	local containerLayer = CCNode:create()
	containerLayer:setContentSize(CCSizeMake(358,0))
		-- 创建列表
	local cellHeight = 10
	for i=heroCount,1,-1  do
		-- 该武将名字
		-- print("i",i,"hid",heroData[i])
		local curHeroData = HeroUtil.getHeroInfoByHid(heroData[i])
		-- 名字
		local hero_name = nil
		if( HeroModel.isNecessaryHeroByHid(heroData[i]) )then
			-- print("主角hid:",heroData[i])
			hero_name = UserModel.getUserName()
		else
			hero_name = curHeroData.localInfo.name
		end
		-- 羁绊
		local link_group = curHeroData.localInfo.link_group1
		-- 得到羁绊信息
		local link_group_Data = FormationUtil.parseHeroUnionProfit( heroData[i], link_group )

		if( table.count(link_group_Data) == 0)then
			-- 羁绊数据为空
			local link_des = CCLabelTTF:create(GetLocalizeStringBy("key_1341"),g_sFontName,23)
			link_des:setColor(ccc3(0x2f,0x2f,0x2f))
			link_des:setAnchorPoint(ccp(0.5,0))
			link_des:setPosition(ccp(containerLayer:getContentSize().width*0.5,cellHeight))
			containerLayer:addChild(link_des)
			-- 累积高度
			cellHeight = cellHeight+link_des:getContentSize().height+15
		else
			-- 遍历所有的羁绊数据
			local link_num = table.count(link_group_Data)
			for k = link_num,1,-1 do
				local name_color = nil
				local des_color = nil
				if( link_group_Data[k].isActive )then
					name_color = ccc3(0x00,0x6d,0x2f)
					des_color = ccc3(0x78,0x25,0x00)
				else
					name_color = ccc3(0x2f,0x2f,0x2f)
					des_color = ccc3(0x2f,0x2f,0x2f)
				end
				-- 羁绊名字
				local name_font = link_group_Data[k].dbInfo.union_arribute_name or " "
				local link_name = CCLabelTTF:create(name_font .. ":",g_sFontName,23)
				-- 羁绊描述
				local des_font = link_group_Data[k].dbInfo.union_arribute_desc or " "
				local link_des = CCLabelTTF:create(des_font,g_sFontName,23,CCSizeMake(210,0),kCCTextAlignmentLeft,kCCVerticalTextAlignmentTop)

				link_des:setColor(des_color)
				link_des:setAnchorPoint(ccp(0,0))
				link_des:setPosition(ccp(123,cellHeight))
				containerLayer:addChild(link_des)
				cellHeight = cellHeight+link_des:getContentSize().height+15

				link_name:setColor(name_color)
				link_name:setAnchorPoint(ccp(1,1))
				link_name:setPosition(ccp(120,link_des:getPositionY() + link_des:getContentSize().height))
				containerLayer:addChild(link_name)
			end
		end

		-- 创建武将名字
		local name_bg = CCSprite:create("images/formation/littlef_line.png")
		name_bg:setAnchorPoint(ccp(0.5,0))
		name_bg:setPosition(containerLayer:getContentSize().width*0.5,cellHeight)
		containerLayer:addChild(name_bg,1,i)
		
		local name_font = CCRenderLabel:create( hero_name, g_sFontPangWa, 28, 1, ccc3(0x00, 0x00, 0x00), type_stroke)
		name_font:setColor(ccc3(0xff, 0xf6, 0x00))
		name_font:setAnchorPoint(ccp(0.5,0.5))
		name_font:setPosition(ccp(name_bg:getContentSize().width*0.5,name_bg:getContentSize().height*0.5))
		name_bg:addChild(name_font)
		-- 累积高度
		cellHeight = cellHeight+name_font:getContentSize().height+5
	end
	-- 设置containerLayer的size
	containerLayer:setContentSize(CCSizeMake(358,cellHeight))
	return containerLayer
end

-- 创建羁绊效果界面
function createLinkLayer( ... )
	local _bgNode = CCNode:create()
	_bgNode:setContentSize(CCSizeMake(358,474))
	-- 创建旗子上的标题
	local str = GetLocalizeStringBy("key_3019")
	local title_font = CCRenderLabel:create( str, g_sFontPangWa, 30, 1, ccc3(0xff, 0xff, 0xff), type_stroke)
	title_font:setAnchorPoint(ccp(0.5,1))
	title_font:setColor(ccc3(0x78, 0x25, 0x00))
	title_font:setPosition(ccp(_bgNode:getContentSize().width*0.5,_bgNode:getContentSize().height-18))
	_bgNode:addChild(title_font)

	-- 创建羁绊显示列表ScrollView
	local listScrollView = createSkillScrollView()
	listScrollView:setPosition(ccp(0,0))
	_bgNode:addChild(listScrollView,3)

	return _bgNode
end

-- 初始化小伙伴界面
function initLittleFriendLayer( ... )
	-- 黑色背景
	-- _mainBg = CCScale9Sprite:create("images/formation/littlef_bg.png")
	-- _mainBg = CCSprite:create()
	-- _mainBg:setContentSize(_layerSize)
	-- _mainBg:setAnchorPoint(ccp(0.5,0.5))
	-- _mainBg:setPosition(ccp(_layerSize.width*0.5,_layerSize.height*0.5))
	-- _bgLayer:addChild(_mainBg)
	-- _mainBg:setScale(MainScene.elementScale)

	-- 标题描述
	local titleSprite = CCSprite:create("images/formation/littlef_font.png")
	titleSprite:setAnchorPoint(ccp(0.5,1))
	titleSprite:setPosition(ccp(_bgLayer:getContentSize().width*0.5,_bgLayer:getContentSize().height*0.99))
	_bgLayer:addChild(titleSprite)
	titleSprite:setScale(MainScene.elementScale)

	-- 大旗帜
	_flagSprite = CCSprite:create("images/formation/littlef_flag.png")
	_flagSprite:setAnchorPoint(ccp(0.5,0.5))
	_flagSprite:setPosition(ccp(_layerSize.width*0.5,_layerSize.height*0.47))
	_bgLayer:addChild(_flagSprite)
	_flagSprite:setScale(MainScene.elementScale)

	-- 创建6个位置
	for i=1,8 do
		local sprite = CCSprite:create("images/formation/littlef_head_bg.png")
		sprite:setAnchorPoint(ccp(0.5, 0.5))
		sprite:setPosition(ccp(_flagSprite:getContentSize().width*btnXPositions[i],_flagSprite:getContentSize().height*btnYPositions[i]))
		_flagSprite:addChild(sprite,2,1000+i)
	end

	-- 创建按钮
	_positionMenu = CCMenu:create()
	_positionMenu:setTouchPriority(-130)
	_positionMenu:setPosition(ccp(0,0))
	_flagSprite:addChild(_positionMenu,3)
	-- 六个itemIcon
	for i=1,8 do
		local item = getPositionIcon(i)
		item:setAnchorPoint(ccp(0.5,0.5))
		item:setPosition(ccp(_flagSprite:getContentSize().width*btnXPositions[i],_flagSprite:getContentSize().height*btnYPositions[i]))
		_positionMenu:addChild(item,1,i)
	end

	-- 界面1 羁绊数量界面
	_showNodeOne = LittleFriendOne.createLittleFriendOne()
	_showNodeOne:setAnchorPoint(ccp(0,0))
	_showNodeOne:setPosition(ccp(50,85))
	_flagSprite:addChild(_showNodeOne)
	_showNodeOne:setVisible(false)

	-- 界面2 羁绊效果界面
	_showNodeTwo = createLinkLayer()
	_showNodeTwo:setAnchorPoint(ccp(0,0))
	_showNodeTwo:setPosition(ccp(50,85))
	_flagSprite:addChild(_showNodeTwo)
	_showNodeTwo:setVisible(false)

	local menu = CCMenu:create()
	menu:setAnchorPoint(ccp(0,0))
	menu:setPosition(ccp(0,0))
	menu:setTouchPriority(-130)
	_flagSprite:addChild(menu)

	-- 羁绊效果按钮
	_linkButton =  LuaCC.create9ScaleMenuItem("images/common/btn/btn1_d.png","images/common/btn/btn1_n.png",CCSizeMake(200, 73),GetLocalizeStringBy("lic_1092"),ccc3(0xfe, 0xdb, 0x1c),35,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00))
	_linkButton:setAnchorPoint(ccp(0.5, 0))
    _linkButton:setPosition(ccp(_flagSprite:getContentSize().width*0.5, 10))
    _linkButton:registerScriptTapHandler(linkButtonCallFun)
	menu:addChild(_linkButton)
	_linkButton:setVisible(false)

	-- 返回按钮
	_backButton =  LuaCC.create9ScaleMenuItem("images/common/btn/btn1_d.png","images/common/btn/btn1_n.png",CCSizeMake(200, 73),GetLocalizeStringBy("lic_1093"),ccc3(0xfe, 0xdb, 0x1c),35,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00))
	_backButton:setAnchorPoint(ccp(0.5, 0))
    _backButton:setPosition(ccp(_flagSprite:getContentSize().width*0.5, 10))
    _backButton:registerScriptTapHandler(backButtonCallFun)
	menu:addChild(_backButton)
	_backButton:setVisible(false)

	print("_whichShow==", _whichShow )
	-- 显示哪个界面
	if( _whichShow == nil)then
		_whichShow = kMarkOne
		_showNodeOne:setVisible(true)
		_linkButton:setVisible(true)
	else
		if(_whichShow == kMarkTwo)then
			_showNodeOne:setVisible(false)
			_linkButton:setVisible(false)
			_showNodeTwo:setVisible(true)
			_backButton:setVisible(true)
		else
			_showNodeOne:setVisible(true)
			_linkButton:setVisible(true)
			_showNodeTwo:setVisible(false)
			_backButton:setVisible(false)
		end
	end
end



--[[
	@des 	:创建小伙伴界面
	@param 	:width:layer宽, height:layer高
	@return :
--]]
function createLittleFriendLayer( width, height)
	-- 初始化数据
	init()
	_bgLayer = CCLayer:create()
	_bgLayer:setContentSize(CCSizeMake(width,height))
	-- _bgLayer:setContentSize(CCSizeMake(640,657))
	_layerSize = _bgLayer:getContentSize()

	-- 主界面信息
	_bgLayerData = LittleFriendData.getLittleFriendeData()
	if( _bgLayerData ~= nil )then
		-- 初始化小伙伴界面
		initLittleFriendLayer()
	else
		local function createNext( ... )
			-- 初始化小伙伴界面
			initLittleFriendLayer()
		end
		LittleFriendService.getLittleFriendInfoService( createNext )
	end

	_bgLayer:registerScriptHandler(onNodeEvent)
	return _bgLayer
end

-- 判断是如何滑动
local function scrollFormationAndFriendLayer(xOffset)
	if(FormationLayer.isOnAnimatingFunc() == true)then
		return false
	end
	if(xOffset>_bgLayer:getContentSize().width/6)then
		FormationLayer.moveFormationOrLittleFriendAnimated( false, true )
	else
		FormationLayer.moveFormationOrLittleFriendAnimated( true, true )
	end
end 

-- touch事件处理
local function cardLayerTouch(eventType, x, y)
   
    if (eventType == "began") then
    	_touchBeganPoint = ccp(x, y)
    	if( FormationLayer.isInLittleFriendFunc() == true )then
			local tPosition = _bgLayer:convertToNodeSpace(_touchBeganPoint)
			if( _bgLayer:isVisible() == true and tPosition.x>0 and tPosition.y>0 and tPosition.x<_bgLayer:getContentSize().width and tPosition.y<_bgLayer:getContentSize().height)then
				return true
			else
				return false
			end
		else
			return false
		end
    elseif (eventType == "moved") then
    	
		-- if(x-_touchBeganPoint.x>0)then
		-- 	-- 跟着手指滑动
		-- 	FormationLayer.moveFormationOrLittleFriend( x-_touchBeganPoint.x - _bgLayer:getContentSize().width )
		-- end
    else
    	-- 切换layer
    	if( ((x-_touchBeganPoint.x) > _bgLayer:getContentSize().width/6) )then
    		local k = (y-_touchBeganPoint.y)/(x-_touchBeganPoint.x)
    		-- 斜率
    		if(k<0.5 and k>-0.5)then
	    		scrollFormationAndFriendLayer( x-_touchBeganPoint.x)
	    	end
	    end
	end
end



--[[
 @desc	 回调onEnter和onExit时间
 @para 	 string event
 @return void
 --]]
function onNodeEvent( event )
	if (event == "enter") then
		_bgLayer:registerScriptTouchHandler(cardLayerTouch, false, -128, true)
		_bgLayer:setTouchEnabled(true)

	elseif (event == "exit") then
		_bgLayer:unregisterScriptTouchHandler()
	end
end




















