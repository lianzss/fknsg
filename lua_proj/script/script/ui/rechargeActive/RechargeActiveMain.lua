-- Filename：	RechargeActiveMain.lua
-- Author：		chao he
-- Date：		2013-8-3
-- Purpose：		活动


module ("RechargeActiveMain", package.seeall)

require "script/network/RequestCenter"
require "script/ui/rechargeActive/FirstPackLayer"
require "script/ui/rechargeActive/GrowthFundLayer"
require "script/ui/rechargeActive/ActiveCache"
require "script/ui/rechargeActive/RestoreEnergyLayer"
require "script/ui/rechargeActive/GrowthFundLayer"
require "script/ui/rechargeActive/MysteryShopLayer"
require "script/model/DataCache"
require "script/model/utils/ActivityConfigUtil"
require "script/ui/digCowry/DigCowryLayer"	
require "script/ui/digCowry/DigCowryData"	
require "script/ui/login/ServerList"
require "script/ui/rechargeActive/CardPackActiveLayer"
require "script/ui/rechargeActive/ConsumeLayer"
require "script/ui/rechargeActive/NewYearLayer"
require "script/ui/rechargeActive/RechargeFeedbackCache"
require "script/ui/rechargeActive/RechargeFeedbackLayer"
require "script/ui/rechargeActive/ChangeActiveLayer"
require "script/ui/rechargeActive/TuanLayer"
require "script/ui/tip/AnimationTip"
require "script/ui/mergeServer/accumulate/AccumulateData"


_ksTagMainMenu 		= 1001
_tagShowChong 		= 101
_tagChengzhang 		= 102
_tagEatChieken 		= 103	-- 整点送体力，吃鸡
_tagMysteryShop		= 104
_tagCardActive 		= 105	-- 活动卡包
_tagConsume    		= 106	-- 消费累积
_tagChargeReward 	= 107	-- 充值回馈
_tagNewYear 	 	= 108   -- 新年礼包		
_tagWabao 			= 109   -- 挖宝
_tagBenefit			= 110
_tagVIPBenefit		= 111
_tagMysteryMerchant = 112	-- 神秘商人
_tagChange 			= 113   -- 兑换
_tagTuan 			= 114 	-- 团购
_tagChargeRaffle	= 115	-- 充值抽奖
_tagMonthCard		= 116	-- 月卡
_tagTopupReward		= 117	-- 充值大放送(名字源于后端，虽然用chargeBigRun更适合些),added by Zhang Zihang
_tagTransfer        = 118   -- 武将变身
_tagStepCounter 	= 119 	-- 计步活动
_tagMergeAccumulate = 120 	--合服累积登陆
_tagMergeRecharge 	= 121 	--合服消费累积

local _ksTagActivityNewIn = 1001  -- 新活动开启时的，提示图片  

local _tagArray		= {}	-- 用来存放tag的数组	
local _curTagIndex	= 1		-- 当前_tagArray 的index
local defaultIndex 	= nil
local _defaultBg	= nil
local count			= 0		 -- 活动数量

local bgLayer 
local _buttomLayer	= nil
local topBgSp
local scrollView
local mainMenu
local oldTag = 0

--福利活动红圈剩余次数
local numLabel

local function init( )
	bgLayer= nil
	_buttomLayer= nil
	topBgSp= nil
	scrollView= nil
	mainMenu= nil
	oldTag = 0
	_tagArray= {}
	_curTagIndex =1

	numLabel = nil
end

function onTouchesHandler( eventType, x, y )
	if(eventType == "began") then
		print("( eventType" , eventType)
		_touchBeganPoint = ccp(x, y)
		return true
	elseif(eventType == "moved") then
		-- local xOffset= x- _touchBeganPoint.x
		-- local curTag=1
		-- local nextLayer= nil
		-- if(xOffset >0) then
		-- else
			
		-- end
	else

	end
end

-- 开始创建UI
function create( index )
	init()
	count = 0
	defaultIndex = index

	MainScene.getAvatarLayerObj():setVisible(false)
	MainScene.setMainSceneViewsVisible(true, false, true)

	bgLayer = CCLayer:create()
	bgLayer:setPosition(ccp(0,0))
	-- bgLayer:setContentSize(CCSizeMake(640,804))

	local bgLayerSize = bgLayer:getContentSize()

	-- 默认背景
	_defaultBg = CCSprite:create("images/recharge/fund/fund_bg.png")
	bgLayer:addChild(_defaultBg)
	_defaultBg:setScale(MainScene.bgScale)

	
	--背景	
	local winHeight = CCDirector:sharedDirector():getWinSize().height
	topBgSp = CCSprite:create("images/formation/topbg.png")
	-- local myScale = bgLayer:getContentSize().width/topBgSp:getContentSize().width/bgLayer:getElementScale()
	topBgSp:setAnchorPoint(ccp(0.5,1))
	topBgSp:setPosition(ccp(CCDirector:sharedDirector():getWinSize().width/2, winHeight - BulletinLayer.getLayerHeight()*g_fScaleX))
	bgLayer:addChild(topBgSp, 99)
	topBgSp:setScale(g_fScaleX)

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
	rightBtn:setAnchorPoint(ccp(0.5, 0.5))
	rightBtn:setPosition(ccp(topBgSp:getContentSize().width*0.94, topBgSp:getContentSize().height/2))
	topMenuBar:addChild(rightBtn, 10002, 10002)

	-- createScrollView()
	_buttomLayer = CCLayer:create()
	_buttomLayer:setPosition(ccp(0,0))
	_buttomLayer:registerScriptTouchHandler(onTouchesHandler)
	_buttomLayer:setTouchEnabled(true)
	bgLayer:addChild(_buttomLayer)

	getNetData()

	--  test by zhz
	-- local layer = FirstPackLayer.createLayer()
	-- bgLayer:addChild(layer)

	return bgLayer
end

--[[
	@desc	活动图标
	@para 	none
	@return void
--]]
local function createScrollView( ... )
	print("createScrollView")
	if( scrollView~= nil ) then
		scrollView:removeFromParentAndCleanup(true)
		scrollView=nil
		--topBgSp:removeChildByTag(2000,true)
	end

	local width = 513
	scrollView = CCScrollView:create()
    scrollView:setContentSize(CCSizeMake(width, topBgSp:getContentSize().height))
    scrollView:setViewSize(CCSizeMake(513, topBgSp:getContentSize().height))
    scrollView:setPosition(66,0)
    scrollView:setTouchPriority(-400)
    scrollView:setDirection(kCCScrollViewDirectionHorizontal)
    scrollView:setContentOffset(ccp(0,0))
    topBgSp:addChild(scrollView,1,2000)

    mainMenu = BTMenu:create()
	mainMenu:setPosition(0,0)
	-- mainMenu:setTouchPriority(-299)
	mainMenu:setScrollView(scrollView)
	scrollView:addChild(mainMenu,1 , _ksTagMainMenu)
	mainMenu:setStyle(kMenuRadio)
	local  POTENTIAL_Base = "images/bag/gift/30001.png"
	local count = 0
	local firstItem = nil


	local activeTable = {

		{
			activity_name = GetLocalizeStringBy("key_1022"), 
			img= {images_n = "images/recharge/btn_shouchong1.png", images_h = "images/recharge/btn_shouchong2.png",},
			tag= _tagShowChong,
			note_data= {
				isActivity= false,
				isOpen= _boolCharge,
				hasTip= false,
				
			},

		},

		{
			activity_name = GetLocalizeStringBy("key_2485"), 
			img= {images_n = "images/recharge/btn_jihua1.png", images_h = "images/recharge/btn_jihua2.png" ,},
			tag= _tagChengzhang,
			note_data= {
				isActivity= false,
				isOpen= _boolGrowUp,
				hasTip= false,
				tipSprite= getTipSprite(),
			},

		},

		-- 烧鸡
		{
			activity_name = GetLocalizeStringBy("key_1850"), 
			img= {images_n = "images/recharge/btn_chicken1.png", images_h ="images/recharge/btn_chicken2.png",},
			tag= _tagEatChieken,
			note_data= {
				isActivity= false,
				isOpen= true,
				hasTip= ActiveCache.isOnTime(),
				-- tipSprite= getTipSprite(),
			}

		},

		-- 福利活动
		{
			activity_name = GetLocalizeStringBy("key_2971"), 
			img= {images_n = "images/recharge/benefit_active/benefit_n.png", images_h ="images/recharge/benefit_active/benefit_h.png",},
			tag= _tagBenefit,
			note_data= {
				isActivity= true,
				isOpen= ActivityConfigUtil.isActivityOpen("weal"),
				-- tipSprite= getTipSprite(),
				hasTip = ActiveCache.isHaveCardNum(),
				key= "weal"
			},

		},

		-- 神秘商店
		{
			activity_name = GetLocalizeStringBy("key_1063"), 
			img= {images_n = "images/recharge/mystery_shop/shop_n.png", images_h ="images/recharge/mystery_shop/shop_h.png",},
			tag= _tagMysteryShop,
			note_data= {
				isActivity= false,
				isOpen= true,
				hasTip= ActiveCache.isMysteryNewIn(),
				-- tipSprite= getTipSprite(),
			},

		},

		-- VIP福利
		{
			activity_name = GetLocalizeStringBy("key_3415"),
			img = {images_n = "images/recharge/vip_benefit/vipB_n.png", images_h = "images/recharge/vip_benefit/vipB_h.png"},
			tag = _tagVIPBenefit,
			note_data = {
				isActivity = false,
				isOpen = ActiveCache.isOpenVIPBenefit(),
				hasTip = ActiveCache.isHaveVIPBenefit(),
			}

		},

		-- 活动卡包
		{
			activity_name = GetLocalizeStringBy("key_1149"), 
			img= {images_n ="images/recharge/card_active/btn_card/btn_card_n.png", images_h ="images/recharge/card_active/btn_card/btn_card_h.png",},
			tag= _tagCardActive,
			note_data= {
				isActivity= true,
				isOpen=  ActiveCache.isCardActiveOpen(),
				hasTip= false,--ActiveCache.getIsNewActivity("heroShop"),
				key= "heroShop"
				
			},

		},

		-- 消费累积
		{
			activity_name = GetLocalizeStringBy("key_2802"), 
			img= {images_n ="images/recharge/consume_n.png", images_h ="images/recharge/consume_h.png",},
			tag= _tagConsume,
			note_data= {
				isActivity= true,
				isOpen=  ConsumeLayer.isOpenConsume(),
				hasTip=false, --ActiveCache.getIsNewActivity("spend"),
				key= "spend",
			},
		},

		-- 新年礼包
		{
			activity_name = GetLocalizeStringBy("key_2796"), 
			img= {images_n ="images/recharge/newyear_n.png", images_h = "images/recharge/newyear_h.png",},
			tag= _tagNewYear,
			note_data= {
				isActivity= true,
				isOpen=  NewYearLayer.isOpenNewYear(),
				hasTip= false, --ActiveCache.getIsNewActivity("signActivity"),
				key="signActivity"
			},

		},

		-- 挖宝
		{
			activity_name = GetLocalizeStringBy("key_2011"), 
			img= {images_n ="images/digCowry/dig_icon_n.png", images_h = "images/digCowry/dig_icon_h.png",},
			tag= _tagWabao,
			note_data= {
				isActivity= true,
				isOpen=  DigCowryData.isDigcowryOpen(),
				hasTip=false ,--ActiveCache.getIsNewActivity("signActivity"),
				key= "robTomb"
			},

		},

		-- 充值回馈
		{
			activity_name = GetLocalizeStringBy("key_2055"), 
			img= {images_n ="images/recharge/feedback_active/btn_n.png", images_h = "images/recharge/feedback_active/btn_h.png",},
			tag= _tagChargeReward,
			note_data= {
				isActivity= true,
				isOpen=  RechargeFeedbackCache.isFeedbackOpen(),
				hasTip= false ,--ActiveCache.getIsNewActivity("topupFund"),
				key= "topupFund"
			},

		},
		--- added by bzx ，神秘商人 ，（这个不是活动， isActivity 应是false
		{
			activity_name = GetLocalizeStringBy("key_1242"),
			img = {images_n = "images/recharge/btn_mystery_merchant1.png",images_h = "images/recharge/btn_mystery_merchant2.png"},
			tag = _tagMysteryMerchant,
			note_data = {
				isActivity = false,
				isOpen = true,--ActiveCache.MysteryMerchant:isExist(),
				hasTip = ActiveCache.MysteryMerchant:isRefreshed(),
				-- tipSprite= getTipSprite(),
			},
		},
		
		-- added by licong 兑换活动 ， 
		{	
			activity_name = GetLocalizeStringBy("lic_1006"),
			img = {
				-- 限时兑换图标
				images_n,images_h = getExchangeActiveIcon()
			},
			tag = _tagChange,
			note_data = {
				isActivity = true,
				isOpen = ActivityConfigUtil.isActivityOpen("actExchange"),
				hasTip = false,
				key= "actExchange"
			},
		},
		-- 团购活动
		{	
			activity_name = GetLocalizeStringBy("lic_1013"),
			img = {
				images_n = "images/recharge/tuan_n.png",
				images_h = "images/recharge/tuan_h.png"
			},
			tag = _tagTuan,
			note_data = {
				isActivity = true,
				isOpen = ActivityConfigUtil.isActivityOpen("groupon"),
				hasTip = false,
				key= "groupon"
			},
		},


		-- 月卡
		{	
			activity_name = GetLocalizeStringBy("key_4014"),
			img = {
				images_n = "images/recharge/month_card_n.png",
				images_h = "images/recharge/month_card_h.png"
			},
			tag = _tagMonthCard,
			note_data = {
				isActivity = false,
				isOpen = true, --BTUtil:isAppStore(),
				hasTip = false,
				-- key= "groupon"
			},
		},

		-- 充值抽奖
		{	
			activity_name = GetLocalizeStringBy("lic_1013"),
			img = {
				images_n = "images/recharge/chargeRaffle_n.png",
				images_h = "images/recharge/chargeRaffle_h.png"
			},
			tag = _tagChargeRaffle,
			note_data = {
				isActivity = true,
				isOpen = ActivityConfigUtil.isActivityOpen("chargeRaffle"),
				hasTip = false,
				key= "chargeRaffle"
			},
		},

		--充值大放送
		--added by Zhang Zihang
		{	
			activity_name = GetLocalizeStringBy("zzh_1016"),
			img = {
				images_n = "images/recharge/rechargeBigRun/bigRun_n.png",
				images_h = "images/recharge/rechargeBigRun/bigRun_h.png"
			},
			tag = _tagTopupReward,
			note_data = {
				isActivity = true,
				isOpen = ActivityConfigUtil.isActivityOpen("topupReward"),
				hasTip = false,
				key= "topupReward"
			},
		},

		--计步活动
		--added by Zhang Zihang
		{
			activity_name = GetLocalizeStringBy("zzh_1140"),
			img = {
				images_n = "images/recharge/stepCounter/step_n.png",
				images_h = "images/recharge/stepCounter/step_h.png"
			},
			tag = _tagStepCounter,
			note_data = {
				isActivity = true,
				isOpen = ActivityConfigUtil.isActivityOpen("stepCounter"),
				hasTip = false,
				key = "stepCounter"
			},
		},
        
        -- added by bzx
        {
            activity_name = "武将变身",
            img = {
                images_n = "images/recharge/btn_transfer_n.png",
				images_h = "images/recharge/btn_transfer_h.png"
            },
            tag = _tagTransfer,
            note_data = {
                isActivity = true,
				isOpen = DataCache.getSwitchNodeState(ksTransfer,false),
				hasTip = false,
				key= "transfer"
            }
        },

        --合服登陆累积活动
        --added by Zhang Zihang
        {
        	activity_name = GetLocalizeStringBy("zzh_1157"),
        	img = {
        		images_n = "images/mergeServer/accumulate/accumulate_n.png",
        		images_h = "images/mergeServer/accumulate/accumulate_h.png"
        	},
        	tag = _tagMergeAccumulate,
        	note_data = {
        		isActivity = true,
        		isOpen = AccumulateData.isMergeActivityOpen("mergeAccumulate"),
        		hasTip = false,
        		key = "mergeAccumulate"
        	}
    	},

    	--合服充值回馈活动
    	--added by Zhang Zihang
    	{
    		activity_name = GetLocalizeStringBy("zzh_1158"),
    		img = {
    			images_n = "images/mergeServer/accumulate/recharge_n.png",
    			images_h = "images/mergeServer/accumulate/recharge_h.png"
  	  		},
  	  		tag = _tagMergeRecharge,
  	  		note_data = {
  	  			isActivity = true,
  	  			isOpen = AccumulateData.isMergeActivityOpen("mergeRecharge"),
  	  			hasTip = false,
  	  			key = "mergeRecharge"
  	  		}
   		},
		----------------------------------------------
	}



	for i=1, #activeTable do
		if( activeTable[i].note_data.isOpen ) then
			local menuItem = CCMenuItemImage:create(activeTable[i].img.images_n , activeTable[i].img.images_h)
			mainMenu:addChild(menuItem)
			menuItem:setAnchorPoint(ccp(0,0.5))
			menuItem:setPosition(ccp(120*count , scrollView:getContentSize().height/2))
			menuItem:registerScriptTapHandler(touchButton)
			menuItem:setTag(activeTable[i].tag )
			-- 把对应的tag，加到_tagArrayshang
			-- table.insert( _tagArray,activeTable[i].tag)
			-- local layer= getLayerByTag(activeTable[i].tag)
			--
			print("activeTable[i].note_data.hasTip and name  is " , activeTable[i].note_data.hasTip,activeTable[i].activity_name )
			if(activeTable[i].note_data.hasTip) then
				local tipSprite=nil
				local activeName = activeTable[i].activity_name
				-- if(activeTable[i].note_data.isActivity and (tostring(activeName) ~= GetLocalizeStringBy("key_2971"))) then
					-- tipSprite= getNewTip()
					-- tipSprite:setPosition(menuItem:getContentSize().width*0.6,menuItem:getContentSize().height-10)
				-- else
				if activeTable[i].note_data.isActivity and tostring(activeTable[i].activity_name) == GetLocalizeStringBy("key_2971") then
					tipSprite = getTipSpriteWithNum()
				else
					tipSprite= getTipSprite()
				end
				tipSprite:setAnchorPoint(ccp(1,1))
				tipSprite:setPosition(menuItem:getContentSize().width*0.98,menuItem:getContentSize().height*0.98)
				-- end
				menuItem:addChild(tipSprite,1, 101)		
			end

			if( activeTable[i].note_data.isActivity and ActiveCache.IsNewInActivityByKey( activeTable[i].note_data.key ) ) then
				local newInTip= getNewTip()
				newInTip:setPosition(menuItem:getContentSize().width*0.75,menuItem:getContentSize().height*0.8)
				menuItem:addChild(newInTip,1, _ksTagActivityNewIn)	
			end
			
			count = count + 1
			if(firstItem == nil)then
				firstItem = menuItem
			end
		end 
	end

	print("defaultIndex = ",defaultIndex)
	if(defaultIndex)then
		local menuItem = tolua.cast(mainMenu:getChildByTag(defaultIndex),"CCMenuItemImage") 
		menuItem:selected()
		touchButton(menuItem:getTag())
		updateScrollViewContainerPosition(menuItem,0.1)
	elseif(firstItem ~= nil)then
		print("+===== =================  ")
		firstItem:selected()
		touchButton(firstItem:getTag())
	end
	if(count >= 4)then
        print("count > 3")
    	scrollView:setContentSize(CCSizeMake(120 * count,  topBgSp:getContentSize().height))
    end
end

--[[
	@des:	更新scrollView位置
]]
function updateScrollViewContainerPosition( selectNode,time)

	local posX = selectNode:getPositionX() - scrollView:getViewSize().width/2
	local lnx,px,vw = 0,selectNode:getPositionX(),scrollView:getViewSize().width
	if(px+ selectNode:getContentSize().width< vw ) then
		lnx = 0
	else
		lnx = px - vw*0.5 + selectNode:getContentSize().width/2
		if(lnx > px + selectNode:getContentSize().width  - vw) then
			lnx = px + selectNode:getContentSize().width - vw
		end
	end
	scrollView:setContentOffsetInDuration(ccp(-lnx, 0), time or 0.5)
end

-- 得到
function getTipSprite(  )
	local tipSprite= CCSprite:create("images/common/tip_2.png")
	local numLabel = CCLabelTTF:create("1",g_sFontName, 21)
	numLabel:setPosition(ccp(tipSprite:getContentSize().width/2,tipSprite:getContentSize().height/2))
	numLabel:setAnchorPoint(ccp(0.5,0.5))
	tipSprite:addChild(numLabel)
	return tipSprite
end

function getTipSpriteWithNum()
	local tipSprite= CCSprite:create("images/common/tip_2.png")
	require "script/ui/rechargeActive/BenefitActiveLayer"

	local accountNum = tonumber(BenefitActiveLayer.getAccountNum())
	local cardRate = tonumber(BenefitActiveLayer.getCostNum())
	local cardNum = math.floor(accountNum/cardRate)
	numLabel = CCLabelTTF:create(cardNum,g_sFontName, 21)
	numLabel:setPosition(ccp(tipSprite:getContentSize().width/2,tipSprite:getContentSize().height/2))
	numLabel:setAnchorPoint(ccp(0.5,0.5))
	tipSprite:addChild(numLabel)
	return tipSprite
end

function getNewTip( )

	local newAnimSprite = CCLayerSprite:layerSpriteWithName(CCString:create("images/mail/new/new"), -1,CCString:create(""));
	return newAnimSprite
end

-- 刷新提示的小红圈
function refreshItemByTag( tag )
	-- local mainMenu = scrollView:getChildByTag(_ksTagMainMenu)
	local item = tolua.cast(mainMenu:getChildByTag(tag), "CCMenuItemImage")
	local tipSprite= tolua.cast(item:getChildByTag(101), "CCSprite" )
	if(tipSprite) then
		tipSprite:removeFromParentAndCleanup(true)
		tipSprite=nil
	end
end

-- 刷新新活动开启的提示
function rfcNewTipByTag( tag )
	local item = tolua.cast(mainMenu:getChildByTag(tag), "CCMenuItemImage")
	local newInSprite= tolua.cast(item:getChildByTag(_ksTagActivityNewIn), "CCSprite" )
	if(newInSprite) then
		newInSprite:removeFromParentAndCleanup(true)
		newInSprite=nil
	end
end



function changeButtomLayer(layer)
	_buttomLayer:removeAllChildrenWithCleanup(true)
	_buttomLayer:addChild(layer)
end


function touchButton( tag )
	if(oldTag == tag)then
		return
	end
	oldTag = tag

	if(tag == _tagShowChong)then
		--显示首冲活动
		local layer = FirstPackLayer.createLayer()
		changeButtomLayer(layer)

	elseif(tag == _tagChengzhang)then
		--显示成长基金
		local layer = GrowthFundLayer.createLayer()
		changeButtomLayer(layer)
	elseif(tag == _tagEatChieken) then
		local layer = RestoreEnergyLayer.createLayer()
		changeButtomLayer(layer)
	elseif(tag== _tagMysteryShop) then
		if(DataCache.getSwitchNodeState(ksSwitchResolve,true)) then
			if( ActiveCache.isMysteryNewIn() ) then
				-- AnimationTip.showTip(GetLocalizeStringBy("key_2617"))
			end
			local layer= MysteryShopLayer.createLayer()
			changeButtomLayer(layer)
		end
	elseif(tag== _tagCardActive) then
		if( BTUtil:getSvrTimeInterval()<ActiveCache.getHeroShopStartTime() or BTUtil:getSvrTimeInterval() > ActiveCache.getHeroShopEndTime()+ ActiveCache.getCardData().coseTime ) then
			AnimationTip.showTip(GetLocalizeStringBy("key_1857"))
			return
		end	
		if(ActiveCache.getHeroShopOpenTime() < tonumber(ServerList.getSelectServerInfo().openDateTime) ) then
			AnimationTip.showTip(GetLocalizeStringBy("key_2586"))
			return
		end

		if(UserModel.getHeroLevel() < 25) then
			AnimationTip.showTip(GetLocalizeStringBy("key_2975"))
			return
		end
		local layer= CardPackActiveLayer.createLayer()
		changeButtomLayer(layer)

		--
		refreshItemByTag(_tagCardActive)
		rfcNewTipByTag(_tagCardActive)
		ActiveCache.setActivityStatusByKey("heroShop")


	elseif( tag == _tagConsume)then
		if( BTUtil:getSvrTimeInterval()<ActiveCache.getSpendStartTime() or BTUtil:getSvrTimeInterval() > ActiveCache.getSpendEndTime()) then
			AnimationTip.showTip(GetLocalizeStringBy("key_1857"))
			return
		end	
		if(ActiveCache.getSpendOpenTime() < tonumber(ServerList.getSelectServerInfo().openDateTime) ) then
			AnimationTip.showTip(GetLocalizeStringBy("key_2586"))
			return
		end
		-- 消费累积
		local layer= ConsumeLayer.createConsumeLayer()
		changeButtomLayer(layer)

		refreshItemByTag(_tagConsume)
		rfcNewTipByTag(_tagConsume)
		ActiveCache.setActivityStatusByKey("spend")

	elseif(tag == _tagChargeReward ) then
		-- 充值回馈
		if( BTUtil:getSvrTimeInterval()<RechargeFeedbackCache.getFeedbackStartTime() or BTUtil:getSvrTimeInterval() > RechargeFeedbackCache.getFeedbackEndTime() ) then
			AnimationTip.showTip(GetLocalizeStringBy("key_1857"))
			return
		end	
		if(RechargeFeedbackCache.getFeedbackOpenTime() < tonumber(ServerList.getSelectServerInfo().openDateTime) ) then
			AnimationTip.showTip(GetLocalizeStringBy("key_2586"))
			return
		end
		-- 充值回馈
		local layer= RechargeFeedbackLayer.createLayer()
		changeButtomLayer(layer)

		refreshItemByTag(_tagChargeReward)
		rfcNewTipByTag(_tagChargeReward)
		ActiveCache.setActivityStatusByKey("topupFund")

	elseif( tag == _tagNewYear)then
		if( BTUtil:getSvrTimeInterval()<ActiveCache.getNewYearStartTime() or BTUtil:getSvrTimeInterval() > ActiveCache.getNewYearEndTime()) then
			AnimationTip.showTip(GetLocalizeStringBy("key_1857"))
			return
		end	
		if(ActiveCache.getNewYearOpenTime() < tonumber(ServerList.getSelectServerInfo().openDateTime) ) then
			AnimationTip.showTip(GetLocalizeStringBy("key_2586"))
			return
		end
		-- 新年礼包
		local layer= NewYearLayer.createNewYearLayer()
		changeButtomLayer(layer)

		refreshItemByTag(_tagNewYear)
		rfcNewTipByTag(_tagNewYear)
		ActiveCache.setActivityStatusByKey("signActivity")

	elseif( tag == _tagWabao) then
		print("wabao")
		--等级限制
		local nowTime = BTUtil:getSvrTimeInterval()
	    local endTime = ActivityConfig.ConfigCache.robTomb.end_time
	    local beginTime = ActivityConfig.ConfigCache.robTomb.start_time
	    if(nowTime < beginTime) or (nowTime > endTime) then
	    	AnimationTip.showTip(GetLocalizeStringBy("key_1857"))
			return
		end
		local level = ActivityConfig.ConfigCache.robTomb.data[1].levelLimit
		if(tonumber(level) > UserModel.getHeroLevel()) then
			AnimationTip.showTip(GetLocalizeStringBy("key_1856")..level..GetLocalizeStringBy("key_1287"))
			return
		end
		
		local layer = DigCowryLayer:createDigCowry()
		changeButtomLayer(layer)
		refreshItemByTag(_tagWabao)

		rfcNewTipByTag(_tagWabao)
		ActiveCache.setActivityStatusByKey("robTomb")
	
	elseif( tag== _tagBenefit) then
		---- 福利活动
		if(ActivityConfigUtil.isActivityOpen("weal") ) then
			require "script/ui/rechargeActive/BenefitActiveLayer"
			local layer = BenefitActiveLayer.createLayer()
			changeButtomLayer(layer)

			rfcNewTipByTag(_tagBenefit)
			ActiveCache.setActivityStatusByKey("weal")

		else
			AnimationTip.showTip(GetLocalizeStringBy("key_1857"))
			return
		end
        ----------------------------------------- added by bzx
	elseif(tag == _tagMysteryMerchant) then
        require "script/ui/rechargeActive/MysteryMerchantLayer"
        local getShopInfoSucceed = function()
            if ActiveCache.MysteryMerchant:isRefreshed() then
                AnimationTip.showTip(GetLocalizeStringBy("key_2799"))
            end
            local layer = MysteryMerchantLayer.createLayer()
            changeButtomLayer(layer)
            refreshItemByTag(_tagMysteryMerchant)
        end
        ActiveCache.MysteryMerchant:requestData(getShopInfoSucceed)
        -----------------------------------------
	elseif (tag == _tagVIPBenefit) then
		require "script/ui/vip_benefit/VIPBenefitLayer"
		local layer = VIPBenefitLayer.createLayer()
		changeButtomLayer(layer)
		refreshItemByTag(_tagVIPBenefit)


	elseif(tag == _tagChange)then
		-- 兑换
		if( BTUtil:getSvrTimeInterval()<tonumber(ActivityConfig.ConfigCache.actExchange.start_time) or BTUtil:getSvrTimeInterval() > tonumber(ActivityConfig.ConfigCache.actExchange.end_time) ) then
			AnimationTip.showTip(GetLocalizeStringBy("key_1857"))
			return
		end	
		if(tonumber(ActivityConfig.ConfigCache.actExchange.need_open_time) < tonumber(ServerList.getSelectServerInfo().openDateTime) ) then
			AnimationTip.showTip(GetLocalizeStringBy("key_2586"))
			return
		end
		-- 等级限制
		local level = ActiveCache.getChangeOpenLv() 
		if(tonumber(level) > UserModel.getHeroLevel()) then
			AnimationTip.showTip(GetLocalizeStringBy("key_1856")..level..GetLocalizeStringBy("key_1287"))
			return
		end
		local layer= ChangeActiveLayer.createChangeLayer()
		changeButtomLayer(layer)

		rfcNewTipByTag(_tagChange)
		ActiveCache.setActivityStatusByKey("actExchange")

	elseif(tag == _tagTuan)then
		-- 团购
		if( BTUtil:getSvrTimeInterval()<tonumber(ActivityConfig.ConfigCache.groupon.start_time) or BTUtil:getSvrTimeInterval() > tonumber(ActivityConfig.ConfigCache.groupon.end_time) ) then
			AnimationTip.showTip(GetLocalizeStringBy("key_1857"))
			return
		end	
		if(tonumber(ActivityConfig.ConfigCache.groupon.need_open_time) < tonumber(ServerList.getSelectServerInfo().openDateTime) ) then
			AnimationTip.showTip(GetLocalizeStringBy("key_2586"))
			return
		end

		local layer= TuanLayer.createTuanLayer()
		changeButtomLayer(layer)

		rfcNewTipByTag(_tagTuan)
		ActiveCache.setActivityStatusByKey("groupon")

	elseif(tag == _tagChargeRaffle)then
		--充值抽奖
		require "script/ui/rechargeActive/chargeRaffle/ChargeRaffleLayer"
		local  layer = ChargeRaffleLayer.create()
		changeButtomLayer(layer)

		rfcNewTipByTag(_tagChargeRaffle)
		ActiveCache.setActivityStatusByKey("chargeRaffle")

	elseif(tag== _tagMonthCard) then
		-- 月卡
		-- print(" monthcard  ==================== ")
		require "script/ui/month_card/MonthCardLayer"
		local layer= MonthCardLayer.createLayer()
		changeButtomLayer(layer)
	--充值大放送
	--added by Zhang Zihang
	elseif(tag == _tagTopupReward)then
		require "script/ui/rechargeActive/rechargeBigRun/RechargeBigRunLayer"
		local layer = RechargeBigRunLayer.createLayer()
		changeButtomLayer(layer)

		rfcNewTipByTag(_tagTopupReward)
		ActiveCache.setActivityStatusByKey("topupReward")

	--￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥用钱砸出来的分割线￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥￥	
	--计步活动
	--added by Zhang Zihang
	elseif tag == _tagStepCounter then
		require "script/ui/rechargeActive/stepCounterActive/StepCounterLayer"
		local layer = StepCounterLayer.createLayer()
		changeButtomLayer(layer)

		rfcNewTipByTag(_tagStepCounter)
		ActiveCache.setActivityStatusByKey("stepCounter")
	-- added by bzx
    elseif tag == _tagTransfer then
        -- test
        --require "script/utils/ModuleUtil"
        --ModuleUtil.cleanupModuleByName("TransferLayer")
        require "script/ui/rechargeActive/transfer/TransferLayer"
        local layer = TransferLayer.create()
        changeButtomLayer(layer)
        rfcNewTipByTag(_tagTransfer)
        ActiveCache.setActivityStatusByKey("transfer")
    --合服累计登陆
    --added by Zhang Zihang
    elseif tag == _tagMergeAccumulate then
    	require "script/ui/mergeServer/accumulate/AccumulateActivity"
		changeButtomLayer(AccumulateActivity.createLayer(1))
		rfcNewTipByTag(_tagMergeAccumulate)
        ActiveCache.setActivityStatusByKey("mergeAccumulate")
	--合服消费累积
	--added by Zhang Zihang
    elseif tag == _tagMergeRecharge then
    	require "script/ui/mergeServer/accumulate/AccumulateActivity"
		changeButtomLayer(AccumulateActivity.createLayer(2))
		rfcNewTipByTag(_tagMergeRecharge)
        ActiveCache.setActivityStatusByKey("mergeRecharge")
    end
end


function getLayerByTag(tag )

	if(oldTag == tag)then
		return
	end
	oldTag = tag

	if(tag == _tagShowChong)then
		--显示首冲活动
		local layer = FirstPackLayer.createLayer()
		return layer

	elseif(tag == _tagChengzhang)then
		--显示成长基金
		local layer = GrowthFundLayer.createLayer()
		return layer
	elseif(tag == _tagEatChieken) then
		local layer = RestoreEnergyLayer.createLayer()
		return layer
	elseif(tag== _tagMysteryShop) then
		if(DataCache.getSwitchNodeState(ksSwitchResolve,true)) then
			if( ActiveCache.isMysteryNewIn() ) then
				AnimationTip.showTip(GetLocalizeStringBy("key_2617"))
			end
			local layer= MysteryShopLayer.createLayer()
			return layer
		end
	elseif(tag== _tagCardActive) then
		if( BTUtil:getSvrTimeInterval()<ActiveCache.getHeroShopStartTime() or BTUtil:getSvrTimeInterval() > ActiveCache.getHeroShopEndTime()+ ActiveCache.getCardData().coseTime ) then
			AnimationTip.showTip(GetLocalizeStringBy("key_1857"))
			return
		end	
		if(ActiveCache.getHeroShopOpenTime() < tonumber(ServerList.getSelectServerInfo().openDateTime) ) then
			AnimationTip.showTip(GetLocalizeStringBy("key_2586"))
			return
		end

		if(UserModel.getHeroLevel() < 25) then
			AnimationTip.showTip(GetLocalizeStringBy("key_2975"))
			return
		end

		local layer= CardPackActiveLayer.createLayer()
		return layer	
	elseif( tag == _tagConsume)then
		if( BTUtil:getSvrTimeInterval()<ActiveCache.getSpendStartTime() or BTUtil:getSvrTimeInterval() > ActiveCache.getSpendEndTime()) then
			AnimationTip.showTip(GetLocalizeStringBy("key_1857"))
			return
		end	
		if(ActiveCache.getSpendOpenTime() < tonumber(ServerList.getSelectServerInfo().openDateTime) ) then
			AnimationTip.showTip(GetLocalizeStringBy("key_2586"))
			return
		end
		-- 消费累积
		local layer= ConsumeLayer.createConsumeLayer()
		changeButtomLayer(layer)
	elseif(tag == _tagChargeReward ) then
		-- 充值回馈
		if( BTUtil:getSvrTimeInterval()<RechargeFeedbackCache.getFeedbackStartTime() or BTUtil:getSvrTimeInterval() > RechargeFeedbackCache.getFeedbackEndTime() ) then
			AnimationTip.showTip(GetLocalizeStringBy("key_1857"))
			return
		end	
		if(RechargeFeedbackCache.getFeedbackOpenTime() < tonumber(ServerList.getSelectServerInfo().openDateTime) ) then
			AnimationTip.showTip(GetLocalizeStringBy("key_2586"))
			return
		end
		-- 充值回馈
		local layer= RechargeFeedbackLayer.createLayer()
		return layer
	elseif( tag == _tagNewYear)then
		if( BTUtil:getSvrTimeInterval()<ActiveCache.getNewYearStartTime() or BTUtil:getSvrTimeInterval() > ActiveCache.getNewYearEndTime()) then
			AnimationTip.showTip(GetLocalizeStringBy("key_1857"))
			return
		end	
		if(ActiveCache.getNewYearOpenTime() < tonumber(ServerList.getSelectServerInfo().openDateTime) ) then
			AnimationTip.showTip(GetLocalizeStringBy("key_2586"))
			return
		end
		-- 新年礼包
		local layer= NewYearLayer.createNewYearLayer()
		return layer
	elseif( tag == _tagWabao) then
		print("wabao")
		--等级限制
		local nowTime = BTUtil:getSvrTimeInterval()
	    local endTime = ActivityConfig.ConfigCache.robTomb.end_time
	    local beginTime = ActivityConfig.ConfigCache.robTomb.start_time 
	    if(nowTime < beginTime) or (nowTime > endTime) then
	    	AnimationTip.showTip(GetLocalizeStringBy("key_1857"))
			return
		end
		local level = ActivityConfig.ConfigCache.robTomb.data[1].levelLimit
		print_t(ActivityConfig.ConfigCache.robTomb.data[1])
		if(tonumber(level) > UserModel.getHeroLevel()) then
			AnimationTip.showTip(GetLocalizeStringBy("key_1856")..level..GetLocalizeStringBy("key_1287"))
			return
		end
		require "script/ui/digCowry/DigCowryLayer"	
		local layer = DigCowryLayer:createDigCowry()
		return layer
	
	elseif( tag== _tagBenefit) then

		if(ActivityConfigUtil.isActivityOpen("weal") ) then
			require "script/ui/rechargeActive/BenefitActiveLayer"
			local layer = BenefitActiveLayer.createLayer()
			return layer
		else
			AnimationTip.showTip(GetLocalizeStringBy("key_1857"))
			return
		end
		return layer
	end
end

-- 
local function getGrowUpInfo( cbFlag, dictData, bRet  )
	
	-- print("cool time",tonumber(UserModel.getUserInfo().create_time)+30*24*60*60 - BTUtil.getSvrTimeInterval())
	if (dictData.err == "ok") then
		-- added by zhz
		-- 将数据缓存器起来数据
		ActiveCache.setPrizeInfo(dictData.ret)
        -- 未充值，显示首冲
        if(dictData.ret == "unactived")then
        	_boolGrowUp = true
        elseif(dictData.ret == "invalid_time" or dictData.ret == "fetch_all" ) then
            _boolGrowUp = false
        else
        	_boolGrowUp = true
            count = count + 1 
        end
        
    end
    createScrollView()
   -- 

  
end

local function isPayAction(cbFlag, dictData, bRet )
    if (dictData.err == "ok") then
        -- 未充值，显示首冲
        if(dictData.ret == "false" or dictData.ret == false) then
            _boolCharge = true
        elseif(dictData.ret == "true" or dictData.ret == true ) then
            _boolCharge = false
            count = count + 1 
        end
        RequestCenter.growUp_getInfo(getGrowUpInfo)
    end
end


function getNetData( ... )
	RequestCenter.user_isPay(isPayAction)
	
end

function  getBgWidth( ... )
	return topBgSp:getContentSize().height * g_fScaleX
end

function getTopFactHightSize( ... )
	
end


--By ZQ 充值回馈
function getTopBgHeight()
	return topBgSp:getContentSize().height
end

function getTopBgSp()
	return topBgSp
end

--更新红圈的翻卡次数
function refreshCardNum(remainCard)
	if tonumber(remainCard) <= 0 then
		local item = tolua.cast(mainMenu:getChildByTag(_tagBenefit), "CCMenuItemImage")
		local tipSprite= tolua.cast(item:getChildByTag(101), "CCSprite" )
		if(tipSprite) then
			tipSprite:removeFromParentAndCleanup(true)
			tipSprite=nil
		end
	else
		numLabel:setString(remainCard)
	end
end

-- 得到限时兑换活动图标
function getExchangeActiveIcon( ... )
	local images_n = nil
	local images_h = nil
	if(ActivityConfig.ConfigCache.actExchange.data[1])then
		if(ActivityConfig.ConfigCache.actExchange.data[1].act_icon1)then
			images_n =  "images/recharge/change/" .. ActivityConfig.ConfigCache.actExchange.data[1].act_icon1
		else
			images_n =  "images/recharge/change/change_n.png"
		end
		if(ActivityConfig.ConfigCache.actExchange.data[1].act_icon2)then
			images_h =  "images/recharge/change/" .. ActivityConfig.ConfigCache.actExchange.data[1].act_icon2
		else
			images_h =  "images/recharge/change/change_h.png"
		end
	else
		images_n =  "images/recharge/change/change_n.png"
		images_h =  "images/recharge/change/change_h.png"
	end
	return images_n,images_h
end


