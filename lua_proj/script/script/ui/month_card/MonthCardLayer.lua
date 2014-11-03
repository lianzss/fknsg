-- Filename：	MonthCardLayer.lua
-- Author：		zhz
-- Date：		2013-6-12
-- Purpose：		月卡功能

module("MonthCardLayer", package.seeall)

require "script/ui/month_card/MonthCardData"
require "script/ui/item/ItemUtil"
require "script/ui/month_card/MonthCardService"
require "script/ui/item/ReceiveReward"
require "script/utils/TimeUtil"


local _bgLayer				--背景的layer
local _monthCardBg			--月卡的背景
local _gameType 			--15天活动还是3天活动 1代表15天，2代表3天 
local _timeCounter 			--定时器



local function init( )
	_bgLayer			=nil
	_monthCardBg		=nil
	_monthSendSp		=nil
	_monthDescBg        =nil
	_monthCardDesc_1	=nil
	_leftDayNode		=nil
	_gameType 			=0
	_timeCounter 		= nil
end


-- 创建顶部的UI
local function createTopUI( ... )

	local monthSendBg=CCSprite:create("images/month_card/month_send_bg.png")
	monthSendBg:setPosition(_layerSize.width/2, _layerSize.height)
	monthSendBg:setScale(MainScene.elementScale)
	monthSendBg:setAnchorPoint(ccp(0.5,1))
	_bgLayer:addChild(monthSendBg,3)

	
	_monthSendSp= CCSprite:create("images/month_card/month_send_sp.png")
	_monthSendSp:setPosition(_layerSize.width/2, _layerSize.height-12*MainScene.elementScale)
	_monthSendSp:setAnchorPoint(ccp(0.5,1))
	_monthSendSp:setScale(MainScene.elementScale)
	_bgLayer:addChild(_monthSendSp,5)

	local monthSendSpSize= _monthSendSp:getContentSize()

	-- 左边的灯笼
	local leftLanternSp= CCSprite:create("images/month_card/lantern.png")
	leftLanternSp:setPosition(_monthSendSp:getPositionX()+5*MainScene.elementScale-monthSendSpSize.width*0.5*MainScene.elementScale ,_layerSize.height)
	leftLanternSp:setAnchorPoint(ccp(1,1))
	leftLanternSp:setFlipX(true)
	leftLanternSp:setScale(MainScene.elementScale)
	_bgLayer:addChild(leftLanternSp)

	-- 右边的灯笼
	local rightlanternSp=CCSprite:create("images/month_card/lantern.png")
	rightlanternSp:setPosition(_monthSendSp:getPositionX()+(monthSendSpSize.width*0.5-15)*MainScene.elementScale,_layerSize.height)
	rightlanternSp:setAnchorPoint(ccp(0,1))
	rightlanternSp:setScale(MainScene.elementScale)
	_bgLayer:addChild(rightlanternSp)



end


-- 创建 放开那三国描述的UI部分
-- 
function createDescUI( )
	-- 紫色描述的底
	local height= _monthSendSp:getPositionY()- _monthSendSp:getContentSize().height*_monthSendSp:getScale() 

	local middleUIHeight=  _monthSendSp:getPositionY()- _monthSendSp:getContentSize().height*_monthSendSp:getScale() - (_bottomBg:getContentSize().height+22)*_bottomBg:getScale()

	_monthDescBg= CCScale9Sprite:create("images/common/bg/9s_purple.png")
	_monthDescBg:setContentSize(CCSizeMake(380,210))
	_monthDescBg:setScale(MainScene.elementScale )
	-- _monthDescBg:setPosition(_layerSize.width/2, _bottomBg:getContentSize().height*g_fScaleX+ )

	_bgLayer:addChild(_monthDescBg,11)

	-- 
	_lineSp= CCSprite:create("images/common/line3.png")
	_lineSp:setPosition(_monthDescBg:getContentSize().width/2, _monthDescBg:getContentSize().height-13)
	_lineSp:setAnchorPoint(ccp(0.5,1))
	_monthDescBg:addChild(_lineSp)

	-- local height= _lineSp:getPositionY()

	-- "放开那月卡"图片
	local monthCardSp= CCSprite:create("images/month_card/month_card_sp.png")
	monthCardSp:setPosition(_lineSp:getContentSize().width/2, _lineSp:getContentSize().height/2)
	monthCardSp:setAnchorPoint(ccp( 0.5,0.5))
	_lineSp:addChild(monthCardSp)

	_monthCardDesc_1= CCSprite:create("images/month_card/card_desc_1.png")
	_monthCardDesc_1:setPosition(_monthDescBg:getContentSize().width/2, 87)
	_monthCardDesc_1:setAnchorPoint(ccp(0.5,0))
	_monthDescBg:addChild(_monthCardDesc_1)

	_monthCardDesc_2= CCSprite:create("images/month_card/card_desc_2.png")
	_monthCardDesc_2:setPosition(_monthDescBg:getContentSize().width/2, 50)
	_monthCardDesc_2:setAnchorPoint(ccp(0.5,0))
	_monthDescBg:addChild(_monthCardDesc_2)

	_monthCardDesc_3 = CCSprite:create("images/month_card/card_desc_3.png")
	_monthCardDesc_3:setPosition(_monthDescBg:getContentSize().width/2, 50)
	_monthCardDesc_3:setAnchorPoint(ccp(0.5,0))
	_monthDescBg:addChild(_monthCardDesc_3)

	---------------------------------------------------UI拼接开始
	--文本 活动时间：
	_gameTimeLabel = CCLabelTTF:create(GetLocalizeStringBy("zzh_1019"),g_sFontName,21)
	_gameTimeLabel:setColor(ccc3(0xff,0xff,0xff))
	_gameTimeLabel:setAnchorPoint(ccp(1,1))
	_monthDescBg:addChild(_gameTimeLabel)

	--开始时间
	_beginTimeLabel = CCLabelTTF:create(TimeUtil.getTimeFormatChnYMDHM(MonthCardData.getBeginTime(_gameType)),g_sFontName,21)
	_beginTimeLabel:setColor(ccc3(0x00,0xff,0x18))
	_beginTimeLabel:setAnchorPoint(ccp(0,1))
	_monthDescBg:addChild(_beginTimeLabel)

	--文本 至
	_toLabel = CCLabelTTF:create(GetLocalizeStringBy("key_2358"),g_sFontName,21)
	_toLabel:setColor(ccc3(0x00,0xff,0x18))
	_toLabel:setAnchorPoint(ccp(0,1))
	_monthDescBg:addChild(_toLabel)

	--结束时间
	_endTimeLabel = CCLabelTTF:create(TimeUtil.getTimeFormatChnYMDHM(MonthCardData.getEndTime(_gameType)),g_sFontName,21)
	_endTimeLabel:setColor(ccc3(0x00,0xff,0x18))
	_endTimeLabel:setAnchorPoint(ccp(0,1))
	_monthDescBg:addChild(_endTimeLabel)

	--文本 （活动倒计时：
	_gameMinusLabel_1 = CCRenderLabel:create(GetLocalizeStringBy("zzh_1029"),g_sFontName, 21,1, ccc3(0x00,0,0),type_stroke)
	_gameMinusLabel_1:setColor(ccc3(0xff,0xff,0xff))
	_gameMinusLabel_1:setAnchorPoint(ccp(1,1))
	_monthDescBg:addChild(_gameMinusLabel_1)

	--倒计时
	_remainTimeLabel = CCRenderLabel:create(MonthCardData.remainTimeFormat(_gameType),g_sFontName,21,1, ccc3(0x00,0,0),type_stroke)
	_remainTimeLabel:setColor(ccc3(0x00,0xff,0x18))
	_remainTimeLabel:setAnchorPoint(ccp(0,1))
	_monthDescBg:addChild(_remainTimeLabel)

	--文本 ）
	_gameMinusLabel_2 = CCRenderLabel:create(GetLocalizeStringBy("key_4039"),g_sFontName,21,1, ccc3(0x00,0,0),type_stroke)
	_gameMinusLabel_2:setColor(ccc3(0xff,0xff,0xff))
	_gameMinusLabel_2:setAnchorPoint(ccp(0,1))
	_monthDescBg:addChild(_gameMinusLabel_2)

	if _gameType ~= 0 then
		_timeCounter = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(refreshRemainTime, 1, false)
	end

	-----------------------------------------------------------------UI拼接结束

	local curDayLabel_1= CCLabelTTF:create(GetLocalizeStringBy("key_4017"),g_sFontPangWa ,21 )
	curDayLabel_1:setColor(ccc3(0xff,0xff,0xff))
	local curDayLabel_2= CCLabelTTF:create( MonthCardData.getOpenServerDay() , g_sFontPangWa, 21)
	curDayLabel_2:setColor(ccc3(0x00,0xff,0x18))
	local curDayLabel_3=CCLabelTTF:create(GetLocalizeStringBy("key_4018"),g_sFontPangWa ,21 )
	curDayLabel_3:setColor(ccc3(0xff,0xff,0xff))

	_curDayNode= BaseUI.createHorizontalNode({curDayLabel_1 ,curDayLabel_2 ,curDayLabel_3 } )
	_curDayNode:setPosition(_monthDescBg:getContentSize().width/2,25)
	_curDayNode:setAnchorPoint(ccp(0.5,0) )
	_monthDescBg:addChild(_curDayNode)


	local menuBar=CCMenu:create()
	menuBar:setPosition(ccp(0,0))
	_bgLayer:addChild(menuBar,11)

		-- 立即购买按钮
	_buyItem = LuaCC.create9ScaleMenuItem("images/common/btn/btn_shop_n.png","images/common/btn/btn_shop_h.png",CCSizeMake(203, 85),GetLocalizeStringBy("key_4015"),ccc3(0xfe, 0xdb, 0x1c),35,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00))
	-- _buyItem:setPosition(_layerSize.width*0.5,( _bottomBg:getContentSize().height+22) *_bottomBg:getScale()+_bottomBg:getPositionY() )
	-- _buyItem:setAnchorPoint(ccp(0.5,0))
	_buyItem:setScale(MainScene.elementScale)
	_buyItem:registerScriptTapHandler(buyCallback)
	menuBar:addChild(_buyItem)

	local offSetHeight= middleUIHeight- _monthDescBg:getContentSize().height*_monthDescBg:getScale() - _buyItem:getContentSize().height*MainScene.elementScale

	_buyItem:setPosition( _layerSize.width*0.5, ( _bottomBg:getContentSize().height+22) *_bottomBg:getScale()+_bottomBg:getPositionY()+ offSetHeight/3 )
	_buyItem:setAnchorPoint(ccp(0.5,0))

	_monthDescBg:setPosition(_layerSize.width/2, _buyItem:getPositionY()+ _buyItem:getContentSize().height*MainScene.elementScale + offSetHeight/3)
	_monthDescBg:setAnchorPoint(ccp(0.5, 0))


	-- local specialScale= middleUIHeight/290
	local leftGirlSp= CCSprite:create("images/month_card/girl_1.png")
	leftGirlSp:setPosition(ccp(0, _monthDescBg:getPositionY()+ _monthDescBg:getContentSize().height*_monthDescBg:getScale()/2 ))
	leftGirlSp:setAnchorPoint(ccp(0,0.5))
	leftGirlSp:setScale(MainScene.elementScale)
	_bgLayer:addChild(leftGirlSp)

	local rightGirlSp=CCSprite:create("images/month_card/girl_2.png")
	rightGirlSp:setPosition(_layerSize.width, _monthDescBg:getPositionY()+ _monthDescBg:getContentSize().height*_monthDescBg:getScale()/2)
	rightGirlSp:setAnchorPoint(ccp(1,0.5))
	rightGirlSp:setScale(MainScene.elementScale)
	_bgLayer:addChild(rightGirlSp)

end

-- 刷新月卡描述的UI
function refreshDescUI( )
	if( MonthCardData.isNewServer() ) then
		_monthCardDesc_2:setVisible(true)
		_monthCardDesc_3:setVisible(false)
		_curDayNode:setVisible(false)

		--被策划干掉了，但保留着吧，以防改回来
		_gameTimeLabel:setVisible(false)
		_beginTimeLabel:setVisible(false)
		_toLabel:setVisible(false)
		_endTimeLabel:setVisible(false)
		
		_gameMinusLabel_1:setVisible(true)
		_remainTimeLabel:setVisible(true)
		_gameMinusLabel_2:setVisible(true)

		_lineSp:setPosition(_monthDescBg:getContentSize().width/2, _monthDescBg:getContentSize().height)
		_monthCardDesc_2:setPosition(_monthDescBg:getContentSize().width/2, 60)
		_monthCardDesc_1:setPosition(_monthDescBg:getContentSize().width/2, 97)
		
		_gameTimeLabel:setPosition(50,60)
		_beginTimeLabel:setPosition(50,60)
		_toLabel:setPosition(50+_beginTimeLabel:getContentSize().width,60)
		_endTimeLabel:setPosition(50+_beginTimeLabel:getContentSize().width+_toLabel:getContentSize().width,60)
		
		_gameMinusLabel_1:setPosition(180,50)
		_remainTimeLabel:setPosition(180,50)
		_gameMinusLabel_2:setPosition(180+_remainTimeLabel:getContentSize().width,50)
	elseif MonthCardData.isOldServer() then
		_monthCardDesc_2:setVisible(false)
		_monthCardDesc_3:setVisible(true)
		_curDayNode:setVisible(false)
		
		--被策划干掉了，但保留着吧，以防改回来
		_gameTimeLabel:setVisible(false)
		_beginTimeLabel:setVisible(false)
		_toLabel:setVisible(false)
		_endTimeLabel:setVisible(false)
		
		_gameMinusLabel_1:setVisible(true)
		_remainTimeLabel:setVisible(true)
		_gameMinusLabel_2:setVisible(true)

		_lineSp:setPosition(_monthDescBg:getContentSize().width/2, _monthDescBg:getContentSize().height-13)
		_monthCardDesc_3:setPosition(_monthDescBg:getContentSize().width/2, 60)
		_monthCardDesc_1:setPosition(_monthDescBg:getContentSize().width/2, 97)
		
		_gameTimeLabel:setPosition(50,60)
		_beginTimeLabel:setPosition(50,60)
		_toLabel:setPosition(50+_beginTimeLabel:getContentSize().width,60)
		_endTimeLabel:setPosition(50+_beginTimeLabel:getContentSize().width+_toLabel:getContentSize().width,60)
		
		_gameMinusLabel_1:setPosition(180,50)
		_remainTimeLabel:setPosition(180,50)
		_gameMinusLabel_2:setPosition(180+_remainTimeLabel:getContentSize().width,50)
	else
		_monthCardDesc_2:setVisible(false)
		_monthCardDesc_3:setVisible(false)
		_curDayNode:setVisible(false)
		--活动倒计时的文本
		_gameTimeLabel:setVisible(false)
		_beginTimeLabel:setVisible(false)
		_toLabel:setVisible(false)
		_endTimeLabel:setVisible(false)
		_gameMinusLabel_1:setVisible(false)
		_remainTimeLabel:setVisible(false)
		_gameMinusLabel_2:setVisible(false)

		_lineSp:setPosition(_monthDescBg:getContentSize().width/2, _monthDescBg:getContentSize().height-33)
		_monthCardDesc_2:setPosition(_monthDescBg:getContentSize().width/2, 20)
		_monthCardDesc_1:setPosition(_monthDescBg:getContentSize().width/2, 57)
	end

	if MonthCardData.wetherHaveBag() then
		_monthCardItem:setVisible(true)
	else
		_monthCardItem:setVisible(false)
	end
end

-- 创建物品的scrowllview
local function createScrollView( )
	
	local scrollSize = _scrollBg:getContentSize()
	local contentScrollView = CCScrollView:create()
	contentScrollView:setViewSize(CCSizeMake(scrollSize.width, scrollSize.height))
	contentScrollView:setDirection(kCCScrollViewDirectionHorizontal)
	contentScrollView:setTouchPriority(-551)
	local scrollLayer = CCLayer:create()
	contentScrollView:setContainer(scrollLayer)

	local rewardTable = {}
	rewardTable = MonthCardData.getCardReward()  --VIPNumTool.unpackGiftInfo()
	local rewardTableNum = table.count(rewardTable)
	local scrollWide = rewardTableNum*121

	scrollLayer:setContentSize(CCSizeMake(scrollWide,scrollSize.height))
	scrollLayer:setPosition(ccp(0,0))
	_scrollBg:addChild(contentScrollView)
    scrollLayer:setPosition(ccp(0,0))

    local picBeginX = 11.5

    for i=1, #rewardTable do
        rewardSprite= ItemUtil.createGoodsIcon(rewardTable[i], -320)
        rewardSprite:setAnchorPoint(ccp(0,1))
        rewardSprite:setPosition(ccp(picBeginX,scrollSize.height-13))
        scrollLayer:addChild(rewardSprite)

        local spriteSize = rewardSprite:getContentSize()
        picBeginX = picBeginX + spriteSize.width + 23
    end

end


-- 创建底部的UI
function createBottomUI(  )

	_bottomBg=CCScale9Sprite:create(CCRectMake(33, 35, 12, 45),"images/recharge/vip_benefit/vipBB.png")
	_bottomBg:setPreferredSize(CCSizeMake(638,245))
	_bottomBg:setPosition(ccp(g_winSize.width/2,5))
	_bottomBg:setScale(MainScene.elementScale)
	_bottomBg:setAnchorPoint(ccp(0.5,0))
	_bgLayer:addChild(_bottomBg,2)

	-- 
	local bottomBgSize = _bottomBg:getContentSize()
	local everyDayB = CCScale9Sprite:create(CCRectMake(86, 32, 4, 3),"images/recharge/vip_benefit/everyday.png")
	everyDayB:setPreferredSize(CCSizeMake(380,68))
	everyDayB:setAnchorPoint(ccp(0.5,0.5))
	everyDayB:setPosition(ccp(bottomBgSize.width/2,bottomBgSize.height-3))
	_bottomBg:addChild(everyDayB)


	_scrollBg = CCScale9Sprite:create("images/common/bg/bg_ng_attr.png")
	_scrollBg:setPreferredSize(CCSizeMake(605,140))
	_scrollBg:setAnchorPoint(ccp(0.5,0))
	_scrollBg:setPosition(ccp(bottomBgSize.width/2,74))
	_bottomBg:addChild(_scrollBg)

	-- 每日奖励的
	local titleSp= CCSprite:create("images/month_card/everyday_sp.png")
	titleSp:setAnchorPoint(ccp(0.5,0.5))
	titleSp:setPosition(ccp(everyDayB:getContentSize().width/2,everyDayB:getContentSize().height/2))
	everyDayB:addChild(titleSp)

	-- 领取按钮
	local menuBar = CCMenu:create()
    menuBar:setPosition(ccp(0,0))
    menuBar:setTouchPriority(-551)
    _bottomBg:addChild(menuBar)

	_receiveItem = LuaCC.create9ScaleMenuItem("images/common/btn/btn1_d.png","images/common/btn/btn1_n.png",CCSizeMake(200, 73),GetLocalizeStringBy("key_1715"),ccc3(0xfe, 0xdb, 0x1c),35,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00))
	_receiveItem:setAnchorPoint(ccp(0.5,0))
	_receiveItem:setPosition(ccp(bottomBgSize.width/2,5))
	_receiveItem:registerScriptTapHandler(receiveCallBack )
	menuBar:addChild(_receiveItem)

	_hasReceiveItem = LuaCC.create9ScaleMenuItem("images/common/btn/btn1_g.png","images/common/btn/btn1_g.png",CCSizeMake(200, 73),GetLocalizeStringBy("key_1369"),ccc3(0xff, 0xff, 0xff),35,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00))
	--haveHad:setColor(ccc3(0xff,0xff,0xff))
	_hasReceiveItem:setAnchorPoint(ccp(0.5,0))
	_hasReceiveItem:setPosition(ccp(bottomBgSize.width/2,5))
	menuBar:addChild(_hasReceiveItem)

	local numberColor= ccc3(0x00,0xff,0x18)
	--得到月卡剩余使用天数
	if(MonthCardData.getLeftDay()<=0) then
		numberColor= ccc3(0xf0,0x02,0x01)
	end

	local buyAgainLabel= CCRenderLabel:createWithAlign(GetLocalizeStringBy("key_4028") ..MonthCardData.getVipCardData().limitTime .. GetLocalizeStringBy("key_4029") , g_sFontPangWa, 21,1, ccc3(0x00,0,0),type_stroke, CCSizeMake(140,61), kCCTextAlignmentLeft, kCCVerticalTextAlignmentBottom)
	buyAgainLabel:setAnchorPoint(ccp(0,0))
	buyAgainLabel:setColor(ccc3(0x00,0xff,0x18) )
	buyAgainLabel:setPosition(35 ,12)
	_bottomBg:addChild(buyAgainLabel)


	local leftDay_1= CCRenderLabel:create(GetLocalizeStringBy("key_4019"),  g_sFontPangWa, 21,1, ccc3(0x00,0,0),type_stroke)
	leftDay_1:setColor(ccc3(0x00,0xff,0x18))
	_leftDay_2=CCRenderLabel:create(MonthCardData.getLeftDay() ,g_sFontPangWa, 21,1, ccc3(0x00,0,0),type_stroke)
	_leftDay_2:setColor(numberColor)
	local leftDay_3=CCRenderLabel:create("/"..MonthCardData.getVipCardData().continueTime ,  g_sFontPangWa, 21,1, ccc3(0x00,0,0),type_stroke)
	leftDay_3:setColor(ccc3(0x00,0xff,0x18))

	_leftDayNode= BaseUI.createHorizontalNode({leftDay_1,_leftDay_2, leftDay_3} )
	_leftDayNode:setAnchorPoint(ccp(1,0))
	_leftDayNode:setPosition(_bottomBg:getContentSize().width-46,12)
	_bottomBg:addChild(_leftDayNode)

	-- 
	local bottomLightSp= CCSprite:create("images/month_card/light.png")
	bottomLightSp:setPosition(_layerSize.width/2, (_bottomBg:getContentSize().height -40) *_bottomBg:getScale() +_bottomBg:getPositionY() )
	bottomLightSp:setAnchorPoint(ccp(0.5,0))
	bottomLightSp:setScale(MainScene.elementScale*0.9 )
	_bgLayer:addChild(bottomLightSp)

	-- 蝴蝶
	local butterFlySp= CCSprite:create("images/month_card/butterfly.png")
	butterFlySp:setPosition(_layerSize.width/2, (_bottomBg:getContentSize().height+ 22) *_bottomBg:getScale() +_bottomBg:getPositionY())
	butterFlySp:setAnchorPoint(ccp(0.5,0))
	butterFlySp:setScale(MainScene.elementScale)
	_bgLayer:addChild(butterFlySp)


	print("MonthCardData getCanReceive is ", MonthCardData.getCanReceive())
	--判断今天是否已经领取，返回true为未领取，返回false为已领取（华仔的神逻辑）
	if(MonthCardData.getCanReceive()) then
		_receiveItem:setVisible(true)
		_hasReceiveItem:setVisible(false)
	else
		_receiveItem:setVisible(false)
		_hasReceiveItem:setVisible(true)
	end	
	
	-- 创建item和背景
	createScrollView( )

	createBuyItem()

end

--创建购买的按钮
function createBuyItem( )

	local menuBar=CCMenu:create()
	menuBar:setPosition(ccp(0,0))
	_bgLayer:addChild(menuBar,11)

		-- 立即购买按钮
	-- _buyItem = LuaCC.create9ScaleMenuItem("images/common/btn/btn_shop_n.png","images/common/btn/btn_shop_h.png",CCSizeMake(203, 85),GetLocalizeStringBy("key_4015"),ccc3(0xfe, 0xdb, 0x1c),35,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00))
	-- _buyItem:setPosition(_layerSize.width*0.5,( _bottomBg:getContentSize().height+22) *_bottomBg:getScale()+_bottomBg:getPositionY() )
	-- _buyItem:setAnchorPoint(ccp(0.5,0))
	-- _buyItem:setScale(MainScene.elementScale)
	-- _buyItem:registerScriptTapHandler(buyCallback)
	-- menuBar:addChild(_buyItem)

	-- 月卡礼包按钮
	_monthCardItem=CCMenuItemImage:create("images/month_card/month_item/month_card_n.png", "images/month_card/month_item/month_card_h.png")
	_monthCardItem:setPosition((_bottomBg:getContentSize().width- 24)*MainScene.elementScale, (_bottomBg:getContentSize().height+5)*MainScene.elementScale )
	_monthCardItem:setAnchorPoint(ccp(1,0))
	_monthCardItem:setScale(MainScene.elementScale )
	_monthCardItem:registerScriptTapHandler(monthCallBack)
	menuBar:addChild(_monthCardItem)

	local img_path = CCString:create("images/base/effect/yuekalibaoguang/yuekalibaoguang")
    local  petBottomEffect=  CCLayerSprite:layerSpriteWithNameAndCount(img_path:getCString(), -1,CCString:create(""))
    petBottomEffect:setFPS_interval(1/60.0)
    petBottomEffect:retain()
    petBottomEffect:setPosition(_monthCardItem:getContentSize().width/2, _monthCardItem:getContentSize().height/2)
    petBottomEffect:setAnchorPoint(ccp(0.5,0.5))
    _monthCardItem:addChild(petBottomEffect,-1)

end

-- 月卡推送的
function refreshAftUpdate( )
	if(_bgLayer~=nil and _leftDayNode~=nil ) then
		_leftDayNode:removeFromParentAndCleanup(true)
		_leftDayNode = nil

		local numberColor= ccc3(0x00,0xff,0x18)
		if(MonthCardData.getLeftDay()<=0) then
			numberColor= ccc3(0xf0,0x02,0x01)
		end
		-- _leftDay_2:setString("" .. MonthCardData.getLeftDay())
		-- _leftDay_2:setColor(numberColor)

		local leftDay_1= CCRenderLabel:create(GetLocalizeStringBy("key_4019"),  g_sFontPangWa, 21,1, ccc3(0x00,0,0),type_stroke)
		leftDay_1:setColor(ccc3(0x00,0xff,0x18))
		_leftDay_2=CCRenderLabel:create(MonthCardData.getLeftDay() ,g_sFontPangWa, 21,1, ccc3(0x00,0,0),type_stroke)
		_leftDay_2:setColor(numberColor)
		local leftDay_3=CCRenderLabel:create("/"..MonthCardData.getVipCardData().continueTime ,  g_sFontPangWa, 21,1, ccc3(0x00,0,0),type_stroke)
		leftDay_3:setColor(ccc3(0x00,0xff,0x18))

		_leftDayNode= BaseUI.createHorizontalNode({leftDay_1,_leftDay_2, leftDay_3} )
		_leftDayNode:setAnchorPoint(ccp(1,0))
		_leftDayNode:setPosition(_bottomBg:getContentSize().width-46,12)
		_bottomBg:addChild(_leftDayNode)
	end
end


local function onNodeEvent( event )
	if (event == "enter") then
	elseif (event == "exit") then
		--如果定时器为空不走，因为涉及到界面切换的问题
		if (_gameType ~= 0) and (_timeCounter ~= nil) then
			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(_timeCounter)
		end
	end
end

function createLayer( )
	init()
	_bgLayer  = CCLayer:create()
	_bgLayer:registerScriptHandler(onNodeEvent)

	_gameType = MonthCardData.getTypeNumber()

	require "script/ui/rechargeActive/RechargeActiveMain"
	--消息提示栏和主菜单栏显示可见，主角信息栏不可见
	MainScene.setMainSceneViewsVisible(true, false, true)
	local bulletinLayerSize = BulletinLayer.getLayerContentSize()
	local  activeMainWidth = RechargeActiveMain.getBgWidth()
	local menuLayerSize = MenuLayer.getLayerContentSize()

	_layerSize = {width= 0, height=0}
	_layerSize.width= g_winSize.width 
	_layerSize.height =g_winSize.height - (bulletinLayerSize.height+menuLayerSize.height)*g_fScaleX- activeMainWidth

	_bgLayer:setContentSize(CCSizeMake(_layerSize.width, _layerSize.height))
	_bgLayer:setPosition(ccp(0, menuLayerSize.height*g_fScaleX))

	_monthCardBg= CCScale9Sprite:create("images/month_card/purple_bottom.png")
	_monthCardBg:setContentSize(CCSizeMake(_layerSize.width, _layerSize.height))
	_monthCardBg:setScale(g_fBgScaleRatio)
	_monthCardBg:setAnchorPoint(ccp(0.5, 0))
	_monthCardBg:setPosition(ccp(_layerSize.width/2, 0))
	_bgLayer:addChild(_monthCardBg)

	createTopUI()
	
	--调用后端接口进行网络回调，回调结束后运行传入的函数
	MonthCardService.getCardInfo(function ( ... )
		createBottomUI()
		createDescUI()
		--开服7天内有月卡大礼包，所以要加入判断
		refreshDescUI()
	end )

	return _bgLayer
end



--------------------------------- 回调事件 -----------------------------
function receiveCallBack(tag, item)


	
	local function callBack(  )
		_receiveItem:setVisible(false)
		_hasReceiveItem:setVisible(true)

		local rewardTable = MonthCardData.getCardReward()
		ItemUtil.addRewardByTable(rewardTable)
		
		ReceiveReward.showRewardWindow( rewardTable)

	end

	MonthCardService.getDailyReward( callBack)

end


-- 立即购买的回调函数
function buyCallback(tag,item)
	
	local function callBack( )
		
	end

	refreshAftUpdate()

	local layer = RechargeLayer.createLayer()
	local scene = CCDirector:sharedDirector():getRunningScene()
	scene:addChild(layer,1111)
end

local function getGift( )
	print("getGift getGift getGift getGift ")

	local function callBack(  )
		local items= MonthCardData.getFirstReward()
		ReceiveReward.showRewardWindow( items)
		ItemUtil.addRewardByTable(items)
		refreshDescUI()
	end
	
	MonthCardService.getGift( callBack )
end

-- 点击月卡礼包按钮的回调函数
function monthCallBack( tag, item)
	require "script/utils/ItemTableView"
	local items= MonthCardData.getFirstReward()

	local layer = ItemTableView:create(items)	

	local taParam
	local alertContent = {}

	print("礼包状态，哎",MonthCardData.getGiftStatus())

	if MonthCardData.getGiftStatus() == 2 then
		taParam= { img_n= "images/common/btn/btn_bg_n.png" , img_h= "images/common/btn/btn_bg_h.png", size= CCSizeMake(192,61),txt= GetLocalizeStringBy("key_4016"), txtColor=ccc3(0xfe, 0xdb, 0x1c),txtSize=35,font=g_sFontPangWa,strokeSize=1, strokeColor=ccc3(0x00, 0x00, 0x00) }
		alertContent[1] = CCRenderLabel:create(GetLocalizeStringBy("key_1248") , g_sFontPangWa, 36,1, ccc3(0x00,0,0),type_stroke)
	elseif MonthCardData.getGiftStatus() == 1 then
		taParam= { img_n= "images/common/btn/btn_hui.png" , img_h= "images/common/btn/btn_hui.png", size= CCSizeMake(192,61),txt= GetLocalizeStringBy("key_4016"), txtColor=ccc3(0xff, 0xff, 0xff),txtSize=35,font=g_sFontPangWa,strokeSize=1, strokeColor=ccc3(0x00, 0x00, 0x00) }
		alertContent[1] = CCRenderLabel:create(GetLocalizeStringBy("zzh_1032") , g_sFontPangWa, 36,1, ccc3(0x00,0,0),type_stroke)
	else
		taParam= { img_n= "images/common/btn/btn_hui.png" , img_h= "images/common/btn/btn_hui.png", size= CCSizeMake(192,61),txt= GetLocalizeStringBy("key_1369"), txtColor=ccc3(0xff, 0xff, 0xff),txtSize=35,font=g_sFontPangWa,strokeSize=1, strokeColor=ccc3(0x00, 0x00, 0x00) }
		alertContent[1] = CCRenderLabel:create(GetLocalizeStringBy("zzh_1032") , g_sFontPangWa, 36,1, ccc3(0x00,0,0),type_stroke)
	end
	layer:addSureBtn(taParam)
	layer:registerScriptSureEvent(getGift)
	alertContent[1]:setColor(ccc3(0xff, 0xc0, 0x00))
	local alert = BaseUI.createHorizontalNode(alertContent)
	layer:setContentTitle(alert)

	local scene= CCDirector:sharedDirector():getRunningScene()
	scene:addChild(layer, 560)
end

function refreshRemainTime()
	_remainTimeLabel:setString(MonthCardData.remainTimeFormat(_gameType))
end