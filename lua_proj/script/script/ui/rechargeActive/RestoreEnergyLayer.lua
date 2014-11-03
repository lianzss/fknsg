-- Filename：	RestoreEnergyLayer.lua
-- Author：		zhz
-- Date：		2013-8-3
-- Purpose：		整点送体力活动

module("RestoreEnergyLayer", package.seeall)


require "script/model/user/UserModel"
require "script/network/RequestCenter"
require "script/libs/LuaCC"
require "script/model/user/UserModel"
require "script/audio/AudioUtil"
require "script/ui/tip/AnimationTip"
require "script/ui/rechargeActive/ActiveCache"


local IMG_PATH = "images/recharge/restore_energy/"
local _layer 
local _receiveBtn			--领取按钮
local _earlyReceiveBtn		-- 上午 12~2点的领取的的按钮
local _chickenBtn			-- 鸡的按钮
local _eatBtn				-- 吃的按钮
local _deskSprite			-- 桌子
local _prettySprite			--
local _isOnTime				-- 是否可领取，
local _lastReceiveTime		-- 上次可以领取的时间
local _descBg 

local function init( )
	_layer = nil
	_fundBackground = nil
	_receiveBtn = nil
	_chickenBtn = nil
	_eatBtn = nil
	_deskSprite = nil
	_prettySprite = nil
	_boolReceived =false
	_descBg = nil
	_lastReceiveTime = nil
	_isOnTime= false
end 

-- 吃按钮的网络回调函数
local function supplyExecutionCb(cbFlag, dictData, bRet)
	require "script/ui/rechargeActive/RechargeActiveMain"
	if (dictData.err == "ok") then
		UserModel.addEnergyValue(tonumber(dictData.ret))
		AnimationTip.showTip(GetLocalizeStringBy("key_1984") .. dictData.ret .. GetLocalizeStringBy("key_3084"))
		ActiveCache.setSupplyTime(BTUtil:getSvrTimeInterval())
		_eatBtn:setVisible(false)
		-- _earlyReceiveBtn:setEnabled(false)
		_chickenBtn:setVisible(false)
		-- _receiveBtn:setEnabled(false)
		RechargeActiveMain.refreshItemByTag(RechargeActiveMain._tagEatChieken)
		-- 
	end
end


-- 按钮按钮时间的回调函数
local function eatCallBack( tag,item )
	if(not ActiveCache.isPassTime(_lastReceiveTime, 115900) and ActiveCache.isOnAfternoon(BTUtil:getSvrTimeInterval())) then
			_isOnTime = true
	elseif(not ActiveCache.isPassTime(_lastReceiveTime ,175900) and  ActiveCache.isOnEvening(BTUtil:getSvrTimeInterval())) then
			_isOnTime = true
	else
		_isOnTime = false
	end 
	if( _isOnTime== false ) then
		AnimationTip.showTip(GetLocalizeStringBy("key_1328"))
		return
	end

	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
	RequestCenter.supply_supplyExecution(supplyExecutionCb)	
end


-- 创建按钮
local function createBtn( )
	local menu = CCMenu:create()
	menu:setPosition(ccp(0,0))
	_deskSprite:addChild(menu,110)

	
	-- chicken
	_chickenBtn = CCMenuItemImage:create(IMG_PATH .. "chicken/chicken_n.png",IMG_PATH .. "chicken/chicken_h.png")
	_chickenBtn:setPosition(ccp(_deskSprite:getContentSize().width*0.5, _deskSprite:getContentSize().height/2))
	_chickenBtn:setAnchorPoint(ccp(0.5,0.5))
	_chickenBtn:setVisible(_isOnTime)
	_chickenBtn:registerScriptTapHandler(eatCallBack)
	menu:addChild(_chickenBtn)

	-- 吃的按钮
	_eatBtn = CCMenuItemImage:create(IMG_PATH .. "eat/eat_n.png",IMG_PATH .. "eat/eat_h.png")
	_eatBtn:setPosition(ccp(_deskSprite:getContentSize().width*0.5, 4))
	_eatBtn:setAnchorPoint(ccp(0.5,0))
	_eatBtn:setVisible(_isOnTime)
	_eatBtn:registerScriptTapHandler(eatCallBack)
	menu:addChild(_eatBtn)


	-- -- 每天18-20点
	require "script/ui/main/MenuLayer"
	local menuLayerSize = MenuLayer.getLayerContentSize()
	local height = menuLayerSize.height*g_fScaleX 
	local menubar = CCMenu:create()
	menubar:setPosition(ccp(0,0))
	menubar:setAnchorPoint(ccp(0,0))
	_layer:addChild(menubar,11)	
end


-- 获得获得上次领取的时间
local function getSupplyInfo(cbFlag, dictData, bRet )
	if (dictData.err == "ok") then
		print_t(dictData.ret)
		ActiveCache.setSupplyTime(dictData.ret) 
		-- 判断是否到时间
		-- _isOnTime =  ActiveCache.isOnEvening(BTUtil:getSvrTimeInterval())
		_lastReceiveTime = tonumber(dictData.ret) 
		--
		-- local testTime= 1389943497+3600*3
		-- print("testTime  is :")
		-- print_t(os.date("*t", testTime))
		-- 判断是否可以在 领取时间段内：12~14， 16~18
		if(not ActiveCache.isPassTime(_lastReceiveTime, 115900) and ActiveCache.isOnAfternoon(BTUtil:getSvrTimeInterval())) then
			_isOnTime = true
		elseif(not ActiveCache.isPassTime(_lastReceiveTime ,175900) and  ActiveCache.isOnEvening(BTUtil:getSvrTimeInterval())) then
			_isOnTime = true
		end

		--如果在时间范围内，则，吃
		print("is onTime   : " , _isOnTime)
		createBtn()
    end
end

--吃烧鸡的精髓：获得当前时间，判断是不是在时间范围内，并且上次是烧鸡的时间不在该时间范围内，则吃烧鸡
 function createLayer(  )
	init()
	_layer = CCLayer:create()

	
	-- 背景图
	_fundBackground = CCScale9Sprite:create(IMG_PATH .. "restore_bg.png")
	require "script/ui/main/BulletinLayer"
	require "script/ui/main/MainScene"
	require "script/ui/main/MenuLayer"
	require "script/ui/rechargeActive/RechargeActiveMain"
	local bulletinLayerSize = BulletinLayer.getLayerContentSize()
	local menuLayerSize = MenuLayer.getLayerContentSize()
	local height = g_winSize.height - ( bulletinLayerSize.height )*g_fScaleX

	-- _fundBackground:setContentSize(CCSizeMake(g_winSize.width/MainScene.elementScale, _fundBackground:getContentSize().height))
	_fundBackground:setScale((MainScene.bgScale))
	_fundBackground:setPosition(ccp(0,menuLayerSize.height*g_fScaleX))
	_layer:addChild(_fundBackground)

	-- 显示文字
	-- _descBg = CCScale9Sprite:create(IMG_PATH .. "desc_bg.png")
	-- _descBg:setScale(MainScene.bgScale)
	-- _descBg:setContentSize(CCSizeMake(g_winSize.width, 102))
	-- height = height -  RechargeActiveMain.getBgWidth()
	-- _descBg:setPosition(ccp(g_winSize.width/2, height))
	-- _descBg:setAnchorPoint(ccp(0.5,1))
	-- _layer:addChild(_descBg,111)

	-- local descLabel = CCRenderLabel:createWithAlign(GetLocalizeStringBy("key_1535"), g_sFontPangWa,25,2,ccc3(0x00,0x00,0x0),type_stroke, CCSizeMake(g_winSize.width/MainScene.bgScale,65),kCCTextAlignmentCenter,kCCVerticalTextAlignmentTop)
	-- descLabel:setPosition(ccp(_descBg:getContentSize().width*0.5, _descBg:getContentSize().height*0.5))
	-- descLabel:setColor(ccc3(0xff,0xff,0xff))
	-- descLabel:setAnchorPoint(ccp(0.5,0.5))
	-- _descBg:addChild(descLabel)
	
	-- -- 桌子
	_deskSprite = CCScale9Sprite:create(IMG_PATH .. "desk.png")
	-- _deskSprite:setContentSize(CCSizeMake(_fundBackground:getContentSize().width/MainScene.elementScale , _fundBackground:getContentSize().height/MainScene.elementScale))
	_deskSprite:setPosition(ccp(0, menuLayerSize.height*g_fScaleX))
	_deskSprite:setScale(MainScene.bgScale)
	print("desc.width is2 : ",_deskSprite:getContentSize().width , " g_winSize.width is: ", g_winSize.width )
	if(_deskSprite:getContentSize().width*MainScene.bgScale > g_winSize.width ) then
		print("desc.width is : ",_deskSprite:getContentSize().width , " g_winSize.width is: ", g_winSize.width )
		_deskSprite:setScale(MainScene.elementScale)
	end
	_layer:addChild(_deskSprite,10)

	-- -- 显示 pretty girl
	local girlHeight = _deskSprite:getContentSize().height*0.45*MainScene.elementScale +menuLayerSize.height*g_fScaleX
	_prettySprite = CCSprite:create(IMG_PATH .. "girl.png")
	_prettySprite:setPosition(ccp(g_winSize.width*0.69, girlHeight))
	_prettySprite:setScale(MainScene.elementScale)
	_prettySprite:setAnchorPoint(ccp(0.5,0))
	_layer:addChild(_prettySprite)
	_prettySprite:setScale(MainScene.elementScale)


	-- 描述文字
	_descBg = CCSprite:create(IMG_PATH .. "eat_bg.png")
	-- local widthOfBg = (_prettySprite:getPositionX()- _prettySprite:getContentSize().width*0.8)*MainScene.elementScale
	local heightOfBg = _prettySprite:getPositionY()+ (_prettySprite:getContentSize().height*0.38)*MainScene.elementScale
	_descBg:setPosition(g_winSize.width*0.25, heightOfBg)
	_descBg:setAnchorPoint(ccp(0.5,0))
	_descBg:setScale(MainScene.elementScale)
	_layer:addChild(_descBg)


	local x = _descBg:getContentSize().width*18/280
	local y = _descBg:getContentSize().height*175/248 
	local masterLabel = CCRenderLabel:create(GetLocalizeStringBy("key_2320"), g_sFontPangWa, 25, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	masterLabel:setColor(ccc3(0xff,0xea,0x00))
	masterLabel:setAnchorPoint(ccp(0,0))
	masterLabel:setPosition(ccp(x, y))
	_descBg:addChild(masterLabel)

	y =y - masterLabel:getContentSize().height -5
	local alertContent = {}
    alertContent[1]=  CCRenderLabel:create(GetLocalizeStringBy("key_3268"), g_sFontPangWa, 25, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
    alertContent[1]:setColor(ccc3(0xff,0xea,0x00))
    alertContent[2]= CCRenderLabel:create(GetLocalizeStringBy("key_1562"), g_sFontPangWa, 25, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
    alertContent[2]:setColor(ccc3(0x00,0xf6,0xff))
    alertContent[3]= CCRenderLabel:create(GetLocalizeStringBy("key_1235"), g_sFontPangWa, 25, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
    alertContent[3]:setColor(ccc3(0xff,0xea,0x00))

    local robNode = BaseUI.createHorizontalNode(alertContent)
    robNode:setPosition(x ,y)
    robNode:setAnchorPoint(ccp(0,0))
    _descBg:addChild(robNode)

     y = y - masterLabel:getContentSize().height -5
	local alertContent = {}
    alertContent[1]=  CCRenderLabel:create(GetLocalizeStringBy("key_1108"), g_sFontPangWa, 25, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
    alertContent[1]:setColor(ccc3(0x00,0xf6,0xff))
    alertContent[2]= CCRenderLabel:create(GetLocalizeStringBy("key_3271"), g_sFontPangWa, 25, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
    alertContent[2]:setColor(ccc3(0xff,0xea,0x00))

    local robNode = BaseUI.createHorizontalNode(alertContent)
    robNode:setPosition(x ,y)
    robNode:setAnchorPoint(ccp(0,0))
    _descBg:addChild(robNode)

    y= y - masterLabel:getContentSize().height-5
    local txt3Label = CCRenderLabel:create(GetLocalizeStringBy("key_1006"), g_sFontPangWa, 25, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	txt3Label:setColor(ccc3(0xff,0xea,0x00))
	txt3Label:setAnchorPoint(ccp(0,0))
	txt3Label:setPosition(x,y)
	_descBg:addChild(txt3Label)


	-- 请求网络数据，获得上次领取的时间
	-- 首次领取时，返回的时间为 0


	local args = CCArray:create()
    RequestCenter.supply_getSupplyInfo(getSupplyInfo,args)

	return _layer
end








