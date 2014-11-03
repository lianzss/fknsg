--RivalInfoData.lua
-- Filename：	RivalInfoData.lua
-- Author：		zhz
-- Date：		2013-2-17
-- Purpose：		组队的数据层 

module ("RivalInfoData", package.seeall)

require "script/model/user/UserModel"
require "script/ui/guild/GuildDataCache"
require "db/DB_Heroes"
require "db/DB_Pet"


local _allFormationInfo	= {}				-- 所有的阵容信息
local _formationInfo ={}				-- 经过处理阵容信息
local _friendInfo	 ={}				-- 小伙伴信息， 可以为空
local _petInfo 		 ={}				-- 宠物信息	，可以为空
local _isNpc          = false

local _curIndex


-- 设置所有的宠物信息
function setAllFormationInfo( allFormationInfo )
	_allFormationInfo = allFormationInfo
end

function handleInfo(  )

	_formationInfo = {}	
	for i=1,#_allFormationInfo.squad do
		for k,v in pairs (_allFormationInfo.arrHero) do
			if( _allFormationInfo.squad[i] == v.hid) then
				table.insert(_formationInfo, v)
			end
		end
	end

	_curIndex =1
end


function setNpc( npc )
	_isNpc = npc
end

-- 得到上阵的宠物信息
function getFormationHeroInfo( ... )
	return _formationInfo
end

--[[
	@des 	:处理npc数据，uid为army表里的id

	@param 	:uid为army表的id
	@retrun : npc的数据
]]
function getNpcDataById( uid )

	require "db/DB_Army"
	require "db/DB_Team"
	require "db/DB_Monsters_tmpl"
	require "db/DB_Monsters"
	require "script/model/user/UserModel"
	local npcData = {}

	math.randomseed(os.time()) 
	
	npcData.level = UserModel.getHeroLevel()-- + math.random(-1,1)
	npcData.uname = DB_Army.getDataById(uid).display_name
	local  _tname = _tname or  DB_Army.getDataById(uid).display_name

	local monster_group= DB_Army.getDataById(uid).monster_group
	local monsterID = DB_Team.getDataById(monster_group).monsterID
	local monsterTable = lua_string_split(monsterID,",")
	local monsteRealTable = {}

	for k,v in pairs(monsterTable) do
		if(tonumber(v)~= 0) then
			table.insert(monsteRealTable, v)
		end
	end

	-- 查找DB_Monsters表，找到对应的htid
	local monsterHtidTable = {}
	for i=1,#monsteRealTable do
		local htid = DB_Monsters.getDataById(monsteRealTable[i]).htid
		table.insert(monsterHtidTable, htid)
	end

	-- 通过DB_Heroes表(  DB_Monsters_tmpl 里面没有对应的战斗力和血量生命的属性 )得到arrHero 里的所有英雄的数据
	local arrHero = {}
	for i=1,#monsterHtidTable do
		local heroTable= {}
		local tParam= {htid = monsterHtidTable[i], level = UserModel.getHeroLevel()  }
		local heroData = HeroFightSimple.getAllForceValues(tParam)
		heroTable.level =  UserModel.getHeroLevel()
		-- print("		=======  heroData  heroData    heroData    ")
		-- print_t(heroData)
		heroTable.physical_def= heroData.physicalDefend
		heroTable.magical_def = heroData.magicDefend
		heroTable.max_hp = heroData.life
		heroTable.evolve_level = 0
		heroTable.general_atk = heroData.generalAttack
		heroTable.fight_force = heroData.fightForce
		heroTable.equipInfo ={ arming ={},
								treasure = {},
								 skillBook= {},
								}
		heroTable.htid = monsterHtidTable[i]
		table.insert(arrHero, heroTable)
		_curIndex = 1

	end

	_formationInfo = arrHero
	return arrHero
	--_formationInfo = arrHero

end

-- 得到玩家总得战斗力
function getHeroFightForce( )
	
	local fightForce=0

	if(_isNpc == true) then
		fightForce = 0
		return fightForce
	end	

	for i=1, #_formationInfo do
		fightForce= fightForce +_formationInfo[i].fight_force
	end

	return fightForce
end


function setCurIndex(index )
	_curIndex = index
end



-- 计算武将的连携
function parseHeroUnionProfit( cur_Htid, link_group )
	require "db/DB_Heroes"
	local heroBaseHtid = cur_Htid

	require "db/DB_Union_profit"
	local s_link_arr = string.split(link_group, ",")
	local t_link_infos = {}
	for k, link_id in pairs(s_link_arr) do
		local t_union_profit = DB_Union_profit.getDataById(link_id)
		local link_info = {}
		link_info.dbInfo = t_union_profit
		link_info.isActive = IsjudgeUnion( link_id, heroBaseHtid )

		table.insert(t_link_infos, link_info)
	end

	return t_link_infos
end

-- 判断羁绊书否开启
function IsjudgeUnion( u_id, htid )
	local isActive = true
	if(_isNpc == true) then
		isActive = false
	end	

	local t_union_profit = DB_Union_profit.getDataById(u_id)
	local heroData= DB_Heroes.getDataById(htid)

	local card_ids = string.split(t_union_profit.union_card_ids, ",")

	for k,type_card in pairs(card_ids) do
		local type_card_arr = string.split(type_card, "|")
		if(tonumber(type_card_arr[1]) == 1)then
			if(tonumber(type_card_arr[2]) == 0)then
				-- if( not isMainHeroOnFormation() ) then
				isActive = false
				-- 	break
				-- end
				-- return false
			else
				if(isHeroOnFormation(tonumber(type_card_arr[2])) == false and isLittleFriendOn(tonumber(type_card_arr[2]))== false) then
					isActive = false
					break
				end

			end
		elseif(tonumber(type_card_arr[1]) == 2) then
			isActive = false
			if(hasTreasure(tonumber(type_card_arr[2])) == true) then
				isActive = true
				break
			end
			if(isActive == false) then
				if(hasEquipt(tonumber(type_card_arr[2]))== true ) then
					isActive= true
					break
				end
			end

		end
	end
		
	return isActive
end

-- --判断当前武将是否在场上
-- function isHeroOnFormation( htid)
-- 	local isOn= false
-- 	for k,formation in pairs(_formationInfo) do
-- 		if(tonumber(formation.htid) == tonumber(htid)  ) then
-- 			isOn = true
-- 			break
-- 		end
-- 	end
-- 	return isOn
-- end
--判断当前武将是否在场上
function isHeroOnFormation( htid)
	local isOn= false
	for k,formation in pairs(_formationInfo) do
		local modelId = DB_Heroes.getDataById(tonumber(formation.htid)).model_id
		if(tonumber(modelId) == tonumber(htid)  ) then
			isOn = true
			break
		end
	end
	return isOn
end

-- -- addBy chengliang
-- -- 通过htid判断小伙伴中是否存在某一类武将
-- function isLittleFriendOn( htid )
-- 	local isOn= false
-- 	local littleFriendInfo = _allFormationInfo.littleFriend

-- 	if( table.isEmpty(littleFriendInfo) ) then
-- 		return false
-- 	end

-- 	for i=1, #littleFriendInfo do
-- 		if( tonumber(littleFriendInfo[i].htid) == tonumber(htid)) then
-- 			isOn = true
-- 			break
-- 		end
-- 	end

-- 	return isOn

-- end
-- 通过htid判断小伙伴中是否存在某一类武将
function isLittleFriendOn( htid )
	local isOn= false
	local littleFriendInfo = _allFormationInfo.littleFriend

	if( table.isEmpty(littleFriendInfo) ) then
		return false
	end

	for i=1, #littleFriendInfo do
		local modelId = DB_Heroes.getDataById(tonumber(littleFriendInfo[i].htid)).model_id
		if( tonumber(modelId) == tonumber(htid)) then
			isOn = true
			break
		end
	end

	return isOn

end


-- 获得ItemSprite，显示头像和等级 
function getItemSprite(armTable )
	local ItemSprite = ItemSprite.getItemSpriteById(armTable.item_template_id,nil,itemDelegateAction, nil,-1011,19001)

	local equipDesc = ItemUtil.getItemById(tonumber(armTable.item_template_id))
	local nameColor = HeroPublicLua.getCCColorByStarLevel(equipDesc.quality)

	-- 强化等级
	local lvSprite = CCSprite:create("images/base/potential/lv_" .. equipDesc.quality .. ".png")
	lvSprite:setAnchorPoint(ccp(0,1))
	lvSprite:setPosition(ccp(-1, ItemSprite:getContentSize().height))
	ItemSprite:addChild(lvSprite)
	local armReinforceLevel =  tonumber(armTable.va_item_text.armReinforceLevel)   or 0
	local lvLabel =  CCRenderLabel:create("" .. armReinforceLevel , g_sFontName, 18, 1, ccc3( 0, 0, 0), type_stroke)
    lvLabel:setColor(ccc3(255,255,255))
    lvLabel:setAnchorPoint(ccp(0.5,0.5))
    lvLabel:setPosition(ccp( lvSprite:getContentSize().width*0.5, lvSprite:getContentSize().height*0.5))
    lvSprite:addChild(lvLabel)

    return ItemSprite
end

function getTreasureItem( treasureTable )
	local ItemSprite = ItemSprite.getItemSpriteById(treasureTable.item_template_id,nil,itemDelegateAction, nil,-1011,19001)

	local equipDesc = ItemUtil.getItemById(tonumber(treasureTable.item_template_id))
	local nameColor = HeroPublicLua.getCCColorByStarLevel(equipDesc.quality)

	-- 强化等级
	local lvSprite = CCSprite:create("images/base/potential/lv_" .. equipDesc.quality .. ".png")
	lvSprite:setAnchorPoint(ccp(0,1))
	lvSprite:setPosition(ccp(-1, ItemSprite:getContentSize().height))
	ItemSprite:addChild(lvSprite)
	local armReinforceLevel =  tonumber(treasureTable.va_item_text.treasureLevel)  or 0
	local lvLabel =  CCRenderLabel:create("" .. armReinforceLevel , g_sFontName, 18, 1, ccc3( 0, 0, 0), type_stroke)
    lvLabel:setColor(ccc3(255,255,255))
    lvLabel:setAnchorPoint(ccp(0.5,0.5))
    lvLabel:setPosition(ccp( lvSprite:getContentSize().width*0.5, lvSprite:getContentSize().height*0.5))
    lvSprite:addChild(lvLabel)

    if(treasureTable.va_item_text.treasureEvolve) then
    	local evolve_level = math.ceil(treasureTable.va_item_text.treasureEvolve)
		local treasureEvolveLabel = CCRenderLabel:create(evolve_level,  g_sFontName , 21, 2, ccc3( 0x00, 0x00, 0x00), type_stroke)
		treasureEvolveLabel:setColor(ccc3(0x00, 0xff, 0x18))
		treasureEvolveLabel:setAnchorPoint(ccp(1, 0))
		treasureEvolveLabel:setPosition(ccp( ItemSprite:getContentSize().width*0.9, ItemSprite:getContentSize().height*0.05))
		ItemSprite:addChild(treasureEvolveLabel)

		-- 精炼等级
		local treasureEvolveSprite = CCSprite:create("images/common/gem.png")
		treasureEvolveSprite:setAnchorPoint(ccp(1, 0))
		treasureEvolveSprite:setPosition(ccp(ItemSprite:getContentSize().width*0.9 - treasureEvolveLabel:getContentSize().width, ItemSprite:getContentSize().height*0.05))
		ItemSprite:addChild(treasureEvolveSprite)
    end

    return ItemSprite
end


-- 得到战魂的按钮
function getFightSoulItem( fightSoul)
	
	-- print("fightSoul is :++++++++++++++++++++++ ")
	-- print_t(fightSoul)
	local ItemSprite= ItemSprite.getItemSpriteById(fightSoul.item_template_id,nil,itemDelegateAction, nil,-1011,19001,nil,nil,false)
	local equipDesc = ItemUtil.getItemById(tonumber(fightSoul.item_template_id))
	local nameColor = HeroPublicLua.getCCColorByStarLevel(equipDesc.quality)
	local e_nameLabel =  CCRenderLabel:create(equipDesc.name , g_sFontName, 20, 2, ccc3( 0x00, 0x00, 0x00), type_stroke)
    e_nameLabel:setColor(nameColor)
    e_nameLabel:setAnchorPoint(ccp(0.5, 0))
    e_nameLabel:setPosition(ccp( ItemSprite:getContentSize().width/2, -ItemSprite:getContentSize().height*0.1))
    ItemSprite:addChild(e_nameLabel, 111)

    local lvSprite = CCSprite:create("images/common/f_level_bg.png")
	lvSprite:setAnchorPoint(ccp(0,0))
	lvSprite:setPosition(ccp(ItemSprite:getContentSize().width*0.5, ItemSprite:getContentSize().height*0))
	ItemSprite:addChild(lvSprite,11)
	-- 等级
	local lvLabel = CCRenderLabel:create( fightSoul.va_item_text.fsLevel ,  g_sFontName , 18, 2, ccc3( 0x00, 0x00, 0x00), type_stroke)
	lvLabel:setColor(ccc3(0xff, 0xff, 0xff))
	lvLabel:setAnchorPoint(ccp(0.5, 0.5))
	lvLabel:setPosition(ccp( lvSprite:getContentSize().width*0.45, lvSprite:getContentSize().height*0.6))
	lvSprite:addChild(lvLabel)
    return ItemSprite
end


function hasTreasure( item_template_id)
	local isHas = false

	if( not table.isEmpty(_formationInfo[_curIndex].equipInfo) and not table.isEmpty(_formationInfo[_curIndex].equipInfo.treasure) ) then
		for k, treasure in pairs(_formationInfo[_curIndex].equipInfo.treasure) do
			-- print("treasure item_template_id is : ", treasure.item_template_id)
			if(tonumber( treasure.item_template_id) == tonumber(item_template_id)) then
				isHas = true
				break
			end
		end
	end
	return isHas
end

-- 判断当前的武将是否装备的该装备
function hasEquipt( item_template_id)
	local isHas = false

	if( not table.isEmpty(_formationInfo[_curIndex].equipInfo)  and  not table.isEmpty(_formationInfo[_curIndex].equipInfo.arming) ) then
		for k, equipt in pairs(_formationInfo[_curIndex].equipInfo.arming) do
			if(tonumber( equipt.item_template_id) == tonumber(item_template_id)) then
				isHas = true
				break
			end
		end
	end
	-- print("isHas  is : equipt  " ,isHas)
	-- print("item_template_id is : ", item_template_id)
	return isHas
end

-- 得到小伙伴的icon
function getFriendItem(  )

	local potentialBgName = "images/formation/potential/officer_11.png"
	local  headIconName = "images/formation/littlef_icon.png"

	local frame= CCSprite:create(potentialBgName)
	local headIcon= CCSprite:create(headIconName)
	headIcon:setPosition(ccp(frame:getContentSize().width/2, frame:getContentSize().height/2))
	headIcon:setAnchorPoint(ccp(0.5,0.5))
	frame:addChild(headIcon)

	local headItem= CCMenuItemSprite:create(frame, frame)

	return headItem

end


-- 得到宠物的icon
function getPetItem(  )

	local potentialBgName = "images/formation/potential/officer_11.png"
	local  headIconName = "images/pet/chongwu.png"

	local frame= CCSprite:create(potentialBgName)
	local headIcon= CCSprite:create(headIconName)
	headIcon:setPosition(ccp(frame:getContentSize().width/2, frame:getContentSize().height/2))
	headIcon:setAnchorPoint(ccp(0.5,0.5))
	frame:addChild(headIcon)

	local headItem= CCMenuItemSprite:create(frame, frame)

	return headItem

end



-- 判断主角是否上阵
function isMainHeroOnFormation( )
	local isOn=false
	for k,formation in pairs(_formationInfo) do
		if(tonumber(formation.htid) == 20001 or tonumber(formation.htid) == 20002 ) then
			isOn= true
			return isOn
		end
	end
	return isOn
end


function getMainHeroInfo( )
	local mainHeroInfo = {}
	for i=1, #_formationInfo do
		if( HeroModel.isNecessaryHero(tonumber( _formationInfo[i].htid)) ) then
			mainHeroInfo= _formationInfo[i]
			break
		end
	end
	return mainHeroInfo
end

-- 判断是否有小伙伴
--策划要求修改小伙伴，因此，除了宠物一直都是true
function hasFriend( )
	local has= false

	if( _isNpc) then
		return false
	end

	if(  not table.isEmpty(_allFormationInfo) and not table.isEmpty(_allFormationInfo.littleFriend ) ) then
		has = true
	end
	return true
end


-- 得到小伙伴信息，
function getFreiendInfo( )

	return  _allFormationInfo.littleFriend
end



--[[
	@des 	:得到该位置上的hid  hid为0时改位置没有上阵武将
	@param 	:position:位置 从1开始 1-6
	@return :返回hid，   >0 是英雄hid，0是没有英雄，-1是未开启
--]]
function getHeroInfoFromPosition( position )
	local heroInfo= {} 
	heroInfo.hid = -1
	local data = _allFormationInfo.littleFriend --getLittleFriendeData()
	print("getHeroInfoFromPosition")
	print_t(_allFormationInfo.littleFriend)
	if(data == nil)then
		return heroInfo
	end
	for i=1, #data do

		if( tonumber(data[i].position)+1 == position) then
			heroInfo= data[i]
			heroInfo.localInfo= DB_Heroes.getDataById(tonumber(heroInfo.htid) )
		end
	end

	-- for k,v in pairs(data) do
	-- 	if(tonumber(k) == tonumber(position))then
	-- 		hid = tonumber(v)
	-- 	end
	-- end
	return heroInfo
end



--[[
	@des 	:得到该位置的开启等级
	@param 	:position:位置 从1开始 1-6
	@return :lv -1:配置中没有开放该位置
--]]
function getOpenLv( position )
	local lv = -1
	require "db/DB_Formation"
	local data = DB_Formation.getDataById(1)
	local tab = string.split(data.openFriendByLv,",")
	for k,v in pairs(tab) do
		local t_data = string.split(v,"|")
		-- print("position",position,"t_data[2]",t_data[2])
		if(tonumber(position) == tonumber(t_data[2]))then
			lv = tonumber(t_data[1])
			break
		end
	end
	-- print("lv",lv)
	return lv
end



--[[
	@des 	:得到该位置是否开启
	@param 	:position:位置 从1开始 1-6
	@return :开启ture，没开启false
--]]
function getIsOpenThisPosition( position )
	local mainHeroInfo= getMainHeroInfo()
	local heroLv = tonumber(mainHeroInfo.level) or UserModel.getHeroLevel()
	local openLv = getOpenLv(position)
	if(openLv == -1 or heroLv < openLv)then
		return false
	else
		return true
	end
end


-- 策划要求修改宠物，因此，除了宠物一直都是true
-- 
function hasPet( )
	local has= false

	if( _isNpc) then
		return false
	end

	if( not table.isEmpty(_allFormationInfo) and not table.isEmpty(_allFormationInfo.arrPet) ) then
		has= true
	end

	-- return has
	return true
end

--  得到上阵宠物的信息
function getPetInfo(  )


	local petInfo=  _allFormationInfo.arrPet[1]
	if(petInfo == nil) then
		return nil
	else
		petInfo.petDesc= DB_Pet.getDataById(petInfo.pet_tmpl)
	end
	return petInfo
end

-- 得到增加的宠物技能
function getAddSkillByTalent( )
	local addSkill= {addNormalSkillLevel = 0, addSpecialSkillLevel=0 }

	local skillTalent = _allFormationInfo.arrPet[1].arrSkill.skillTalent

	for i=1, #skillTalent do
		local petSkill= tonumber(skillTalent[i].id)
		local skillData= DB_Pet_skill.getDataById(petSkill)
		if(skillData.addNormalSkillLevel ) then
				addSkill.addNormalSkillLevel= addSkill.addNormalSkillLevel+ tonumber(skillData.addNormalSkillLevel) 
		end

		if(skillData.addSpecialSkillLevel ) then
			addSkill.addSpecialSkillLevel= addSkill.addSpecialSkillLevel+ tonumber(skillData.addSpecialSkillLevel)
		end
	end

	return addSkill

end

--获得宠物的加成属性
function getPetValue( )


	local petProperty= {}

	if( table.isEmpty(_allFormationInfo.arrPet[1]) or _allFormationInfo.arrPet[1]== nil ) then
		return petProperty
	end

	local petInfo= _allFormationInfo.arrPet[1]
	local skillNormal = petInfo.arrSkill.skillNormal
	local addNormalSkillLevel = getAddSkillByTalent().addNormalSkillLevel

	local retTable= {}
	local tInfo = {}
	

	for i=1, table.count(skillNormal) do
		local skillId, level = tonumber(skillNormal[i].id), tonumber(skillNormal[i].level)+addNormalSkillLevel

		if(skillId >0) then	
			local skillProperty= PetUtil.getNormalSkill(skillId, level ) 
			table.insert(tInfo , skillProperty)
		end
	end

	for i=1,#tInfo do
		for j=1,#tInfo[i] do
			local v = tInfo[i][j]
			if(retTable[tostring(v.affixDesc[1])] == nil) then
				retTable[tostring(v.affixDesc[1])] = v
			else
				retTable[tostring(v.affixDesc[1])].realNum = retTable[tostring(v.affixDesc[1])].realNum + v.realNum
				retTable[tostring(v.affixDesc[1])].displayNum = retTable[tostring(v.affixDesc[1])].displayNum + v.displayNum
			end
			-- if(retTable[] )
			
		end
	end

	for k,v in pairs( retTable) do
		table.insert(petProperty, v)
	end
	return petProperty
end

-- 得到宠物战斗力，前端显示用
function getPetFightForce( )

	local fightForceNumber = 0

	local petInfo= _allFormationInfo.arrPet[1]
	local skillNormal = petInfo.arrSkill.skillNormal
	local skillNormal = petInfo.arrSkill.skillNormal
	local skillTalent = petInfo.arrSkill.skillTalent
	local skillProduct= petInfo.arrSkill.skillProduct

	-- 普通技能
	for i=1, table.count( skillNormal) do
		local skillId= tonumber(skillNormal[i].id)
		if( skillId ~= 0 and DB_Pet_skill.getDataById(skillId).fightForce) then
			local fightForce = DB_Pet_skill.getDataById(skillId).fightForce
			fightForce= fightForce* tonumber(skillNormal[i].level )
			fightForceNumber= fightForceNumber+ fightForce
		end
	end

	-- 特殊技能
	for i=1, table.count( skillProduct) do
		local skillId= tonumber(skillProduct[i].id)
		if( skillId ~= 0 and DB_Pet_skill.getDataById(skillId).fightForce) then
			local fightForce = DB_Pet_skill.getDataById(skillId).fightForce
			fightForce= fightForce* tonumber(skillProduct[i].level )
			fightForceNumber= fightForceNumber+ fightForce
		end
	end

	-- 天赋技能
	for i=1, table.count( skillTalent) do
		local skillId= tonumber(skillTalent[i].id)
		if( skillId ~= 0 and DB_Pet_skill.getDataById(skillId).fightForce) then
			local fightForce = DB_Pet_skill.getDataById(skillId).fightForce
			fightForce= fightForce* tonumber(skillTalent[i].level )
			fightForceNumber= fightForceNumber+ fightForce
		end
	end

	return fightForceNumber

end






