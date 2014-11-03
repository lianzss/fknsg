-- Filename: 	HeroUtil.lua
-- Author: 		chengliang
-- Date: 		2013-07-15
-- Purpose: 	hero工具方法


module ("HeroUtil", package.seeall)

require "script/model/hero/HeroModel"
require "script/model/DataCache"
require "script/ui/formation/LittleFriendData"
require "db/DB_Normal_config"


-- 根据hid获得英雄的相关信息 int
function getHeroInfoByHid( hid )
	local heroAllInfo = nil
	local allHeros = HeroModel.getAllHeroes()
	
	for t_hid, t_hero in pairs(allHeros) do
		
		if( tonumber(t_hid) ==  tonumber(hid)) then
			heroAllInfo = t_hero
			break
		end
	end
	require "db/DB_Heroes"
	heroAllInfo.localInfo = DB_Heroes.getDataById(tonumber(heroAllInfo.htid))
	

	return heroAllInfo
end

-- 根据htid获得英雄DB信息
function getHeroLocalInfoByHtid( htid )
	require "db/DB_Heroes"
	return DB_Heroes.getDataById(htid)
end

-- 根据htid获得hero的头像 int (dressId,gender 可不传) genderId 1男，2女
-- 通过vip 来判断是否有光圈
function getHeroIconByHTID( htid, dressId , genderId,vip)
	local heroInfo = getHeroLocalInfoByHtid(htid)
	local bgSprite = CCSprite:create("images/base/potential/officer_" .. heroInfo.potential .. ".png")
	local vip= vip or 0

	local headFile = getHeroIconImgByHTID( htid, dressId )

	local iconSprite = CCSprite:create(headFile)
	iconSprite:setAnchorPoint(ccp(0.5, 0.5))
	iconSprite:setPosition(ccp(bgSprite:getContentSize().width/2, bgSprite:getContentSize().height/2))
	bgSprite:addChild(iconSprite)

	local effectNeedVipLevel = DB_Normal_config.getDataById(1).vipEffect

	if( tonumber(vip) >= tonumber(effectNeedVipLevel) and HeroModel.isNecessaryHero(htid) ) then

	    local img_path=  CCString:create("images/base/effect/txlz/txlz")
        local openEffect=  CCLayerSprite:layerSpriteWithNameAndCount(img_path:getCString(), -1,CCString:create(""))
        openEffect:setPosition(bgSprite:getContentSize().width/2,bgSprite:getContentSize().width*0.5)
        openEffect:setAnchorPoint(ccp(0.5,0.5))
        bgSprite:addChild(openEffect,1,88888)
	end
    
	return bgSprite
end

-- 根据htid获得hero的灰色头像 int (dressId,gender 可不传) genderId 1男，2女
-- 通过vip 来判断是否有光圈
function getHeroGrayIconByHTID( htid, dressId , genderId,vip)
	local heroInfo = getHeroLocalInfoByHtid(htid)
	local bgSprite = BTGraySprite:create("images/base/potential/officer_" .. heroInfo.potential .. ".png")
	local vip= vip or 0

	local headFile = getHeroIconImgByHTID( htid, dressId )

	local iconSprite = BTGraySprite:create(headFile)
	iconSprite:setAnchorPoint(ccp(0.5, 0.5))
	iconSprite:setPosition(ccp(bgSprite:getContentSize().width/2, bgSprite:getContentSize().height/2))
	bgSprite:addChild(iconSprite)

	local effectNeedVipLevel = DB_Normal_config.getDataById(1).vipEffect

	if( tonumber(vip) >= tonumber(effectNeedVipLevel) and HeroModel.isNecessaryHero(htid) ) then

	    local img_path=  CCString:create("images/base/effect/txlz/txlz")
        local openEffect=  CCLayerSprite:layerSpriteWithNameAndCount(img_path:getCString(), -1,CCString:create(""))
        openEffect:setPosition(bgSprite:getContentSize().width/2,bgSprite:getContentSize().width*0.5)
        openEffect:setAnchorPoint(ccp(0.5,0.5))
        bgSprite:addChild(openEffect,1,88888)
	end
    
	return bgSprite
end

-- 根据htid获得hero的头像 
function getHeroIconImgByHTID( htid, dressId )
	local imgName = ""
	if(dressId and tonumber(dressId)>0)then
		-- 如果有时装
		require "db/DB_Item_dress"
		local dressInfo = DB_Item_dress.getDataById(dressId)
		
		if(dressInfo.changeHeadIcon~=nil)then
			genderId = HeroModel.getSex(htid)
			imgName =  getStringByFashionString(dressInfo.changeHeadIcon, genderId)
		else
			-- 隐藏时装
			require "db/DB_Heroes"
			local heroInfo = DB_Heroes.getDataById(htid)
			imgName =  heroInfo.head_icon_id
		end
	else
		-- 没有时装
		require "db/DB_Heroes"
		local heroInfo = DB_Heroes.getDataById(htid)
		imgName =  heroInfo.head_icon_id
	end
    
	return "images/base/hero/head_icon/" .. imgName
end

-- 英雄的全身像图片地址 (dressId,gender 可不传) genderId 1男，2女
function getHeroBodyImgByHTID( htid, dressId, genderId )
	
	local imgName = ""
	if(dressId and tonumber(dressId)>0)then
		-- 如果有时装
		require "db/DB_Item_dress"
		local dressInfo = DB_Item_dress.getDataById(dressId)
		if(dressInfo.changeBodyImg ~= nil)then
			genderId = HeroModel.getSex(htid)
			imgName =  getStringByFashionString(dressInfo.changeBodyImg, genderId)
		else
			-- 隐藏时装
			require "db/DB_Heroes"
			local heroInfo = DB_Heroes.getDataById(htid)
			imgName =  heroInfo.body_img_id
		end
	else
		-- 没有时装
		require "db/DB_Heroes"
		local heroInfo = DB_Heroes.getDataById(htid)
		imgName =  heroInfo.body_img_id
	end
    
	return "images/base/hero/body_img/" .. imgName
end

-- 英雄的全身像图片地址 (dressId,gender 可不传) genderId 1男，2女
function getHeroBodySpriteByHTID( htid, dressId, genderId )
	local iconFile =  getHeroBodyImgByHTID( htid, dressId, genderId )

	return CCSprite:create(iconFile)
end

function getHeroBodySpriteByHtid( ... )
	-- body
end


-- 分男女 解析时装的字段
function getStringByFashionString( fashion_str, genderId)
	genderId = tonumber(genderId)
	local t_fashion = splitFashionString(fashion_str)
	if(genderId == 1)then
		return t_fashion["20001"]
	else
		return t_fashion["20002"]
	end

end

-- 
function splitFashionString( fashion_str )
	local fashion_t = {}
	local f_t = string.split(fashion_str, ",")
	for k,ff_t in pairs(f_t) do
		local s_t = string.split(ff_t, "|")
		fashion_t[s_t[1]] = s_t[2]
	end

	return fashion_t
end


-- 根据htid获得hero的半身像 int
-- 金城确认无半身像，返回全身像 2013.08.14
-- k 2013.8.2
function getHeroHalfLenImageStringByHTID( htid )
	require "db/DB_Heroes"
	local heroInfo = DB_Heroes.getDataById(htid)

    
    if(heroInfo==nil)then
        print(GetLocalizeStringBy("key_2685"))
        return nil
    end
    ---[[
    if(heroInfo.body_img_id==nil)then
        print(GetLocalizeStringBy("key_2666"))
        return nil
    end
    --]]
    --暂无半身资源，使用全身资源
    --local str = "images/base/hero/body_img/" .. heroInfo.body_img_id
    local str = "images/base/hero/body_img/" .. heroInfo.body_img_id
    
	return str
end

-- 按强化等级由高到低排序
local function fnCompareWithLevel(h1, h2)
	return h1.level > h2.level
end
-- 按进阶次数排序
local function fnCompareWithEvolveLevel(h1, h2)
	if tonumber(h1.evolve_level) == tonumber(h2.evolve_level) then
		return fnCompareWithLevel(h1, h2)
	else
		return tonumber(h1.evolve_level) > tonumber(h2.evolve_level)
	end
end
-- 按星级高低排序
local function fnCompareWithStarLevel(h1, h2)
	if h1.star_lv == h2.star_lv then
		return fnCompareWithEvolveLevel(h1, h2)
	else
		return h1.star_lv > h2.star_lv
	end
end

-- 将领的排序
function heroSort( hero_1, hero_2 )
	local isPre = false
	if(hero_1.heroDesc.potential>hero_2.heroDesc.potential) then
		isPre = true
	elseif(hero_1.heroDesc.potential==hero_2.heroDesc.potential)then
		require "script/ui/hero/HeroPublicLua"
		local h1 = HeroPublicLua.getHeroDataByHid02(hero_1.hid)
		local h2 = HeroPublicLua.getHeroDataByHid02(hero_2.hid)

		-- if(hero_1.fightDict.vitalStat > hero_2.fightDict.vitalStat)then
		-- 	isPre = true
		-- end
		isPre = fnCompareWithEvolveLevel(h1, h2)
	end
	return isPre
end


-- 获得空闲的将领
function getFreeHerosInfo( )
	local freeHerosInfo = {}
	local allHeros = HeroModel.getAllHeroes()
	local formationInfos = DataCache.getFormationInfo()
	require "script/ui/formation/LittleFriendData"
	local littleFriendInfo = LittleFriendData.getLittleFriendeData()
    require "script/ui/hero/HeroFightForce"
	for t_hid, t_hero in pairs(allHeros) do
		local isFree = true
		for k,  f_hid in pairs(formationInfos) do
			if( tonumber(t_hid) ==  tonumber(f_hid)) then
				isFree = false
				break
			end
		end

		-- 小伙伴
		for k,  f_hid in pairs(littleFriendInfo) do
			if( tonumber(t_hid) ==  tonumber(f_hid)) then
				isFree = false
				break
			end
		end

		if(isFree)then
			require "db/DB_Heroes"
			t_hero.heroDesc = DB_Heroes.getDataById(t_hero.htid)
--			t_hero.fightDict = HeroFightForce.getAllForceValuesByHid(t_hero.hid)
			table.insert(freeHerosInfo, t_hero)
		end
	end
	table.sort( freeHerosInfo, heroSort )

	return freeHerosInfo
end

-- 获得武将身上的装备信息
function getEquipsOnHeros()
	local equipsOnHeros = {}
	local allHeros = HeroModel.getAllHeroes()
	for t_hid, t_hero in pairs(allHeros) do
		for equip_pos, equipInfo in pairs(t_hero.equip.arming) do
			if( not table.isEmpty(equipInfo) ) then
				equipInfo.pos = equip_pos
				equipInfo.hid = t_hid
				equipInfo.equip_hid = t_hid
				equipsOnHeros[equipInfo.item_id] = equipInfo
			end
		end
	end

	return equipsOnHeros
end

-- 获得主角身上的时装信息
function getFashionOnHeros()
	local fashionOnHeros = {}
	local allHeros = HeroModel.getAllHeroes()
	for t_hid, t_hero in pairs(allHeros) do
		for fashion_pos, fashionInfo in pairs(t_hero.equip.dress) do
			if( not table.isEmpty(fashionInfo) ) then
				fashionInfo.pos = fashion_pos
				fashionInfo.hid = t_hid
				fashionInfo.fashion_hid = t_hid
				fashionOnHeros[fashionInfo.item_id] = fashionInfo
			end
		end
	end
	return fashionOnHeros
end

-- 获得某个武将身上的装备
function getEquipsByHid( hid )
	local allHeros = HeroModel.getAllHeroes()
	for t_hid, t_hero in pairs(allHeros) do
		if(tonumber(t_hid) == tonumber(hid))then
			return t_hero.equip.arming
		end
	end
	return nil
end

-- add by chengliang
-- 获得武将身上的所有宝物 
function getTreasOnHeros()
	local treasOnHeros = {}
	local allHeros = HeroModel.getAllHeroes()
	for t_hid, t_hero in pairs(allHeros) do
		for treas_pos, treasInfo in pairs(t_hero.equip.treasure) do
			if( not table.isEmpty(treasInfo) ) then
				treasInfo.pos = treas_pos
				treasInfo.hid = t_hid
				treasInfo.equip_hid = t_hid
				treasOnHeros[treasInfo.item_id] = treasInfo
			end
		end
	end
	return treasOnHeros
end

-- add by chengliang
-- 获得某个武将身上的宝物
function getTreasByHid( hid )
	local allHeros = HeroModel.getAllHeroes()
	for t_hid, t_hero in pairs(allHeros) do
		if(tonumber(t_hid) == tonumber(hid))then
			return t_hero.equip.treasure
		end
	end
	return nil
end

-- 获得所有武将身上的战魂
function getAllFightSoulOnHeros()
	local allFightSoul = {}

	local formation = DataCache.getFormationInfo()
	for f_pos, f_hid in pairs(formation) do
		if( tonumber(f_hid)>0 )then
			local tempFightSoul = getFightSoulByHid( f_hid )
			if(not table.isEmpty(tempFightSoul))then
				for k,v in pairs(tempFightSoul) do
					allFightSoul[k] = v
					allFightSoul[k].itemDesc = ItemUtil.getItemById(v.item_template_id)
				end
			end
		end
	end
	return allFightSoul
end

-- 获得某个武将身上的战魂 
function getFightSoulByHid( hid )
	local fightSoulTemp = {}
	local allHeros = HeroModel.getAllHeroes()
	if( (not table.isEmpty(allHeros["" .. hid].equip)) and   (not table.isEmpty(allHeros["" .. hid].equip.fightSoul)) )then
		local fightSoulTemp_t = allHeros["" .. hid].equip.fightSoul
		for t_pos, t_fightSoul in pairs(fightSoulTemp_t) do
			t_fightSoul.hid = hid
			t_fightSoul.equip_hid = hid
			t_fightSoul.pos = t_pos
			fightSoulTemp[t_fightSoul.item_id] = t_fightSoul
		end
	end
	return fightSoulTemp
end

-- 计算某个htid的武将有多少个
function getHeroNumByHtid( h_tid )
	h_tid = tonumber(h_tid)
	local allHeros = HeroModel.getAllHeroes()
	local number = 0

	for k,v in pairs(allHeros) do
		if(tonumber(v.htid) == h_tid)then
			number = number + 1
		end
	end

	return number
end

--[[
    @des: 得到武将列表里所有与传入的htid相同的武将
--]]
function getHerosByHtid(htid)
	local allHeros = HeroModel.getAllHeroes()
	local heros = {}
	for hid, hero in pairs(allHeros) do
		if hero.htid == htid then
			table.insert(heros, hero)
		end
	end
	return heros
end

--[[
    @des: 对应的武将有没有可激活的觉醒能力
    @htid: 武将的htid
    @heroCopyId: 武将列传的ID 1简单 2普通 3困难
--]]
function couldActivateTalent(htid, heroCopyId)
    local allHeros = HeroModel.getAllHeroes()
    local heros = getHerosByHtid(htid)
    local heroDb = parseDB(DB_Heroes.getDataById(tonumber(htid)))
    for i = 1, #heros do
        local hero = heros[i]
        for talentIndex = 1, 2 do
            local sealedTalentId = hero.talent ~= nil and (hero.talent.sealed ~= nil and hero.talent.sealed[ tostring(talentIndex)] or nil) or nil
            print(sealedTalentId)
            print_t(heroDb)
            print_t(heroDb.hero_copy_id[heroCopyId])
            print(heroDb.hero_copy_id[heroCopyId][3])
            if sealedTalentId ~= nil and sealedTalentId ~= "0" and tonumber(hero.evolve_level) >= heroDb.hero_copy_id[heroCopyId][3] then
                return true
            end
        end
    end
    return false
end