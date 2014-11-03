-- Filename: SeniorHeroRecruitLayer.lua
-- Author: fang
-- Date: 2013-09-30
-- Purpose: 该文件用于: 神将招将功能

module("SeniorHeroRecruitLayer", package.seeall)

require "script/utils/BaseUI"
require "script/ui/tip/LackGoldTip"


local _tagPopupPanel=2001
local _tagCloseButton=2002
local _tagRecruitOne=2003
local _tagRecruitTen=2004

-- 招将10次界面相关变量
local _tagPopupPanelOfRecruitTen=3001
local _tagQuit = 3002
-- 招将10次界面背景层
local _clRecruitTenBg
local _arrObjsRecruitText
local _arrObjsCardShow

-- 消耗金币
local _nCostGold

local _costGoldOfTen 		-- 十连抽消耗的金币
local _numOfTenRecuit		-- 十连抽抽的武将

local fnHandlerOfNetworkRecruitOne

local _btnRecruitOne


-- “关闭”按钮事件回调处理
local function fnHandlerOfSenionRecruit(tag, obj)
	AudioUtil.playEffect("audio/effect/guanbi.mp3")
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	local seniorPanel = runningScene:getChildByTag(_tagPopupPanel)
	if seniorPanel then
		seniorPanel:removeFromParentAndCleanup(true)
	end
	if tag == _tagCloseButton then
		
	elseif tag == _tagRecruitOne then
		local shopInfo = DataCache.getShopCache()
		if (tonumber(shopInfo.gold_recruit_num) > 0) then
			local args = Network.argsHandler(0, 1)
			RequestCenter.shop_goldRecruit(fnHandlerOfNetworkRecruitOne, args)
		else
			require "db/DB_Tavern"
			local db_tavern = DB_Tavern.getDataById(3)
			if (UserModel.getGoldNumber() >= (db_tavern.gold_needed)) then
				_nCostGold = db_tavern.gold_needed
				local args = Network.argsHandler(1, 1)
				RequestCenter.shop_goldRecruit(fnHandlerOfNetworkRecruitOne, args)
			else
				--AnimationTip.showTip(GetLocalizeStringBy("key_2601"))
				LackGoldTip.showTip()
			end
		end
	elseif tag == _tagRecruitTen then
		local db_tavern = DB_Tavern.getDataById(3)

		if (UserModel.getGoldNumber() < _costGoldOfTen) then
			-- _nCostGold = db_tavern.gold_needed*10
			-- local args = Network.argsHandler(1, 10)
			-- RequestCenter.shop_goldRecruit(fnHandlerOfNetworkRecruitTen, args)
			--AnimationTip.showTip(GetLocalizeStringBy("key_2601"))
			LackGoldTip.showTip()
			return			
		end

		local sureCallBack = function()
			require "script/ui/shop/TenHeroRecuitLayer"
			dealRecuitTen()
			TenHeroRecuitLayer.createRecruitTenLayer()
		end

	--	createRecruitTenLayer()

		--弹购买花费的板子
		local tip_1 = CCLabelTTF:create(GetLocalizeStringBy("zzh_1132") .. _costGoldOfTen,g_sFontName,25)
		tip_1:setColor(ccc3(0x78,0x25,0x00))
		local goldSprite = CCSprite:create("images/common/gold.png")
		local tip_2 = CCLabelTTF:create(GetLocalizeStringBy("zzh_1133"),g_sFontName,25)
		tip_2:setColor(ccc3(0x78,0x25,0x00))

		local insertNode = BaseUI.createHorizontalNode({tip_1,goldSprite,tip_2})

		require "script/ui/tip/TipByNode"
		TipByNode.showLayer(insertNode,sureCallBack)
	end

end

local function fnFilterTouchEvent( ... )
	return true
end

-- 当本次招将免费时，用文字“本次招将免费”来替换 图文：金币280
local function createGoldFreeLabel( )
	local alertContent = {}

	alertContent[1] = CCRenderLabel:create(GetLocalizeStringBy("key_2511"), g_sFontPangWa, 25, 2, ccc3(0, 0, 0), type_stroke)
	alertContent[1]:setColor(ccc3(0x36, 0xff, 0x00))

	local alertNode = BaseUI.createHorizontalNode(alertContent)
	return alertNode
end



-- 创建神将招将面板
function createSeniorHeroRecruitPanel( ... )
	local runningScene = CCDirector:sharedDirector():getRunningScene()

	-- 创建灰色摭罩层
	local cclMask = CCLayerColor:create(ccc4(10,10,10, 180))
	cclMask:setTouchEnabled(true)
	cclMask:registerScriptTouchHandler(function ( ... )
		return true
	end, false, -4000, true)

	local fullRect = CCRectMake(0, 0, 213, 171)
	local insetRect = CCRectMake(84, 84, 2, 3)
	local ccSpriteBg = CCScale9Sprite:create("images/common/viewbg1.png", fullRect, insetRect)
	ccSpriteBg:setPreferredSize(CCSizeMake(520, 510))
	ccSpriteBg:setScale(g_fElementScaleRatio)
	ccSpriteBg:setPosition(g_winSize.width/2, g_winSize.height/2)
	ccSpriteBg:setAnchorPoint(ccp(0.5, 0.5))
	cclMask:addChild(ccSpriteBg)

	local bg_size = ccSpriteBg:getContentSize()

	local ccTitleBG = CCSprite:create("images/common/viewtitle1.png")
	ccTitleBG:setPosition(ccp(bg_size.width/2, bg_size.height-6))
	ccTitleBG:setAnchorPoint(ccp(0.5, 0.5))
	ccSpriteBg:addChild(ccTitleBG)
	-- 神将招将标题文本
	require "script/libs/LuaCCLabel"
	local ccLabelTitle = LuaCCLabel.createShadowLabel(GetLocalizeStringBy("key_2442"), g_sFontPangWa, 33)
	ccLabelTitle:setPosition(ccp(ccTitleBG:getContentSize().width/2, (ccTitleBG:getContentSize().height-1)/2))
	ccLabelTitle:setAnchorPoint(ccp(0.5, 0.5))
	ccLabelTitle:setColor(ccc3(0xff, 0xf0, 0x49))
	ccTitleBG:addChild(ccLabelTitle)

	local menu = CCMenu:create()
	ccSpriteBg:addChild(menu)
	menu:setPosition(ccp(0,0))


	local ccButtonClose = CCMenuItemImage:create("images/common/btn_close_n.png", "images/common/btn_close_h.png")
	ccButtonClose:setAnchorPoint(ccp(1, 1))
	ccButtonClose:setPosition(ccp(bg_size.width+14, bg_size.height+14))
	ccButtonClose:registerScriptTapHandler(fnHandlerOfSenionRecruit)
	menu:addChild(ccButtonClose, 0, _tagCloseButton)
	menu:setPosition(0, 0)
	menu:setTouchPriority(-4002)

-- 招将一次
	local cmiiRecruitOne = CCMenuItemImage:create("images/shop/pub/one_n.png", "images/shop/pub/one_h.png")
	_btnRecruitOne = cmiiRecruitOne
	cmiiRecruitOne:setPosition(33, 80)
	cmiiRecruitOne:setAnchorPoint(ccp(0, 0))
	cmiiRecruitOne:registerScriptTapHandler(fnHandlerOfSenionRecruit)
	menu:addChild(cmiiRecruitOne, 0, _tagRecruitOne)

	local recuitOneDesc= CCSprite:create("images/shop/pub/buy_one.png")
	recuitOneDesc:setPosition(cmiiRecruitOne:getContentSize().width/2, 13 )
	recuitOneDesc:setAnchorPoint(ccp(0.5,0))
	cmiiRecruitOne:addChild(recuitOneDesc)


-- 如果是首招则必得五星武将
	require "script/model/DataCache"
	local shopInfo = DataCache.getShopCache()
	if( tonumber(shopInfo.gold_recruit_num) <= 0 and tonumber(shopInfo.gold_recruit_status) < 2 )then
		print("firstSpfirstSpfirstSpfirstSp")
		local firstSp = CCSprite:create("images/shop/pub/firstget_5.png")
		firstSp:setAnchorPoint(ccp(0.5,0))
		firstSp:setPosition(ccp(cmiiRecruitOne:getContentSize().width/2, cmiiRecruitOne:getContentSize().height*0.21))
		cmiiRecruitOne:addChild(firstSp)
	end

-- 招将十次
	local cmiiRecruitTen = CCMenuItemImage:create("images/shop/pub/ten_n.png", "images/shop/pub/ten_h.png")
	cmiiRecruitTen:setPosition(272, 80)
	cmiiRecruitTen:setAnchorPoint(ccp(0, 0))
	cmiiRecruitTen:registerScriptTapHandler(fnHandlerOfSenionRecruit)
	menu:addChild(cmiiRecruitTen, 0, _tagRecruitTen)

	local recuitTenDesc= CCSprite:create("images/shop/pub/buy_ten.png")
	recuitTenDesc:setPosition(cmiiRecruitTen:getContentSize().width/2, 14 )
	recuitTenDesc:setAnchorPoint(ccp(0.5,0))
	cmiiRecruitTen:addChild(recuitTenDesc)


	require "db/DB_Tavern"
	local db_senior = DB_Tavern.getDataById(3)
-- 金币消耗(招一次)
	local csGoldIconForOne = CCSprite:create("images/common/gold.png")
	csGoldIconForOne:setPosition(89, 40)
	csGoldIconForOne:setAnchorPoint(ccp(0, 0))
	ccSpriteBg:addChild(csGoldIconForOne)
	local crlGoldNeedForOne = CCRenderLabel:create(db_senior.gold_needed, g_sFontPangWa, 25, 2, ccc3(0, 0, 0), type_stroke)
	crlGoldNeedForOne:setColor(ccc3(0xff, 0xf6, 0))
	crlGoldNeedForOne:setAnchorPoint(ccp(0, 0))
	crlGoldNeedForOne:setPosition(csGoldIconForOne:getContentSize().width+2, 0)
	csGoldIconForOne:addChild(crlGoldNeedForOne)

	local shopInfo = DataCache.getShopCache()
	if( tonumber(shopInfo.gold_recruit_num ) > 0 )then
		csGoldIconForOne:setVisible(false)
		crlGoldNeedForOne:setVisible(false)

		local  goldFreeNode =createGoldFreeLabel()
		goldFreeNode:setPosition(ccSpriteBg:getContentSize().width*0.25 ,40)
		goldFreeNode:setAnchorPoint(ccp(0.5,0))
		ccSpriteBg:addChild(goldFreeNode)
	end

-- 金币消耗(招十次)
	_numOfTenRecuit = tonumber(lua_string_split(db_senior.gold_nums, "|")[1])
	_costGoldOfTen = tonumber(lua_string_split(db_senior.gold_nums, "|")[2])
	local csGoldIconForTen = CCSprite:create("images/common/gold.png")
	csGoldIconForTen:setPosition(330, 40)
	csGoldIconForTen:setAnchorPoint(ccp(0, 0))
	ccSpriteBg:addChild(csGoldIconForTen)
	local crlGoldNeedForTen = CCRenderLabel:create( _costGoldOfTen, g_sFontPangWa, 25, 2, ccc3(0, 0, 0), type_stroke)
	crlGoldNeedForTen:setColor(ccc3(0xff, 0xf6, 0))
	crlGoldNeedForTen:setAnchorPoint(ccp(0, 0))
	crlGoldNeedForTen:setPosition(csGoldIconForTen:getContentSize().width+2, 0)
	csGoldIconForTen:addChild(crlGoldNeedForTen)

-- 再招？次必得五星将提示
-- 再招9次后，下次招将必得一张五星武将!

	local shopInfo = DataCache.getShopCache()
	local nRecruitSum = tonumber(shopInfo.gold_recruit_sum)
	local nRecruitLeft = 0
	if nRecruitSum <= 5 then
		nRecruitLeft = 5 - nRecruitSum - 1
	else
		nRecruitSum = (nRecruitSum - 5)%10
		nRecruitLeft = 10 - nRecruitSum - 1
	end
	if nRecruitLeft < 0 then
		nRecruitLeft = 9
	end
	require "script/libs/LuaCC"
	local tElements = {
 		{ctype=3, text=GetLocalizeStringBy("key_1470"), color=ccc3(0x51, 0xfb, 255), fontname=g_sFontPangWa, strokeColor=ccc3(0, 0, 0), fontsize=24, strokeSize=2},
 		{ctype=3, text=tostring(nRecruitLeft), color=ccc3(255, 255, 255), fontsize=39, vOffset=-10},
 		{ctype=3, text=GetLocalizeStringBy("key_3196"), color=ccc3(0x51, 0xfb, 255), vOffset=10, fontsize=24},
 		{ctype=3, text=GetLocalizeStringBy("key_1258"), color=ccc3(255, 0, 0xe1), fontsize=29},
 	}
 	local tObjs = LuaCC.createCCNodesOnHorizontalLine(tElements)
 	for i=1, #tObjs do
 		tObjs[i]:setAnchorPoint(ccp(0, 0))
 	end
 	tObjs[1]:setPosition(25, 410)
 	ccSpriteBg:addChild(tObjs[1])

 	-- 当nRecruitLeft == 0 显示本次招将必得五星紫卡文本
 	if(nRecruitLeft == 0) then
 		tObjs[1]:setVisible(false)
 		local thisRecuitNode = createRecruitThisNode()
 		thisRecuitNode:setPosition(ccSpriteBg:getContentSize().width/2, 410)
 		thisRecuitNode:setAnchorPoint(ccp(0.5,0))
 		ccSpriteBg:addChild(thisRecuitNode)
 	end


	-- 新手引导
	cclMask:registerScriptHandler(function (event)
		if event == "enter" then
			-- 新手修改跳过此步骤 2013.11.29
			-- addGuideLevelGiftBagGuide6()
		end
	end)
	-- cclMask add到父节点上
	runningScene:addChild(cclMask, 3000, _tagPopupPanel)
end

-- added by zhz ,显示：本次招将必得五星紫卡文本
function createRecruitThisNode( )
	local alertContent = {}
	alertContent[1] = CCRenderLabel:create(GetLocalizeStringBy("key_1171") , g_sFontPangWa, 24,2, ccc3(0x00,0,0),type_stroke)
	alertContent[1]:setColor(ccc3(0x51, 0xfb, 255))
	alertContent[2] = CCRenderLabel:create(GetLocalizeStringBy("key_2224") , g_sFontPangWa, 39,2, ccc3(0x00,0,0),type_stroke)
	alertContent[2]:setColor(ccc3(255, 0, 0xe1))
	local alert = BaseUI.createHorizontalNode(alertContent)

	return alert
end



-- 招将1次网络回调处理
fnHandlerOfNetworkRecruitOne = function (cbFlag, dictData, bRet)
	if bRet then
		local runningScene = CCDirector:sharedDirector():getRunningScene()
		local seniorPanel = runningScene:getChildByTag(_tagPopupPanelOfRecruitTen)
		if seniorPanel then
			seniorPanel:removeFromParentAndCleanup(true)
		end

		local shopInfo = DataCache.getShopCache()
		if( tonumber(shopInfo.gold_recruit_num ) > 0 )then
			DataCache.addGoldFreeNum(-1)
		else
			require "db/DB_Tavern"
			local seniorDesc = DB_Tavern.getDataById(3)
			DataCache.changeFirstStatus()
			UserModel.addGoldNumber(-seniorDesc.gold_needed)
		end
		DataCache.changeGoldRecruitSum(1)
		local h_tid = nil
		local h_id 	= nil
		local s_tid = nil
		local s_id 	= nil

		local hero_t = dictData.ret.hero
		local star_t = dictData.ret.star
		if( not table.isEmpty(hero_t))then
			local h_keys = table.allKeys(hero_t)
			h_id = tonumber(h_keys[1])
			h_tid = tonumber(hero_t["" .. h_id])
		end
		if( not table.isEmpty(star_t))then
			local s_keys = table.allKeys(star_t)
			s_id = tonumber(s_keys[1])
			s_tid = tonumber(star_t["" .. s_id])
		end
		-- 修改积分
        local addPoint = 0
		if(dictData.ret.add_point and tonumber(dictData.ret.add_point) > 0)then
			DataCache.addShopPoint(tonumber(dictData.ret.add_point))
            addPoint = tonumber(dictData.ret.add_point)
		end
		
		-- createRecruitMenu()
--		stopScheduler( )
		require "script/ui/shop/HeroDisplayerLayer"
		local  heroDisplayerLayer = HeroDisplayerLayer.createLayer(h_id, h_tid, s_id, s_tid, addPoint,3,dictData.ret.item)
		MainScene.changeLayer(heroDisplayerLayer, "heroDisplayerLayer")
	end
end
-- 招将10次网络回调处理
function fnHandlerOfNetworkRecruitTen(cbFlag, dictData, bRet)
	if bRet then
		-- 减去所消耗金币
		DataCache.changeFirstStatus()
		UserModel.addGoldNumber(-_costGoldOfTen)
		local arrHeroes={}
		for k, v in pairs(dictData.ret.hero) do
			table.insert(arrHeroes, v)
		end
		--TenHeroRecuitLayer.addHeroCardShow(arrHeroes)
		TenHeroRecuitLayer.setAllHeroes(arrHeroes)
		-- 招将十次额外物品掉落
		TenHeroRecuitLayer.setAllItems(dictData.ret.item)
	end
end

-- added by zhz
-- 招将10次事件处理
function dealRecuitTen( )
	require "db/DB_Tavern"
		local db_tavern = DB_Tavern.getDataById(3)
		-- local recuitNum = tonumber(lua_string_split(db_tavern.gold_nums, "|")[1])
		-- local costGoldOfTen = tonumber(lua_string_split(db_tavern.gold_nums, "|")[2])
		-- _costGoldOfTen
		-- _numOfTenRecuit
		if (UserModel.getGoldNumber() >=_costGoldOfTen ) then
			_nCostGold = costGoldOfTen --db_tavern.gold_needed*10
			local args = Network.argsHandler(1, _numOfTenRecuit)
			RequestCenter.shop_goldRecruit(fnHandlerOfNetworkRecruitTen, args)
		else
			-- AnimationTip.showTip(GetLocalizeStringBy("key_2601"))
			LackGoldTip.showTip()
	end
end


-- function fnHandlerOfRecruitTenUI(tag, obj)
-- -- 招将1次按钮事件处理
-- 	if tag == _tagRecruitOne then
-- 		local shopInfo = DataCache.getShopCache()
-- 		if (tonumber(shopInfo.gold_recruit_num) > 0) then
-- 			local args = Network.argsHandler(0, 1)
-- 			RequestCenter.shop_goldRecruit(fnHandlerOfNetworkRecruitOne, args)
-- 		else
-- 			require "db/DB_Tavern"
-- 			local db_tavern = DB_Tavern.getDataById(3)
-- 			if (UserModel.getGoldNumber() >= (db_tavern.gold_needed)) then
-- 				_nCostGold = db_tavern.gold_needed
-- 				local args = Network.argsHandler(1, 1)
-- 				RequestCenter.shop_goldRecruit(fnHandlerOfNetworkRecruitOne, args)
-- 			else
-- 				AnimationTip.showTip(GetLocalizeStringBy("key_2601"))
-- 			end
-- 		end
-- -- 招将10次按钮事件处理	
-- 	elseif tag == _tagRecruitTen then
-- 		dealRecuitTen()
		
-- -- 退出按钮事件处理
-- 	elseif tag == _tagQuit then
-- 		local runningScene = CCDirector:sharedDirector():getRunningScene()
-- 		local seniorPanel = runningScene:getChildByTag(_tagPopupPanelOfRecruitTen)
-- 		if seniorPanel then
-- 			seniorPanel:removeFromParentAndCleanup(true)
-- 		end
-- 	end
-- end

-- local function fnInitOfRecruitTen( ... )
-- 	_arrObjsRecruitText = {}
-- 	_arrObjsCardShow={}
-- end

-- -- 创建神将十连抽界面
-- function createRecruitTenLayer( ... )
-- 	fnInitOfRecruitTen()
-- 	local runningScene = CCDirector:sharedDirector():getRunningScene()
-- 	local clBg = CCLayer:create()
-- 	_clRecruitTenBg = clBg
-- 	clBg:setTouchEnabled(true)
-- 	clBg:registerScriptTouchHandler(function ( ... )
-- 		return true
-- 	end, false, -4000, true)
-- 	local csBg = CCSprite:create("images/shop/pub/pubbg.jpg")
-- 	csBg:setPosition(g_winSize.width/2, g_winSize.height/2)
-- 	csBg:setAnchorPoint(ccp(0.5, 0.5))
-- 	csBg:setScale(g_fBgScaleRatio)
-- 	clBg:addChild(csBg)
-- 	runningScene:addChild(clBg, 3000, _tagPopupPanelOfRecruitTen)

-- 	local csConsTitle = CCSprite:create("images/shop/pub/congratulations.png")
-- 	csConsTitle:setScale(g_fElementScaleRatio)
-- 	csConsTitle:setAnchorPoint(ccp(0.5, 0))
-- 	csConsTitle:setPosition(g_winSize.width/2, g_winSize.height*0.85)
-- 	clBg:addChild(csConsTitle)

-- 	require "script/libs/LuaCC"
-- -- 按钮, 招将1次
-- 	local btnRecruitOne = LuaCC.create9ScaleMenuItem("images/common/btn/btn1_d.png","images/common/btn/btn1_n.png",CCSizeMake(200, 73),GetLocalizeStringBy("key_2893"),ccc3(0xfe, 0xdb, 0x1c),35,g_sFontPangWa,1, ccc3(0, 0, 0))
-- 	btnRecruitOne:registerScriptTapHandler(fnHandlerOfRecruitTenUI)
-- 	btnRecruitOne:setScale(g_fElementScaleRatio)
-- 	btnRecruitOne:setPosition(g_winSize.width*0.15, g_winSize.height*0.15)
-- 	btnRecruitOne:setAnchorPoint(ccp(0, 0))
-- -- 按钮, 招将10次
-- 	local btnRecruitTen = LuaCC.create9ScaleMenuItem("images/common/btn/btn1_d.png","images/common/btn/btn1_n.png",CCSizeMake(210, 73),GetLocalizeStringBy("key_1864"),ccc3(0xfe, 0xdb, 0x1c),35,g_sFontPangWa,1, ccc3(0, 0, 0))
-- 	btnRecruitTen:setScale(g_fElementScaleRatio)
-- 	btnRecruitTen:registerScriptTapHandler(fnHandlerOfRecruitTenUI)
-- 	btnRecruitTen:setPosition(g_winSize.width*0.55, g_winSize.height*0.15)
-- 	btnRecruitTen:setAnchorPoint(ccp(0, 0))
-- -- 按钮, 退出
-- 	local btnRecruitQuit = LuaCC.create9ScaleMenuItem("images/common/btn/btn1_d.png","images/common/btn/btn1_n.png",CCSizeMake(200, 73),GetLocalizeStringBy("key_3344"),ccc3(0xfe, 0xdb, 0x1c),35,g_sFontPangWa,1, ccc3(0, 0, 0))
-- 	btnRecruitQuit:setScale(g_fElementScaleRatio)
-- 	btnRecruitQuit:setAnchorPoint(ccp(0.5, 0))
-- 	btnRecruitQuit:setPosition(g_winSize.width/2, g_winSize.height*0.02)
-- 	btnRecruitQuit:registerScriptTapHandler(fnHandlerOfRecruitTenUI)
-- -- 几个按钮菜单
-- 	local cmRecruitHero = CCMenu:create()
-- 	cmRecruitHero:setPosition(0, 0)
-- 	cmRecruitHero:setTouchEnabled(true)
-- 	cmRecruitHero:setTouchPriority(-4002)
-- 	cmRecruitHero:addChild(btnRecruitOne, 0, _tagRecruitOne)
-- 	cmRecruitHero:addChild(btnRecruitTen, 0, _tagRecruitTen)
-- 	cmRecruitHero:addChild(btnRecruitQuit, 0, _tagQuit)
-- 	clBg:addChild(cmRecruitHero)
-- -- 显示卡牌
-- 	addCardShow()

--  	require "db/DB_Tavern"
-- 	local db_senior = DB_Tavern.getDataById(3)
-- -- 金币消耗(招一次)
-- 	local csGoldIconForOne = CCSprite:create("images/common/gold.png")
-- 	local nGoldIconWidth = csGoldIconForOne:getContentSize().width
-- 	local crlGoldNeedForOne = CCRenderLabel:create(db_senior.gold_needed, g_sFontPangWa, 25, 2, ccc3(0, 0, 0), type_stroke)
-- 	crlGoldNeedForOne:setColor(ccc3(0xff, 0xf6, 0))
-- 	crlGoldNeedForOne:setAnchorPoint(ccp(0, 0))
-- 	crlGoldNeedForOne:setPosition(nGoldIconWidth+2, 0)
-- 	csGoldIconForOne:addChild(crlGoldNeedForOne)
-- 	local nChildWidth = nGoldIconWidth+2+crlGoldNeedForOne:getContentSize().width
-- 	csGoldIconForOne:setPosition((btnRecruitOne:getContentSize().width-nChildWidth)/2, -4)
-- 	csGoldIconForOne:setAnchorPoint(ccp(0, 1))
-- 	btnRecruitOne:addChild(csGoldIconForOne)

-- -- 金币消耗(招十次)
-- 	local csGoldIconForTen = CCSprite:create("images/common/gold.png")
-- 	local crlGoldNeedForTen = CCRenderLabel:create(db_senior.gold_needed*10, g_sFontPangWa, 25, 2, ccc3(0, 0, 0), type_stroke)
-- 	crlGoldNeedForTen:setColor(ccc3(0xff, 0xf6, 0))
-- 	crlGoldNeedForTen:setAnchorPoint(ccp(0, 0))
-- 	crlGoldNeedForTen:setPosition(csGoldIconForTen:getContentSize().width+2, 0)
-- 	csGoldIconForTen:addChild(crlGoldNeedForTen)

-- 	local nChildWidth = nGoldIconWidth+2+crlGoldNeedForTen:getContentSize().width

-- 	csGoldIconForTen:setPosition((btnRecruitTen:getContentSize().width-nChildWidth)/2, -4)
-- 	csGoldIconForTen:setAnchorPoint(ccp(0, 1))

-- 	btnRecruitTen:addChild(csGoldIconForTen)

-- 	addRecruitLeftTimeText(clBg)
-- end

-- -- 增加招将剩于次数文本显示
-- function addRecruitLeftTimeText(ccParent)
-- 	if #_arrObjsRecruitText >= 1 then
-- 		_arrObjsRecruitText[1]:removeFromParentAndCleanup(true)
-- 	end
-- 	-- 再招？次必得一张五星武将
-- 	local shopInfo = DataCache.getShopCache()
-- 	local nRecruitSum = tonumber(shopInfo.gold_recruit_sum)
-- 	local nRecruitLeft = 0
-- 	if nRecruitSum <= 5 then
-- 		nRecruitLeft = 5 - nRecruitSum - 1
-- 	else
-- 		nRecruitSum = (nRecruitSum - 5)%10
-- 		nRecruitLeft = 10 - nRecruitSum - 1
-- 	end
-- 	if nRecruitLeft <= 0 then
-- 		nRecruitLeft = 9
-- 	end
-- 	require "script/libs/LuaCC"
-- 	local tElements = {
--  		{ctype=3, text=GetLocalizeStringBy("key_1470"), color=ccc3(0x51, 0xfb, 255), fontname=g_sFontPangWa, strokeColor=ccc3(0, 0, 0), fontsize=24, strokeSize=2},
--  		{ctype=3, text=tostring(nRecruitLeft), color=ccc3(255, 255, 255), fontsize=39, vOffset=-10},
--  		{ctype=3, text=GetLocalizeStringBy("key_3196"), color=ccc3(0x51, 0xfb, 255), vOffset=10, fontsize=24},
--  		{ctype=3, text=GetLocalizeStringBy("key_1258"), color=ccc3(255, 0, 0xe1), fontsize=29},
--  		{ctype=3, text="！", color=ccc3(0x51, 0xfb, 255), fontsize=24},
--  	}
--  	local tObjs = LuaCC.createCCNodesOnHorizontalLine(tElements)
--  	local nTotalWidth = 0
--  	for i=1, #tObjs do
--  		tObjs[i]:setAnchorPoint(ccp(0, 0))
--  		nTotalWidth = nTotalWidth + tObjs[i]:getContentSize().width
--  		tObjs[i]:setScale(g_fElementScaleRatio)
--  	end
--  	tObjs[1]:setPosition((g_winSize.width - nTotalWidth*g_fElementScaleRatio)/2, g_winSize.height*0.26)
--  	ccParent:addChild(tObjs[1])

--  	_arrObjsRecruitText = tObjs

-- end

-- -- 增加卡牌形象显示
-- function addCardShow(tHeroes)
-- 	local x_start = g_winSize.width * 0.0375
-- 	local x = x_start
-- 	local y = g_winSize.height * 0.396

-- 	for i=1, #_arrObjsCardShow do
-- 		_arrObjsCardShow[i]:removeFromParentAndCleanup(true)
-- 	end
-- 	_arrObjsCardShow = {}

-- 	if not tHeroes then
-- 		local x_offset = g_winSize.width*0.189
-- 		local fOppScale = 0.33*g_fElementScaleRatio

-- 		for i=1, 10 do
-- 			if i == 6 then
-- 				x = x_start
-- 				y = g_winSize.height * 0.65
-- 			end
-- 			local csItem = CCSprite:create("images/shop/pub/card_opp.png")
-- 			csItem:setScale(fOppScale)
-- 			csItem:setPosition(x, y)
-- 			csItem:setAnchorPoint(ccp(0, 0))

-- 			_clRecruitTenBg:addChild(csItem)
-- 			x = x + x_offset
-- 			table.insert(_arrObjsCardShow, csItem)
-- 		end
-- 	else
-- 		local x_offset = g_winSize.width*0.1875
-- -- 显示卡牌
-- 		require "script/battle/BattleCardUtil"
-- 		require "db/DB_Heroes"
-- 		require "script/ui/hero/HeroPublicLua"
-- 		-- local arrItemData = {10005, 10078, 10121, 10139, 10002, 10079, 10008, 10032, 10155, 10172}
		
-- 		local cardScale = 0.85*g_fElementScaleRatio
		
-- 		for i=1, #tHeroes do
-- 			if i == 6 then
-- 				x = x_start
-- 				y = g_winSize.height * 0.65
-- 			end
-- 			local csItem = BattleCardUtil.getFormationPlayerCard(nil, nil, tHeroes[i])
-- 			csItem:setScale(cardScale)
-- 			csItem:setPosition(x, y)
-- 			csItem:setAnchorPoint(ccp(0, 0))

-- 			local db_hero = DB_Heroes.getDataById(tHeroes[i])
-- 			local color = HeroPublicLua.getCCColorByStarLevel(db_hero.star_lv)
-- 			local crlName = CCRenderLabel:create(db_hero.name, g_sFontPangWa, 25, 1, ccc3(0, 0, 0), type_stroke)
-- 			crlName:setAnchorPoint(ccp(0.5, 1))
-- 			crlName:setColor(color)
-- 			crlName:setPosition(csItem:getContentSize().width/2, -10)
-- 			csItem:addChild(crlName)
-- 			_clRecruitTenBg:addChild(csItem)

-- 			local tElements = {}
-- 			for i=1, db_hero.star_lv do
-- 				table.insert(tElements, {ctype=LuaCC.m_ksTypeSprite, file="images/shop/pub/star.png"})
-- 			end
-- 			local tObjs = LuaCC.createCCNodesOnHorizontalLine(tElements)
-- 			for i=1, #tObjs do
-- 				tObjs[i]:setAnchorPoint(ccp(0, 0))
-- 			end
-- 			tObjs[1]:setPosition((csItem:getContentSize().width-tObjs[1]:getContentSize().width*db_hero.star_lv)/2, csItem:getContentSize().height+12)
-- 			csItem:addChild(tObjs[1], 1000)

-- 			x = x + x_offset

-- 			table.insert(_arrObjsCardShow, csItem)
-- 		end
-- 	end
-- end

-- 为新手引导提供按钮
function getRecruitOneBtn( ... )
	return _btnRecruitOne
end


-- 等级礼包第6步 点击招一次
function addGuideLevelGiftBagGuide6( ... )
    require "script/guide/NewGuide"
	-- print("g_guideClass = ", NewGuide.guideClass)
    require "script/guide/LevelGiftBagGuide"
    if(NewGuide.guideClass ==  ksGuideFiveLevelGift and LevelGiftBagGuide.stepNum == 5) then
    	-- require "script/ui/shop/SeniorHeroRecruitLayer"
    	local levelGiftBagGuide_button = getRecruitOneBtn()
   	 	local touchRect = getSpriteScreenRect(levelGiftBagGuide_button)
    	LevelGiftBagGuide.show(6, touchRect)
        LevelGiftBagGuide.stepNum = 7
    end
end

