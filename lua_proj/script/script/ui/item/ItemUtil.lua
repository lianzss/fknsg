-- Filename：	ItemUtil.lua
-- Author：		Cheng Liang
-- Date：		2013-7-10
-- Purpose：		物品Item

module("ItemUtil", package.seeall)


require "script/utils/LuaUtil"
require "script/model/user/UserModel"
require "script/model/hero/HeroModel"
require "script/ui/hero/HeroPublicLua"
require "db/DB_City"
require "script/ui/guild/GuildDataCache"
local _forwardDelegate = nil
local _isBigMap		   = false
local BG_PATH		   = "images/common/"

-- 使用某个物品所获得的物品 i_id/i_num/isModifyCache <=> 物品templateid/个数/是否修改缓存
function getUseResultBy( i_id, i_num , isModifyCache)

	if(isModifyCache == nil) then
		isModifyCache = false
	end


	local useResult = nil
	local result = {}
	local result_text = ""
	require "db/DB_Item_direct"
	local i_data = DB_Item_direct.getDataById(i_id)


	if(i_data.coins and i_data.coins > 0) then
		result.coins = i_data.coins * i_num
		result_text = result_text  .. result.coins .. GetLocalizeStringBy("key_2894")
	end
	if(i_data.golds and i_data.golds > 0) then
		result.golds = i_data.golds * i_num
		result_text = result_text  .. result.golds .. GetLocalizeStringBy("key_1447")
	end
	if(i_data.energy and i_data.energy > 0) then
		result.energy = i_data.energy * i_num
		result_text = result_text  .. result.energy .. GetLocalizeStringBy("key_3238")
	end
	if(i_data.general_soul and i_data.general_soul > 0) then
		result.general_soul = i_data.general_soul * i_num
		result_text = result_text  .. result.general_soul .. GetLocalizeStringBy("key_1598")
	end
	if(i_data.endurance and i_data.endurance > 0) then
		result.endurance = i_data.endurance * i_num
		result_text = result_text  .. result.endurance .. GetLocalizeStringBy("key_2991")
	end
	-- if(i_data.award_item_id and i_data.award_item_id > 0) then
	-- 	result.award_item_id = i_data.award_item_id
	-- 	local tempData = ItemUtil.getItemById(i_data.award_item_id)
	-- 	result_text = result_text  .. tempData.name .. " "
	-- 	tempData = nil
	-- end

	-- 英雄卡牌
	if(i_data.award_card_id) then

		local tempArr = string.split(i_data.award_card_id , "|")

		result.award_card_id = tempArr[1]

		require "db/DB_Heroes"
		local tempData = DB_Heroes.getDataById(tonumber(tempArr[1]))
		result_text = result_text  .. tempData.name .. GetLocalizeStringBy("key_1869")

		package.loaded["db/DB_Heroes"] = nil

	end
	if(i_data.add_challenge_times and i_data.add_challenge_times > 0) then
		result.add_challenge_times = i_data.add_challenge_times * i_num
		result_text = result_text  .. result.add_challenge_times .. GetLocalizeStringBy("key_3088")
	end

	if( i_data.getPet and  i_data.getPet > 0 )then
		print("i_data.getPet",i_data.getPet)
		require "db/DB_Pet"
		result_text = result_text .. " " .. DB_Pet.getDataById(i_data.getPet).roleName .. "*" .. i_num
	end

	if ( result )then
		useResult = {}
		useResult.result = result
		useResult.result_text = result_text

		if(isModifyCache) then
			if (result.coins) then
				UserModel.changeSilverNumber(result.coins)
			elseif(result.golds)then
				UserModel.changeGoldNumber(result.golds)
			elseif(result.energy)then
				UserModel.changeEnergyValue(result.energy)
			elseif(result.endurance)then
				UserModel.changeStaminaNumber(result.endurance)
			elseif(result.general_soul)then
				UserModel.changeHeroSoulNumber(result.general_soul)
			end
		end
	end
	return useResult
end


-- 通过ID获取某个物品的属性所有信息 i_id<=>item_template_id
function getItemById( i_id )
	i_id = tonumber(i_id)
	local i_data = nil
	if(i_id >= 10001 and i_id <= 20000) then
		-- 直接使用类：10001~30000
		require "db/DB_Item_direct"
		i_data = DB_Item_direct.getDataById(i_id)

	elseif(i_id >= 20001 and i_id <= 30000) then
		-- 礼包类物品：
		require "db/DB_Item_gift"
		i_data = DB_Item_gift.getDataById(i_id)

	elseif(i_id >= 30001 and i_id <= 40000) then
		-- 随机礼包类：
		require "db/DB_Item_randgift"
		i_data = DB_Item_randgift.getDataById(i_id)

	elseif(i_id >= 50001 and i_id <= 60000) then
		-- 坐骑饲料类：50001~80000
		require "db/DB_Item_feed"
		i_data = DB_Item_feed.getDataById(i_id)

	elseif(i_id >= 60001 and i_id <= 70000) then
		-- 普通物品
		require "db/DB_Item_normal"
		i_data = DB_Item_normal.getDataById(i_id)

	elseif(i_id >= 200001 and i_id <= 300000) then
		-- 武将技能书：
		require "db/DB_Item_book"
		i_data = DB_Item_book.getDataById(i_id)

	elseif(i_id >= 40001 and i_id <= 50000) then
		-- 好感礼物类：100001~120000
		require "db/DB_Item_star_gift"
		i_data = DB_Item_star_gift.getDataById(i_id)

	elseif(i_id >= 400001 and i_id <= 500000) then
		-- 武将碎片类：
		require "db/DB_Item_hero_fragment"
		i_data = DB_Item_hero_fragment.getDataById(i_id)

	elseif(i_id >= 1000001 and i_id <= 5000000) then
		-- 物品碎片类：
		require "db/DB_Item_fragment"
		i_data = DB_Item_fragment.getDataById(i_id)

	elseif(i_id >= 100001 and i_id <= 200000) then
		-- 装备类：
		require "db/DB_Item_arm"
		i_data = DB_Item_arm.getDataById(i_id)
		i_data.desc = i_data.info
	elseif(i_id >= 500001 and i_id <= 600000) then
		-- 宝物类：
		require "db/DB_Item_treasure"
		i_data = DB_Item_treasure.getDataById(i_id)
		i_data.desc = i_data.info
	elseif( i_id >= 5000001 and i_id <= 6000000 )then
		-- 宝物碎片
		require "db/DB_Item_treasure_fragment"
		i_data = DB_Item_treasure_fragment.getDataById(i_id)
		i_data.desc = i_data.info
	elseif( i_id >= 70001 and i_id <= 80000 )then
		-- 战魂
		require "db/DB_Item_fightsoul"
		i_data = DB_Item_fightsoul.getDataById(i_id)
		i_data.desc = i_data.info

	elseif( i_id >= 80001 and i_id <= 90000 )then
		-- 时装
		require "db/DB_Item_dress"
		i_data = DB_Item_dress.getDataById(i_id)

		i_data.desc = i_data.info
	elseif( i_id >= 6000001 and i_id <= 7000000 ) then
		require "db/DB_Item_pet_fragment"
		i_data = DB_Item_pet_fragment.getDataById(i_id)

	else
		print("item not found")

	end

	return i_data
end

M_Type_Arm 		= 1 	-- 装备
M_Type_Prop 	= 2 	-- 道具
M_Type_Treas	= 3 	-- 宝物

-- 根据模板ID返回物品类型
function getItemTypeByTId( item_template_id )
	local type_str = nil

	if(item_template_id >= 100001 and item_template_id <= 200000) then
		-- 装备类	：
		type_str = M_Type_Arm
	elseif(item_template_id >= 500001 and item_template_id <= 600000) then
		-- 宝物
		type_str = M_Type_Treas
	else
		-- 道具
		type_str = M_Type_Prop
	end

	return type_str
end

-- 获取饲料
function getFeedInfos()
	local feedInfos = {}
	local allBagInfo = DataCache.getBagInfo()
	if(table.isEmpty( allBagInfo ) == false	) then
		for k, prop_info in pairs(allBagInfo.props) do
			if( tonumber(prop_info.item_template_id)>= 50001 and tonumber(prop_info.item_template_id)<60000 ) then
				table.insert(feedInfos, prop_info)
			end
		end
	end
	return feedInfos
end

-- 获得宠物碎片的信息
function getPetFragInfos( )
	local petFragInfos = {}
	local allBagInfo = DataCache.getBagInfo()
	if(table.isEmpty( allBagInfo.petFrag ) == false	) then
		for k, petFragInfo in pairs(allBagInfo.petFrag) do
			if( tonumber(petFragInfo.item_template_id)>= 600001 and tonumber(petFragInfo.item_template_id)<=7000000 ) then
				table.insert(petFragInfos, petFragInfo)
			end
		end
	end
	return petFragInfos

end

-- 获得某个物品的所有信息
function getFullItemInfoByGid( gid )
	local i_gid = tonumber(gid)
	-- i_gid= 2000004
	local bagInfo = DataCache.getBagInfo()
	-- local remoteBagInfo = DataCache.getRemoteBagInfo()
	local fullItemInfo = nil

	local i_data_t = {}
	if (i_gid >= 2000001 and i_gid < 3000000 ) then
		-- 装备
		i_data_t = bagInfo.arm
	elseif(i_gid >= 3000001 and i_gid < 4000000) then
		-- 道具
		i_data_t = bagInfo.props
	elseif(i_gid >= 4000001 and i_gid < 5000000) then
		-- 武将碎片
		i_data_t = bagInfo.heroFrag
	elseif(i_gid >= 5000001 and i_gid < 6000000) then
		-- 宝物
		i_data_t = bagInfo.treas
	elseif(i_gid >= 6000001 and i_gid < 7000000)then
		-- 装备碎片
		i_data_t = bagInfo.armFrag
	else
		print("Error: Not Found!")
	end
	-- print_t(i_data_t)
	if(not table.isEmpty(i_data_t))then
		for k,tempItem in pairs(i_data_t) do
			if( tonumber(tempItem.gid) == i_gid)then
				fullItemInfo = tempItem
				break
			end
		end
	else
		-- 在临时背包
		local isFind = false
		if(not table.isEmpty(bagInfo.arm))then
			-- 是不是装备
			for r_gid, r_data in pairs(bagInfo.arm) do
				if( tonumber(r_gid) == i_gid) then
					if(isForceDel == true)then
						bagInfo.arm[r_gid] = nil
					else
						if ( tonumber(r_data.item_num) <= i_num)then
							bagInfo.arm[r_gid] = nil
						else
							bagInfo.arm[r_gid].item_num = tonumber(r_data.item_num) - i_num
						end
					end
					isFind = true
					DataCache.setBagInfo(bagInfo)
					break
				end
			end
		end
		if( isFind == false and not table.isEmpty(bagInfo.props))then
			-- 是不是道具
			for r_gid, r_data in pairs(bagInfo.props) do
				if( tonumber(r_gid) == i_gid) then
					if(isForceDel == true)then
						bagInfo.props[r_gid] = nil
					else
						if ( tonumber(r_data.item_num) <= i_num)then
							bagInfo.props[r_gid] = nil
						else
							bagInfo.props[r_gid].item_num = tonumber(r_data.item_num) - i_num
						end
					end
					isFind = true
					DataCache.setBagInfo(bagInfo)
					break
				end
			end
		end
		if( isFind == false and not table.isEmpty(bagInfo.treas))then
			-- 是不是宝物
			for r_gid, r_data in pairs(bagInfo.treas) do
				if( tonumber(r_gid) == i_gid) then
					if(isForceDel == true)then
						bagInfo.treas[r_gid] = nil
					else
						if ( tonumber(r_data.item_num) <= i_num)then
							bagInfo.treas[r_gid] = nil
						else
							bagInfo.treas[r_gid].item_num = tonumber(r_data.item_num) - i_num
						end
					end
					isFind = true
					DataCache.setBagInfo(bagInfo)
					break
				end
			end
		end
		if( isFind == false and not table.isEmpty(bagInfo.heroFrag))then
			-- 是不是武将碎片
			for r_gid, r_data in pairs(bagInfo.heroFrag) do
				if( tonumber(r_gid) == i_gid) then
					if(isForceDel == true)then
						bagInfo.heroFrag[r_gid] = nil
					else
						if ( tonumber(r_data.item_num) <= i_num)then
							bagInfo.heroFrag[r_gid] = nil
						else
							bagInfo.heroFrag[r_gid].item_num = tonumber(r_data.item_num) - i_num
						end
					end
					isFind = true
					DataCache.setBagInfo(bagInfo)
					break
				end
			end
		end

		if( isFind == false and not table.isEmpty(bagInfo.armFrag))then
			-- 是不是装备碎片
			for r_gid, r_data in pairs(bagInfo.armFrag) do
				if( tonumber(r_gid) == i_gid) then
					if(isForceDel == true)then
						bagInfo.armFrag[r_gid] = nil
					else
						if ( tonumber(r_data.item_num) <= i_num)then
							bagInfo.armFrag[r_gid] = nil
						else
							bagInfo.armFrag[r_gid].item_num = tonumber(r_data.item_num) - i_num
						end
					end
					isFind = true
					DataCache.setBagInfo(bagInfo)
					break
				end
			end
		end

		if (isFind == false and not table.isEmpty(bagInfo.petFrag))then
			--是不是宠物碎片
			for r_gid,r_data in pairs(bagInfo.petFrag) do
				if( tonumber(r_gid) == i_gid) then
					if(isForceDel == true)then
						bagInfo.petFrag[r_gid] = nil
					else
						if ( tonumber(r_data.item_num) <= i_num)then
							bagInfo.petFrag[r_gid] = nil
						else
							bagInfo.petFrag[r_gid].item_num = tonumber(r_data.item_num) - i_num
						end
					end
					isFind = true
					DataCache.setBagInfo(bagInfo)
					break
				end
			end
		end
	end


	return fullItemInfo
end

-- 减少物品的个数    i_gid/i_num <=> 格子id/数量
function reduceItemByGid( i_gid, i_num, isForceDel )
	isForceDel = isForceDel or false
	i_gid = tonumber(i_gid)
	if(i_num == nil) then
		i_num = 1
	end
	local remoteBagInfo = DataCache.getRemoteBagInfo()
	local i_data_t = {}
	if (i_gid >= 2000001 and i_gid < 3000000 ) then
		-- 装备
		i_data_t = remoteBagInfo.arm
	elseif(i_gid >= 3000001 and i_gid < 4000000) then
		-- 道具
		i_data_t = remoteBagInfo.props
	elseif(i_gid >= 4000001 and i_gid < 5000000) then
		-- 武将碎片
		i_data_t = remoteBagInfo.heroFrag
	elseif(i_gid >= 5000001 and i_gid < 6000000) then
		-- 宝物
		i_data_t = remoteBagInfo.treas
	elseif(i_gid >= 6000001 and i_gid < 7000000)then
		-- 装备碎片
		i_data_t = remoteBagInfo.armFrag
	elseif(i_gid >= 9000001 and i_gid < 10000000)then
		--宠物碎片
		i_data_t = remoteBagInfo.petFrag
	end

	if(not table.isEmpty(i_data_t))then
		-- 不是临时背包
		for r_gid, r_data in pairs(i_data_t) do
			if( tonumber(r_gid) == i_gid) then
				if(isForceDel == true)then
					i_data_t[r_gid] = nil
				else
					if ( tonumber(r_data.item_num) <= i_num)then
						-- table.remove(i_data_t, r_gid)
						i_data_t[r_gid] = nil
					else
						i_data_t[r_gid].item_num = tonumber(r_data.item_num) - i_num
					end
				end
				if (i_gid >= 2000001 and i_gid < 3000000 ) then
					-- 装备
					remoteBagInfo.arm = i_data_t
				elseif(i_gid >= 3000001 and i_gid < 4000000) then
					-- 道具
					remoteBagInfo.props = i_data_t
				elseif(i_gid >= 4000001 and i_gid < 5000000) then
					-- 武将碎片
					remoteBagInfo.heroFrag = i_data_t
				elseif(i_gid >= 5000001 and i_gid < 6000000) then
					-- 宝物
					remoteBagInfo.treas = i_data_t
				elseif(i_gid >= 6000001 and i_gid < 7000000)then
					-- 装备碎片
					remoteBagInfo.armFrag = i_data_t
				elseif(i_gid >= 9000001 and i_gid < 10000000)then
					--宠物碎片
					remoteBagInfo.petFrag = i_data_t
				end
				DataCache.setBagInfo(remoteBagInfo)
				break
			end
		end
	else
		-- 在临时背包
		local isFind = false
		if(not table.isEmpty(remoteBagInfo.arm))then
			-- 是不是装备
			for r_gid, r_data in pairs(remoteBagInfo.arm) do
				if( tonumber(r_gid) == i_gid) then
					if(isForceDel == true)then
						remoteBagInfo.arm[r_gid] = nil
					else
						if ( tonumber(r_data.item_num) <= i_num)then
							remoteBagInfo.arm[r_gid] = nil
						else
							remoteBagInfo.arm[r_gid].item_num = tonumber(r_data.item_num) - i_num
						end
					end
					isFind = true
					DataCache.setBagInfo(remoteBagInfo)
					break
				end
			end
		end
		if( isFind == false and not table.isEmpty(remoteBagInfo.props))then
			-- 是不是道具
			for r_gid, r_data in pairs(remoteBagInfo.props) do
				if( tonumber(r_gid) == i_gid) then
					if(isForceDel == true)then
						remoteBagInfo.props[r_gid] = nil
					else
						if ( tonumber(r_data.item_num) <= i_num)then
							remoteBagInfo.props[r_gid] = nil
						else
							remoteBagInfo.props[r_gid].item_num = tonumber(r_data.item_num) - i_num
						end
					end
					isFind = true
					DataCache.setBagInfo(remoteBagInfo)
					break
				end
			end
		end
		if( isFind == false and not table.isEmpty(remoteBagInfo.treas))then
			-- 是不是宝物
			for r_gid, r_data in pairs(remoteBagInfo.treas) do
				if( tonumber(r_gid) == i_gid) then
					if(isForceDel == true)then
						remoteBagInfo.treas[r_gid] = nil
					else
						if ( tonumber(r_data.item_num) <= i_num)then
							remoteBagInfo.treas[r_gid] = nil
						else
							remoteBagInfo.treas[r_gid].item_num = tonumber(r_data.item_num) - i_num
						end
					end
					isFind = true
					DataCache.setBagInfo(remoteBagInfo)
					break
				end
			end
		end
		if( isFind == false and not table.isEmpty(remoteBagInfo.heroFrag))then
			-- 是不是武将碎片
			for r_gid, r_data in pairs(remoteBagInfo.heroFrag) do
				if( tonumber(r_gid) == i_gid) then
					if(isForceDel == true)then
						remoteBagInfo.heroFrag[r_gid] = nil
					else
						if ( tonumber(r_data.item_num) <= i_num)then
							remoteBagInfo.heroFrag[r_gid] = nil
						else
							remoteBagInfo.heroFrag[r_gid].item_num = tonumber(r_data.item_num) - i_num
						end
					end
					isFind = true
					DataCache.setBagInfo(remoteBagInfo)
					break
				end
			end
		end

		if( isFind == false and not table.isEmpty(remoteBagInfo.armFrag))then
			-- 是不是装备碎片
			for r_gid, r_data in pairs(remoteBagInfo.armFrag) do
				if( tonumber(r_gid) == i_gid) then
					if(isForceDel == true)then
						remoteBagInfo.armFrag[r_gid] = nil
					else
						if ( tonumber(r_data.item_num) <= i_num)then
							remoteBagInfo.armFrag[r_gid] = nil
						else
							remoteBagInfo.armFrag[r_gid].item_num = tonumber(r_data.item_num) - i_num
						end
					end
					isFind = true
					DataCache.setBagInfo(remoteBagInfo)
					break
				end
			end
		end

		if (isFind == false and not table.isEmpty(remoteBagInfo.petFrag))then
			--是不是宠物碎片
			for r_gid,r_data in pairs(remoteBagInfo.petFrag) do
				if( tonumber(r_gid) == i_gid) then
					if(isForceDel == true)then
						remoteBagInfo.petFrag[r_gid] = nil
					else
						if ( tonumber(r_data.item_num) <= i_num)then
							remoteBagInfo.petFrag[r_gid] = nil
						else
							remoteBagInfo.petFrag[r_gid].item_num = tonumber(r_data.item_num) - i_num
						end
					end
					isFind = true
					DataCache.setBagInfo(remoteBagInfo)
					break
				end
			end
		end
	end
end

--[[
	获得装备的各种数值
	parm	i_id<=>item_id
	return	t_numerial
			t_numerial.hp
			t_numerial.phy_att
			t_numerial.magic_att
			t_numerial.phy_def
			t_numerial.magic_def
--]]
function getEquipNumerialByIID( i_id )
	i_id = tonumber(i_id)

	local t_numerial = {}
	local t_numerial_pl = {}
	local t_equip_score = 0
	-- 获取装备数据
	local a_bagInfo = DataCache.getBagInfo()
	local equipData = nil
	for k,s_data in pairs(a_bagInfo.arm) do
	--		print("s_data.item_id==", s_data.item_id,  "i_id ===", i_id)
		if( tonumber(s_data.item_id) == i_id ) then
			equipData = s_data
			break
		end
	end

	-- 如果为空则是武将身上的装备
	if(table.isEmpty(equipData))then
		equipData = getEquipInfoFromHeroByItemId(i_id)
		if( not table.isEmpty(equipData))then
			require "db/DB_Item_arm"
			equipData.itemDesc = DB_Item_arm.getDataById(equipData.item_template_id)

		end
	end
	-- 进行计算
	if( table.isEmpty(equipData) == false) then
		local equip_desc = equipData.itemDesc
		local forceLevel = tonumber(equipData.va_item_text.armReinforceLevel)

		-- 生命值
		t_numerial.hp 		  = math.floor(equip_desc.baseLife + forceLevel* equip_desc.lifePL/100)
		-- 通用攻击
		t_numerial.gen_att	  = math.floor(equip_desc.baseGenAtt + forceLevel* equip_desc.genAttPL/100)
		-- 物攻
		t_numerial.phy_att	  = math.floor(equip_desc.basePhyAtt + forceLevel* equip_desc.phyAttPL/100)
		-- 魔攻
		t_numerial.magic_att  = math.floor(equip_desc.baseMagAtt + forceLevel* equip_desc.magAttPL/100)
		-- 物防
		t_numerial.phy_def 	  = math.floor(equip_desc.basePhyDef + forceLevel* equip_desc.phyDefPL/100)
		-- 魔防
		t_numerial.magic_def  = math.floor(equip_desc.baseMagDef + forceLevel* equip_desc.magDefPL/100)

		t_numerial_pl.hp		= math.floor(equip_desc.lifePL/100)
		t_numerial_pl.gen_att	= equip_desc.genAttPL/100 --math.floor(equip_desc.genAttPL/100)
		t_numerial_pl.phy_att	= equip_desc.phyAttPL/100 --math.floor(equip_desc.phyAttPL/100)
		t_numerial_pl.magic_att	= equip_desc.magAttPL/100 --math.floor(equip_desc.magAttPL/100)
		t_numerial_pl.phy_def	= equip_desc.phyDefPL/100 --math.floor(equip_desc.phyDefPL/100)
		t_numerial_pl.magic_def	= equip_desc.magDefPL/100 --math.floor(equip_desc.magDefPL/100)

		t_equip_score = equip_desc.base_score + forceLevel* equip_desc.grow_score

	end
	return t_numerial, t_numerial_pl, t_equip_score
end


-- 获得前两条数据用于显示
function getTop2NumeralByIID( i_id )

	if(type(i_id) ~= "number") then
		print("getTop2NumeralByIID(), 参数必须是number")
		return
	end

	local t_numerial, t_numerial_pl, t_equip_score = getEquipNumerialByIID(i_id)
	local f_data = 0
	local f_key  = nil
	local s_data = 0
	local s_key  = nil
	for key, t_num in pairs(t_numerial) do
		if(f_data == nil) then
			f_key  = key
			f_data = t_num
		elseif( t_num > f_data ) then
			s_key  = f_key
			s_data = f_data
			f_key  = key
			f_data = t_num
		elseif( t_num > s_data) then
			s_key  = key
			s_data = t_num
		end
	end
	local tmplData = {}
	local tmplData_PL = {}
	if (f_key) then
		tmplData[f_key] = f_data
		tmplData_PL[f_key] = t_numerial_pl[f_key]
	end
	if (s_key) then
		tmplData[s_key] = s_data
		tmplData_PL[s_key] = t_numerial_pl[s_key]
	end
	return tmplData, tmplData_PL, t_equip_score
end


--[[
	获得装备的各种数值
	parm	tmpl_id<=>item_template_id
	return	t_numerial
			t_numerial.hp
			t_numerial.phy_att
			t_numerial.magic_att
			t_numerial.phy_def
			t_numerial.magic_def
--]]
function getEquipNumerialByTmplID( tmpl_id )
	if(type(tmpl_id) ~= "number") then
		print("参数必须是number")
		return
	end
	local t_numerial 	= {}
	local t_numerial_pl = {}
	local t_equip_score = 0
	-- 获取装备数据
	require "db/DB_Item_arm"
	local equip_desc = DB_Item_arm.getDataById(tmpl_id)


	-- 生命值
	t_numerial.hp 		  = equip_desc.baseLife
	-- 通用攻击
	t_numerial.gen_att	  = equip_desc.baseGenAtt
	-- 物攻
	t_numerial.phy_att	  = equip_desc.basePhyAtt
	-- 魔攻
	t_numerial.magic_att  = equip_desc.baseMagAtt
	-- 物防
	t_numerial.phy_def 	  = equip_desc.basePhyDef
	-- 魔防
	t_numerial.magic_def  = equip_desc.baseMagDef
	print("equip_desc.genAttPL, equip_desc.phyAttPL, equip_desc.magAttPL, equip_desc.phyDefPL, equip_desc.magDefPL===", equip_desc.genAttPL, equip_desc.phyAttPL, equip_desc.magAttPL, equip_desc.phyDefPL, equip_desc.magDefPL)
	t_numerial_pl.hp		= math.floor(equip_desc.lifePL/100)
	t_numerial_pl.gen_att	= equip_desc.genAttPL/100 --math.floor(equip_desc.genAttPL/100)
	t_numerial_pl.phy_att	= equip_desc.phyAttPL/100 --math.floor(equip_desc.phyAttPL/100)
	t_numerial_pl.magic_att	= equip_desc.magAttPL/100 --math.floor(equip_desc.magAttPL/100)
	t_numerial_pl.phy_def	= equip_desc.phyDefPL/100 --math.floor(equip_desc.phyDefPL/100)
	t_numerial_pl.magic_def	= equip_desc.magDefPL/100 --math.floor(equip_desc.magDefPL/100)

	t_equip_score = equip_desc.base_score



	return t_numerial, t_numerial_pl, t_equip_score
end

function getTop2NumeralByTmplID( tmpl_id )
	if(type(tmpl_id) ~= "number") then
		print("getTop2NumeralByIID(), 参数必须是number")
		return
	end

	local t_numerial, t_numerial_pl, t_equip_score = getEquipNumerialByTmplID(tmpl_id)
	local f_data = 0
	local f_key  = nil
	local s_data = 0
	local s_key  = nil
	for key, t_num in pairs(t_numerial) do
		if(f_data == 0) then
			f_key  = key
			f_data = t_num
			-- print(f_key, f_data)
		elseif( t_num > f_data ) then
			s_key  = f_key
			s_data = f_data
			f_key  = key
			f_data = t_num
		elseif( t_num > s_data) then
			s_key  = key
			s_data = t_num
		end
	end

	local tmplData = {}
	local tmplData_PL = {}
	if (f_key) then
		tmplData[f_key] = f_data
		tmplData_PL[f_key] = t_numerial_pl[f_key]
	end
	if (s_key) then
		tmplData[s_key] = s_data
		tmplData_PL[s_key] = t_numerial_pl[s_key]
	end

	return tmplData, tmplData_PL, t_equip_score
end


-- 根据item_id 获取缓存信息
function getItemInfoByItemId( i_id )
	i_id = tonumber(i_id)
	local allBagInfo = DataCache.getRemoteBagInfo()
	local item_info = nil
	for g_id, item_data in pairs(allBagInfo.arm) do
		if(i_id == tonumber(item_data.item_id)) then
			return item_data
		end
	end
	for g_id, item_data in pairs(allBagInfo.props) do
		if(i_id == tonumber(item_data.item_id)) then
			return item_data
		end
	end
	for g_id, item_data in pairs(allBagInfo.heroFrag) do
		if(i_id == tonumber(item_data.item_id)) then
			return item_data
		end
	end

	for g_id, item_data in pairs(allBagInfo.armFrag) do
		if(i_id == tonumber(item_data.item_id)) then
			return item_data
		end
	end

	for g_id, item_data in pairs(allBagInfo.treas) do
		if(i_id == tonumber(item_data.item_id)) then
			return item_data
		end
	end
	if( table.isEmpty(allBagInfo.fightSoul) == false )then
		for g_id, item_data in pairs(allBagInfo.fightSoul) do
			if(i_id == tonumber(item_data.item_id)) then
				return item_data
			end
		end
	end
	if(table.isEmpty(allBagInfo.dress) == false)then
		for g_id, item_data in pairs(allBagInfo.dress) do
			if(i_id == tonumber(item_data.item_id)) then
				return item_data
			end
		end
	end

	if( table.isEmpty(allBagInfo.petFrag)) then
		for g_id, item_data in pairs(allBagInfo.petFrag) do
			if(i_id == tonumber(item_data.item_id)) then
				return item_data
			end
		end
	end

	return nil
end

-- 从hero身上获取装备xinxi
function getEquipInfoFromHeroByItemId( item_id )
	local equipInfo = nil
	local t_equips = HeroUtil.getEquipsOnHeros()

	if ( not table.isEmpty (t_equips)) then
		for t_item_id, t_equipInfo in pairs(t_equips) do
			if(item_id == tonumber(t_item_id)) then
				equipInfo = t_equipInfo
				break
			end
		end
	end

	return equipInfo
end

-- 从hero身上获取时装信息
function getFashionFromHeroByItemId( item_id )
	local fashionInfo = nil
	local t_fashions = HeroUtil.getFashionOnHeros()

	if ( not table.isEmpty (t_fashions)) then
		for t_item_id, t_fashionInfo in pairs(t_fashions) do
			if(tonumber(item_id) == tonumber(t_item_id)) then
				fashionInfo = t_fashionInfo
				break
			end
		end
	end
	return fashionInfo
end

-- 从hero身上获取宝物信息
function getTreasInfoFromHeroByItemId( item_id )
	local treasInfo = nil
	local t_treas = HeroUtil.getTreasOnHeros()

	if ( not table.isEmpty (t_treas)) then
		for t_item_id, t_treasInfo in pairs(t_treas) do
			if(tonumber(item_id) == tonumber(t_item_id)) then
				treasInfo = t_treasInfo
				break
			end
		end
	end

	return treasInfo
end

-- 从hero身上获取战魂信息
function getFightSoulInfoFromHeroByItemId( item_id )
	item_id = tonumber(item_id)
	local fightSoulInfo = nil
	local allFightSoul = HeroUtil.getAllFightSoulOnHeros()

	if ( not table.isEmpty (allFightSoul)) then
		for t_item_id, t_fightSoulInfo in pairs(allFightSoul) do
			if(item_id == tonumber(t_item_id)) then
				fightSoulInfo = t_fightSoulInfo
				break
			end
		end
	end

	return fightSoulInfo
end


--[[
	@desc	背包里面是否有该物品
	@para 	item_template_id
	@return bool true/false <=> 有/无
--]]
function isItemInBagBy( item_tid )
	local r_cacheData = DataCache.getRemoteBagInfo()
	local tempData = {}
	local isHas = false
	if( not table.isEmpty(r_cacheData))then
		if( item_tid >= 100001 and item_tid <= 200000 ) then
			-- 装备
			tempData = r_cacheData.arm

		elseif(item_tid >= 400001 and item_tid <= 500000) then
			-- 武将碎片
			tempData = r_cacheData.heroFrag
		else
			-- 物品
			tempData = r_cacheData.props
		end
		if( not table.isEmpty(tempData))then
			for k, item_info in pairs(tempData) do
				if(tonumber(item_tid) == tonumber(item_info.item_template_id) ) then
					isHas = true
					break
				end
			end
		end
	end
	return isHas
end

-- 道具格子回调
function openPropGridsCallback( cbFlag, dictData, bRet )
	if(dictData.err == "ok") then
		UserModel.addGoldNumber(-BagUtil.getNextOpenPropGridPrice())
		AnimationTip.showTip(GetLocalizeStringBy("key_3328"))
		DataCache.addGidNumBy( 2, 5 )
		if(MainScene.getOnRunningLayerSign() == "bagLayer")then
			BagLayer.createItemNumbersSprite()
		end
	end
end

-- 装备格子回调
function openArmGridsCallback( cbFlag, dictData, bRet )
	if(dictData.err == "ok") then
		UserModel.addGoldNumber(-BagUtil.getNextOpenArmGridPrice())
		AnimationTip.showTip(GetLocalizeStringBy("key_2869"))
		DataCache.addGidNumBy( 1, 5 )
		if(MainScene.getOnRunningLayerSign() == "bagLayer")then
			BagLayer.createItemNumbersSprite()
		end
	end
end

-- 宝物格子回调
function openTreasGridsCallback( cbFlag, dictData, bRet )
	if(dictData.err == "ok") then
		UserModel.addGoldNumber(-BagUtil.getNextOpenTreasGridPrice())
		AnimationTip.showTip(GetLocalizeStringBy("key_2570"))
		DataCache.addGidNumBy( 3, 5 )
		if(MainScene.getOnRunningLayerSign() == "bagLayer")then
			BagLayer.createItemNumbersSprite()
		end
	end
end

-- 装备碎片
function openArmFragCallback( cbFlag, dictData, bRet )
	if(dictData.err == "ok") then
		UserModel.addGoldNumber(-BagUtil.getNextOpenArmFragGridPrice())
		AnimationTip.showTip(GetLocalizeStringBy("key_2104"))
		DataCache.addGidNumBy( 4, 5 )
		if(MainScene.getOnRunningLayerSign() == "bagLayer")then
			BagLayer.createItemNumbersSprite()
		end
	end
end

-- 开启宝物格子
function realOpenTreasGrid(isConfirm)
	if(isConfirm == true) then
		local args = Network.argsHandler(5, 3)
		RequestCenter.bag_openGridByGold(openTreasGridsCallback, args)
	end
end

-- 开启装备格子
function realOpenEquipGrid(isConfirm)
	if(isConfirm == true) then
		local args = Network.argsHandler(5, 1)
		RequestCenter.bag_openGridByGold(openArmGridsCallback, args)
	end
end

-- 开启道具格子
function realOpenPropsGrid(isConfirm)
	if(isConfirm == true)then
		local args = Network.argsHandler(5, 2)
		RequestCenter.bag_openGridByGold(openPropGridsCallback, args)
	end
end

-- 开启装备碎片格子
function realOpenArmFragGrid(isConfirm)
	if(isConfirm == true) then
		local args = Network.argsHandler(5, 4)
		RequestCenter.bag_openGridByGold(openArmFragCallback, args)
	end
end

-- 处理道具背包
function propBagHandleFunc( isConfirm )
	if(isConfirm == true)then
		if(BagUtil.getNextOpenPropGridPrice() <= UserModel.getGoldNumber())then
			local tipText = GetLocalizeStringBy("key_2303") .. BagUtil.getNextOpenPropGridPrice() .. GetLocalizeStringBy("key_1491")
			AlertTip.showAlert(tipText, realOpenPropsGrid, true)
		else
			--添加充值提示 by zhang zihang
			--AnimationTip.showTip(GetLocalizeStringBy("key_1300") .. BagUtil.getNextOpenPropGridPrice() .. GetLocalizeStringBy("key_1911"))
			require "script/ui/tip/LackGoldTip"
			LackGoldTip.showTip()
		end
	else

		require "script/ui/bag/BagLayer"
		local bagLayer = BagLayer.createLayer(BagLayer.Tag_Init_Props)
		MainScene.changeLayer(bagLayer, "bagLayer")

	end
end

-- 道具背包是否已满
function isPropBagFull(isShowAlert)
	local isFull = false
	local allBagInfo = DataCache.getRemoteBagInfo()
    local m_number = 0

    -- 携带数
    if( not table.isEmpty(allBagInfo))then

    	-- 道具是否满了
	    if(not table.isEmpty(allBagInfo.props)) then
		    for k,v in pairs(allBagInfo.props) do
		    	m_number = m_number + 1
		    end
		end
		if( m_number >= tonumber(allBagInfo.gridMaxNum.props)) then
			isFull = true
		end
	end

	if(isFull==true and isShowAlert==true)then
		local tipText = GetLocalizeStringBy("key_3037")
		AlertTip.showAlert(tipText, propBagHandleFunc, true, nil, GetLocalizeStringBy("key_2297"), GetLocalizeStringBy("key_1490"))
	end
    return isFull
end

-- 处理装备背包
function equipBagHandleFunc( isConfirm )
	if(isConfirm == true)then
		if(BagUtil.getNextOpenArmGridPrice() <= UserModel.getGoldNumber())then
			local tipText = GetLocalizeStringBy("key_2590") .. BagUtil.getNextOpenArmGridPrice() .. GetLocalizeStringBy("key_1491")
			AlertTip.showAlert(tipText, realOpenEquipGrid, true)
		else
			--AnimationTip.showTip(GetLocalizeStringBy("key_1300") .. BagUtil.getNextOpenArmGridPrice() .. GetLocalizeStringBy("key_1911"))
			require "script/ui/tip/LackGoldTip"
			LackGoldTip.showTip()
		end
	else
		if type(_forwardDelegate) == "function" then
			_forwardDelegate()
		end
		require "script/ui/bag/BagLayer"
		local bagLayer = BagLayer.createLayer(BagLayer.Tag_Init_Arming)
		MainScene.changeLayer(bagLayer, "bagLayer")
	end
end

-- 装备背包是否已满
function isEquipBagFull(isShowAlert, forwordDelegate)
	_forwardDelegate = forwordDelegate
	local isFull = false
	local allBagInfo = DataCache.getRemoteBagInfo()
    local m_number = 0

    -- 携带数
    if( not table.isEmpty(allBagInfo))then
    	-- 装备是否满了
		if(not table.isEmpty(allBagInfo.arm)) then
		    for k,v in pairs(allBagInfo.arm) do
		    	m_number = m_number + 1
		    end
		end
		if( m_number >= tonumber(allBagInfo.gridMaxNum.arm)) then
			isFull = true
		end
	end
	if(isFull==true and isShowAlert==true)then
		local tipText = GetLocalizeStringBy("key_1286")
		AlertTip.showAlert(tipText, equipBagHandleFunc, true, nil, GetLocalizeStringBy("key_2297"), GetLocalizeStringBy("key_1490"))
	end
    return isFull
end

-- 处理战魂背包
function fightSoulBagHandleFunc( isConfirm )
	if(isConfirm == true)then
		if(BagUtil.getNextOpenArmGridPrice() <= UserModel.getGoldNumber())then
			local tipText = GetLocalizeStringBy("key_2590") .. BagUtil.getNextOpenArmGridPrice() .. GetLocalizeStringBy("key_1491")
			AlertTip.showAlert(tipText, realOpenEquipGrid, true)
		else
			--AnimationTip.showTip(GetLocalizeStringBy("key_1300") .. BagUtil.getNextOpenArmGridPrice() .. GetLocalizeStringBy("key_1911"))
			require "script/ui/tip/LackGoldTip"
			LackGoldTip.showTip()
		end
	else
		if type(_forwardDelegate) == "function" then
			_forwardDelegate()
		end
		require "script/ui/huntSoul/HuntSoulLayer"
		local layer = HuntSoulLayer.createHuntSoulLayer("fightSoulBag")
	    MainScene.changeLayer(layer,"HuntSoulLayer")
	end
end

-- 战魂背包是否已满
function isFightSoulBagFull(isShowAlert, forwordDelegate)
	_forwardDelegate = forwordDelegate
	local isFull = false
	local allBagInfo = DataCache.getRemoteBagInfo()
    local m_number = 0

    -- 携带数
    if( not table.isEmpty(allBagInfo))then
    	-- 装备是否满了
		if(not table.isEmpty(allBagInfo.fightSoul)) then
		    for k,v in pairs(allBagInfo.fightSoul) do
		    	m_number = m_number + 1
		    end
		end
		if( m_number >= tonumber(allBagInfo.gridMaxNum.fightSoul)) then
			isFull = true
		end
	end
	if(isFull==true and isShowAlert==true)then
		local tipText = GetLocalizeStringBy("key_2845")
		AlertTip.showAlert(tipText, fightSoulBagHandleFunc, true, nil, GetLocalizeStringBy("key_2297"), GetLocalizeStringBy("key_1490"),nil,false)
	end
    return isFull
end

-- 处理装备碎片背包
function equipFragBagHandleFunc( isConfirm )
	if(isConfirm == true)then
		if(BagUtil.getNextOpenArmFragGridPrice() <= UserModel.getGoldNumber())then
			local tipText = GetLocalizeStringBy("key_2598") .. BagUtil.getNextOpenArmFragGridPrice() .. GetLocalizeStringBy("key_1491")
			AlertTip.showAlert(tipText, realOpenArmFragGrid, true)
		else
			--AnimationTip.showTip(GetLocalizeStringBy("key_1300") .. BagUtil.getNextOpenArmGridPrice() .. GetLocalizeStringBy("key_1911"))
			require "script/ui/tip/LackGoldTip"
			LackGoldTip.showTip()
		end
	else
		if type(_forwardDelegate) == "function" then
			_forwardDelegate()
		end
		require "script/ui/bag/BagLayer"
		local bagLayer = BagLayer.createLayer(BagLayer.Tag_Init_ArmFrag)
		MainScene.changeLayer(bagLayer, "bagLayer")
	end
end

-- 装备碎片背包是否已满
function isArmFragBagFull(isShowAlert, forwordDelegate)
	_forwardDelegate = forwordDelegate
	local isFull = false
	local allBagInfo = DataCache.getRemoteBagInfo()
    local m_number = 0

    -- 携带数
    if( not table.isEmpty(allBagInfo))then
    	-- 装备是否满了
		if(not table.isEmpty(allBagInfo.armFrag)) then
		    for k,v in pairs(allBagInfo.armFrag) do
		    	m_number = m_number + 1
		    end
		end
		if( m_number >= tonumber(allBagInfo.gridMaxNum.armFrag)) then
			isFull = true
		end
	end
	if(isFull==true and isShowAlert==true)then
		local tipText = GetLocalizeStringBy("key_1000")
		AlertTip.showAlert(tipText, equipFragBagHandleFunc, true, nil, GetLocalizeStringBy("key_2297"), GetLocalizeStringBy("key_1490"))
	end
    return isFull
end

-- 处理宝物背包
function treasBagHandleFunc( isConfirm )
	if(isConfirm == true)then
		if(BagUtil.getNextOpenTreasGridPrice() <= UserModel.getGoldNumber())then
			local tipText = GetLocalizeStringBy("key_2646") .. BagUtil.getNextOpenTreasGridPrice() .. GetLocalizeStringBy("key_1491")
			AlertTip.showAlert(tipText, realOpenTreasGrid, true)
		else
			--AnimationTip.showTip(GetLocalizeStringBy("key_1300") .. BagUtil.getNextOpenTreasGridPrice() .. GetLocalizeStringBy("key_1911"))
			require "script/ui/tip/LackGoldTip"
			LackGoldTip.showTip()
		end
	else
		if type(_forwardDelegate) == "function" then
			_forwardDelegate()
		end
		require "script/ui/bag/BagLayer"
		local bagLayer = BagLayer.createLayer(BagLayer.Tag_Init_Treas)
		MainScene.changeLayer(bagLayer, "bagLayer")
	end
end

-- 宝物背包是否已满
function isTreasBagFull(isShowAlert, forwordDelegate)
	_forwardDelegate = forwordDelegate
	local isFull = false
	local allBagInfo = DataCache.getRemoteBagInfo()
    local m_number = 0

    -- 携带数
    if( not table.isEmpty(allBagInfo))then
    	-- 装备是否满了
		if(not table.isEmpty(allBagInfo.treas)) then
		    for k,v in pairs(allBagInfo.treas) do
		    	m_number = m_number + 1
		    end
		end
		if( m_number >= tonumber(allBagInfo.gridMaxNum.treas)) then
			isFull = true
		end
	end
	if(isFull==true and isShowAlert==true)then
		local tipText = GetLocalizeStringBy("key_2854")
		AlertTip.showAlert(tipText, treasBagHandleFunc, true, nil, GetLocalizeStringBy("key_2297"), GetLocalizeStringBy("key_1490"))
	end
    return isFull
end

-- 背包是否已满 return bool 满/没满 <=> true/false
function isBagFull(isShowAlert)
	local isFull = false
	isShowAlert = isShowAlert or true
	isFull = isPropBagFull(isShowAlert) or isEquipBagFull(isShowAlert) or isTreasBagFull(isShowAlert) or isArmFragBagFull(isShowAlert) or isFightSoulBagFull(isShowAlert)
	return isFull
end

-- 通过item_template_id 得到缓存匹配的第一条数据
function getCacheItemInfoBy( item_template_id )
	item_template_id = tonumber(item_template_id)
	local allBagInfo = DataCache.getRemoteBagInfo()
	local cacheItemInfo = nil
	if( not table.isEmpty(allBagInfo)) then
		if( not table.isEmpty( allBagInfo.props)) then
			for k,item_info in pairs( allBagInfo.props) do
				if(tonumber(item_info.item_template_id) == item_template_id) then
					cacheItemInfo = item_info
					cacheItemInfo.gid = k
				end
			end
		end

		if(item_info==nil and not table.isEmpty( allBagInfo.arm)) then
			for k,item_info in pairs( allBagInfo.arm) do
				if(tonumber(item_info.item_template_id) == item_template_id) then
					cacheItemInfo = item_info
					cacheItemInfo.gid = k
				end
			end
		end

		if(item_info==nil and not table.isEmpty( allBagInfo.heroFrag)) then
			for k,item_info in pairs( allBagInfo.heroFrag) do
				if(tonumber(item_info.item_template_id) == item_template_id) then
					cacheItemInfo = item_info
					cacheItemInfo.gid = k
				end
			end
		end
	end

	return cacheItemInfo
end

-- 通过item_template_id 得到背包中物品的个数
function getCacheItemNumBy( item_template_id )
	item_template_id = tonumber(item_template_id)
	local allBagInfo = DataCache.getRemoteBagInfo()
	local item_num = 0
	if( not table.isEmpty(allBagInfo)) then
		-- 道具
		if( not table.isEmpty( allBagInfo.props)) then
			for k,item_info in pairs( allBagInfo.props) do
				if(tonumber(item_info.item_template_id) == item_template_id) then
					item_num = item_num + tonumber(item_info.item_num)
				end
			end
		end
		-- 装备
		if(item_num<=0 and not table.isEmpty( allBagInfo.arm)) then
			for k,item_info in pairs( allBagInfo.arm) do
				if(tonumber(item_info.item_template_id) == item_template_id) then
					item_num = item_num + tonumber(item_info.item_num)
				end
			end
		end
		-- 武将碎片
		if(item_num<=0 and not table.isEmpty( allBagInfo.heroFrag)) then
			for k,item_info in pairs( allBagInfo.heroFrag) do
				if(tonumber(item_info.item_template_id) == item_template_id) then
					item_num = item_num + tonumber(item_info.item_num)
				end
			end
		end
		-- 宝物
		if(item_num<=0 and not table.isEmpty( allBagInfo.treas)) then
			for k,item_info in pairs( allBagInfo.treas) do
				if(tonumber(item_info.item_template_id) == item_template_id) then
					item_num = item_num + tonumber(item_info.item_num)
				end
			end
		end
		-- add by licong
		-- 装备碎片
		if(item_num<=0 and not table.isEmpty( allBagInfo.armFrag)) then
			for k,item_info in pairs( allBagInfo.armFrag) do
				if(tonumber(item_info.item_template_id) == item_template_id) then
					item_num = item_num + tonumber(item_info.item_num)
				end
			end
		end
		-- 战魂
		if(item_num<=0 and not table.isEmpty( allBagInfo.fightSoul)) then
			for k,item_info in pairs( allBagInfo.fightSoul) do
				if(tonumber(item_info.item_template_id) == item_template_id) then
					item_num = item_num + tonumber(item_info.item_num)
				end
			end
		end
		-- 时装
		if(item_num<=0 and not table.isEmpty( allBagInfo.dress)) then
			for k,item_info in pairs( allBagInfo.dress) do
				if(tonumber(item_info.item_template_id) == item_template_id) then
					item_num = item_num + tonumber(item_info.item_num)
				end
			end
		end
		-- 宠物碎片
		if(item_num<=0 and not table.isEmpty( allBagInfo.petFrag)) then
			for k,item_info in pairs( allBagInfo.petFrag) do
				if(tonumber(item_info.item_template_id) == item_template_id) then
					item_num = item_num + tonumber(item_info.item_num)
				end
			end
		end

	end

	return item_num
end

-- 通过item_template_id 得到背包中p_needLv级的物品的个数  默认寻找0级的
function getCacheItemNumByTidAndLv( item_template_id, p_needLv )
	item_template_id = tonumber(item_template_id)
	local allBagInfo = DataCache.getRemoteBagInfo()
	local item_num = 0
	local needItemLv = tonumber(p_needLv) or 0
	if( not table.isEmpty(allBagInfo)) then
		-- 道具
		if( not table.isEmpty( allBagInfo.props)) then
			for k,item_info in pairs( allBagInfo.props) do
				if(tonumber(item_info.item_template_id) == item_template_id) then
					item_num = item_num + tonumber(item_info.item_num)
				end
			end
		end
		-- 装备
		if(item_num<=0 and not table.isEmpty( allBagInfo.arm)) then
			for k,item_info in pairs( allBagInfo.arm) do
				if(tonumber(item_info.item_template_id) == item_template_id) then
					if(needItemLv == tonumber(item_info.va_item_text.armReinforceLevel))then
						item_num = item_num + tonumber(item_info.item_num)
					end
				end
			end
		end
		-- 武将碎片
		if(item_num<=0 and not table.isEmpty( allBagInfo.heroFrag)) then
			for k,item_info in pairs( allBagInfo.heroFrag) do
				if(tonumber(item_info.item_template_id) == item_template_id) then
					item_num = item_num + tonumber(item_info.item_num)
				end
			end
		end
		-- 宝物
		if(item_num<=0 and not table.isEmpty( allBagInfo.treas)) then
			for k,item_info in pairs( allBagInfo.treas) do
				if(tonumber(item_info.item_template_id) == item_template_id) then
					if(needItemLv == tonumber(item_info.va_item_text.treasureLevel))then
						item_num = item_num + tonumber(item_info.item_num)
					end
				end
			end
		end
		-- add by licong
		-- 装备碎片
		if(item_num<=0 and not table.isEmpty( allBagInfo.armFrag)) then
			for k,item_info in pairs( allBagInfo.armFrag) do
				if(tonumber(item_info.item_template_id) == item_template_id) then
					item_num = item_num + tonumber(item_info.item_num)
				end
			end
		end
		-- 战魂
		if(item_num<=0 and not table.isEmpty( allBagInfo.fightSoul)) then
			for k,item_info in pairs( allBagInfo.fightSoul) do
				if(tonumber(item_info.item_template_id) == item_template_id) then
					if(needItemLv == tonumber(item_info.va_item_text.fsLevel))then
						item_num = item_num + tonumber(item_info.item_num)
					end
				end
			end
		end
		-- 时装
		if(item_num<=0 and not table.isEmpty( allBagInfo.dress)) then
			for k,item_info in pairs( allBagInfo.dress) do
				if(tonumber(item_info.item_template_id) == item_template_id) then
					if(needItemLv == tonumber(item_info.va_item_text.dressLevel))then
						item_num = item_num + tonumber(item_info.item_num)
					end
				end
			end
		end
		-- 宠物碎片
		if(item_num<=0 and not table.isEmpty( allBagInfo.petFrag)) then
			for k,item_info in pairs( allBagInfo.petFrag) do
				if(tonumber(item_info.item_template_id) == item_template_id) then
					item_num = item_num + tonumber(item_info.item_num)
				end
			end
		end

	end

	return item_num
end

-- 获取装备评分 item_id
function getEquipScoreByItemId(item_id)
	--
	if(type(item_id) ~= "number") then
		print("参数必须是number")
		return
	end

	-- 获取装备数据
	local a_bagInfo = DataCache.getBagInfo()
	local equipData = nil
	for k,s_data in pairs(a_bagInfo.arm) do
		if( tonumber(s_data.item_id) == item_id ) then
			equipData = s_data
			break
		end
	end

	-- 如果为空则是武将身上的装备
	if(table.isEmpty(equipData))then
		equipData = getEquipInfoFromHeroByItemId(item_id)
		if( not table.isEmpty(equipData))then
			require "db/DB_Item_arm"
			equipData.itemDesc = DB_Item_arm.getDataById(equipData.item_template_id)

		end
	end

	local equip_desc = equipData.itemDesc
	local forceLevel = tonumber(equipData.va_item_text.armReinforceLevel)
	local t_equip_score = equip_desc.base_score + forceLevel* equip_desc.grow_score
	return t_equip_score
end

-- 获取装备评分 item_template_id
function getEquipScoreByItemTmplId(item_template_id)
	--
	if(type(item_template_id) ~= "number") then
		print("参数必须是number")
		return
	end

	require "db/DB_Item_arm"
	local equip_desc = DB_Item_arm.getDataById(item_template_id)

	return equip_desc.base_score
end


-- 获取名将好感礼物
function getAllStarGifts()
	local allStarGifts = {}

	for gid, prop_info in pairs(DataCache.getRemoteBagInfo().props) do
		if( tonumber(prop_info.item_template_id) >= 40001 and tonumber(prop_info.item_template_id) <= 50000) then
			prop_info.gid = gid
			table.insert(allStarGifts, prop_info)
		end
	end

	return allStarGifts
end

-- 获取武将身上的装备 无gid
function getEquipsOnFormation()
	local formationInfo = DataCache.getFormationInfo()
	local equipsInfo_t = {}
	require "db/DB_Item_arm"
	if( not table.isEmpty(formationInfo))then
		for k,f_hid in pairs(formationInfo) do
			if(tonumber(f_hid)>0)then
				local f_hero = HeroModel.getHeroByHid(f_hid)
				if( (not table.isEmpty(f_hero)) and (not table.isEmpty(f_hero.equip.arming)) ) then
					for p, equipInfo in pairs(f_hero.equip.arming) do
						if( not table.isEmpty(equipInfo)) then
							equipInfo.itemDesc = DB_Item_arm.getDataById(equipInfo.item_template_id)
							equipInfo.itemDesc.desc = equipInfo.itemDesc.info
							equipInfo.equip_hid =  tonumber(f_hid)
							table.insert(equipsInfo_t, equipInfo)
						end
					end
				end
			end
		end
	end
	table.sort( equipsInfo_t, BagUtil.equipSort )
	return equipsInfo_t
end

-- 获得上阵的宝物
function getTreasOnFormation()
	local formationInfo = DataCache.getFormationInfo()
	local equipsInfo_t = {}
	if( not table.isEmpty(formationInfo))then
		for k,f_hid in pairs(formationInfo) do
			if(tonumber(f_hid)>0)then
				local f_hero = HeroModel.getHeroByHid(f_hid)
				if( (not table.isEmpty(f_hero)) and (not table.isEmpty(f_hero.equip.treasure)) ) then
					for p, equipInfo in pairs(f_hero.equip.treasure) do
						if( not table.isEmpty(equipInfo)) then
							equipInfo.itemDesc = ItemUtil.getItemById(equipInfo.item_template_id)
							equipInfo.itemDesc.desc = equipInfo.itemDesc.info
							equipInfo.equip_hid =  tonumber(f_hid)
							table.insert(equipsInfo_t, equipInfo)
						end
					end
				end
			end
		end
	end
	table.sort( equipsInfo_t, BagUtil.treasSort )
	return equipsInfo_t
end

-- 获得上阵的时装
function getDressOnFormation()
	local formationInfo = DataCache.getFormationInfo()
	local equipsInfo_t = {}
	if( not table.isEmpty(formationInfo))then
		for k,f_hid in pairs(formationInfo) do
			if(tonumber(f_hid)>0)then
				local f_hero = HeroModel.getHeroByHid(f_hid)
				if( (not table.isEmpty(f_hero)) and (not table.isEmpty(f_hero.equip.dress)) ) then
					for p, equipInfo in pairs(f_hero.equip.dress) do
						if( not table.isEmpty(equipInfo)) then
							equipInfo.itemDesc = ItemUtil.getItemById(equipInfo.item_template_id)
							equipInfo.itemDesc.desc = equipInfo.itemDesc.info
							equipInfo.equip_hid =  tonumber(f_hid)
							table.insert(equipsInfo_t, equipInfo)
						end
					end
				end
			end
		end
	end
	-- table.sort( equipsInfo_t, BagUtil.treasSort )
	return equipsInfo_t
end

-- 根据装备位置 筛选武将身上的装备 不查找的武将的hid
function getEquipsOnFormationByPos(equipPosition, d_hid)
	equipPosition = tonumber(equipPosition)
	local equipsInfo_t = getEquipsOnFormation()

	local p_equips = {}
	for k, equipInfo in pairs(equipsInfo_t) do
		if(d_hid and tonumber(equipInfo.equip_hid) == tonumber(d_hid) ) then

		elseif(tonumber(equipInfo.itemDesc.type) == equipPosition)then
			table.insert(p_equips, equipInfo)
		end
	end
	return p_equips
end

-- 根据装备位置 筛选武将身上的装备 不查找的武将的hid
function getTreasOnFormationByPos(equipPosition, d_hid)
	equipPosition = tonumber(equipPosition)
	local equipsInfo_t = getTreasOnFormation()

	local p_equips = {}
	for k, equipInfo in pairs(equipsInfo_t) do
		if(d_hid and tonumber(equipInfo.equip_hid) == tonumber(d_hid) ) then

		elseif(tonumber(equipInfo.itemDesc.type) == equipPosition)then
			table.insert(p_equips, equipInfo)
		end
	end
	return p_equips
end

-- 获得武将身上的战魂， hid的武将例外
function getFightSoulOnFormationExeptHid( e_hid )
	e_hid = tonumber(e_hid)
	local p_equips = {}

	local fightSoulOnHeros = HeroUtil.getAllFightSoulOnHeros()
	if( not table.isEmpty(fightSoulOnHeros))then
		for item_id, t_fightSoul in pairs(fightSoulOnHeros) do
			if( e_hid == tonumber(t_fightSoul.equip_hid) )then
			else
				table.insert(p_equips, t_fightSoul)
			end
		end
	end
	return p_equips
end

-- 返回套装信息
function getSuitInfoByIds(item_template_id, hid)
	-- 获取装备数据
	require "db/DB_Item_arm"
	local equip_desc = DB_Item_arm.getDataById(item_template_id)

	if(equip_desc.jobLimit == nil )then
		return
	end

	-- 英雄身上的装备
	local equip_hero = {}
	if(hid and tonumber(hid)>0)then
		equip_hero = HeroUtil.getEquipsByHid(hid)
	end

	-- 获取套装数据
	require "db/DB_Suit"
	local suit_desc = DB_Suit.getDataById(equip_desc.jobLimit)
	-- 套装的各个装备
	local suit_equip_ids = string.split(string.gsub(suit_desc.suit_items, " ", ""), "," )

	-- 已有的套装装备
	local equips_ids_status = {}
	local had_count = 0
	for k, tmpl_id in pairs(suit_equip_ids) do
		equips_ids_status[tmpl_id] = false
		if(tonumber(tmpl_id) == tonumber(item_template_id))then
			equips_ids_status[tmpl_id] = true
			had_count = had_count + 1
		else
			for k,t_equipInfo in pairs(equip_hero) do
				if(tonumber(tmpl_id) == tonumber(t_equipInfo.item_template_id) )then
					equips_ids_status[tmpl_id] = true
					had_count = had_count + 1
					break
				end
			end
		end
	end

	-- 每级激活的套装属性
	local suit_attr_infos = {}
	for i=1,suit_desc.max_lock do
		local attr_info = {}
		attr_info.lock_num = tonumber(suit_desc["lock_num" .. i])
		attr_info.astAttr  = {}
		attr_info.hadUnlock = false
		-- 是否解锁
		if(attr_info.lock_num <= had_count)then
			attr_info.hadUnlock = true
		end

		-- 相应属性
		local astAttr_temp = string.split(string.gsub(suit_desc["astAttr" .. i], " ", ""), "," )
		for k,temp_str in pairs(astAttr_temp) do
			local t_arr = string.split(temp_str, "|" )
			attr_info.astAttr[t_arr[1] .. ""] = t_arr[2]
		end
		table.insert(suit_attr_infos, attr_info)
	end

	local suit_name = suit_desc.name

	return equips_ids_status, suit_attr_infos, suit_name
end


--[[ by licong
	@des 	:得到英雄身上已有的套装id, 套装激活的信息
	@param 	:hid
	@return :table{ suit_id套装id={ suit_id=num套装id,had_count=num套装激活的件数, suit_attr_infos=table激活属性, suit_name=string套装名字, isShow=是否激活了} }
--]]
function getSuitActivateNumByHid( hid )
	-- 英雄身上的装备
	local equip_hero = {}
	if(hid and tonumber(hid)>0)then
		equip_hero = HeroUtil.getEquipsByHid(hid)
	end
	local suitNumTab = {}
	for k,t_equipInfo in pairs(equip_hero) do
		-- print("t_equipInfo")
		-- print_t(t_equipInfo)
		if(t_equipInfo.item_template_id ~= nil)then
			-- 获取装备数据
			require "db/DB_Item_arm"
			local equip_desc = DB_Item_arm.getDataById(t_equipInfo.item_template_id)
			if(equip_desc.jobLimit ~= nil )then
				if(suitNumTab[tonumber(equip_desc.jobLimit)] == nil)then
					suitNumTab[tonumber(equip_desc.jobLimit)] = 1
				else
					suitNumTab[tonumber(equip_desc.jobLimit)] = suitNumTab[tonumber(equip_desc.jobLimit)] + 1
				end
			end
		end
	end
	-- 返回拥有的套装属性信息
	local retSuitTab = {}
	for s_id,s_num in pairs(suitNumTab) do
		local infoTab = {}
		infoTab.suit_attr_infos = {}
		-- 获取套装数据
		require "db/DB_Suit"
		local suit_desc = DB_Suit.getDataById(s_id)
		-- 每级激活的套装属性
		infoTab.isShow = false
		for i=1,suit_desc.max_lock do
			local attr_info = {}
			attr_info.lock_num = tonumber(suit_desc["lock_num" .. i])
			attr_info.astAttr  = {}
			-- 激活
			if(attr_info.lock_num <= s_num)then
				infoTab.isShow = true
				-- 相应属性
				local astAttr_temp = string.split(string.gsub(suit_desc["astAttr" .. i], " ", ""), "," )
				for k,temp_str in pairs(astAttr_temp) do
					local t_arr = string.split(temp_str, "|" )
					attr_info.astAttr[t_arr[1] .. ""] = t_arr[2]
				end
				infoTab.suit_attr_infos = attr_info
			else
				break
			end
		end
		infoTab.suit_name = suit_desc.name
		infoTab.had_count = s_num
		infoTab.suit_id = s_id
		retSuitTab[s_id] = infoTab
	end
	return retSuitTab
end

-- 装备变化
-- 计算属性变化的值
function showAttrChangeInfo(t_numerial_last, t_numerial_cur, p_flyTextCallBack)
	if(table.isEmpty(t_numerial_cur))then
		t_numerial_cur = {}
	end
	local numerial_result = {}
	if(table.isEmpty(t_numerial_last))then
		numerial_result = t_numerial_cur
	else
		for c_k,cur_num in pairs(t_numerial_cur) do
			if(t_numerial_last[c_k] and tonumber(t_numerial_last[c_k]) >0 )then
				numerial_result[c_k] = tonumber(t_numerial_cur[c_k]) -tonumber(t_numerial_last[c_k])
				t_numerial_last[c_k] = 0
			else
				numerial_result[c_k] = tonumber(t_numerial_cur[c_k])
			end
		end
		for l_k, l_num in pairs(t_numerial_last) do
			if(tonumber(l_num)>0)then
				numerial_result[l_k] = -tonumber(l_num)
			end
		end
	end
	local t_text = {}
	for key,v_num in pairs(numerial_result) do
		if(v_num~=0) then
			local strName = ""
			if (key == "hp") then
				strName = GetLocalizeStringBy("key_1765")
			elseif (key == "gen_att") then
				strName = GetLocalizeStringBy("key_2980")
			elseif(key == "phy_att"  )then
				strName = GetLocalizeStringBy("key_2958")
			elseif(key == "magic_att")then
				strName = GetLocalizeStringBy("key_1536")
			elseif(key == "phy_def"  )then
				strName = GetLocalizeStringBy("key_1588")
			elseif(key == "magic_def")then
				strName = GetLocalizeStringBy("key_3133")
			end
			local o_text = {}
			o_text.txt = strName
			o_text.num = v_num
			table.insert(t_text, o_text)
		end
	end
	require "script/utils/LevelUpUtil"
	LevelUpUtil.showFlyText(t_text,p_flyTextCallBack)

end

function showFightSoulAttrChangeInfo( last_attr, cur_attr )
	print_t(last_attr)
	local t_text = {}
	for l_attid, l_data in pairs(last_attr) do
		local addNum = 0
	 	for c_attid, c_data in pairs(cur_attr) do
	 		if( tonumber(l_attid) == tonumber(c_attid) )then
	 			addNum = tonumber(c_data.displayNum)
	 			cur_attr[c_attid] = nil
	 			break
	 		end
	 	end
	 	local o_text = {}
		o_text.txt = l_data.desc.displayName
		o_text.num = addNum - tonumber(l_data.displayNum)
		if(o_text.num>0)then
			table.insert(t_text, o_text)
		end
	end
	for c_attid,c_data in pairs(cur_attr) do
		local o_text = {}
		o_text.txt = c_data.desc.displayName
		o_text.num = c_data.displayNum
		table.insert(t_text, o_text)
	end

	require "script/utils/LevelUpUtil"
	LevelUpUtil.showFlyText(t_text)
end


-- 宝物的基本属性
function getTreasAttrByTmplId( tmpl_id )
	local treasInfo = getItemById(tmpl_id)

	-- 属性信息
	local attr_arr 	= {}
	for i=1,5 do
		local str_info = treasInfo["base_attr"..i]
		if(str_info ~= nil)then
			local tempArr = string.split(str_info, "|")
			local tempArr_pl = string.split(treasInfo["increase_attr"..i], "|")

			local attr_e 	= {}
			attr_e.attId 	= tonumber(tempArr[1])
			attr_e.base 	= tonumber(tempArr[2])
			attr_e.num 		= tonumber(tempArr[2])
			attr_e.pl 		= tonumber(tempArr_pl[2])
			table.insert(attr_arr, attr_e)
		end
	end

	-- 评分
	local score_t = {}
	score_t.base = treasInfo.base_score
	score_t.num  = treasInfo.base_score
	score_t.pl   = treasInfo.increase_score

	-- 解锁属性
	local ext_active = {}
	local active_arr_1 = string.split(treasInfo.ext_active_arr, ",")
	for k, str_act in pairs(active_arr_1) do
		local temp_act_arr = string.split(str_act, "|")
		local t_ext_active = {}
		t_ext_active.openLv = tonumber(temp_act_arr[1])
		t_ext_active.attId 	= tonumber(temp_act_arr[2])
		t_ext_active.num = tonumber(temp_act_arr[3])
		t_ext_active.isOpen = false
		table.insert(ext_active, t_ext_active)
	end
	local enhanceLv = 0
	return attr_arr, score_t, ext_active, enhanceLv, treasInfo
end

-- 宝物的属性
function getTreasAttrByItemId( item_id, treasData )
	item_id = tonumber(item_id)
	-- 获取宝物数据
	local a_bagInfo = DataCache.getBagInfo()
	if(table.isEmpty(treasData))then
		for k,s_data in pairs(a_bagInfo.treas) do
			if( tonumber(s_data.item_id) == item_id ) then
				treasData = s_data
				break
			end
		end

		-- 如果为空则是武将身上的宝物
		if(table.isEmpty(treasData))then
			treasData = getTreasInfoFromHeroByItemId(item_id)
			if( not table.isEmpty(treasData))then
				treasData.itemDesc = getItemById(treasData.item_template_id)
			end
		end
	end

	local attr_arr, score_t, ext_active = getTreasAttrByTmplId(treasData.item_template_id)
	local enhanceLv = tonumber(treasData.va_item_text.treasureLevel)
	if(enhanceLv and enhanceLv>0)then
		-- 计算属性信息
		for key, v in pairs(attr_arr) do
			attr_arr[key].num = v.base + v.pl * enhanceLv
		end
		-- 计算评分
		score_t.num = score_t.base+score_t.pl*enhanceLv
		-- 计算解锁属性
		for k,v in pairs(ext_active) do
			if(enhanceLv >= v.openLv)then
				ext_active[k].isOpen = true
			end
		end
	end
	return attr_arr, score_t, ext_active, enhanceLv, treasData
end

-- 物品属性的名称和数值的显示
function getAtrrNameAndNum( attrId, num )
	require "db/DB_Affix"
    local affixDesc = DB_Affix.getDataById(tonumber(attrId))
    num = tonumber(num)
    local realNum = num
    local displayNum = num
    if(affixDesc.type == 1)then
    	displayNum = num
    elseif(affixDesc.type == 2)then
		displayNum = num / 100
		if(displayNum > math.floor(displayNum))then
			displayNum = string.format("%.1f", displayNum)
		end
	elseif(affixDesc.type == 3)then
		displayNum = num / 100
		if(displayNum > math.floor(displayNum))then
			displayNum = string.format("%.1f", displayNum)
		end

		displayNum = displayNum .. "%"
    end

	return affixDesc, displayNum, realNum
end

-- 解析宝物字符串数组
function parseAttrStringToArr( attr_str )
	local parse_arr_1 = string.split(attr_str, ",")
	local parse_arr_2 = {}
	for k, sub_parse_str in pairs(parse_arr_1) do
		local sub_parse_arr = string.split(sub_parse_str, "|")
		table.insert(parse_arr_2, sub_parse_arr)
	end

	-- 排序
	local function keySort ( data_1, data_2 )
	   	return tonumber(data_1[1]) < tonumber(data_2[1])
	end
	table.sort( parse_arr_2, keySort )

	return parse_arr_2
end

-- 根据宝物的总经验 计算出宝物的当前等级、当前等级经验、当前等级升级所需总经验
function getTreasExpAndLevelInfo( item_template_id, totalExp )
	local tresInfo = getItemById(item_template_id)

	local parse_arr_2 = parseAttrStringToArr( tresInfo.total_upgrade_exp )

	local curLevel 			= 0 -- 当前等级
	local curLevelExp 		= 0 -- 当前等级经验
	local curLevelLimiteExp = 0 -- 当前等级经验上限

	local temp_exp_add = 0
	for k, exp_lv_arr in pairs(parse_arr_2) do
		temp_exp_add = temp_exp_add + exp_lv_arr[2]
		if(totalExp < temp_exp_add)then
			curLevel 			= tonumber(exp_lv_arr[1])
			curLevelLimiteExp 	= tonumber(exp_lv_arr[2])
			curLevelExp 		= curLevelLimiteExp - (tonumber(temp_exp_add) - totalExp)

			break
		elseif(totalExp == temp_exp_add)then
			curLevel 			= tonumber(exp_lv_arr[1]) + 1
			curLevelExp 		= 0
			curLevelLimiteExp 	= tonumber(parse_arr_2[k+1][2])
			break
		end
	end
	return curLevel, curLevelExp, curLevelLimiteExp
end

-- 计算某个等级 每单位经验所需要的 花费
function getSilverPerExpByLevel( item_template_id, level )
	level = tonumber(level)
	local tresInfo = getItemById(item_template_id)
	local sliverPer = 0
	local sliverPerExpArr = parseAttrStringToArr( tresInfo.upgrade_cost_arr )
	for k,v in pairs(sliverPerExpArr) do
		if(tonumber(v[1]) == level )then
			sliverPer = tonumber(v[2])
			break
		end
	end

	return sliverPer
end

-- 计算某个等级所需的全部经验
function getExpForLevelUp(item_template_id, level)
	local tresInfo = getItemById(item_template_id)
	local needExp = 0
	local parse_exp_arr = parseAttrStringToArr( tresInfo.total_upgrade_exp )
	for k,v in pairs(parse_exp_arr) do
		if(tonumber(v[1]) == level )then
			needExp = tonumber(v[2])
			break
		end
	end

	return needExp
end

-- 计算经验到从s_exp到e_exp需要的金币数
function getTreasCostToAddExp( item_template_id, s_exp, e_exp )
	print(" s_exp, e_exp===",  s_exp, e_exp)
	local slilverNum = 0
	local s_level, s_levelExp, s_levelLimiteExp = getTreasExpAndLevelInfo(item_template_id, s_exp)
	local e_level, e_levelExp, e_levelLimiteExp = getTreasExpAndLevelInfo(item_template_id, e_exp)

	if(s_level == e_level)then
		-- 没升级
		sliverNum = getSilverPerExpByLevel( item_template_id, s_level ) * (e_exp - s_exp)
	elseif(e_level-s_level == 1)then
		-- 只升了1级
		sliverNum = getSilverPerExpByLevel( item_template_id, s_level ) * (s_levelLimiteExp - s_levelExp)
		sliverNum = sliverNum + getSilverPerExpByLevel( item_template_id, e_level ) * e_levelExp
	elseif((e_level-s_level) >= 1)then
		-- 升了不止1级
		sliverNum = getSilverPerExpByLevel( item_template_id, s_level ) * (s_levelLimiteExp - s_levelExp)
		sliverNum = sliverNum + getSilverPerExpByLevel( item_template_id, e_level ) * e_levelExp

		for i_lv=s_level+1, e_level-1 do
			sliverNum = sliverNum + getExpForLevelUp(item_template_id, i_lv)*getSilverPerExpByLevel( item_template_id, i_lv )
		end
	end

	return sliverNum
end

-- 某个等级的基础经验
function getBaseExpBy( item_template_id, level )
	-- level = tonumber(level)
	local tresInfo = getItemById(item_template_id)
	-- local baseExp = 0

	-- local parse_exp_arr = parseAttrStringToArr( tresInfo.base_exp_arr )

	-- for k,v in pairs(parse_exp_arr) do

	-- 	if(tonumber(v[1]) == level )then
	-- 		baseExp = tonumber(v[2])
	-- 		break
	-- 	end
	-- end

	return tonumber(tresInfo.base_exp_arr)
end

--判断是否为经验金银书马
function isGoldOrSilverTreas(itemTid)
	if tonumber(itemTid) == 501001 then
		return true
	elseif tonumber(itemTid) == 501002 then
		return true
	elseif tonumber(itemTid) == 502001 then
		return true
	elseif tonumber(itemTid) == 502002 then
		return true
	else
		return false
	end
end

--added by zhang zihang
--通过itemTid和itemId判断是否是经验宝物或宝物精华
function isExpTreasById(itemTid,itemId)
	if itemTid ~= nil then
		if tonumber(itemTid) == 501001 then
			return true
		elseif tonumber(itemTid) == 501002 then
			return true
		elseif tonumber(itemTid) == 502001 then
			return true
		elseif tonumber(itemTid) == 502002 then
			return true
		elseif tonumber(itemTid) == 501010 then
			return true
		else
			return false
		end
	else
		print("进入itemid",itemId)
		local a, b, c, d, treasData = getTreasAttrByItemId(itemId)
		local itemTempId = treasData.item_template_id
		print_t(treasData)
		print(treasData.id)
		if tonumber(itemTempId) == 501001 then
			return true
		elseif tonumber(itemTempId) == 501002 then
			return true
		elseif tonumber(itemTempId) == 502001 then
			return true
		elseif tonumber(itemTempId) == 502002 then
			return true
		elseif tonumber(itemTempId) == 501010 then
			return true
		else
			return false
		end
	end
end

-- 获取5个potential星级一下的宝物ids, (不包括 dup_arr 中的 item_id)
function getTreasIdsByCondition( potential, self_item_id, materialsArr, treas_type)
	potential = potential or 3
	materialsArr = materialsArr or {}
	local bagCache = DataCache.getBagInfo()
	local treas_cache = bagCache.treas

	if( not table.isEmpty(treas_cache) and #materialsArr<5)then

		for k,v in pairs(treas_cache) do
			-- 条件判断更改 by 张梓航
			-- 去除 白鹤 和 黑云
			if( (tonumber(treas_type) == tonumber(v.itemDesc.type)) and tonumber(v.item_template_id)~=501301 and tonumber(v.item_template_id)~=501302 and ((tonumber(v.itemDesc.quality) <= potential) or isGoldOrSilverTreas(v.item_template_id))) then
				local isInDupArr = false

				for k,d_item_id in pairs(materialsArr) do
					if(tonumber(v.item_id) == tonumber(d_item_id) )then
						isInDupArr = true
						break
					end
				end
				if(tonumber(v.item_id) == tonumber(self_item_id))then
					isInDupArr = true
				end
				if(isInDupArr == false)then

					table.insert(materialsArr, tonumber(v.item_id))
					if(#materialsArr>=5)then
						break
					end
				end
			end
		end
	end
	return materialsArr
end

--- added by zhz
function getItemNameByItmTid( item_tid )

	local item_tmpl_id= tonumber(item_tid)
	local itemData = getItemById(item_tid)
	local itemName=  itemData.name
	if item_tmpl_id >= 80001 and item_tmpl_id < 90000 then

		local sex = UserModel.getUserSex()
		local itemInfo = DB_Item_dress.getDataById(item_tid)
		itemName= HeroUtil.getStringByFashionString(itemInfo.name, sex )
	end

	return itemName

end



-------------------------------------------------------------------------------------------------------
-- add by licong
-- 适用于显示奖励物品列表

--  分解表中物品字符串数据
function analyzeGoodsStr( goodsStr )
    if(goodsStr == nil)then
        return
    end
    local goodsData = {}
    local goodTab = string.split(goodsStr, ",")
    for k,v in pairs(goodTab) do
        local data = {}
        local tab = string.split(v, "|")
        data.type = tab[1]
        data.id   = tab[2]
        data.num  = tab[3]
        table.insert(goodsData,data)
    end
    -- print("~~~~~~~~~")
    -- print_t(goodsData)
    -- print("~~~~~~~~~")
    return goodsData
end

-- 根据表配置得到展示物品的数据 奖励的17个类型
-- rewardDataStr 表配置奖励 1|0|1000
-- p_goodsData:解析后的数据{1,0,1000}
function getItemsDataByStr( rewardDataStr, p_goodsData )
    local goodsData = nil
	if(rewardDataStr ~= nil)then
		goodsData = analyzeGoodsStr(rewardDataStr)
	elseif(p_goodsData ~= nil)then
		goodsData = p_goodsData
	end
    -- print("--------------------")
    -- print_t(goodsData)
    if(goodsData == nil)then
        return
    end
    local itemData ={}
    for k,v in pairs(goodsData) do
        local tab = {}
        if( tonumber(v.type) == 1 ) then
            -- 银币
            tab.type = "silver"
            tab.num  = tonumber(v.num)
            tab.tid  = tonumber(v.id)
            tab.name=  GetLocalizeStringBy("key_8042")
        elseif(tonumber(v.type) == 2 ) then
            -- 将魂
            tab.type = "soul"
            tab.num  = tonumber(v.num)
            tab.tid  = tonumber(v.id)
            tab.name= GetLocalizeStringBy("key_1086")
       elseif(tonumber(v.type) == 3 ) then
            -- 金币
            tab.type = "gold"
            tab.num  = tonumber(v.num)
            tab.tid  = tonumber(v.id)
            tab.name= GetLocalizeStringBy("key_1447")
        elseif(tonumber(v.type) == 4 ) then
            -- 体力(wu)
            tab.type = "execution"
            tab.num  = tonumber(v.num)
            tab.tid  = tonumber(v.id)
            tab.name= GetLocalizeStringBy("key_1299")
        elseif(tonumber(v.type) == 5 ) then
            -- 耐力(wu)
            tab.type = "stamina"
            tab.num  = tonumber(v.num)
            tab.tid  = tonumber(v.id)
             tab.name= GetLocalizeStringBy("key_2021")
        elseif(tonumber(v.type) == 6 ) then
            -- 单个物品  类型6 类型id|物品数量默认1|物品id  以前约定特殊处理
            tab.type = "item"
            tab.num  = 1
            tab.tid  = tonumber(v.num)
        elseif(tonumber(v.type) == 7 ) then
            -- 多个物品(wu)
            tab.type = "item"
            tab.num  = tonumber(v.num)
            tab.tid  = tonumber(v.id)
        elseif(tonumber(v.type) == 8 ) then
            -- 等级*银币(wu)
            tab.type = "silver"
            tab.num  = tonumber(v.num) * UserModel.getHeroLevel()
            tab.tid  = tonumber(v.id)
            tab.name= GetLocalizeStringBy("key_1189")
        elseif(tonumber(v.type) == 9 ) then
            -- 等级*将魂(wu)
            tab.type = "soul"
            tab.num  = tonumber(v.num) * UserModel.getHeroLevel()
            tab.tid  = tonumber(v.id)
            tab.name= GetLocalizeStringBy("key_1469")
        elseif(tonumber(v.type) == 10 ) then
            -- 单个英雄 类型10 类型id|物品数量默认1|英雄id  以前约定特殊处理(wu)
            tab.type = "hero"
            tab.num  = 1
            tab.tid  = tonumber(v.num)

        elseif(tonumber(v.type) == 11 ) then
            -- 魂玉
            tab.type = "jewel"
            tab.num  = tonumber(v.num)
            tab.tid  = tonumber(v.id)
            tab.name= GetLocalizeStringBy("key_1510")
        elseif(tonumber(v.type) == 12 ) then
            -- 声望
            tab.type = "prestige"
            tab.num  = tonumber(v.num)
            tab.tid  = tonumber(v.id)
            tab.name= GetLocalizeStringBy("key_2231")
        elseif(tonumber(v.type) == 13 ) then
            -- 多个英雄(wu)
            tab.type = "hero"
            tab.num  = tonumber(v.num)
            tab.tid  = tonumber(v.id)
        elseif(tonumber(v.type) == 14 ) then
            -- 宝物碎片
            tab.type = "item"
            tab.num  = tonumber(v.num)
            tab.tid  = tonumber(v.id)
        elseif(tonumber(v.type) == 15 ) then
	        -- 军团个人贡献
	        tab.type = "contri"
	        tab.num  = tonumber(v.num)
	        tab.tid  = tonumber(v.id)
	    elseif(tonumber(v.type) == 16 ) then
	        -- 军团建设度
	        tab.type = "buildNum"
	        tab.num  = tonumber(v.num)
	        tab.tid  = tonumber(v.id)
	    elseif(tonumber(v.type) == 17 ) then
	        -- 比武荣誉
	        tab.type = "honor"
	        tab.num  = tonumber(v.num)
	        tab.tid  = tonumber(v.id)
	    else
            print("此类型不存在。。。",tonumber(v.type))
            -- return
        end
        -- 存入数组
        if(table.isEmpty(tab) == false) then
        	table.insert(itemData,tab)
        end
    end
    return  itemData
end

-- 根据表配置得到展示物品的数据 奖励的15个类型 专用军团任务
function getItemsDataByStrForTask( rewardDataStr )
    local goodsData = analyzeGoodsStr(rewardDataStr)
    -- print("--------------------")
    -- print_t(goodsData)
    if(goodsData == nil)then
        return
    end
    local itemData ={}
    for k,v in pairs(goodsData) do
        local tab = {}
        if( tonumber(v.type) == 1 ) then
            -- 银币
            tab.type = "silver"
            tab.num  = tonumber(v.num)
            tab.tid  = tonumber(v.id)
            tab.name=  GetLocalizeStringBy("key_8042")
        elseif(tonumber(v.type) == 2 ) then
            -- 将魂
            tab.type = "soul"
            tab.num  = tonumber(v.num)
            tab.tid  = tonumber(v.id)
            tab.name= GetLocalizeStringBy("key_1086")
       elseif(tonumber(v.type) == 3 ) then
            -- 金币
            tab.type = "gold"
            tab.num  = tonumber(v.num)
            tab.tid  = tonumber(v.id)
            tab.name= GetLocalizeStringBy("key_1447")
        elseif(tonumber(v.type) == 4 ) then
            -- 体力(wu)
            tab.type = "execution"
            tab.num  = tonumber(v.num)
            tab.tid  = tonumber(v.id)
            tab.name= GetLocalizeStringBy("key_1299")
        elseif(tonumber(v.type) == 5 ) then
            -- 耐力(wu)
            tab.type = "stamina"
            tab.num  = tonumber(v.num)
            tab.tid  = tonumber(v.id)
             tab.name= GetLocalizeStringBy("key_2021")
        elseif(tonumber(v.type) == 6 ) then
            -- 单个物品  类型6 类型id|物品数量默认1|物品id  以前约定特殊处理
            tab.type = "item"
            tab.num  = 1
            tab.tid  = tonumber(v.num)
        elseif(tonumber(v.type) == 7 ) then
            -- 多个物品(wu)
            tab.type = "item"
            tab.num  = tonumber(v.num)
            tab.tid  = tonumber(v.id)
        elseif(tonumber(v.type) == 8 ) then
            -- 等级*银币(wu)
            tab.type = "silver"
            tab.num  = tonumber(v.num) * UserModel.getHeroLevel()
            tab.tid  = tonumber(v.id)
            tab.name= GetLocalizeStringBy("key_1189")
        elseif(tonumber(v.type) == 9 ) then
            -- 等级*将魂(wu)
            tab.type = "soul"
            tab.num  = tonumber(v.num) * UserModel.getHeroLevel()
            tab.tid  = tonumber(v.id)
            tab.name= GetLocalizeStringBy("key_1469")
        elseif(tonumber(v.type) == 10 ) then
            -- 单个英雄 类型10 类型id|物品数量默认1|英雄id  以前约定特殊处理(wu)
            tab.type = "hero"
            tab.num  = 1
            tab.tid  = tonumber(v.num)

        elseif(tonumber(v.type) == 11 ) then
            -- 魂玉
            tab.type = "jewel"
            tab.num  = tonumber(v.num)
            tab.tid  = tonumber(v.id)
            tab.name= GetLocalizeStringBy("key_1510")
        elseif(tonumber(v.type) == 12 ) then
            -- 声望
            tab.type = "prestige"
            tab.num  = tonumber(v.num)
            tab.tid  = tonumber(v.id)
            tab.name= GetLocalizeStringBy("key_2231")
        elseif(tonumber(v.type) == 13 ) then
            -- 多个英雄(wu)
            tab.type = "hero"
            tab.num  = tonumber(v.num)
            tab.tid  = tonumber(v.id)
        elseif(tonumber(v.type) == 14 ) then
            -- 宝物碎片
            tab.type = "item"
            tab.num  = tonumber(v.num)
            tab.tid  = tonumber(v.id)
        elseif(tonumber(v.type) == 15 ) then
	        -- 军团个人贡献
	        tab.type = "contri"
	        tab.num  = tonumber(v.num)
	        tab.tid  = tonumber(v.id)
	    else
            print("此类型不存在。。。",tonumber(v.type))
            -- return
        end
        -- 存入数组
        if(table.isEmpty(tab) == false) then
        	table.insert(itemData,tab)
        end
    end
    return  itemData
end

----建奖励node-------
function getRewardNode( rewardDataStr )
	-- body
	local goodsData = getItemsDataByStr(rewardDataStr)
	local node      = CCSprite:create()
	local sprite    = nil
	local label     = nil
	local numLabel  = nil
	printTable("rewardDataStr", rewardDataStr)
	if(tostring(goodsData[1].type) == "silver") then
		-- 银币
		print("1111")
		sprite   = CCSprite:create("images/common/coin.png")
		label    = CCRenderLabel:create(GetLocalizeStringBy("key_1687"),g_sFontName,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
		numLabel = CCRenderLabel:create(goodsData[1].num,g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	elseif(tostring(goodsData[1].type) == "soul") then
		-- 将魂
		print("2222")
		sprite 	 = CCSprite:create("images/base/props/jianghun.png")
		label    = CCRenderLabel:create(GetLocalizeStringBy("key_1616"),g_sFontName,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
		numLabel = CCRenderLabel:create(goodsData[1].num,g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	elseif(tostring(goodsData[1].type) == "gold") then
		-- 金币
		print("3333")
		sprite   = CCSprite:create("images/base/props/jinbi_xiao.png")
		label    = CCRenderLabel:create(GetLocalizeStringBy("key_1491"),g_sFontName,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
		numLabel = CCRenderLabel:create(goodsData[1].num,g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	elseif(tostring(goodsData[1].type) == "item") then
		-- 物品
		print("4444")
		sprite   = CCSprite:create("images/base/props/jinbi_xiao.png")
		label    = CCRenderLabel:create(GetLocalizeStringBy("key_1687"),g_sFontName,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
		numLabel = CCRenderLabel:create(goodsData[1].num,g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	elseif(tostring(goodsData[1].type) == "hero") then
		-- 英雄
		print("5555")
		sprite   = CCSprite:create("images/base/props/jinbi_xiao.png")
		label    = CCRenderLabel:create(GetLocalizeStringBy("key_1687"),g_sFontName,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
		numLabel = CCRenderLabel:create(goodsData[1].num,g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	elseif(tostring(goodsData[1].type) == "prestige") then
		-- 声望
		print("6666")
		sprite   = CCSprite:create("images/base/props/shengwang.png")
		label    = CCRenderLabel:create(GetLocalizeStringBy("key_2231"),g_sFontName,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
		numLabel = CCRenderLabel:create(goodsData[1].num,g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
    elseif(tostring(goodsData[1].type) == "jewel") then
		-- 魂玉
		print("7777")
		sprite   = CCSprite:create("images/base/props/hunyu.png")
		label    = CCRenderLabel:create(GetLocalizeStringBy("key_1510"),g_sFontName,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
		numLabel = CCRenderLabel:create(goodsData[1].num,g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
    elseif(tostring(goodsData[1].type) == "execution") then
		-- 体力
		print("8888")
		sprite   = CCSprite:create("images/base/props/tili_xiao.png")
		label    = CCRenderLabel:create(GetLocalizeStringBy("key_1032"),g_sFontName,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
		numLabel = CCRenderLabel:create(goodsData[1].num,g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
    elseif(tostring(goodsData[1].type) == "stamina") then
		-- 耐力
		print("9999")
		sprite   = CCSprite:create("images/base/props/naili_xiao.png")
		label    = CCRenderLabel:create(GetLocalizeStringBy("key_2021"),g_sFontName,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
		numLabel = CCRenderLabel:create(goodsData[1].num,g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	elseif(tostring(goodsData[1].type) == "contri") then
		-- 个人贡献
		print("9999")
		sprite   = CCSprite:create("images/battlemission/gong.png")
		label    = CCRenderLabel:create(GetLocalizeStringBy("llp_35"),g_sFontName,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
		numLabel = CCRenderLabel:create(goodsData[1].num,g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	elseif(tostring(goodsData[1].type) == "haveno") then
		return nil
	end
	node:addChild(sprite)
	node:addChild(label)
	node:addChild(numLabel)
	sprite:setAnchorPoint(ccp(0,0))
	label:setAnchorPoint(ccp(0,0))
	numLabel:setAnchorPoint(ccp(0,0))
	if(tostring(goodsData[1].type) ~= "contri" and tostring(goodsData[1].type) ~= "silver")then
		sprite:setScale(0.4)
	end
	numLabel:setColor(ccc3(0xfe,0xdb,0x1c))
	sprite:setPosition(ccp(0,0))
	if(tostring(goodsData[1].type) ~= "contri" and tostring(goodsData[1].type) ~= "silver")then
		label:setPosition(ccp(sprite:getContentSize().width*0.4,0))
		numLabel:setPosition(ccp(sprite:getContentSize().width*0.4+label:getContentSize().width,0))
		node:setContentSize(CCSizeMake(sprite:getContentSize().width*0.4+label:getContentSize().width+numLabel:getContentSize().width,sprite:getContentSize().height))
	else
		label:setPosition(ccp(sprite:getContentSize().width,0))
		numLabel:setPosition(ccp(sprite:getContentSize().width+label:getContentSize().width,0))
		node:setContentSize(CCSizeMake(sprite:getContentSize().width+label:getContentSize().width+numLabel:getContentSize().width,sprite:getContentSize().height))
	end
	return node
end

--------------------

----
function getNodeByStr( rewardDataStr , isBigMapCpy)
	_isBigMap = isBigMapCpy
    local goodsData = analyzeGoodsStr(rewardDataStr)
    -- print("--------------------")
    -- print_t(goodsData)
    if(goodsData == nil)then
        return
    end
    local itemData ={}
    for k,v in pairs(goodsData) do
        local tab = {}
        if( tonumber(v.type) == 1 ) then
            -- 银币
            tab.type = "silver"
            tab.num  = tonumber(v.num)
            tab.tid  = tonumber(v.id)
            if(_isBigMap == true)then
            	_isBigMap = false
            	local bgNode = CCSprite:create()--
            	local iconSprite = CCSprite:create(BG_PATH.."coin.png")
            	iconSprite:setAnchorPoint(ccp(1,0.5))
            	bgNode:addChild(iconSprite)
            	iconSprite:setPosition(ccp(iconSprite:getContentSize().width,iconSprite:getContentSize().height*0.5))
            	local big = 0
            	local small = 0
            	local numLabel = nil
            	if(tab.num>=10000)then
            		big,small = math.modf(tab.num/10000)
            		if(small~=0)then
            			numLabel = CCRenderLabel:create(big.."."..small..GetLocalizeStringBy("key_2593"),g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
            		else
            			numLabel = CCRenderLabel:create(big..GetLocalizeStringBy("key_2593"),g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
            		end
            	else
            		numLabel = CCRenderLabel:create(tostring(tab.num),g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
            	end

            	numLabel:setAnchorPoint(ccp(0,0.5))
            	iconSprite:addChild(numLabel)
            	numLabel:setPosition(ccp(iconSprite:getContentSize().width,iconSprite:getContentSize().height*0.5))
            	bgNode:setContentSize(CCSizeMake(iconSprite:getContentSize().width+numLabel:getContentSize().width,iconSprite:getContentSize().height))
            	bgNode:setAnchorPoint(ccp(0.5,0.5))
            	return bgNode
            end
        elseif(tonumber(v.type) == 2 ) then
            -- 将魂
            tab.type = "soul"
            tab.num  = tonumber(v.num)
            tab.tid  = tonumber(v.id)
            if(_isBigMap == true)then
            	_isBigMap = false
            	local bgNode = CCSprite:create()
            	local iconSprite = CCSprite:create(BG_PATH.."icon_soul.png")
            	iconSprite:setAnchorPoint(ccp(1,0.5))
            	bgNode:addChild(iconSprite)
            	iconSprite:setPosition(ccp(iconSprite:getContentSize().width,iconSprite:getContentSize().height*0.5))
            	local numLabel = nil
            	if(tab.num>=10000)then
            		big,small = math.modf(tab.num/10000)
            		if(small~=0)then
            			numLabel = CCRenderLabel:create(big.."."..small..GetLocalizeStringBy("key_2593"),g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
            		else
            			numLabel = CCRenderLabel:create(big..GetLocalizeStringBy("key_2593"),g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
            		end
            	else
            		numLabel = CCRenderLabel:create(tostring(tab.num),g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
            	end
            	numLabel:setAnchorPoint(ccp(0,0.5))
            	iconSprite:addChild(numLabel)
            	numLabel:setPosition(ccp(iconSprite:getContentSize().width,iconSprite:getContentSize().height*0.5))
            	bgNode:setContentSize(CCSizeMake(iconSprite:getContentSize().width+numLabel:getContentSize().width,iconSprite:getContentSize().height))
            	bgNode:setAnchorPoint(ccp(0.5,0.5))
            	return bgNode
            end
       elseif(tonumber(v.type) == 3 ) then
            -- 金币
            tab.type = "gold"
            tab.num  = tonumber(v.num)
            tab.tid  = tonumber(v.id)
            if(_isBigMap == true)then
            	_isBigMap = false
            	local bgNode = CCSprite:create()
            	local iconSprite = CCSprite:create(BG_PATH.."gold.png")
            	iconSprite:setAnchorPoint(ccp(1,0.5))
            	bgNode:addChild(iconSprite)
            	iconSprite:setPosition(ccp(iconSprite:getContentSize().width,iconSprite:getContentSize().height*0.5))
            	local numLabel = nil
            	if(tab.num>=10000)then
            		big,small = math.modf(tab.num/10000)
            		if(small~=0)then
            			numLabel = CCRenderLabel:create(big.."."..small..GetLocalizeStringBy("key_2593"),g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
            		else
            			numLabel = CCRenderLabel:create(big..GetLocalizeStringBy("key_2593"),g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
            		end
            	else
            		numLabel = CCRenderLabel:create(tostring(tab.num),g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
            	end
            	numLabel:setAnchorPoint(ccp(0,0.5))
            	iconSprite:addChild(numLabel)
            	numLabel:setPosition(ccp(iconSprite:getContentSize().width,iconSprite:getContentSize().height*0.5))
            	bgNode:setContentSize(CCSizeMake(iconSprite:getContentSize().width+numLabel:getContentSize().width,iconSprite:getContentSize().height))
            	bgNode:setAnchorPoint(ccp(0.5,0.5))
            	return bgNode
            end
        elseif(tonumber(v.type) == 4 ) then
            -- 体力(wu)
            tab.type = "execution"
            tab.num  = tonumber(v.num)
            tab.tid  = tonumber(v.id)
        elseif(tonumber(v.type) == 5 ) then
            -- 耐力(wu)
            tab.type = "stamina"
            tab.num  = tonumber(v.num)
            tab.tid  = tonumber(v.id)
        elseif(tonumber(v.type) == 6 ) then
            -- 单个物品  类型6 类型id|物品数量默认1|物品id  以前约定特殊处理
            tab.type = "item"
            tab.num  = tonumber(v.num)
            tab.tid  = tonumber(v.id)
        elseif(tonumber(v.type) == 7 ) then
            -- 多个物品(wu)
            tab.type = "item"
            tab.num  = tonumber(v.num)
            tab.tid  = tonumber(v.id)
            if(_isBigMap == true)then
            	if(tonumber(tab.tid) == 60002 or tonumber(tab.tid) == 60014 or tonumber(tab.tid) == 10042 or
            		tonumber(tab.tid) == 30003 or tonumber(tab.tid) == 50403 or tonumber(tab.tid) == 60013 or
            		 tonumber(tab.tid) == 60001 or tonumber(tab.tid) == 30103 or
            		 tonumber(tab.tid) == 30021 or tonumber(tab.tid) == 30022 or tonumber(tab.tid) == 72002 or
            		 tonumber(tab.tid) == 60016 or tonumber(tab.tid) == 60007 or tonumber(tab.tid) == 30102 or
            		 tonumber(tab.tid) == 30803 or tonumber(tab.tid) == 30701)then
	            	_isBigMap = false
	            	local bgNode = CCSprite:create()--
	            	local iconSprite = nil
	            	if(tonumber(tab.tid) == 60002)then
	            		iconSprite = CCSprite:create("images/arena/item_icon.png")
	            		iconSprite:setAnchorPoint(ccp(1,0.5))
	            		bgNode:addChild(iconSprite)
	            		iconSprite:setPosition(ccp(iconSprite:getContentSize().width,iconSprite:getContentSize().height*0.5))
	            	elseif(tonumber(tab.tid) == 60014)then
	            		iconSprite = CCSprite:create("images/base/props/qianggongqi.png")
	            		iconSprite:setAnchorPoint(ccp(1,0.5))
	            		bgNode:addChild(iconSprite)
	            		iconSprite:setPosition(ccp(iconSprite:getContentSize().width,iconSprite:getContentSize().height*0.5))
	            	elseif(tonumber(tab.tid) == 10042)then
	            		iconSprite = CCRenderLabel:create(GetLocalizeStringBy("llp_19"),g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	            		iconSprite:setAnchorPoint(ccp(1,0.5))
	            		bgNode:addChild(iconSprite)
	            		iconSprite:setPosition(ccp(iconSprite:getContentSize().width,iconSprite:getContentSize().height*0.5))
	            	elseif(tonumber(tab.tid) == 30003)then
	            		iconSprite = CCRenderLabel:create(GetLocalizeStringBy("llp_14"),g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	            		iconSprite:setAnchorPoint(ccp(1,0.5))
	            		bgNode:addChild(iconSprite)
	            		iconSprite:setPosition(ccp(iconSprite:getContentSize().width,iconSprite:getContentSize().height*0.5))
	            	elseif(tonumber(tab.tid) == 50403)then
	            		iconSprite = CCRenderLabel:create(GetLocalizeStringBy("llp_15"),g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	            		iconSprite:setAnchorPoint(ccp(1,0.5))
	            		bgNode:addChild(iconSprite)
	            		iconSprite:setPosition(ccp(iconSprite:getContentSize().width,iconSprite:getContentSize().height*0.5))
	            	elseif(tonumber(tab.tid) == 60013)then
	            		iconSprite = CCRenderLabel:create(GetLocalizeStringBy("llp_16"),g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	            		iconSprite:setAnchorPoint(ccp(1,0.5))
	            		bgNode:addChild(iconSprite)
	            		iconSprite:setPosition(ccp(iconSprite:getContentSize().width,iconSprite:getContentSize().height*0.5))
	            	elseif(tonumber(tab.tid) == 60001)then
	            		iconSprite = CCRenderLabel:create(GetLocalizeStringBy("llp_17"),g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	            		iconSprite:setAnchorPoint(ccp(1,0.5))
	            		bgNode:addChild(iconSprite)
	            		iconSprite:setPosition(ccp(iconSprite:getContentSize().width,iconSprite:getContentSize().height*0.5))
	            	elseif(tonumber(tab.tid) == 30103)then
	            		iconSprite = CCRenderLabel:create(GetLocalizeStringBy("llp_18"),g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	            		iconSprite:setAnchorPoint(ccp(1,0.5))
	            		bgNode:addChild(iconSprite)
	            		iconSprite:setPosition(ccp(iconSprite:getContentSize().width,iconSprite:getContentSize().height*0.5))
	            	elseif(tonumber(tab.tid) == 30021)then
	            		iconSprite = CCRenderLabel:create(GetLocalizeStringBy("llp_21"),g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	            		iconSprite:setAnchorPoint(ccp(1,0.5))
	            		bgNode:addChild(iconSprite)
	            		iconSprite:setPosition(ccp(iconSprite:getContentSize().width,iconSprite:getContentSize().height*0.5))
	            	elseif(tonumber(tab.tid) == 30022)then
	            		iconSprite = CCRenderLabel:create(GetLocalizeStringBy("llp_22"),g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	            		iconSprite:setAnchorPoint(ccp(1,0.5))
	            		bgNode:addChild(iconSprite)
	            		iconSprite:setPosition(ccp(iconSprite:getContentSize().width,iconSprite:getContentSize().height*0.5))
	            	elseif(tonumber(tab.tid) == 72002)then
	            		iconSprite = CCRenderLabel:create(GetLocalizeStringBy("llp_23"),g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	            		iconSprite:setAnchorPoint(ccp(1,0.5))
	            		bgNode:addChild(iconSprite)
	            		iconSprite:setPosition(ccp(iconSprite:getContentSize().width,iconSprite:getContentSize().height*0.5))
	            	elseif(tonumber(tab.tid) == 60016)then
	            		iconSprite = CCRenderLabel:create(GetLocalizeStringBy("llp_24"),g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	            		iconSprite:setAnchorPoint(ccp(1,0.5))
	            		bgNode:addChild(iconSprite)
	            		iconSprite:setPosition(ccp(iconSprite:getContentSize().width,iconSprite:getContentSize().height*0.5))
	            	elseif(tonumber(tab.tid) == 60007)then
	            		iconSprite = CCRenderLabel:create(GetLocalizeStringBy("llp_25"),g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	            		iconSprite:setAnchorPoint(ccp(1,0.5))
	            		bgNode:addChild(iconSprite)
	            		iconSprite:setPosition(ccp(iconSprite:getContentSize().width,iconSprite:getContentSize().height*0.5))
	            	elseif(tonumber(tab.tid) == 30102)then
	            		iconSprite = CCRenderLabel:create(GetLocalizeStringBy("llp_26"),g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	            		iconSprite:setAnchorPoint(ccp(1,0.5))
	            		bgNode:addChild(iconSprite)
	            		iconSprite:setPosition(ccp(iconSprite:getContentSize().width,iconSprite:getContentSize().height*0.5))
	            	elseif(tonumber(tab.tid) == 30803)then
	            		iconSprite = CCRenderLabel:create(GetLocalizeStringBy("llp_98"),g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	            		iconSprite:setAnchorPoint(ccp(1,0.5))
	            		bgNode:addChild(iconSprite)
	            		iconSprite:setPosition(ccp(iconSprite:getContentSize().width,iconSprite:getContentSize().height*0.5))
	            	elseif(tonumber(tab.tid) == 30701)then
	            		iconSprite = CCRenderLabel:create(GetLocalizeStringBy("llp_99"),g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	            		iconSprite:setAnchorPoint(ccp(1,0.5))
	            		bgNode:addChild(iconSprite)
	            		iconSprite:setPosition(ccp(iconSprite:getContentSize().width,iconSprite:getContentSize().height*0.5))
	            	end

	            	-- iconSprite:setAnchorPoint(ccp(1,0.5))
	            	-- bgNode:addChild(iconSprite)
	            	-- iconSprite:setPosition(ccp(iconSprite:getContentSize().width,iconSprite:getContentSize().height*0.5))
	            	local numLabel = nil
	            	if(tab.num>=10000)then
	            		big,small = math.modf(tab.num/10000)
	            		-- if(small~=0)then
	            		-- 	numLabel = CCRenderLabel:create(big.."."..small..GetLocalizeStringBy("key_2593"),g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	            		-- else
	            			numLabel = CCRenderLabel:create(" "..big..GetLocalizeStringBy("key_2593"),g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	            		-- end
	            	else
	            		numLabel = CCRenderLabel:create(" "..tostring(tab.num),g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	            	end
	            	-- numLabel:setScale(2)
	            	numLabel:setAnchorPoint(ccp(0,0.5))
	            	iconSprite:addChild(numLabel)
	            	numLabel:setPosition(ccp(iconSprite:getContentSize().width,iconSprite:getContentSize().height*0.5))
	            	bgNode:setContentSize(CCSizeMake(iconSprite:getContentSize().width+numLabel:getContentSize().width,iconSprite:getContentSize().height))
            		bgNode:setAnchorPoint(ccp(0.5,0.5))
	            	return bgNode
	            end

            end
        elseif(tonumber(v.type) == 8 ) then
            -- 等级*银币(wu)
            tab.type = "silver"
            tab.num  = tonumber(v.num) * UserModel.getHeroLevel()
            tab.tid  = tonumber(v.id)
        elseif(tonumber(v.type) == 9 ) then
            -- 等级*将魂(wu)
            tab.type = "soul"
            tab.num  = tonumber(v.num) * UserModel.getHeroLevel()
            tab.tid  = tonumber(v.id)
        elseif(tonumber(v.type) == 10 ) then
            -- 单个英雄 类型10 类型id|物品数量默认1|英雄id  以前约定特殊处理(wu)
            tab.type = "hero"
            tab.num  = 1
            tab.tid  = tonumber(v.num)
        elseif(tonumber(v.type) == 11 ) then
            -- 魂玉
            tab.type = "jewel"
            tab.num  = tonumber(v.num)
            tab.tid  = tonumber(v.id)
            if(_isBigMap == true)then

            	_isBigMap = false
            	local bgNode = CCSprite:create()--
            	local iconSprite = CCSprite:create("images/common/jewel_small.png")
            	iconSprite:setAnchorPoint(ccp(1,0.5))
            	bgNode:addChild(iconSprite)
            	iconSprite:setPosition(ccp(iconSprite:getContentSize().width,iconSprite:getContentSize().height*0.5))
            	local numLabel = nil
            	if(tab.num>=10000)then
            		big,small = math.modf(tab.num/10000)
            		if(small~=0)then
            			numLabel = CCRenderLabel:create(big.."."..small..GetLocalizeStringBy("key_2593"),g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
            		else
            			numLabel = CCRenderLabel:create(big..GetLocalizeStringBy("key_2593"),g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
            		end
            	else
            		numLabel = CCRenderLabel:create(tostring(tab.num),g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
            	end
            	numLabel:setAnchorPoint(ccp(0,0.5))
            	iconSprite:addChild(numLabel)
            	numLabel:setPosition(ccp(iconSprite:getContentSize().width,iconSprite:getContentSize().height*0.5))
            	bgNode:setContentSize(CCSizeMake(iconSprite:getContentSize().width+numLabel:getContentSize().width,iconSprite:getContentSize().height))
            	bgNode:setAnchorPoint(ccp(0.5,0.5))
            	return bgNode

            end
        elseif(tonumber(v.type) == 12 ) then
            -- 声望
            tab.type = "prestige"
            tab.num  = tonumber(v.num)
            tab.tid  = tonumber(v.id)
            if(_isBigMap == true)then
            	_isBigMap = false
            	local bgNode = CCSprite:create()--
            	local iconSprite = CCSprite:create("images/common/prestige.png")
            	iconSprite:setAnchorPoint(ccp(1,0.5))
            	bgNode:addChild(iconSprite)
            	iconSprite:setPosition(ccp(iconSprite:getContentSize().width,iconSprite:getContentSize().height*0.5))
            	local numLabel = nil
            	if(tab.num>=10000)then
            		big,small = math.modf(tab.num/10000)
            		if(small~=0)then
            			numLabel = CCRenderLabel:create(big.."."..small..GetLocalizeStringBy("key_2593"),g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
            		else
            			numLabel = CCRenderLabel:create(big..GetLocalizeStringBy("key_2593"),g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
            		end
            	else
            		numLabel = CCRenderLabel:create(tostring(tab.num),g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
            	end
            	numLabel:setAnchorPoint(ccp(0,0.5))
            	iconSprite:addChild(numLabel)
            	numLabel:setPosition(ccp(iconSprite:getContentSize().width,iconSprite:getContentSize().height*0.5))
            	bgNode:setContentSize(CCSizeMake(iconSprite:getContentSize().width+numLabel:getContentSize().width,iconSprite:getContentSize().height))
            	bgNode:setAnchorPoint(ccp(0.5,0.5))
            	return bgNode
            end
        elseif(tonumber(v.type) == 13 ) then
            -- 多个英雄(wu)
            tab.type = "hero"
            tab.num  = tonumber(v.num)
            tab.tid  = tonumber(v.id)
            if(_isBigMap == true)then
            	if(tonumber(tab.tid) == 40001)then
	            	_isBigMap = false
	            	local bgNode = CCSprite:create()--
	            	local iconSprite = nil
	            	if(tonumber(tab.tid) == 40001)then
	            		iconSprite = CCRenderLabel:create(GetLocalizeStringBy("llp_20"),g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	            	end

	            	iconSprite:setAnchorPoint(ccp(1,0.5))
	            	bgNode:addChild(iconSprite)
	            	iconSprite:setPosition(ccp(iconSprite:getContentSize().width,iconSprite:getContentSize().height*0.5))
	            	local numLabel = nil
	            	if(tab.num>=10000)then
	            		big,small = math.modf(tab.num/10000)
	            		-- if(small~=0)then
	            		-- 	numLabel = CCRenderLabel:create(big.."."..small..GetLocalizeStringBy("key_2593"),g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	            		-- else
	            			numLabel = CCRenderLabel:create(" "..big..GetLocalizeStringBy("key_2593"),g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	            		-- end
	            	else
	            		numLabel = CCRenderLabel:create(" "..tostring(tab.num),g_sFontPangWa,18,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	            	end
	            	-- numLabel:setScale(2)
	            	numLabel:setAnchorPoint(ccp(0,0.5))
	            	iconSprite:addChild(numLabel)
	            	numLabel:setPosition(ccp(iconSprite:getContentSize().width,iconSprite:getContentSize().height*0.5))
	            	bgNode:setContentSize(CCSizeMake(iconSprite:getContentSize().width+numLabel:getContentSize().width,iconSprite:getContentSize().height))
            		bgNode:setAnchorPoint(ccp(0.5,0.5))
	            	return bgNode
	            end
	        end
        elseif(tonumber(v.type) == 14 ) then
            -- 多个物品(wu)
            tab.type = "item"
            tab.num  = tonumber(v.num)
            tab.tid  = tonumber(v.id)
        else
            print("此类型不存在。。。",tonumber(v.type))
            return
        end
        -- 存入数组
        if(_isBigMap == false)then
        	table.insert(itemData,tab)
        end
    end
    -- if(_isBigMap == false)then
    -- 	return  itemData
    -- else
    	local node = CCSprite:create()
    	return node
    -- end
end
----

-- 创建展示物品列表cell
-- cellValues 物品数据
-- menu_priority:按钮的优先级，zOrderNum:z轴，info_layer_priority:展示界面的优先级
function createGoodListCell( cellValues, menu_priority, zOrderNum, info_layer_priority )
	-- print("//////////")
	-- print_t(cellValues)
	local cell = CCTableViewCell:create()
	local iconBg = nil
	local iconName = nil
	local nameColor = nil
	if(cellValues.type == "silver") then
		-- 银币
		iconBg= ItemSprite.getSiliverIconSprite()
		iconName = GetLocalizeStringBy("key_1687")
		local quality = ItemSprite.getSilverQuality()
        nameColor = HeroPublicLua.getCCColorByStarLevel(quality)
	elseif(cellValues.type == "soul") then
		-- 将魂
		iconBg= ItemSprite.getSoulIconSprite()
		iconName = GetLocalizeStringBy("key_1616")
		local quality = ItemSprite.getSoulQuality()
        nameColor = HeroPublicLua.getCCColorByStarLevel(quality)
	elseif(cellValues.type == "gold") then
		-- 金币
		iconBg= ItemSprite.getGoldIconSprite()
		iconName = GetLocalizeStringBy("key_1491")
		local quality = ItemSprite.getGoldQuality()
        nameColor = HeroPublicLua.getCCColorByStarLevel(quality)
	elseif(cellValues.type == "item") then
		-- 物品
		iconBg =  ItemSprite.getItemSpriteById(tonumber(cellValues.tid),nil, nil, nil,  menu_priority, zOrderNum, info_layer_priority)
		local itemData = ItemUtil.getItemById(cellValues.tid)
        iconName = itemData.name
        nameColor = HeroPublicLua.getCCColorByStarLevel(itemData.quality)
	elseif(cellValues.type == "hero") then
		-- 英雄
		require "db/DB_Heroes"
		iconBg = ItemSprite.getHeroIconItemByhtid(cellValues.tid,menu_priority,zOrderNum,info_layer_priority)
		local heroData = DB_Heroes.getDataById(cellValues.tid)
		iconName = heroData.name
		nameColor = HeroPublicLua.getCCColorByStarLevel(heroData.star_lv)
	elseif(cellValues.type == "prestige") then
		-- 声望
		iconBg= ItemSprite.getPrestigeSprite()
		iconName = GetLocalizeStringBy("key_2231")
		local quality = ItemSprite.getPrestigeQuality()
        nameColor = HeroPublicLua.getCCColorByStarLevel(quality)
    elseif(cellValues.type == "jewel") then
		-- 魂玉
		iconBg= ItemSprite.getJewelSprite()
		iconName = GetLocalizeStringBy("key_1510")
		local quality = ItemSprite.getJewelQuality()
        nameColor = HeroPublicLua.getCCColorByStarLevel(quality)
    elseif(cellValues.type == "execution") then
		-- 体力
		iconBg= ItemSprite.getExecutionSprite()
		iconName = GetLocalizeStringBy("key_1032")
		local quality = ItemSprite.getExecutionQuality()
        nameColor = HeroPublicLua.getCCColorByStarLevel(quality)
    elseif(cellValues.type == "stamina") then
		-- 耐力
		iconBg= ItemSprite.getStaminaSprite()
		iconName = GetLocalizeStringBy("key_2021")
		local quality = ItemSprite.getStaminaQuality()
        nameColor = HeroPublicLua.getCCColorByStarLevel(quality)
	end
	iconBg:setAnchorPoint(ccp(0,1))
	iconBg:setPosition(ccp(10,120))
	cell:addChild(iconBg)

	-- 物品数量
	if( tonumber(cellValues.num) > 1 )then
		local numberLabel =  CCRenderLabel:create("" .. cellValues.num , g_sFontName,21,2,ccc3(0x00,0x00,0x00),type_stroke)
		numberLabel:setColor(ccc3(0x00,0xff,0x18))
		numberLabel:setAnchorPoint(ccp(0,0))
		local width = iconBg:getContentSize().width - numberLabel:getContentSize().width - 6
		numberLabel:setPosition(ccp(width,5))
		iconBg:addChild(numberLabel)
	end

	--- desc 物品名字
	local descLabel = CCRenderLabel:create("" .. iconName , g_sFontName,21,1,ccc3(0x00,0x00,0x00),type_stroke)
	descLabel:setColor(nameColor)
	descLabel:setAnchorPoint(ccp(0.5,0.5))
	descLabel:setPosition(ccp(iconBg:getContentSize().width*0.5 ,-iconBg:getContentSize().height*0.1-2))
	iconBg:addChild(descLabel)

	return cell
end

-- 领取成功后修改本地数据
function addRewardByTable( rewardTab )
     for k,v in pairs(rewardTab) do
        if( v.type == "silver" ) then
            -- 加银币
            UserModel.addSilverNumber(tonumber(v.num))
        elseif( v.type == "soul" ) then
            -- 加将魂
            UserModel.addSoulNum(tonumber(v.num))
       elseif( v.type == "gold" ) then
            -- 加金币
            UserModel.addGoldNumber(tonumber(v.num))
        elseif( v.type == "execution" ) then
            -- 加体力点
            UserModel.addEnergyValue(tonumber(v.num))
        elseif( v.type == "stamina" ) then
            -- 加耐力点
            UserModel.addStaminaNumber(tonumber(v.num))
        elseif( v.type == "prestige") then
            -- 加声望
            UserModel.addPrestigeNum(tonumber(v.num))
        elseif( v.type == "jewel") then
            -- 加魂玉
            UserModel.addJewelNum(tonumber(v.num))
        elseif( v.type == "contri") then
            -- 个人贡献
            GuildDataCache.addSigleDonate(tonumber(v.num))
        end
    end
end

-- 获得一个奖励的icon
function createGoodsIcon(goodsValues, menu_priority, zOrderNum, info_layer_priority, callFun ,p_needSpecial)
	local iconBg = nil
	local iconName = nil
	local nameColor = nil
	--needSpecial这个参数的意思是
	--如果希望拿到带有武将信息回调的武魂头像的话，将这个参数设置为true即可
	--added by Zhang Zihang
	local needSpecial = p_needSpecial or false
	if(goodsValues.type == "silver") then
		-- 银币
		iconBg= ItemSprite.getSiliverIconSprite()
		iconName = GetLocalizeStringBy("key_1687")
		local quality = ItemSprite.getSilverQuality()
        nameColor = HeroPublicLua.getCCColorByStarLevel(quality)
	elseif(goodsValues.type == "soul") then
		-- 将魂
		iconBg= ItemSprite.getSoulIconSprite()
		iconName = GetLocalizeStringBy("key_1616")
		local quality = ItemSprite.getSoulQuality()
        nameColor = HeroPublicLua.getCCColorByStarLevel(quality)
	elseif(goodsValues.type == "gold") then
		-- 金币
		iconBg= ItemSprite.getGoldIconSprite()
		iconName = GetLocalizeStringBy("key_1491")
		local quality = ItemSprite.getGoldQuality()
        nameColor = HeroPublicLua.getCCColorByStarLevel(quality)
	elseif(goodsValues.type == "item") then
		-- 物品
		--如果希望得到带有武将信息回调的武魂头像
		--added by Zhang Zihang
		if needSpecial and (tonumber(goodsValues.tid) >= 400001 and tonumber(goodsValues.tid) <= 500000) then
			iconBg = ItemSprite.getHeroSoulSprite(tonumber(goodsValues.tid),menu_priority,zOrderNum,info_layer_priority)
			local itemData = ItemUtil.getItemById(goodsValues.tid)
	        iconName = itemData.name
	        nameColor = HeroPublicLua.getCCColorByStarLevel(itemData.quality)
		--如果想得到的只是物品图标的话
	    else
	    	iconBg =  ItemSprite.getItemSpriteById(tonumber(goodsValues.tid),nil, callFun, nil,  menu_priority, zOrderNum, info_layer_priority)
			local itemData = ItemUtil.getItemById(goodsValues.tid)
	        iconName = itemData.name
	        nameColor = HeroPublicLua.getCCColorByStarLevel(itemData.quality)
	    end
	elseif(goodsValues.type == "hero") then
		-- 英雄
		require "db/DB_Heroes"
		iconBg = ItemSprite.getHeroIconItemByhtid(goodsValues.tid,menu_priority,zOrderNum,info_layer_priority)
		local heroData = DB_Heroes.getDataById(goodsValues.tid)
		iconName = heroData.name
		nameColor = HeroPublicLua.getCCColorByStarLevel(heroData.star_lv)
	elseif(goodsValues.type == "prestige") then
		-- 声望
		iconBg= ItemSprite.getPrestigeSprite()
		iconName = GetLocalizeStringBy("key_2231")
		local quality = ItemSprite.getPrestigeQuality()
        nameColor = HeroPublicLua.getCCColorByStarLevel(quality)
    elseif(goodsValues.type == "jewel") then
		-- 魂玉
		iconBg= ItemSprite.getJewelSprite()
		iconName = GetLocalizeStringBy("key_1510")
		local quality = ItemSprite.getJewelQuality()
        nameColor = HeroPublicLua.getCCColorByStarLevel(quality)
    elseif(goodsValues.type == "execution") then
		-- 体力
		iconBg= ItemSprite.getExecutionSprite()
		iconName = GetLocalizeStringBy("key_1032")
		local quality = ItemSprite.getExecutionQuality()
        nameColor = HeroPublicLua.getCCColorByStarLevel(quality)
    elseif(goodsValues.type == "stamina") then
		-- 耐力
		iconBg= ItemSprite.getStaminaSprite()
		iconName = GetLocalizeStringBy("key_2021")
		local quality = ItemSprite.getStaminaQuality()
        nameColor = HeroPublicLua.getCCColorByStarLevel(quality)
	end

	-- 物品数量
	if( tonumber(goodsValues.num) > 1 )then
		local numberLabel =  CCRenderLabel:create("" .. goodsValues.num , g_sFontName,21,2,ccc3(0x00,0x00,0x00),type_stroke)
		numberLabel:setColor(ccc3(0x00,0xff,0x18))
		numberLabel:setAnchorPoint(ccp(0,0))
		local width = iconBg:getContentSize().width - numberLabel:getContentSize().width - 6
		numberLabel:setPosition(ccp(width,5))
		iconBg:addChild(numberLabel)
	end

	--- desc 物品名字
	local descLabel = CCRenderLabel:create("" .. iconName , g_sFontName,21,1,ccc3(0x00,0x00,0x00),type_stroke)
	descLabel:setColor(nameColor)
	descLabel:setAnchorPoint(ccp(0.5,0.5))
	descLabel:setPosition(ccp(iconBg:getContentSize().width*0.5 ,-iconBg:getContentSize().height*0.1-2))
	iconBg:addChild(descLabel)

	return iconBg
end



--
-- 获得一个奖励的icon
-- function createGoodsIcon(goodsValues, menu_priority, zOrderNum, info_layer_priority, callFun )
-- 	local iconBg = nil
-- 	local iconName = nil
-- 	local nameColor = nil
-- 	if(goodsValues.type == "silver") then
-- 		-- 银币
-- 		iconBg= ItemSprite.getSiliverIconSprite()
-- 		iconName = GetLocalizeStringBy("key_1687")
-- 		local quality = ItemSprite.getSilverQuality()
--         nameColor = HeroPublicLua.getCCColorByStarLevel(quality)
-- 	elseif(goodsValues.type == "soul") then
-- 		-- 将魂
-- 		iconBg= ItemSprite.getSoulIconSprite()
-- 		iconName = GetLocalizeStringBy("key_1616")
-- 		local quality = ItemSprite.getSoulQuality()
--         nameColor = HeroPublicLua.getCCColorByStarLevel(quality)
-- 	elseif(goodsValues.type == "gold") then
-- 		-- 金币
-- 		iconBg= ItemSprite.getGoldIconSprite()
-- 		iconName = GetLocalizeStringBy("key_1491")
-- 		local quality = ItemSprite.getGoldQuality()
--         nameColor = HeroPublicLua.getCCColorByStarLevel(quality)
-- 	elseif(goodsValues.type == "item") then
-- 		-- 物品
-- 		iconBg =  ItemSprite.getItemSpriteById(tonumber(goodsValues.tid),nil, callFun, nil,  menu_priority, zOrderNum, info_layer_priority)
-- 		local itemData = ItemUtil.getItemById(goodsValues.tid)
--         iconName = itemData.name
--         nameColor = HeroPublicLua.getCCColorByStarLevel(itemData.quality)
-- 	elseif(goodsValues.type == "hero") then
-- 		-- 英雄
-- 		require "db/DB_Heroes"
-- 		iconBg = ItemSprite.getHeroIconItemByhtid(goodsValues.tid,menu_priority,zOrderNum,info_layer_priority)
-- 		local heroData = DB_Heroes.getDataById(goodsValues.tid)
-- 		iconName = heroData.name
-- 		nameColor = HeroPublicLua.getCCColorByStarLevel(heroData.star_lv)
-- 	elseif(goodsValues.type == "prestige") then
-- 		-- 声望
-- 		iconBg= ItemSprite.getPrestigeSprite()
-- 		iconName = GetLocalizeStringBy("key_2231")
-- 		local quality = ItemSprite.getPrestigeQuality()
--         nameColor = HeroPublicLua.getCCColorByStarLevel(quality)
--     elseif(goodsValues.type == "jewel") then
-- 		-- 魂玉
-- 		iconBg= ItemSprite.getJewelSprite()
-- 		iconName = GetLocalizeStringBy("key_1510")
-- 		local quality = ItemSprite.getJewelQuality()
--         nameColor = HeroPublicLua.getCCColorByStarLevel(quality)
--     elseif(goodsValues.type == "execution") then
-- 		-- 体力
-- 		iconBg= ItemSprite.getExecutionSprite()
-- 		iconName = GetLocalizeStringBy("key_1032")
-- 		local quality = ItemSprite.getExecutionQuality()
--         nameColor = HeroPublicLua.getCCColorByStarLevel(quality)
--     elseif(goodsValues.type == "stamina") then
-- 		-- 耐力
-- 		iconBg= ItemSprite.getStaminaSprite()
-- 		iconName = GetLocalizeStringBy("key_2021")
-- 		local quality = ItemSprite.getStaminaQuality()
--         nameColor = HeroPublicLua.getCCColorByStarLevel(quality)
-- 	end

-- 	-- 物品数量
-- 	if( tonumber(goodsValues.num) > 1 )then
-- 		local numberLabel =  CCRenderLabel:create("" .. goodsValues.num , g_sFontName,21,2,ccc3(0x00,0x00,0x00),type_stroke)
-- 		numberLabel:setColor(ccc3(0x00,0xff,0x18))
-- 		numberLabel:setAnchorPoint(ccp(0,0))
-- 		local width = iconBg:getContentSize().width - numberLabel:getContentSize().width - 6
-- 		numberLabel:setPosition(ccp(width,5))
-- 		iconBg:addChild(numberLabel)
-- 	end

-- 	--- desc 物品名字
-- 	local descLabel = CCRenderLabel:create("" .. iconName , g_sFontName,21,1,ccc3(0x00,0x00,0x00),type_stroke)
-- 	descLabel:setColor(nameColor)
-- 	descLabel:setAnchorPoint(ccp(0.5,0.5))
-- 	descLabel:setPosition(ccp(iconBg:getContentSize().width*0.5 ,-iconBg:getContentSize().height*0.1-2))
-- 	iconBg:addChild(descLabel)

-- 	return iconBg
-- end

-- 通过对应的数据，得到小的图标
-- added by zhz
function getSmallSprite( items)

	local smallIconSp

	if(items.type == "silver") then
		-- 银币
		smallIconSp= CCSprite:create("images/common/coin.png")
	elseif(items.type == "soul") then
		-- 将魂
		smallIconSp= CCSprite:create("images/common/icon_soul.png")

	elseif(items.type == "gold") then
		-- 金币
		smallIconSp= CCSprite:create("images/common/gold.png")

	elseif(items.type == "item") then
		-- 物品
		local item_info= getItemById( tonumber(items.tid))
		local icon_small= item_info.icon_small
		smallIconSp =  CCSprite:create("images/base/item_small/" ..icon_small )

	elseif(items.type == "hero") then
		-- 英雄
		require "db/DB_Heroes"
	elseif(items.type == "prestige") then
		-- 声望
		smallIconSp= ItemSprite.getPrestigeSprite()

    elseif(items.type == "jewel") then
		-- 魂玉
		smallIconSp= CCSprite:create("images/common/soul_jade.png")

    elseif(items.type == "execution") then
		-- 体力
		smallIconSp= CCSprite:create("images/common/soul_jade.png")

    elseif(items.type == "stamina") then
		-- 耐力
		smallIconSp= CCSprite:create("images/common/soul_jade.png")
	end

	return smallIconSp

end




---------------------------------------- added by bzx
-- 通过物品ID来增减物品数量
function addItemCountByID(item_id, item_count)
    local item_data = ItemUtil.getCacheItemInfoBy(item_id)
    if item_data ~= nil then
        item_data.item_num = item_data.item_num + item_count
    end
end
----------------------------------------

-- 数据解析 后端17类型奖励
function getServiceReward( p_serviceData )
	local dataTab = {}
	for k,v in pairs(p_serviceData) do
		local data = {}
		data.type = v[1]
        data.id   = v[2]
        data.num  = v[3]
        table.insert(dataTab,data)
	end
    local retTab = getItemsDataByStr(nil,dataTab)
	return retTab
end







