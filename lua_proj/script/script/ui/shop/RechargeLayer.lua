-- Filename: RechargeLayer.lua.
-- Author: chao he   
-- Date: 2013-09-25
-- Purpose: 该文件用于显示充值界面

module("RechargeLayer",package.seeall)

require "script/model/DataCache"
require "script/model/user/UserModel"
require "script/ui/tip/AnimationTip"
require "script/ui/tip/AlertTip"
require "script/libs/LuaCCMenuItem"
require "script/ui/item/ItemSprite"
require "script/ui/item/ItemUtil"   
require "script/network/RequestCenter"
require "script/ui/shop/GiftsPakLayer"
require "script/ui/shop/RechargeCell"
require "db/DB_First_gift"
require "db/DB_Pay_list"
require "db/DB_Vip"
require "script/ui/shop/RecharData"

local _bgLayer 				-- 灰色的layer
local _touchProperty
local _chargeBg             -- 9宫格的背景面板
local _myTableView          -- 
local _myTableViewSpite
local _chargeNum            -- 再充值的钱数，可以生到下一级
local _boolCharge           -- 判断是否充值过 false:首冲 ， true：冲过
local _canBuyMonthCard      -- 判断是否有买过

local _isMaxVipLevel
local _curPayMoney          -- 当前冲的money
local _levelUpMoney         -- 升级要冲的money
local _expSprite            -- 经验条
local _expSpriteSize
local _payData              -- 所有充钱的数据
local _curVipLevel          -- 当前vip的等级
local _chargeContent        -- 文字：在充值xx ，
-- local _integralNumLabel     -- 积分的数量
local _curVip               -- 当前vip
local _vipDesc2
local _vipDesc
local _chargeContent2             -- 文字 vip x 可够买下列物品  
local _vipBg                -- vipx 尊享礼包及其的背影
local closeBtn = nil

local _rechargeChangedDelegate= nil

local function init( )
	_bgLayer = nil
    _touchProperty= nil
    _chargeBg = nil
    _curVip = nil
    _boolCharge = true
    _canBuyMonthCard=true
    _myTableView = nil
    _myTableViewSpite = nil
    _payData = {}
    _chargeNum = 0
    _curPayMoney = 0
    _levelUpMoney = 1
    _vipDesc2 = nil
    _vipDesc = nil
    _vipBg = nil
    _expSpriteSize= nil
    _curVipLevel = UserModel.getVipLevel()
    _isMaxVipLevel= false
end

-- layer 的回调函数
local function layerToucCb(eventType, x, y)
	return true
end

-- 关闭按钮的回调函数
function closeCb()
    require "script/audio/AudioUtil"
    AudioUtil.playEffect("audio/effect/guanbi.mp3")
    ---[==[签到 新手引导屏蔽层
    ---------------------新手引导---------------------------------
    --add by licong 2013.09.29
    require "script/guide/NewGuide"
    if(NewGuide.guideClass == ksGuideSignIn) then
        require "script/guide/SignInGuide"
        SignInGuide.changLayer()
    end
    ---------------------end-------------------------------------
    --]==]
	_bgLayer:removeFromParentAndCleanup(true)
	_bgLayer = nil
    -- 新手引导 第8步
    addGuideSignInGuide8()
end


-- 创建TableView 
local function createTableView( )

    if(_myTableViewSpite ~= nil ) then
        _myTableViewSpite:removeFromParentAndCleanup(true)
        _myTableViewSpite = nil
    end
    local tableViewSpSize= CCSizeMake(565,411)
    local tableViewSize = CCSizeMake(552,400)

    if(_isMaxVipLevel == true) then
         tableViewSpSize= CCSizeMake(565,591)
         tableViewSize = CCSizeMake(552,580)
    end

    --充值的数据，首冲前和首冲后的数据分开
    _payData = RecharData.getChargeData()
    local monthCardData= RecharData.getMonthCardData()

    -- tableView 的背景
    _myTableViewSpite = CCScale9Sprite:create("images/common/bg/bg_ng_attr.png")
    _myTableViewSpite:setContentSize(tableViewSpSize)
    _myTableViewSpite:setPosition(ccp(_chargeBg:getContentSize().width*0.5,37))
    _myTableViewSpite:setAnchorPoint(ccp(0.5,0))
    _chargeBg:addChild(_myTableViewSpite)


    local contentScrollView = CCScrollView:create()
    contentScrollView:setViewSize(CCSizeMake(tableViewSize.width, tableViewSize.height))
    contentScrollView:setDirection(kCCScrollViewDirectionVertical)
    contentScrollView:setTouchPriority(_touchProperty )
    local scrollLayer = CCLayer:create()
    contentScrollView:setContainer(scrollLayer)

    scrollLayer:setPosition(ccp(0,0))

    contentScrollView:setPosition(ccp(0,0))

    _myTableViewSpite:addChild(contentScrollView)


    local vCellOffset = 7
    local x_pos = 3 -- _alertBgSize.width/2
    local y_pos = 0


    for i=#_payData,1,-1 do 
      
        local rechargeCell = RechargeCell.createRechargeCell(_payData[i] , _touchProperty-2)
        local nHeight= rechargeCell:getContentSize().height
        rechargeCell:setPosition(ccp(x_pos, y_pos))
        scrollLayer:addChild(rechargeCell)
        y_pos = y_pos + nHeight + vCellOffset
    end

   -- if(BTUtil:isAppStore() ) then
    local monthCardCell= RechargeCell.createMonthCardCell(monthCardData, _touchProperty-2)
    local nHeight= monthCardCell:getContentSize().height
    monthCardCell:setPosition(ccp(x_pos, y_pos))
    scrollLayer:addChild(monthCardCell)
    y_pos = y_pos + nHeight + vCellOffset
    -- end

    contentScrollView:setContentSize(CCSizeMake(tableViewSize.width,y_pos))
    scrollLayer:setContentSize(CCSizeMake(tableViewSize.width,y_pos))
    -- clContentContainer:setPosition(ccp(0, 650-y_pos))
    contentScrollView:setContentOffset(ccp(0,contentScrollView:getViewSize().height-scrollLayer:getContentSize().height))
end

 
local function chargeInfoAction(cbFlag, dictData, bRet )
    if (dictData.err == "ok") then
        -- 未充值，显示首冲
        RecharData.setChargeInfo(dictData.ret )
        if(dictData.ret.is_pay == "false") then
            _boolCharge = false
        elseif(dictData.ret.is_pay == "true") then
            _boolCharge = true
        end

        if(dictData.ret.can_buy_monthlycard== "false") then
            _canBuyMonthCard=false
        elseif(dictData.ret.can_buy_monthlycard== "true")then
             _canBuyMonthCard= true
        end 


        -- if(dictData.ret. )

        print(" ========    ====", _boolCharge)
        --首冲前的首冲物品展示
        createVipGiftUI(_boolCharge)
        createTableView(_boolCharge)
        createVipDescUI(_boolCharge)
    end
end

 -- 创建 vip 礼包的物品展示界面 ，显示物品 
function createVipGiftUI(_boolCharge )

    if(_vipBg ~= nil) then
        _vipBg:removeFromParentAndCleanup(true)
        _vipBg= nil
    end

    -- 判断是否满级
    local nextVipLevel
    if(tonumber(UserModel.getVipLevel()) == tonumber(table.count(DB_Vip.Vip) -1)) then
        nextVipLevel = tonumber(UserModel.getVipLevel()) 
    else
        nextVipLevel = tonumber(UserModel.getVipLevel()) +1
    end
    ---  vip 尊享礼包
    _vipBg = CCScale9Sprite:create("images/common/bg/bg_ng_attr.png")
    _vipBg:setContentSize(CCSizeMake(566,166))
    _vipBg:setPosition(ccp(_chargeBg:getContentSize().width/2,460))
    _vipBg:setAnchorPoint(ccp(0.5,0))

    if(_isMaxVipLevel == true) then
        _vipBg:setPosition(ccp(_chargeBg:getContentSize().width/2,472))
        _vipBg:setVisible(false)
    end

    _chargeBg:addChild(_vipBg)
    vipTitleSp = CCSprite:create("images/reward/cell_title_panel.png")
    vipTitleSp:setPosition(ccp(2,138))
    _vipBg:addChild(vipTitleSp)

    local alertContent = {}

    if(_boolCharge == true ) then
        alertContent[1] = CCSprite:create("images/common/vip.png")
        alertContent[2] = LuaCC.createNumberSprite("images/main/vip", nextVipLevel)
        alertContent[3] = CCSprite:create("images/shop/vip_desc.png")
    else
        alertContent[1] = CCSprite:create("images/shop/first_charge.png")
    end
    local vipDesc = BaseUI.createHorizontalNode(alertContent)
    vipDesc:setPosition(ccp(vipTitleSp:getContentSize().width*0.5, vipTitleSp:getContentSize().height*0.5))
    vipDesc:setAnchorPoint(ccp(0.5,0.5))
    vipTitleSp:addChild(vipDesc)

    -- 显示物品图片
    local items = GiftsPakLayer.getVipItemInfo(_boolCharge, nextVipLevel)
    for i=1, 4 do 
        if(items[i]~= nil) then
            local itemSprite 
            local itemName
             local itemNameLabel
            if(items[i].type== "item") then
               itemSprite =ItemSprite.getItemSpriteById(items[i].tid,nil, itemDelegateAction,nil, _touchProperty-6, 1200) --ItemSprite.getItemSpriteByItemId(tonumber(items[i].tid))
               local itemTableInfo = ItemUtil.getItemById(tonumber(items[i].tid))
               itemName = itemTableInfo.name
            elseif(items[i].type == "gold") then  
                -- 首冲
               itemSprite = ItemSprite.getGoldIconSprite()
               itemName= GetLocalizeStringBy("key_2385")
            elseif(items[i].type == "silver") then  
                -- 首冲
               itemSprite = ItemSprite.getBigSilverSprite()
               itemName= GetLocalizeStringBy("key_2889") .. items[i].num
            end

            itemSprite:setPosition(ccp(28+(i-1)*138,_vipBg:getContentSize().height/2))
            itemSprite:setAnchorPoint(ccp(0,0.5))
            _vipBg:addChild(itemSprite)
            itemNameLabel = CCRenderLabel:create(itemName , g_sFontName,18,1,ccc3(0x00,0x00,0x0),type_stroke)
            itemNameLabel:setPosition(ccp(73+(i-1)*138,8))
            itemNameLabel:setAnchorPoint(ccp(0.5,0))
            _vipBg:addChild(itemNameLabel)
        end
    end

    -- nnd ,没有物品，做特殊处理
    if(table.isEmpty(items)  ) then
        local tipNameLabel = CCRenderLabel:create(GetLocalizeStringBy("key_1209") , g_sFontPangWa ,34 ,1,ccc3(0x00,0x00,0x0),type_stroke)
        tipNameLabel:setPosition(_vipBg:getContentSize().width/2,_vipBg:getContentSize().height/2 )
        tipNameLabel:setAnchorPoint(ccp(0.5,0.5))
        tipNameLabel:setColor(ccc3(0xff,0xe4,0x00))
        _vipBg:addChild(tipNameLabel)
    end

end

function itemDelegateAction(  )
    MainScene.setMainSceneViewsVisible(true, false, true)
end


-- vip 特权的按钮的回调函数
local function vipPowerCallBack( )
    require "script/audio/AudioUtil"
    AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
    require "script/ui/shop/VipPrivilegeLayer"
    VipPrivilegeLayer.addPopLayer(_touchProperty-10)
end

-- 文字 ：vip 2 可购买下列尊享礼包
function createVipDescUI( )
    if(_vipDesc2 ~= nil ) then
        _vipDesc2:removeFromParentAndCleanup(true)
        _vipDesc2 = nil

        _vipDesc:removeFromParentAndCleanup(true)
        _vipDesc = nil
    end

    -- 文字 ：再充值 xxx 元，您将成为vip 2 
     -- 判断是否满级
    local nextVipLevel
    if(tonumber(UserModel.getVipLevel()) == tonumber(table.count(DB_Vip.Vip) -1)) then
        nextVipLevel = tonumber(UserModel.getVipLevel()) +1
    else
        nextVipLevel = tonumber(UserModel.getVipLevel()) +1
    end
    _chargeContent= {}
    if(_isMaxVipLevel == false) then
        _chargeContent[1] = CCRenderLabel:create(GetLocalizeStringBy("key_2106") .. _levelUpMoney-_curPayMoney .. GetLocalizeStringBy("key_1981"), g_sFontName, 24, 1, ccc3(0x00, 0x00, 0x00), type_stroke)
        _chargeContent[1]:setColor(ccc3(0xff,0xe4,0x00))
        _chargeContent[2] = CCSprite:create("images/common/vip.png")
        _chargeContent[3] = LuaCC.createNumberSprite("images/main/vip",nextVipLevel)

        _vipDesc = BaseUI.createHorizontalNode(_chargeContent)
        _vipDesc:setPosition(ccp(35,703))
        _chargeBg:addChild(_vipDesc)
    else
        _chargeContent[1] =  CCRenderLabel:create(GetLocalizeStringBy("key_1918") .. _curPayMoney .. GetLocalizeStringBy("key_1491"), g_sFontName,24,1,ccc3(0,0,0), type_stroke)
        _chargeContent[1]:setColor(ccc3(0xff,0xe4,0x00))
        _vipDesc = BaseUI.createHorizontalNode(_chargeContent)
        _vipDesc:setPosition(ccp(35,680))
        _chargeBg:addChild(_vipDesc)
    end

     _chargeContent2= {}

    if(_boolCharge == true and _isMaxVipLevel== false ) then
     
        _chargeContent2[1] = CCSprite:create("images/common/vip.png")
        _chargeContent2[2] = LuaCC.createNumberSprite("images/main/vip", nextVipLevel)
        _chargeContent2[3] = CCRenderLabel:create(GetLocalizeStringBy("key_2649"), g_sFontName, 24, 1, ccc3(0x00, 0x00, 0x00), type_stroke)
        _chargeContent2[3]:setColor(ccc3(0xff,0xe4,0x00))

       _vipDesc2 = BaseUI.createHorizontalNode(_chargeContent2)
        _vipDesc2:setPosition(ccp(35,665))
        _chargeBg:addChild(_vipDesc2)
    elseif(_boolCharge == false and _isMaxVipLevel == false) then
        _chargeContent2[1] = CCRenderLabel:create(GetLocalizeStringBy("key_1887"), g_sFontName,24,1,ccc3(0,0,0), type_stroke)
        _chargeContent2[1]:setColor(ccc3(0xff,0xe4,0x00))
        _vipDesc2 = BaseUI.createHorizontalNode(_chargeContent2)
        _vipDesc2:setPosition(ccp(35,655))
        _chargeBg:addChild(_vipDesc2)
    end
end

-- 计算当前的钱数和满级的钱数
function calLevelUpMoney( ... )

    -- 判断当前用户是否已满级 ，满级时，_levelUpMoney 为当前的级rechargeValue
    local nextVipLevelData
    if(tonumber(UserModel.getVipLevel()) == tonumber(table.count(DB_Vip.Vip) -1)) then
        nextVipLevelData = DB_Vip.getDataById(UserModel.getVipLevel()+1)
        _isMaxVipLevel = true
    else
        nextVipLevelData = DB_Vip.getDataById(UserModel.getVipLevel()+2)
    end
     _levelUpMoney = nextVipLevelData.rechargeValue or 0
    _curPayMoney =  DataCache.getChargeGoldNum() --UserModel.getChargeGoldNum() or 0
   if(tonumber(_curPayMoney)>tonumber(_levelUpMoney) ) then
        _levelUpMoney = _curPayMoney
   end
end

-- 当前 vip等级Vip
function createCurVip( )
    if(_curVip~= nil) then
        _curVip:removeFromParentAndCleanup(true)
        _curVip = nil
    end

    local alertContent = {}
    alertContent[1] = CCSprite:create("images/shop/vip_big/vip.png")
    alertContent[2] = LuaCC.createNumberSprite("images/shop/vip_big", UserModel.getVipLevel())

    _curVip = BaseUI.createHorizontalNode(alertContent)
    _curVip:setPosition(ccp(30,744))
    _chargeBg:addChild(_curVip)

end

function createLayer( touchProperty)
    init()
    calLevelUpMoney()
    _touchProperty = touchProperty or -551
	_bgLayer = CCLayerColor:create(ccc4(11,11,11,166))

	-- 设置灰色layer的优先级
    _bgLayer:setTouchEnabled(true)
    _bgLayer:registerScriptTouchHandler(layerToucCb,false,_touchProperty,true)

    local myScale = MainScene.elementScale
	local mySize = CCSizeMake(625,838)
	-- 背景
	local fullRect = CCRectMake(0, 0, 213, 171)
	local insetRect = CCRectMake(84, 84, 2, 3)
    _chargeBg = CCScale9Sprite:create("images/common/viewbg1.png",fullRect,insetRect)
    _chargeBg:setContentSize(mySize)
    _chargeBg:setScale(myScale)
    _chargeBg:setPosition(ccp(g_winSize.width*0.5,g_winSize.height*0.5))
    _chargeBg:setAnchorPoint(ccp(0.5,0.5))
    _bgLayer:addChild(_chargeBg)

    local titleBg= CCSprite:create("images/common/viewtitle1.png")
	titleBg:setPosition(ccp(_chargeBg:getContentSize().width*0.5, _chargeBg:getContentSize().height-6))
	titleBg:setAnchorPoint(ccp(0.5, 0.5))
	_chargeBg:addChild(titleBg)

	 --武将兑换的的标题文本
	local labelTitle = CCRenderLabel:create(GetLocalizeStringBy("key_1170"), g_sFontPangWa,33,2,ccc3(0x00,0x00,0x0),type_shadow)
	labelTitle:setPosition(ccp(titleBg:getContentSize().width/2, (titleBg:getContentSize().height-1)/2))
	labelTitle:setColor(ccc3(0xff,0xe4,0x00))
	labelTitle:setPosition(ccp(titleBg:getContentSize().width*0.5,titleBg:getContentSize().height*0.5))
    labelTitle:setAnchorPoint(ccp(0.5,0.5))
	titleBg:addChild(labelTitle)

	-- 关闭按钮
    local menu = CCMenu:create()
    menu:setPosition(ccp(0,0))
    menu:setTouchPriority(_touchProperty-1)
    _chargeBg:addChild(menu,99)
    closeBtn = CCMenuItemImage:create("images/common/btn_close_n.png", "images/common/btn_close_h.png")
    closeBtn:setPosition(ccp(mySize.width*1.02,mySize.height*1.02))
    closeBtn:setAnchorPoint(ccp(1,1))
    closeBtn:registerScriptTapHandler(closeCb)
    menu:addChild(closeBtn)

    -- 当前 vip
    createCurVip()

    -- 经验条背景 和 经验条 ,及 充得钱数
    local expBackground = CCScale9Sprite:create("images/shop/exp_bg.png")
    expBackground:setPosition(ccp(195,740))
    _chargeBg:addChild(expBackground)

    _expSprite = CCSprite:create("images/shop/exp_progress.png")
    local rate = _curPayMoney/_levelUpMoney
    if(rate ~= 0 and rate< 0.05 ) then
        rate = 0.05
    end

    _expSpriteSize= _expSprite:getContentSize()
    _expSprite:setTextureRect(CCRectMake(0, 0, _expSprite:getContentSize().width*rate, _expSprite:getContentSize().height))
    _expSprite:setPosition(ccp(0,0))
    _expSprite:setAnchorPoint(ccp(0,0))
    expBackground:addChild(_expSprite)

    _expLabel = CCLabelTTF:create(_curPayMoney .. "/" .. _levelUpMoney ,g_sFontName,20)
    _expLabel:setColor(ccc3(0xff,0xff,0xff))
    _expLabel:setPosition(ccp(expBackground:getContentSize().width*0.5, expBackground:getContentSize().height*0.5))
    _expLabel:setAnchorPoint(ccp(0.5,0.5))
    expBackground:addChild(_expLabel)

    -- 查看vip 权限按钮
    local image_n = "images/common/btn/btn_violet_n.png"
    local image_h = "images/common/btn/btn_violet_h.png"
    local rect_full   = CCRectMake(0,0,119,64)
    local rect_inset  = CCRectMake(25,20,13,3)
    -- local rect_full_h   = CCRectMake(0,0,73,53)
    -- local rect_inset_h  = CCRectMake(35,25,3,3)
    local btn_size_n    = CCSizeMake(220, 64)
    local btn_size_h    = CCSizeMake(222, 64)   
    local text_color_n  = ccc3(0xfe, 0xdb, 0x1c) 
    local text_color_h  = ccc3(0xfe, 0xdb, 0x1c) 
    local font          = g_sFontPangWa
    local font_size     = 30
    local strokeCor_n   = ccc3(0x00, 0x00, 0x00) 
    local strokeCor_h   = ccc3(0x00, 0x00, 0x00)  
    local stroke_size   = 1
    local vipPowerItem = LuaCCMenuItem.createMenuItemOfRender( image_n, image_h, rect_full, rect_inset, rect_full, rect_inset, btn_size_n, btn_size_h, GetLocalizeStringBy("key_3054"), text_color_n, text_color_h, font, font_size, strokeCor_n, strokeCor_h, stroke_size )
    vipPowerItem:setPosition(ccp(380,645))
    vipPowerItem:registerScriptTapHandler(vipPowerCallBack)
    menu:addChild(vipPowerItem,1, 1000)

    if(_isMaxVipLevel == true) then
        vipPowerItem:setPosition(ccp(380,665))
    end

    Network.rpc(chargeInfoAction, "user.getChargeInfo", "user.getChargeInfo", nil, true)    

    local seq = CCSequence:createWithTwoActions(CCDelayTime:create(0.3),CCCallFunc:create(function ( ... )
            addGuideSignInGuide6()
        end))
    _bgLayer:runAction(seq)

	return _bgLayer
end

-- 获得优先级
function getTouchProperty(  )
    return _touchProperty
end

-- 更新经验条及所有的充值的钱数
local function updateExp( )
    calLevelUpMoney()
    if(_expLabel == nil) then
        return
    end
    _expLabel:setString(_curPayMoney .. "/" .. _levelUpMoney )
    local rate = _curPayMoney/_levelUpMoney
    if(rate ~= 0 and rate< 0.05 ) then
        rate = 0.05
    end
    print("rate is : ", rate )
    _expSprite:setTextureRect(CCRectMake(0, 0, _expSpriteSize.width*rate, _expSprite:getContentSize().height))

end


-- 充值完成后，刷新ui
function refreshUI( )
    require "script/model/user/UserModel"
    local userInfo = UserModel.getUserInfo()
    if userInfo == nil then
        return
    end
   
    
    if(_bgLayer == nil) then
        return
    end
    -- 更新经验条
    updateExp()
    --判断vip是否升级
   if(UserModel.getVipLevel() > _curVipLevel) then
         -- 重新
        createCurVip()
        createVipDescUI()
    else
        _chargeContent[1]:setString(GetLocalizeStringBy("key_2106") .. _levelUpMoney-_curPayMoney .. GetLocalizeStringBy("key_1981"))
    end  
    createVipGiftUI(_boolCharge )
    createTableView(_boolCharge)
end


-- added by zhz
-- 充值
function chargeUserGold(tParam)

    require "script/ui/tip/AnimationTip"
    if not (tParam and type(tParam)=="table") then
        return
    end

    if(tonumber(tParam.charge_type) ~=  2 ) then
        _boolCharge =true
    end
    RecharData.setIsPay(_boolCharge)

    MainScene.updateAvatarInfo()

    if(_rechargeChangedDelegate ~= nil) then
        _rechargeChangedDelegate()
    end
    -- 您购买的月卡已到帐，获得XXXX金币，在精彩活动界面即可领取月卡每日奖励
    DataCache.setChargeGoldNum(tonumber(tParam.charge_gold_sum))
    local showStr = nil 
    if(tParam.first_pay== "true" or tParam.first_pay== true) then
       showStr=GetLocalizeStringBy("key_2573") .. tParam.charge_gold .. GetLocalizeStringBy("key_2578") ..  tParam.pay_back .. GetLocalizeStringBy("key_1899")
    elseif(tonumber(tParam.charge_type) ==  2) then
        showStr= GetLocalizeStringBy("key_4026") .. tParam.pay_back .. GetLocalizeStringBy("key_4027")
    else
        showStr = GetLocalizeStringBy("key_2573") .. tParam.charge_gold .. GetLocalizeStringBy("key_1018") ..  tParam.pay_back .. GetLocalizeStringBy("key_1899")
    end
    AlertTip.showAlert(showStr, nil)
    refreshUI( )
end

-- added 月卡冲成功后的回调
function chargeMonthCard( )
    
    RecharData.setCanBuyMonthCard(false)
    -- local showStr =   GetLocalizeStringBy("key_2824")
    -- AlertTip.showAlert(showStr, nil)
end



function registerChargeGoldCb( callbackFunc)
    _rechargeChangedDelegate = callbackFunc
end



----------------------------------- 新手引导 ----------------------------------
-- 新手引导 
-- 签到第7步得到关闭按钮
function getCloseBtnForGuide( ... )
    return closeBtn
end

-- 签到第6步充值介绍
function addGuideSignInGuide6( ... )
    require "script/guide/NewGuide"
    require "script/guide/SignInGuide"
    if(NewGuide.guideClass ==  ksGuideSignIn and SignInGuide.stepNum == 5) then
        SignInGuide.show(6, nil)
    end
end

-- 签到第8步 礼包
function addGuideSignInGuide8( ... )
    require "script/guide/NewGuide"
    require "script/guide/SignInGuide"
    if(NewGuide.guideClass ==  ksGuideSignIn and SignInGuide.stepNum == 7) then
        require "script/ui/shop/ShopLayer"
        local button = ShopLayer.getGiftsButtonForGuide()
        local touchRect   = getSpriteScreenRect(button)
        SignInGuide.show(8, touchRect)
    end
end
