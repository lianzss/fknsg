-- Filename：	FormationLayer.lua
-- Author：		Cheng Liang
-- Date：		2013-7-4
-- Purpose：		阵型

module ("FormationLayer", package.seeall)


require "script/ui/formation/HeroCell"
require "script/network/RequestCenter"
require "script/model/DataCache"
require "script/ui/formation/HeroSprite"
require "script/model/hero/HeroModel"
require "script/ui/item/ItemSprite"
require "script/model/utils/HeroUtil"
require "script/ui/tip/AnimationTip"
require "script/model/user/UserModel"
require "script/ui/formation/LittleFriendLayer"


local ARM_TYPE_WEAPON	= 1	-- 武器
-- local ARM_TYPE_CAPE		= 2	-- 戒指
local ARM_TYPE_ARMOR	= 2	-- 盔甲
local ARM_TYPE_HAT		= 3	-- 头盔
local ARM_TYPE_NECKLACE	= 4	-- 项链

local TREAS_TYPE_HORSE	= 1
local TREAS_TYPE_BOOK 	= 2

local FORMATION_TYPE_EQUIP 		= 1 		-- 装备阵容
local FORMATION_TYPE_FIGHTSOUL 	= 2 		-- 战魂阵容
				
local equipPositions = { ARM_TYPE_HAT, ARM_TYPE_WEAPON, ARM_TYPE_NECKLACE, ARM_TYPE_ARMOR, TREAS_TYPE_BOOK, TREAS_TYPE_HORSE} 

local bgLayer = nil
local formationInfo 	= {}			-- formation的信息  实际是阵容信息
local m_formationInfo 	= {}			-- 处理成需要的阵型信息 从1开始	格式如：{100038, 100039, 0, -1} 			0/100038/-1 <=> 位置开启但无上阵将领/上阵将领/位置未开启
local c_formationInfo 	= {}			-- scrollView使用	从0开始	格式如：{0, 100038, 0, -1, -1 ,-1}	0/100038/-1 <=> 位置开启但无上阵将领/上阵将领/位置未开启
local ck_formationInfo	= {}			-- 更换阵型时使用		从0开始	格式如：{0, 100038, 0, -1, -1 ,-1}	0/100038/-1 <=> 位置开启但无上阵将领/上阵将领/位置未开启

local open_num        					-- 可上阵的将领个数
local m_num = 0 						-- 已上阵将领的个数

local isVisibalMiddleUI	= true			-- 中间的UI是否隐藏了

local containerLayer					-- scrollview 的 container
local scrollBgLayer						-- scrollview 的 底

local _isNeedDisplayAnimation = true  	-- 首次是否需要动画 （特殊需求）

local leftBtn 							-- 左翻按钮
local rightBtn 							-- 右翻按钮
local leftGraySp 						-- 左翻灰度
local rightGraySp 						-- 右翻灰度

local topBgSp							-- 上部的UI
local topHerosTableview 				-- 英雄Tableview
local curSeletedTopTableViewCell 		-- 当前选中的cell
local topVisibleCellSize				-- cell的可见大小
local visiableNum						-- 可显示的cell个数

local herosScrollView					-- 中间部分的英雄卡牌UI
local touchBeganPoint					-- card的touchBeganPoint
local curHeroIndex		= 1				-- 当前选中的英雄卡牌 从1开始
local lastHeroIndex 	= 1
local curCardSize		= nil			-- 中间卡牌的Size 用的地方较多
local curCardPosition					-- 中间卡牌的Position
local equipMenuBar		= nil			-- 中间的 6 个装备按钮

local starArr_n 		= {} 			-- 普通的star数组
local starArr_h 		= {} 			-- 高亮的star数组

local onekeyMenuBar						-- 一键装备按钮

------ 最下面的UI

local bottomBg 							-- 底
local heroNameLabel						-- 英雄名称
local heroLevelLabel					-- 英雄等级
local evolveLevelLabel 	= nil 			-- 转生等级
local firePoweLabel						-- 英雄战斗力
local hpLabel 							-- 血量
local skillLabelArr 	= {}			-- 6个羁绊label
local life_att_label 	= nil			-- 物理攻击
local phy_def_label		= nil 			-- 物理防御
local mag_att_label 	= nil			-- 法攻
local mag_def_label 	= nil			-- 法防
local heroNameBg		= nil 			-- 英雄名称
local developMenu        = nil           -- 武将(紫卡＋7)进化橙卡按钮
  
------ 修改阵行界面
local backToFormationBar				-- 返回阵容
local changeFormationSprite				-- 修改阵型UI
local heroCardsTable 	= {}			-- 保存可以修改阵容的Sprite 从 1 开始

local began_pos 						-- 开始移动的阵型Pos 从 1 开始
local began_heroSprite 					-- 开始移动的heroSprite
local began_hero_position				-- 开始时heroSp的position
local began_hero_ZOrder 				-- 开始时的ZOrder

local end_pos 							-- 交换的目标hero 位置 从 1 开始

local MAX_ZORDER 		= 9999 			-- 移动时的ZOrder

local h_AnimatedDuration= 0.2 			-- 动画时长

local onFormationHerosInfo 	= {}		-- 上阵

local _displayHid 		= nil			-- 需要展示那个英雄 

local starsBgSp			= nil 			-- 星星底

local onekeyBtn			= nil

local _weaponBtn 		= nil

local _horseBtn 		= nil

local formationLayerDidLoadCallback = {} 			--加载完成事件
local fromationLayerTouchHeroCallback = nil 		--武将信息查看事件
local swapHeroCallback = nil

-- 各个初始位置
local _equipMenuOriginPosition 		= nil
local _scrollBgLayerOriginPosition 	= nil
local _bottomBgOriginPosition 		= nil
local _littleFriendLayerOriginPosition = nil

local _isInLittleFriend 			= false
local _littleFriendLayer	 		= nil

local _isOnAnimating 				= false 	-- 是否正在播放动画

local _f_equipBtn 					= nil 		-- 切换到装备阵容
local _f_fightSoulBtn 				= nil 		-- 切换到战魂阵容
local _equipAndFightSoulMenu 		= nil 		-- 装备和阵容切换界面

local _fightSoulMenuBar 			= nil 		-- 战魂的八个按钮

local _curFormationType 			= nil 		-- 当前是装备阵容还是战魂阵容

local heroXScale					= {}
local heroYScale					= {}
local original_pos 					= nil

local _oldSuitInfo 					= nil       -- 一键装备前套装激活信息

local function init(  )
	isVisibalMiddleUI 			= true
	curHeroIndex 				= 1
	bgLayer 					= nil
	heroCardsTable 				= {}
	formationInfo 				= nil
	onekeyMenuBar 				= nil
	curSeletedTopTableViewCell 	= nil
	starsBgSp					= nil 			-- 星星底
	ck_formationInfo			= {}			-- 更换阵型时使用
	curCardSize					= CCSizeMake(800, 620)
	onekeyBtn					= nil
	heroNameBg					= nil 			-- 英雄名称
	evolveLevelLabel 			= nil 			-- 转生等级
	heroNameLabel 				= nil
	changeFormationSprite		= nil
	backToFormationBar			= nil
	_equipMenuOriginPosition 	= nil
	_scrollBgLayerOriginPosition= nil
	_bottomBgOriginPosition 	= nil
	_isInLittleFriend			= false
	_littleFriendLayer	 		= nil
	_littleFriendLayerOriginPosition = nil
	_isOnAnimating 				= false 	-- 是否正在播放动画

	_f_equipBtn 				= nil 		-- 切换到装备阵容
	_f_fightSoulBtn 			= nil 		-- 切换到战魂阵容
	_equipAndFightSoulMenu 		= nil 		-- 装备和阵容切换界面
	_fightSoulMenuBar 			= nil 		-- 战魂的八个按钮

	_curFormationType 			= nil 		-- 当前是装备阵容还是战魂阵容
	original_pos				= nil
	heroYScale					= {}
	heroXScale 					= {}
	_oldSuitInfo 				= nil
	developMenu                 = nil
end

function isInLittleFriendFunc()
	return _isInLittleFriend
end

-- 是否是小伙伴切换到阵型
function isFriendToFormation()
	
	return false
end

-- 是否正在动画
function isOnAnimatingFunc()
	return _isOnAnimating
end

-- 是否是小伙伴切换到阵型
function isFormationToFriend()
	--索引顺序更改 by 张梓航
	if open_num < 6 then
		if (m_formationInfo[curHeroIndex+2] == -2)then
			return true
		end
	else
		if (m_formationInfo[curHeroIndex+1] == -2)then
			return true
		end
	end
	return false
end

-- 一键装备战魂
function oneKeyFightSoulCallback( cbFlag, dictData, bRet )
	if(dictData.err ~= "ok" or table.isEmpty(dictData.ret) )then
		AnimationTip.showTip(GetLocalizeStringBy("key_2568"))
		return
	end
	local allHeros = HeroModel.getAllHeroes()
	if(not table.isEmpty(dictData.ret.fightSoul) )then
		-- 计算数值
		local last_numerial = {}

		if( not table.isEmpty(allHeros["" .. m_formationInfo[curHeroIndex]].equip.fightSoul) )then
			last_numerial = getShowFightSoulData(allHeros["" .. m_formationInfo[curHeroIndex]].equip.fightSoul)
		end

		-- 更换装备
		for m_pos,m_equipInfo in pairs(dictData.ret.fightSoul) do
			allHeros["" .. m_formationInfo[curHeroIndex]].equip.fightSoul[""..m_pos] = m_equipInfo
		end

		-- 装备后的数值
		local cur_numerial = getShowFightSoulData(allHeros["" .. m_formationInfo[curHeroIndex]].equip.fightSoul)
		
		ItemUtil.showFightSoulAttrChangeInfo( last_numerial, cur_numerial )

		refreshFightSoulAndBottom()
	end


end

function getShowFightSoulData( t_fightSoul)
	local t_numerial = {}

	if( not table.isEmpty(t_fightSoul) )then
		for k,soulData in pairs(t_fightSoul) do
			if(not table.isEmpty(soulData)) then
				local  t_numerial_last = HuntSoulData.getFightSoulAttrByItem_id(soulData.item_id, nil, soulData)
				for l_key, l_data in pairs(t_numerial_last) do
					if( not table.isEmpty(t_numerial[l_key]) )then
						t_numerial[l_key].displayNum = t_numerial[l_key].displayNum + l_data.displayNum
					else
						t_numerial[l_key] = l_data
					end
				end
			end
		end
	end

	return t_numerial
end



-- 一键装备装备
function onekeyEquipCallback( cbFlag, dictData, bRet )
	if(dictData.err ~= "ok" or table.isEmpty(dictData.ret) )then
		AnimationTip.showTip(GetLocalizeStringBy("key_1691"))

		return
	end

	local allHeros = HeroModel.getAllHeroes()

	-- 装备
	if( not table.isEmpty(dictData.ret.arming))then
		-- 计算数值
		local last_numerial = {}
		for k, equipInfo in pairs(allHeros["" .. m_formationInfo[curHeroIndex]].equip.arming) do
			if(not table.isEmpty(equipInfo)) then
				local  t_numerial_last = ItemUtil.getTop2NumeralByIID( tonumber(equipInfo.item_id))
				for l_key, l_num in pairs(t_numerial_last) do
					last_numerial[l_key] = last_numerial[l_key] or 0
					last_numerial[l_key] = last_numerial[l_key] + tonumber(l_num)
				end
			end
		end

		-- 更换装备
		for m_pos,m_equipInfo in pairs(dictData.ret.arming) do
			allHeros["" .. m_formationInfo[curHeroIndex]].equip.arming[""..m_pos] = m_equipInfo
		end

		local cur_numerial = {}
		for k, equipInfo in pairs(allHeros["" .. m_formationInfo[curHeroIndex]].equip.arming) do
			if(not table.isEmpty(equipInfo)) then
				local  t_numerial_last = ItemUtil.getTop2NumeralByIID( tonumber(equipInfo.item_id))
				for l_key, l_num in pairs(t_numerial_last) do
					cur_numerial[l_key] = cur_numerial[l_key] or 0
					cur_numerial[l_key] = cur_numerial[l_key] + tonumber(l_num)
				end
			end
		end

		-- 更换完装备后套装最新信息 飘套装激活属性
		local newSuitInfo = ItemUtil.getSuitActivateNumByHid(m_formationInfo[curHeroIndex])
		print("onekey newSuitInfo==>")
		print_t(newSuitInfo)
		require "script/ui/tip/AttrTip"
		local flyTipCallBack = function ( ... )
			AttrTip.showAtrrTipCallBack(newSuitInfo,_oldSuitInfo)
		end
		ItemUtil.showAttrChangeInfo(last_numerial, cur_numerial, flyTipCallBack)
	end

	-- 宝物
	if(not table.isEmpty(dictData.ret.treasure))then
		-- 更换装备
		for m_pos,m_treasInfo in pairs(dictData.ret.treasure) do
			allHeros["" .. m_formationInfo[curHeroIndex]].equip.treasure[""..m_pos] = m_treasInfo
		end
	end

	HeroModel.setAllHeroes(allHeros)
	refreshEquipAndBottom()
	AnimationTip.showTip(GetLocalizeStringBy("key_1537"))

	-- 铁匠铺 第3步 显示点击武器
	local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.3),CCCallFunc:create(function ( ... )
		addGuideEquipGuide3()
	end))
	bgLayer:runAction(seq)


end

--[[
	@desc	一键装备按钮
	@para 	
	@return void
--]]
function onekeyMenuItemAction( ... )
	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
	---[==[铁匠铺 新手引导屏蔽层
	---------------------新手引导---------------------------------
	--add by licong 2013.09.26
	require "script/guide/NewGuide"
	if(NewGuide.guideClass == ksGuideSmithy) then
		require "script/guide/EquipGuide"
		EquipGuide.changLayer()
	end
	---------------------end-------------------------------------
	--]==]
	local hid = m_formationInfo[curHeroIndex]
	if(hid and hid>0)then
		local args = Network.argsHandler(m_formationInfo[curHeroIndex])

		if(_curFormationType == FORMATION_TYPE_EQUIP)then
			-- 记录更换装备之前的套装个数
			_oldSuitInfo = ItemUtil.getSuitActivateNumByHid(m_formationInfo[curHeroIndex])
			print("onekey_oldSuitInfo==>")
			print_t(_oldSuitInfo)
			RequestCenter.hero_equipBestArming(onekeyEquipCallback, args)
		elseif(_curFormationType == FORMATION_TYPE_FIGHTSOUL)then
			if not DataCache.getSwitchNodeState(ksSwitchBattleSoul) then
				return
			end
			RequestCenter.hero_equipBestFightSoul(oneKeyFightSoulCallback, args)
		end
	end
end

-- 对
local function handleCurSeletedTopTableViewCell( ... )
	if(curSeletedTopTableViewCell) then
		local topTableViewOffset = topHerosTableview:getContentOffset();
		local sPosition = (1-lastHeroIndex)*topVisibleCellSize.width
		if (sPosition <= topTableViewOffset.x and sPosition-topVisibleCellSize.width >= topTableViewOffset.x -  visiableNum*topVisibleCellSize.width) then
			HeroCell.setSeletedCellBgVisible(curSeletedTopTableViewCell, false)
		end
	end
end 

--[[
 @desc	 刷新上部的Tableview
 @para 	 
 @return 
--]]
local function refreshTopTableviewStatus( isNeedAnimation, isWillInFriendLayer )
	isWillInFriendLayer = isWillInFriendLayer or false

	if(isNeedAnimation == nil)then
		isNeedAnimation = true
	end
	local m_select_index = curHeroIndex
	if(isWillInFriendLayer == true)then
		--高亮改变 by 张梓航
		if open_num < 6 then
		 	m_select_index = open_num + 2
		 else
		 	m_select_index = open_num + 1
		 end
	end
	local topTableViewOffset = topHerosTableview:getContentOffset();

	curStartPositon = (1-m_select_index) * topVisibleCellSize.width
	curEndPosition = (-m_select_index) * topVisibleCellSize.width
	if(curStartPositon > topTableViewOffset.x) then

		topHerosTableview:setContentOffsetInDuration(ccp( curStartPositon , 0), 0.2)

	elseif (curEndPosition < topTableViewOffset.x - visiableNum * topVisibleCellSize.width ) then
		-- print("( m_select_index - visiableNum )*topVisibleCellSize.width==", ( m_select_index - visiableNum )*topVisibleCellSize.width)
		if(isNeedAnimation)then
			topHerosTableview:setContentOffsetInDuration(ccp( - ( m_select_index - visiableNum )*topVisibleCellSize.width , 0), 0.2)
		else
			topHerosTableview:setContentOffset(ccp( - ( m_select_index - visiableNum )*topVisibleCellSize.width , 0))
		end
	end

	local topTableViewCell = topHerosTableview:cellAtIndex( m_select_index -1)

	-- 处理选中状态
	if (curSeletedTopTableViewCell ~= topTableViewCell) then
		if (curSeletedTopTableViewCell) then
			handleCurSeletedTopTableViewCell()
		end
		if (topTableViewCell) then
			HeroCell.setSeletedCellBgVisible(topTableViewCell, true)
			curSeletedTopTableViewCell = topTableViewCell
		end
	end
end

-- 刷新底部 hero信息
function refreshBottomInfo()
	-- MainScene.setMainSceneViewsVisible(true, false, true)
	local cur_Hid = m_formationInfo[curHeroIndex]

	local curHeroData = nil
	if( cur_Hid and cur_Hid > 0) then
		curHeroData = HeroUtil.getHeroInfoByHid(cur_Hid)
		local name_t = curHeroData.localInfo.name
		if(HeroModel.isNecessaryHeroByHid(cur_Hid)) then
			name_t = UserModel.getUserName()
		end

		-- 武将(紫卡＋7)进化橙卡按钮 by zhangqiang
		if(developMenu)then
			developMenu:removeFromParentAndCleanup(true)
			developMenu = nil
		end
		require "script/ui/develop/DevelopData"
		if DevelopData.doOpenDevelopByHid(curHeroData.hid) then
			developMenu = CCMenu:create()
			developMenu:setPosition(0,0)
			heroNameBg:addChild(developMenu)

			local btn = CCMenuItemImage:create("images/develop/developup_btn_n.png","images/develop/developup_btn_h.png")
			btn:registerScriptTapHandler(tapDevelopBtnCb)
			btn:setAnchorPoint(ccp(0.5,0))
			btn:setPosition(heroNameBg:getContentSize().width*0.5,heroNameBg:getContentSize().height)
			developMenu:addChild(btn,1,tonumber(curHeroData.hid))
		end

		-- 英雄名称
		if(heroNameLabel)then
			heroNameLabel:removeFromParentAndCleanup(true)
			heroNameLabel = nil
		end
		local nameColor = HeroPublicLua.getCCColorByStarLevel(curHeroData.localInfo.potential)
		heroNameLabel = CCRenderLabel:create(name_t, g_sFontPangWa, 25, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
		heroNameLabel:setColor(nameColor)
		heroNameLabel:setAnchorPoint(ccp(0, 0.5))
		heroNameBg:addChild(heroNameLabel)
		-- 转生次数
		if(evolveLevelLabel)then
			evolveLevelLabel:removeFromParentAndCleanup(true)
			evolveLevelLabel = nil
		end
		local laberStr = nil
		if curHeroData.localInfo.star_lv == 6 then
			labelStr = GetLocalizeStringBy("zz_99",curHeroData.evolve_level)
		else
			labelStr = "+" .. curHeroData.evolve_level
		end 
		evolveLevelLabel = CCRenderLabel:create(labelStr, g_sFontPangWa, 25, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
		evolveLevelLabel:setColor(ccc3(0x00, 0xff, 0x18))
		evolveLevelLabel:setAnchorPoint(ccp(0, 0.5))
		
		heroNameBg:addChild(evolveLevelLabel)

		local centerX = heroNameBg:getContentSize().width*0.5
		local t_length = heroNameLabel:getContentSize().width + evolveLevelLabel:getContentSize().width + 5
		local s_x = centerX - t_length*0.5

		heroNameLabel:setPosition(ccp(s_x, heroNameBg:getContentSize().height*0.55))
		evolveLevelLabel:setPosition(ccp(s_x+heroNameLabel:getContentSize().width + 5, heroNameBg:getContentSize().height*0.55))

		-- 等级上限
		require "script/model/hero/HeroModel"
		-- local limitLv = HeroModel.getHeroLimitLevel(curHeroData.localInfo.id, curHeroData.evolve_level)
		heroLevelLabel:setString(curHeroData.level .. "/" .. UserModel.getHeroLevel())
		
		-- 连携技能
		local link_group = curHeroData.localInfo.link_group1
		if(link_group)then
			require "db/DB_Union_profit"
			local s_name_arr = string.split(link_group, ",")
			for k, m_skill_label in pairs(skillLabelArr) do
				if(k <= #s_name_arr)then
					local t_union_profit = DB_Union_profit.getDataById(s_name_arr[k])
					if( not table.isEmpty(t_union_profit) and t_union_profit.union_arribute_name)then
						m_skill_label:setString(t_union_profit.union_arribute_name)
						if( not FormationUtil.isUnionActive( s_name_arr[k], cur_Hid )) then
							m_skill_label:setColor(ccc3(155,155,155))
						else
							m_skill_label:setColor(ccc3(0x78, 0x25, 0x00))
						end
					end
				else
					m_skill_label:setString("")
				end
			end
		else
			for k, m_skill_label in pairs(skillLabelArr) do
				m_skill_label:setString("")
			end
		end

		require "script/ui/hero/HeroFightForce"

		-- 战斗力等
		local t_fight_dict = HeroFightForce.getAllForceValuesByHid(cur_Hid)

		if(table.isEmpty(t_fight_dict)) then
			firePoweLabel:setString("")
			
			phy_def_label:setString("")
			life_att_label:setString("")
			mag_def_label:setString("")
			mag_att_label:setString("")
			
		else
			firePoweLabel:setString(curHeroData.localInfo.heroQuality)
			phy_def_label:setString(t_fight_dict.physicalDefend)
			life_att_label:setString(t_fight_dict.life)
			mag_def_label:setString(t_fight_dict.magicDefend)
			mag_att_label:setString(t_fight_dict.generalAttack)
		end
		-- 刷新6个star
		--将偶数星时的星星居中，positionChanged by zhang zihang
		local starsXPositions = {0.5, 0.4, 0.6, 0.3, 0.7, 0.2, 0.8}
		local starsYPositions = {0.75, 0.74, 0.74, 0.71, 0.71, 0.68, 0.68}
		local starsXPositionsDouble = {0.45,0.55,0.35,0.65,0.25,0.75,0.8}
        local starsYPositionsDouble = {0.745,0.745,0.72,0.72,0.7,0.7,0.68}

		for k, h_starsp in pairs(starArr_h) do
			if ((curHeroData.localInfo.potential%2) ~= 0) then
				h_starsp:setPosition(ccp(starsBgSp:getContentSize().width * starsXPositions[k], starsBgSp:getContentSize().height * starsYPositions[k]))
				if(k<= curHeroData.localInfo.potential) then
					h_starsp:setVisible(true)
				else
					h_starsp:setVisible(false)
				end
			else
				h_starsp:setPosition(ccp(starsBgSp:getContentSize().width * starsXPositionsDouble[k], starsBgSp:getContentSize().height * starsYPositionsDouble[k]))
				if(k<= curHeroData.localInfo.potential) then
					h_starsp:setVisible(true)
				else
					h_starsp:setVisible(false)
				end
			end
		end
	else
		heroNameLabel:setString("")
		heroLevelLabel:setString("" )

		if(evolveLevelLabel)then
			evolveLevelLabel:setString("")
		end
		
		for k, m_skill_label in pairs(skillLabelArr) do
			m_skill_label:setString("")
		end

		firePoweLabel:setString("")
		phy_def_label:setString("")
		life_att_label:setString("")
		mag_def_label:setString("")
		mag_att_label:setString("")

		-- 刷新7个star
		for k, h_starsp in pairs(starArr_h) do
			-- local n_starsp = starArr_n[k]
			h_starsp:setVisible(false)
			-- n_starsp:setVisible(true)
			
			
		end
	end
end 

-- 动画结束回调
function overAnimationDelegate()
	print("_isOnAnimating_isOnAnimating_isOnAnimating_isOnAnimating")
	_isOnAnimating = false
end

--[[
 @desc		中间卡牌滑动到某个card
 @para		selectedHeroIndex card的	索引
 			isAnimated 是否播放动画
 @return 	void
--]]
local function scrollToNext ( selectedHeroIndex, isAnimated, isRefresh )
	-- isRefresh = isRefresh == nil and true or isRefresh
	if(isRefresh == nil)then
		isRefresh = true
	end
	if(isAnimated == nil) then
		isAnimated = true
	end
	local animatedDuration = 0
	if(isAnimated) then
		animatedDuration = 0.1
	end
	if(_isNeedDisplayAnimation)then
		_isOnAnimating = true
		herosScrollView:setContentOffsetInDuration(ccp(-(selectedHeroIndex -1 )*curCardSize.width , 0), animatedDuration)
		-- 延迟回调
		local overAnimation = CCSequence:createWithTwoActions(CCDelayTime:create(animatedDuration),CCCallFunc:create(overAnimationDelegate))
		bgLayer:runAction(overAnimation)
	else
		herosScrollView:setContentOffset(ccp(-(selectedHeroIndex -1 )*curCardSize.width , 0))
		_isNeedDisplayAnimation = true
	end
	if(isRefresh)then
		refreshEquipMenu()
		refreshBottomInfo()
		refreshFightSoulMenu()
	end
end

-- 刷新
function refreshEquipAndBottom( )
	refreshEquipMenu()
	-- refreshFightSoulMenu()
	refreshBottomInfo()
end

function refreshFightSoulAndBottom()

	refreshFightSoulMenu()
	refreshBottomInfo()
end

-- 切换到更换将领界面
local function changeOfficeLayerAction( ... )
	local t_hid = m_formationInfo[curHeroIndex]
	
	local squadInfo = DataCache.getSquad()

	if(t_hid>0) then
		local t_index = 0
		for i=1,6 do
			c_hid = squadInfo["" .. i]
			if (c_hid == t_hid) then
		 		t_index = i
		 		break
		 	end
		end
		require "script/ui/hero/HeroInfoLayer"
		require "script/ui/hero/HeroPublicLua"
		local data = HeroPublicLua.getHeroDataByHid(t_hid)
		local tArgs = {}
		tArgs.sign = "formationLayer"
		tArgs.fnCreate = FormationLayer.createLayer
		tArgs.reserved = t_hid
		tArgs.reserved2 = t_index
		-- if(HeroModel.isNecessaryHeroByHid(t_hid) and tonumber(UserModel.getHeroLevel())<30)then
		-- 	tArgs.needChangeHeroBtn=false
		-- else
		tArgs.needChangeHeroBtn=true
		-- end
		---[==[等级礼包新手引导屏蔽层
		---------------------新手引导---------------------------------
		--add by licong 2013.09.09
		require "script/guide/NewGuide"
		if(NewGuide.guideClass == ksGuideFiveLevelGift) then
			require "script/guide/LevelGiftBagGuide"
			LevelGiftBagGuide.changLayer()
		end
		---------------------end-------------------------------------
		--]==]

		if(HeroModel.isNecessaryHero(data.htid)) then
			data.dressId = UserModel.getDressIdByPos(1)
		end

		MainScene.changeLayer(HeroInfoLayer.createLayer(data, tArgs), "HeroInfoLayer")

		
		---[==[ 等级礼包第14步 显示将领信息
        ---------------------新手引导---------------------------------
        --add by licong 2013.09.09
        require "script/guide/NewGuide"
        require "script/guide/LevelGiftBagGuide"
        if(NewGuide.guideClass ==  ksGuideFiveLevelGift and LevelGiftBagGuide.stepNum == 13) then
            local levelGiftBagGuide_button = HeroInfoLayer.getStrengthenButton()
            local touchRect = getSpriteScreenRect(levelGiftBagGuide_button)
            LevelGiftBagGuide.show(14, touchRect)
        end
        ---------------------end-------------------------------------
   		--]==]
	else
		
		-- 添加武将
		---------------------新手引导---------------------------------
		--add by lichenyang 2013.08.29
		require "script/guide/NewGuide"
		if(NewGuide.guideClass ==  ksGuideFormation) then
		    require "script/guide/FormationGuide"
		    FormationGuide.changLayer()
		end
	    ---------------------end-------------------------------------		

	    ---[==[等级礼包新手引导屏蔽层
		---------------------新手引导---------------------------------
		--add by licong 2013.09.09
		require "script/guide/NewGuide"
		if(NewGuide.guideClass == ksGuideFiveLevelGift) then
			require "script/guide/LevelGiftBagGuide"
			LevelGiftBagGuide.changLayer()
		end
		---------------------end-------------------------------------
		--]==]

		require "script/ui/formation/ChangeOfficerLayer"
		-- for k,v in pairs(c_formationInfo) do
		-- 	if(v == 0)then
		-- 		t_index = k
		-- 		break
		-- 	end
		-- end
		local t_index = 0
		for i=1,6 do
			c_hid = squadInfo["" .. i]
			if ( tonumber(c_hid) == tonumber(t_hid)) then
		 		t_index = i
		 		break
		 	end
		end
		local changeOfficerLayer = ChangeOfficerLayer.createLayer(t_index, t_hid)
		require "script/ui/main/MainScene"
		MainScene.changeLayer(changeOfficerLayer, "changeOfficerLayer")
	end
end

--[[
 @desc	 切换中间卡牌
 @para 		
 @return 
--]]
local function switchCard( xOffset )
	if (math.abs(xOffset) < 20) then
		changeOfficeLayerAction()
		-- scrollToNext ( curHeroIndex, true, false)
	else
		lastHeroIndex = curHeroIndex
		local nextHeroIndex = curHeroIndex
		if (xOffset > curCardSize.width/6) then
			if (nextHeroIndex <= 1 )then
				nextHeroIndex = 1
			else
				nextHeroIndex = nextHeroIndex -1
			end
		elseif (xOffset < -curCardSize.width/6 ) then
			if ( nextHeroIndex>= open_num) then
				nextHeroIndex = open_num
			else
				nextHeroIndex = nextHeroIndex + 1
			end
		end
		if(nextHeroIndex == curHeroIndex)then
			scrollToNext ( curHeroIndex, true, false)
		else
			curHeroIndex = nextHeroIndex
			scrollToNext ( curHeroIndex, true )
			refreshTopTableviewStatus()
		end
		
	end
end


-- 修改阵容 回调
function changeFormationCallback( cbFlag, dictData, bRet )
	
	local tempFormationInfo = {}
	local real_formation = DataCache.getFormationInfo()
	for f_pos, f_hid in pairs(real_formation) do
		if (tonumber(f_pos) ==  began_pos-1) then
			tempFormationInfo[f_pos] = real_formation["" .. end_pos-1]

		elseif (tonumber(f_pos) == end_pos-1) then
			tempFormationInfo[f_pos] = real_formation["" .. began_pos-1]
		else
			tempFormationInfo[f_pos] = f_hid
		end
	end

	-- 更新缓存数据
	DataCache.setFormationInfo(tempFormationInfo)
	-- formationInfo = tempFormationInfo

	local t_heroIcon = heroCardsTable[end_pos]
	local t_x, t_y = t_heroIcon:getPosition()
	t_position = ccp(t_x, t_y)
	-- 开始动画
	began_heroSprite:runAction(CCMoveTo:create(h_AnimatedDuration, t_position))
	t_heroIcon:runAction(CCMoveTo:create(h_AnimatedDuration, began_hero_position))

	-- 交换 英雄 卡牌
	local tempHeroCards = {}
	for n_pos, n_herpCard in pairs(heroCardsTable) do
		if (n_pos ==  began_pos) then
			tempHeroCards[n_pos] = heroCardsTable[end_pos]

		elseif (n_pos == end_pos) then
			tempHeroCards[n_pos] = heroCardsTable[began_pos]
		else
			tempHeroCards[n_pos] = heroCardsTable[n_pos]
		end
	end
	heroCardsTable = tempHeroCards


	handleFormation()

	-- 换阵容 刷新小伙伴界面
	LittleFriendLayer.refreshLittleFriendUI()
end

--[[
 @desc	 处理和发送修改阵容的请求
 @para 	 s_pos/e_pos 需要交换的两个hero的位置 从 1 开始
 @return void
--]]
local function changeFormationAction( s_pos, e_pos )
	began_pos = s_pos
	end_pos = e_pos
	local tempFormationInfo = {}
	local real_formation = DataCache.getFormationInfo()
	for f_pos, f_hid in pairs(real_formation) do
		if (tonumber(f_pos) ==  began_pos-1) then
			tempFormationInfo[f_pos] = real_formation["" .. end_pos-1]

		elseif (tonumber(f_pos) == end_pos-1) then
			tempFormationInfo[f_pos] = real_formation["" .. began_pos-1]
		else
			tempFormationInfo[f_pos] = f_hid
		end
	end
	
	local ff = CCDictionary:create()
	for i=0, 5 do
		if (tempFormationInfo[ "" .. i] > 0) then
			ff:setObject(CCInteger:create(tempFormationInfo["" .. i]), "" .. i)
		end
	end
	local args = CCArray:create()
	args:addObject(ff)
	RequestCenter.setFormationInfo(changeFormationCallback, args)
end

--[[
 @desc	 处理touches事件
 @para 	 string event
 @return 
--]]
local function onTouchesHandler( eventType, x, y )
	
	if (eventType == "began") then

		if(_isOnAnimating == true)then
			return false
		end
		print("began")
		began_pos = nil
		began_heroSprite = nil
		began_hero_position = nil
		began_hero_ZOrder = nil
		original_pos = nil

        touchBeganPoint = ccp(x, y)
        local isTouch = false
        if (isVisibalMiddleUI) then

        	-- local tPosition = topBgSp:convertToNodeSpace(touchBeganPoint)
        	-- if ( tPosition.x >0 and tPosition.x <  topBgSp:getContentSize().width and tPosition.y > 0 and tPosition.y < topBgSp:getContentSize().height ) then
        	-- 	isTouch = true
        	-- 	print("topBgSptopBgSptopBgSptopBgSptopBgSp")
        	-- else
        		-- 是针对中间的scrollView滑动
		        local vPosition = scrollBgLayer:convertToNodeSpace(touchBeganPoint)
		        if ( vPosition.x >0 and vPosition.x <  curCardSize.width and vPosition.y > 0 and vPosition.y < curCardSize.height ) then
		        	isTouch = true
		        else
		        	isTouch = false
		        end
        	-- end
        	
	    else
	    	-- 更换阵型
	    	for pos, heroCard in pairs(heroCardsTable) do
	    		local bPosition = heroCard:convertToNodeSpace(touchBeganPoint)
	    		if ( bPosition.x >0 and bPosition.x <  heroCard:getContentSize().width and bPosition.y > 0 and bPosition.y < heroCard:getContentSize().height ) then
		        	
		        	if (ck_formationInfo[pos-1]>0) then
		        		local tempX, tempY  = heroCard:getPosition()
		        		--if (tempX == 620*heroXScale[pos]) and (tempY == 490*heroYScale[pos]) then
		        		isTouch = true
			        	began_pos = pos
			        	began_heroSprite = heroCard
			        	
			        	began_hero_position = ccp(tempX, tempY)
			        	original_pos = ccp(620*heroXScale[pos],510*heroYScale[pos])
			        	-- 修改 Z轴
			        	began_hero_ZOrder = heroCard:getZOrder()
			        	local parent_node = began_heroSprite:getParent() 
			        	parent_node:reorderChild(began_heroSprite, MAX_ZORDER)
				        --end
			        else
			        	isTouch = false
			        end

		        	break

		        else
		        	isTouch = false
		        end
	    	end
	    end

	    return isTouch
    elseif (eventType == "moved") then
    	print("moved")
    	if (BTUtil:getGuideState() == true) then
        	return
    	end
    	
    	if (isVisibalMiddleUI) then
	    	local tPosition = topBgSp:convertToNodeSpace(touchBeganPoint)
	    	if ( tPosition.x >0 and tPosition.x <  topBgSp:getContentSize().width and tPosition.y > 0 and tPosition.y < topBgSp:getContentSize().height ) then

	    	else
	    		if( isFormationToFriend() and (x - touchBeganPoint.x) < 0 )then--or isFriendToFormation() )then
	    			moveFormationOrLittleFriend(x - touchBeganPoint.x)
	    		else
	    			herosScrollView:setContentOffset(ccp(x - touchBeganPoint.x - (curHeroIndex-1)*curCardSize.width , 0))
	    		end
	    		
	    	end
	    else
	    	began_heroSprite:setPosition(ccp( (x - touchBeganPoint.x)/MainScene.elementScale + began_hero_position.x , (y - touchBeganPoint.y)/MainScene.elementScale + began_hero_position.y))
	    end
    else
        local xOffset = x - touchBeganPoint.x
        if (BTUtil:getGuideState() == true) then
        	xOffset = 0
        	_isInLittleFriend = false
    	end
        if (isVisibalMiddleUI) then
        	
	        local tPosition = topBgSp:convertToNodeSpace(touchBeganPoint)
	    	if ( tPosition.x >0 and tPosition.x <  topBgSp:getContentSize().width and tPosition.y > 0 and tPosition.y < topBgSp:getContentSize().height ) then
	    		
	    	else
	    		if(isFormationToFriend() and (x - touchBeganPoint.x) < 0 and BTUtil:getGuideState() ~= true )then  --or isFormationToFriend() )then
					if((x - touchBeganPoint.x) < -bgLayer:getContentSize().width/6)then
						moveFormationOrLittleFriendAnimated(true, true)
					else
						moveFormationOrLittleFriendAnimated(false, true)
					end
	    		else
		    		-- 移动
		    		if(_isInLittleFriend)then

		    		else
			       		switchCard( xOffset )
			       	end
		       	end
	    	end
	    else
	    	-- 移动修改阵容界面的 hero
	    	local isChanged = false
	    	local changedHero = nil

	    	local temp = ccp(began_heroSprite:getContentSize().width/2,began_heroSprite:getContentSize().height/2 )
			local e_position = began_heroSprite:convertToWorldSpace(ccp(temp.x,temp.y))
	    	for pos, card_hero in pairs(heroCardsTable) do
	    		if(pos ~= began_pos) then
	    			local bPosition = card_hero:convertToNodeSpace(e_position)
	    			if ( bPosition.x >0 and bPosition.x <  card_hero:getContentSize().width and bPosition.y > 0 and bPosition.y < card_hero:getContentSize().height ) then
	    				isChanged = true
	    				changedHero = card_hero
	    				end_pos =  pos
	    				break
	    			end
	    		end
	    	end
	    	if (isChanged == false) then
		    	began_heroSprite:runAction(CCMoveTo:create(h_AnimatedDuration, original_pos))
		    	-- 修改 Z轴
		    	local parent_node = began_heroSprite:getParent() 
		    	if tonumber(began_pos) >= 4 then
			    	parent_node:reorderChild(began_heroSprite, 10)
			    else
			    	parent_node:reorderChild(began_heroSprite, 20)
			    end
			else
				changeFormationAction(began_pos, end_pos)
				local parent_node = began_heroSprite:getParent() 
				if tonumber(end_pos) >= 4 then
					if tonumber(began_pos) < 4 then
						parent_node:reorderChild(changedHero,20)
					else
						parent_node:reorderChild(changedHero,10)
					end
			    	parent_node:reorderChild(began_heroSprite, 10)
			    else
			    	if tonumber(began_pos) < 4 then
			    		parent_node:reorderChild(changedHero,20)
			    	else
			    		parent_node:reorderChild(changedHero,10)
			    	end
			    	parent_node:reorderChild(began_heroSprite, 20)
			    end
			end
	    end
        print("end")
	end
end

-- 切换阵容和小伙伴
function moveFormationOrLittleFriend( xOffset )
	equipMenuBar:setPosition(ccp(_equipMenuOriginPosition.x+xOffset, _equipMenuOriginPosition.y))
	_fightSoulMenuBar:setPosition(ccp(_equipMenuOriginPosition.x+xOffset, _equipMenuOriginPosition.y))
	scrollBgLayer:setPosition(ccp(_scrollBgLayerOriginPosition.x+xOffset, _scrollBgLayerOriginPosition.y))
	bottomBg:setPosition(ccp(_bottomBgOriginPosition.x+xOffset, _bottomBgOriginPosition.y))
	_littleFriendLayer:setPosition(ccp(_littleFriendLayerOriginPosition.x+xOffset, _littleFriendLayerOriginPosition.y)) 
end

-- 切换阵容和小伙伴
function moveFormationOrLittleFriendAnimated( isMoveToLittleFriend, isAnimated )
	
	isAnimated = isAnimated or false
	local xOffset = 0
	if(isMoveToLittleFriend == true)then
		_isInLittleFriend = true
		xOffset = -bgLayer:getContentSize().width
		refreshTopTableviewStatus( true, true )
	else
		_isInLittleFriend = false
		refreshTopTableviewStatus( true, false )
	end

	
	if(isAnimated == true)then
		_isOnAnimating = true
		local animationDuration = 0.1
		equipMenuBar:runAction(CCMoveTo:create(animationDuration, ccp(_equipMenuOriginPosition.x+xOffset, _equipMenuOriginPosition.y)))
		_fightSoulMenuBar:runAction(CCMoveTo:create(animationDuration, ccp(_equipMenuOriginPosition.x+xOffset, _equipMenuOriginPosition.y)))
		scrollBgLayer:runAction(CCMoveTo:create(animationDuration, ccp(_scrollBgLayerOriginPosition.x+xOffset, _scrollBgLayerOriginPosition.y)))
		bottomBg:runAction(CCMoveTo:create(animationDuration, ccp(_bottomBgOriginPosition.x+xOffset, _bottomBgOriginPosition.y)))
		_littleFriendLayer:runAction(CCMoveTo:create(animationDuration, ccp(_littleFriendLayerOriginPosition.x+xOffset, _littleFriendLayerOriginPosition.y)))

		-- 延迟回调
		local overAnimation = CCSequence:createWithTwoActions(CCDelayTime:create(animationDuration),CCCallFunc:create(overAnimationDelegate))
		bgLayer:runAction(overAnimation)
	else
		equipMenuBar:setPosition( ccp(_equipMenuOriginPosition.x+xOffset, _equipMenuOriginPosition.y))
		_fightSoulMenuBar:setPosition( ccp(_equipMenuOriginPosition.x+xOffset, _equipMenuOriginPosition.y))
		scrollBgLayer:setPosition( ccp(_scrollBgLayerOriginPosition.x+xOffset, _scrollBgLayerOriginPosition.y))
		bottomBg:setPosition( ccp(_bottomBgOriginPosition.x+xOffset, _bottomBgOriginPosition.y))
		_littleFriendLayer:setPosition(  ccp(_littleFriendLayerOriginPosition.x+xOffset, _littleFriendLayerOriginPosition.y))
	end
end

--[[
 @desc	 回调onEnter和onExit时间
 @para 	 string event
 @return void
 --]]
local function onNodeEvent( event )
	if (event == "enter") then
		bgLayer:registerScriptTouchHandler(onTouchesHandler, false, -127, true)
		bgLayer:setTouchEnabled(true)

	elseif (event == "exit") then
		bgLayer:unregisterScriptTouchHandler()
	end
end

--[[
	@desc	上部UI上阵英雄tableView的创建
	@para 	none
	@return void
--]]
local function createTopTableView( ... )


	local cellSize = CCSizeMake(105, 100)			--计算cell大小
	local myScale = bgLayer:getContentSize().width/topBgSp:getContentSize().width/bgLayer:getElementScale()
	topVisibleCellSize = CCSizeMake(cellSize.width*myScale, cellSize.height*myScale)
	local h = LuaEventHandler:create(function(fn, table, a1, a2) 	--创建
		local r
		if fn == "cellSize" then
			-- r = CCSizeMake(cellSize.width * myScale, cellSize.height * myScale)

			r = CCSizeMake(cellSize.width, cellSize.height)

		elseif fn == "cellAtIndex" then
            a2 = HeroCell.createHeroCell( m_formationInfo[a1+1] )
            if ( a1 +1 == curHeroIndex) then
            	if(curSeletedTopTableViewCell) then
            		handleCurSeletedTopTableViewCell()
            	end
            	curSeletedTopTableViewCell = a2
            	HeroCell.setSeletedCellBgVisible(curSeletedTopTableViewCell, true)
            end
			r = a2
		elseif fn == "numberOfCells" then
			local num = 0
			for position, hid in pairs(m_formationInfo) do
				num = num + 1
			end
			r = num
		elseif fn == "cellTouched" then
			-- 如果正在动画
			if(_isOnAnimating == true)then
				return
			end
			if (m_formationInfo[a1:getIdx()+1] >= 0)then

				if(_isInLittleFriend == true)then
					moveFormationOrLittleFriendAnimated(false, true)
				end
            	if(curSeletedTopTableViewCell) then
        			handleCurSeletedTopTableViewCell()
	        	end
	        	curSeletedTopTableViewCell = a1
	        	HeroCell.setSeletedCellBgVisible(curSeletedTopTableViewCell, true)
	        	lastHeroIndex = curHeroIndex 
				curHeroIndex = a1:getIdx() +1
				scrollToNext(curHeroIndex, true)
				setVisibleMiddleUI(true)
				if(m_formationInfo[a1:getIdx()+1] == 0) then
					-- 添加武将
					---------------------新手引导---------------------------------
					--add by lichenyang 2013.08.29
					require "script/guide/FormationGuide"
					require "script/guide/NewGuide"
					if(NewGuide.guideClass ==  ksGuideFormation and FormationGuide.stepNum == 2) then
					    FormationGuide.changLayer()
					    local touchRect = CCRectMake(g_winSize.width * 0.5 - 120 * getScaleParm(), g_winSize.height * 0.5 - 180 * getScaleParm(), 240 * getScaleParm(), 450 * getScaleParm() )
					    FormationGuide.show(3, touchRect)
					end
				    ---------------------end-------------------------------------

				    ---[==[ 等级礼包第11步 
					---------------------新手引导---------------------------------
					--add by licong 2013.09.09
					require "script/guide/NewGuide"
				    require "script/guide/LevelGiftBagGuide"
					if(NewGuide.guideClass ==  ksGuideFiveLevelGift and LevelGiftBagGuide.stepNum == 10) then
				        LevelGiftBagGuide.changLayer()
					    local touchRect = CCRectMake(g_winSize.width * 0.5 - 120 * getScaleParm(), g_winSize.height * 0.5 - 180 * getScaleParm(), 240 * getScaleParm(), 450 * getScaleParm() )
				        LevelGiftBagGuide.show(11, touchRect)
				    end
				    ---------------------end-------------------------------------
					--]==]
					---[==[ 第4个上阵栏位开启 第3步 
					---------------------新手引导---------------------------------
					--add by licong 2013.09.09
					require "script/ui/level_reward/LevelRewardLayer"
				    require "script/guide/NewGuide"
				    require "script/guide/ForthFormationGuide"
				    if(NewGuide.guideClass ==  ksGuideForthFormation and ForthFormationGuide.stepNum == 2) then
				    	ForthFormationGuide.changLayer()
				        ForthFormationGuide.show(3, nil)
				    end
					---------------------end-------------------------------------
					--]==]
				end
				if(swapHeroCallback ~= nil)then
					swapHeroCallback()
				end
			elseif (m_formationInfo[a1:getIdx()+1] == -2)then
				
				if(_isInLittleFriend)then

				else
					moveFormationOrLittleFriendAnimated(true, true)
					setVisibleMiddleUI(true)
				end
			else

				-- 尚未解锁
				local nextLevel = FormationUtil.nextOpendFormationNumAndLevel()
				AnimationTip.showTip( nextLevel .. GetLocalizeStringBy("key_1526"))
            end
		elseif (fn == "scroll") then
			
		end
		return r
	end)

	visiableNum = 4 --math.floor(topBgSp:getContentSize().width*0.65, topVisibleCellSize.width)

	topHerosTableview = LuaTableView:createWithHandler(h, CCSizeMake(topBgSp:getContentSize().width*0.65, topBgSp:getContentSize().height*0.8275))
	topHerosTableview:setBounceable(true)
	topHerosTableview:setDirection(kCCScrollViewDirectionHorizontal)
	topHerosTableview:setPosition(ccp(topBgSp:getContentSize().width*0.13, 0))
	topHerosTableview:setVerticalFillOrder(kCCTableViewFillTopDown)
	topHerosTableview:setTouchPriority(-402)
	topBgSp:addChild(topHerosTableview)

	refreshTopTableviewStatus()
end

--判断是否弹出没有物品的提示
--物品方面
--武器 1 护甲 2 头盔 3 项链 4 
function isPushBox(posId)
	local isPush = false
	local bagInfo = DataCache.getBagInfo()
	for k, itemInfo in pairs(bagInfo.arm) do
		if(tonumber(itemInfo.itemDesc.type) == posId) then
			isPush = true
			break
		end
	end
	require "script/ui/tip/AnimationTip"
	if isPush == false then
		if posId == 1 then
			AnimationTip.showTip(GetLocalizeStringBy("key_2237"))
		elseif posId == 2 then
			AnimationTip.showTip(GetLocalizeStringBy("key_1998"))
		elseif posId == 3 then
			AnimationTip.showTip(GetLocalizeStringBy("key_1695"))
		elseif posId == 4 then
			AnimationTip.showTip(GetLocalizeStringBy("key_2089"))
		end
	end
	return isPush
end

--[[
	@desc	6个换装备按钮 的Action
	@para 	
	@return void
--]]
function changeEquipAction(tag, menuItem )
	local f_hid = m_formationInfo[curHeroIndex]
	if(f_hid > 0)then
		if(tag-20000>=5) then
			-- if not isPushBox(equipPositions[tag-20000],true) then
			require "script/ui/formation/ChangeEquipLayer"
			local changeEquipLayer = ChangeEquipLayer.createLayer( changeEquipCallback, m_formationInfo[curHeroIndex] , equipPositions[tag-20000], true)
			require "script/ui/main/MainScene"
			MainScene.changeLayer(changeEquipLayer, "changeEquipLayer")
			--end
		else
			if isPushBox(equipPositions[tag-20000]) then
				require "script/ui/formation/ChangeEquipLayer"
				local changeEquipLayer = ChangeEquipLayer.createLayer( changeEquipCallback, m_formationInfo[curHeroIndex] , equipPositions[tag-20000])
				require "script/ui/main/MainScene"
				MainScene.changeLayer(changeEquipLayer, "changeEquipLayer")
			end
		end
	end
end 


-- 装备回调
function equipInfoDelegeate( )
	MainScene.setMainSceneViewsVisible(true, false, true)
	refreshEquipAndBottom()
end



-- 战魂
function fightSoulAction( tag, btnItem )

	local f_hid = m_formationInfo[curHeroIndex]
	if(f_hid > 0)then
		local isOpen, openLv = FormationUtil.isFightSoulOpenByPos(tag)
		if(isOpen == true)then
			if not DataCache.getSwitchNodeState(ksSwitchBattleSoul) then
				return
			end
			require "script/ui/formation/ChangeEquipLayer"
			local changeEquipLayer = ChangeEquipLayer.createLayer( changeEquipCallback, m_formationInfo[curHeroIndex] , tag, false, true)
			require "script/ui/main/MainScene"
			MainScene.changeLayer(changeEquipLayer, "changeEquipLayer")
		else
			AnimationTip.showTip( openLv .. GetLocalizeStringBy("key_1526"))
		end
	end
end

-- 8个换战魂的按钮
function refreshFightSoulMenu()
	if(_fightSoulMenuBar ~= nil)then
		_fightSoulMenuBar:removeFromParentAndCleanup(true)
		_fightSoulMenuBar = nil
	end
	_fightSoulMenuBar = CCMenu:create()
	_equipMenuOriginPosition = ccp(0, 0)
	_fightSoulMenuBar:setPosition(_equipMenuOriginPosition)
	bgLayer:addChild(_fightSoulMenuBar,3)

	-- 顺序 
	local btnXPositions = {0.15, 0.85, 0.15, 0.85, 0.15, 0.85, 0.15, 0.85}
	local btnYPositions = {0.75, 0.75, 0.61, 0.61, 0.47, 0.47, 0.33, 0.33}

	local icon_file = "images/common/f_bg.png"

	local hid = m_formationInfo[curHeroIndex]

	for btnIndex,xScale in pairs(btnXPositions) do
		local menuItem = CCMenuItemImage:create(icon_file, icon_file)
		
		if(hid>0)then
			local isOpen, openLv = FormationUtil.isFightSoulOpenByPos(btnIndex)
			if( isOpen == true)then
				local fightSoulInfos = nil
				if(hid>0)then
					local heroRemoteInfo = nil
					local allHeros = HeroModel.getAllHeroes()
					for t_hid, t_hero in pairs(allHeros) do
						if( tonumber(t_hid) ==  hid) then
							heroRemoteInfo = t_hero
							break
						end
					end
					fightSoulInfos = heroRemoteInfo.equip.fightSoul
				end
				if( (not table.isEmpty(fightSoulInfos) ) and ( not table.isEmpty(fightSoulInfos["" .. btnIndex]) ) )then
					-- 有战魂
					local fightSoulInfo = fightSoulInfos["" .. btnIndex]
					-- getItemSpriteById( item_tmpl_id, item_id, itemDelegateAction, isNeedChangeBtn, menu_priority, zOrderNum, info_layer_priority, isRobTreasure, isDisplayLevel, enhanceLv )
					local t_menuItem = ItemSprite.getItemSpriteById(tonumber(fightSoulInfo.item_template_id), tonumber(fightSoulInfo.item_id), FormationLayer.equipInfoDelegeate, true, nil, nil, nil, nil, true, tonumber(fightSoulInfo.va_item_text.fsLevel))
					-- local t_menuItem = ItemSprite.getItemSpriteById(tonumber(fightSoulInfo.item_template_id), tonumber(fightSoulInfo.item_id), nil, true)
					-- 名称
					local equipDesc = ItemUtil.getItemById(tonumber(fightSoulInfo.item_template_id))
					local nameColor = HeroPublicLua.getCCColorByStarLevel(equipDesc.quality)
					local e_nameLabel =  CCRenderLabel:create(equipDesc.name , g_sFontName, 20, 2, ccc3( 0x00, 0x00, 0x00), type_stroke)
				    e_nameLabel:setColor(nameColor)
				    e_nameLabel:setAnchorPoint(ccp(0.5, 0))
				    e_nameLabel:setPosition(ccp( t_menuItem:getContentSize().width/2, -t_menuItem:getContentSize().height*0.1))
				    t_menuItem:addChild(e_nameLabel, 4)

					menuItem:addChild(t_menuItem)
				else
					-- 未添加战魂
					menuItem:registerScriptTapHandler(fightSoulAction)
				
					local iconSp = CCSprite:create("images/formation/potential/newadd.png")
					iconSp:setAnchorPoint(ccp(0.5, 0.5))
					iconSp:setPosition(ccp(menuItem:getContentSize().width*0.5, menuItem:getContentSize().height*0.5))
					menuItem:addChild(iconSp)

					local arrActions_2 = CCArray:create()
					arrActions_2:addObject(CCFadeOut:create(1))
					arrActions_2:addObject(CCFadeIn:create(1))
					local sequence_2 = CCSequence:create(arrActions_2)
					local action_2 = CCRepeatForever:create(sequence_2)
					iconSp:runAction(action_2)
					
				end
			else
				
				local lockSp = CCSprite:create("images/formation/potential/newlock.png")
				lockSp:setAnchorPoint(ccp(0.5, 0.5))
				lockSp:setPosition(ccp(menuItem:getContentSize().width/2, menuItem:getContentSize().height*0.5))
				menuItem:addChild(lockSp)
				-- if( tonumber(btnIndex) <=6 )then
				
					local tipLabel = CCRenderLabel:create( openLv, g_sFontPangWa, 25, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
				    tipLabel:setAnchorPoint(ccp(0.5, 0.5))
				    tipLabel:setColor(ccc3(0xff, 0xff, 0xff))
				    tipLabel:setPosition(ccp( menuItem:getContentSize().width* 0.5, menuItem:getContentSize().height*0.7))
				    menuItem:addChild(tipLabel)
				    menuItem:registerScriptTapHandler(fightSoulAction)

				    local openLvSp = CCSprite:create("images/formation/potential/jikaifang.png")
					openLvSp:setAnchorPoint(ccp(0.5, 0.5))
					openLvSp:setPosition(ccp(menuItem:getContentSize().width*0.5, menuItem:getContentSize().height*0.4))
					menuItem:addChild(openLvSp)
				-- else
				-- 	local tipLabel = CCRenderLabel:create(GetLocalizeStringBy("key_3325"), g_sFontPangWa, 25, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
				--     tipLabel:setAnchorPoint(ccp(0.5, 0.5))
				--     tipLabel:setColor(ccc3(0xff, 0xff, 0xff))
				--     tipLabel:setPosition(ccp( menuItem:getContentSize().width* 0.5, menuItem:getContentSize().height*0.5))
				--     menuItem:addChild(tipLabel)
				-- end
			end
		else
			
			menuItem:registerScriptTapHandler(fightSoulAction)
		end
		
		menuItem:setAnchorPoint(ccp(0.5, 0.5))
		menuItem:setPosition(MainScene.getMenuPositionInTruePoint(bgLayer:getContentSize().width*xScale,bgLayer:getContentSize().height*btnYPositions[btnIndex]))
		
		_fightSoulMenuBar:addChild(menuItem, 1, btnIndex)


	end

	if(_curFormationType == FORMATION_TYPE_FIGHTSOUL)then
		setFightSoulVisible(true)
	else
		setFightSoulVisible(false)
	end
end

-- 中间的卡牌 的6个换装备按钮
function refreshEquipMenu( )

	if(onekeyMenuBar)then
		if(m_formationInfo[curHeroIndex] and m_formationInfo[curHeroIndex]>0)then
			onekeyMenuBar:setVisible(true)
		else
			onekeyMenuBar:setVisible(false)
		end
	end

	if(equipMenuBar ~= nil) then
		equipMenuBar = tolua.cast(equipMenuBar, "CCNode")
		if (equipMenuBar) then
			equipMenuBar:removeFromParentAndCleanup(true)
			equipMenuBar = nil
		end
	end

	--按钮Bar
	equipMenuBar = CCMenu:create()
	_equipMenuOriginPosition = ccp(0, 0)
	equipMenuBar:setPosition(_equipMenuOriginPosition)
	bgLayer:addChild(equipMenuBar,3)

	-- 顺序 
	local btnXPositions = {0.15, 0.85, 0.15, 0.85, 0.15, 0.85}
	local btnYPositions = {0.7, 0.7, 0.53, 0.53, 0.35, 0.35}
	local emptyEquipIcons = {
								"images/formation/emptyequip/helmet.png",   "images/formation/emptyequip/weapon.png",		
								"images/formation/emptyequip/necklace.png",	"images/formation/emptyequip/armor.png",	
								"images/formation/emptyequip/book.png",		"images/formation/emptyequip/horse.png",
							}

	local hid = m_formationInfo[curHeroIndex]

	local arming = nil
	local treas_infos = nil
	if(hid>0)then
		local heroRemoteInfo = nil
		local allHeros = HeroModel.getAllHeroes()
		for t_hid, t_hero in pairs(allHeros) do
			if( tonumber(t_hid) ==  hid) then
				heroRemoteInfo = t_hero
				break
			end
		end
		arming = heroRemoteInfo.equip.arming
		treas_infos = heroRemoteInfo.equip.treasure
	end


	for btnIndex,xScale in pairs(btnXPositions) do

		local borderFileName = "images/common/equipborder.png"
		if(btnIndex >=5)then
			borderFileName = "images/common/t_equipborder.png"
		end

		local equipBorderSp = CCSprite:create(borderFileName)
		equipBorderSp:setAnchorPoint(ccp(0.5,0.5))
		
		local equipBtn = nil --LuaMenuItem.createItemImage(emptyEquipIcons[btnIndex],  emptyEquipIcons[btnIndex])
		if( btnIndex < 5)then
			-- 装备
			if(table.isEmpty(arming) == false)then
				local equipInfo = arming["" .. equipPositions[btnIndex]]
				if( table.isEmpty(equipInfo) == false and  tonumber(equipInfo.item_template_id) > 0) then
					local equipSprite = ItemSprite.getItemSpriteById(tonumber(equipInfo.item_template_id), tonumber(equipInfo.item_id), FormationLayer.equipInfoDelegeate, true)
					equipBtn = LuaMenuItem.createItemSprite(equipSprite, equipSprite)
				
					-- 名称
					local equipDesc = ItemUtil.getItemById(tonumber(equipInfo.item_template_id))
					local nameColor = HeroPublicLua.getCCColorByStarLevel(equipDesc.quality)
					local e_nameLabel =  CCRenderLabel:create(equipDesc.name , g_sFontName, 20, 2, ccc3( 0x00, 0x00, 0x00), type_stroke)
				    e_nameLabel:setColor(nameColor)
				    e_nameLabel:setPosition(ccp( (equipBtn:getContentSize().width-e_nameLabel:getContentSize().width)/2, -equipBtn:getContentSize().height*0.1))
				    equipBtn:addChild(e_nameLabel)
					-- 强化等级
					local lvSprite = CCSprite:create("images/base/potential/lv_" .. equipDesc.quality .. ".png")
					lvSprite:setAnchorPoint(ccp(0,1))
					lvSprite:setPosition(ccp(-1, equipBtn:getContentSize().height))
					equipBtn:addChild(lvSprite)
					local lvLabel =  CCRenderLabel:create(equipInfo.va_item_text.armReinforceLevel , g_sFontName, 18, 1, ccc3( 0, 0, 0), type_stroke)
				    lvLabel:setColor(ccc3(255,255,255))
				    lvLabel:setAnchorPoint(ccp(0.5,0.5))
				    lvLabel:setPosition(ccp( lvSprite:getContentSize().width*0.5, lvSprite:getContentSize().height*0.5))
				    lvSprite:addChild(lvLabel)

				end
				-- 新手引导用
				if(btnIndex == 2)then
					_weaponBtn = equipBtn
				end
			end
		else
			-- 宝物
			if(table.isEmpty(treas_infos) == false)then
				local treasInfo = treas_infos["" .. equipPositions[btnIndex]]
				if( table.isEmpty(treasInfo) == false and  tonumber(treasInfo.item_template_id) > 0) then
					local equipSprite = ItemSprite.getItemSpriteById(tonumber(treasInfo.item_template_id), tonumber(treasInfo.item_id), FormationLayer.equipInfoDelegeate, true)
					equipBtn = LuaMenuItem.createItemSprite(equipSprite, equipSprite)
				
					-- 名称
					local equipDesc = ItemUtil.getItemById(tonumber(treasInfo.item_template_id))
					local nameColor = HeroPublicLua.getCCColorByStarLevel(equipDesc.quality)
					local e_nameLabel =  CCRenderLabel:create(equipDesc.name , g_sFontName, 20, 2, ccc3( 0x00, 0x00, 0x00), type_stroke)
				    e_nameLabel:setColor(nameColor)
				    e_nameLabel:setPosition(ccp( (equipBtn:getContentSize().width-e_nameLabel:getContentSize().width)/2, -equipBtn:getContentSize().height*0.1))
				    equipBtn:addChild(e_nameLabel)
					-- 强化等级
					local lvSprite = CCSprite:create("images/base/potential/lv_" .. equipDesc.quality .. ".png")
					lvSprite:setAnchorPoint(ccp(0,1))
					lvSprite:setPosition(ccp(-1, equipBtn:getContentSize().height))
					equipBtn:addChild(lvSprite)
					local lvLabel =  CCRenderLabel:create(treasInfo.va_item_text.treasureLevel, g_sFontName, 18, 1, ccc3( 0, 0, 0), type_stroke)
				    lvLabel:setColor(ccc3(255,255,255))
				    lvLabel:setAnchorPoint(ccp(0.5,0.5))
				    lvLabel:setPosition(ccp( lvSprite:getContentSize().width*0.5, lvSprite:getContentSize().height*0.5))
				    lvSprite:addChild(lvLabel)
				end
			end
		end
		if(equipBtn == nil)then
			equipBtn = LuaMenuItem.createItemImage(emptyEquipIcons[btnIndex],  emptyEquipIcons[btnIndex])
			equipBtn:registerScriptTapHandler(changeEquipAction)
		end
		if(btnIndex == 6)then
	    	_horseBtn = equipBtn
	    end
		-- equipBorderSp:setPosition(ccp(bgLayer:getContentSize().width*xScale,bgLayer:getContentSize().height*btnYPositions[btnIndex]))
		equipBorderSp:setPosition(ccp(equipBtn:getContentSize().width*0.5,equipBtn:getContentSize().height*0.5))
		equipBtn:addChild(equipBorderSp, -1)
		equipBtn:setAnchorPoint(ccp(0.5, 0.5))
		equipBtn:setPosition(MainScene.getMenuPositionInTruePoint(bgLayer:getContentSize().width*xScale,bgLayer:getContentSize().height*btnYPositions[btnIndex]))
		
		equipMenuBar:addChild(equipBtn, 1, 20000+btnIndex)
	end

	if(_curFormationType == FORMATION_TYPE_EQUIP)then
		setEquipFormationVisible(true)
	else
		setEquipFormationVisible(false)
	end
end

--[[
	@desc	换完装备的回调
	@para 	hid 	 将领ID
			equipPos 装备位置
			itemId   itemId
			o_hid    是否是另一个将领的身上的装备
	@return void
--]]
function changeEquipCallback( hid, equipPos, itemId, o_hid )
	
	refreshEquipMenu()
	refreshBottomInfo()
end


--[[
	@desc	中间的卡牌
	@para 	
	@return void
--]]
local function heroCardScrollView ( ... ) 
	containerLayer = CCLayer:create() --CCLayerColor:create(ccc4(250,150,150,255)) --CCLayer:create()
	local cardSprite = nil

	local formationHeros = 0
	for h_index, hid in pairs(m_formationInfo) do
		local iconName = "images/formation/testhero.png"
		if(hid < 0) then
			break
		elseif(hid >0) then
			
			local heroRemoteInfo = nil
			local allHeros = HeroModel.getAllHeroes()
			for t_hid, t_hero in pairs(allHeros) do
				if( tonumber(t_hid) ==  hid) then
					heroRemoteInfo = t_hero
					break
				end
			end
			local dressId = nil
			if(not table.isEmpty( heroRemoteInfo.equip.dress) and not table.isEmpty(heroRemoteInfo.equip.dress["1"]))then
				dressId = heroRemoteInfo.equip.dress["1"].item_template_id
			-- 	local dressInfo = ItemUtil.getItemById(heroRemoteInfo.equip.dress["1"].item_template_id)
			-- 	local d_heroInfo = DB_Heroes.getDataById(ItemSprite.getStringByFashionString(dressInfo.changeModel))

			-- 	iconName = "images/base/hero/body_img/" .. d_heroInfo.body_img_id
			-- else
			-- 	require "db/DB_Heroes"
			-- 	local heroLocalInfo = DB_Heroes.getDataById(tonumber(heroRemoteInfo.htid))
			-- 	iconName = "images/base/hero/body_img/" .. heroLocalInfo.body_img_id
			end

			cardSprite = HeroUtil.getHeroBodySpriteByHTID( heroRemoteInfo.htid, dressId, UserModel.getUserSex() ) --CCSprite:create(iconName)

		elseif (hid == 0) then
			iconName = "images/formation/testselect.png"
			cardSprite = CCSprite:create(iconName)
		end
		formationHeros = formationHeros + 1

		
		cardSprite:setAnchorPoint(ccp(0.5,0))
		cardSprite:setPosition(ccp( curCardSize.width * (h_index-0.5), 0))
		-- curCardSize = cardSprite:getContentSize()
		containerLayer:addChild(cardSprite)
	end

	containerLayer:setContentSize(CCSizeMake(curCardSize.width*formationHeros, curCardSize.height ))

	herosScrollView = CCScrollView:create()
	herosScrollView:setContainer(containerLayer)
	herosScrollView:setTouchEnabled(false)
	herosScrollView:setDirection(kCCScrollViewDirectionHorizontal)
	herosScrollView:setViewSize(curCardSize)
	herosScrollView:setAnchorPoint(ccp((bgLayer:getContentSize().width - curCardSize.width)/2, bgLayer:getContentSize().height))
	herosScrollView:setBounceable(true)

	-- containerLayer:registerScriptTouchHandler(onTouchesHandler, false, -129, true)
	
	-- scrollview 的 底
	scrollBgLayer = CCSprite:create()
	scrollBgLayer:setContentSize(curCardSize)
	local bottomSize = bottomBg:getContentSize()
	scrollBgLayer:setAnchorPoint(ccp(0.5, 0.5))
	curCardPosition = ccp(bgLayer:getContentSize().width/2, bgLayer:getContentSize().height*0.63)
	_scrollBgLayerOriginPosition = curCardPosition
	scrollBgLayer:setPosition(curCardPosition)

	scrollBgLayer:addChild(herosScrollView, 2)
	bgLayer:addChild(scrollBgLayer)
	
	
end 

-- 隐藏战魂阵容
function setFightSoulVisible( isVisible )
	_fightSoulMenuBar:setVisible(isVisible)
end

-- 隐藏装备阵容
function setEquipFormationVisible( isVisible )
	equipMenuBar:setVisible(isVisible)
	-- onekeyMenuBar:setVisible(isVisible)
	-- if(m_formationInfo[curHeroIndex] and m_formationInfo[curHeroIndex]>0)then
	-- 	onekeyMenuBar:setVisible(isVisible)
	-- else
	-- 	onekeyMenuBar:setVisible(false)
	-- end
end

-- 是否切换到布阵
function setVisibleMiddleUI( isVisible)
	isVisibalMiddleUI = isVisible

	scrollBgLayer:setVisible(isVisible)

	if(isVisible == true)then
		if(_curFormationType == FORMATION_TYPE_EQUIP)then
			setFightSoulVisible(false)
			setEquipFormationVisible(true)
		elseif(_curFormationType == FORMATION_TYPE_FIGHTSOUL)then
			setFightSoulVisible(true)
			setEquipFormationVisible(false)
		end
	else
		setFightSoulVisible(false)
		setEquipFormationVisible(false)
	end

	bottomBg:setVisible(isVisible) 
	herosScrollView:setTouchEnabled(isVisible)

	-- 小伙伴
	_littleFriendLayer:setVisible(isVisible)

	-- 布阵界面
	if ( isVisible == false) then
		createChangeFormation()
	else
		if(changeFormationSprite)then
			changeFormationSprite:removeFromParentAndCleanup(true)
			changeFormationSprite = nil
		end
		if(backToFormationBar) then
			backToFormationBar:removeFromParentAndCleanup(true)
			backToFormationBar = nil
		end
	end
end

-- 返回阵容
function backToFormationAction( ... )
	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
 	setVisibleMiddleUI(true)
end 

-- 布阵界面 ( 不得已而为之)
function createChangeFormation(  )
	-- 修改阵型的UI
	-- 阵型背景
	local fullRect = CCRectMake(0,0,213,171)
	local insetRect = CCRectMake(50,50,113,71)
	changeFormationSprite = CCScale9Sprite:create("images/formation/changeformation/bg.png", fullRect, insetRect)
	changeFormationSprite:setPreferredSize(CCSizeMake(620, 510))
	changeFormationSprite:setAnchorPoint(ccp(0.5, 0.5))
	changeFormationSprite:setPosition(ccp(bgLayer:getContentSize().width*0.5, bgLayer:getContentSize().height*0.41))
	bgLayer:addChild(changeFormationSprite)	

	local CFSSize = changeFormationSprite:getContentSize()
	-- 标题
	local titleSp = CCSprite:create("images/formation/changeformation/titlebg.png")
	titleSp:setAnchorPoint(ccp(0.5,0.5))
	titleSp:setPosition(ccp(changeFormationSprite:getContentSize().width/2, changeFormationSprite:getContentSize().height*0.986))
	changeFormationSprite:addChild(titleSp)
	local titleLabel = CCRenderLabel:create(GetLocalizeStringBy("key_2896") , g_sFontName, 35, 2, ccc3( 0x00, 0x00, 0x00), type_stroke)
    -- titleLabel:setSourceAndTargetColor(ccc3( 0xff, 0xf0, 0x49), ccc3( 0xff, 0xa2, 0x00));
    titleLabel:setColor(ccc3(0xff, 0xf6, 0x00))
    titleLabel:setPosition(ccp( (titleSp:getContentSize().width-titleLabel:getContentSize().width)/2, titleSp:getContentSize().height*0.85))
    titleSp:addChild(titleLabel, 10000, 10000)

	-- 返回阵容Bar
	backToFormationBar = CCMenu:create()
	backToFormationBar:setPosition(ccp(0, 0))
	bgLayer:addChild(backToFormationBar)
	-- 返回阵容Button
	local backToFormationBtn = LuaCC.create9ScaleMenuItem("images/common/btn/btn1_d.png","images/common/btn/btn1_n.png",CCSizeMake(200, 73),GetLocalizeStringBy("key_2661"),ccc3(0xfe, 0xdb, 0x1c),35,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00))
	backToFormationBtn:setAnchorPoint(ccp(0.5, 0.5))
	backToFormationBtn:setPosition(MainScene.getMenuPositionInTruePoint(bgLayer:getContentSize().width*0.5, bgLayer:getContentSize().height*0.06))
	backToFormationBtn:registerScriptTapHandler(backToFormationAction)
	backToFormationBar:addChild(backToFormationBtn)


-- 6 个位置UI
	heroXScale = { 0.2, 0.5, 0.8, 0.2, 0.5, 0.8 }
	heroYScale = { 0.7, 0.7, 0.7, 0.28, 0.28, 0.28 }
	local underZorder = 10
	local upZorder = 20
	heroCardsTable = {}
	for k, xScale in pairs(heroXScale) do
		local hid = ck_formationInfo[(k-1)]
		local heroSp = HeroSprite.createHeroSprite(hid, (k-1))
		heroSp:setAnchorPoint(ccp(0.5, 0.5))
		heroSp:setPosition(ccp(CFSSize.width*xScale,CFSSize.height*heroYScale[k]))
		if tonumber(k) >= 4 then
			changeFormationSprite:addChild(heroSp, underZorder, k)
		else
			changeFormationSprite:addChild(heroSp, upZorder, k)
		end
		if(hid>=0)then
			heroCardsTable[k] = heroSp
		end

		local heroBg = CCSprite:create("images/formation/changeformation/herobg.png")
		heroBg:setAnchorPoint(ccp(0.5,0.5))
		heroBg:setPosition(ccp(CFSSize.width*xScale,CFSSize.height*heroYScale[k]))
		changeFormationSprite:addChild(heroBg)
	end
end

-- 创建小伙伴
function createLittleFriendUI()
	local myScale = bgLayer:getContentSize().width/topBgSp:getContentSize().width
	-- print("myScale:",myScale)
	-- 小伙伴
	_littleFriendLayer = LittleFriendLayer.createLittleFriendLayer(bgLayer:getContentSize().width, bgLayer:getContentSize().height-topBgSp:getContentSize().height*myScale)
	_littleFriendLayerOriginPosition = ccp(bgLayer:getContentSize().width, 0)
	_littleFriendLayer:setPosition(_littleFriendLayerOriginPosition)
	bgLayer:addChild(_littleFriendLayer)
	_littleFriendLayer:setScale(1/MainScene.elementScale)
end

--[[
	@desc	上部的按钮
	@para 	
	@return void
--]]
function topMenuItemAction( tag, itemMenu )
	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
	-- 布阵
	if (tag == 10003 and isVisibalMiddleUI == true) then
		setVisibleMiddleUI( false)
	end
end

-- 点击羁绊区域
local function jibanAction( tag, itemMenu )
	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
	changeOfficeLayerAction()
end

-- 切换到装备阵容
function toEquipFormationAction( tag, btn )
	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
	_curFormationType = FORMATION_TYPE_EQUIP

	_f_fightSoulBtn:setVisible(true)
	_f_equipBtn:setVisible(false)

	-- 显示装备阵容
	setEquipFormationVisible(true)
	setFightSoulVisible(false)
end

-- 切换到战魂阵容
function toFightSoulFormationAction( tag, btn )
	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
	_curFormationType = FORMATION_TYPE_FIGHTSOUL
	_f_fightSoulBtn:setVisible(false)
	_f_equipBtn:setVisible(true)

	-- 隐藏装备阵容
	setEquipFormationVisible(false)
	setFightSoulVisible(true)
end

-- 开始创建UI
local function create( ... )

	local bgLayerSize = bgLayer:getContentSize()

-- 上面的英雄列表
	--背景	
	topBgSp = CCSprite:create("images/formation/topbg.png")
	local myScale = bgLayer:getContentSize().width/topBgSp:getContentSize().width/bgLayer:getElementScale()
	topBgSp:setAnchorPoint(ccp(0.5,1))
	topBgSp:setPosition(ccp(bgLayerSize.width/2, bgLayerSize.height))
	bgLayer:addChild(topBgSp)
	topBgSp:setScale(myScale)

    local topMenuBar = CCMenu:create()
    topMenuBar:setPosition(ccp(0, 0))
    topBgSp:addChild(topMenuBar)

	--左右翻页的按钮
	require "script/ui/common/LuaMenuItem"
	--左按钮
	local leftBtn = LuaMenuItem.createItemImage("images/formation/btn_left.png",  "images/formation/btn_left.png", topMenuItemAction )
	leftBtn:setAnchorPoint(ccp(0.5, 0.5))
	leftBtn:setPosition(ccp(topBgSp:getContentSize().width*0.06, topBgSp:getContentSize().height/2))
	-- leftBtn:registerScriptTapHandler(topMenuItemAction)
	topMenuBar:addChild(leftBtn, 10001, 10001)
	-- 右按钮
	local rightBtn = LuaMenuItem.createItemImage("images/formation/btn_right.png",  "images/formation/btn_right.png", topMenuItemAction )
	rightBtn:setAnchorPoint(ccp(0.5, 0.5))
	rightBtn:setPosition(ccp(topBgSp:getContentSize().width*0.82, topBgSp:getContentSize().height/2))
	-- rightBtn:registerScriptTapHandler(topMenuItemAction)
	topMenuBar:addChild(rightBtn, 10002, 10002)

	-- 布阵按钮
	local deployBtn = LuaMenuItem.createItemImage("images/formation/btn_deploy_n.png",  "images/formation/btn_deploy_h.png", topMenuItemAction )
	deployBtn:setAnchorPoint(ccp(0.5, 0.5))
	deployBtn:setPosition(ccp(topBgSp:getContentSize().width*0.92, topBgSp:getContentSize().height/2))
	-- deployBtn:registerScriptTapHandler(topMenuItemAction)
	topMenuBar:addChild(deployBtn, 10003, 10003)

	-- 上部UI上阵英雄tableView的创建
	createTopTableView()



-- 最下面UI
	-- 底
	bottomBg = CCSprite:create("images/formation/bottombg.png")
	bottomBg:setAnchorPoint(ccp(0.5, 0))
	_bottomBgOriginPosition = ccp(bgLayer:getContentSize().width/2, 0)
	bottomBg:setPosition(ccp(bgLayer:getContentSize().width/2, 0))
	bottomBg:setScale(myScale)
	bgLayer:addChild(bottomBg,2)
	local bottomSize = bottomBg:getContentSize()

	-- 一键装备按钮
	onekeyMenuBar = CCMenu:create()
	onekeyMenuBar:setPosition(ccp(0,0))
	bottomBg:addChild(onekeyMenuBar)
	onekeyBtn = LuaMenuItem.createItemImage("images/formation/btn_onekey_n.png",  "images/formation/btn_onekey_h.png")
	onekeyBtn:setAnchorPoint(ccp(0.5, 0.5))
	onekeyBtn:setPosition(ccp(bottomSize.width*0.85, bottomSize.height*0.8))
	onekeyBtn:registerScriptTapHandler(onekeyMenuItemAction)
	onekeyMenuBar:addChild(onekeyBtn)
	-- onekeyMenuBar:setVisible(false)

	_equipAndFightSoulMenu = CCMenu:create()
	_equipAndFightSoulMenu:setPosition(ccp(0,0))
	bottomBg:addChild(_equipAndFightSoulMenu)

	-- 切换装备阵容按钮
	_f_equipBtn = CCMenuItemImage:create("images/common/btn/btn_equip_n.png", "images/common/btn/btn_equip_h.png")
	_f_equipBtn:setAnchorPoint(ccp(0.5, 0.5))
	_f_equipBtn:setPosition(ccp(bottomSize.width*0.5, bottomSize.height*0.8))
	_f_equipBtn:registerScriptTapHandler(toEquipFormationAction)
	_equipAndFightSoulMenu:addChild(_f_equipBtn)
	
	-- 切换战魂阵容界面
	_f_fightSoulBtn = CCMenuItemImage:create("images/common/btn/btn_fightSoul_n.png", "images/common/btn/btn_fightSoul_h.png")
	_f_fightSoulBtn:setAnchorPoint(ccp(0.5, 0.5))
	_f_fightSoulBtn:setPosition(ccp(bottomSize.width*0.5, bottomSize.height*0.8))
	_f_fightSoulBtn:registerScriptTapHandler(toFightSoulFormationAction)
	_equipAndFightSoulMenu:addChild(_f_fightSoulBtn)

	if(_curFormationType == FORMATION_TYPE_EQUIP)then
		_f_equipBtn:setVisible(false)
		_f_fightSoulBtn:setVisible(true)
	else
		_f_equipBtn:setVisible(true)
		_f_fightSoulBtn:setVisible(false)
	end

	heroNameBg = CCScale9Sprite:create("images/common/bg/bg_9s_2.png")
	heroNameBg:setContentSize(CCSizeMake(240, 40))
	heroNameBg:setAnchorPoint(ccp(0.5,0))
	heroNameBg:setPosition(ccp(bottomSize.width*0.5, bottomSize.height))
	bottomBg:addChild(heroNameBg,2)

	local e_sprite_1 = CCSprite:create()
	e_sprite_1:setContentSize(CCSizeMake(295, 90))
	local e_sprite_2 = CCSprite:create()
	e_sprite_2:setContentSize(CCSizeMake(295, 90))
	local e_menuItem = CCMenuItemSprite:create(e_sprite_1, e_sprite_2)
	e_menuItem:setAnchorPoint(ccp(0,0))
	e_menuItem:setPosition(ccp(25, 25))
	e_menuItem:registerScriptTapHandler(jibanAction)
	onekeyMenuBar:addChild(e_menuItem)

	-- 英雄等级
	heroLevelLabel = CCRenderLabel:create("LV100", g_sFontPangWa, 21, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	heroLevelLabel:setColor(ccc3(0xff, 0xf6, 0x00))
	heroLevelLabel:setAnchorPoint(ccp(0, 1))
	heroLevelLabel:setPosition(ccp(100, bottomSize.height*0.93))
	bottomBg:addChild(heroLevelLabel)	

	-- 英雄战斗力
	firePoweLabel = CCRenderLabel:create("1234567890" , g_sFontName, 25, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
    -- firePoweLabel:setSourceAndTargetColor(ccc3( 0xff, 0xf5, 0x83), ccc3( 0xff, 0xde, 0x00));
    firePoweLabel:setColor(ccc3(0xff, 0xf6, 0x00))
    firePoweLabel:setPosition(ccp( bottomSize.width* 470/640, bottomSize.height*0.58))
    bottomBg:addChild(firePoweLabel)				

    -- 血量标题
    local hpTitleLabel = CCLabelTTF:create("H P", g_sFontName, 22)
	hpTitleLabel:setColor(ccc3(0x78, 0x25, 0x00))
	hpTitleLabel:setAnchorPoint(ccp(0, 0))
	hpTitleLabel:setPosition(ccp(bottomSize.width*0.55, bottomSize.height*0.48))
	-- bottomBg:addChild(hpTitleLabel)

	-- 血量条
	local hpBgSp = CCSprite:create("images/formation/bloodbg.png")
	hpBgSp:setPosition(ccp(bottomSize.width*0.61, bottomSize.height*0.48))
	-- bottomBg:addChild(hpBgSp)
	local hpSp = CCSprite:create("images/formation/blood.png")
	hpSp:setAnchorPoint(ccp(0.5, 0.5))
	hpSp:setPosition(ccp(hpBgSp:getContentSize().width/2, hpBgSp:getContentSize().height/2))
	hpBgSp:addChild(hpSp)
	-- 血量
	hpLabel = CCLabelTTF:create("99999", g_sFontName, 23)
	hpLabel:setColor(ccc3(0xff, 0xff, 0xff))
	hpLabel:setAnchorPoint(ccp(0.5, 0.5))
	hpLabel:setPosition(ccp(hpSp:getContentSize().width/2, hpSp:getContentSize().height/2))
	hpSp:addChild(hpLabel)

	-- 羁绊
    local jipanBg = CCSprite:create("images/common/line2.png")
    jipanBg:setAnchorPoint(ccp(0.5,0.5))
    jipanBg:setPosition(ccp(bottomSize.width * 175/640, bottomSize.height*0.55))
    bottomBg:addChild(jipanBg)

    local jipanSp = CCSprite:create("images/formation/text.png")
    jipanSp:setAnchorPoint(ccp(0.5,0.5))
    jipanSp:setPosition(ccp(jipanBg:getContentSize().width * 0.5, jipanBg:getContentSize().height*0.5))
    jipanBg:addChild(jipanSp)

    local x_scale = { 68.0/640, 175.0/640, 280.0/640, 68.0/640, 175.0/640, 280.0/640}
    local y_scale = { 0.35, 0.35, 0.35 ,0.2 ,0.2, 0.2}

    skillLabelArr = {}
    for i=1,6 do
    	local tempLabel = CCLabelTTF:create("99999", g_sFontName, 23)
		tempLabel:setColor(ccc3(0x78, 0x25, 0x00))
		tempLabel:setAnchorPoint(ccp(0.5, 0.5))
		tempLabel:setPosition(ccp(bottomBg:getContentSize().width* x_scale[i], bottomBg:getContentSize().height * y_scale[i]))
		bottomBg:addChild(tempLabel)
		table.insert(skillLabelArr, tempLabel)
    end

    -- 武将的攻击等等
    -- 生命
    local phyAttTitleLabel =  CCLabelTTF:create(GetLocalizeStringBy("key_1754"), g_sFontName, 23)
	phyAttTitleLabel:setColor(ccc3(0x78, 0x25, 0x00))
	phyAttTitleLabel:setAnchorPoint(ccp(0.5, 0.5))
	phyAttTitleLabel:setPosition(ccp(bottomBg:getContentSize().width* 380/640, bottomBg:getContentSize().height * 0.35))
	bottomBg:addChild(phyAttTitleLabel)
    -- 物防
    local phyDefTitleLabel =  CCLabelTTF:create(GetLocalizeStringBy("key_1567"), g_sFontName, 23)
	phyDefTitleLabel:setColor(ccc3(0x78, 0x25, 0x00))
	phyDefTitleLabel:setAnchorPoint(ccp(0.5, 0.5))
	phyDefTitleLabel:setPosition(ccp(bottomBg:getContentSize().width* 380/640, bottomBg:getContentSize().height * 0.2))
	bottomBg:addChild(phyDefTitleLabel)
    -- 攻击
    local magAttTitleLabel =  CCLabelTTF:create(GetLocalizeStringBy("key_2966"), g_sFontName, 23)
	magAttTitleLabel:setColor(ccc3(0x78, 0x25, 0x00))
	magAttTitleLabel:setAnchorPoint(ccp(0.5, 0.5))
	magAttTitleLabel:setPosition(ccp(bottomBg:getContentSize().width* 510/640, bottomBg:getContentSize().height * 0.35))
	bottomBg:addChild(magAttTitleLabel)
    -- 法防
    local magDefTitleLabel =  CCLabelTTF:create(GetLocalizeStringBy("key_3147"), g_sFontName, 23)
	magDefTitleLabel:setColor(ccc3(0x78, 0x25, 0x00))
	magDefTitleLabel:setAnchorPoint(ccp(0.5, 0.5))
	magDefTitleLabel:setPosition(ccp(bottomBg:getContentSize().width* 510/640, bottomBg:getContentSize().height * 0.2))
	bottomBg:addChild(magDefTitleLabel)

	--数值
	-- 生命
	life_att_label = CCLabelTTF:create("99999", g_sFontName, 22)
	life_att_label:setColor(ccc3(0x00, 0x00, 0x00))
	life_att_label:setAnchorPoint(ccp(0, 0.5))
	life_att_label:setPosition(ccp(bottomBg:getContentSize().width* 410/640, bottomBg:getContentSize().height * 0.34))
	bottomBg:addChild(life_att_label)
	-- 物理防御
	phy_def_label = CCLabelTTF:create("99999", g_sFontName, 22)
	phy_def_label:setColor(ccc3(0x00, 0x00, 0x00))
	phy_def_label:setAnchorPoint(ccp(0, 0.5))
	phy_def_label:setPosition(ccp(bottomBg:getContentSize().width* 410/640, bottomBg:getContentSize().height * 0.19))
	bottomBg:addChild(phy_def_label)
	-- 攻击
	mag_att_label = CCLabelTTF:create("99999", g_sFontName, 22)
	mag_att_label:setColor(ccc3(0x00, 0x00, 0x00))
	mag_att_label:setAnchorPoint(ccp(0, 0.5))
	mag_att_label:setPosition(ccp(bottomBg:getContentSize().width* 540/640, bottomBg:getContentSize().height * 0.34))
	bottomBg:addChild(mag_att_label)		
	-- 法防	
	mag_def_label = CCLabelTTF:create("99999", g_sFontName, 22)
	mag_def_label:setColor(ccc3(0x00, 0x00, 0x00))
	mag_def_label:setAnchorPoint(ccp(0, 0.5))
	mag_def_label:setPosition(ccp(bottomBg:getContentSize().width* 540/640, bottomBg:getContentSize().height * 0.19))
	bottomBg:addChild(mag_def_label)


	-- 中间的UI
	
	-- 阵型背景
	-- local formationBgSprite = CCSprite:create("images/formation/formationbg.jpg")
	-- formationBgSprite:setAnchorPoint(ccp(0.5, 1))
	-- formationBgSprite:setPosition(ccp(bgLayerSize.width/2, bgLayerSize.height- topBgSp:getContentSize().height))
	-- bgLayer:addChild(formationBgSprite)

	-- 英雄卡牌
	heroCardScrollView()
	--聚光灯
	local spotLightSp = CCSprite:create("images/formation/spotlight.png")
	spotLightSp:setAnchorPoint(ccp(0.5,1))
	spotLightSp:setPosition(ccp(scrollBgLayer:getContentSize().width/2, scrollBgLayer:getContentSize().height*0.75))
	scrollBgLayer:addChild(spotLightSp, 1)

	-- 星星底
	starsBgSp = CCSprite:create("images/formation/stars_bg.png")
	starsBgSp:setAnchorPoint(ccp(0.5, 1))
	starsBgSp:setPosition(ccp(scrollBgLayer:getContentSize().width/2, scrollBgLayer:getContentSize().height*0.75))
	scrollBgLayer:addChild(starsBgSp, 2)
	
	-- 星星们
	local starsXPositions = {0.2,0.3,0.4,0.5,0.6,0.7,0.8}
	local starsYPositions = {0.68,0.71,0.74,0.75,0.74,0.71,0.68}
	starsXPositions = {0.5, 0.4, 0.6, 0.3, 0.7, 0.2, 0.8}
	starsYPositions = {0.75, 0.74, 0.74, 0.71, 0.71, 0.68, 0.68}

	starArr_h={}
	starArr_n={}
	for starIndex, xScale in pairs(starsXPositions) do
		local starSp = CCSprite:create("images/formation/star.png")
		starSp:setAnchorPoint(ccp(0.5, 0.5))
		starSp:setPosition(ccp(starsBgSp:getContentSize().width * xScale, starsBgSp:getContentSize().height * starsYPositions[starIndex]))
		starsBgSp:addChild(starSp)
		table.insert(starArr_h, starSp)

		-- local starSp_n = CCSprite:create("images/common/star_n.png")
		-- starSp_n:setAnchorPoint(ccp(0.5, 0.5))
		-- starSp_n:setPosition(ccp(starsBgSp:getContentSize().width * xScale, starsBgSp:getContentSize().height * starsYPositions[starIndex]))
		-- starsBgSp:addChild(starSp_n)
		-- table.insert(starArr_n, starSp_n)
	end

	-- 添加6个装备的按钮
	refreshEquipMenu()
	refreshBottomInfo()

	-- 添加8个战魂按钮
	refreshFightSoulMenu()

	-- 创建小伙伴
	createLittleFriendUI()

	--add by lichenyang  -- add new Guide
	local newGuideAction = CCSequence:createWithTwoActions(CCDelayTime:create(0.3),CCCallFunc:create(addNewGuide))
	bgLayer:runAction(newGuideAction)
end

-- 处理成需要的阵型信息
function handleFormation()
	
	require "script/ui/formation/FormationUtil"
	open_num = FormationUtil.getFormationOpenedNum()
	-- print("open_num ====", open_num)
	-- 处理 m_formationInfo 和 c_formationInfo
	if ( formationInfo ) then
		m_formationInfo = {}
		ck_formationInfo = {}
		m_num = 0 			-- 已上阵将领的个数
		c_formationInfo = {}
		
		for i=0,5 do
			if(i<open_num)then
				c_formationInfo[i] = 0
			else
				c_formationInfo[i] = -1
			end
		end
		for k=0,5 do
			hid = formationInfo["" .. k]
			
			if (hid > 0) then
				table.insert(m_formationInfo, tonumber(hid))
				-- m_formationInfo[tonumber(k) + 1] = tonumber(hid)
				c_formationInfo[tonumber(k)] = tonumber(hid)
				m_num = m_num + 1
			else

			end
		end

		--顺序调整 by 张梓航

		for i=m_num+1, open_num do
			table.insert(m_formationInfo, 0)
		end

		if (open_num < g_limitedHerosOnFormation) then
			table.insert(m_formationInfo, -1)		-- 在解锁阵容后加入没开启
		end

		-- 最后插入小伙伴
		table.insert(m_formationInfo, -2)

		
		
		-- 真在的阵型信息
		local real_formation = DataCache.getFormationInfo()
		ck_formationInfo = {}
		for k,h_id in pairs(real_formation) do
			if(h_id>0)then
				ck_formationInfo[tonumber(k)] = h_id
			elseif(FormationUtil.isOpenedByPosition(k))then
				ck_formationInfo[tonumber(k)] = 0
			else
				ck_formationInfo[tonumber(k)] = -1
			end
		end
	end
end

-- 刷新界面
function refreshAll( ... )
	handleFormation()
	refreshTopHerosTableView( )
	refreshEquipMenu()
	refreshFightSoulMenu()
end

--  刷新上面的额TableView
function refreshTopHerosTableView( )
	if(topHerosTableview)then
		local contentOffset = topHerosTableview:getContentOffset() 
		topHerosTableview:reloadData()
		topHerosTableview:setContentOffset(contentOffset) 
	end
end

-- 阵型信息
function realFormationCallback( cbFlag, dictData, bRet )
	if(dictData.err == "ok") then

		local real_formationInfo = {}
		if(dictData.ret) then
			for k,v in pairs(dictData.ret) do
		        real_formationInfo["" .. (tonumber(k)-1)] = tonumber(v)
		    end
			DataCache.setFormationInfo(real_formationInfo)
		end

		handleFormation()
		create()
	end
end

-- 阵容信息
function formationCallback( cbFlag, dictData, bRet )
	if(dictData.err == "ok") then
		formationInfo = {}
		if(dictData.ret) then
			for k,v in pairs(dictData.ret) do
		        formationInfo["" .. (tonumber(k)-1)] = tonumber(v)
		    end
			DataCache.setSquad(formationInfo)
		end
		RequestCenter.getFormationInfo(realFormationCallback)
		
	end
end

-- 新手引导 start 0
function getGuideTopCell(cellIndex)
	if(cellIndex == nil)then
		cellIndex = 1
	end
	if(topHerosTableview)then 
		return topHerosTableview:cellAtIndex(cellIndex)
	end
	return nil
end

-- 一键装备
function getGuideObject()
	return onekeyBtn
end

-- 武器
function getGuideObject_2()
	return _weaponBtn
end

-- 战马
function getGuideObject_3()
	return _horseBtn
end


--[[
	@desc	创建
	@para 	display_hid
	@return void
--]]
function createLayer(display_hid, isAnimate, isShowLittleFriend, isDefaultLastIndex, formationType)
	_isNeedDisplayAnimation = isAnimate 
	if(_isNeedDisplayAnimation==nil) then
		_isNeedDisplayAnimation = true
	end
	-- 是否默认跳到最后一个阵容位置
	isDefaultLastIndex = isDefaultLastIndex or false
	init()
	require "script/ui/main/MainScene"
	
	bgLayer = MainScene.createBaseLayer("images/formation/formationbg.jpg", true, false, true)
	bgLayer:registerScriptHandler(onNodeEvent)
	formationInfo = DataCache.getSquad()

	if(formationType)then
		_curFormationType = formationType
	else
		_curFormationType = FORMATION_TYPE_EQUIP
	end

	if ( table.isEmpty (formationInfo) ) then
		RequestCenter.getSquadInfo(formationCallback)
	else

		handleFormation()
		create()
		curHeroIndex = 1
		if(isShowLittleFriend == true) then
			-- 直接切到 小伙伴界面
			curHeroIndex = open_num
			scrollToNext ( curHeroIndex, _isNeedDisplayAnimation )
			refreshTopTableviewStatus(false, true)
			refreshAll()
			moveFormationOrLittleFriendAnimated( true, false )
		else
			if(display_hid and tonumber(display_hid) > 0)then
				local isInFormation = false
				for k,i_hid in pairs(m_formationInfo) do
					if (i_hid == tonumber(display_hid)) then
						curHeroIndex = tonumber(k)
						isInFormation = true
						break
					end
				end
				if(isDefaultLastIndex == true and isInFormation==false)then
					curHeroIndex = open_num
				end
				if(curHeroIndex > 1) then
					scrollToNext ( curHeroIndex, true )
					refreshTopTableviewStatus(false)
					refreshAll()
				end
			end
		end
	end

	
	local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.3),CCCallFunc:create(function ( ... )
			if(formationLayerDidLoadCallback ~= nil) then
				for k,v in pairs(formationLayerDidLoadCallback) do
					v()
				end
			end
		end))
	bgLayer:runAction(seq)

	-- 小伙伴新位置提示
	addLittleNewPosTip()
	
	return bgLayer
end 


--add by lichenyang
function registerFormationLayerDidLoadCallback( p_callback )
	table.insert(formationLayerDidLoadCallback, p_callback)
end

function registerFormationLayerTouchHeroCallback( p_callback )
	fromationLayerTouchHeroCallback = p_callback
end

function registerSwapHeroCallback( p_callback )
	swapHeroCallback = p_callback
end

function addNewGuide(  )
	---------------------新手引导---------------------------------
    require "script/guide/NewGuide"
    if(NewGuide.guideClass ==  ksGuideFormation and FormationGuide.stepNum == 1) then
	    --add by lichenyang 2013.08.29
	    require "script/guide/FormationGuide"
	    local formationButton = getGuideTopCell()
	    local touchRect       = getSpriteScreenRect(formationButton)
	    FormationGuide.show(2, touchRect)
	end
	if(NewGuide.guideClass ==  ksGuideFormation and FormationGuide.stepNum == 4) then
	    --add by lichenyang 2013.08.29
	    require "script/guide/FormationGuide"
        local formationButton = MenuLayer.getMenuItemNode(3)
        local touchRect       = getSpriteScreenRect(formationButton)
	    FormationGuide.show(5, touchRect)
	end
    ---------------------end-------------------------------------

    ---[==[ 等级礼包第10步 
	---------------------新手引导---------------------------------
	--add by licong 2013.09.09
	require "script/guide/NewGuide"
	require "script/guide/LevelGiftBagGuide"
	if(NewGuide.guideClass ==  ksGuideFiveLevelGift and LevelGiftBagGuide.stepNum == 9) then
	    local levelGiftBagGuide_button = getGuideTopCell(2)
	    local touchRect = getSpriteScreenRect(levelGiftBagGuide_button)
	    LevelGiftBagGuide.show(10, touchRect)
	end
	---------------------end-------------------------------------
	--]==]

	---[==[ 等级礼包第13步 
	---------------------新手引导---------------------------------
	--add by licong 2013.09.09
	require "script/guide/NewGuide"
    require "script/guide/LevelGiftBagGuide"
	if(NewGuide.guideClass ==  ksGuideFiveLevelGift and LevelGiftBagGuide.stepNum == 12) then
        LevelGiftBagGuide.changLayer()
        local x = g_winSize.width * 0.5 - 120 * getScaleParm()
        local y = g_winSize.height * 0.5 - 180 * getScaleParm()
        local w = 240 * getScaleParm()
        local h = 450 * getScaleParm()
	    local touchRect = CCRectMake(x, y, w, h)
        LevelGiftBagGuide.show(13, touchRect)
    end
    ---------------------end-------------------------------------
	--]==]

	---[==[ 第4个上阵栏位开启 第四个加号
	---------------------新手引导---------------------------------
	--add by licong 2013.09.09
	require "script/ui/level_reward/LevelRewardLayer"
    require "script/guide/NewGuide"
    require "script/guide/ForthFormationGuide"
    if(NewGuide.guideClass ==  ksGuideForthFormation and ForthFormationGuide.stepNum == 1) then
        local forthFormationGuide_button = getGuideTopCell(3)
        local touchRect = getSpriteScreenRect(forthFormationGuide_button)
        ForthFormationGuide.show(2, touchRect)
    end
	---------------------end-------------------------------------
	--]==]

	---[==[铁匠铺 第2步 一键装备按钮
	---------------------新手引导---------------------------------
	require "script/guide/NewGuide"
	require "script/guide/EquipGuide"
    if(NewGuide.guideClass ==  ksGuideSmithy and EquipGuide.stepNum == 1) then
        local equipButton = getGuideObject()
        local touchRect   = getSpriteScreenRect(equipButton)
        EquipGuide.show(2, touchRect)
    end
	---------------------end-------------------------------------
	--]==]

	--[[夺宝新手引导]]
	local guideFunc = function ( ... )
        require "script/guide/RobTreasureGuide"
        if(NewGuide.guideClass ==  ksGuideRobTreasure and RobTreasureGuide.stepNum == 8) then
            RobTreasureGuide.changLayer()
            local robTreasure = getGuideObject_3()
            local touchRect   = getSpriteScreenRect(robTreasure)
            RobTreasureGuide.show(9, touchRect)
        end
    end
    local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0),CCCallFunc:create(function ( ... )
            guideFunc()
    end))
    bgLayer:runAction(seq)

    local guideFunc = function ( ... )
        require "script/guide/RobTreasureGuide"
        if(NewGuide.guideClass ==  ksGuideRobTreasure and RobTreasureGuide.stepNum == 10) then
            local robTreasure = MenuLayer.getMenuItemNode(4)
            local touchRect   = getSpriteScreenRect(robTreasure)
            RobTreasureGuide.show(11, touchRect)
        end
    end
    local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0),CCCallFunc:create(function ( ... )
            guideFunc()
    end))
    bgLayer:runAction(seq)
end

---[==[铁匠铺 第3步
---------------------新手引导---------------------------------
function addGuideEquipGuide3( ... )
	require "script/guide/NewGuide"
	require "script/guide/EquipGuide"
    if(NewGuide.guideClass ==  ksGuideSmithy and EquipGuide.stepNum == 2) then
        local equipButton = getGuideObject_2()
        local touchRect   = getSpriteScreenRect(equipButton)
        EquipGuide.show(3, touchRect)
    end
end
---------------------end-------------------------------------
--]==]


-- 有新的小伙伴位置时提示
function addLittleNewPosTip( ... )
	require "script/ui/formation/LittleFriendData"
	local isShow,b = LittleFriendData.getIsShowTipNewLittle()
	if(isShow)then
		require "script/ui/tip/AlertTip"
		local str = GetLocalizeStringBy("key_1658")
		AlertTip.showAlert(str,LittleFriendData.afterLittleTipCallFun,nil,nil,nil,nil,LittleFriendData.afterLittleTipCallFun)
	end
end

--武将(紫卡＋7)进化橙卡按钮回调 by zhangqiang
function tapDevelopBtnCb( p_tag, p_item )
	require "script/ui/develop/DevelopLayer"
	DevelopLayer.showLayer(p_tag, DevelopLayer.kOldLayerTag.kFormationTag)
end
















