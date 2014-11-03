-- Filename: VipPrivilegeLayer.lua
-- Author: fang
-- Date: 2013-09-30
-- Purpose: 该文件用于显示“VIP特权”界面

module("VipPrivilegeLayer", package.seeall)

require "script/model/DataCache"

local _bgLayer
local _cs9LayerBg
local _chargeNum            -- 再充值的钱数，可以生到下一级
local _boolCharge           -- 判断是否充值过
local _curPayMoney          -- 当前冲的money
local _levelUpMoney         -- 升级要冲的money
local _payData             	-- 所有充钱的数据
local _touchProperty        -- 

local function init( ... )
	_bgLayer = nil
	_boolCharge = true
	_payData = {}
    _chargeNum = 0
    _curPayMoney = 0
    _levelUpMoney = 1
    _cs9LayerBg = nil
    _touchProperty= nil
end

-- 计算当前的钱数和满级的钱数
function calLevelUpMoney( ... )
    -- 判断当前用户是否已满级 ，满级时，_levelUpMoney 为当前的级rechargeValue
    local nextVipLevelData
    if(tonumber(UserModel.getVipLevel()) == tonumber(table.count(DB_Vip.Vip) -1)) then
        nextVipLevelData = DB_Vip.getDataById(UserModel.getVipLevel()+1)
    else
        nextVipLevelData = DB_Vip.getDataById(UserModel.getVipLevel()+2)
    end
     _levelUpMoney = nextVipLevelData.rechargeValue or 0
    
    _curPayMoney =  DataCache.getChargeGoldNum()      -- UserModel.getChargeGoldNum() or 0
   if(tonumber(_curPayMoney)>tonumber(_levelUpMoney) ) then
        _levelUpMoney = _curPayMoney
   end
end

-- layer 的回调函数
local function layerToucCb(eventType, x, y)
	return true
end

-- 关闭按钮的回调函数
function closeCb()
    require "script/audio/AudioUtil"
    AudioUtil.playEffect("audio/effect/guanbi.mp3")
	_bgLayer:removeFromParentAndCleanup(true)
	init()
    release()
end

function addPopLayer( touchPorperty,zOrder)
	init()
	calLevelUpMoney()
	_bgLayer = CCLayerColor:create(ccc4(11,11,11,166))
	-- 设置灰色layer的优先级
    _bgLayer:setTouchEnabled(true)
    _touchProperty = touchPorperty or -553
    _zOrder= zOrder or 1111
    _bgLayer:registerScriptTouchHandler(layerToucCb,false,_touchProperty,true)

	local scene = CCDirector:sharedDirector():getRunningScene()
    scene:addChild(_bgLayer,2111)

    -- 背景
	local fullRect = CCRectMake(0, 0, 213, 171)
	local insetRect = CCRectMake(84, 84, 2, 3)
	local bgPreferredSize = {width=630, height=850}
    local cs9Bg = CCScale9Sprite:create("images/common/viewbg1.png",fullRect,insetRect)
    _cs9LayerBg=cs9Bg

    cs9Bg:setPreferredSize(CCSizeMake(bgPreferredSize.width, bgPreferredSize.height))
    cs9Bg:setScale(g_fElementScaleRatio)
    cs9Bg:setPosition(g_winSize.width/2, g_winSize.height/2)
    cs9Bg:setAnchorPoint(ccp(0.5,0.5))
    _bgLayer:addChild(cs9Bg)

    local csTitleBg= CCSprite:create("images/common/viewtitle1.png")
	csTitleBg:setPosition(cs9Bg:getContentSize().width/2, cs9Bg:getContentSize().height-6)
	csTitleBg:setAnchorPoint(ccp(0.5, 0.5))
	cs9Bg:addChild(csTitleBg)

	local labelTitle = CCRenderLabel:create(GetLocalizeStringBy("key_3285"), g_sFontPangWa,33,2,ccc3(0,0,0),type_shadow)
	labelTitle:setPosition(csTitleBg:getContentSize().width/2, (csTitleBg:getContentSize().height-1)/2)
	labelTitle:setColor(ccc3(255,0xe4,0))
	labelTitle:setPosition(ccp(csTitleBg:getContentSize().width/2,csTitleBg:getContentSize().height/2))
    labelTitle:setAnchorPoint(ccp(0.5,0.5))
	csTitleBg:addChild(labelTitle)

	local menu = CCMenu:create()
    menu:setPosition(ccp(0,0))
    menu:setTouchPriority(_touchProperty-1)
    cs9Bg:addChild(menu,99)
    local closeBtn = CCMenuItemImage:create("images/common/btn_close_n.png", "images/common/btn_close_h.png")
    closeBtn:setPosition(ccp(bgPreferredSize.width*1.02, bgPreferredSize.height*1.02))
    closeBtn:setAnchorPoint(ccp(1,1))
    closeBtn:registerScriptTapHandler(closeCb)
    menu:addChild(closeBtn)

    local alertContent = {}

    alertContent[1] = CCSprite:create("images/shop/vip_big/vip.png")
    alertContent[2] = LuaCC.createNumberSprite("images/shop/vip_big", UserModel.getVipLevel())

    local vip = BaseUI.createHorizontalNode(alertContent)
    vip:setPosition(ccp(32,744))
    cs9Bg:addChild(vip)

    -- 经验条背景 和 经验条 ,及 充得钱数
    local expBackground = CCScale9Sprite:create("images/shop/exp_bg.png")
    expBackground:setPosition(ccp(200,740))
    cs9Bg:addChild(expBackground)

    local expSprite = CCSprite:create("images/shop/exp_progress.png")
    local rate = _curPayMoney/_levelUpMoney
    if(rate ~= 0 and rate< 0.05 ) then
        rate = 0.05
    end
     expSprite:setTextureRect(CCRectMake(0, 0, expSprite:getContentSize().width*rate, expSprite:getContentSize().height))
    expSprite:setPosition(ccp(0,0))
    expSprite:setAnchorPoint(ccp(0,0))
    expBackground:addChild(expSprite)

    local expLabel = CCLabelTTF:create(_curPayMoney .. "/" .. _levelUpMoney ,g_sFontName,20)
    expLabel:setColor(ccc3(0xff,0xff,0xff))
    expLabel:setPosition(ccp(expBackground:getContentSize().width*0.5, expBackground:getContentSize().height*0.5))
    expLabel:setAnchorPoint(ccp(0.5,0.5))
    expBackground:addChild(expLabel)

    local viewSize = {}
    viewSize.height = 650
    viewSize.width = bgPreferredSize.width
    local csvDesc = CCScrollView:create()
    csvDesc:setTouchPriority(_touchProperty-1)
    csvDesc:setDirection(kCCScrollViewDirectionVertical)

    local layer = CCLayer:create()
    csvDesc:setContainer(layer)

    require "db/DB_Vip_desc"
    require "script/libs/LuaCC"
    local x = bgPreferredSize.width/2
    local anchorPoint = ccp(0.5, 0)
    local nTextAreaHeight=0
    local y = 0
    for id=1, table.count(DB_Vip_desc.Vip_desc)  do
        local vip_desc_num= table.count(DB_Vip_desc.Vip_desc)
    	local db_data = DB_Vip_desc.getDataById(vip_desc_num+1-id)
    	local cs9Cell = createVipDesc(db_data)
        cs9Cell:setPosition(x, y)
        cs9Cell:setAnchorPoint(anchorPoint)
        layer:addChild(cs9Cell)
        nTextAreaHeight = nTextAreaHeight + cs9Cell:getContentSize().height + 10
        y = y + cs9Cell:getContentSize().height + 10
    end
    DB_Vip_desc.release()

    layer:setContentSize(CCSizeMake(viewSize.width, nTextAreaHeight))
    csvDesc:setViewSize(CCSizeMake(viewSize.width, viewSize.height))
    layer:setPosition(0, viewSize.height-nTextAreaHeight)
    csvDesc:setPosition(0, 40)

    _cs9LayerBg:addChild(csvDesc)
end

-- 创建Vip等级描述
function createVipDesc(db_data)
	local height = 10
	local bgPreferredSize = {}
	bgPreferredSize.width = _cs9LayerBg:getContentSize().width*0.9
	local vipBg = CCScale9Sprite:create("images/common/bg/bg_ng_attr.png")
	local csVip = CCSprite:create("images/shop/vip_big/vip.png")
	
    local csVipNum = LuaCC.createNumberSprite("images/shop/vip_big", tostring(db_data.id-1))
	csVip:addChild(csVipNum)
	csVipNum:setPosition(csVip:getContentSize().width, 0)
	csVipNum:setAnchorPoint(ccp(0, 0))
    csVip:setContentSize(CCSizeMake(csVip:getContentSize().width+csVipNum:getContentSize().width, csVip:getContentSize().height))
	vipBg:addChild(csVip)
	height = height + csVip:getContentSize().height + 10

	local arrDesc = string.split(db_data.desc, "\n")
	local arrObjs = {}
	local nTextWidth = bgPreferredSize.width*0.94
    local nMargin = bgPreferredSize.width*0.03
	for i=1, #arrDesc do
		local clDecs = CCLabelTTF:create(arrDesc[i], g_sFontName, 24, CCSizeMake(nTextWidth, 0), kCCTextAlignmentLeft)
		height = height + clDecs:getContentSize().height + 4
        table.insert(arrObjs, clDecs)
	end
    local y = height-4
    
    bgPreferredSize.height = height
    vipBg:setPreferredSize(CCSizeMake(bgPreferredSize.width, bgPreferredSize.height))
    csVip:setAnchorPoint(ccp(0.5, 1))
    csVip:setPosition(bgPreferredSize.width/2, y)

    y = y - csVip:getContentSize().height - 6

    for i=1, #arrObjs do 
        vipBg:addChild(arrObjs[i])
        arrObjs[i]:setPosition(nMargin, y)
        arrObjs[i]:setAnchorPoint(ccp(0, 1))
        y = y - arrObjs[i]:getContentSize().height - 4
    end

	return vipBg
end

function release( ... )
	VipPrivilegeLayer = nil
    for k, v in pairs(package.loaded) do
        local s, e = string.find(k, "/VipPrivilegeLayer")
        if s and e == string.len(k) then
            package.loaded[k] = nil
        end
    end
    collectgarbage("collect", 100)
end
