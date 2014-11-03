-- Filename: BreakDownLayer.lua
-- Author: zhang zihang
-- Date: 2013-11-28
-- Purpose: 该文件用于: 武将分解页面

module ("BreakDownLayer", package.seeall)

require "script/ui/main/MainScene"
require "script/model/hero/HeroModel"
require "script/ui/hero/HeroPublicLua"
require "script/ui/tip/AnimationTip"
require "db/DB_Item_arm"
require "db/DB_Item_treasure"
require "db/DB_Item_dress"
require "script/model/DataCache"
require "script/model/user/UserModel"

--以下变量用来记录上次选中的列表栏目
--记录到NOWIN_TAG中
--初始为HERO_TAG
local HERO_TAG = 8001
local EQUIP_TAG = 8002
local GOOD_TAG = 8003
local CLOTH_TAG = 8004

local NOWIN_TAG = HERO_TAG

local HERO_ADD
local EQUIP_ADD
local GOOD_ADD

function init()
	_layer = nil
	_parentSize = nil

	_ksTagSelectedHeroStart = 4001

	_fastAdd = false
	
	breakDownButton = nil
	fastAddButton = nil

	--HERO_ADD = -1
	--EQUIP_ADD = -1

	--用于存放四个添加格子的内容
	_csAddHeroeButtons = {}
	--有武将的格子的武将信息
	_arrSelectedHeroes = {}

	--选中的装备信息
	_arrSelectedItems = {}

	--选中的宝物信息
	_arrSelectedGoods = {}

	--选中的时装信息
	_arrSelectedCloths = {}

	changeHeroButton = nil
	changeGoodButton = nil

	fastAddGoodAction = nil

	FAST_HERO_TAG = 8088
	CHANGE_HERO_TAG = 8089
	FAST_EQUIP_TAG = 8090
	CHANGE_EQUIP_TAG = 8091
	FAST_GOOD_TAG = 8092
	CHANGE_GOOD_TAG = 8093
	FAST_CLOTH_TAG = 8094
	CHANGE_CLOTH_TAG = 8095

	HERO_ADD = 1
	EQUIP_ADD = 0
	GOOD_ADD = 0
	CLOTH_ADD = 0
end

--创建分解窗说明文字
-- function createBreakDownDescribe()
-- 	local breakDownDescribe = CCSprite:create("images/recycle/describe/breakdown1.png")
-- 	breakDownDescribe:setAnchorPoint(ccp(0.5,0.5))
-- 	breakDownDescribe:setPosition(ccp(_parentSize.width/2,_parentSize.height/2-90*g_fScaleY))
-- 	breakDownDescribe:setScale(MainScene.elementScale)
-- 	_layer:addChild(breakDownDescribe)

-- 	local breakDownDescribe1 = CCSprite:create("images/recycle/describe/breakdown2.png")
-- 	breakDownDescribe1:setAnchorPoint(ccp(0.5,0.5))
-- 	breakDownDescribe1:setPosition(ccp(_parentSize.width/2,_parentSize.height/2-130*g_fScaleY))
-- 	breakDownDescribe1:setScale(MainScene.elementScale)
-- 	_layer:addChild(breakDownDescribe1)

-- 	local breakDownDescribe2 = CCSprite:create("images/recycle/describe/breakdown3.png")
-- 	breakDownDescribe2:setAnchorPoint(ccp(0.5,0.5))
-- 	breakDownDescribe2:setPosition(ccp(_parentSize.width/2,_parentSize.height/2-170*g_fScaleY))
-- 	breakDownDescribe2:setScale(MainScene.elementScale)
-- 	_layer:addChild(breakDownDescribe2)
-- end

--过滤武将
function getFiltersForSelection()
	local filters = {}
	local tAllHeroes = HeroModel.getAllHeroes()
	require "db/DB_Heroes"
	for k, v in pairs(tAllHeroes) do
		-- 去除主角
		if HeroModel.isNecessaryHero(v.htid) then
			table.insert(filters, v.hid)
		else
			-- 去除在阵上武将
			local bIsBusy = HeroPublicLua.isBusyWithHid(v.hid)
			if bIsBusy then
				table.insert(filters, v.hid)
			end

			--去除小伙伴
			require "script/ui/formation/LittleFriendData"
			if LittleFriendData.isInLittleFriend(v.hid) then
				table.insert(filters,v.hid)
			end

			-- 去掉进阶过的武将
			if tonumber(v.evolve_level) > 0 then
				table.insert(filters, v.hid)
			end

			--去掉枷锁的武将
			if v.lock and tonumber(v.lock)== 1 then
				table.insert(filters,v.hid)
			end

			--去掉小兵
			local db_hero = DB_Heroes.getDataById(v.htid)
			if (db_hero.advanced_id == nil) or (tonumber(db_hero.advanced_id) == 0) then
				table.insert(filters,v.hid)
			end

			-- 去掉1至3星及武将
			local nLimitStarLevel = 4
			if db_hero.star_lv < nLimitStarLevel or db_hero.star_lv > 5 then
				table.insert(filters, v.hid)
			end

			--去掉武将变身没有执行命令的武将
			-- require "script/ui/rechargeActive/ActiveCache"
			-- if ActiveCache.isUnhandleTransfer(v.hid) then
			-- 	table.insert(filters,v.hid)
			-- end
		end
	end

	return filters
end

--过滤装备
function getFiltersForItem()
	local filt = {}
	local bagInfo = DataCache.getBagInfo()
	-- print("bagInfo.arm~~~")
	-- print_t(bagInfo.arm)
	local bagArmInfo = {}
	-- for k,v in pairs(bagInfo.arm) do
	-- 	if (v.itemDesc.resolveId ~= nil) and (tonumber(v.itemDesc.resolveId) ~= 0) then
	-- 		table.insert(filt,v)
	-- 	end
	-- 	v.isSelected = false
	-- 	--v.ccObj = nil
	-- end
	table.hcopy(bagInfo.arm,bagArmInfo)

	for k,v in pairs(bagArmInfo) do
		if ( v.itemDesc.resolveId ~= nil  and tonumber(v.itemDesc.resolveId) ~= 0 and tonumber(v.itemDesc.quality) <= 5 ) then
			if not(v.va_item_text.lock and tonumber(v.va_item_text.lock) == 1 )then
				table.insert(filt,v)
			end
		end
		v.isSelected = false
		--v.ccObj = nil
	end

	local function sort(w1, w2)
		if tonumber(w1.itemDesc.quality) > tonumber(w2.itemDesc.quality) then
			return true
		elseif tonumber(w1.itemDesc.quality) == tonumber(w2.itemDesc.quality) then
			if tonumber(w1.va_item_text.armReinforceLevel) > tonumber(w2.va_item_text.armReinforceLevel) then
				return true
			else 
				return false 
			end
		else 
			return false
		end
		--return w1.star_lv < w2.star_lv
	end

	table.sort(filt, sort)

	return filt

end

-- 过滤宝物
function getFiltersForGood()
	local filt = {}
	local bagInfo = DataCache.getBagInfo()
	print(GetLocalizeStringBy("key_1591"))
	print_t(bagInfo.treas)
	local bagGoodInfo = {}

	table.hcopy(bagInfo.treas,bagGoodInfo)
	for k,v in pairs(bagGoodInfo) do
		if (v.itemDesc.resolve_exp_item ~= nil) and (tonumber(v.itemDesc.quality) >= 5) then
			table.insert(filt,v)
		end
		v.isSelected = false
	end

	local function sort(w1,w2)
		if tonumber(w1.va_item_text.treasureLevel) > tonumber(w2.va_item_text.treasureLevel) then
			return true
		else
			return false
		end
	end

	table.sort(filt,sort)

	return filt
end

-- 过滤时装
function getFiltersForCloth()
	local filt = {}
	local bagInfo = DataCache.getBagInfo()
	print("时装哦")
	print_t(bagInfo.dress)
	print_t(bagInfo)
	local bagDressInfo = {}
	table.hcopy(bagInfo.dress,bagDressInfo)
	for k,v in pairs(bagDressInfo) do
		table.insert(filt,v)
		v.isSelected = false
		--if (v.itemDesc.resolve_exp_item ~= nil) and (tonumber(v.itemDesc.quality) )
	end

	local function sort(w1,w2)
		if tonumber(w1.va_item_text.dressLevel) > tonumber(w2.va_item_text.dressLevel) then
			return true
		else
			return false
		end
	end

	table.sort(filt,sort)

	return filt
end

--添加按钮回调
function fnHandlerOfSelectHero(tag, item_obj)
	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
	
	local tArgsOfModule = {sign="BreakDownLayer"}

	tArgsOfModule.filters = getFiltersForSelection()
	tArgsOfModule.filtersItem = getFiltersForItem()
	tArgsOfModule.filtersGood = getFiltersForGood()
	tArgsOfModule.filtersCloth = getFiltersForCloth()

	--tArgsOfModule.nowIn表示目前选中的是哪个界面
	--同时修改本次选中的页面，用于下一次快速找到的NOWIN_TAG值

	if not table.isEmpty(_arrSelectedItems) then
		tArgsOfModule.nowIn = "itemList"

		for i = 1,#tArgsOfModule.filtersItem do
			for j = 1,#_arrSelectedItems do
				if tArgsOfModule.filtersItem[i].item_id == _arrSelectedItems[j].item_id then
					tArgsOfModule.filtersItem[i].isSelected = true
				end
			end
		end

		tArgsOfModule.selected = _arrSelectedItems
	elseif not table.isEmpty(_arrSelectedGoods) then
		tArgsOfModule.nowIn = "goodList"
		for i = 1,#tArgsOfModule.filtersGood do
			for j = 1,#_arrSelectedGoods do
				if tArgsOfModule.filtersGood[i].item_id == _arrSelectedGoods[j].item_id then
					tArgsOfModule.filtersGood[i].isSelected = true
				end
			end
		end
		tArgsOfModule.selected = _arrSelectedGoods
	elseif not table.isEmpty(_arrSelectedCloths) then
		tArgsOfModule.nowIn = "clothList"
		for i = 1,#tArgsOfModule.filtersCloth do
			for j = 1,#_arrSelectedCloths do
				if tArgsOfModule.filtersCloth[i].item_id == _arrSelectedCloths[j].item_id then
					tArgsOfModule.filtersCloth[i].isSelected = true
				end
			end
		end
		tArgsOfModule.selected = _arrSelectedCloths
	elseif NOWIN_TAG == EQUIP_TAG then
		tArgsOfModule.nowIn = "itemList"
		tArgsOfModule.selected = _arrSelectedItems
	elseif NOWIN_TAG == HERO_TAG then
		tArgsOfModule.nowIn = "heroList"
		tArgsOfModule.selected = _arrSelectedHeroes
	elseif NOWIN_TAG == GOOD_TAG then
		tArgsOfModule.nowIn = "goodList"
		tArgsOfModule.selected = _arrSelectedGoods
	elseif NOWIN_TAG == CLOTH_TAG then
		tArgsOfModule.nowIn = "clothList"
		tArgsOfModule.selected = _arrSelectedCloths
	end
	--tArgsOfModule.filters = getFiltersForSelection()
	--tArgsOfModule.filtersItem = getFiltersForItem()

	print("我在那里~~~~",NOWIN_TAG)
	require "script/ui/recycle/ResolveSelectLayer"

	--点击添加物品按钮，进入选择待炼化武将，装备，宝物界面
	MainScene.changeLayer(ResolveSelectLayer.createLayer(tArgsOfModule), "ResolveSelectLayer")
end

--创建添加按钮
function createAddMenu()
	--如果格子有内容
	for i = 1,5 do
		local tCellValue = {quality_bg="images/common/border.png", quality_h="images/hero/quality/highlighted.png"}
		local menu = CCMenu:create()
		if (not table.isEmpty(_arrSelectedHeroes)) and (i <= #_arrSelectedHeroes) then

			tCellValue.quality_bg = _arrSelectedHeroes[i].quality_bg
			tCellValue.quality_h = _arrSelectedHeroes[i].quality_h

			local heroName = CCRenderLabel:create(_arrSelectedHeroes[i].name, g_sFontPangWa,25,1,ccc3(0x00,0x00,0x00),type_shadow)
			heroName:setColor(HeroPublicLua.getCCColorByStarLevel(_arrSelectedHeroes[i].star_lv))
			heroName:setAnchorPoint(ccp(0.5,0.5))
			heroName:setScale(MainScene.elementScale)
			if i == 1 then
				heroName:setPosition(ccp(_parentSize.width/2,_parentSize.height/2+182*g_fScaleY))
			elseif i == 2 then
				heroName:setPosition(ccp(_parentSize.width/2-220*g_fScaleX,_parentSize.height/2+62*g_fScaleY))
			elseif i == 3 then
				heroName:setPosition(ccp(_parentSize.width/2+220*g_fScaleX,_parentSize.height/2+62*g_fScaleY))
			elseif i == 4 then
				heroName:setPosition(ccp(_parentSize.width/2-130*g_fScaleX,_parentSize.height/2-128*g_fScaleY))
			elseif i == 5 then
				heroName:setPosition(ccp(_parentSize.width/2+130*g_fScaleX,_parentSize.height/2-128*g_fScaleY))
			end
			_layer:addChild(heroName,0,445+i)

		elseif (not table.isEmpty(_arrSelectedItems)) and (i <= #_arrSelectedItems)then
			local i_data = DB_Item_arm.getDataById(_arrSelectedItems[i].item_template_id)
			tCellValue.quality_bg = "images/base/potential/props_" .. i_data.quality .. ".png"

			local heroName = CCRenderLabel:create(_arrSelectedItems[i].itemDesc.name, g_sFontPangWa,25,1,ccc3(0x00,0x00,0x00),type_shadow)
			heroName:setColor(HeroPublicLua.getCCColorByStarLevel(_arrSelectedItems[i].itemDesc.quality))
			heroName:setAnchorPoint(ccp(0.5,0.5))
			heroName:setScale(MainScene.elementScale)
			if i == 1 then
				heroName:setPosition(ccp(_parentSize.width/2,_parentSize.height/2+182*g_fScaleY))
			elseif i == 2 then
				heroName:setPosition(ccp(_parentSize.width/2-220*g_fScaleX,_parentSize.height/2+62*g_fScaleY))
			elseif i == 3 then
				heroName:setPosition(ccp(_parentSize.width/2+220*g_fScaleX,_parentSize.height/2+62*g_fScaleY))
			elseif i == 4 then
				heroName:setPosition(ccp(_parentSize.width/2-130*g_fScaleX,_parentSize.height/2-128*g_fScaleY))
			elseif i == 5 then
				heroName:setPosition(ccp(_parentSize.width/2+130*g_fScaleX,_parentSize.height/2-128*g_fScaleY))
			end
			_layer:addChild(heroName,0,445+i)
		elseif (not table.isEmpty(_arrSelectedGoods)) and (i <= #_arrSelectedGoods) then
			local i_data = DB_Item_treasure.getDataById(_arrSelectedGoods[i].item_template_id)
			tCellValue.quality_bg = "images/base/potential/props_" .. i_data.quality .. ".png"

			local heroName = CCRenderLabel:create(_arrSelectedGoods[i].itemDesc.name, g_sFontPangWa,25,1,ccc3(0x00,0x00,0x00),type_shadow)
			heroName:setColor(HeroPublicLua.getCCColorByStarLevel(_arrSelectedGoods[i].itemDesc.quality))
			heroName:setAnchorPoint(ccp(0.5,0.5))
			heroName:setScale(MainScene.elementScale)
			if i == 1 then
				heroName:setPosition(ccp(_parentSize.width/2,_parentSize.height/2+182*g_fScaleY))
			elseif i == 2 then
				heroName:setPosition(ccp(_parentSize.width/2-220*g_fScaleX,_parentSize.height/2+62*g_fScaleY))
			elseif i == 3 then
				heroName:setPosition(ccp(_parentSize.width/2+220*g_fScaleX,_parentSize.height/2+62*g_fScaleY))
			elseif i == 4 then
				heroName:setPosition(ccp(_parentSize.width/2-130*g_fScaleX,_parentSize.height/2-128*g_fScaleY))
			elseif i == 5 then
				heroName:setPosition(ccp(_parentSize.width/2+130*g_fScaleX,_parentSize.height/2-128*g_fScaleY))
			end
			_layer:addChild(heroName,0,445+i)
		elseif (not table.isEmpty(_arrSelectedCloths)) and (i <= #_arrSelectedCloths) then
			local i_data = DB_Item_dress.getDataById(_arrSelectedCloths[i].item_template_id)
			tCellValue.quality_bg = "images/base/potential/props_" .. i_data.quality .. ".png"

			local fashionName
			local oldhtid = UserModel.getAvatarHtid()
			local model_id = DB_Heroes.getDataById(tonumber(oldhtid)).model_id
			local nameArray = lua_string_split(_arrSelectedCloths[i].itemDesc.name, ",")
			for k,v in pairs(nameArray) do
		    	local array = lua_string_split(v, "|")
		    	if(tonumber(array[1]) == tonumber(model_id)) then
					fashionName = array[2]
					break
		    	end
		    end

			local heroName = CCRenderLabel:create(fashionName, g_sFontPangWa,25,1,ccc3(0x00,0x00,0x00),type_shadow)
			heroName:setColor(HeroPublicLua.getCCColorByStarLevel(_arrSelectedCloths[i].itemDesc.quality))
			heroName:setAnchorPoint(ccp(0.5,0.5))
			heroName:setScale(MainScene.elementScale)
			if i == 1 then
				heroName:setPosition(ccp(_parentSize.width/2,_parentSize.height/2+182*g_fScaleY))
			elseif i == 2 then
				heroName:setPosition(ccp(_parentSize.width/2-220*g_fScaleX,_parentSize.height/2+62*g_fScaleY))
			elseif i == 3 then
				heroName:setPosition(ccp(_parentSize.width/2+220*g_fScaleX,_parentSize.height/2+62*g_fScaleY))
			elseif i == 4 then
				heroName:setPosition(ccp(_parentSize.width/2-130*g_fScaleX,_parentSize.height/2-128*g_fScaleY))
			elseif i == 5 then
				heroName:setPosition(ccp(_parentSize.width/2+130*g_fScaleX,_parentSize.height/2-128*g_fScaleY))
			end
			_layer:addChild(heroName,0,445+i)
		end

		--格子框初始图片
		local csQuality = CCSprite:create("images/common/equipborder.png")
		local csQuality1 = CCSprite:create(tCellValue.quality_bg)
		csQuality1:setPosition(ccp(csQuality:getContentSize().width/2,csQuality:getContentSize().height/2))
		csQuality1:setAnchorPoint(ccp(0.5,0.5))
		csQuality:addChild(csQuality1)
		--用于csFrame的复制

		local csQualityLighted = CCSprite:create("images/common/equipborder.png")
		local csQuality2 = CCSprite:create(tCellValue.quality_bg)
		csQuality2:setPosition(ccp(csQualityLighted:getContentSize().width/2,csQualityLighted:getContentSize().height/2))
		csQuality2:setAnchorPoint(ccp(0.5,0.5))
		csQualityLighted:addChild(csQuality2)

		--[[local csQualityLighted = CCSprite:create(tCellValue.quality_bg)
		csQualityLighted:setAnchorPoint(ccp(0.5,0.5))]]
		local csFrame = CCSprite:create(tCellValue.quality_h)

		csFrame:setPosition(csQualityLighted:getContentSize().width/2, csQualityLighted:getContentSize().height/2)
		csFrame:setAnchorPoint(ccp(0.5, 0.5))
		csQualityLighted:addChild(csFrame)

		local head_icon_bg = CCMenuItemSprite:create(csQuality, csQualityLighted)
		head_icon_bg:registerScriptTapHandler(fnHandlerOfSelectHero)
		table.insert(_csAddHeroeButtons, head_icon_bg)

		--头像初始值
		local head_icon = nil
		--如果有武将，则换为头像
		if (not table.isEmpty(_arrSelectedHeroes)) and (i <= #_arrSelectedHeroes) then
			print("lalala")
			require "script/model/utils/HeroUtil"
			head_icon=HeroUtil.getHeroIconByHTID(_arrSelectedHeroes[i].htid)
			if tonumber(_arrSelectedHeroes[i].evolve_level) > 0 then
				local plus = CCSprite:create("images/hero/transfer/numbers/add.png")
				plus:setAnchorPoint(ccp(1,0))
				plus:setPosition(ccp(head_icon:getContentSize().width/2,-3))
				head_icon:addChild(plus)
				local num = CCSprite:create("images/hero/transfer/numbers/" .. tonumber(_arrSelectedHeroes[i].evolve_level) .. ".png")
				num:setAnchorPoint(ccp(0,0))
				num:setPosition(ccp(head_icon:getContentSize().width/2,-3))
				head_icon:addChild(num)
			end
		elseif (not table.isEmpty(_arrSelectedItems)) and (i <= #_arrSelectedItems) then
			local i_data = DB_Item_arm.getDataById(_arrSelectedItems[i].item_template_id)
			head_icon = CCSprite:create("images/base/equip/small/" .. i_data.icon_small)
		elseif (not table.isEmpty(_arrSelectedGoods)) and (i <= #_arrSelectedGoods)  then
			local i_data = DB_Item_treasure.getDataById(_arrSelectedGoods[i].item_template_id)
			head_icon = CCSprite:create("images/base/treas/small/" .. i_data.icon_small)
		elseif (not table.isEmpty(_arrSelectedCloths)) and (i <= #_arrSelectedCloths) then
			local i_data = DB_Item_dress.getDataById(_arrSelectedCloths[i].item_template_id)

			local iconName
			local oldhtid = UserModel.getAvatarHtid()
			local model_id = DB_Heroes.getDataById(tonumber(oldhtid)).model_id
			local nameArray = lua_string_split(i_data.icon_small, ",")
			for k,v in pairs(nameArray) do
		    	local array = lua_string_split(v, "|")
		    	if(tonumber(array[1]) == tonumber(model_id)) then
					iconName = array[2]
					break
		    	end
		    end

			head_icon = CCSprite:create("images/base/fashion/small/" .. iconName)
		else
		  	--head_icon=CCSprite:create("images/common/add.png")
		  	head_icon=CCSprite:create("images/common/add_new.png")
			local arrActions_2 = CCArray:create()
			arrActions_2:addObject(CCFadeOut:create(1))
			arrActions_2:addObject(CCFadeIn:create(1))
			local sequence_2 = CCSequence:create(arrActions_2)
			local action_2 = CCRepeatForever:create(sequence_2)
			head_icon:runAction(action_2)
		end

		head_icon:setPosition(ccp(head_icon_bg:getContentSize().width/2, head_icon_bg:getContentSize().height/2))
		head_icon:setAnchorPoint(ccp(0.5, 0.5))
		head_icon_bg:addChild(head_icon)
		if i == 1 then
			head_icon_bg:setPosition(ccp(_parentSize.width/2,_parentSize.height/2+250*g_fScaleY))
		elseif i == 2 then
			head_icon_bg:setPosition(ccp(_parentSize.width/2-220*g_fScaleX,_parentSize.height/2+130*g_fScaleY))
		elseif i == 3 then
			head_icon_bg:setPosition(ccp(_parentSize.width/2+220*g_fScaleX,_parentSize.height/2+130*g_fScaleY))
		elseif i == 4 then
			head_icon_bg:setPosition(ccp(_parentSize.width/2-130*g_fScaleX,_parentSize.height/2-60*g_fScaleY))
		elseif i == 5 then
			head_icon_bg:setPosition(ccp(_parentSize.width/2+130*g_fScaleX,_parentSize.height/2-60*g_fScaleY))
		end
		head_icon_bg:setAnchorPoint(ccp(0.5, 0.5))
		menu:addChild(head_icon_bg, 0, _ksTagSelectedHeroStart)

		head_icon_bg:setScale(MainScene.elementScale)

		menu:setPosition(ccp(0, 0))
	    _layer:addChild(menu,0,440+i)
	end
end

function fnHandlerOfNetwork(cbFlag, dictData, bRet)
	if not bRet then
		return
	end
	if cbFlag == "mysteryshop.resolveHero" then
		print_t(dictData.ret)

		for i = 1,#_arrSelectedHeroes do
			HeroModel.deleteHeroByHid(_arrSelectedHeroes[i].hid)
		end

		require "script/model/user/UserModel"
		UserModel.addSilverNumber(tonumber(dictData.ret.silver))
		UserModel.addSoulNum(tonumber(dictData.ret.soul))
		UserModel.addJewelNum(tonumber(dictData.ret.jewel))

		require "script/ui/recycle/RecycleMain"
		RecycleMain.updateSilver()

		require "script/ui/recycle/RecycleMain"
		for i = 1,10 do
			if _layer:getChildByTag(440+i) ~= nil then
				_layer:getChildByTag(440+i):setVisible(false)
			end
		end

		RecycleMain.createSomethingAmazing(dictData)
	end
end

function fnHandlerOfNetworkItem(cbFlag, dictData, bRet)
	if not bRet then
		return
	end
	if cbFlag == "mysteryshop.resolveItem" then
		print_t(dictData.ret)

		require "script/model/user/UserModel"
		UserModel.addSilverNumber(tonumber(dictData.ret.silver))

		require "script/ui/recycle/RecycleMain"
		RecycleMain.updateSilver()

		require "script/model/DataCache"
		local bagInfo = DataCache.getBagInfo()
		local iTag
		for k,v in pairs(bagInfo.arm) do
			for i = 1,#_arrSelectedItems do
				if v.item_id == _arrSelectedItems[i].item_id then
					iTag = k
				end
			end
		end
		table.remove(bagInfo.arm,iTag)
		print("Lulala")
		print_t(bagInfo.arm)

		require "script/ui/recycle/RecycleMain"
		for i = 1,10 do
			if _layer:getChildByTag(440+i) ~= nil then
				_layer:getChildByTag(440+i):setVisible(false)
			end
		end

		RecycleMain.createSomethingAmazing(dictData)
	end
end

function gotoBreakDownAction()
	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
	breakDownButton:setEnabled(false)
	fastAddButton:setEnabled(false)
	changeHeroButton:setEnabled(false)
	fastAddItemAction:setEnabled(false)
	changeItemButton:setEnabled(false)
	fastAddGoodAction:setEnabled(false)
	changeGoodButton:setEnabled(false)
	fastAddclothAction:setEnabled(false)
	changeClothButton:setEnabled(false)

	if table.isEmpty(_arrSelectedHeroes) and table.isEmpty(_arrSelectedItems) and table.isEmpty(_arrSelectedGoods) and table.isEmpty(_arrSelectedCloths) then
		AnimationTip.showTip(GetLocalizeStringBy("key_2419"))
		breakDownButton:setEnabled(true)
		fastAddButton:setEnabled(true)
		changeHeroButton:setEnabled(true)
		fastAddItemAction:setEnabled(true)
		changeItemButton:setEnabled(true)
		fastAddGoodAction:setEnabled(true)
		changeGoodButton:setEnabled(true)
		fastAddclothAction:setEnabled(true)
		changeClothButton:setEnabled(true)
		return
	else
		if (not table.isEmpty(_arrSelectedHeroes)) then
			local fiveHero = {}
			for i = 1,#_arrSelectedHeroes do
				if _arrSelectedHeroes[i].star_lv == 5 then
					table.insert(fiveHero,_arrSelectedHeroes[i])
				end
			end
			if not table.isEmpty(fiveHero) then
				require "script/ui/recycle/BreakDowwnTip"
				local showLayer = BreakDowwnTip.createLayer(fiveHero)
				local runningScene = CCDirector:sharedDirector():getRunningScene()
				runningScene:addChild(showLayer, 9999)
			else
				beginToBreakDown()
			end
		end
		if not table.isEmpty(_arrSelectedItems) then
			require "script/ui/item/ItemUtil"
			if  ItemUtil.isPropBagFull(true) then
				breakDownButton:setEnabled(true)
				fastAddButton:setEnabled(true)
				changeHeroButton:setEnabled(true)
				fastAddItemAction:setEnabled(true)
				changeItemButton:setEnabled(true)
				fastAddGoodAction:setEnabled(true)
				changeGoodButton:setEnabled(true)
				fastAddclothAction:setEnabled(true)
				changeClothButton:setEnabled(true)
			else
				print("_arrSelectedItems  is ++++++++++++++++++++=============== ")
				print_t(_arrSelectedItems)
				local fourItem = {}
				for i = 1,#_arrSelectedItems do
					if tonumber(_arrSelectedItems[i].itemDesc.quality) == 5 then
						table.insert(fourItem,_arrSelectedItems[i])
					end
				end
				if not table.isEmpty(fourItem) then
					require "script/ui/recycle/ItemBreakTip"
				 	ItemBreakTip.showLayer(fourItem, beginToBreakDown)
				else
					beginToBreakDown()
				end
			end
		end
		if not table.isEmpty(_arrSelectedGoods) then
			require "script/ui/item/ItemUtil"
			if ItemUtil.isTreasBagFull(true) then
				breakDownButton:setEnabled(true)
				fastAddButton:setEnabled(true)
				changeHeroButton:setEnabled(true)
				fastAddItemAction:setEnabled(true)
				changeItemButton:setEnabled(true)
				fastAddGoodAction:setEnabled(true)
				changeGoodButton:setEnabled(true)
				fastAddclothAction:setEnabled(true)
				changeClothButton:setEnabled(true)
			else
				local fiveGood = {}
				for i = 1,#_arrSelectedGoods do
					if tonumber(_arrSelectedGoods[i].itemDesc.quality) == 5 then
						table.insert(fiveGood,_arrSelectedGoods[i])
					end
				end
				if not table.isEmpty(fiveGood) then
					require "script/ui/recycle/TreasureBreakDowwnTip"
					TreasureBreakDowwnTip.showLayer(fiveGood,beginToBreakDown)
				else
					beginToBreakDown()
				end
			end
		end
		if not table.isEmpty(_arrSelectedCloths) then
			require "script/ui/item/ItemUtil"
			if  ItemUtil.isPropBagFull(true) then
				breakDownButton:setEnabled(true)
				fastAddButton:setEnabled(true)
				changeHeroButton:setEnabled(true)
				fastAddItemAction:setEnabled(true)
				changeItemButton:setEnabled(true)
				fastAddGoodAction:setEnabled(true)
				changeGoodButton:setEnabled(true)
				fastAddclothAction:setEnabled(true)
				changeClothButton:setEnabled(true)
			else
				local fiveCloth = {}
				for i = 1,#_arrSelectedCloths do
					if tonumber(_arrSelectedCloths[i].itemDesc.quality) == 5 then
						table.insert(fiveCloth,_arrSelectedCloths[i])
					end
				end
				if not table.isEmpty(fiveCloth) then
					require "script/ui/recycle/ClothBreakDoenTip"
					ClothBreakDoenTip.showLayer(fiveCloth,beginToBreakDown)
				else
					beginToBreakDown()
				end
			end
		end
	end
end

function cancelBreakDown()
	breakDownButton:setEnabled(true)
	fastAddButton:setEnabled(true)
	changeHeroButton:setEnabled(true)
	fastAddItemAction:setEnabled(true)
	changeItemButton:setEnabled(true)
	fastAddGoodAction:setEnabled(true)
	changeGoodButton:setEnabled(true)
	fastAddclothAction:setEnabled(true)
	changeClothButton:setEnabled(true)
end

function fnHandlerOfNetworkGood(cbFlag, dictData, bRet)
	if not bRet then
		return
	end
	if cbFlag == "mysteryshop.resolveTreasure" then
		print("炼化宝物结果是~~~")
		print_t(dictData.ret)

		require "script/model/user/UserModel"
		UserModel.addSilverNumber(tonumber(dictData.ret.silver))

		require "script/ui/recycle/RecycleMain"
		RecycleMain.updateSilver()

		require "script/model/DataCache"
		local bagInfo = DataCache.getBagInfo()
		local iTag
		for k,v in pairs(bagInfo.treas) do
			for i = 1,#_arrSelectedGoods do
				if v.item_id == _arrSelectedGoods[i].item_id then
					iTag = k
				end
			end
		end
		table.remove(bagInfo.treas,iTag)
		print("Lulala")
		print_t(bagInfo.treas)

		require "script/ui/recycle/RecycleMain"
		for i = 1,10 do
			if _layer:getChildByTag(440+i) ~= nil then
				_layer:getChildByTag(440+i):setVisible(false)
			end
		end

		RecycleMain.createSomethingAmazing(dictData)
	end
end

function fnHandlerOfNetworkCloth(cbFlag,dictData,bRet)
	if not bRet then
		return
	end
	if cbFlag == "mysteryshop.resolveDress" then
		print_t(dictData.ret)

		require "script/model/user/UserModel"
		UserModel.addSilverNumber(tonumber(dictData.ret.silver))

		require "script/ui/recycle/RecycleMain"
		RecycleMain.updateSilver()

		require "script/model/DataCache"
		local bagInfo = DataCache.getBagInfo()
		local iTag
		for k,v in pairs(bagInfo.dress) do
			for i = 1,#_arrSelectedCloths do
				if v.item_id == _arrSelectedCloths[i].item_id then
					iTag = k
				end
			end
		end
		table.remove(bagInfo.dress,iTag)
		print("Lulala")
		print_t(bagInfo.dress)

		require "script/ui/recycle/RecycleMain"
		for i = 1,10 do
			if _layer:getChildByTag(440+i) ~= nil then
				_layer:getChildByTag(440+i):setVisible(false)
			end
		end

		RecycleMain.createSomethingAmazing(dictData)
	end
end

function beginToBreakDown()
	local arg = CCArray:create()
	local subArg = CCArray:create()
	require "script/network/Network"
	if not table.isEmpty(_arrSelectedHeroes) then
		for i = 1,#_arrSelectedHeroes do
			subArg:addObject(CCInteger:create(_arrSelectedHeroes[i].hid))
		end
		arg:addObject(subArg)
		Network.rpc(fnHandlerOfNetwork, "mysteryshop.resolveHero","mysteryshop.resolveHero", arg, true)
	end

	if not table.isEmpty(_arrSelectedItems) then
		for i = 1,#_arrSelectedItems do
			subArg:addObject(CCInteger:create(_arrSelectedItems[i].item_id))
		end
		arg:addObject(subArg)
		Network.rpc(fnHandlerOfNetworkItem, "mysteryshop.resolveItem","mysteryshop.resolveItem", arg, true)
	end

	if not table.isEmpty(_arrSelectedGoods) then
		for i = 1,#_arrSelectedGoods do
			subArg:addObject(CCInteger:create(_arrSelectedGoods[i].item_id))
		end
		arg:addObject(subArg)
		Network.rpc(fnHandlerOfNetworkGood, "mysteryshop.resolveTreasure","mysteryshop.resolveTreasure", arg, true)
	end

	if not table.isEmpty(_arrSelectedCloths) then
		for i = 1,#_arrSelectedCloths do
			print("时装的炼化id")
			print_t(_arrSelectedCloths[i])
			print(_arrSelectedCloths[i].item_id)
			subArg:addObject(CCInteger:create(_arrSelectedCloths[i].item_id))
		end
		arg:addObject(subArg)
		Network.rpc(fnHandlerOfNetworkCloth,"mysteryshop.resolveDress","mysteryshop.resolveDress",arg,true)
	end
end

function animateCallBack(dictData)
	_arrSelectedHeroes = {}
	_arrSelectedItems = {}
	_arrSelectedGoods = {}
	_arrSelectedCloths = {}
	for i = 1,10 do
		_layer:removeChildByTag(440+i,true)
	end
	createAddMenu()

	print("$$$$$$")
	print_t(dictData.ret)
	require "script/ui/recycle/BreakDownGiftLayer"

	local showLayer = BreakDownGiftLayer.createLayer(dictData.ret)
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	runningScene:addChild(showLayer, 9999)

	breakDownButton:setEnabled(true)
	fastAddButton:setEnabled(true)
	changeHeroButton:setEnabled(true)
	fastAddItemAction:setEnabled(true)
	changeItemButton:setEnabled(true)
	fastAddGoodAction:setEnabled(true)
	changeGoodButton:setEnabled(true)
	fastAddclothAction:setEnabled(true)
	changeClothButton:setEnabled(true)

	fastAddButton:setVisible(true)
	changeHeroButton:setVisible(false)
	fastAddItemAction:setVisible(true)
	changeItemButton:setVisible(false)
	fastAddGoodAction:setVisible(true)
	changeGoodButton:setVisible(false)
	fastAddclothAction:setVisible(true)
	changeClothButton:setVisible(false)
end

function fastAddAction(tag)
	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
	--fastAddButton:setEnabled(false)
	fastAddItemAction:setVisible(true)
	changeItemButton:setVisible(false)
	fastAddGoodAction:setVisible(true)
	changeGoodButton:setVisible(false)
	fastAddclothAction:setVisible(true)
	changeClothButton:setVisible(false)

	-- EQUIP_ADD = -1
	-- GOOD_ADD = -1
	require "script/ui/recycle/ResolveSelectLayer"
	local tArgsOfModule = {sign="BreakDownLayer"}
	tArgsOfModule.selected = {}
	tArgsOfModule.filters = getFiltersForSelection()
	
	if tag == FAST_HERO_TAG then
		local temp = ResolveSelectLayer.getFastHeroList(tArgsOfModule)
		print(GetLocalizeStringBy("key_1623"),#temp)
		_arrSelectedHeroes = {}
		local cont = 0
		for i = 1,#temp do
			cont = cont+1
			table.insert(_arrSelectedHeroes,temp[i])
			if i == 5 then
				break
			end
		end
		HERO_ADD = cont+1
		print("添加后add",HERO_ADD)
	elseif tag == CHANGE_HERO_TAG then
		print("addheronum",HERO_ADD)
		local temp = ResolveSelectLayer.getFastHeroList(tArgsOfModule)
		if HERO_ADD > table.count(temp) then
			HERO_ADD = 1
		end

		_arrSelectedHeroes = {}
		local addCount = 0
		for i = HERO_ADD,#temp do
			addCount = addCount +1
			table.insert(_arrSelectedHeroes,temp[i])
			if addCount == 5 then
				break
			end
		end

		HERO_ADD = HERO_ADD + addCount
	end
	if table.isEmpty(_arrSelectedHeroes) then
		require "script/ui/tip/AnimationTip"
		AnimationTip.showTip(GetLocalizeStringBy("key_2555"))
		--fastAddButton:setEnabled(false)
	else
		NOWIN_TAG = HERO_TAG
		if tag == FAST_HERO_TAG then
			fastAddButton:setVisible(false)
			changeHeroButton:setVisible(true)
		end
	end

	_arrSelectedItems = {}
	_arrSelectedGoods = {}
	_arrSelectedCloths = {}

	for i = 1,10 do
		_layer:removeChildByTag(440+i,true)
	end
	createAddMenu()
end

function fastAddItem(tag)
	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
	fastAddButton:setVisible(true)
	changeHeroButton:setVisible(false)
	fastAddGoodAction:setVisible(true)
	changeGoodButton:setVisible(false)
	fastAddclothAction:setVisible(true)
	changeClothButton:setVisible(false)

	-- HERO_ADD = -1
	-- GOOD_ADD = -1
	local allItem = getFiltersForItem()
	if table.count(allItem) ~= 0 then
		if tag == FAST_EQUIP_TAG then
			local cont = 0
			_arrSelectedItems = {}
			for i = #allItem,1,-1 do
				cont = cont+1
				if cont <= 5 then
					table.insert(_arrSelectedItems,allItem[i])
				else
					break
				end
			end
			if tonumber(cont) > 5 then
				EQUIP_ADD = cont-1
			else
				EQUIP_ADD = cont
			end
			fastAddItemAction:setVisible(false)
			changeItemButton:setVisible(true)
		elseif tag == CHANGE_EQUIP_TAG then

			if EQUIP_ADD >= (#allItem) then
				EQUIP_ADD = 0
			end

			_arrSelectedItems = {}
			local cont = 0
			for i = #allItem-EQUIP_ADD,1,-1 do
				cont = cont+1
				table.insert(_arrSelectedItems,allItem[i])
				if cont == 5 then
					break
				end
			end
			EQUIP_ADD = EQUIP_ADD+cont
		end
		NOWIN_TAG = EQUIP_TAG
	end
	if table.count(allItem) == 0 then
		require "script/ui/tip/AnimationTip"
		AnimationTip.showTip(GetLocalizeStringBy("key_1118"))
	end

	_arrSelectedHeroes = {}
	_arrSelectedGoods = {}
	_arrSelectedCloths = {}

	for i = 1,10 do
		_layer:removeChildByTag(440+i,true)
	end
	createAddMenu()
end

function fastAddGood(tag)
	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
	fastAddButton:setVisible(true)
	changeHeroButton:setVisible(false)
	fastAddItemAction:setVisible(true)
	changeItemButton:setVisible(false)
	fastAddclothAction:setVisible(true)
	changeClothButton:setVisible(false)

	-- HERO_ADD = -1
	-- EQUIP_ADD = -1
	local allItem = getFiltersForGood()
	if table.count(allItem) ~= 0 then
		if tag == FAST_GOOD_TAG then
			local cont = 0
			_arrSelectedGoods = {}
			for i = #allItem,1,-1 do
				cont = cont+1
				if cont <= 5 then
					table.insert(_arrSelectedGoods,allItem[i])
				else
					break
				end
			end
			if tonumber(cont) > 5 then
				GOOD_ADD = cont-1
			else
				GOOD_ADD = cont
			end
			fastAddGoodAction:setVisible(false)
			changeGoodButton:setVisible(true)
		elseif tag == CHANGE_GOOD_TAG then
			if GOOD_ADD >= (#allItem)then
				GOOD_ADD = 0
			end

			_arrSelectedGoods = {}
			local cont = 0
			for i = #allItem-GOOD_ADD,1,-1 do
				cont = cont+1
				table.insert(_arrSelectedGoods,allItem[i])
				if cont == 5 then
					break
				end
			end
			GOOD_ADD = GOOD_ADD+cont
		end
		NOWIN_TAG = GOOD_TAG
	end
	if table.count(allItem) == 0 then
		require "script/ui/tip/AnimationTip"
		AnimationTip.showTip(GetLocalizeStringBy("key_1875"))
	end

	_arrSelectedHeroes = {}
	_arrSelectedItems = {}
	_arrSelectedCloths = {}

	for i = 1,10 do
		_layer:removeChildByTag(440+i,true)
	end
	createAddMenu()
end

function fastAddCloth(tag)
	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
	fastAddButton:setVisible(true)
	changeHeroButton:setVisible(false)
	fastAddItemAction:setVisible(true)
	changeItemButton:setVisible(false)
	fastAddGoodAction:setVisible(true)
	changeGoodButton:setVisible(false)

	-- HERO_ADD = -1
	-- EQUIP_ADD = -1
	local allItem = getFiltersForCloth()
	if table.count(allItem) ~= 0 then
		if tag == FAST_CLOTH_TAG then
			local cont = 0
			_arrSelectedCloths = {}
			for i = #allItem,1,-1 do
				cont = cont+1
				if cont <= 5 then
					table.insert(_arrSelectedCloths,allItem[i])
				else
					break
				end
			end
			if tonumber(cont) > 5 then
				CLOTH_ADD = cont-1
			else
				CLOTH_TAG = cont
			end
			fastAddclothAction:setVisible(false)
			changeClothButton:setVisible(true)
		elseif tag == CHANGE_CLOTH_TAG then
			if CLOTH_ADD >= (#allItem)then
				CLOTH_ADD = 0
			end

			_arrSelectedCloths = {}
			local cont = 0
			for i = #allItem- CLOTH_ADD,1,-1 do
				cont = cont+1
				table.insert(_arrSelectedCloths,allItem[i])
				if cont == 5 then
					break
				end
			end
			CLOTH_ADD = CLOTH_ADD+cont
		end
		NOWIN_TAG = CLOTH_TAG
	end
	if table.count(allItem) == 0 then
		require "script/ui/tip/AnimationTip"
		AnimationTip.showTip(GetLocalizeStringBy("key_2448"))
	end

	_arrSelectedHeroes = {}
	_arrSelectedItems = {}
	_arrSelectedGoods = {}

	for i = 1,10 do
		_layer:removeChildByTag(440+i,true)
	end
	createAddMenu()
end

function createBreakDownMenu()
	local menuBar_g = CCMenu:create()
	menuBar_g:setPosition(ccp(0,0))
	_layer:addChild(menuBar_g)

	breakDownButton = LuaCC.create9ScaleMenuItem("images/common/btn/btn1_d.png","images/common/btn/btn1_n.png",CCSizeMake(200, 73),GetLocalizeStringBy("key_3040"),ccc3(0xfe, 0xdb, 0x1c),35,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00))
	breakDownButton:setAnchorPoint(ccp(0.5, 0.5))
    breakDownButton:setPosition(ccp(_layer:getContentSize().width*0.5, 300*g_fScaleY))
    breakDownButton:registerScriptTapHandler(gotoBreakDownAction)
	menuBar_g:addChild(breakDownButton)
	breakDownButton:setScale(MainScene.elementScale)

	--武将按钮
	fastAddButton = LuaCC.create9ScaleMenuItem("images/common/btn/btn1_d.png","images/common/btn/btn1_n.png",CCSizeMake(210, 73),GetLocalizeStringBy("key_1524"),ccc3(0xfe, 0xdb, 0x1c),29,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00),ccp(-20,0))
	fastAddButton:setAnchorPoint(ccp(0, 0.5))
    fastAddButton:setPosition(ccp(0, 250*g_fScaleY))
    fastAddButton:registerScriptTapHandler(fastAddAction)
	menuBar_g:addChild(fastAddButton,0,FAST_HERO_TAG)
	fastAddButton:setScale(MainScene.elementScale)

	local heroHead = CCSprite:create("images/recycle/btn/hero.png")
	heroHead:setAnchorPoint(ccp(1,0.5))
	heroHead:setPosition(ccp(fastAddButton:getContentSize().width-25,fastAddButton:getContentSize().height/2))
	fastAddButton:addChild(heroHead)

	changeHeroButton = LuaCC.create9ScaleMenuItem("images/common/btn/btn1_d.png","images/common/btn/btn1_n.png",CCSizeMake(210, 73),GetLocalizeStringBy("key_2699"),ccc3(0xfe, 0xdb, 0x1c),29,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00),ccp(-20,0))
	changeHeroButton:setAnchorPoint(ccp(0, 0.5))
    changeHeroButton:setPosition(ccp(0, 250*g_fScaleY))
    changeHeroButton:registerScriptTapHandler(fastAddAction)
	menuBar_g:addChild(changeHeroButton,0,CHANGE_HERO_TAG)
	changeHeroButton:setScale(MainScene.elementScale)
	
	local heroHead1 = CCSprite:create("images/recycle/btn/hero.png")
	heroHead1:setAnchorPoint(ccp(1,0.5))
	heroHead1:setPosition(ccp(changeHeroButton:getContentSize().width-25,changeHeroButton:getContentSize().height/2))
	changeHeroButton:addChild(heroHead1)

	print(GetLocalizeStringBy("key_1945"))
	print(table.isEmpty(_arrSelectedHeroes))
	print_t(_arrSelectedHeroes)
	if table.isEmpty(_arrSelectedHeroes) then
		fastAddButton:setVisible(true)
		changeHeroButton:setVisible(false)
	else
		fastAddButton:setVisible(false)
		changeHeroButton:setVisible(true)
	end

	--装备按钮
	fastAddItemAction = LuaCC.create9ScaleMenuItem("images/common/btn/btn1_d.png","images/common/btn/btn1_n.png",CCSizeMake(210, 73),GetLocalizeStringBy("key_3286"),ccc3(0xfe, 0xdb, 0x1c),29,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00),ccp(-20,0))
	fastAddItemAction:setAnchorPoint(ccp(1, 0.5))
    fastAddItemAction:setPosition(ccp(_layer:getContentSize().width, 250*g_fScaleY))
    fastAddItemAction:registerScriptTapHandler(fastAddItem)
	menuBar_g:addChild( fastAddItemAction,0,FAST_EQUIP_TAG)
	fastAddItemAction:setScale(MainScene.elementScale)

	local itemHead = CCSprite:create("images/recycle/btn/item.png")
	itemHead:setAnchorPoint(ccp(1,0.5))
	itemHead:setPosition(ccp(fastAddItemAction:getContentSize().width-25,fastAddItemAction:getContentSize().height/2))
	fastAddItemAction:addChild(itemHead)

	changeItemButton = LuaCC.create9ScaleMenuItem("images/common/btn/btn1_d.png","images/common/btn/btn1_n.png",CCSizeMake(210, 73),GetLocalizeStringBy("key_2699"),ccc3(0xfe, 0xdb, 0x1c),29,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00),ccp(-20,0))
	changeItemButton:setAnchorPoint(ccp(1, 0.5))
    changeItemButton:setPosition(ccp(_layer:getContentSize().width, 250*g_fScaleY))
    changeItemButton:registerScriptTapHandler(fastAddItem)
	menuBar_g:addChild( changeItemButton,0,CHANGE_EQUIP_TAG)
	changeItemButton:setScale(MainScene.elementScale)

	local itemHead1 = CCSprite:create("images/recycle/btn/item.png")
	itemHead1:setAnchorPoint(ccp(1,0.5))
	itemHead1:setPosition(ccp(changeItemButton:getContentSize().width-25,changeItemButton:getContentSize().height/2))
	changeItemButton:addChild(itemHead1)

	if table.isEmpty(_arrSelectedItems) then
		fastAddItemAction:setVisible(true)
		changeItemButton:setVisible(false)
	else
		fastAddItemAction:setVisible(false)
		changeItemButton:setVisible(true)
	end

	--宝物按钮
	fastAddGoodAction = LuaCC.create9ScaleMenuItem("images/common/btn/btn1_d.png","images/common/btn/btn1_n.png",CCSizeMake(210, 73),GetLocalizeStringBy("key_2166"),ccc3(0xfe, 0xdb, 0x1c),29,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00),ccp(-20,0))
	fastAddGoodAction:setAnchorPoint(ccp(0, 0.5))
    fastAddGoodAction:setPosition(ccp(0, 170*g_fScaleY))
    fastAddGoodAction:registerScriptTapHandler(fastAddGood)
	menuBar_g:addChild( fastAddGoodAction,0,FAST_GOOD_TAG)
	fastAddGoodAction:setScale(MainScene.elementScale)

	local goodHead = CCSprite:create("images/recycle/btn/treasure.png")
	goodHead:setAnchorPoint(ccp(1,0.5))
	goodHead:setPosition(ccp(fastAddGoodAction:getContentSize().width-25,fastAddGoodAction:getContentSize().height/2))
	fastAddGoodAction:addChild(goodHead)

	changeGoodButton = LuaCC.create9ScaleMenuItem("images/common/btn/btn1_d.png","images/common/btn/btn1_n.png",CCSizeMake(210, 73),GetLocalizeStringBy("key_2699"),ccc3(0xfe, 0xdb, 0x1c),29,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00),ccp(-20,0))
	changeGoodButton:setAnchorPoint(ccp(0, 0.5))
    changeGoodButton:setPosition(ccp(0, 170*g_fScaleY))
    changeGoodButton:registerScriptTapHandler(fastAddGood)
	menuBar_g:addChild( changeGoodButton,0,CHANGE_GOOD_TAG)
	changeGoodButton:setScale(MainScene.elementScale)

	local goodHead1 = CCSprite:create("images/recycle/btn/treasure.png")
	goodHead1:setAnchorPoint(ccp(1,0.5))
	goodHead1:setPosition(ccp(changeGoodButton:getContentSize().width-25,changeGoodButton:getContentSize().height/2))
	changeGoodButton:addChild(goodHead1)

	if table.isEmpty(_arrSelectedGoods) then
		fastAddGoodAction:setVisible(true)
		changeGoodButton:setVisible(false)
	else
		fastAddGoodAction:setVisible(false)
		changeGoodButton:setVisible(true)
	end

	--时装按钮
	fastAddclothAction = LuaCC.create9ScaleMenuItem("images/common/btn/btn1_d.png","images/common/btn/btn1_n.png",CCSizeMake(210, 73),GetLocalizeStringBy("key_1136"),ccc3(0xfe, 0xdb, 0x1c),29,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00),ccp(-20,0))
	fastAddclothAction:setAnchorPoint(ccp(1, 0.5))
    fastAddclothAction:setPosition(ccp(_layer:getContentSize().width, 170*g_fScaleY))
    fastAddclothAction:registerScriptTapHandler(fastAddCloth)
	menuBar_g:addChild( fastAddclothAction,0,FAST_CLOTH_TAG)
	fastAddclothAction:setScale(MainScene.elementScale)

	local clothHead = CCSprite:create("images/recycle/btn/cloth.png")
	clothHead:setAnchorPoint(ccp(1,0.5))
	clothHead:setPosition(ccp(fastAddclothAction:getContentSize().width-25,fastAddclothAction:getContentSize().height/2))
	fastAddclothAction:addChild(clothHead)

	changeClothButton = LuaCC.create9ScaleMenuItem("images/common/btn/btn1_d.png","images/common/btn/btn1_n.png",CCSizeMake(210, 73),GetLocalizeStringBy("key_2699"),ccc3(0xfe, 0xdb, 0x1c),29,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00),ccp(-20,0))
	changeClothButton:setAnchorPoint(ccp(1, 0.5))
    changeClothButton:setPosition(ccp(_layer:getContentSize().width, 170*g_fScaleY))
    changeClothButton:registerScriptTapHandler(fastAddCloth)
	menuBar_g:addChild( changeClothButton,0,CHANGE_CLOTH_TAG)
	changeClothButton:setScale(MainScene.elementScale)

	local clothHead1 = CCSprite:create("images/recycle/btn/cloth.png")
	clothHead1:setAnchorPoint(ccp(1,0.5))
	clothHead1:setPosition(ccp(changeClothButton:getContentSize().width-25,changeClothButton:getContentSize().height/2))
	changeClothButton:addChild(clothHead1)

	if table.isEmpty(_arrSelectedCloths) then
		fastAddclothAction:setVisible(true)
		changeClothButton:setVisible(false)
	else
		fastAddclothAction:setVisible(false)
		changeClothButton:setVisible(true)
	end

end

function createLayer(tParam)
	init()

	if tParam == nil then 
		-- HERO_ADD = -1
		-- EQUIP_ADD = -1
		-- GOOD_ADD = -1
	end
	if tParam ~= nil then
		if tParam.sign == "ResurrectLayer" then
			_arrSelectedHeroes = {}
			_arrSelectedItems = {}
			_arrSelectedGoods = {}
			_arrSelectedCloths = {}
		elseif tParam.nowSit == "heroList" then
			_arrSelectedHeroes = tParam.selectedHeroes
			_arrSelectedItems = {}
			_arrSelectedGoods = {}
			_arrSelectedCloths = {}
		elseif tParam.nowSit == "itemList" then
			_arrSelectedItems = tParam.selectedHeroes
			_arrSelectedHeroes = {}
			_arrSelectedGoods = {}
			_arrSelectedCloths = {}
		elseif tParam.nowSit == "goodList" then
			_arrSelectedGoods = tParam.selectedHeroes
			print(GetLocalizeStringBy("key_1433"))
			print_t(_arrSelectedGoods)
			_arrSelectedItems = {}
			_arrSelectedHeroes = {}
			_arrSelectedCloths = {}
		elseif tParam.nowSit == "clothList" then
			_arrSelectedCloths = tParam.selectedHeroes
			print("选中了时装")
			print_t(_arrSelectedCloths)

			_arrSelectedItems = {}
			_arrSelectedGoods = {}
			_arrSelectedHeroes = {}
		end
		print(tParam.nowSit)
	end

	print("ZZZHHH3")
	print_t(tParam)
	print_t(_arrSelectedItems)
	require "script/ui/recycle/RecycleMain"
	_parentSize = RecycleMain.getLayerSize()

	_layer = CCLayer:create()

	--创建说明文字
	--createBreakDownDescribe()

	--创建分解与一键分解按钮
	createBreakDownMenu()

	--创建添加按钮
	createAddMenu()

	return _layer
end

function createLayerAfterSelectHero(tParam)
	local tArgs = {}
	tArgs.sign = tParam.sign
	print("打印tParam")
	print_t(tParam)
	if tParam.nowSit == "heroList" then 
		tArgs.selectedHeroes = tParam.selectedHeroes
		tArgs.nowSit = "heroList"
		NOWIN_TAG = HERO_TAG
	end
	if tParam.nowSit == "itemList" then
		tArgs.selectedHeroes = tParam.selectedHeroes
		tArgs.nowSit = "itemList"
		NOWIN_TAG = EQUIP_TAG
	end
	if tParam.nowSit == "goodList" then
		tArgs.selectedHeroes = tParam.selectedHeroes
		tArgs.nowSit = "goodList"
		NOWIN_TAG = GOOD_TAG
	end
	if tParam.nowSit == "clothList" then
		tArgs.selectedHeroes = tParam.selectedHeroes
		tArgs.nowSit = "clothList"
		NOWIN_TAG = CLOTH_TAG
	end

	print("ZZZHHH2")
	print_t(tParam)
	print_t(tArgs)
	require "script/ui/recycle/RecycleMain"
	local recycleLayer = RecycleMain.create(tArgs)

	return recycleLayer
end
