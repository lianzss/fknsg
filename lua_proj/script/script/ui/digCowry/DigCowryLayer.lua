-- Filename：	DigCowryLayer.lua
-- Author：		Li Pan
-- Date：		2014-1-8
-- Purpose：		挖宝

module("DigCowryLayer", package.seeall)

require "script/ui/main/BulletinLayer"
require "script/ui/main/MainScene"
require "script/utils/BaseUI"

require "script/ui/digCowry/DigCowryData"
require "script/ui/digCowry/DigCowryNet"

require "script/model/utils/ActivityConfig"

--图片路径
local iPath = "images/digCowry/"

--cclayer
local baseLayer = nil
--免费次数label
local normalDesNode1 = nil
--剩余探宝次数
local normalDesNode2 = nil

--每次花费
local digPriceLabel = nil

--剩余时间label
local leftDigTime = nil
local scheduleTag  = nil

--剩余金币
local goldLeftLabel = nil

--挖宝种类,1，表示 一次挖，2 表示多次挖
local digType = nil
--挖10次 需要金币的label
local costGoldLabel = nil

--挖宝cd
local digCD = nil
local maskLayer       = nil 


-- 查看物品信息返回回调 为了显示下排按钮
local function showDownMenu( ... )
    MainScene.setMainSceneViewsVisible(true, false, true)
end

--创建
function createDigCowry( ... )
    local nowTime = BTUtil:getSvrTimeInterval()
    local endTime = ActivityConfig.ConfigCache.robTomb.end_time
    local beginTime = ActivityConfig.ConfigCache.robTomb.start_time 
    if(nowTime < beginTime) or (nowTime > endTime) then
        require "script/ui/tip/AlertTip"
        AlertTip.showAlert(GetLocalizeStringBy("key_3368"), nil)
        return
    end
    print("ActivityConfig.ConfigCache.robTomb is >>>>")
    print_t(ActivityConfig.ConfigCache.robTomb)

	baseLayer = CCLayer:create()
    baseLayer:registerScriptHandler(onNodeEvent)

	DigCowryNet.getDigInfo(createUI)


	return  baseLayer
end

function createUI( ... )
	local background = CCScale9Sprite:create("images/digCowry/dig_bg.jpg")
    -- local bulletinLayerSize = BulletinLayer.getLayerContentSize()
    -- local menuLayerSize = MenuLayer.getLayerContentSize()
    -- local height = g_winSize.height - ( bulletinLayerSize.height )*g_fScaleX
    background:setScale((MainScene.bgScale))
    background:setPosition(ccp(g_winSize.width/2, g_winSize.height/2))
    background:setAnchorPoint(ccp(0.5, 0.5))
    baseLayer:addChild(background)

    local title = CCSprite:create(iPath.."dig_title.png")
    baseLayer:addChild(title)
    title:setAnchorPoint(ccp(0.5, 0.5))
    title:setPosition(ccp(g_winSize.width/2, g_winSize.height - 240*g_fElementScaleRatio))
    title:setScale(g_fElementScaleRatio)

--当前金币
    local leftTimeLabel = CCRenderLabel:create(GetLocalizeStringBy("key_1099"), g_sFontName, 21, 1.5, ccc3(0, 0, 0), type_stroke)
    leftTimeLabel:setColor(ccc3(0xff, 0xf6, 0x00))
    leftTimeLabel:setAnchorPoint(ccp(0, 0.5))
    baseLayer:addChild(leftTimeLabel)
    leftTimeLabel:setPosition(ccp(10*g_fElementScaleRatio, g_winSize.height - 200*g_fScaleX))
    leftTimeLabel:setScale(g_fElementScaleRatio)

    local goldIcon = CCSprite:create("images/common/gold.png")
    leftTimeLabel:addChild(goldIcon,1,90904)
    goldIcon:setPosition(ccp(leftTimeLabel:getContentSize().width, leftTimeLabel:getContentSize().height/2))
    goldIcon:setAnchorPoint(ccp(0, 0.5))

    local goldNum = UserModel.getGoldNumber()
    goldLeftLabel = CCLabelTTF:create(goldNum, g_sFontName, 21)
    goldLeftLabel:setColor(ccc3(0xff, 0xf6, 0x00))
    goldLeftLabel:setAnchorPoint(ccp(0, 0.5))
    leftTimeLabel:addChild(goldLeftLabel)
    goldLeftLabel:setPosition(ccp(leftTimeLabel:getContentSize().width + 30, leftTimeLabel:getContentSize().height/2))

--剩余时间
    local leftTimeLabel = CCRenderLabel:create(GetLocalizeStringBy("key_3201"), g_sFontName, 21, 1.5, ccc3(0, 0, 0), type_stroke)
    leftTimeLabel:setColor(ccc3(0x00, 0xff, 0x18))
    leftTimeLabel:setAnchorPoint(ccp(0, 0.5))
    baseLayer:addChild(leftTimeLabel)
    -- leftTimeLabel:setPosition(ccp(10*g_fElementScaleRatio, g_winSize.height - 200*g_fScaleX))
    leftTimeLabel:setPosition(ccp(g_winSize.width - 150*g_fElementScaleRatio, g_winSize.height - 300*g_fScaleX))
    leftTimeLabel:setScale(g_fElementScaleRatio)


    local nowTime = BTUtil:getSvrTimeInterval()
    local endTime = ActivityConfig.ConfigCache.robTomb.end_time
    local leftTimeData = tonumber(endTime - nowTime)
    print("the leftTimeData is ",leftTimeData)

    leftTimeData = TimeUtil.getTimeString(leftTimeData)
    print("the leftTimeData is ",leftTimeData)
    print("the nowTime is ",nowTime)
    print("the endTime is ",endTime)
    leftDigTime = CCLabelTTF:create(leftTimeData, g_sFontName, 21)
    leftDigTime:setColor(ccc3(0xff, 0xff, 0xff))
    leftDigTime:setAnchorPoint(ccp(0.5, 1))
    leftTimeLabel:addChild(leftDigTime)
    leftDigTime:setPosition(ccp(leftTimeLabel:getContentSize().width/2, -10))

    scheduleTag = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(changeLeftTime, 1, false)        

   --预览按钮
    local preMenu = CCMenu:create()
    preMenu:setPosition(ccp(0, 0))
    baseLayer:addChild(preMenu)

    local normalSprite  = CCSprite:create(iPath.."cowry_info_1.png")
    local selectSprite  = CCSprite:create(iPath.."cowry_info_2.png")
    local closeButton = CCMenuItemSprite:create(normalSprite,selectSprite)
    closeButton:setPosition(g_winSize.width - 100*g_fElementScaleRatio, g_winSize.height - 230*g_fScaleX)
    closeButton:setAnchorPoint(ccp(0.5, 0.5))
    closeButton:registerScriptTapHandler(prePrize)
    -- closeButton:registerScriptTapHandler(createPrize)
    closeButton:setScale(g_fElementScaleRatio)

    preMenu:addChild(closeButton, 9999)
    preMenu:setTouchPriority(- 100)

-- 挖宝按钮
    local dig1Sprite  = CCSprite:create(iPath.."dig_icon2.png")
    local dig2Sprite  = CCSprite:create(iPath.."dig_icon1.png")
    local dig1Item = CCMenuItemSprite:create(dig1Sprite,dig2Sprite)
    dig1Item:setPosition(g_winSize.width/3, 300*g_fElementScaleRatio)
    dig1Item:setAnchorPoint(ccp(0.5, 0.5))
    dig1Item:registerScriptTapHandler(digCowry)
    preMenu:addChild(dig1Item, 9999)
    dig1Item:setTag(1)
    dig1Item:setScale(g_fElementScaleRatio)

--描述label1
    local needGold = ActivityConfig.ConfigCache.robTomb.data[1].GoldCost
    digPriceLabel = CCRenderLabel:create(needGold, g_sFontName, 21, 1.5, ccc3(0, 0, 0), type_stroke)
    digPriceLabel:setColor(ccc3(0xff, 0xf6, 0x00))
    digPriceLabel:setAnchorPoint(ccp(0.5, 0.5))
    dig1Item:addChild(digPriceLabel)
    digPriceLabel:setPosition(ccp(dig1Item:getContentSize().width - 20, - 20))
    digPriceLabel:setVisible(false)

    local goldSp1 = CCSprite:create("images/common/gold.png")
    digPriceLabel:addChild(goldSp1,1,90904)
    goldSp1:setPosition(ccp(-40, digPriceLabel:getContentSize().height/2))
    goldSp1:setAnchorPoint(ccp(0, 0.5))


    local freeLabel = createFreeLabel()
    freeLabel:setAnchorPoint(ccp(0.5, 0.5))
    freeLabel:setPosition(dig1Item:getContentSize().width/2, - 20)
    dig1Item:addChild(freeLabel)
 
--金币挖宝
    local dig3Sprite  = CCSprite:create(iPath.."ten_dig1.png")
    local dig4Sprite  = CCSprite:create(iPath.."ten_dig2.png")
    local dig2Item = CCMenuItemSprite:create(dig3Sprite,dig4Sprite)
    dig2Item:setPosition(g_winSize.width/3*2, 300*g_fElementScaleRatio)
    dig2Item:setAnchorPoint(ccp(0.5, 0.5))
    dig2Item:registerScriptTapHandler(digCowry)
    preMenu:addChild(dig2Item, 9999)
    dig2Item:setTag(10)
    dig2Item:setScale(g_fElementScaleRatio)


    local goldSp = CCSprite:create("images/common/gold.png")
    dig2Item:addChild(goldSp,1,90904)
    goldSp:setPosition(ccp(0, -20))
    goldSp:setAnchorPoint(ccp(0, 0.5))

    local vipArr = DB_Vip.getArrDataByField("level", UserModel.getVipLevel())
    local totalGoldTime = vipArr[1].ernieGoldTimes
    local userGoldTime = DigCowryData.digInfo.today_gold_num
    local leftGoldTime = tonumber(totalGoldTime) - tonumber(userGoldTime)

    local needGold = ActivityConfig.ConfigCache.robTomb.data[1].GoldCost

    -- if(leftGoldTime < 10) then
        needGold = needGold * 5
    -- else
    --     needGold = needGold * 10
    -- end
    
    costGoldLabel = CCRenderLabel:create(needGold, g_sFontName, 21, 1.5, ccc3(0, 0, 0), type_stroke)
    costGoldLabel:setColor(ccc3(0xff, 0xf6, 0x00))
    costGoldLabel:setAnchorPoint(ccp(0, 0.5))
    dig2Item:addChild(costGoldLabel)
    costGoldLabel:setPosition(ccp(40, -20))

-- 剩余金币挖宝
    local leftGoldLabel = createDigLabel()
    leftGoldLabel:setAnchorPoint(ccp(0.5, 0.5))
    leftGoldLabel:setPosition(g_winSize.width/2, 205*g_fElementScaleRatio)
    baseLayer:addChild(leftGoldLabel)

--活动时间
    local fullRect = CCRectMake(0, 0, 41, 31)
    local insetRect = CCRectMake(20, 15, 1, 1)
    local timeBg = CCScale9Sprite:create("images/common/bg/9s_6.png", fullRect, insetRect)
    timeBg:setPreferredSize(CCSizeMake(570*g_fElementScaleRatio, 50*g_fElementScaleRatio))
    timeBg:setAnchorPoint(ccp(0.5, 0))
    timeBg:setPosition(ccp(g_winSize.width/2, 125*g_fScaleX))
    baseLayer:addChild(timeBg)

    local beginTime = ActivityConfig.ConfigCache.robTomb.start_time 
    require "script/utils/TimeUtil"
    local beginString = TimeUtil.getTimeForDay(beginTime)

    local endTime = ActivityConfig.ConfigCache.robTomb.end_time
    local endString = TimeUtil.getTimeForDay(endTime)

    local freeLabels = {}
    freeLabels[1] = CCRenderLabel:create(GetLocalizeStringBy("key_2826"), g_sFontName, 21, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
    freeLabels[1]:setColor(ccc3(0x00, 0xff, 0x18))

    freeLabels[2] = CCRenderLabel:create(beginString..GetLocalizeStringBy("key_2358")..endString, g_sFontName, 21, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
    freeLabels[2]:setColor(ccc3(0xff, 0xff, 0xff))

    local labels = BaseUI.createHorizontalNode(freeLabels)
    labels:setScale(g_fElementScaleRatio)
    labels:setAnchorPoint(ccp(0, 0.5))
    labels:setPosition(20, timeBg:getContentSize().height/2)
    timeBg:addChild(labels)
end

--剩余免费挖宝
function createFreeLabel( ... )
    local freeLabels = {}
    freeLabels[1] = CCRenderLabel:create(GetLocalizeStringBy("key_1551"), g_sFontName, 21, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
    freeLabels[1]:setColor(ccc3(0xff, 0xff, 0xff))

    local vipArr = DB_Vip.getArrDataByField("level", UserModel.getVipLevel())
    local totalFreeTime = tonumber(vipArr[1].ernieFreeTimes)
    local useTime = tonumber(DigCowryData.digInfo.today_free_num)
    local leftFreeTime = totalFreeTime - useTime
    if(leftFreeTime <= 0) then
        leftFreeTime = 0
    end

    freeLabels[2] = CCRenderLabel:create(leftFreeTime, g_sFontName, 21, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
    freeLabels[2]:setColor(ccc3(0x00, 0xff, 0x18))

    freeLabels[3] = CCRenderLabel:create(GetLocalizeStringBy("key_3010"), g_sFontName, 21, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
    freeLabels[3]:setColor(ccc3(0xff, 0xff, 0xff))

    local labelPare = nil
    if(normalDesNode1) then    
        labelPare = normalDesNode1:getParent()
        print("the labelPare is >>>>>>",labelPare)
        normalDesNode1:removeFromParentAndCleanup(true)
        normalDesNode1 = nil 
    end
    normalDesNode1 = BaseUI.createHorizontalNode(freeLabels)
    -- normalDesNode1:setScale(g_fElementScaleRatio)
    
    local leftFreeTime = totalFreeTime - useTime
    if(leftFreeTime <= 0) then
        digPriceLabel:setVisible(true)
        normalDesNode1:setVisible(false)
    end

    if(labelPare) then
        print("the labelPare is ")
        return normalDesNode1, labelPare    
    end
    return normalDesNode1
    
end

--剩余金币挖宝
function createDigLabel( ... )
    -- if(labelTabel2) then
    --     labelTabel2:removeFromParentAndCleanup(true)    
    --     labelTabel2 = nil
    -- end
    local vipArr = DB_Vip.getArrDataByField("level", UserModel.getVipLevel())
    local totalGoldTime = vipArr[1].ernieGoldTimes
    local userGoldTime = DigCowryData.digInfo.today_gold_num
    local leftGoldTime = tonumber(totalGoldTime) - tonumber(userGoldTime)
    print("the leftGoldTime is ",leftGoldTime)
    print("the userGoldTime is ",userGoldTime)

    local labelTabel2 = {}
    labelTabel2[1] = CCRenderLabel:create(GetLocalizeStringBy("key_2705"), g_sFontName, 21, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
    labelTabel2[1]:setColor(ccc3(0xff, 0xff, 0xff))

    labelTabel2[2] = CCRenderLabel:create(leftGoldTime, g_sFontName, 21, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
    labelTabel2[2]:setColor(ccc3(0x00, 0xff, 0x18))

    labelTabel2[3] = CCRenderLabel:create(GetLocalizeStringBy("key_3010"), g_sFontName, 21, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
    labelTabel2[3]:setColor(ccc3(0xff, 0xff, 0xff))

    if(normalDesNode2) then
        print("enter normalDesNode2")
        normalDesNode2:removeFromParentAndCleanup(true)
        normalDesNode2 = nil 
    end

    normalDesNode2 = BaseUI.createHorizontalNode(labelTabel2)
    normalDesNode2:setScale(g_fElementScaleRatio)
    return normalDesNode2
end

--预览
function prePrize( ... )
	local maskLayer = BaseUI.createMaskLayer(-500)
    local runningScene = CCDirector:sharedDirector():getRunningScene()
    runningScene:addChild(maskLayer,999,90901)

    local background = CCScale9Sprite:create("images/common/viewbg1.png")
    background:setContentSize(CCSizeMake(630, 800))
    background:setAnchorPoint(ccp(0.5, 0.5))
    background:setPosition(ccp(g_winSize.width/2, g_winSize.height/2))
    maskLayer:addChild(background)
    AdaptTool.setAdaptNode(background)

    --标题
    local titlePanel = CCSprite:create("images/common/viewtitle1.png")
    titlePanel:setAnchorPoint(ccp(0.5, 0.5))
    titlePanel:setPosition(background:getContentSize().width/2, background:getContentSize().height - 7 )
    background:addChild(titlePanel)

    local titleLabel = CCRenderLabel:create(GetLocalizeStringBy("key_2613"), g_sFontPangWa, 33, 1, ccc3(0,0,0))
    titleLabel:setColor(ccc3(0xff, 0xe4, 0x00))
    local x = (titlePanel:getContentSize().width - titleLabel:getContentSize().width)/2
    local y = titlePanel:getContentSize().height - (titlePanel:getContentSize().height - titleLabel:getContentSize().height)/2
    titleLabel:setPosition(ccp(x , y))
    titlePanel:addChild(titleLabel)

--关闭按钮
    local closeMenu = CCMenu:create()
    closeMenu:setPosition(ccp(0, 0))
    background:addChild(closeMenu)
    local closeButton = CCMenuItemImage:create("images/common/btn_close_n.png", "images/common/btn_close_h.png")
    closeButton:setPosition(background:getContentSize().width * 0.95, background:getContentSize().height * 0.96)
    closeButton:setAnchorPoint(ccp(0.5, 0.5))
    closeButton:registerScriptTapHandler(closeButtonCallback)
    closeMenu:addChild(closeButton, 9999)
    closeMenu:setTouchPriority(-501)

    --活动说明
    local tipLabel = CCRenderLabel:create(GetLocalizeStringBy("key_2934"), g_sFontPangWa, 25, 1, ccc3(0xff, 0xff, 0xff))
    tipLabel:setPosition(ccp(background:getContentSize().width/2, background:getContentSize().height - 81))
    tipLabel:setColor(ccc3(0x25, 0x8b, 0x23))
    tipLabel:setAnchorPoint(ccp(0.5, 0))
    background:addChild(tipLabel)

    --提示
    local tipLabel1 = CCLabelTTF:create(GetLocalizeStringBy("key_2135"), g_sFontName, 21)
    tipLabel1:setPosition(ccp(20, background:getContentSize().height - 130))
    tipLabel1:setColor(ccc3(0x78, 0x25, 0x00))
    tipLabel1:setAnchorPoint(ccp(0, 0))
    background:addChild(tipLabel1)

    local tipLabel2 = CCLabelTTF:create(GetLocalizeStringBy("key_3195"), g_sFontName, 21)
    tipLabel2:setPosition(ccp(20, background:getContentSize().height - 160))
    tipLabel2:setColor(ccc3(0x78, 0x25, 0x00))
    tipLabel2:setAnchorPoint(ccp(0, 0))
    background:addChild(tipLabel2)

    -- local tipLabel3 = CCLabelTTF:create(GetLocalizeStringBy("key_2771"), g_sFontName, 21)
    -- tipLabel3:setPosition(ccp(20, background:getContentSize().height - 170))
    -- tipLabel3:setColor(ccc3(0x78, 0x25, 0x00))
    -- tipLabel3:setAnchorPoint(ccp(0, 0))
    -- background:addChild(tipLabel3)

    --bg
    local fullRect = CCRectMake(0, 0, 75, 75)
    local insetRect = CCRectMake(30, 30, 15, 10)
    local listBg = CCScale9Sprite:create("images/common/bg/bg_ng_attr.png", fullRect, insetRect)
    listBg:setPreferredSize(CCSizeMake(580, 570))
    listBg:setPosition(ccp(25, 45))
    background:addChild(listBg)
  
  --scrollview
    local scrollView = CCScrollView:create()
    scrollView:setViewSize(CCSizeMake(570, 550))
    scrollView:setTouchPriority(-501)
    print("the scrollview contentsize is "..scrollView:getContentSize().height)
   
    scrollView:setBounceable(true)
    scrollView:setDirection(kCCScrollViewDirectionVertical)
    scrollView:setAnchorPoint(ccp(0, 0))
    scrollView:setPosition(ccp(0, 10))
    listBg:addChild(scrollView)

    local bSize = 0
    for i=1,5 do
        local itemInfo = getItemInfo(i)
        if(itemInfo) then
            local number = table.count(itemInfo)
            if(number > 4) then
                number = math.ceil((number - 4)/4)
                bSize = (230 + 140 * number) + bSize
                print("llllll number = ", number)
                print("llllll bSize = ", bSize)
            else
                bSize = 230 + bSize
                print("the bsize = ",bSize)
            end
        end
    end

    -- print("num = ", num)
    scrollView:setContentSize(CCSizeMake(570, bSize))
    scrollView:setContentOffset(ccp(0, scrollView:getViewSize().height - scrollView:getContentSize().height))

    local scrollLayer = CCLayer:create()
    scrollView:addChild(scrollLayer)
    scrollLayer:setPosition(ccp(0, 0))
    print("scrollView:setContentSize = ", scrollView:getContentSize().width, scrollView:getContentSize().height)
    local lastItemY = 0 
    local index = 1
    for i=5,1,-1 do
        local item1 = createPrizeItem(i)
        if(item1) then
            scrollView:addChild(item1)
            item1:setAnchorPoint(ccp(0.5, 0))
            if(index == 1) then
                item1:setPosition(ccp(scrollView:getContentSize().width/2, scrollView:getContentSize().height - item1:getContentSize().height))
                print("first")
            else
                print("is = ",i)
                item1:setPosition(ccp(scrollView:getContentSize().width/2, lastItemY - item1:getContentSize().height))
            end
            lastItemY = item1:getPositionY()

            index = index + 1

            print("+++++++++++++",i)
            print(" scrollView:getContentSize().height  == ",  scrollView:getContentSize().height )

            print("item1:getContentSize().height == ",item1:getContentSize().height)

            print(" lastItemY = ", lastItemY)
        end
    end
end

--得到宝物数量
function getItemInfo(tag)
    local showItemInfo = nil
    local showData = nil
    require "script/utils/LuaUtil"
    -- print("the tag is ",tag)
    if(tag == 1) then
        showData = ActivityConfig.ConfigCache.robTomb.data[1].showItems1
    elseif(tag == 2) then
        showData = ActivityConfig.ConfigCache.robTomb.data[1].showItems2
    elseif(tag == 3) then
        showData = ActivityConfig.ConfigCache.robTomb.data[1].showItems3
    elseif(tag == 4) then
        showData = ActivityConfig.ConfigCache.robTomb.data[1].showItems4
    elseif(tag == 5) then
        showData = ActivityConfig.ConfigCache.robTomb.data[1].showItems5
    end
    print("the showData is ")
    print_t(showData)
    if(not showData) or (showData == "") then
        showItemInfo = nil
    else
        showItemInfo = lua_string_split(showData, ",")    
    end
    -- if(showData) then
    --     showItemInfo = lua_string_split(showData, "|")    
    -- end
    return showItemInfo
end


function createPrizeItem(tag)
-- 设置数据
    local showItemInfo = getItemInfo(tag)
    print("createPrizeItem is ")
    print_t(showItemInfo)
    if(not showItemInfo) or (table.count(showItemInfo) == 0) or (showItemInfo[1] == "") then
        return nil
    end
    local prizeNum = table.count(showItemInfo)

--设置大小
    local bSize = nil
    print("the prizeNum is ",prizeNums)
    if(prizeNum < 5) then
        bSize = CCSizeMake(560, 230)
        cSize = CCSizeMake(520, 150)
        print("enter first")
    else
        local num = math.ceil((prizeNum - 4)/4)
        print("the num is ",num)
        bSize = CCSizeMake(560, 230 + 130 * num)
        cSize = CCSizeMake(520, 150 + 130 * num)
        print("fffff number = ", num)
        print("fffff bSize = ", bSize)
    end

    local fullRect = CCRectMake(0, 0, 116, 124)
    local insetRect = CCRectMake(30, 50, 1, 1)
    local listBg = CCScale9Sprite:create("images/reward/cell_back.png", fullRect, insetRect)
    listBg:setPreferredSize(bSize)

    local starBg = CCSprite:create("images/digCowry/star_bg.png")
    starBg:setAnchorPoint(ccp(0, 1))
    listBg:addChild(starBg)
    starBg:setPosition(ccp(0, listBg:getContentSize().height))


    for i=1,tag do
        local star = CCSprite:create("images/digCowry/star.png")
        starBg:addChild(star)
        star:setAnchorPoint(ccp(0.5, 0.5))
        star:setPosition(ccp(35 + 30*(i - 1), starBg:getContentSize().height/2))
    end

    local itemInfoSpite = CCScale9Sprite:create("images/recycle/reward/rewardbg.png")
    itemInfoSpite:setContentSize(cSize)
    itemInfoSpite:setPosition(ccp(listBg:getContentSize().width*0.5, listBg:getContentSize().height*0.5 - 10))
    itemInfoSpite:setAnchorPoint(ccp(0.5, 0.5))
    listBg:addChild(itemInfoSpite)

   
    local j = 1
    require "script/ui/item/ItemSprite"
    for k,v in pairs(showItemInfo) do
        --物品 和 英雄
        local sprite = nil
        local heroData = lua_string_split(v, "|")  
        print("the heroData is ")
        print_t(heroData) 

        local itemData = nil
        local nameColor = nil
        local htid = tonumber(heroData[2])
        local htype = tonumber(heroData[1])
        print("the htid is ",heroData[2])
        print("the htype is ",heroData[1])
        require "script/ui/item/ItemSprite"
        if(1 == htype) then
            -- sprite = ItemSprite.getItemSpriteById(htid)
            sprite = ItemSprite.getItemSpriteById(htid,nil,showDownMenu, nil,-502,19001,-503)
            itemData = ItemUtil.getItemById(htid)
            nameColor = HeroPublicLua.getCCColorByStarLevel(itemData.quality)
        elseif(2 == htype) then
            -- sprite = ItemSprite.getHeroIconItemByhtid(htid)
            sprite = ItemSprite.getHeroIconItemByhtid(htid,-502,19001,- 503)
            itemData = DB_Heroes.getDataById(htid)
            nameColor = HeroPublicLua.getCCColorByStarLevel(itemData.star_lv)
        end
        itemInfoSpite:addChild(sprite)
        sprite:setAnchorPoint(ccp(0, 0.5))
        sprite:setPosition(ccp(20 + 125*(j-1), itemInfoSpite:getContentSize().height - 70))
        if(j > 4) then
            local num = math.ceil((j - 4)/4)
            local upNum = (j-1)%4
            sprite:setPosition(ccp(20 + 125*upNum, itemInfoSpite:getContentSize().height - 70 - 130 * num))
        end

        local itemNameLabel = CCRenderLabel:create(itemData.name, g_sFontName, 18, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
        print("the itemData is >>>",itemData)
        print_t(itemData)
        if(htid > 80000 and htid < 90000) then
            local model_id = DB_Heroes.getDataById(tonumber(UserModel.getAvatarHtid())).model_id
            print("the model_id is"..model_id)
            local dressArray = lua_string_split(itemData.name, ",")
            print_t(dressArray)
            for k,v in pairs(dressArray) do
                local array = lua_string_split(v, "|")
                print("the array is")
                print_t(array)
                if(tonumber(array[1]) == tonumber(model_id)) then
                    itemNameLabel:setString(array[2])
                    break
                end
            end
        end
        -- local nameColor = HeroPublicLua.getCCColorByStarLevel(itemData.quality)
        itemNameLabel:setColor(nameColor)
        itemNameLabel:setAnchorPoint(ccp(0.5,0.5))
        itemNameLabel:setPosition(ccp(sprite:getContentSize().width*0.5, - 10))
        sprite:addChild(itemNameLabel)

        j = j + 1
    end

    return listBg
end

function closeButtonCallback( ... )
    print("close closeButtonCallback")
    local runningScene = CCDirector:sharedDirector():getRunningScene()
    runningScene:removeChildByTag(90901, true)
end

--挖宝奖励
function createPrize(tag)
    digCD = 0
    print("the DigCowryData.DigCowryInfo is ")
    print_t(DigCowryData.DigCowryInfo)
--设置数据
    -- local newTable = {}
    -- local prizeNum = table.count(DigCowryData.DigCowryInfo.item or newTable)
    -- prizeNum = table.count(DigCowryData.DigCowryInfo.hero or newTable) + prizeNum
    -- prizeNum = table.count(DigCowryData.DigCowryInfo.treasFrag or newTable) + prizeNum
    local prizeNum = table.count(DigCowryData.DigCowryInfo)
    local bSize = nil
    print("the prizeNum is ",prizeNum)
    if(prizeNum < 5) then
        bSize = CCSizeMake(560, 230 + 150 + 50)
        cSize = CCSizeMake(520, 150)
        print("enter first")
    else
        local num = math.ceil((prizeNum - 4)/4)
        print("the num is ",num)
        bSize = CCSizeMake(560, 230 + 150 + 50 + 130 * num)
        cSize = CCSizeMake(520, 150 + 130 * num)
        print("fffff number = ", num)
        print("fffff bSize = ", bSize)
    end

    local maskLayer = BaseUI.createMaskLayer(-500)
    local runningScene = CCDirector:sharedDirector():getRunningScene()
    runningScene:addChild(maskLayer,999,90901)

    local background = CCScale9Sprite:create("images/common/viewbg1.png")
    background:setContentSize(bSize)
    background:setAnchorPoint(ccp(0.5, 0.5))
    background:setPosition(ccp(g_winSize.width/2, g_winSize.height/2))
    maskLayer:addChild(background)
    AdaptTool.setAdaptNode(background)

    local thisScale = background:getScale()
    background:setScale(0)
    local array = CCArray:create()
    local scale1 = CCScaleTo:create(0.08,1.2*thisScale)
    local fade = CCFadeIn:create(0.06)
    local spawn = CCSpawn:createWithTwoActions(scale1,fade)
    local scale2 = CCScaleTo:create(0.07,0.9*thisScale)
    local scale3 = CCScaleTo:create(0.07,1*thisScale)
    array:addObject(scale1)
    array:addObject(scale2)
    array:addObject(scale3)
    local seq = CCSequence:create(array)
    background:runAction(seq)
    
    --标题
    local titlePanel = CCSprite:create("images/common/viewtitle1.png")
    titlePanel:setAnchorPoint(ccp(0.5, 0.5))
    titlePanel:setPosition(background:getContentSize().width/2, background:getContentSize().height - 7 )
    background:addChild(titlePanel)

    local titleLabel = CCRenderLabel:create(GetLocalizeStringBy("key_1370"), g_sFontPangWa, 33, 1, ccc3(0,0,0))
    titleLabel:setColor(ccc3(0xff, 0xe4, 0x00))
    local x = (titlePanel:getContentSize().width - titleLabel:getContentSize().width)/2
    local y = titlePanel:getContentSize().height - (titlePanel:getContentSize().height - titleLabel:getContentSize().height)/2
    titleLabel:setPosition(ccp(x , y))
    titlePanel:addChild(titleLabel)

    local explainLabel = CCRenderLabel:create(GetLocalizeStringBy("key_1303"), g_sFontPangWa,30,1,ccc3(0x00,0x00,0x00),type_shadow)
    explainLabel:setColor(ccc3(0xff,0xf0,0x00))
    explainLabel:setPosition(ccp(40,background:getContentSize().height-100))
    explainLabel:setAnchorPoint(ccp(0,0))
    background:addChild(explainLabel)

--确定按钮
    local menu = CCMenu:create()
    menu:setPosition(ccp(0,0))
    menu:setTouchPriority(-501)

    local makeSureButton = LuaCC.create9ScaleMenuItem("images/common/btn/btn_bg_n.png","images/common/btn/btn_bg_h.png",CCSizeMake(200, 73),GetLocalizeStringBy("key_1465"),ccc3(0xfe, 0xdb, 0x1c),35,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00))
    makeSureButton:setAnchorPoint(ccp(0.5, 0.5))
    makeSureButton:setPosition(ccp(background:getContentSize().width/2, 60))
    makeSureButton:registerScriptTapHandler(closeButtonCallback)
    menu:addChild(makeSureButton)
    background:addChild(menu)

-- 提示
    -- local tipLabel = CCRenderLabel:create(GetLocalizeStringBy("key_1602"),g_sFontName, 28, 2, ccc3( 0x00, 0x00, 0x00), type_stroke)
    -- tipLabel:setColor(ccc3(0x00,0xff,0x18))
    -- tipLabel:setPosition(ccp(makeSureButton:getContentSize().width/2, 80))
    -- tipLabel:setAnchorPoint(ccp(0.5 ,0))
    -- makeSureButton:addChild(tipLabel)

--内容
    local itemInfoSpite = CCScale9Sprite:create("images/recycle/reward/rewardbg.png")
    itemInfoSpite:setContentSize(cSize)
    itemInfoSpite:setPosition(ccp(background:getContentSize().width*0.5, background:getContentSize().height*0.5))
    itemInfoSpite:setAnchorPoint(ccp(0.5, 0.5))
    background:addChild(itemInfoSpite)
   
    print("DigCowryData.DigCowryInfo jsakmvi")
    -- print_t(DigCowryData.DigCowryInfo)

    local j = 1
    for i,v in ipairs(DigCowryData.DigCowryInfo) do
        -- print(i,v)
        print("the v is ...")
        print_t(v)
        if(v.item) or (v.treasFrag) then
            setPrizePos(v.item or v.treasFrag, j, itemInfoSpite, 1)
        elseif(v.hero) then
            setPrizePos(v.hero, j, itemInfoSpite, 2)
        end
        j = j + 1
    end

    -- j = setPrizePos(DigCowryData.DigCowryInfo.item, j, itemInfoSpite, 1)
    -- print("the first j = ", j)
    -- j = setPrizePos(DigCowryData.DigCowryInfo.treasFrag, j, itemInfoSpite, 1)
    -- print("the second j = ", j)
    -- setPrizePos(DigCowryData.DigCowryInfo.hero, j, itemInfoSpite, 2)
    -- print("the third j = ", j)
end

function setPrizePos(prizeTable, j, parent, tag)
    if(not prizeTable) then
        return j
    end
    for k,v in pairs(prizeTable) do
        local sprite = getPrizeItem(k,v,tag)
        parent:addChild(sprite)
        sprite:setPosition(ccp(20 + 125*(j-1), parent:getContentSize().height - 70))
        if(j > 4) then
            local num = math.ceil((j - 4)/4)
            local upNum = (j-1)%4
            sprite:setPosition(ccp(20 + 125*upNum, parent:getContentSize().height - 70 - 130 * num))
        end
        j = j + 1
    end
    return j
end

function getPrizeItem(htid,num,tag)
    print("the htid = "..htid.." the num is ..",num)
    print("the tag is  = ",tag) 
    local sprite = nil
    local itemData = nil
    local nameColor = nil
    require "script/ui/item/ItemSprite"
    if(tag == 1) then
--物品和碎片
        sprite = ItemSprite.getItemSpriteById(htid,nil,showDownMenu, nil,-502,19001,-503)
        itemData = ItemUtil.getItemById(htid)
        nameColor = HeroPublicLua.getCCColorByStarLevel(itemData.quality)
    elseif(tag == 2) then
--英雄
        require "db/DB_Heroes"
        sprite = ItemSprite.getHeroIconItemByhtid(htid,-502,19001,- 503)
        itemData = DB_Heroes.getDataById(htid)
        nameColor = HeroPublicLua.getCCColorByStarLevel(itemData.star_lv)
    end
    print("the itemData is ")
    print_t(itemData)
    print("the itemData is quality",itemData.quality)


    sprite:setAnchorPoint(ccp(0, 0.5))
    local itemNameLabel = CCRenderLabel:create(itemData.name, g_sFontName, 18, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
     if(tonumber(htid) > 80000 and tonumber(htid) < 90000) then
            local model_id = DB_Heroes.getDataById(tonumber(UserModel.getAvatarHtid())).model_id
            print("the model_id is"..model_id)
            local dressArray = lua_string_split(itemData.name, ",")
            print_t(dressArray)
            for k,v in pairs(dressArray) do
                local array = lua_string_split(v, "|")
                print("the array is")
                print_t(array)
                if(tonumber(array[1]) == tonumber(model_id)) then
                    itemNameLabel:setString(array[2])
                    break
                end
            end
        end
    -- local nameColor = HeroPublicLua.getCCColorByStarLevel(itemData.quality)
    itemNameLabel:setColor(nameColor)
    itemNameLabel:setAnchorPoint(ccp(0.5,0.5))
    itemNameLabel:setPosition(ccp(sprite:getContentSize().width*0.5, - 10))
    sprite:addChild(itemNameLabel)

    local itemNumLabel = CCRenderLabel:create(num, g_sFontName, 18, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
    itemNumLabel:setColor(ccc3(0x00,0xff,0x18))
    itemNumLabel:setAnchorPoint(ccp(1, 0))
    itemNumLabel:setPosition(ccp(sprite:getContentSize().width - 10, 0))
    sprite:addChild(itemNumLabel)

    return sprite
end

--改变剩余时间
function changeLeftTime( ... )
    local nowTime = BTUtil:getSvrTimeInterval()
    local endTime = ActivityConfig.ConfigCache.robTomb.end_time
    local leftTimeData = TimeUtil.getTimeString(endTime - nowTime)
    leftDigTime:setString(leftTimeData)

    if(tonumber(nowTime - endTime) >= 0) then
        --时间到了怎么办
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(scheduleTag)
    end
end

function createEffect( ... )
    digCD = 1
    local ccDelegate=BTAnimationEventDelegate:create()
    ccDelegate:registerLayerEndedHandler(function (actionName, xmlSprite)
        print("effect end")
        if(digType == 1) then
            digOneTime()
        else
            digMoreTimes()
        end
        if(maskLayer)then 
            maskLayer:removeFromParentAndCleanup(true)
            maskLayer = nil
        end
    end)
    if(maskLayer)then 
        maskLayer:removeFromParentAndCleanup(true)
        maskLayer = nil
    end
    local runningScene = CCDirector:sharedDirector():getRunningScene()
    maskLayer = BaseUI.createMaskLayer(-5000,nil,nil,0)
    runningScene:addChild(maskLayer, 10000)
    local sImgPath=CCString:create("images/digCowry/effect/chutou")
    local loadEffectSprite = CCLayerSprite:layerSpriteWithNameAndCount(sImgPath:getCString(), 1,CCString:create(""));
    loadEffectSprite:retain()
    loadEffectSprite:setAnchorPoint(ccp(0.5, 0.5))
    loadEffectSprite:setPosition(ccp(g_winSize.width/2, g_winSize.height/2))
    baseLayer:addChild(loadEffectSprite, 99999)
    loadEffectSprite:release()
    loadEffectSprite:setScale(g_fBgScaleRatio)
    loadEffectSprite:setDelegate(ccDelegate)
end

--挖宝
function digCowry(tag, sender)
    print("the tag is ", tag) 
    if(digCD == 1) then
        return
    end
--判断时间到了不
    local nowTime = BTUtil:getSvrTimeInterval()
    local endTime = ActivityConfig.ConfigCache.robTomb.end_time
    local beginTime = ActivityConfig.ConfigCache.robTomb.start_time 
    if(nowTime < beginTime) or (nowTime > endTime) then
        require "script/ui/tip/AlertTip"
        AlertTip.showAlert(GetLocalizeStringBy("key_2447"), nil)
        return
    end
--判断背包是否满
    -- 物品背包满了
    require "script/ui/item/ItemUtil"
    if(ItemUtil.isBagFull() == true )then
        -- AlertTip.showAlert(GetLocalizeStringBy("key_1913"), nil)
        return
    end
    -- 武将满了
    require "script/ui/hero/HeroPublicUI"
    if HeroPublicUI.showHeroIsLimitedUI() then
        -- AlertTip.showAlert(GetLocalizeStringBy("key_1807"), nil)
        return
    end

    if(tag == 1) then
    --表示点击 左边的
        --判断次数够不够
        local vipArr = DB_Vip.getArrDataByField("level", UserModel.getVipLevel())
        local totalFreeTime = tonumber(vipArr[1].ernieFreeTimes)
        local useTime = tonumber(DigCowryData.digInfo.today_free_num)
        local leftFreeTime = totalFreeTime - useTime
        if(leftFreeTime <= 0) then
            local vipArr = DB_Vip.getArrDataByField("level", UserModel.getVipLevel())
            local totalGoldTime = vipArr[1].ernieGoldTimes
            local userGoldTime = DigCowryData.digInfo.today_gold_num
            local leftGoldTime = tonumber(totalGoldTime) - tonumber(userGoldTime)
            if(leftGoldTime <= 0) then
                AlertTip.showAlert(GetLocalizeStringBy("key_2068"), nil)
                return
            else
                local needGold = ActivityConfig.ConfigCache.robTomb.data[1].GoldCost
                local nowGold = UserModel.getGoldNumber()
                if(tonumber(nowGold) < tonumber(needGold)) then 
                    require "script/ui/tip/LackGoldTip"
                    LackGoldTip.showTip()
                    return
                end
            end
        end    
        digType = 1
        createEffect()    
    else
        digType = 2
        digMoreTimesTip()
    end
end

--挖一次宝
function digOneTime()
    local vipArr = DB_Vip.getArrDataByField("level", UserModel.getVipLevel())
    local totalFreeTime = tonumber(vipArr[1].ernieFreeTimes)
    local useTime = tonumber(DigCowryData.digInfo.today_free_num)
    local leftFreeTime = totalFreeTime - useTime
    if(leftFreeTime > 0) then 
        DigCowryNet.digCowry(function ( ... )
            --修改数据
            DigCowryData.digInfo.today_free_num = tonumber(DigCowryData.digInfo.today_free_num) + 1
            --减次数
            local label,labelPare = createFreeLabel()
            labelPare:addChild(label)
            label:setAnchorPoint(ccp(0.5, 0.5))
            label:setPosition(labelPare:getContentSize().width/2, - 20)

        --展示界面
            createPrize()
        end, 1, 1)
    else
        DigCowryNet.digCowry(function ( ... )
            --修改数据
            DigCowryData.digInfo.today_gold_num = tonumber(DigCowryData.digInfo.today_gold_num) + 1
            local needGold = ActivityConfig.ConfigCache.robTomb.data[1].GoldCost

            UserModel.addGoldNumber(- tonumber(needGold))
            goldLeftLabel:setString(UserModel.getGoldNumber())
            --减次数
            local leftGoldLabel = createDigLabel()
            leftGoldLabel:setAnchorPoint(ccp(0.5, 0.5))
            leftGoldLabel:setPosition(g_winSize.width/2, 205*g_fElementScaleRatio)
            baseLayer:addChild(leftGoldLabel)

        --如果不足10次 减少花费金币显示
            local vipArr = DB_Vip.getArrDataByField("level", UserModel.getVipLevel())
            local totalGoldTime = vipArr[1].ernieGoldTimes
            local userGoldTime = DigCowryData.digInfo.today_gold_num
            local leftGoldTime = tonumber(totalGoldTime) - tonumber(userGoldTime)
            if(leftGoldTime < 10) then
                -- costGoldLabel:setString(needGold*leftGoldTime)
            end

    --展示界面
            createPrize()

        end, 1, 2)
    end
end

--挖宝多次
function digMoreTimesTip()
    local vipArr = DB_Vip.getArrDataByField("level", UserModel.getVipLevel())
    local totalGoldTime = vipArr[1].ernieGoldTimes
    local userGoldTime = DigCowryData.digInfo.today_gold_num
    local leftGoldTime = tonumber(totalGoldTime) - tonumber(userGoldTime)
    if(leftGoldTime <= 0) then
        AlertTip.showAlert(GetLocalizeStringBy("key_2068"), nil)
        return        
    end
    --如果只有一次，那么不弹出提示
    print("the leftGoldTime is ",leftGoldTime)
    local needGold = ActivityConfig.ConfigCache.robTomb.data[1].GoldCost
    if(leftGoldTime < 5) then
        needGold = needGold * leftGoldTime
        print("the needGold is ",needGold)
    else
        needGold = needGold * 5
        print("the needGold is >>>>>>> ",needGold)
    end
    --判断金币是否足够
    -- local oneTimeNeedGold = ActivityConfig.ConfigCache.robTomb.data[1].GoldCost
    local nowGold = UserModel.getGoldNumber()
    if(tonumber(nowGold) < tonumber(needGold)) then 
        require "script/ui/tip/LackGoldTip"
        LackGoldTip.showTip()
        return
    end

--如果是10次以下提示，如果以上，不提示
    if(leftGoldTime < 5) then
        local str = GetLocalizeStringBy("key_3121")..leftGoldTime..GetLocalizeStringBy("key_3295")..GetLocalizeStringBy("key_3282")..needGold..GetLocalizeStringBy("key_1107")
        AlertTip.showAlert( str, yesToreceive, true)
    else
        yesToreceive(true)
    end
   
end

function yesToreceive(param_1, param_2)
    if(param_1 == true) then
        --创建特效
        createEffect()    
        return
    end
end

function digMoreTimes()
    local vipArr = DB_Vip.getArrDataByField("level", UserModel.getVipLevel())
    local totalGoldTime = vipArr[1].ernieGoldTimes
    local userGoldTime = DigCowryData.digInfo.today_gold_num
    local leftGoldTime = tonumber(totalGoldTime) - tonumber(userGoldTime)
    local leftTime = 5
    if(leftGoldTime < 5) then
        leftTime = leftGoldTime
    end
    DigCowryNet.digCowry(function ( ... )
    --修改数据
        local totalGoldTime = vipArr[1].ernieGoldTimes
        local userGoldTime = DigCowryData.digInfo.today_gold_num
        local leftGoldTime = tonumber(totalGoldTime) - tonumber(userGoldTime)
        local useTime = 5
        if(leftGoldTime < 5 )  then
            useTime = leftGoldTime
        end

        local needGold = ActivityConfig.ConfigCache.robTomb.data[1].GoldCost
        -- DB_Ernie.getDataById(1).GoldCost
        if(leftGoldTime < 5) then
            needGold = needGold * leftGoldTime
        else
            needGold = needGold * 5
        end
        print("leftGoldTime is  >>>>>> ",leftGoldTime)
        DigCowryData.digInfo.today_gold_num = tonumber(DigCowryData.digInfo.today_gold_num) + useTime
        UserModel.addGoldNumber(- tonumber(needGold))
        goldLeftLabel:setString(UserModel.getGoldNumber())
        --减次数
        local leftGoldLabel = createDigLabel()
        leftGoldLabel:setAnchorPoint(ccp(0.5, 0.5))
        leftGoldLabel:setPosition(g_winSize.width/2, 205*g_fElementScaleRatio)
        baseLayer:addChild(leftGoldLabel)
    --如果不足10次 减少花费金币显示
        local vipArr = DB_Vip.getArrDataByField("level", UserModel.getVipLevel())
        local totalGoldTime = vipArr[1].ernieGoldTimes
        local userGoldTime = DigCowryData.digInfo.today_gold_num
        local leftGoldTime = tonumber(totalGoldTime) - tonumber(userGoldTime)
        if(leftGoldTime < 10) then
            -- costGoldLabel:setString(needGold)
        end

    --展示界面
        createPrize()
    end, leftTime, 2)
end

function onNodeEvent( eventType )
    if(eventType == "exit") then
        closeDig()
    end
end

function closeDig( ... )
    print("close digCowry")
    --图片路径
    iPath = "images/digCowry/"
--cclayer
    baseLayer = nil
--免费次数label
    normalDesNode1 = nil
--剩余探宝次数
    normalDesNode2 = nil
--剩余时间label
    leftDigTime = nil

    digPriceLabel = nil

    goldLeftLabel = nil

    CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(scheduleTag)
    scheduleTag = nil

    digType = nil
    costGoldLabel = nil

    digCD = nil
end



