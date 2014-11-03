-- Filename: HeroModel.lua.
-- Author: fang.
-- Date: 2013-07-09
-- Purpose: 武将数据

module("HeroModel", package.seeall)



-- 所有英雄数据
local _allHeroes

local newHeroTable 	= nil
bHaveNewHero = nil

-- 获得所有武将信息
function getAllHeroes()
	return _allHeroes
end
-- 设置所有武将信息
function setAllHeroes(heroes)
	_allHeroes = heroes

    -- 战斗力
    local heroIDs = getAllHeroesHid()
    local fight_value = 0

    -- 已上阵武将信息
    require "script/model/DataCache"
    local formationInfo = DataCache.getFormationInfo()
 
    require "script/ui/hero/HeroFightForce"
    for i=1, #heroIDs do
        -- 从阵容信息中获取该武将是否已上阵武将
        local isBusy = false
        if formationInfo then
            for k, v in pairs(formationInfo) do
                if (tostring(v) == heroIDs[i]) then
                    isBusy = true
                    break
                end
            end
        end
        if isBusy then
            local hero_fight = HeroFightForce.getAllForceValuesByHid(heroIDs[i]).fightForce
            fight_value = fight_value + hero_fight
        end
    end

	require "script/model/user/UserModel"
    UserModel.setFightForceValue(fight_value)
end
-- 通过hid获得英雄属性
function getHeroByHid(hid)
	return _allHeroes[tostring(hid)]
end
-- 获取所有英雄hids
function getAllHeroesHid()
	local hids = {}
	if _allHeroes == nil then
		return hids
	end
	for k, v in pairs(_allHeroes) do
		hids[#hids+1] = v.hid
	end

	return hids
end
-- 获得当前武将数量
function getHeroNumber()
	return table.count(_allHeroes)
end

-- 通过国家ID获取国家相应等级图标
-- cid -> 所属国家id
-- star_lv -> 星级
function getCiconByCidAndlevel(cid, star_lv)
	local countries = {"wei", "shu", "wu", "qun"}
	if (countries[cid] == nil) then
--		CCLuaLog (string.format("Error: no such country with %d %s", cid, "cid."))
		return "images/common/transparent.png"
	end
	return "images/hero/" .. countries[cid] .. "/" .. countries[cid] .. star_lv .. ".png"
end

-- 通过国家ID获取国家相应等级大图标（是大图标）
-- cid -> 所属国家id
-- star_lv -> 星级
function getLargeCiconByCidAndlevel(cid, star_lv)
	local countries = {"wei", "shu", "wu", "qun"}
	if (countries[cid] == nil) then
--		CCLuaLog (string.format("Error: no such country with %d %s", cid, "cid."))
		return "images/common/transparent.png"
	end
	local quality = star_lv

	return "images/common/hero_show/country/"..countries[cid].."/"..countries[cid]..quality..".png"
end

-- 删除某个英雄
-- hid -> 被删除的英雄hid
function deleteHeroByHid(hid)
	_allHeroes[tostring(hid)] = nil
end
-- 添加英雄
-- hid -> 被添加的英雄hid
function addHeroWithHid(hid, h_data)
	_allHeroes[tostring(hid)] = h_data

	--add by lichenyang
	haveNewHero(hid, h_data)
end
-- 根据英雄htid获得头像
function getHeroHeadIconByHtid(htid)
	require "db/DB_Heroes"
	local data = DB_Heroes.getDataById(htid)
	return "images/base/hero/head_icon/"..data.head_icon_id
end

-- 根据英雄htid判断是否为主角
function isNecessaryHero(htid)

	require "db/DB_Heroes"
	local data = DB_Heroes.getDataById(htid)

	return data.model_id == 20001 or data.model_id == 20002
end
-- 通过英雄hid判断是否为主角
function isNecessaryHeroByHid(pHid)
	local htid = _allHeroes[tostring(pHid)].htid
	
	return isNecessaryHero(htid)
end

-- 获取武将性别
-- return, 1男，2女
function getSex(htid)
	require "db/DB_Heroes"
	local model_id = DB_Heroes.getDataById(htid).model_id
	if model_id == 20001 then
		return 1
	elseif model_id == 20002 then
		return 2
	end
	return -1
end

--[[
	@des : 得到武将原型id
--]]
function getHeroModelId(htid  )
	require "db/DB_Heroes"
	local model_id = DB_Heroes.getDataById(htid).model_id
	return model_id
end

-- 获取主角的武将信息方法
function getNecessaryHero( ... )
	if _allHeroes == nil then
		return
	end
	for k, v in pairs(_allHeroes) do
		local db_hero = DB_Heroes.getDataById(v.htid)
		if db_hero.model_id == 20001 or db_hero.model_id == 20002 then
			return v
		end
	end
end
-- 设置主角武将的htid
function setNecessaryHeroHtid(pHtid)
	if _allHeroes == nil then
		return
	end
	for k, v in pairs(_allHeroes) do
		local db_hero = DB_Heroes.getDataById(v.htid)
		if db_hero.model_id == 20001 or db_hero.model_id == 20002 then
			_allHeroes[k].htid = pHtid
			return v
		end
	end
end


-- 通过htid获得所有htid相同的当前武将列表
function getAllByHtid(tParam)
	local tArrHeroes = {}
	for k, v in pairs(_allHeroes) do
		if tonumber(v.htid) == tParam.htid then
			table.insert(tArrHeroes, v)
		end
	end
	return tArrHeroes
end

-- 通过武将hid修改武将的进阶等级
function setHeroEvolveLevelByHid( pHid, pLevel )
	_allHeroes[tostring(pHid)].evolve_level = pLevel
end

-- 通过武将hid修改武将等级
function setHeroLevelByHid( pHid, pLevel )
	_allHeroes[tostring(pHid)].level = pLevel
end

-- 
function setMainHeroLevel(pLevel)
	for k, v in pairs(_allHeroes) do
		local htid = tonumber(v.htid)
		if isNecessaryHero(htid) then
			_allHeroes[k].level=pLevel
			break
		end
	end
end

-- add by chengliang
-- 修改hero身上装备的强化等级
function changeHeroEquipReinforceBy( hid, item_id, addLv )
	for pos, arm_info in pairs(_allHeroes[tostring(hid)].equip.arming) do
	 	if(tonumber( arm_info.item_id ) == item_id) then
	 		local level = tonumber(arm_info.va_item_text.armReinforceLevel) + addLv
	 		_allHeroes[tostring(hid)].equip.arming[pos]["va_item_text"]["armReinforceLevel"] = tostring(level)
	 		break
	 	end
	 end 
end

-- 通过hid设置武将上锁的状态
-- 如果武将没有锁定  此字段没有  如果锁定 值为1
function setHeroLockStatusByHid(hid, status )
	for k, v in pairs(_allHeroes) do
	
		if tonumber(hid)== tonumber(v.hid) then
			_allHeroes[tostring(k)].lock= status
			break
		end
	end
end


-- 通过hid设置武将身上的5星(紫色)装备上锁的状态  add by licong
-- 如果装备没有锁定  lock字段没有  如果锁定 lock值为1
-- p_hid 英雄hid, p_item_id 装备item_id, p_status 状态 1是锁定，0是解锁lock字段赋值nil
function setHeroEquipLockStatusByHid(p_hid, p_item_id, p_status )
	for k, v in pairs(_allHeroes) do
		for pos, arm_info in pairs(_allHeroes[tostring(p_hid)].equip.arming) do
		 	if(tonumber( arm_info.item_id ) == tonumber(p_item_id)) then
		 		if(tonumber(p_status) == 1)then
		 			-- 加锁 1
		 			_allHeroes[tostring(p_hid)].equip.arming[pos]["va_item_text"]["lock"] = tonumber(p_status)
		 		else
		 			-- 解锁 0
		 			_allHeroes[tostring(p_hid)].equip.arming[pos]["va_item_text"]["lock"] = nil
		 		end
		 		break
		 	end
		 end 
	end
end

-- add by chengliang
-- 设置hero身上装备的强化等级
function setHeroEquipReinforceLevelBy( hid, item_id, curLv )
	for pos, arm_info in pairs(_allHeroes[tostring(hid)].equip.arming) do
	 	if(tonumber( arm_info.item_id ) == item_id) then
	 		_allHeroes[tostring(hid)].equip.arming[pos]["va_item_text"]["armReinforceLevel"] = tostring(curLv)
	 		break
	 	end
	 end 
end

-- add by chengliang
-- 设置hero身上装备的强化费用
function setHeroEquipReinforceLevelCostBy( hid, item_id, curCost )
	for pos, arm_info in pairs(_allHeroes[tostring(hid)].equip.arming) do
	 	if(tonumber( arm_info.item_id ) == item_id) then
	 		_allHeroes[tostring(hid)].equip.arming[pos]["va_item_text"]["armReinforceCost"] = tostring(curCost)
	 		break
	 	end
	 end 
end

-- add by chengliang
-- 修改hero身上装备的强化等级
function changeHeroEquipReinforceCostBy( hid, item_id, addCost )
	for pos, arm_info in pairs(_allHeroes[tostring(hid)].equip.arming) do
	 	if(tonumber( arm_info.item_id ) == item_id) then
	 		if(_allHeroes[tostring(hid)].equip.arming[pos]["va_item_text"]["armReinforceCost"])then
	 			_allHeroes[tostring(hid)].equip.arming[pos]["va_item_text"]["armReinforceCost"] = tostring(tonumber(arm_info.va_item_text.armReinforceLevel) + tonumber(addCost))
	 		else
		 		_allHeroes[tostring(hid)].equip.arming[pos]["va_item_text"]["armReinforceCost"] = tostring(addCost)
		 	end

	 		break
	 	end
	 end 
end

-- add by chengliang
-- 卸下武将身上的装备
function removeEquipFromHeroBy( hid, r_pos)
	for pos, arm_info in pairs(_allHeroes[tostring(hid)].equip.arming) do
	 	if(tonumber( pos ) == tonumber(r_pos)) then
	 		_allHeroes[tostring(hid)].equip.arming[pos] = "0"
	 		break
	 	end
	end 
end
-- 检查武将(hid)是否装备了某个装备id(item_template_id)
function checkEquipStatus(pHid, pItid)
	local tArming = _allHeroes[tostring(pHid)].equip.arming
	for k, v in pairs(tArming) do
		if type(v) == "table" then
			if tonumber(v.item_template_id) == tonumber(pItid) then
				return true
			end
		end
	end

	return false
end

-- 检查武将(hid)是否装备了某个宝物(item_template_id)
function checkTreasureStatus(pHid, pItid)
	local tArming = _allHeroes[tostring(pHid)].equip.treasure
	for k, v in pairs(tArming) do
		if type(v) == "table" then
			if tonumber(v.item_template_id) == tonumber(pItid) then
				return true
			end
		end
	end

	return false
end

-- add by chengliang
-- 卸下武将身上的宝物
function removeTreasFromHeroBy( hid, r_pos)
	for pos, arm_info in pairs(_allHeroes[tostring(hid)].equip.treasure) do
	 	if(tonumber( pos ) == tonumber(r_pos)) then
	 		_allHeroes[tostring(hid)].equip.treasure[pos] = "0"
	 		break
	 	end
	 end 
end

-- 为指定hid的武将设置武魂数
function setHeroSoulByHid(pHid, pSoul)
	_allHeroes[tostring(pHid)].soul = pSoul
end

-- 通过武将hid增加进阶等级
function addEvolveLevelByHid(pHid, pAddedLevel)
	_allHeroes[tostring(pHid)].evolve_level = tonumber(_allHeroes[tostring(pHid)].evolve_level) + pAddedLevel
end

-- 通过武将hid修改其htid
function setHtidByHid(pHid, pHtid)
	_allHeroes[tostring(pHid)].htid = pHtid
end

-- 判断当前武将数量是否已达上限
-- out: true表示武将数量已达上限，false表示未达上限
function isLimitedCount()
	local nCount = table.count(_allHeroes)
	if nCount >= UserModel.getHeroLimit() then
		return true
	end

	return false
end

-- 交换两个武将的装备信息  -- 程亮
function exchangeEquipInfo( f_hid, s_hid )
	if(f_hid == nil or s_hid == nil) then
		return
	end
	f_hid = tonumber(f_hid)
	s_hid = tonumber(s_hid)
	
	local f_equipInfo = _allHeroes["" .. f_hid].equip
	_allHeroes["" .. f_hid].equip = _allHeroes["" .. s_hid].equip
	_allHeroes["" .. s_hid].equip = f_equipInfo
end

-- 获得当前所有武将的国家分类数量
-- return. tHeroNumByCountry = {wei=18, shu=56, wu=98, qun=99}
function getHeroNumByCountry( ... )
	require "db/DB_Heroes"
	local nWei=0
	local nShu=0
	local nWu=0
	local nQun=0
	if _allHeroes then
		for k, v in pairs(_allHeroes) do
			local db_hero = DB_Heroes.getDataById(v.htid)
			local countryId = db_hero.country
			if countryId == 1 then
				nWei = nWei + 1
			elseif countryId == 2 then
				nShu = nShu + 1
			elseif countryId == 3 then
				nWu = nWu + 1
			else
				nQun = nQun + 1
			end
		end
	end
	local tHeroNumByCountry = {}
	tHeroNumByCountry.wei = nWei
	tHeroNumByCountry.shu = nShu
	tHeroNumByCountry.wu = nWu
	tHeroNumByCountry.qun = nQun

	return tHeroNumByCountry
end

-- 通过武将的htid和进阶次数计算出该武将的等级上限
-- params: pHtid: 武将的htid, pEvolveLevel: 该武将的进阶等级
-- return: 武将等级上限
function getHeroLimitLevel(pHtid, pEvolveLevel)
	local nLimitLevel = 0
	local nEvolveLevel = pEvolveLevel or 0
	local db_hero = DB_Heroes.getDataById(pHtid)
	if db_hero then
		nLimitLevel = db_hero.strength_limit_lv + tonumber(nEvolveLevel)*db_hero.strength_interval_lv
	end

	return nLimitLevel
end

-- 修改武将身上的装备等级
function addArmLevelOnHerosBy( hid, pos, addLv )
	local enhanceLv = tonumber(_allHeroes["" .. hid].equip.arming["" .. pos].va_item_text.armReinforceLevel) + tonumber(addLv)
	_allHeroes["" .. hid].equip.arming["" .. pos].va_item_text.armReinforceLevel = enhanceLv
end

-- 修改武将身上的宝物等级
function addTreasLevelOnHerosBy( hid, pos, addLv, totalExp )
	local enhanceLv = tonumber(_allHeroes["" .. hid].equip.treasure["" .. pos].va_item_text.treasureLevel) + tonumber(addLv)
	_allHeroes["" .. hid].equip.treasure["" .. pos].va_item_text.treasureLevel = enhanceLv
	_allHeroes["" .. hid].equip.treasure["" .. pos].va_item_text.treasureExp = totalExp
end

-- 修改武将身上的战魂等级
function addFSLevelOnHerosBy( hid, pos, cruLv, totalExp )
	_allHeroes["" .. hid].equip.fightSoul["" .. pos].va_item_text.fsLevel = cruLv
	_allHeroes["" .. hid].equip.fightSoul["" .. pos].va_item_text.fsExp = totalExp
end

-- 修改武将身上的时装等级
function addFashionLevelOnHerosBy( hid, pos, cruLv )
	_allHeroes["" .. hid].equip.dress["" .. pos].va_item_text.dressLevel = cruLv
end

-- 通过item_template_id获取武魂当前数量和需要的数量
-- return. {item_num=物品实际数量, need_num=物品需要的数量}
function getNumByItemTemplateId(pItemTemplateId)
	local tRetValue = {item_num=0, need_num=0}

	local tHeroFrag = DataCache.getHeroFragFromBag()
	if not tHeroFrag then
		return tRetValue
	end

	for k,v in pairs(tHeroFrag) do
		if tonumber(v.item_template_id) == tonumber(pItemTemplateId) then
			tRetValue.item_num = tonumber(v.item_num)
			break
		end
	end
	if tRetValue.item_num > 0 then
		require "db/DB_Item_hero_fragment"
		local heroFragment = DB_Item_hero_fragment.getDataById(pItemTemplateId)
		tRetValue.need_num = heroFragment.need_part_num
	end

	return tRetValue
end


function setHeroFixedPotentiality( item_id ,potentiality_info )
	for k,v in pairs(_allHeroes) do
		for kh,vh in pairs(v.equip.arming) do
			if(tonumber(vh) ~= 0) then
				if(tonumber(vh.item_id) == tonumber(item_id)) then
					_allHeroes[tostring(k)].equip.arming[tostring(kh)].va_item_text.armFixedPotence = potentiality_info
					print(GetLocalizeStringBy("key_3082"))
					break
				end
			end
		end
	end
end

function setHeroPotentiality( item_id)
	print("setHeroPotentiality = ", item_id)
	print_t(potentiality_info)
	print(GetLocalizeStringBy("key_1794"))
	for k,v in pairs(_allHeroes) do
		for kh,vh in pairs(v.equip.arming) do
			if(tonumber(vh)  ~= 0) then
				if(tonumber(vh.item_id) == tonumber(item_id)) then
					_allHeroes[tostring(k)].equip.arming[tostring(kh)].va_item_text.armPotence = vh.va_item_text.armFixedPotence
					_allHeroes[tostring(k)].equip.arming[tostring(kh)].va_item_text.armFixedPotence = nil
					print(GetLocalizeStringBy("key_3082"))
					break
				end
			end
		end
	end
	print(GetLocalizeStringBy("key_1180"))
	print_t(_allHeroes)
end

--[[
	@设置宝物精炼等级
--]]
function setTreasureEvolveLevel( item_id, evolve_level )
	for k,v in pairs(_allHeroes) do
		for kh,vh in pairs(v.equip.treasure) do
			if(tonumber(vh)  ~= 0) then
				if(tonumber(vh.item_id) == tonumber(item_id)) then
					_allHeroes[tostring(k)].equip.treasure[tostring(kh)].va_item_text.treasureEvolve = evolve_level
					break
				end
			end
		end
	end
end

--[[
	@des 	:	记忆新获得武将
	@params	:	hid 武将id
	@return :	
--]]
function haveNewHero( hid, hero_info )

	print("hero_info")
	print_t(hero_info)

	require "db/DB_Heroes"
	local heroStraLv = DB_Heroes.getDataById(hero_info.htid).star_lv
	if(tonumber(heroStraLv) < 4) then
		return
	end

	if(newHeroTable == nil) then
		--从本地读取
		local newHeroBuffer = CCUserDefault:sharedUserDefault():getStringForKey("hava_new_hero_table")
		if(newHeroBuffer == nil or newHeroBuffer == "") then
			newHeroTable 				= {}
		else
			newHeroTable 		= table.unserialize(newHeroBuffer)
		end	
	end
	newHeroTable[tostring(hid)] = true
	local serializeBuffer 		= table.serialize(newHeroTable)
	CCUserDefault:sharedUserDefault():setStringForKey("hava_new_hero_table", serializeBuffer)
	CCUserDefault:sharedUserDefault():flush()

	--主界面武将按钮new 特效
	require "script/ui/main/MainBaseLayer"
	MainBaseLayer.addNewHeroButton()
	bHaveNewHero = true
	print("new hero is ======== ", hid)
	print("newHeroTable =:")
	print_t(newHeroTable)
end

--[[
	@des 	:	删除持久化的新英雄
	@params	:	hid 武将id
--]]
function removeHavaNewHero( hid )
	if(newHeroTable == nil) then
		return
	end
	newHeroTable[tostring(hid)] = nil
	local serializeBuffer 		= table.serialize(newHeroTable)
	CCUserDefault:sharedUserDefault():setStringForKey("hava_new_hero_table", serializeBuffer)
	CCUserDefault:sharedUserDefault():flush()
end

--[[
	@des 	:	清楚所有标志为新的英雄
]]
function clearAllNewHeroSign()
	newHeroTable = nil
	CCUserDefault:sharedUserDefault():setStringForKey("hava_new_hero_table", "")
	CCUserDefault:sharedUserDefault():flush()
end


--[[
	@des 	:	判断武将是否是新武将
	@params	:	hid 武将id	
--]]
function isNewHero( hid )
	if(newHeroTable == nil) then
		return false
	end

	if(newHeroTable[tostring(hid)] == true) then
		return true
	else
		return false
	end
end


--[[
	@des 	:	是否拥有新武将
]]
function isHaveNewHero()
	if(newHeroTable ~= nil) then
		return true
	else
		return false
	end
end

--[[
	@des 	: 初始化缓存数据
--]]
function initNewHero( ... )
 	if(newHeroTable == nil) then
		--从本地读取
		local newHeroBuffer = CCUserDefault:sharedUserDefault():getStringForKey("hava_new_hero_table")
		print("newHeroBuffer = ", newHeroBuffer)
		if(newHeroBuffer == nil or newHeroBuffer == "") then
			newHeroTable 				= nil
		else
			newHeroTable 		= table.unserialize(newHeroBuffer)
		end	
	end
	if(isHaveNewHero()) then
		bHaveNewHero = true
	else
		bHaveNewHero = false
	end
end

--[[
	@des 	:得到英雄的觉醒属性
	@parm 	:hid
	@ret  	:属性table
--]]
function getHeroAwakenAffix(p_hid)
	local affixTable = {}
	local heroInfo = getHeroByHid(tostring(p_hid))
	if(heroInfo["talent"] ~= nil and heroInfo["talent"]["confirmed"] ~= nil) then
		for key,value in pairs(heroInfo["talent"]["confirmed"]) do
			local isSealed = false
			if(heroInfo["talent"]["sealed"] ~= nil and heroInfo["talent"]["sealed"][key] ~= nil and heroInfo["talent"]["sealed"][key] ~= 0) then
				isSealed = true
			end
			if(isSealed == false) then
				require "db/DB_Hero_refreshgift"
				local talentInfo = DB_Hero_refreshgift.getDataById(value)
				if(talentInfo ~= nil) then
					local attri_ids  = string.split(talentInfo.attri_ids, "|")
					if(table.count(attri_ids) >=2) then
						local affixId    = attri_ids[1]
						local affixValue = attri_ids[2]
						if(affixTable[affixId] == nil) then
							affixTable[affixId] = tonumber(affixValue)
						else
							affixTable[affixId] = affixTable[affixId] + tonumber(affixValue)
						end
					end
				end
			end
		end
	end
	return affixTable
end

--[[
	@des :得到英雄的战魂属性
	@parm:英雄hid
	@ret :属性tab
--]]
function getHeroFightSoulAffix( p_hid )
	if(p_hid == nil)then
		return {}
	end
	print("p_hid",p_hid)
	require "script/ui/huntSoul/HuntSoulData"
	local affixs      = {}
	local heroInfo = getHeroByHid(tostring(p_hid))
	if(heroInfo.equip.fightSoul == nil) then
		return affixs
	end

	for k,v in pairs(heroInfo.equip.fightSoul) do
		local affixInfo = HuntSoulData.getFightSoulAttrByItem_id(v.item_id)
		for key,value in pairs(affixInfo) do
			if(affixs[key] == nil) then
				affixs[key] = {}
			end
			affixs[key].desc = value.desc.displayName
			if(affixs[key].realNum == nil) then
				affixs[key].realNum = tonumber(value.realNum)
			else
				affixs[key].realNum = tonumber(value.realNum) + tonumber(ffixs[key].realNum)
			end
			if(affixs[key].displayNum == nil) then
				local tempAffix = nil
				tempAffix, affixs[key].displayNum = ItemUtil.getAtrrNameAndNum(key, value.realNum)
			else
				local tempAffix = nil
				tempAffix, affixs[key].displayNum =  ItemUtil.getAtrrNameAndNum(key, value.realNum) --tonumber(affixs[key].displayNum) + value.displayNum
			end
		end
	end
	printTable("getHeroFightSoulAffix:" .. p_hid, affixs)
	return affixs
end

--[[
	@des  :计算武将本身属性
	@parm :p_hid
	@ret  :属性tab
--]]
function getHeroAffix( p_hid )
	require "db/DB_Heroes"
	require "script/model/hero/HeroModel"
	require "script/model/hero/AffixConfig"

	local heroInfo 	  = getHeroByHid(tostring(p_hid))
	local heroDBInfo  = DB_Heroes.getDataById(heroInfo.htid)

	--@param p_affixNum 属性基础值
	--@param p_affixGrow 属性成长值
	local calculateAffix = function ( p_affixNum, p_affixGrow )
		--属性值总和 =基础值 + 基础值*(1+进阶基础值系数/10000*进阶次数) + int(进阶次数/200*成长值)*( 进阶初始等级*2+进阶间隔等级*(进阶次数-1) ) + (武将等级-1)*属性成长值
		--基础值 + 基础值*(1+进阶基础值系数/10000*进阶次数)

		local retAffix = p_affixNum + p_affixNum*(1 + tonumber(heroDBInfo.advanced_base_coefficient)/1000*tonumber(heroInfo.evolve_level)) 
		--int(进阶次数/200*成长值)*( 进阶初始等级*2+进阶间隔等级*(进阶次数-1) ) 
		retAffix = retAffix + math.floor((tonumber(heroInfo.evolve_level)/200*p_affixGrow)*(tonumber(heroDBInfo.advanced_begin_lv)*2+tonumber(heroDBInfo.advanced_interval_lv)*(tonumber(heroInfo.evolve_level-1))))
		retAffix = retAffix + (tonumber(heroInfo.level) - 1)*p_affixGrow
		return retAffix
	end

	local affix = {}
	-- base_hp				武将基础生命
	affix[AffixConfig.getAffixIdByDesString("base_hp")] = calculateAffix(tonumber(heroDBInfo.base_hp), tonumber(heroDBInfo.hp_grow))
	-- base_command			武将基础统帅
	affix[AffixConfig.getAffixIdByDesString("base_command")] = tonumber(heroDBInfo.base_command)
	-- base_strength		武将基础武力
	affix[AffixConfig.getAffixIdByDesString("base_strength")] = tonumber(heroDBInfo.base_strength)
	-- base_intelligence	武将基础智力
	affix[AffixConfig.getAffixIdByDesString("base_intelligence")] = tonumber(heroDBInfo.base_intelligence)
	-- base_general_attack	武将基础通用攻击
	affix[AffixConfig.getAffixIdByDesString("base_general_attack")] = calculateAffix(tonumber(heroDBInfo.base_general_attack), tonumber(heroDBInfo.general_attack_grow))
	-- base_physical_attack	武将基础物理攻击
	affix[AffixConfig.getAffixIdByDesString("base_physical_attack")] = calculateAffix(tonumber(heroDBInfo.base_physical_attack), tonumber(heroDBInfo.physical_attack_grow))
	-- base_magic_attack	武将基础法术攻击
	affix[AffixConfig.getAffixIdByDesString("base_magic_attack")] = calculateAffix(tonumber(heroDBInfo.base_magic_attack), tonumber(heroDBInfo.magic_attack_grow))
	-- base_physical_defend	武将基础物理防御
	affix[AffixConfig.getAffixIdByDesString("base_physical_defend")] = calculateAffix(tonumber(heroDBInfo.base_physical_defend), tonumber(heroDBInfo.physical_defend_grow))
	-- base_magic_defend	武将基础法术防御
	affix[AffixConfig.getAffixIdByDesString("base_magic_defend")] = calculateAffix(tonumber(heroDBInfo.base_magic_defend), tonumber(heroDBInfo.magic_defend_grow))
	-- base_damage			武将基础最终伤害
	affix[AffixConfig.getAffixIdByDesString("base_damage")] = tonumber(heroDBInfo.base_damage)
	-- base_ignore_damage	武将基础最终免伤
	affix[AffixConfig.getAffixIdByDesString("base_ignore_damage")] = tonumber(heroDBInfo.base_ignore_damage)

	return affix	
end

--[[
	@des  :计算单个装备属性
	@parm :p_hid
	@ret  :属性tab
--]]

function getEquipAffix( p_itemId )
	-- body
end


--[[
	@des:得到武将战魂属性
--]]
function getShowHeroFightSoulAffix( p_hid )
	local retTable = {}
	require "db/DB_Normal_config"
	require "db/DB_Affix"
	local heroDetailAffixIds = string.split(DB_Normal_config.getDataById(1).heroDetailedAffix, ",")
	local fightSoulInfo = getHeroFightSoulAffix(p_hid)
	for i,v in ipairs(heroDetailAffixIds) do
		local affix = {}
		local fightSoulAffix = fightSoulInfo[tostring(v)]
		if(fightSoulAffix == nil) then
			affix.name = DB_Affix.getDataById(v).displayName
			affix.value = 0
		else
			affix.name = fightSoulAffix.desc
			affix.value = fightSoulAffix.displayNum
		end
		-- printTable("fightSoulInfo[" ..  i  .."][" .. v .. "]", fightSoulInfo[v])
		table.insert(retTable, affix)
	end
	return retTable
end

