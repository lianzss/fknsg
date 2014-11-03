-- Filename：	VIPBenefitLayer.lua
-- Author：		Zhang zihang
-- Date：		2014-4-1
-- Purpose：		vip福利界面

--本想放在rechargeActive文件夹下，后来华仔反应那里东西太多，所以就拿出来了

module("VIPBenefitLayer", package.seeall)

require "script/ui/main/MainScene"
require "script/ui/vip_benefit/VIPNumTool"
require "script/network/Network"

local scrollBg
local vipBenefitBottom
local VBSize
local _rewardTable
local giftButton
local vipPowerItem
local haveHad
local layer
local haveLing

local function init()
	scrollBg = nil
	vipBenefitBottom = nil
	VBSize = nil
	_rewardTable = {}
	giftButton = nil
	vipPowerItem = nil
	haveHad = nil
	layer = nil
	haveLing = nil
end

local function vipPowerCallBack()
	require "script/ui/shop/VipPrivilegeLayer"
	VipPrivilegeLayer.addPopLayer()
end

function enableCallback()
	giftButton:setEnabled(true)
	vipPowerItem:setEnabled(true)
	giftButton:setVisible(false)
	haveHad:setVisible(true)
end

function getTheGifts(cbFlag, dictData, bRet)
	if not bRet then
		return
	end

	if cbFlag == "vipbonus.fetchVipBonus" then

		require "script/model/user/UserModel"

		for i = 1,#_rewardTable do
			local RTpye = _rewardTable[i].type
			local RNum = _rewardTable[i].num
			if RTpye == "silver" then
				UserModel.addSilverNumber(tonumber(RNum))
			elseif RTpye == "soul" then
				UserModel.addSoulNum(tonumber(RNum))
			elseif RTpye == "gold" then
				UserModel.addGoldNumber(tonumber(RNum))
			elseif RTpye == "execution" then
				UserModel.addEnergyValue(tonumber(RNum))
			elseif RTpye == "stamina" then
				UserModel.addStaminaNumber(tonumber(RNum))
			elseif RTpye == "jewel" then
				UserModel.addJewelNum(tonumber(RNum))
			elseif RTpye == "prestige" then
				UserModel.addPrestigeNum(tonumber(RNum))
			end
		end

		giftButton:setEnabled(false)
		vipPowerItem:setEnabled(false)
		require "script/ui/item/ReceiveReward"
		
		haveLing = "hasgot"
		
		ReceiveReward.showRewardWindow(_rewardTable,enableCallback)
	end
end

local function getReward()

	require "script/ui/hero/HeroPublicUI"
	require "script/ui/item/ItemUtil"
	if HeroPublicUI.showHeroIsLimitedUI() then

	elseif ItemUtil.isBagFull() then

	else
		local arg = CCArray:create()
		Network.rpc(getTheGifts, "vipbonus.fetchVipBonus","vipbonus.fetchVipBonus", arg, true)
	end
end

local function createScrollView()
	local scrollSize = scrollBg:getContentSize()
	local contentScrollView = CCScrollView:create()
	contentScrollView:setViewSize(CCSizeMake(scrollSize.width, scrollSize.height))
	contentScrollView:setDirection(kCCScrollViewDirectionHorizontal)
	contentScrollView:setTouchPriority(-600)
	local scrollLayer = CCLayer:create()
	contentScrollView:setContainer(scrollLayer)

	local rewardTable = {}
	rewardTable = VIPNumTool.unpackGiftInfo()
	local rewardTableNum = table.count(rewardTable)
	local scrollWide = rewardTableNum*121

	scrollLayer:setContentSize(CCSizeMake(scrollWide,scrollSize.height))
	scrollLayer:setPosition(ccp(0,0))

	contentScrollView:setPosition(ccp(0,0))

	scrollBg:addChild(contentScrollView)

	local picBeginX = 11.5

	for k,v in pairs(rewardTable) do
		local rewardSprite
		local rewardNum
		local rewardName
		rewardSprite,rewardNum,rewardName,newTable= VIPNumTool.vipGiftDetial(v)

		table.insert(_rewardTable,newTable)

		rewardSprite:setAnchorPoint(ccp(0,1))
		rewardSprite:setPosition(ccp(picBeginX,scrollSize.height-13))
		scrollLayer:addChild(rewardSprite)

		local spriteSize = rewardSprite:getContentSize()
		picBeginX = picBeginX + spriteSize.width + 23

		local numTxt = CCRenderLabel:create(tostring(rewardNum), g_sFontName ,18, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
		numTxt:setColor(ccc3(0x00,0xff,0x18))
		numTxt:setAnchorPoint(ccp(1,0))
		numTxt:setPosition(ccp(spriteSize.width-7,3))
		rewardSprite:addChild(numTxt)

		local nameTxt = CCLabelTTF:create(tostring(rewardName), g_sFontName ,18)
		nameTxt:setColor(ccc3(0xff,0xff,0xff))
		nameTxt:setAnchorPoint(ccp(0.5,1))
		nameTxt:setPosition(ccp(spriteSize.width/2,-5))
		rewardSprite:addChild(nameTxt)
	end

	local menuInner = CCMenu:create()
    menuInner:setPosition(ccp(0,0))
    menuInner:setTouchPriority(-551)
    vipBenefitBottom:addChild(menuInner)

	giftButton = LuaCC.create9ScaleMenuItem("images/common/btn/btn1_d.png","images/common/btn/btn1_n.png",CCSizeMake(200, 73),GetLocalizeStringBy("key_1715"),ccc3(0xfe, 0xdb, 0x1c),35,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00))
	giftButton:setAnchorPoint(ccp(0.5,0))
	giftButton:setPosition(ccp(VBSize.width/2,5))
	giftButton:registerScriptTapHandler(getReward)
	menuInner:addChild(giftButton)

	local rewardButtonSize = giftButton:getContentSize()



	haveHad = LuaCC.create9ScaleMenuItem("images/common/btn/btn1_g.png","images/common/btn/btn1_g.png",CCSizeMake(200, 73),GetLocalizeStringBy("key_1369"),ccc3(0xff, 0xff, 0xff),35,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00))
	--haveHad:setColor(ccc3(0xff,0xff,0xff))
	haveHad:setAnchorPoint(ccp(0.5,0.5))
	haveHad:setPosition(ccp(VBSize.width/2,5+rewardButtonSize.height/2))
	menuInner:addChild(haveHad)

	if tostring(haveLing) == "ok" then
		giftButton:setVisible(true)
		haveHad:setVisible(false)
	elseif tostring(haveLing) == "hasgot" then
		giftButton:setVisible(false)
		haveHad:setVisible(true)
	end
end

function  doWeHave(cbFlag, dictData, bRet)
	if not bRet then
		return
	end

	if cbFlag == "vipbonus.getVipBonusInfo" then
		print(GetLocalizeStringBy("key_1060"))
		print_t(dictData)
		print_t(dictData.ret)
		haveLing = dictData.ret
		require "script/ui/main/BulletinLayer"
		require "script/ui/rechargeActive/RechargeActiveMain"
		require "script/ui/main/MenuLayer"
		local bulletSize = BulletinLayer.getLayerContentSize()
		local rechargeHeight = RechargeActiveMain.getBgWidth()
		local menuLayerSize = MenuLayer.getLayerContentSize()

		local backGroundPic = CCScale9Sprite:create("images/recharge/vip_benefit/redBg.png")
		backGroundPic:setPreferredSize(CCSizeMake(640,960))
		backGroundPic:setScale(MainScene.bgScale)
		layer:addChild(backGroundPic)

		local sunPosY = g_winSize.height - bulletSize.height*g_fScaleX - rechargeHeight

		local sunShine = CCSprite:create("images/recharge/vip_benefit/sunShine.png")
		sunShine:setPosition(ccp(g_winSize.width/2,sunPosY))
		sunShine:setAnchorPoint(ccp(0.5,1))
		sunShine:setScale(MainScene.elementScale)
		layer:addChild(sunShine)

		--local zhenPosY = sunPosY - 10*g_fScaleY
		local zhenPosY = sunPosY

		local missZhen = CCSprite:create("images/recharge/vip_benefit/zhenji.png")
		missZhen:setAnchorPoint(ccp(0,1))
		missZhen:setPosition(ccp(0,zhenPosY))
		missZhen:setScale(g_fScaleY * 1.1)
		layer:addChild(missZhen)	

		bFPosY = sunPosY - 20*g_fScaleY

		local butterFly = CCSprite:create("images/recharge/vip_benefit/butterfly.png")
		butterFly:setPosition(ccp(g_winSize.width,bFPosY))
		butterFly:setAnchorPoint(ccp(1,1))
		butterFly:setScale(MainScene.elementScale)
		layer:addChild(butterFly)

		-- local desPosY = sunPosY - 115*g_fScaleY

		-- local desButtom = CCScale9Sprite:create("images/recharge/vip_benefit/desButtom.png")
		-- desButtom:setPreferredSize(CCSizeMake(380,150))
		-- desButtom:setAnchorPoint(ccp(0.5,1))
		-- desButtom:setPosition(ccp(g_winSize.width*2/3,desPosY))
		-- desButtom:setScale(MainScene.elementScale)
		-- layer:addChild(desButtom)

		-- local desBSize = desButtom:getContentSize()

		-- local arrow = CCSprite:create("images/common/star_bg.png")
		-- arrow:setAnchorPoint(ccp(0.5,0.5))
		-- arrow:setPosition(ccp(desBSize.width/2,desBSize.height*2/3+20))
		-- arrow:setScaleX(1.5)
		-- desButtom:addChild(arrow)

		-- local desVIP = CCSprite:create("images/recharge/vip_benefit/des.png")
		-- desVIP:setAnchorPoint(ccp(0.5,0.5))
		-- desVIP:setPosition(ccp(desBSize.width/2,desBSize.height/2))
		-- desButtom:addChild(desVIP)

		-- local flowerPosY = sunPosY + 30*g_fScaleY

		-- local vipFlower = CCSprite:create("images/recharge/vip_benefit/vipflower.png")
		-- vipFlower:setPosition(ccp(g_winSize.width*2/3,flowerPosY))
		-- vipFlower:setAnchorPoint(ccp(0.5,1))
		-- vipFlower:setScale(MainScene.elementScale)
		-- layer:addChild(vipFlower)

		-- local flowerSize = vipFlower:getContentSize()

		-- local benefitTitle = CCSprite:create("images/recharge/vip_benefit/fuli.png")
		-- benefitTitle:setPosition(ccp(flowerSize.width/2,15))
		-- benefitTitle:setAnchorPoint(ccp(0.5,0))
		-- vipFlower:addChild(benefitTitle)

		local vipBPosY = menuLayerSize.height*g_fScaleX + 10*g_fScaleY
		--local vipBPosY = sunPosY - 370*g_fScaleY

		vipBenefitBottom = CCScale9Sprite:create(CCRectMake(33, 35, 12, 45),"images/recharge/vip_benefit/vipBB.png")
		vipBenefitBottom:setPreferredSize(CCSizeMake(630,255))
		vipBenefitBottom:setPosition(ccp(g_winSize.width/2,vipBPosY))
		vipBenefitBottom:setScale(MainScene.elementScale)
		vipBenefitBottom:setAnchorPoint(ccp(0.5,0))
		layer:addChild(vipBenefitBottom)

		VBSize = vipBenefitBottom:getContentSize() 

		local everyDayB = CCScale9Sprite:create(CCRectMake(86, 32, 4, 3),"images/recharge/vip_benefit/everyday.png")
		everyDayB:setPreferredSize(CCSizeMake(380,68))
		everyDayB:setAnchorPoint(ccp(0.5,0.5))
		everyDayB:setPosition(ccp(VBSize.width/2,VBSize.height-3))
		vipBenefitBottom:addChild(everyDayB)

		local everyDaySize = everyDayB:getContentSize()

		local levelDes = CCSprite:create("images/recharge/vip_benefit/vipwenzi.png")
		levelDes:setAnchorPoint(ccp(0.5,0.5))
		levelDes:setPosition(ccp(everyDaySize.width/2,everyDaySize.height/2))
		everyDayB:addChild(levelDes)

		local LDSize = levelDes:getContentSize()

		local vipLevelNum = VIPNumTool.getVIPNumSprite()
		vipLevelNum:setAnchorPoint(ccp(0.5,0.5))
		vipLevelNum:setPosition(ccp(86,LDSize.height/2))
		levelDes:addChild(vipLevelNum)

		scrollBg = CCScale9Sprite:create("images/common/bg/bg_ng_attr.png")
		scrollBg:setPreferredSize(CCSizeMake(605,145))
		scrollBg:setAnchorPoint(ccp(0.5,1))
		scrollBg:setPosition(ccp(VBSize.width/2,VBSize.height-everyDaySize.height/2-3))
		vipBenefitBottom:addChild(scrollBg)

		--查看vip特权按钮
		local image_n = "images/common/btn/btn_violet_n.png"
	    local image_h = "images/common/btn/btn_violet_h.png"
	    local rect_full   = CCRectMake(0,0,119,64)
	    local rect_inset  = CCRectMake(25,20,13,3)
	    local btn_size_n    = CCSizeMake(220, 64)
	    local btn_size_h    = CCSizeMake(222, 64)   
	    local text_color_n  = ccc3(0xfe, 0xdb, 0x1c) 
	    local text_color_h  = ccc3(0xfe, 0xdb, 0x1c) 
	    local font          = g_sFontPangWa
	    local font_size     = 30
	    local strokeCor_n   = ccc3(0x00, 0x00, 0x00) 
	    local strokeCor_h   = ccc3(0x00, 0x00, 0x00)  
	    local stroke_size   = 1

	    local menu = CCMenu:create()
	    menu:setPosition(ccp(0,0))
	    menu:setTouchPriority(-551)
	    layer:addChild(menu)

	    local minusHeight = sunPosY - (menuLayerSize.height*g_fScaleX + 10*g_fScaleY + VBSize.height*MainScene.elementScale + everyDaySize.height/2*MainScene.elementScale)

	    --local vipPosY = (sunPosY - 115*g_fScaleY - desBSize.height*MainScene.elementScale)/2 + (menuLayerSize.height*g_fScaleX + 10*g_fScaleY + VBSize.height*MainScene.elementScale + everyDaySize.height/2*MainScene.elementScale)/2
	    --local vipPosY = menuLayerSize.height*g_fScaleX + 10*g_fScaleY + VBSize.height*MainScene.elementScale + everyDaySize.height/2*MainScene.elementScale

	    local vipPosY = sunPosY - minusHeight*0.9

		vipPowerItem = LuaCCMenuItem.createMenuItemOfRender( image_n, image_h, rect_full, rect_inset, rect_full, rect_inset, btn_size_n, btn_size_h, GetLocalizeStringBy("key_3054"), text_color_n, text_color_h, font, font_size, strokeCor_n, strokeCor_h, stroke_size )
		vipPowerItem:setAnchorPoint(ccp(0.5,0.5))
		vipPowerItem:setPosition(ccp(g_winSize.width*2/3,vipPosY))
		vipPowerItem:setScale(MainScene.elementScale)
		vipPowerItem:registerScriptTapHandler(vipPowerCallBack)
		menu:addChild(vipPowerItem)

		local desPosY = sunPosY - minusHeight*0.56

		local desButtom = CCScale9Sprite:create("images/recharge/vip_benefit/desButtom.png")
		desButtom:setPreferredSize(CCSizeMake(380,150))
		desButtom:setAnchorPoint(ccp(0.5,0.5))
		desButtom:setPosition(ccp(g_winSize.width*2/3,desPosY))
		desButtom:setScale(MainScene.elementScale)
		layer:addChild(desButtom)

		local desBSize = desButtom:getContentSize()

		local arrow = CCSprite:create("images/common/star_bg.png")
		arrow:setAnchorPoint(ccp(0.5,0.5))
		arrow:setPosition(ccp(desBSize.width/2,desBSize.height*2/3+20))
		arrow:setScaleX(1.5)
		desButtom:addChild(arrow)

		local desVIP = CCSprite:create("images/recharge/vip_benefit/des.png")
		desVIP:setAnchorPoint(ccp(0.5,0.5))
		desVIP:setPosition(ccp(desBSize.width/2,desBSize.height/2))
		desButtom:addChild(desVIP)

		local flowerPosY = sunPosY - minusHeight*0.25

		local vipFlower = CCSprite:create("images/recharge/vip_benefit/vipflower.png")
		vipFlower:setPosition(ccp(g_winSize.width*2/3,flowerPosY))
		vipFlower:setAnchorPoint(ccp(0.5,0))
		vipFlower:setScale(MainScene.elementScale)
		layer:addChild(vipFlower)

		local flowerSize = vipFlower:getContentSize()

		local benefitTitle = CCSprite:create("images/recharge/vip_benefit/fuli.png")
		benefitTitle:setPosition(ccp(flowerSize.width/2,15))
		benefitTitle:setAnchorPoint(ccp(0.5,0))
		vipFlower:addChild(benefitTitle)

		createScrollView()
	end
end

local function desideHaven()
	local arg = CCArray:create()
	Network.rpc(doWeHave, "vipbonus.getVipBonusInfo","vipbonus.getVipBonusInfo", arg, true)
end

function createLayer()
	init()

	layer = CCLayer:create()
	
	desideHaven()

	return layer
end

function writeHave(haveRet)
	haveLing = haveRet
end

function readHave()
	return haveLing
end
