-- Filename: RivalInfoLayer.lua.
-- Author: zhz
-- Date: 2013-10-22
-- Purpose: 查看对手阵容的信息的layer

module ("RivalInfoLayer", package.seeall)
require "script/audio/AudioUtil"
require "script/network/RequestCenter"
require "script/ui/hero/HeroPublicCC"
require "script/ui/hero/HeroFightSimple"
require "db/DB_Heroes"
require "script/ui/item/ItemSprite"
require "script/ui/tip/AnimationTip"
require "script/model/DataCache"
require "script/model/hero/HeroModel"
require "script/model/utils/HeroUtil"
require "script/ui/active/RivalInfoData"

local _maskLayer
local _bgLayer 						-- 灰色的layer
local _rivalInfoLayer= nil
local _topSprite					-- 顶部的sprite，显示玩家姓名
local _headBgSp						-- 显示玩家的头像
local _formationBgSprite			-- 图的背景
local _tname						-- 用户的姓名
local _vip							--用户的VIP等级

-- 上面的ui
local _rivalName					-- 玩家的姓名
local _headScrowView				-- 头像的scrowView
local _allHeroScrowView				-- 全身像的ScrowView
local _formationInfo = {}			--阵容信息
local _topHeroArr

-- Middle UI , 装备
-- 后端传得装备  武器[1，戒指2，护甲3，头盔4，项链5 锁6， 宝物：1是名马  2是名书
-- 后端传得戒指和锁不显示   

local _equiptArr={}					--装备的数组
local _equipBorderArr={}			--装备的底板
local _fightSoulNameArr
local _fightSoulBorderArr
local _fightSoulArr
local _equipNameArr={}
local _starArr ={}					--星星的数组

local _touchBeganPoint				-- 开始触摸的点
local  _isOnAnimation				-- 是否正在滑动
local _curHeroSprite				-- 当前显示的英雄的全身像
local _curHeroItem					--当前显示英雄的按钮
local _count						-- 英雄的数量
local _uid							--  英雄的uid
local _curIndex						-- 英雄的index
local _lastIndex
-- local _containerLayer				-- 
local _curCardSize=nil

-- 底部的ui
local _heroNameLabel				-- 英雄的姓名
local _evolveLevelLabel				-- 英雄的转生次数
local _levelLabel					-- 等级
local _fightForceLabel				-- 战斗力
local _lifeLabel					-- 生命
local _attLabel						-- 攻击力	
local _phyDefLabel					-- 物理防御
local _magDefLabel					-- 魔法防御
local _skillLabelArr 				-- 6个羁绊label

local _equipMenuNode
local _equipMenuOriginPosition


----------------------- below is for 小伙伴 ---------------------
local _ksTagFriend 							= 1001 			-- 点击小伙伴的头像的tag
local _littleFriendLayerOriginPosition 
local _isInLittleFriend

local  _inType 								-- 1, 正常得阵容界面，2 ，为小伙伴， 3为宠物


----------------------- below is for 宠物 -----------------------
local _ksTagPet							  = 1002
local _petLayerOriginPosition		


---
local _isNpc					-- 是否为NPc

local _menuVisible
local _avatarVisible
local _bulletinVisible



function init( )
	_maskLayer =nil
	_bgLayer = nil
	_count = 0 
	_topHeroArr= {}
	_topSprite = nil
	_titileSprite = nil
	_evolveLevelLabel= nil
	_levelLabel =nil
	_rivalInfoLayer = nil
	_headBgSp = nil 
	_formationBgSprite = nil
	_formationInfo = {}
	_curIndex = 1
	_skillLabelArr= {}
	_starArr = {}
	_equiptArr= {}
	_equipBorderArr={}
	_equipNameArr={}
	_fightSoulBorderArr= {}
	_fightSoulArr={}
	_fightSoulNameArr= {}
	_isOnAnimation= false
	_curCardSize	= CCSizeMake(6400, 620)
	_headScrowView =nil
	_allHeroScrowView = nil
	_isNpc = false

	_menuVisible= MenuLayer.getObject():isVisible()
	_avatarVisible= MainScene.getAvatarLayerObj():isVisible()
	_bulletinVisible= true

	_equipMenuNode = nil
	_equipMenuOriginPosition=nil

	_littleFriendLayerOriginPosition= nil
	_isInLittleFriend = nil

	_inType =1
	_lastIndex=1

	_petLayerOriginPosition= nil
	_vip 	= 0

end


local function createTopUI( )

	topBgSp = CCSprite:create("images/formation/topbg.png")
	topBgSp:setAnchorPoint(ccp(0.5,1))
	topBgSp:setPosition(ccp(_formationBgSprite:getContentSize().width/2, _formationBgSprite:getContentSize().height- 25))
	_formationBgSprite:addChild(topBgSp,2)

	_titileSprite = CCSprite:create("images/common/title_bg.png")
	-- _titileSprite:setScale(g_fScaleX/g_fElementScaleRatio)
	_titileSprite:setPosition(ccp(0, _formationBgSprite:getContentSize().height))
	_titileSprite:setAnchorPoint(ccp(0,1))
	_formationBgSprite:addChild(_titileSprite,2)

    local topMenuBar = CCMenu:create()
    topMenuBar:setPosition(ccp(0, 0))
    topBgSp:addChild(topMenuBar)

	--左右翻页的按钮
	require "script/ui/common/LuaMenuItem"
	--左按钮
	local leftBtn = LuaMenuItem.createItemImage("images/formation/btn_left.png",  "images/formation/btn_left.png", topMenuItemAction )
	leftBtn:setAnchorPoint(ccp(0.5, 0.5))
	leftBtn:setPosition(ccp(topBgSp:getContentSize().width*0.06, topBgSp:getContentSize().height/2))
	topMenuBar:addChild(leftBtn, 10001, 10001)
	-- 右按钮
	local rightBtn = LuaMenuItem.createItemImage("images/formation/btn_right.png",  "images/formation/btn_right.png", topMenuItemAction )
	rightBtn:setAnchorPoint(ccp(1, 0.5))
	rightBtn:setPosition(ccp(topBgSp:getContentSize().width*0.96, topBgSp:getContentSize().height/2))
	topMenuBar:addChild(rightBtn, 10002, 10002)


	-- 关闭按钮
	local menu = CCMenu:create()
	menu:setPosition(ccp(0,0))
	menu:setTouchPriority(-1000)
	_formationBgSprite:addChild(menu,4)
	local closeBtn = CCMenuItemImage:create("images/common/btn_close_n.png", "images/common/btn_close_h.png")
	closeBtn:setAnchorPoint(ccp(1,1))
	closeBtn:setPosition(ccp(_formationBgSprite:getContentSize().width*1.01, _formationBgSprite:getContentSize().height*1.01))
	closeBtn:registerScriptTapHandler(closeCb)
	menu:addChild(closeBtn)
end

-- 动画结束
function animatedEndAction( nextHeroSprite )
	_curHeroSprite:removeFromParentAndCleanup(true)
	_curHeroSprite = nextHeroSprite
	-- _isOnMoved = false
	refreshAllUI()
end

-- 滑到对应index的hero
function swicthIndexHero( index )
	--_curHeroItem:selected()
	hanleSelected(_curHeroItem)
	-- if(index == _curIndex) then
	-- 	return
	-- end
	local nextHeroSprite= getHeroSopriteByInfo(_formationInfo[index])
	_formationBgSprite:addChild(nextHeroSprite)

	local curMoveToP = nil
	local nextMoveToP = ccp(_formationBgSprite:getContentSize().width*0.5,200)
	local curPositionX = _curHeroSprite:getPositionX()
	if(_curIndex<index) then
		curMoveToP= ccp(curPositionX -_formationBgSprite:getContentSize().width,200)
		nextHeroSprite:setPosition(curPositionX+_formationBgSprite:getContentSize().width, 200)
	else
		curMoveToP=ccp(curPositionX+ _formationBgSprite:getContentSize().width,200)
		nextHeroSprite:setPosition(ccp(curPositionX-_formationBgSprite:getContentSize().width, 200))
	end
	nextHeroSprite:setAnchorPoint(ccp(0.5,0))
	-- 移动
	local args = CCArray:create()
	args:addObject(CCMoveTo:create(0.2,curMoveToP))
	_curHeroSprite:runAction(CCSequence:create(args))
	local actionArr = CCArray:create()
	actionArr:addObject(CCMoveTo:create(0.2, nextMoveToP))
	actionArr:addObject(CCCallFuncN:create(animatedEndAction))
	_curIndex= index
	RivalInfoData.setCurIndex(_curIndex)

	nextHeroSprite:runAction(CCSequence:create(actionArr))

	refreshStarBg()

	-- local animationDuration = 0.1
	-- _equipMenuNode:runAction(CCMoveTo:create(animationDuration, ccp(_equipMenuOriginPosition.x, _equipMenuOriginPosition.y)))
	-- _fightSoulMenuBar:runAction(CCMoveTo:create(animationDuration, ccp(_equipMenuOriginPosition.x, _equipMenuOriginPosition.y)))
	-- _bottomBg:setPosition(ccp(0, 0))
	-- _bottomBg:setAnchorPoint(ccp(0,0))
	

end

function endAction( nextHeroSprite )

	_curHeroSprite:removeFromParentAndCleanup(true)
	_curHeroSprite= nextHeroSprite
	refreshAllUI()
	refreshTopUI()
	_isOnAnimation= false

end

-- 换到下一个hero
function switchNextHero( xOffset )

	-- print("  in function switchNextHero and ,xOffset is ", xOffset)

	local nextIndex = 0
	if(xOffset < 0) then
		if(_curIndex<table.count(_formationInfo)) then
			nextIndex = _curIndex+1
		end
	else
		if(_curIndex>1) then
			nextIndex= _curIndex-1
		end
	end

	local nextMoveTop = ccp(_formationBgSprite:getContentSize().width*0.5,200)
	local curPositionX = _curHeroSprite:getPositionX()
	local curMoveTop= nil
	if(nextIndex>0 and nextIndex<=table.count(_formationInfo)) then
		local nextHeroSprite= getHeroSopriteByInfo(_formationInfo[nextIndex])
		_formationBgSprite:addChild(nextHeroSprite)
		if(xOffset>0) then
			curMoveTop= ccp(curPositionX+_formationBgSprite:getContentSize().width,200)
			nextHeroSprite:setPosition(curPositionX- _formationBgSprite:getContentSize().width,200)
		else
			curMoveTop= ccp(curPositionX - _formationBgSprite:getContentSize().width,200)
			nextHeroSprite:setPosition(curPositionX+_formationBgSprite:getContentSize().width,200)
		end
		_isOnAnimation = true
		nextHeroSprite:setAnchorPoint(ccp(0.5,0))
		_curHeroSprite:runAction(CCMoveTo:create(0.2,curMoveTop))
		-- print("curPositionX  is : ", _curHeroSprite:getContentSize().width)
		local args= CCArray:create()
		args:addObject(CCMoveTo:create(0.2,nextMoveTop))
		args:addObject(CCCallFuncN:create(endAction))	
		nextHeroSprite:runAction(CCSequence:create(args))

		handleUnseletced(_curHeroItem)
		_curIndex = nextIndex
		RivalInfoData.setCurIndex( _curIndex)
		-- 
		_lastIndex = _curIndex


		_curHeroItem= _topHeroArr[_curIndex]
		hanleSelected(_curHeroItem)
	else
		-- 
		runBack()
	end
end


-- 刷新顶部的ui，
function refreshTopUI(  )
	--计算顶部的offset
	local topTableViewOffset= _headScrowView:getContentOffset()
	local cellSize = CCSizeMake(105, 100)
	local curStartPositon = (1-_curIndex) * cellSize.width
	local curEndPosition = (-_curIndex) * cellSize.width
	if(curStartPositon > topTableViewOffset.x) then
		_headScrowView:setContentOffsetInDuration(ccp( curStartPositon , 0), 0.2)
	elseif (curEndPosition < topTableViewOffset.x - 4 * cellSize.width ) then
		_headScrowView:setContentOffsetInDuration(ccp( - ( _curIndex - 4 )*cellSize.width , 0), 0.2)
	end

	print("_curIndex is ", _curIndex)
	handleUnseletced(_curHeroItem)
	_curHeroItem= _topHeroArr[_curIndex]
	hanleSelected(_curHeroItem)
end


-- 处理点击headSorite 的回调函数
local function headItemCallBack( tag,item )

	print("_isOnAnimation is ", _isOnAnimation )

	if(_isOnAnimation == true) then
		return
	end

	handleUnseletced(_curHeroItem)
	_curHeroItem = item
	hanleSelected(_curHeroItem)


	-- if(_isInLittleFriend == true)then
	-- 	moveFormationOrLittleFriendAnimated(false, true)
	-- end
	-- if(_isInPet == true) then
	-- 	moveFriendOrPetAnimated(false, true)
	-- end
	if(_curIndex == tag) then
		return
	end


	-- 
	if(tag== _ksTagFriend) then
		moveFormationOrLittleFriendAnimated( true, true)

	elseif(tag== _ksTagPet ) then
		moveFriendOrPetAnimated(true,true)
	else
		
		

		-- if(_isInLittleFriend == true)then
		-- 	moveFormationOrLittleFriendAnimated(false, true)
		-- end
		-- if(_isInPet == true) then
		-- 	moveToPetAnimatedByType(3)
		-- end

		if(_inType == 2) then
			moveFormationOrLittleFriendAnimated(false, true)
		elseif(_inType ==3) then
			moveToPetAnimatedByType(3)
		end
		_lastIndex = tag
		swicthIndexHero(tonumber(tag))
	end

	refreshTopUI()
	print(" _curIndex is : ", _curIndex, " Intype is ", _inType, " _lastIndex is ",_lastIndex)

	
end




-- 通过武将的信息获得英雄的全身像
function getHeroSopriteByInfo( formationInfo )
	local iconName= nil
	local dressId= nil
	if(not table.isEmpty( formationInfo.equipInfo.dress) and not table.isEmpty(formationInfo.equipInfo.dress["1"]))then
		dressId = tonumber(formationInfo.equipInfo.dress["1"].item_template_id)
	end	

	local heroSprite = HeroUtil.getHeroBodySpriteByHTID(tonumber(formationInfo.htid),dressId )
	return heroSprite
	
end

function getHeroHeadIcon( formationInfo )
	local htid= nil
	local dressId = nil
	-- print_t(formationInfo)
	if(not table.isEmpty( formationInfo.equipInfo.dress) and not table.isEmpty(formationInfo.equipInfo.dress["1"]))then
		dressId = tonumber(formationInfo.equipInfo.dress["1"].item_template_id)
	end	
	local headIcon =  HeroUtil.getHeroIconByHTID(tonumber(formationInfo.htid),dressId ,nil , _vip)
	local headItem= CCMenuItemSprite:create(headIcon, headIcon)

	return headItem
end

function getHeroInfoByFormation(formationInfo )
	local heroLocalInfo = nil
	if(not table.isEmpty( formationInfo.equipInfo.dress) and not table.isEmpty(formationInfo.equipInfo.dress["1"]))then
		local dressInfo = ItemUtil.getItemById(tonumber(formationInfo.equipInfo.dress["1"].item_template_id))
		heroLocalInfo = DB_Heroes.getDataById(getStringByFashionString(dressInfo.changeModel, formationInfo.htid))
	else
		heroLocalInfo = DB_Heroes.getDataById(tonumber(formationInfo.htid))		
	end	

	return heroLocalInfo
end

-- 创建初始化的图片
function createHeroSprite(  )
	local heroSprite = getHeroSopriteByInfo(_formationInfo[1] )
	heroSprite:setPosition(ccp(_formationBgSprite:getContentSize().width/2,200))
	heroSprite:setAnchorPoint(ccp(0.5,0))
	_formationBgSprite:addChild(heroSprite)
	_curHeroSprite = heroSprite
	_index = 1
end


--处理selected函数的方法
function hanleSelected(Item)
	Item:selected()
	Item:getChildByTag(33):setVisible(true)
	--Item:addChild(csFrame,-1,33)
end

-- 处理unseletded
function handleUnseletced(preSeletced )
	preSeletced:unselected()
	preSeletced:getChildByTag(33):setVisible(false)
end


-- 创建头像ui
local function createHeadUI( )

	local width ,height = 125*(#_formationInfo),145

	if(RivalInfoData.hasFriend() ) then
		width = width+ 125
	end
	if( RivalInfoData.hasPet() ) then
		width = width+125
	end

	local index= #_formationInfo 

	_headScrowView = CCScrollView:create()
	_headScrowView:setTouchPriority(-1005)

    _headScrowView:setContentSize(CCSizeMake(width , height))
    _headScrowView:setViewSize(CCSizeMake(505,height))
    _headScrowView:setPosition(66,620)
    _headScrowView:setDirection(kCCScrollViewDirectionHorizontal)
    _headScrowView:setContentOffset(ccp(0,0))
    _formationBgSprite:addChild(_headScrowView,10,2000)

    local headMenu = CCMenu:create()
    headMenu:setPosition(ccp(0,0))
    headMenu:setTouchPriority(-1003)
    -- headMenu:setScrollView(_headScrowView)
    _headScrowView:addChild(headMenu,-1)

    print("RivalInfoData.hasFriend() is ", RivalInfoData.hasFriend() , " RivalInfoData.hasPet()", RivalInfoData.hasPet() )

    for i =1, #_formationInfo do 
		local menuItem = getHeroHeadIcon(_formationInfo[i]) --HeroPublicCC.getCMISHeadIconByHtid(_formationInfo[i].htid)
		headMenu:addChild(menuItem,1,i)
		menuItem:setAnchorPoint(ccp(0,0.5))
		menuItem:setPosition(ccp(120*(i-1) , _headScrowView:getContentSize().height/2))
		menuItem:registerScriptTapHandler(headItemCallBack)

		local sQualityLightedImg="images/hero/quality/highlighted.png"
		local csFrame = CCSprite:create(sQualityLightedImg)
		csFrame:setAnchorPoint(ccp(0.5, 0.5))
		csFrame:setPosition(menuItem:getContentSize().width/2, menuItem:getContentSize().height/2)
		menuItem:addChild(csFrame,0,33)
		csFrame:setVisible(false)
		table.insert(_topHeroArr,menuItem)
		if(i == 1)  then 
			-- menuItem:selected()
			hanleSelected(menuItem)
			_curHeroItem = menuItem
		end
	end

	if(RivalInfoData.hasFriend() == true) then

		local menuItem= RivalInfoData.getFriendItem()
		headMenu:addChild(menuItem,1,_ksTagFriend)
		menuItem:setAnchorPoint(ccp(0,0.5))
		menuItem:setPosition(ccp(120*( index) , _headScrowView:getContentSize().height/2))
		menuItem:registerScriptTapHandler(headItemCallBack)

		local sQualityLightedImg="images/hero/quality/highlighted.png"
		local csFrame = CCSprite:create(sQualityLightedImg)
		csFrame:setAnchorPoint(ccp(0.5, 0.5))
		csFrame:setPosition(menuItem:getContentSize().width/2, menuItem:getContentSize().height/2)
		menuItem:addChild(csFrame,0,33)
		csFrame:setVisible(false)
		table.insert(_topHeroArr,menuItem)
		index= index+1
	end

	if(RivalInfoData.hasPet() == true) then
		
		local menuItem= RivalInfoData.getPetItem()
		headMenu:addChild(menuItem,1,_ksTagPet)
		menuItem:setAnchorPoint(ccp(0,0.5))
		menuItem:setPosition(ccp(120*( index) , _headScrowView:getContentSize().height/2))
		menuItem:registerScriptTapHandler(headItemCallBack)

		local sQualityLightedImg="images/hero/quality/highlighted.png"
		local csFrame = CCSprite:create(sQualityLightedImg)
		csFrame:setAnchorPoint(ccp(0.5, 0.5))
		csFrame:setPosition(menuItem:getContentSize().width/2, menuItem:getContentSize().height/2)
		menuItem:addChild(csFrame,0,33)
		csFrame:setVisible(false)
		table.insert(_topHeroArr,menuItem)
	end

	createHeroSprite()
end

-- 刷新中部的UI 包括
function refreshMiddleUI(  )
	--首先刷新名字和转生次数
	local curHeroData = DB_Heroes.getDataById(_formationInfo[_curIndex].htid)
	-- if(tonumber(curHeroData.id) == 20001 or tonumber(curHeroData.id)== 20002) then
	if(HeroModel.isNecessaryHero(curHeroData.id)) then
		_heroNameLabel:setString(_tname)
	else
		_heroNameLabel:setString(curHeroData.name)
	end
	local nameColor = HeroPublicLua.getCCColorByStarLevel(curHeroData.star_lv)
	_heroNameLabel:setColor(nameColor)

	local evolveStr = nil
	if curHeroData.star_lv == 6 then
		evolveStr = GetLocalizeStringBy("zz_99",  _formationInfo[_curIndex].evolve_level)
	else
		evolveStr = "+" .. _formationInfo[_curIndex].evolve_level
	end
	_evolveLevelLabel:setString(evolveStr)
	local width = _heroNameLabel:getPositionX()+_heroNameLabel:getContentSize().width

	local centerX = _heroNameBg:getContentSize().width*0.5
	local t_length = _heroNameLabel:getContentSize().width + _evolveLevelLabel:getContentSize().width + 5
	local s_x = centerX - t_length*0.5

	_heroNameLabel:setPosition(ccp(s_x, _heroNameBg:getContentSize().height*0.5))
	_evolveLevelLabel:setPosition(ccp(s_x+_heroNameLabel:getContentSize().width + 5, _heroNameBg:getContentSize().height*0.55))

	-- -- 刷新小星星
	--将偶数星时的星星居中，positionChanged by zhang zihang
	local starsXPositions = {0.5, 0.4, 0.6, 0.3, 0.7, 0.2, 0.8}
	local starsYPositions = {0.75, 0.74, 0.74, 0.71, 0.71, 0.68, 0.68}
	local starsXPositionsDouble = {0.45,0.55,0.35,0.65,0.25,0.75,0.8}
    local starsYPositionsDouble = {0.745,0.745,0.72,0.72,0.7,0.7,0.68}

	for k, h_starsp in pairs(_starArr) do
		if ((curHeroData.star_lv%2) ~= 0) then
			h_starsp:setPosition(ccp(starsBgSp:getContentSize().width * starsXPositions[k], starsBgSp:getContentSize().height * starsYPositions[k]))
			if(k<= curHeroData.star_lv) then
				h_starsp:setVisible(true)
			else
				h_starsp:setVisible(false)
			end
		else
			h_starsp:setPosition(ccp(starsBgSp:getContentSize().width * starsXPositionsDouble[k], starsBgSp:getContentSize().height * starsYPositionsDouble[k]))
			if(k<= curHeroData.star_lv) then
				h_starsp:setVisible(true)
			else
				h_starsp:setVisible(false)
			end
		end
	end

	-- 刷新装备
	for k=1, 6 do
		if(_equiptArr[k]~= nil) then
			_equiptArr[k]:removeFromParentAndCleanup(true)
			_equiptArr[k]= nil
			_equipNameArr[k]:setString("")
		end
	end

	-- local armTable = _formationInfo[_curIndex].equipInfo.arming
	-- local treasTable = _formationInfo[_curIndex].equipInfo.treasure
	for k ,armTable in pairs(_formationInfo[_curIndex].equipInfo.arming) do
		-- 加上k~= 2 的限制是除去戒指
		if(not table.isEmpty(armTable) and tonumber(armTable.item_template_id)>0 ) then
			k=  tonumber(k) 
			k=  changeEquiptPos(k)
			
			local itemSprite= RivalInfoData.getItemSprite(armTable) --ItemSprite.getItemSpriteById(armTable.item_template_id,nil,nil, nil,-1011,19001)
			_equiptArr[k]= itemSprite
			_equiptArr[k]:setPosition(ccp(_equipBorderArr[k]:getContentSize().width/2,_equipBorderArr[k]:getContentSize().height/2))
			_equiptArr[k]:setAnchorPoint(ccp(0.5,0.5))
			_equipBorderArr[k]:addChild(_equiptArr[k])

			--装备名称
			local equipDesc = ItemUtil.getItemById(tonumber(armTable.item_template_id))
			local nameColor = HeroPublicLua.getCCColorByStarLevel(equipDesc.quality)
			_equipNameArr[k]:setString(equipDesc.name)
			_equipNameArr[k]:setColor(nameColor)	
		end
	end

	-- 宝物
	for k,treasure in pairs(_formationInfo[_curIndex].equipInfo.treasure) do
		if(not table.isEmpty(treasure) and tonumber(treasure.item_template_id)>0 ) then
			k=  tonumber(k)
			k= changeTreasurePos(k) 

			local itemSprite= RivalInfoData.getTreasureItem(treasure) --ItemSprite.getItemSpriteById(armTable.item_template_id,nil,nil, nil,-1011,19001)
			_equiptArr[k]= itemSprite
			_equiptArr[k]:setPosition(ccp(_equipBorderArr[k]:getContentSize().width/2,_equipBorderArr[k]:getContentSize().height/2))
			_equiptArr[k]:setAnchorPoint(ccp(0.5,0.5))
			_equipBorderArr[k]:addChild(_equiptArr[k])
		end
	end

	-- 
end



-- 涮新战魂的UI
function refreshFightSoulUI( )

	-- 刷新装备
	for k=1, 8 do
		if(_fightSoulArr[k]~= nil) then
			_fightSoulArr[k]:removeFromParentAndCleanup(true)
			_fightSoulArr[k]= nil
		end
	end

	for k=1,8 do
		local fightSoul= _formationInfo[_curIndex].equipInfo.fightSoul
		if( not table.isEmpty(fightSoul) and not table.isEmpty(fightSoul[""..k])) then
			
			_fightSoulArr[k] = RivalInfoData.getFightSoulItem(fightSoul[""..k]) 
			_fightSoulArr[k]:setPosition(ccp(_fightSoulBorderArr[k]:getContentSize().width/2,_fightSoulBorderArr[k]:getContentSize().height/2))
			_fightSoulArr[k]:setAnchorPoint(ccp(0.5,0.5))
			_fightSoulBorderArr[k]:addChild(_fightSoulArr[k])
		else
			local isOpen , openLv= isFightSoulOpenByPos(k)
			if(isOpen== false) then
				_fightSoulArr[k] = CCSprite:create("images/formation/potential/newlock.png")
				_fightSoulArr[k]:setPosition(ccp(_fightSoulBorderArr[k]:getContentSize().width/2,_fightSoulBorderArr[k]:getContentSize().height/2))
				_fightSoulArr[k]:setAnchorPoint(ccp(0.5,0.5))
				_fightSoulBorderArr[k]:addChild(_fightSoulArr[k])
				if( tonumber(k) <=6 )then
				
					local tipLabel = CCRenderLabel:create( openLv, g_sFontPangWa, 25, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
				    tipLabel:setAnchorPoint(ccp(0.5, 0.5))
				    tipLabel:setColor(ccc3(0xff, 0xff, 0xff))
				    tipLabel:setPosition(ccp( _fightSoulBorderArr[k]:getContentSize().width* 0.5, _fightSoulBorderArr[k]:getContentSize().height*0.7))
				    _fightSoulBorderArr[k]:addChild(tipLabel)

				    local openLvSp = CCSprite:create("images/formation/potential/jikaifang.png")
					openLvSp:setAnchorPoint(ccp(0.5, 0.5))
					openLvSp:setPosition(ccp(_fightSoulBorderArr[k]:getContentSize().width*0.5, _fightSoulBorderArr[k]:getContentSize().height*0.4))
					_fightSoulBorderArr[k]:addChild(openLvSp)
				else
					local tipLabel = CCRenderLabel:create(GetLocalizeStringBy("key_3325"), g_sFontPangWa, 25, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
				    tipLabel:setAnchorPoint(ccp(0.5, 0.5))
				    tipLabel:setColor(ccc3(0xff, 0xff, 0xff))
				    tipLabel:setPosition(ccp( _fightSoulBorderArr[k]:getContentSize().width* 0.5, _fightSoulBorderArr[k]:getContentSize().height*0.5))
				    _fightSoulBorderArr[k]:addChild(tipLabel)
				end
			end


		end	
	end

	-- for k,fightSoul in pairs(_formationInfo[_curIndex].equipInfo.fightSoul) do
	-- 	if(not table.isEmpty(fightSoul) and tonumber(fightSoul.item_template_id)>0 ) then
	-- 		k= tonumber(k)
	-- 		_fightSoulArr[k] = getFightSoulItem(fightSoul) 
	-- 		_fightSoulArr[k]:setPosition(ccp(_fightSoulBorderArr[k]:getContentSize().width/2,_fightSoulBorderArr[k]:getContentSize().height/2))
	-- 		_fightSoulArr[k]:setAnchorPoint(ccp(0.5,0.5))
	-- 		_fightSoulBorderArr[k]:addChild(_fightSoulArr[k])
	-- 	end
	-- end

end


-- 战魂格子是否开启
function isFightSoulOpenByPos( posIndex )
	require "db/DB_Normal_config"
	local dbInfo = DB_Normal_config.getDataById(1)
	posIndex = tonumber(posIndex)
	local openLvArr = string.split(dbInfo.fightSoulOpenLevel, ",")
	local isOpen = false
	local openLv = tonumber(openLvArr[posIndex])
	local userLv= tonumber(_formationInfo[1].level)
	if( userLv >= openLv )then
		isOpen = true
	else
		isOpen = false
	end

	return isOpen, openLv
end

-- 后端传得装备  武器1，护甲2，头盔3，项链4 ， 宝物：1是名马  2是名书
-- 后端传得戒指和锁不显示   
-- 显示的顺寻： 武器-头盔-衣服-项链 -马-书
function changeEquiptPos( k )
	if(k==1 ) then
		return 1
	elseif(k==2) then
		return 3
	elseif(k==3) then
		return 2
	elseif(k==4) then
		return 4
	-- elseif(k==5) then
	-- 	return 4
	-- elseif(k==6) then
	-- 	return 0
	end
end

function changeTreasurePos(k)
	if(k== 1) then
		return 5
	elseif(k==2) then
		return 6
	end
end
function itemDelegateAction(  )
	MainScene.setMainSceneViewsVisible(_menuVisible, _avatarVisible, _bulletinVisible)
end


-- 创建中间的ui，装备和头像
local function createMiddleUI( )

	-- 星星底
	starsBgSp = CCSprite:create("images/formation/stars_bg.png")
	starsBgSp:setAnchorPoint(ccp(0.5, 1))
	starsBgSp:setPosition(ccp(_formationBgSprite:getContentSize().width/2, _formationBgSprite:getContentSize().height*0.77))
	_formationBgSprite:addChild(starsBgSp, 11)

	-- 星星
	local starsXPositions = {0.5, 0.4, 0.6, 0.3, 0.7, 0.2, 0.8}
	local starsYPositions = {0.75, 0.74, 0.74, 0.71, 0.71, 0.68, 0.68}
	for k,v in pairs (starsXPositions) do
		local starSp= CCSprite:create("images/formation/star.png")
		starSp:setAnchorPoint(ccp(0.5,0.5))
		starSp:setPosition(ccp(starsBgSp:getContentSize().width * v, starsBgSp:getContentSize().height * starsYPositions[k]))
		starsBgSp:addChild(starSp)
		table.insert(_starArr, starSp)
	end

	_equipMenuNode = CCNode:create()
	_equipMenuOriginPosition = ccp(0, 0)
	_equipMenuNode:setPosition(_equipMenuOriginPosition)
	_formationBgSprite:addChild(_equipMenuNode,3)

	-- 后端传得装备  武器1，戒指2，护甲3，头盔4，项链5 锁6， 宝物：1是名马  2是名书
	-- 后端传得戒指和锁不显示   
	-- 显示的顺寻： 武器-头盔-衣服-项链 -马-书
	local btnXPositions = {489, 45, 489, 45,  480,35}
	local btnYPositions = {495, 495, 364, 364,210,210}
	local emptyEquipIcons = {
								"images/formation/emptyequip/weapon.png", 		"images/formation/emptyequip/helmet.png",	
								"images/formation/emptyequip/armor.png",		"images/formation/emptyequip/necklace.png",
								"images/formation/emptyequip/horse.png",		"images/formation/emptyequip/book.png",
							}
	for i=1,6 do
		local equipborderSp
		if( i==5 or i==6 ) then
			equipBorderSp = CCSprite:create("images/common/t_equipborder.png")
		else
			equipBorderSp = CCSprite:create("images/common/equipborder.png")
		end
		
		equipBorderSp:setPosition(ccp(btnXPositions[i],btnYPositions[i]))
		-- equipBorderSp:setVisible(false)
		_equipMenuNode:addChild(equipBorderSp,12)
		table.insert(_equipBorderArr,equipBorderSp)
		local tempSprite= CCSprite:create(emptyEquipIcons[i])
		tempSprite:setAnchorPoint(ccp(0.5,0.5))
		tempSprite:setPosition(ccp(equipBorderSp:getContentSize().width/2, equipBorderSp:getContentSize().height/2))
		equipBorderSp:addChild(tempSprite)
		local e_nameLabel =  CCRenderLabel:create("" , g_sFontName, 20, 2, ccc3( 0x00, 0x00, 0x00), type_stroke)
	    e_nameLabel:setPosition(ccp(equipBorderSp:getContentSize().width/2, -1))
	    e_nameLabel:setAnchorPoint(ccp(0.5,1))
	    equipBorderSp:addChild(e_nameLabel)
	    table.insert(_equipNameArr,e_nameLabel)
	end

	createFightSoulUI()
	setFightSoulVisible(false)

	local menuBar= CCMenu:create()
	menuBar:setPosition(ccp(0,0))
	menuBar:setTouchPriority(-1001)
	_bottomBg:addChild(menuBar)

	-- 切换装备阵容按钮
	_f_equipBtn = CCMenuItemImage:create("images/common/btn/btn_equip_n.png", "images/common/btn/btn_equip_h.png")
	_f_equipBtn:setAnchorPoint(ccp(0.5, 0))
	_f_equipBtn:setPosition(ccp(_formationBgSprite:getContentSize().width*0.5,123 ))
	_f_equipBtn:registerScriptTapHandler(EquiptTOSoulAction)
	_f_equipBtn:setVisible(false)
	menuBar:addChild(_f_equipBtn,1, 101)
	
	-- 切换战魂阵容界面
	_f_fightSoulBtn = CCMenuItemImage:create("images/common/btn/btn_fightSoul_n.png", "images/common/btn/btn_fightSoul_h.png")
	_f_fightSoulBtn:setAnchorPoint(ccp(0.5, 0))
	_f_fightSoulBtn:setVisible(true)
	_f_fightSoulBtn:setPosition(_formationBgSprite:getContentSize().width*0.5,130)
	_f_fightSoulBtn:registerScriptTapHandler(EquiptTOSoulAction)
	menuBar:addChild(_f_fightSoulBtn,1,102)

	createBottomFrame()
	--refreshStarBg()
end

-- 刷新 -- 星星底 和底部的frame
function refreshStarBg()
	if(_curIndex<= #_formationInfo ) then
		
		starsBgSp:setVisible(true)
	else
		starsBgSp:setVisible(false)
	end

	if( _inType ==1) then
		_bottomFrame:setVisible(false)
	else
		_bottomFrame:setVisible(true)
	end
end


-- 设置装备按钮可见
function setEquiptVisible( visible )
	for i=1, #_equipBorderArr do
		_equipBorderArr[i]:setVisible(visible)
		_equipNameArr[i]:setVisible(visible)
	end
end

-- 创建底框的UI
function createBottomFrame( ... )

	_bottomFrame= CCSprite:create("images/main/base_bottom_border.png")
	_bottomFrame:setAnchorPoint(ccp(0.5,0))
	_bottomFrame:setPosition(_formationBgSprite:getContentSize().width/2,-2)
	_formationBgSprite:addChild(_bottomFrame,11)

end

--
function createFightSoulUI( )
		-- 顺序 
	-- local fightSoul= _formationInfo[_curIndex].equipInfo.fightSoul
	local btnXPositions = {0.15, 0.85, 0.15, 0.85, 0.15, 0.85, 0.15, 0.85}
	local btnYPositions = {530, 530, 420, 420,310 ,310, 200,200}

	
	_fightSoulMenuBar = CCNode:create()
	_equipMenuOriginPosition = ccp(0, 0)
	_fightSoulMenuBar:setPosition(_equipMenuOriginPosition)
	_formationBgSprite:addChild(_fightSoulMenuBar,3)

	for i, xScale in pairs(btnXPositions) do
		local equipBorderSp= CCSprite:create("images/common/f_bg.png")
		equipBorderSp:setPosition(ccp(btnXPositions[i]*_formationBgSprite:getContentSize().width,btnYPositions[i]))
		equipBorderSp:setAnchorPoint(ccp(0.5,0))
		-- _formationBgSprite:addChild(equipBorderSp,12)
		table.insert(_fightSoulBorderArr ,equipBorderSp)
		_fightSoulMenuBar:addChild( equipBorderSp)
	end

end

-- 设置战魂是否可见
function setFightSoulVisible( visible)
	for i=1, #_fightSoulBorderArr do
		_fightSoulBorderArr[i]:setVisible(visible)
	end
end

function EquiptTOSoulAction( tag, item)
	if(tag == 101) then
		_f_equipBtn:setVisible(false)
		_f_fightSoulBtn:setVisible(true)
		setFightSoulVisible(false)
		setEquiptVisible(true)
	elseif(tag== 102) then
		_f_equipBtn:setVisible(true)
		_f_fightSoulBtn:setVisible(false)
		setFightSoulVisible(true)
		setEquiptVisible(false)
	end
end

-- 创建 hero 的姓名， 战斗力，生命 等ui
local function createPropertyUI(  )

	_bottomBg = CCSprite:create("images/formation/bottombg.png")
	_bottomBg:setPosition(_formationBgSprite:getContentSize().width/2, 0)
	_bottomBg:setAnchorPoint(ccp(0.5,0))
	_formationBgSprite:addChild(_bottomBg,2)

	-- 英雄的名字
	_heroNameBg = CCScale9Sprite:create("images/common/bg/bg_9s_2.png")
	_heroNameBg:setContentSize(CCSizeMake(240, 36))
	_heroNameBg:setAnchorPoint(ccp(0.5,0))
	_heroNameBg:setPosition(ccp(_bottomBg:getContentSize().width*0.5, 197))
	_bottomBg:addChild(_heroNameBg,2)
	--_heroNameLabel= CCRenderLabel:
	_heroNameLabel = CCRenderLabel:create(GetLocalizeStringBy("key_1167"), g_sFontPangWa, 25, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	-- _heroNameLabel:setColor(nameColor)
	_heroNameLabel:setAnchorPoint(ccp(0, 0.5))
	_heroNameBg:addChild(_heroNameLabel,11)
	-- 转生次数
	_evolveLevelLabel= CCRenderLabel:create("+" , g_sFontPangWa, 25, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	_evolveLevelLabel:setAnchorPoint(ccp(0, 0.5))
	_evolveLevelLabel:setColor(ccc3(0x00, 0xff, 0x18))
	_heroNameBg:addChild(_evolveLevelLabel,11)

	local centerX = _heroNameBg:getContentSize().width*0.5
	local t_length = _heroNameLabel:getContentSize().width + _evolveLevelLabel:getContentSize().width + 5
	local s_x = centerX - t_length*0.5
	_heroNameLabel:setPosition(ccp(s_x, _heroNameBg:getContentSize().height*0.55))
	_evolveLevelLabel:setPosition(ccp(s_x+_heroNameLabel:getContentSize().width + 5, _heroNameBg:getContentSize().height*0.55))

	-- 战斗力
	_fightForceLabel = CCRenderLabel:create("123123" , g_sFontName, 25, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	_fightForceLabel:setPosition(ccp(450,89))
	_fightForceLabel:setAnchorPoint(ccp(0,0))
	_fightForceLabel:setColor(ccc3(0xff, 0xf6, 0x00))
	_bottomBg:addChild(_fightForceLabel,5)

	-- 生命
	local lifeTitleLabel= CCLabelTTF:create(GetLocalizeStringBy("key_1754"), g_sFontName, 23)
	lifeTitleLabel:setPosition(ccp(351,51))
	lifeTitleLabel:setColor(ccc3(0x78, 0x25, 0x00))
	_bottomBg:addChild(lifeTitleLabel,5)

	_lifeLabel = CCLabelTTF:create("2344", g_sFontName, 23)
	_lifeLabel:setColor(ccc3(0x00, 0x00, 0x00))
	_lifeLabel:setPosition(ccp(409,51))
	_bottomBg:addChild(_lifeLabel,5)

	-- 攻击
	local attTitleLabel= CCLabelTTF:create(GetLocalizeStringBy("key_2966"), g_sFontName, 23)
	attTitleLabel:setPosition(ccp(483,55))
	attTitleLabel:setColor(ccc3(0x78, 0x25, 0x00))
	_bottomBg:addChild(attTitleLabel)

	_attLabel = CCLabelTTF:create("2344", g_sFontName, 23)
	_attLabel:setColor(ccc3(0x00, 0x00, 0x00))
	_attLabel:setPosition(ccp(545,55))
	_bottomBg:addChild(_attLabel,5)

	-- 物防
	local phyDefTitleLabel= CCLabelTTF:create(GetLocalizeStringBy("key_1567"), g_sFontName, 23)
	phyDefTitleLabel:setPosition(ccp(351,25))
	phyDefTitleLabel:setColor(ccc3(0x78, 0x25, 0x00))
	_bottomBg:addChild(phyDefTitleLabel,5)

	 _phyDefLabel = CCLabelTTF:create("2344", g_sFontName, 23)
	_phyDefLabel:setColor(ccc3(0x00, 0x00, 0x00))
	_phyDefLabel:setPosition(ccp(409,25))
	_bottomBg:addChild(_phyDefLabel,5)

	-- -- 法防
	local magDefTitleLabel= CCLabelTTF:create(GetLocalizeStringBy("key_3147"), g_sFontName, 23)
	magDefTitleLabel:setPosition(ccp(483,25))
	magDefTitleLabel:setColor(ccc3(0x78, 0x25, 0x00))
	_bottomBg:addChild(magDefTitleLabel,5)

	 _magDefLabel = CCLabelTTF:create("2344", g_sFontName, 23)
	_magDefLabel:setColor(ccc3(0x00, 0x00, 0x00))
	_magDefLabel:setPosition(ccp(545,25))
	_bottomBg:addChild(_magDefLabel,5)

	-- 显示战斗力
	_userFightLineSp= CCSprite:create("images/common/line2.png")
	_userFightLineSp:setPosition(394,130)
	_bottomBg:addChild(_userFightLineSp)

	local fightForceSp =CCSprite:create("images/common/fight_value.png")
	fightForceSp:setPosition(3,_userFightLineSp:getContentSize().height/2 )
	fightForceSp:setAnchorPoint(ccp(0,0.5))
	_userFightLineSp:addChild(fightForceSp )

	_userFightValue=CCRenderLabel:create("", g_sFontPangWa, 23, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	_userFightValue:setColor(ccc3(0xff, 0xf6, 0x00))
	_userFightValue:setPosition( fightForceSp:getContentSize().width+6,_userFightLineSp:getContentSize().height/2)
	_userFightValue:setAnchorPoint(ccp(0,0.5))
	_userFightLineSp:addChild(_userFightValue)


end

-- 羁绊ui,和等级ui
local function createUnionUI(  )
	
	local jipanBg = CCSprite:create("images/common/line2.png")
    jipanBg:setAnchorPoint(ccp(0.5,0.5))
    jipanBg:setPosition(ccp(165,101 ))
    _bottomBg:addChild(jipanBg)

    local jipanSp = CCSprite:create("images/formation/text.png")
    jipanSp:setAnchorPoint(ccp(0.5,0.5))
    jipanSp:setPosition(ccp(jipanBg:getContentSize().width * 0.5, jipanBg:getContentSize().height*0.5))
    jipanBg:addChild(jipanSp)

    -- 等级及等级上限
	_LevelLabel = CCRenderLabel:create("20/20", g_sFontPangWa, 23, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	_LevelLabel:setColor(ccc3(0xff, 0xf6, 0x00))
	_LevelLabel:setAnchorPoint(ccp(0, 0))
	_LevelLabel:setPosition(ccp(90,154 ))
	_bottomBg:addChild(_LevelLabel)	

    -- 六个羁绊
    local x_scale = { 70, 175, 278, 70, 175, 278}
    local y_scale = { 52, 52, 52 ,24 ,24, 24}
    for i=1,6 do
    	local tempLabel = CCLabelTTF:create("", g_sFontName, 23)
		--tempLabel:setColor(ccc3(0x78, 0x25, 0x00))
		tempLabel:setColor(ccc3(155,155,155))
		tempLabel:setAnchorPoint(ccp(0.5, 0))
		tempLabel:setPosition(ccp( x_scale[i], y_scale[i]))
		_bottomBg:addChild(tempLabel)
		table.insert(_skillLabelArr, tempLabel)
    end
end

-- -- 刷新羁绊的ui
-- function refreshUnionUI(  )
-- 	local hero_db = DB_Heroes.getDataById(_formationInfo[_curIndex].htid)
-- 	local heroData= DB_Heroes.getDataById(hero_db.model_id)
-- 	local link_group= heroData.link_group1
-- 	if(link_group)then
-- 		require "db/DB_Union_profit"
-- 		local s_name_arr= string.split(link_group, ",")
-- 		for k,v in pairs(_skillLabelArr) do 
-- 			if(k<= #s_name_arr)then
-- 				local t_union_profit = DB_Union_profit.getDataById(s_name_arr[k])
-- 				if( not table.isEmpty(t_union_profit) and t_union_profit.union_arribute_name)then
-- 					v:setString(t_union_profit.union_arribute_name)
-- 					v:setColor(ccc3(155,155,155))
-- 					-- 设置颜色
-- 					-- print("_curIndex is  ", _curIndex)
-- 					if( RivalInfoData.IsjudgeUnion(s_name_arr[k],_formationInfo[_curIndex].htid)) then
					
-- 						v:setColor(ccc3(0x78, 0x25, 0x00))
-- 					end

-- 				end
-- 			else
-- 				v:setString("")
-- 			end
-- 		end
-- 	else
-- 		for k,v in pairs(_skillLabelArr) do 
-- 			v:setString("")
-- 		end
-- 	end
-- 刷新羁绊的ui
function refreshUnionUI(  )
	local heroData = DB_Heroes.getDataById(_formationInfo[_curIndex].htid)
	local link_group= heroData.link_group1
	if(link_group)then
		require "db/DB_Union_profit"
		local s_name_arr= string.split(link_group, ",")
		for k,v in ipairs(_skillLabelArr) do
			if(k<= #s_name_arr)then
				local t_union_profit = DB_Union_profit.getDataById(s_name_arr[k])
				if( not table.isEmpty(t_union_profit) and t_union_profit.union_arribute_name)then
					v:setString(t_union_profit.union_arribute_name)
					v:setColor(ccc3(155,155,155))
					-- 设置颜色
					-- print("_curIndex is  ", _curIndex)
					if( RivalInfoData.IsjudgeUnion(s_name_arr[k],_formationInfo[_curIndex].htid)) then
					
						v:setColor(ccc3(0x78, 0x25, 0x00))
					end

				end
			else
				v:setString("")
			end
		end
	else
		for k,v in pairs(_skillLabelArr) do 
			v:setString("")
		end
	end

	-- 刷新等级
	local limitLevel = _formationInfo[1].level  -- HeroModel.getHeroLimitLevel(_formationInfo[_curIndex].htid, _formationInfo[_curIndex].evolve_level)
	_LevelLabel:setString( _formationInfo[_curIndex].level .. "/" .. limitLevel)
end


-- 刷新所有的ui
function refreshAllUI(  )
	refreshPropertyUI()
	refreshUnionUI()
	refreshMiddleUI()
	refreshFightSoulUI()
end

-- 刷新属性的UI
function refreshPropertyUI( )
	local heroData= DB_Heroes.getDataById(_formationInfo[_curIndex].htid)
	_fightForceLabel:setString("" .. heroData.heroQuality )
	_lifeLabel:setString("" .. math.ceil(_formationInfo[_curIndex].max_hp) )
	_attLabel:setString("" .. math.ceil(_formationInfo[_curIndex].general_atk) )
	_phyDefLabel:setString("" .. math.ceil(_formationInfo[_curIndex].physical_def))
	_magDefLabel:setString("" .. math.ceil(_formationInfo[_curIndex].magical_def))


	if( HeroModel.isNecessaryHero( tonumber(_formationInfo[_curIndex].htid)) and RivalInfoData.getHeroFightForce()>0 ) then
		_userFightValue:setString( RivalInfoData.getHeroFightForce() )
		_userFightLineSp:setVisible(true)
	else
		_userFightLineSp:setVisible(false)
	end

end

-- 处理阵容信息
local function handleInfo(allFormationInfo  )
	for i=1,#allFormationInfo.squad do
		for k,v in pairs (allFormationInfo.arrHero) do
			if( allFormationInfo.squad[i] == v.hid) then
				table.insert(_formationInfo, v)
			end
		end
	end
end

-- 网络数据的回调
function userBattleCallback( cbFlag, dictData, bRet )
	if(dictData.err ~= "ok" or table.isEmpty(dictData.ret) )then
		AnimationTip.showTip(GetLocalizeStringBy("key_1834"))
		return
	end
	print("武将信息独守空房骄傲的时间放假啦")
	print_t(dictData.ret)
	local allFormationInfo
	for k,v in pairs (dictData.ret) do 
		allFormationInfo = v
	end
	_tname= allFormationInfo.uname
	_guildName= allFormationInfo.guild_name
	_vip =  allFormationInfo.vip or 0

	allFormationInfo.uid= _uid
	-- print("all _formationInfo  is :============================ ")
	-- print_t(allFormationInfo)
	DataCache.addFormaton(allFormationInfo)
	_curIndex =1
	handleInfo(allFormationInfo)
	RivalInfoData.setAllFormationInfo(allFormationInfo)
	RivalInfoData.handleInfo()
	createHeadUI( )
	refreshAllUI()
	refreshRivalName()

	-- 创建小伙伴的UI
	if(RivalInfoData.hasFriend() ) then
		createLittleFriendUI()
	end
	if(RivalInfoData.hasPet() ) then
		createPetUI()
	end
	--createHeroScrowView()
end

function setTname(name  )
	_tname= name
end

function getTname( )
	return _tname
end


local function getHeroData( htid)
	local value = {}

	value.htid = htid
	local db_hero = DB_Heroes.getDataById(htid)
	value.country_icon = HeroModel.getCiconByCidAndlevel(db_hero.country, db_hero.star_lv)

	if(HeroModel.isNecessaryHero( tonumber(htid) )) then
		value.name = _tname
	else
		value.name = db_hero.name
	end

	value.level = tonumber(_formationInfo[_curIndex].level)
	value.star_lv = db_hero.star_lv
	value.hero_cb = menu_item_tap_handler
	value.head_icon = "images/base/hero/head_icon/" .. db_hero.head_icon_id
    value.quality_bg = "images/hero/quality/"..value.star_lv .. ".png"
	value.quality_h = "images/hero/quality/highlighted.png"
	value.type = "HeroFragment"
	value.isRecruited = false
	value.evolve_level =  tonumber(_formationInfo[_curIndex].evolve_level)
	value.htid = tonumber( _formationInfo[_curIndex].htid)
	--添加怒气和普通技能id
	value.rage_skill = tonumber(_formationInfo[_curIndex].rage_skill)
	value.attack_skill = tonumber(_formationInfo[_curIndex].attack_skill)

	local formationInfo =  _formationInfo[_curIndex]
	local dressId= nil
	if( not table.isEmpty(formationInfo) ) then 
		if(not table.isEmpty( formationInfo.equipInfo.dress) and not table.isEmpty(formationInfo.equipInfo.dress["1"]))then
			dressId = tonumber(formationInfo.equipInfo.dress["1"].item_template_id)
		end	
	end
	value.dressId = dressId
	return value
end

-- 点击英雄头像的回调函数
function heroSpriteCb( htid)

	_formationBgSprite:setVisible(false)

	--closeCb()
	require "script/ui/hero/HeroInfoLayer"
	local data = getHeroData(htid)
	local tArgs = {}
	tArgs.sign = "RivalInfoLayer"
	tArgs.fnCreate = RivalInfoLayer.createLayer
	tArgs.reserved =  {index= 10001}
	HeroInfoLayer.createLayer(data, {isPanel=true}, 19003,-1011, nil, setFormationView, true )
	-- MainScene.changeLayer(HeroInfoLayer.createLayer(data, tArgs), "HeroInfoLayer")
end


function setFormationView( ... )
	_formationBgSprite:setVisible(true)
end


-- layer 的回调函数
local function layerToucCb(eventType, x, y)
	-- local heroStartPositionX = _curHeroSprite:getPositionX()
	if (eventType == "began") then	
		_touchBeganPoint = ccp(x, y)
		local vPosition = _curHeroSprite:convertToNodeSpace(_touchBeganPoint)

			if(not _isOnAnimation and vPosition.y>0  and vPosition.x < _curHeroSprite:getContentSize().width and vPosition.y < _curHeroSprite:getContentSize().height) then 
			print("began true")
		    return true
		else
			return false
	   end
    elseif (eventType == "moved") then
    --	print("moved")
    	if( RivalInfoData.hasFriend() and isFormationToFriend() and (x - _touchBeganPoint.x) < 0 ) then

	    	moveFormationOrLittleFriend(x - _touchBeganPoint.x)
	    	-- local xOffset = (x- _touchBeganPoint.x)+ _formationBgSprite:getContentSize().width/2
	    	-- _curHeroSprite:setPosition(ccp(xOffset , 200))
	    -- elseif() then
	    else
	    	local xOffset = (x- _touchBeganPoint.x)+ _formationBgSprite:getContentSize().width/2 --_curHeroSprite:getPositionX()
	    	_curHeroSprite:setPosition(ccp(xOffset , 200))
	    	_curHeroSprite:setAnchorPoint(ccp(0.5,0))
	    end	
    else
    	local xOffset = x- _touchBeganPoint.x

    	if(RivalInfoData.hasFriend() and isFormationToFriend() and (x - _touchBeganPoint.x) < 0  )then 
    		if((x - _touchBeganPoint.x) < - _formationBgSprite:getContentSize().width/6)then
				moveFormationOrLittleFriendAnimated(true, true)
			else
				print("  == moveFormationOrLittleFriendAnimated(false, true) moveFormationOrLittleFriendAnimated(false, true) ")
				moveFormationOrLittleFriendAnimated(false, true)
			end
		elseif( RivalInfoData.hasPet() and RivalInfoData.hasFriend()== false and  isFormationToFriend() and  (x - _touchBeganPoint.x) < 0  ) then
			if((x - _touchBeganPoint.x) < - _formationBgSprite:getContentSize().width/6)then
				moveFriendOrPetAnimated(true, true)
			else
				print("  == moveFriendOrPetAnimated() ")
				moveFriendOrPetAnimated(false, true)
			end
        elseif(math.abs(xOffset) > 60)then
        	print("switchNextHero   switchNextHero  switchNextHero   ")
        	switchNextHero(xOffset)
        	--switchHero(xOffset)
        elseif(math.abs(xOffset) > 20) then
        	runBack()
        elseif(math.abs(xOffset)<20) then
        	runBack()
        	print("_index  is : ", _curIndex)
        	heroSpriteCb(_formationInfo[_curIndex].htid)
        end
	end
	-- return true
end


-- 让当前的英雄大图跑回原来的
function runBack( )
	_heroPriginPosition = ccp(_formationBgSprite:getContentSize().width/2, 200 )
	_curHeroSprite:runAction(CCMoveTo:create(0.2,_heroPriginPosition ))
end

-- 创建小伙伴
function createLittleFriendUI()
	-- 小伙伴
	require "script/ui/active/RivalFriendLayer"
	_littleFriendLayer = RivalFriendLayer.createLittleFriendLayer( )
	_littleFriendLayerOriginPosition = ccp( _formationBgSprite:getContentSize().width, 0)
	_littleFriendLayer:setPosition(_littleFriendLayerOriginPosition)
	_littleFriendLayer:setAnchorPoint(ccp(0,0))
	_formationBgSprite:addChild(_littleFriendLayer)
end


-- 切换阵容和小伙伴
function moveFormationOrLittleFriend( xOffset )
	_equipMenuNode:setPosition(ccp(_equipMenuOriginPosition.x+xOffset, _equipMenuOriginPosition.y))
	-- _fightSoulMenuBar:setPosition(ccp(_equipMenuOriginPosition.x+xOffset, _equipMenuOriginPosition.y))

	
	_curHeroSprite:setPosition(ccp(xOffset+ _formationBgSprite:getContentSize().width/2 , 200))
    _curHeroSprite:setAnchorPoint(ccp(0.5,0))
	_bottomBg:setPosition(ccp(xOffset, 0))
	_littleFriendLayer:setPosition(ccp(_littleFriendLayerOriginPosition.x+xOffset, _littleFriendLayerOriginPosition.y)) 
end

-- 切换阵容和小伙伴
function moveFormationOrLittleFriendAnimated( isMoveToLittleFriend, isAnimated, isClick )
	
	isAnimated = isAnimated or false
	local xOffset = 0
	
	-- _curIndex = #_formationInfo
	-- RivalInfoData.setCurIndex(_curIndex)

	if(isMoveToLittleFriend == true)then
		_isInLittleFriend = true
		_inType =2
		xOffset = -_formationBgSprite:getContentSize().width
		_curIndex = #_formationInfo+1
		RivalInfoData.setCurIndex(_curIndex)
	
		-- refreshTopTableviewStatus( true, true )
	else
		_isInLittleFriend = false
		_inType =1
		
		--if(_lastIndex<=#_formationInfo ) then
			_curIndex= _lastIndex
		-- else
		-- 	_curIndex=  #_formationInfo

		-- end	
		-- RivalInfoData.setCurIndex(_curIndex)
		--end
		-- refreshTopTableviewStatus( true, false )
	end

	print("xOffset is : ", xOffset, " _curIndex is ", _curIndex , " _lastIndex is ", _lastIndex)
	if(isAnimated == true)then
		_isOnAnimation = true
		local animationDuration = 0.1
		_equipMenuNode:runAction(CCMoveTo:create(animationDuration, ccp(_equipMenuOriginPosition.x+xOffset, _equipMenuOriginPosition.y)))
		_fightSoulMenuBar:runAction(CCMoveTo:create(animationDuration, ccp(_equipMenuOriginPosition.x+xOffset, _equipMenuOriginPosition.y)))
		_curHeroSprite:runAction(CCMoveTo:create(animationDuration, ccp(_heroPriginPosition.x+xOffset, _heroPriginPosition.y)))
		_bottomBg:runAction(CCMoveTo:create(animationDuration, ccp(xOffset, 0)))
		_bottomBg:setAnchorPoint(ccp(0,0))
		_littleFriendLayer:runAction(CCMoveTo:create(animationDuration, ccp(_littleFriendLayerOriginPosition.x+xOffset, _littleFriendLayerOriginPosition.y)))

		if(RivalInfoData.hasPet() ) then
			_petLayer:runAction(CCMoveTo:create(animationDuration, ccp( _petLayerOriginPosition.x , _petLayerOriginPosition.y)))
		end

		-- 延迟回调
		local overAnimation = CCSequence:createWithTwoActions(CCDelayTime:create(animationDuration+0.05),CCCallFunc:create(overAnimationDelegate))
		_formationBgSprite:runAction(overAnimation)
	else
		_equipMenuNode:setPosition( ccp(_equipMenuOriginPosition.x+xOffset, _equipMenuOriginPosition.y))
		-- _fightSoulMenuBar:setPosition( ccp(_equipMenuOriginPosition.x+xOffset, _equipMenuOriginPosition.y))
		_bottomBg:setPosition(ccp(xOffset, 0))
		_bottomBg:setAnchorPoint(ccp(0,0))
		_littleFriendLayer:setPosition(_littleFriendLayerOriginPosition.x+xOffset, _littleFriendLayerOriginPosition.y)

		if(RivalInfoData.hasPet() ) then
			_petLayer:setPosition(ccp( _petLayerOriginPosition.x , _petLayerOriginPosition.y))
		end
	end

	refreshStarBg()
	refreshTopUI()
end


-- 动画结束回调
function overAnimationDelegate()
	-- print("_isOnAnimation _isOnAnimation ")
	_isOnAnimation = false
end

-- 创建出战宠物的UI
function createPetUI( )
	-- 小伙伴
	require "script/ui/active/RivalPetLayer"
	_petLayer = RivalPetLayer.createPetLayer( )
	_petLayerOriginPosition = ccp( _formationBgSprite:getContentSize().width, 0)
	_petLayer:setPosition(_petLayerOriginPosition)
	_petLayer:setAnchorPoint(ccp(0,0))
	_formationBgSprite:addChild(_petLayer)
end


-- 切换阵容和小伙伴
function moveLittleOrPet( xOffset )
	-- _equipMenuNode:setPosition(ccp(_equipMenuOriginPosition.x+xOffset, _equipMenuOriginPosition.y))
	-- -- _fightSoulMenuBar:setPosition(ccp(_equipMenuOriginPosition.x+xOffset, _equipMenuOriginPosition.y))
	-- _curHeroSprite:setPosition(ccp(xOffset , 200))
 --    _curHeroSprite:setAnchorPoint(ccp(0.5,0))
	-- _bottomBg:setPosition(ccp(xOffset, 0))
	_littleFriendLayer:setPosition(ccp(xOffset, _littleFriendLayerOriginPosition.y)) 
	_petLayer:setPosition(ccp( _petLayerOriginPosition.x,_petLayerOriginPosition.y ))
end

-- 切换宠物和小伙伴
function moveFriendOrPetAnimated( isMoveToPet , isAnimated )
	
	local isAnimated = isAnimated or false
	local xOffset = 0
	_curIndex = #_formationInfo+1
	RivalInfoData.setCurIndex(_curIndex)
	if(isMoveToPet == true)then
		_isInPet = true
		_isInLittleFriend= false
		_inType= 3

		xOffset = -_formationBgSprite:getContentSize().width

		if(RivalInfoData.hasFriend() ) then
			_curIndex = #_formationInfo+2
		else
			_curIndex = #_formationInfo+1
		end
		RivalInfoData.setCurIndex(_curIndex)
		-- refreshTopTableviewStatus( true, true )
	else
		_inType=2
		_isInPet = false
		_isInLittleFriend= true

		
		-- if(RivalInfoData.hasFriend() ) then
			_curIndex = #_formationInfo+1
		-- else
		-- 	-- _curIndex = _lastIndex--#_formationInfo
			-- _curIndex = #_formationInfo
		-- end
		RivalInfoData.setCurIndex(_curIndex)
	end

	print("in moveFriendOrPetAnimated  _curIndex  is ", _curIndex)
	-- print("xOffset is : ", xOffset, " isMoveToLittleFriend is ", isMoveToLittleFriend , " isAnimated is ", isAnimated)
	if(isAnimated == true)then
		_isOnAnimation = true
		local animationDuration = 0.1

		if(RivalInfoData.hasFriend() ) then
			_littleFriendLayer:runAction(CCMoveTo:create(animationDuration, ccp(xOffset, _littleFriendLayerOriginPosition.y)))
		end

		if(RivalInfoData.hasPet() ) then
			_petLayer:runAction(CCMoveTo:create(animationDuration, ccp( _petLayerOriginPosition.x+xOffset, _petLayerOriginPosition.y) ) )
		end

		local overAnimation = CCSequence:createWithTwoActions(CCDelayTime:create(animationDuration+0.05),CCCallFunc:create(overAnimationDelegate))
		_formationBgSprite:runAction(overAnimation)
		
		-- 修改
		_curHeroSprite:runAction(CCMoveTo:create(animationDuration, ccp(_heroPriginPosition.x - _formationBgSprite:getContentSize().width, _heroPriginPosition.y)))
		_bottomBg:runAction(CCMoveTo:create(animationDuration, ccp(-_formationBgSprite:getContentSize().width, 0)))
		_bottomBg:setAnchorPoint(ccp(0,0))
		_equipMenuNode:runAction(CCMoveTo:create(animationDuration, ccp(_equipMenuOriginPosition.x- _formationBgSprite:getContentSize().width, _equipMenuOriginPosition.y)))
		_fightSoulMenuBar:runAction(CCMoveTo:create(animationDuration, ccp(_equipMenuOriginPosition.x-_formationBgSprite:getContentSize().width, _equipMenuOriginPosition.y)))
	else
		_littleFriendLayer:setPosition( ccp(xOffset,_littleFriendLayerOriginPosition.y))
		_petLayer:setPosition(ccp(_petLayerOriginPosition.x+xOffset, _petLayerOriginPosition.y))

	end

	refreshStarBg()
	refreshTopUI()
end

-- 移动到宠物的类型
-- moveType:1 小伙伴到宠物， 2，宠物到小伙伴，3。宠物到其他界面 
function moveToPetAnimatedByType( moveType )
	local animationDuration= 0.1
	local xOffset = 0

	if( moveType ==1) then
		_isInPet = true
		_isInLittleFriend= false
		_inType=3

		xOffset= -_formationBgSprite:getContentSize().width
		
		if(RivalInfoData.hasFriend() ) then
			_curIndex = #_formationInfo+2
		else
			_curIndex = #_formationInfo+1
		end
		RivalInfoData.setCurIndex(_curIndex)

		_littleFriendLayer:runAction(CCMoveTo:create(animationDuration, ccp(xOffset, _littleFriendLayerOriginPosition.y)))
		_petLayer:runAction(CCMoveTo:create(animationDuration, ccp( _petLayerOriginPosition.x+xOffset, _petLayerOriginPosition.y) ) )

	elseif(moveType==2) then

		_isInPet = false
		_isInLittleFriend = true
		_inType=2

		xOffset= 0
		_curIndex = #_formationInfo+1
		RivalInfoData.setCurIndex(_curIndex)

		_littleFriendLayer:runAction(CCMoveTo:create(animationDuration, ccp(xOffset, _littleFriendLayerOriginPosition.y)))

		if(RivalInfoData.hasPet() ) then
			_petLayer:runAction(CCMoveTo:create(animationDuration, ccp( _petLayerOriginPosition.x+xOffset, _petLayerOriginPosition.y) ) )
		end

	elseif(moveType== 3) then

		_isOnAnimation = true

		_isInPet = false
		_isInLittleFriend = false
		_inType=1

		if(RivalInfoData.hasFriend() ) then
			_curIndex = #_formationInfo+1
		else
			--_curIndex = _lastIndex--#_formationInfo
			_curIndex = #_formationInfo
		end
		RivalInfoData.setCurIndex(_curIndex)
		-- _curIndex = _lastIndex

		_equipMenuNode:runAction(CCMoveTo:create(animationDuration, ccp(_equipMenuOriginPosition.x+xOffset, _equipMenuOriginPosition.y)))
		_fightSoulMenuBar:runAction(CCMoveTo:create(animationDuration, ccp(_equipMenuOriginPosition.x+xOffset, _equipMenuOriginPosition.y)))
		_curHeroSprite:runAction(CCMoveTo:create(animationDuration, ccp(_heroPriginPosition.x+xOffset, _heroPriginPosition.y)))
		_bottomBg:runAction(CCMoveTo:create(animationDuration, ccp(xOffset, 0)))

		if(RivalInfoData.hasFriend() ) then
			_littleFriendLayer:runAction(CCMoveTo:create(animationDuration, ccp(_littleFriendLayerOriginPosition.x, _littleFriendLayerOriginPosition.y)))
		end

		if(RivalInfoData.hasPet() ) then
			_petLayer:runAction(CCMoveTo:create(animationDuration, ccp( _petLayerOriginPosition.x, _petLayerOriginPosition.y) ) )
		end

		local overAnimation = CCSequence:createWithTwoActions(CCDelayTime:create(animationDuration+0.05),CCCallFunc:create(overAnimationDelegate))
		_formationBgSprite:runAction(overAnimation)
	end

	refreshStarBg()
	refreshTopUI()

end



function refreshRivalName()

	_rivalName =CCRenderLabel:create("" .. _tname, g_sFontPangWa, 33, 1,ccc3(0x00,0x00,0x00), type_stroke)
	_rivalName:setColor(ccc3(0xff,0xe4,0x00))
	if(_guildName~= nil ) then
		_guildNameLabel =CCRenderLabel:create("   [" .. _guildName .. "]", g_sFontPangWa, 32, 1,ccc3(0x00,0x00,0x00), type_stroke)
	else
		_guildNameLabel =CCRenderLabel:create("", g_sFontPangWa, 32, 1,ccc3(0x00,0x00,0x00), type_stroke)
	end
	_guildNameLabel:setColor(ccc3(0xff,0xff,0xff))

	local rilavNode= BaseUI.createHorizontalNode({_rivalName, _guildNameLabel})	
	rilavNode:setPosition(ccp( _titileSprite:getContentSize().width*0.5,_titileSprite:getContentSize().height*0.5+3))
	rilavNode:setAnchorPoint(ccp(0.5,0.5))
	_titileSprite:addChild(rilavNode)	
end



-- 是否是小伙伴切换到阵型
function isFormationToFriend()
	
	if( _curIndex== #_formationInfo ) then
		return true
	end 
	return false
end


-- 关闭按钮的回调函数
function closeCb( tag,item )
	AudioUtil.playEffect("audio/effect/guanbi.mp3")
   -- local scene = CCDirector:sharedDirector():getRunningScene()
   --  scene:removeChildByTag(2013,true)

   if(_maskLayer~= nil) then
   		_maskLayer:removeFromParentAndCleanup(true)
   		_maskLayer= nil
   		_bgLayer=nil
    	itemDelegateAction()
    end
end


local function onNodeEvent(event)
	if event == "enter" then
		_bgLayer:setTouchEnabled(true)
		_bgLayer:registerScriptTouchHandler(layerToucCb,false,-999,true)
	elseif (event == "exit") then
		_bgLayer:unregisterScriptTouchHandler()
		_bgLayer =nil
	end
end




--[[
	@des 	:弹出查看对手阵容的layer
	@param 	:当不是npc时，uid 为玩家的hid，当是npc时，uid为army表的id, 
	@retrun :
]]
function createLayer(uid , isNpc, npcName,menuVisible,avatarVisible,bulletinVisible )

	if(uid == 0) then
		AnimationTip.showTip(GetLocalizeStringBy("key_2163"))
		return
	end
	init()

	_isNpc = isNpc or false
	RivalInfoData.setNpc(_isNpc)
	_tname = npcName
	-- _menuVisible= menuVisible~=nil or true
	if(menuVisible~= nil) then
		_menuVisible= menuVisible
	end
	if(avatarVisible~= nil) then 
		_avatarVisible= avatarVisible 
	end
	if( bulletinVisible ~= nil ) then 
		_bulletinVisible= bulletinVisible 
	end
		
	require "script/model/user/UserModel"
	_maskLayer = BaseUI.createMaskLayer(-998)

	_bgLayer = CCLayerColor:create(ccc4(11,11,11,166))
	_bgLayer:setTouchEnabled(true)
	_bgLayer:registerScriptTouchHandler(layerToucCb,false,-999,true)

	_maskLayer:addChild(_bgLayer)

	local scene = CCDirector:sharedDirector():getRunningScene()
 	scene:addChild(_maskLayer,19000,2013)

	local myScale = MainScene.elementScale
	local layerSize = CCSizeMake(640,802)

 	-- _formationBgSprite = CCSprite:create("images/active/beijing.png") 
 	_formationBgSprite=CCSprite:create()  
 	_formationBgSprite:setContentSize(CCSizeMake(640,804))
 	_formationBgSprite:setPosition(ccp(_bgLayer:getContentSize().width*0.5,_bgLayer:getContentSize().height*0.5))
    _formationBgSprite:setAnchorPoint(ccp(0.5,0.5))
  
    _formationBgSprite:setScale(g_fScaleX)
    _bgLayer:addChild(_formationBgSprite)

    _heroPriginPosition = ccp(_formationBgSprite:getContentSize().width/2, 200 )

    	-- 背景
	_backgroundSprite = CCSprite:create("images/formation/formationbg.png")
	_backgroundSprite:setPosition(_formationBgSprite:getContentSize().width/2, 5)
	_backgroundSprite:setAnchorPoint(ccp(0.5,0))
	_formationBgSprite:addChild(_backgroundSprite)

    local leftFrameSp= CCScale9Sprite:create("images/common/frame.png")
    leftFrameSp:setContentSize(CCSizeMake(16, 800))
    leftFrameSp:setPosition(0,1)
    _formationBgSprite:addChild(leftFrameSp,1)

    local rightFrameSp= CCScale9Sprite:create("images/common/frame.png")
    rightFrameSp:setContentSize(CCSizeMake(16, 800))
    rightFrameSp:setPosition(640,1)
    rightFrameSp:setAnchorPoint(ccp(1,0))
    _formationBgSprite:addChild(rightFrameSp,1)



    --
    createTopUI()
    createPropertyUI()
    createUnionUI()
    createMiddleUI()

    -- 网络请求，获取对手的信息
    _uid= uid or  UserModel.getUserUid()

   
    -- local allFormationInfo=  DataCache.getFromation(_uid)
    if(isNpc) then
    	_curIndex =1
	 	_formationInfo= RivalInfoData.getNpcDataById(uid)
		-- print("_formationInfo   is : ")
		-- print_t(allFormationInfo)
		createHeadUI( )
		refreshAllUI()
		refreshRivalName()
    else
	   	local args = CCArray:create()
		args:addObject(CCInteger:create(_uid))
		local args2 =CCArray:create()
		args2:addObject(args)
	    RequestCenter.user_getBattleDataOfUsers(userBattleCallback, args2)
	end

	--MainScene.removeAllChildLayer()

end

