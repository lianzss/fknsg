-- Filename: ResurrectLayer.lua
-- Author: zhang zihang
-- Date: 2013-11-28
-- Purpose: 该文件用于: 武将重生页面

module ("ResurrectLayer", package.seeall)

require "script/ui/main/MainScene"
require "script/model/user/UserModel"
require "script/model/hero/HeroModel"
require "script/ui/tip/AnimationTip"
require "script/model/DataCache"
require "db/DB_Item_dress"

function init()
	_layer = nil
	_parentSize = nil

	resurrectButton = nil

	_goldNeedNumber = 0
	_ksTagSelectedHeroStart = 4001

	--用于存放四个添加格子的内容
	_csAddHeroeButtons = {}
	--有武将的格子的武将信息
	_arrSelectedHeroes = {}

	_arrSelectedItems = {}
	_arrSelectedCloths = {}
	_arrSelectedGoods = {}
end

--创建复活说明文字
-- function createResurrectDescribe()
-- 	local resurrectDescribe = CCSprite:create("images/recycle/describe/resurrect2.png")
-- 	resurrectDescribe:setAnchorPoint(ccp(0.5,0.5))
-- 	resurrectDescribe:setPosition(ccp(_parentSize.width/2,_parentSize.height/2-160*g_fScaleY))
-- 	resurrectDescribe:setScale(MainScene.elementScale)
-- 	_layer:addChild(resurrectDescribe)

-- 	local resurrectDescribe = CCSprite:create("images/recycle/describe/resurrect.png")
-- 	resurrectDescribe:setAnchorPoint(ccp(0.5,0.5))
-- 	resurrectDescribe:setPosition(ccp(_parentSize.width/2,_parentSize.height/2-105*g_fScaleY))
-- 	resurrectDescribe:setScale(MainScene.elementScale)
-- 	_layer:addChild(resurrectDescribe)
-- end

--过滤武将
function getFiltersForSelection()
	local filters = {}
	local tAllHeroes = HeroModel.getAllHeroes()
	print("zhujuene~~~~")
	print_t(tAllHeroes)
	require "db/DB_Heroes"
	for k, v in pairs(tAllHeroes) do
		-- 去除主角
		if HeroModel.isNecessaryHero(v.htid) then
			table.insert(filters, v.hid)
		else
			-- 去除在阵上武将
			require "script/ui/hero/HeroPublicLua"
			local bIsBusy = HeroPublicLua.isBusyWithHid(v.hid)
			if bIsBusy then
				table.insert(filters, v.hid)
			end

			--去除小伙伴
			require "script/ui/formation/LittleFriendData"
			if LittleFriendData.isInLittleFriend(v.hid) then
				table.insert(filters,v.hid)
			end

			--去掉枷锁的武将
			if v.lock and tonumber(v.lock)== 1 then
				table.insert(filters,v.hid)
			end

			if tonumber(v.level) < 2 then
				table.insert(filters,v.hid)
			end

			local db_hero = DB_Heroes.getDataById(v.htid)
			if (db_hero.advanced_id == nil) or (tonumber(db_hero.advanced_id) == 0) then
				table.insert(filters,v.hid)
			end

			-- if (v.advanced_id == nil) or (tonumber(v.advanced_id) == 0) then
			-- 	table.insert(filters,v.hid)
			-- end
			
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
	print("bagInfo.arm~~~")
	print_t(bagInfo.arm)
	local bagArmInfo = {}

	table.hcopy(bagInfo.arm,bagArmInfo)


	for k,v in pairs(bagArmInfo) do
		if (tonumber(v.itemDesc.quality) >= 5) and (tonumber(v.va_item_text.armReinforceLevel) > 0) then
			if not(v.va_item_text.lock and tonumber(v.va_item_text.lock) == 1 )then
				table.insert(filt,v)
			end
		end
		v.isSelected = false
		--v.ccObj = nil
	end

	local function sort(w1, w2)
		if tonumber(w1.va_item_text.armReinforceLevel) > tonumber(w2.va_item_text.armReinforceLevel) then
			return true
		else 
			return false
		end
		--return w1.star_lv < w2.star_lv
	end

	table.sort(filt, sort)

	return filt

end

function getFiltersForCloth()
	local filt = {}
	local bagInfo = DataCache.getBagInfo()
	print("时装哦")
	print_t(bagInfo.dress)
	print_t(bagInfo)

	local bagDressInfo = {}

	table.hcopy(bagInfo.dress,bagDressInfo)
	for k,v in pairs(bagDressInfo) do
		if tonumber(v.va_item_text.dressLevel) > 0 then
			table.insert(filt,v)
			v.isSelected = false
		end
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

function getFiltersForGood()
	local filt = {}
	local bagInfo = DataCache.getBagInfo()
	
	local bagGoodInfo = {}

	table.hcopy(bagInfo.treas,bagGoodInfo)
	print("空")
	print_t(bagGoodInfo)
	for k,v in pairs(bagGoodInfo) do
		if (tonumber(v.itemDesc.quality) >= 4) and (v.itemDesc.isExpTreasure == nil) and (v.va_item_text.treasureEvolve ~= nil) then
			print(v.itemDesc.name)
			if (tonumber(v.va_item_text.treasureEvolve) > 0) or (tonumber(v.va_item_text.treasureLevel) > 0) then
				table.insert(filt,v)
				v.isSelected = false
			end
		end
	end

	local function  sort(w1,w2)
		if tonumber(w1.va_item_text.treasureLevel) > tonumber(w2.va_item_text.treasureLevel) then
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
	
	require "script/ui/item/ItemUtil"
	require "script/ui/hero/HeroPublicUI"
	-- if  ItemUtil.isPropBagFull(true) then
	-- 	--AnimationTip.showTip(GetLocalizeStringBy("key_1739"))
	-- elseif HeroPublicUI.showHeroIsLimitedUI() then
	-- 	--AnimationTip.showTip(GetLocalizeStringBy("key_3126"))
	-- elseif ItemUtil.isTreasBagFull(true) then
	--else
	--require "script/ui/recycle/RecycleHeroSelectLayer"
	local tArgsOfModule = {sign="ResurrectLayer"}
	--tArgsOfModule.selected = _arrSelectedHeroes
	--武将筛选
	tArgsOfModule.filters = getFiltersForSelection()
	tArgsOfModule.filtersItem = getFiltersForItem()
	tArgsOfModule.filtersCloth = getFiltersForCloth()
	tArgsOfModule.filtersGood  = getFiltersForGood()
	print("here comes a item")
	print_t(tArgsOfModule.filtersItem)

	if _arrSelectedItems and _arrSelectedItems.item_id ~= nil then
		tArgsOfModule.nowIn = "itemList"

		for i = 1,#tArgsOfModule.filtersItem do
			if tArgsOfModule.filtersItem[i].item_id == _arrSelectedItems.item_id then
				print("ZHHHHH")
				tArgsOfModule.filtersItem[i].isSelected = true
				print_t(tArgsOfModule.filtersItem[i])
			end
		end

		tArgsOfModule.selected = _arrSelectedItems
	elseif _arrSelectedCloths and _arrSelectedCloths.item_id ~= nil then
		tArgsOfModule.nowIn = "clothList"

		for i = 1,#tArgsOfModule.filtersCloth do
			if tArgsOfModule.filtersCloth[i].item_id == _arrSelectedCloths.item_id then
				print("ZHHHHH")
				tArgsOfModule.filtersCloth[i].isSelected = true
				print_t(tArgsOfModule.filtersCloth[i])
			end
		end

		tArgsOfModule.selected = _arrSelectedCloths
	elseif _arrSelectedGoods and _arrSelectedGoods.item_id ~= nil then
		tArgsOfModule.nowIn = "goodList"
		for i = 1,#tArgsOfModule.filtersGood do
			if tArgsOfModule.filtersGood[i].item_id == _arrSelectedGoods.item_id then
				tArgsOfModule.filtersGood[i].isSelected = true
			end
		end
		tArgsOfModule.selected = _arrSelectedGoods
	else
		tArgsOfModule.nowIn = "heroList"
		tArgsOfModule.selected = _arrSelectedHeroes
	end

	require "script/ui/recycle/RebornSelectLayer"
	MainScene.changeLayer(RebornSelectLayer.createLayer(tArgsOfModule), "RebornSelectLayer")
	--end
end

--创建添加按钮
function createAddMenu()
	local menu = CCMenu:create()

	--格子内容初始值
	local tCellValue = {quality_bg="images/common/border.png", quality_h="images/hero/quality/highlighted.png"}
	--如果格子有内容
	if _arrSelectedHeroes and _arrSelectedHeroes.hid ~= nil then
		tCellValue.quality_bg = _arrSelectedHeroes.quality_bg
		tCellValue.quality_h = _arrSelectedHeroes.quality_h

		local heroName = CCRenderLabel:create(_arrSelectedHeroes.name, g_sFontPangWa,25,1,ccc3(0x00,0x00,0x00),type_shadow)
		heroName:setColor(HeroPublicLua.getCCColorByStarLevel(_arrSelectedHeroes.star_lv))
		heroName:setAnchorPoint(ccp(0.5,0.5))
		heroName:setScale(MainScene.elementScale)
		heroName:setPosition(ccp(_parentSize.width/2,_parentSize.height/2+62*g_fScaleY))
		_layer:addChild(heroName,0,448)
	elseif _arrSelectedItems and _arrSelectedItems.item_id ~= nil then
		local i_data = DB_Item_arm.getDataById(_arrSelectedItems.item_template_id)
		tCellValue.quality_bg = "images/base/potential/props_" .. i_data.quality .. ".png"

		local heroName = CCRenderLabel:create(_arrSelectedItems.itemDesc.name, g_sFontPangWa,25,1,ccc3(0x00,0x00,0x00),type_shadow)
		heroName:setColor(HeroPublicLua.getCCColorByStarLevel(_arrSelectedItems.itemDesc.quality))
		heroName:setAnchorPoint(ccp(0.5,0.5))
		heroName:setScale(MainScene.elementScale)
		heroName:setPosition(ccp(_parentSize.width/2,_parentSize.height/2+62*g_fScaleY))
		_layer:addChild(heroName,0,448)
	elseif _arrSelectedGoods and _arrSelectedGoods.item_id ~= nil then
		local i_data = DB_Item_treasure.getDataById(_arrSelectedGoods.item_template_id)
		tCellValue.quality_bg = "images/base/potential/props_" .. i_data.quality .. ".png"

		local heroName = CCRenderLabel:create(_arrSelectedGoods.itemDesc.name, g_sFontPangWa,25,1,ccc3(0x00,0x00,0x00),type_shadow)
		heroName:setColor(HeroPublicLua.getCCColorByStarLevel(_arrSelectedGoods.itemDesc.quality))
		heroName:setAnchorPoint(ccp(0.5,0.5))
		heroName:setScale(MainScene.elementScale)
		heroName:setPosition(ccp(_parentSize.width/2,_parentSize.height/2+62*g_fScaleY))
		_layer:addChild(heroName,0,448)
	elseif _arrSelectedCloths and _arrSelectedCloths.item_id ~= nil then
		local i_data = DB_Item_dress.getDataById(_arrSelectedCloths.item_template_id)
		tCellValue.quality_bg = "images/base/potential/props_" .. i_data.quality .. ".png"

		local fashionName
		local oldhtid = UserModel.getAvatarHtid()
		local model_id = DB_Heroes.getDataById(tonumber(oldhtid)).model_id
		local nameArray = lua_string_split(_arrSelectedCloths.itemDesc.name, ",")
		for k,v in pairs(nameArray) do
	    	local array = lua_string_split(v, "|")
	    	if(tonumber(array[1]) == tonumber(model_id)) then
				fashionName = array[2]
				break
	    	end
	    end

		local heroName = CCRenderLabel:create(fashionName, g_sFontPangWa,25,1,ccc3(0x00,0x00,0x00),type_shadow)
		heroName:setColor(HeroPublicLua.getCCColorByStarLevel(_arrSelectedCloths.itemDesc.quality))
		heroName:setAnchorPoint(ccp(0.5,0.5))
		heroName:setScale(MainScene.elementScale)
		heroName:setPosition(ccp(_parentSize.width/2,_parentSize.height/2+62*g_fScaleY))
		_layer:addChild(heroName,0,448)
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
	
	local csFrame = CCSprite:create(tCellValue.quality_h)

	csFrame:setPosition(csQualityLighted:getContentSize().width/2, csQualityLighted:getContentSize().height/2)
	csFrame:setAnchorPoint(ccp(0.5, 0.5))
	csQualityLighted:addChild(csFrame)

	local head_icon_bg = CCMenuItemSprite:create(csQuality, csQualityLighted)
	head_icon_bg:registerScriptTapHandler(fnHandlerOfSelectHero)
	table.insert(_csAddHeroeButtons, head_icon_bg)

	--头像初始值
	local head_icon = nil
	if _arrSelectedHeroes and _arrSelectedHeroes.hid ~= nil then
		require "script/model/utils/HeroUtil"
		head_icon=HeroUtil.getHeroIconByHTID(_arrSelectedHeroes.htid)
		if tonumber(_arrSelectedHeroes.evolve_level) > 0 then
			local plus = CCSprite:create("images/hero/transfer/numbers/add.png")
			plus:setAnchorPoint(ccp(1,0))
			plus:setPosition(ccp(head_icon:getContentSize().width/2,-3))
			head_icon:addChild(plus)
			local num = CCSprite:create("images/hero/transfer/numbers/" .. tonumber(_arrSelectedHeroes.evolve_level) .. ".png")
			num:setAnchorPoint(ccp(0,0))
			num:setPosition(ccp(head_icon:getContentSize().width/2,-3))
			head_icon:addChild(num)
		end
	elseif _arrSelectedItems and _arrSelectedItems.item_id ~= nil then
		local i_data = DB_Item_arm.getDataById(_arrSelectedItems.item_template_id)
		head_icon = CCSprite:create("images/base/equip/small/" .. i_data.icon_small)
	elseif _arrSelectedGoods and _arrSelectedGoods.item_id ~= nil then
		local i_data = DB_Item_treasure.getDataById(_arrSelectedGoods.item_template_id)
		head_icon = CCSprite:create("images/base/treas/small/" .. i_data.icon_small)
	elseif _arrSelectedCloths and _arrSelectedCloths.item_id ~= nil then
		local i_data = DB_Item_dress.getDataById(_arrSelectedCloths.item_template_id)
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
	head_icon_bg:setPosition(ccp(_parentSize.width/2,_parentSize.height/2+130*g_fScaleY))
	head_icon_bg:setAnchorPoint(ccp(0.5, 0.5))
	menu:addChild(head_icon_bg, 0, _ksTagSelectedHeroStart)

	head_icon_bg:setScale(MainScene.elementScale)

	menu:setPosition(ccp(0, 0))
    _layer:addChild(menu,0,444)
end

function createNeedGold()
	local labelTitle = CCRenderLabel:create(GetLocalizeStringBy("key_1642"), g_sFontName,23,2,ccc3(0x00,0x00,0x00),type_shadow)
	labelTitle:setPosition(ccp(_layer:getContentSize().width/2-40*g_fScaleX, 260*g_fScaleY))
	labelTitle:setScale(MainScene.elementScale)
	labelTitle:setAnchorPoint(ccp(1,1))
	labelTitle:setColor(ccc3(0x00,0xe4,0xff))
	_layer:addChild(labelTitle,445)

	local fullRect = CCRectMake(0, 0, 34, 32)
	local insetRect = CCRectMake(12, 12, 10, 6)
	local goldCountBG = CCScale9Sprite:create("images/common/checkbg.png", fullRect, insetRect)
	goldCountBG:setPreferredSize(CCSizeMake(180, 36))
	goldCountBG:setAnchorPoint(ccp(0,1))
	goldCountBG:setScale(MainScene.elementScale)
	goldCountBG:setPosition(ccp(_layer:getContentSize().width/2-40*g_fScaleX, 265*g_fScaleY))
	_layer:addChild(goldCountBG,446)

	local goldSprite = CCSprite:create("images/common/gold.png")
	goldSprite:setPosition(25,goldCountBG:getContentSize().height/2)
	goldSprite:setAnchorPoint(ccp(0.5,0.5))
	goldCountBG:addChild(goldSprite)

	if _arrSelectedHeroes and _arrSelectedHeroes.hid ~= nil then
		_goldNeedNumber = (_arrSelectedHeroes.evolve_level+1)*(_arrSelectedHeroes.rebirth_gold)
	elseif _arrSelectedItems and _arrSelectedItems.item_id ~= nil then
		require "db/DB_Item_arm"
		local thisItemInfo = DB_Item_arm.getDataById(_arrSelectedItems.item_template_id)
		_goldNeedNumber = thisItemInfo.resetCostGold
	elseif _arrSelectedCloths and _arrSelectedCloths.item_id ~= nil then
		require "db/DB_Item_dress"
		local thisClothInfo = DB_Item_dress.getDataById(_arrSelectedCloths.item_template_id)
		_goldNeedNumber = thisClothInfo.resetGold*(_arrSelectedCloths.va_item_text.dressLevel)
	elseif _arrSelectedGoods and _arrSelectedGoods.item_id ~= nil then
		require "db/DB_Item_treasure"
		local thisGoodInfo = DB_Item_treasure.getDataById(_arrSelectedGoods.item_template_id)
		_goldNeedNumber = thisGoodInfo.rebirthGold
	else
		_goldNeedNumber = 0
	end
	goldNum = CCRenderLabel:create(tostring(_goldNeedNumber), g_sFontName,23,2,ccc3(0x00,0x00,0x00),type_shadow)
	goldNum:setPosition(ccp(50, goldCountBG:getContentSize().height/2))
	goldNum:setAnchorPoint(ccp(0,0.5))
	goldNum:setColor(ccc3(0xff,0xff,0xff))
	goldCountBG:addChild(goldNum)
end

function fnHandlerOfNetwork(cbFlag, dictData, bRet)
	if not bRet then
		return
	end
	if cbFlag == "mysteryshop.rebornHero" then
		UserModel.addGoldNumber(tonumber(-_goldNeedNumber))
		UserModel.addSilverNumber(tonumber(dictData.ret.silver))
		UserModel.addSoulNum(tonumber(dictData.ret.soul))

		HeroModel.setHeroLevelByHid(_arrSelectedHeroes.hid,1)
		HeroModel.addEvolveLevelByHid(_arrSelectedHeroes.hid,-_arrSelectedHeroes.evolve_level)
		HeroModel.setHeroSoulByHid(_arrSelectedHeroes.hid,0)
		--武将变身那里的
		require "script/ui/rechargeActive/ActiveCache"
		ActiveCache.setUserTransfer(_arrSelectedHeroes.hid)

		require "script/ui/recycle/RecycleMain"
		RecycleMain.updateGold()
		RecycleMain.updateSilver()

		_layer:getChildByTag(444):setVisible(false)
		_layer:getChildByTag(448):setVisible(false)
		RecycleMain.createSomethingAmazing(dictData)
	end
end

function fnHandlerOfItemNetwork(cbFlag,dictData,bRet)
	if not bRet then
		return
	end
	if cbFlag == "mysteryshop.rebornItem" then
		UserModel.addGoldNumber(tonumber(-_goldNeedNumber))
		UserModel.addSilverNumber(tonumber(dictData.ret.silver))
		--UserModel.addSoulNum(tonumber(dictData.ret.soul))

		print(GetLocalizeStringBy("key_1600"),_arrSelectedItems.item_id)
		DataCache.resetArmInfoByItemID(_arrSelectedItems.item_id)

		require "script/ui/recycle/RecycleMain"
		RecycleMain.updateGold()
		RecycleMain.updateSilver()

		_layer:getChildByTag(444):setVisible(false)
		_layer:getChildByTag(448):setVisible(false)
		RecycleMain.createSomethingAmazing(dictData)
	end
end

function fnHandlerOfClothNetwork(cbFlag,dictData,bRet)
	if not bRet then
		return
	end
	if cbFlag == "mysteryshop.rebornDress" then
		UserModel.addGoldNumber(tonumber(-_goldNeedNumber))
		UserModel.addSilverNumber(tonumber(dictData.ret.silver))
		--UserModel.addSoulNum(tonumber(dictData.ret.soul))

		--print(GetLocalizeStringBy("key_1600"),_arrSelectedItems.item_id)
		DataCache.resetClothInfoByItemId(_arrSelectedCloths.item_id)

		require "script/ui/recycle/RecycleMain"
		RecycleMain.updateGold()
		RecycleMain.updateSilver()

		_layer:getChildByTag(444):setVisible(false)
		_layer:getChildByTag(448):setVisible(false)
		RecycleMain.createSomethingAmazing(dictData)
	end
end

function fnHandlerOfGoodNetwork(cbFlag,dictData,bRet)
	if not bRet then
		return
	end
	if cbFlag == "mysteryshop.rebornTreasure" then
		print("重生宝物返回")
		UserModel.addGoldNumber(tonumber(-_goldNeedNumber))
		UserModel.addSilverNumber(tonumber(dictData.ret.silver))
		DataCache.resetTreasureInfoByItemID(_arrSelectedGoods.item_id)

		require "script/ui/recycle/RecycleMain"
		RecycleMain.updateGold()
		RecycleMain.updateSilver()

		_layer:getChildByTag(444):setVisible(false)
		_layer:getChildByTag(448):setVisible(false)
		RecycleMain.createSomethingAmazing(dictData)
	end
end

function gotoResurrectAction()
	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
	resurrectButton:setEnabled(false)
	local userInfo = UserModel.getUserInfo()
	print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
	print(math.ceil(0))
	if not (_arrSelectedHeroes and _arrSelectedHeroes.hid ~= nil) and not(_arrSelectedItems and _arrSelectedItems.item_id ~= nil) and not(_arrSelectedCloths and _arrSelectedCloths.item_id ~= nil) and not(_arrSelectedGoods and _arrSelectedGoods.item_id ~= nil) then
		AnimationTip.showTip(GetLocalizeStringBy("key_1748"))
		resurrectButton:setEnabled(true)
		return
	elseif tonumber(userInfo.gold_num) < _goldNeedNumber then
		require "script/ui/tip/LackGoldTip"
		LackGoldTip.showTip()
		--AnimationTip.showTip(GetLocalizeStringBy("key_1637"))
		resurrectButton:setEnabled(true)
		return
	else

		local hero_info = HeroModel.getHeroByHid(_arrSelectedHeroes.hid)
		require "script/ui/item/ItemUtil"
		require "script/ui/hero/HeroPublicUI"
		require "script/ui/rechargeActive/ActiveCache"
		if _arrSelectedHeroes and _arrSelectedHeroes.hid ~= nil then
			if  ItemUtil.isPropBagFull(true) then
				resurrectButton:setEnabled(true)
			elseif HeroPublicUI.showHeroIsLimitedUI() then
				resurrectButton:setEnabled(true)
			elseif ItemUtil.isTreasBagFull(true) then
				resurrectButton:setEnabled(true)
			else
				print("confirmed id",HeroModel.getHeroByHid(_arrSelectedHeroes.hid)["talent"]["confirmed"]["1"])
				local subArg = CCArray:create()
				subArg:addObject(CCInteger:create(_arrSelectedHeroes.hid))
				subArg:retain()
				require "script/network/Network"

				if(hero_info["talent"]["confirmed"]["1"] ~= nil)  then
					print("炼化条件不满足")
					require "script/ui/tip/AlertTip"
					AlertTip.showAlert(GetLocalizeStringBy("lcy_10042"), function (p_bool)
						if p_bool == true then
							Network.rpc(fnHandlerOfNetwork, "mysteryshop.rebornHero","mysteryshop.rebornHero", subArg, true)
							subArg:release()
						else
							resurrectButton:setEnabled(true)
						end
					end, true)
				elseif ActiveCache.isUnhandleTransfer(hero_info.hid) then
					require "script/ui/tip/AlertTip"
					AlertTip.showAlert(GetLocalizeStringBy("zzh_1160"), function (p_bool)
						if p_bool == true then
							Network.rpc(fnHandlerOfNetwork, "mysteryshop.rebornHero","mysteryshop.rebornHero", subArg, true)
							subArg:release()
						else
							resurrectButton:setEnabled(true)
						end
					end, true)
				else
					print("开始炼化了")
					Network.rpc(fnHandlerOfNetwork, "mysteryshop.rebornHero","mysteryshop.rebornHero", subArg, true)
					subArg:release()
				end
			end

		elseif _arrSelectedCloths and _arrSelectedCloths.item_id ~= nil then
			if ItemUtil.isPropBagFull(true) then
				resurrectButton:setEnabled(true)
			else
				local subArg = CCArray:create()
				local itemArg = CCArray:create()
				itemArg:addObject(CCInteger:create(_arrSelectedCloths.item_id))
				subArg:addObject(itemArg)
				require "script/network/Network"
				Network.rpc(fnHandlerOfClothNetwork,"mysteryshop.rebornDress","mysteryshop.rebornDress",subArg,true)
			end
		elseif _arrSelectedGoods and _arrSelectedGoods.item_id ~= nil then
			if ItemUtil.isPropBagFull(true) then
				resurrectButton:setEnabled(true)
			elseif ItemUtil.isTreasBagFull(true) then
				resurrectButton:setEnabled(true)
			else
				local subArg = CCArray:create()
				local itemArg = CCArray:create()
				itemArg:addObject(CCInteger:create(_arrSelectedGoods.item_id))
				subArg:addObject(itemArg)
				require "script/network/Network"
				print("准备发送重生宝物")
				Network.rpc(fnHandlerOfGoodNetwork,"mysteryshop.rebornTreasure","mysteryshop.rebornTreasure",subArg,true)
			end
		else
			if  ItemUtil.isPropBagFull(true) then
				resurrectButton:setEnabled(true)
			else
				local subArg = CCArray:create()
				local itemArg = CCArray:create()
				itemArg:addObject(CCInteger:create(_arrSelectedItems.item_id))
				subArg:addObject(itemArg)
				require "script/network/Network"
				Network.rpc(fnHandlerOfItemNetwork,"mysteryshop.rebornItem","mysteryshop.rebornItem",subArg,true)
			end
		end
	end
end

function animateCallBack(dictData)
	--local arg = CCArray:create()
	--[[UserModel.addGoldNumber(tonumber(-_goldNeedNumber))
	UserModel.addSilverNumber(tonumber(dictData.ret.silver))
	UserModel.addSoulNum(tonumber(dictData.ret.soul))]]

	print_t(dictData.ret)

	--[[HeroModel.setHeroLevelByHid(_arrSelectedHeroes.hid,1)
	HeroModel.addEvolveLevelByHid(_arrSelectedHeroes.hid,-_arrSelectedHeroes.evolve_level)
	HeroModel.setHeroSoulByHid(_arrSelectedHeroes.hid,0)]]

	_arrSelectedHeroes.hid = nil
	_arrSelectedItems.item_id = nil
	_arrSelectedCloths.item_id = nil
	_arrSelectedGoods.item_id = nil

	local baginfo = DataCache.getRemoteBagInfo()
	print(GetLocalizeStringBy("key_2528"))
	print_t(baginfo.dress)
	
	_layer:removeChildByTag(444,true)
	_layer:removeChildByTag(445,true)
	_layer:removeChildByTag(446,true)
	_layer:removeChildByTag(448,true)
	createAddMenu()
	createNeedGold()
	
	require "script/ui/recycle/ResurrectGiftLayer"

	local showLayer = ResurrectGiftLayer.createLayer(dictData.ret)
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	runningScene:addChild(showLayer, 999)

	--[[require "script/ui/recycle/RecycleMain"
	RecycleMain.updateGold()
	RecycleMain.updateSilver()]]
	resurrectButton:setEnabled(true)
end

--重生按钮
function createResurrectBtn()
	local menuBar_g = CCMenu:create()
	menuBar_g:setPosition(ccp(0,0))
	_layer:addChild(menuBar_g)
	resurrectButton = LuaCC.create9ScaleMenuItem("images/common/btn/btn1_d.png","images/common/btn/btn1_n.png",CCSizeMake(200, 73),GetLocalizeStringBy("key_2251"),ccc3(0xfe, 0xdb, 0x1c),35,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00))
	resurrectButton:setAnchorPoint(ccp(0.5, 0.5))
    resurrectButton:setPosition(ccp(_layer:getContentSize().width*0.5, 180*g_fScaleY))
    resurrectButton:registerScriptTapHandler(gotoResurrectAction)
	menuBar_g:addChild(resurrectButton)
	resurrectButton:setScale(MainScene.elementScale)
end

function createLayer(tParam)
	init()

	if tParam ~= nil then
		if tParam.sign == "BreakDownLayer" then
			_arrSelectedHeroes = {}
			_arrSelectedItems = {}
			_arrSelectedCloths = {}
			_arrSelectedGoods = {}
		elseif tParam.nowSit == "heroList" then
			_arrSelectedHeroes = tParam.selectedHeroes
			_arrSelectedItems = {}
			_arrSelectedCloths = {}
			_arrSelectedGoods = {}
		elseif tParam.nowSit == "itemList" then
			_arrSelectedItems = tParam.selectedHeroes
			_arrSelectedHeroes = {}
			_arrSelectedCloths = {}
			_arrSelectedGoods = {}
		elseif tParam.nowSit == "clothList" then
			_arrSelectedCloths = tParam.selectedHeroes
			_arrSelectedHeroes = {}
			_arrSelectedItems = {}
			_arrSelectedGoods = {}
		elseif tParam.nowSit == "goodList" then
			_arrSelectedGoods = tParam.selectedHeroes
			_arrSelectedHeroes = {}
			_arrSelectedItems = {}
			_arrSelectedCloths = {}
		end
	end

	require "script/ui/recycle/RecycleMain"
	_parentSize = RecycleMain.getLayerSize()

	_layer = CCLayer:create()

	--创建说明文字
	--createResurrectDescribe()

	--添加需要的金币数量栏
	createNeedGold()

	--创建添加按钮
	createAddMenu()

	--添加重生按钮
	createResurrectBtn()

	return _layer
end

function createLayerAfterSelectHero(tParam)
	local tArgs = {}
	tArgs.sign = tParam.sign
	if tParam.nowSit == "heroList" then 
		tArgs.selectedHeroes = tParam.selectedHeroes
		tArgs.nowSit = "heroList"
		--NOWIN_TAG = HERO_TAG
	end
	if tParam.nowSit == "itemList" then
		tArgs.selectedHeroes = tParam.selectedHeroes
		tArgs.nowSit = "itemList"
		--NOWIN_TAG = EQUIP_TAG
	end

	if tParam.nowSit == "clothList" then
		tArgs.selectedHeroes = tParam.selectedHeroes
		tArgs.nowSit = "clothList"
	end

	if tParam.nowSit == "goodList" then
		tArgs.selectedHeroes = tParam.selectedHeroes
		tArgs.nowSit = "goodList"
	end

	require "script/ui/recycle/RecycleMain"
	local recycleLayer = RecycleMain.create(tArgs)

	return recycleLayer
end
