-- Filename：	PetData.lua
-- Author：		zhz
-- Date：		2014-3-31
-- Purpose：		宠物的数据层

module("PetData", package.seeall)

require "db/DB_Pet"
require "db/DB_Pet_skill"
require "db/DB_Vip"
require "script/model/user/UserModel"
require "script/ui/pet/PetUtil"
require "script/ui/item/ItemUtil"

local _allPetInfo 	= {}			-- 所有宠物的信息
local _formationPetInfo= {}


function setAllPetInfo(petInfo )
	--petInfo结构 摘自 后端文档
	--array(
	--		petInfo =>array(
	--			'petid => array (
	--				'petid' => int,宠物id
    -- 				'pet_tmpl' => int, 宠物模板id
    -- 				'level' => int ,宠物等级
    -- 				'exp' => int ,宠物经验
    -- 				'swallow' => int, 已经吞噬宠物的数量
    -- 				'skill_point' => int, 宠物拥有的技能点
    -- 				'va_pet' => array(
    --					skillTalent => array(0 => array(id => 0, level => int, status => int)),
    --                  skillNormal => array(0 => array(id => 0level => int, status => int)),
    --                  skillProduct => array(0 => array(id => 0, level => int, status => int)),
    --				), 宠物技能相关
	--			),
	--		),
	--		keeperInfo =>array(
	--			pet_slot => int,宠物仓库已开启数量
    --          va_keeper => array(
    --          	0 => array(
    --					petid => int, 
    --					status => int[0未出战1已出战], 
    --					producttime => int, 
    --					traintime => int
    --				)
	--			),拥有者信息
    --		),
	--);
	_allPetInfo = petInfo
end

-- 
function getAllPetInfo(  )
	return _allPetInfo
end

-- 得到第一个宠物的信息
function getFirstPetInfo( )
	
end

-- 把宠物信息加到_allPetInfo
function addPetInfo( petData)

	print("petData++++++++++++++++++++++ ")
	print_t(petData)
	_allPetInfo.petInfo["" .. petData.petid]= petData
end

-- 增加宠物的上阵栏位
function addPetSetpet( )
	local tempTable= {
				petid =0,
				status=0,
				producttime =0,
		}
		table.insert(_allPetInfo.keeperInfo.va_keeper.setpet, tempTable )
end

--获得背包大小
function getOpenBagNum()
	return tonumber(_allPetInfo.keeperInfo.keeper_slot)
end

--增加背包大小
function  addOpenBagNum(addNum)
	_allPetInfo.keeperInfo.keeper_slot = tonumber(_allPetInfo.keeperInfo.keeper_slot) + tonumber(addNum)
end

--目前宠物的数量
function getPetNum()
	return tonumber(table.count(_allPetInfo.petInfo))
end

--得到背包中所有宠物的信息
function getAllBagPetInfo()
	return _allPetInfo.petInfo
end

--通过模板id获得宠物名字
function getPetNameByTid(ptid)
	local petData = DB_Pet.getDataById(ptid)
	return petData.roleName
end

--通过模板id获得宠物的品质
function getPetQualityByTid(ptid)
	local petData = DB_Pet.getDataById(ptid)
	return petData.quality
end

-- 通过petId 修改宠物的等级
function setPetLevelByPetId( petId)
	
end


-- 得到上阵的宠物信息
function getFormationPetInfo()

	_formationPetInfo = {}

	local setpet = _allPetInfo.keeperInfo.va_keeper.setpet

	for i=1,table.count(setpet) do
		if(tonumber(setpet[i].petid)== 0) then
			local tempTable= {}
			tempTable.setpet= setpet[i]
			tempTable.showStatus=2
			table.insert( _formationPetInfo,tempTable )
		else	
			for petid, petInfo in pairs(_allPetInfo.petInfo) do
				if( tonumber(setpet[i].petid ) == tonumber(petid)) then
					local tempTable= {}
					tempTable= petInfo
					tempTable.showStatus = 1
					tempTable.setpet =setpet[i]
					tempTable.petDesc=  DB_Pet.getDataById(tonumber(petInfo.pet_tmpl ) )
					table.insert(_formationPetInfo ,tempTable)
				end
			end
		end	
	end

	if( table.count(setpet)< PetUtil.getMaxFormationNum() ) then
		local tempTable= {}
		tempTable.showStatus=3
		tempTable.setpet = {}
		table.insert( _formationPetInfo,tempTable )
	end
	
	-- print("=======================getFormationPetInfo ===================== ")
	-- print_t(_allPetInfo)
	return _formationPetInfo
end

-- 得到通过宠物的petId来获得可以喂养或是学习技能的宠物信息
function getFormationPetById( id)

	local _singlePetInfo={}
	local id= tonumber(id)

	local formationPetInfo = getFormationPetInfo()

	for i=1, #formationPetInfo do
		if(id == tonumber(formationPetInfo[i].petid)) then
			_singlePetInfo= formationPetInfo[i]
			break
		end
	end

	if(table.isEmpty(_singlePetInfo)) then

		local petInfo = getPetInfoById(id)
		_singlePetInfo= petInfo
		_singlePetInfo.showStatus =4

		-- local setpet= {}
	end

	return _singlePetInfo

end

--  设置普通技能状态
function setNormalSkillStatus( petId, normalId,status)
	local petInfo = getPetInfoById(petId)

	local normalId = tonumber(normalId)
	for i=1, table.count(petInfo.va_pet.skillNormal ) do
		if( tonumber(normalId) == tonumber( petInfo.va_pet.skillNormal[i].id ) ) then
			petInfo.va_pet.skillNormal[i].status=status
			break
		end
	end
end

-- 得到宠物已经锁的技能
function getLockSkillNum( petId)
	local petInfo = getPetInfoById(petId)
	local number= 0

	for i=1, table.count(petInfo.va_pet.skillNormal) do
		if( tonumber( petInfo.va_pet.skillNormal[i].status)==1 ) then
			number= number+1
		end
	end

	return number
end

-- 得到宠物在第几个上阵栏位，从0 开始
function getPosIndexById(id)
	local formationPetInfo = getFormationPetInfo()

	local id = tonumber(id)
	local posIndex =0

	for i=1, table.count(formationPetInfo) do

		if(id == tonumber( formationPetInfo[i].petid )) then
			posIndex = i-1
		end
	end
	return posIndex
end

-- 按照宠物的id,来修改技能点
function addPetSKillPointById( id, number)
	
	local number = number or 1
	local petId= tonumber(id)
	local petInfo = getPetInfoById(id)

	petInfo.skill_point = tonumber(petInfo.skill_point)+ tonumber(number) 

end

-- 通过宠物的上阵栏位获得宠物的信息
function getPetInfoByPos(posIndex )
	local formationPetInfo = getFormationPetInfo()

	local i=tonumber(posIndex)+1

	return  formationPetInfo[i]
end

-- 得到出战宠物的栏位，从0开始
function getUpPosIndex( ... )
	local posIndex = nil
	local setpet = _allPetInfo.keeperInfo.va_keeper.setpet

	for i=1, table.count(setpet ) do

		if( tonumber(setpet[i].status )== 1) then
			posIndex= i-1
			break
		end
	end
	return posIndex
end



-- 通过宠物的petId 修改宠物出战的状态
function setFightStatusById( petId )
	local petId = tonumber(petId)

	local setpet= _allPetInfo.keeperInfo.va_keeper.setpet
	for i=1, table.count(setpet) do
		if( petId == tonumber(setpet[i].petid )) then
			_allPetInfo.keeperInfo.va_keeper.setpet[i].status=1
		else
			_allPetInfo.keeperInfo.va_keeper.setpet[i].status=0
		end
	end
end

-- 修改宠物的生产时间
function setProducttimeById( id ,time)
	
	for i=1, table.count(_allPetInfo.keeperInfo.va_keeper.setpet ) do

		if(id == tonumber( _allPetInfo.keeperInfo.va_keeper.setpet[i].petid)) then
			_allPetInfo.keeperInfo.va_keeper.setpet[i].producttime = time
			break
		end
	end

end

-- 得到可以上阵宠物的数量
function getMaxForamtionNum( ... )
	return table.count(_allPetInfo.keeperInfo.va_keeper.setpet)
end

-- 得到已经上阵的宠物数量
function getFormationNum( )

	local number=0
	local setpet= _allPetInfo.keeperInfo.va_keeper.setpet
	for i=1, table.count(setpet) do
		if( tonumber( setpet[i].petid)~= 0) then
			number=number+1
		end
	end
	return number
end

-- 通过ID获得宠物的信息
function getPetInfoById(id )
	local id=tonumber(id)

	for petId, petInfo in pairs( _allPetInfo.petInfo) do
		if( id == tonumber(petId) ) then
			return petInfo
		end
	end
	return nil
end

function setPetInfoById(id ,petData)
	local id=tonumber(id)

	print("id is :", id)

	for petId, petInfo in pairs( _allPetInfo.petInfo) do
		if( id == tonumber(petId) ) then
			_allPetInfo.petInfo["" .. petId] =petData
		end
	end
end

--通过pid得到单个宠物的战斗力 
function getPetSingleFightValue(pid)
	return 0
end


-- 得到可以上阵的宠物
function getPetCanFormation( )
	local canFormationPetInfo= {}
	for petId, petInfo in pairs( _allPetInfo.petInfo) do
		if( isPetUpByid(petId) == false) then
			table.insert(canFormationPetInfo ,petInfo)
		end
	end
	return canFormationPetInfo
end

-- 通过petTid和 petId得到可以吞噬的宠物数据
-- 首先要除掉上阵的宠物
function getCanSwallowPetInfoByTid( petId)
	
	local upPetId= nil
	local curPetInfo = getPetInfoById(tonumber(petId))
	local petTid= tonumber( curPetInfo.pet_tmpl )

	local canSwallowPetInfo= {}
	local setpet= _allPetInfo.keeperInfo.va_keeper.setpet

	local formationPetInfo = getFormationPetInfo()

	-- for i=1, table.count(formationPetInfo) do
	-- 	if( petTid == tonumber(formationPetInfo[i].pet_tmpl)) then
	-- 		upPetId = tonumber(formationPetInfo[i].petid) 
	-- 		break
	-- 	end
	-- end

	print("upPetId is :", upPetId)
	print("petTid  is :", petTid)

	--
	for petid,petInfo in pairs(_allPetInfo.petInfo) do
		-- if( upPetId ~= tonumber( petInfo.petid ) and petTid == tonumber(petInfo.pet_tmpl) ) then
		if(  isPetUpByid( petInfo.petid) == false ) then
			if(  petTid == tonumber(petInfo.pet_tmpl) or ( petTid ~= tonumber(petInfo.pet_tmpl) and tonumber(petInfo.exp)>0 ) ) then
				local tempTable= {}
				tempTable= petInfo
				tempTable.showStatus = 4
				tempTable.petDesc=  DB_Pet.getDataById(tonumber(petInfo.pet_tmpl))
				table.insert(canSwallowPetInfo,tempTable)
			end
		end
	end	

	local function sort(w1,w2 )
		if( tonumber(w1.pet_tmpl)<tonumber(w2.pet_tmpl) ) then
			return true
		end
	end

	table.sort(canSwallowPetInfo, sort)
	return canSwallowPetInfo
end

-- 得到所有可以购买的宠物信息
function getCanSellPetInfo( )
	
	local canSellPetInfo= {}
	for petid,petInfo in pairs(_allPetInfo.petInfo) do
		
		if(  isPetUpByid( petInfo.petid) == false and  tonumber(petInfo.level)<=20 ) then
			local tempTable= {}
			tempTable= petInfo
			tempTable.showStatus = 4
			tempTable.petDesc=  DB_Pet.getDataById(tonumber(petInfo.pet_tmpl))
			table.insert(canSellPetInfo,tempTable)
		end
	end	

	local function sort(w1, w2)
		
		if tonumber(w1.petDesc.quality) < tonumber(w2.petDesc.quality) then
			return true
		elseif tonumber(w1.petDesc.quality) == tonumber(w2.petDesc.quality) then
			if tonumber(w1.level) < tonumber(w2.level) then
				return true
			elseif( tonumber(w1.level) == tonumber(w2.level) ) then --and tonumber(w1.petDesc.id) < tonumber(w1.petDesc.id) )then
				if( tonumber(w1.petDesc.id) < tonumber(w2.petDesc.id) ) then
					return true
				else
					return false
				end	
			end	
		else
			return false	
		end
	end	

	table.sort(canSellPetInfo, sort)

	return canSellPetInfo
end

-- 得到卖掉一个宠物所得到的银币。
function getSoldSliverByPetInfo( petId)
	if( petId==nil ) then
		print("error !")
		return
	end

	local petInfo= getPetInfoById(tonumber(petId))
	-- print(" petInfo petInfo petInfo ")
	-- print_t(petInfo)

	local level = tonumber(petInfo.level)
	local pet_tmpl =tonumber(petInfo.pet_tmpl)

	-- print(" pet_tmpl  is ............ ", pet_tmpl)	
	local sellSilver= DB_Pet.getDataById(pet_tmpl).sellSilver
	sellSilver= lua_string_split( sellSilver,",")

	local soldSliver= tonumber(sellSilver[1])+ tonumber(sellSilver[2])*(level-1)
	return soldSliver
end



-- 通过宠物的ID，删除宠物
function removePetById(petId )
	if(petId== nil ) then
		return
	end
	_allPetInfo.petInfo[tostring(petId)] = nil 
end

-- 通过被吞噬的宠物的ID，得到可以增加的skill_point
-- 吞噬不同种宠物，被吞噬的宠物的技能点，不加到被吞噬的宠物身上。
function getAddPoint( petId, swallowPetId)

	local petInfo = getPetInfoById(tonumber(petId))
	local curPetTmpl, swallowNum=tonumber( petInfo.pet_tmpl) , petInfo.swallow 
	local PetData = DB_Pet.getDataById(tonumber(curPetTmpl) )
	local swallowedPetInfo = getPetInfoById(tonumber(swallowPetId ))
	local expUpgradeID= PetData.expUpgradeID

	local orginPetExp = tonumber(petInfo.exp)
	local originLv = tonumber(petInfo.level )

    local swallowExp = swallowedPetInfo.exp
    -- local PetData= DB_Pet.getDataById(  tonumber(swallowedPetInfo.pet_tmpl))
   	local allExp= tonumber(petInfo.exp )+ tonumber(swallowedPetInfo.exp)

    local curLv,curExp,needExp = LevelUpUtil.getObjectCurExp(PetData.expUpgradeID,allExp)


    if(curLv >UserModel.getHeroLevel() ) then
    	curLv = UserModel.getHeroLevel()
    end

    print("originLv, curLv,tonumber( petInfo.pet_tmpl) ",originLv, curLv,tonumber( petInfo.pet_tmpl))
    local levelPoint = PetUtil.getAddSkillPoint(originLv, curLv,tonumber( petInfo.pet_tmpl) )
    local swallowPoint = PetData.swallow*(tonumber(swallowedPetInfo.swallow )+1 )

    -- 如果，吞噬的宠物 何被吞噬的宠物的是不同种宠物， 那么 swallowPoint 不加。
    if( tonumber(petInfo.pet_tmpl) ~= tonumber(swallowedPetInfo.pet_tmpl) ) then
    	swallowPoint = 0
    end

    local addPoint= levelPoint+ swallowPoint

    return addPoint, curLv, allExp

end

-- 得到当前宠物有技能的数量
function getSkillNum( petId )
	local petInfo= getPetInfoById( tonumber(petId))

	local number= 0
	for i=1, table.count( petInfo.va_pet.skillNormal ) do
		if( tonumber(petInfo.va_pet.skillNormal[i].id)>0  ) then
			number= number+1
		end
	end
	return number
end


-- 判断宠物是否上阵
-- 返回宠物是否上阵，还在阵上的id
function isPetUpByid( petId )

	local setpet= _allPetInfo.keeperInfo.va_keeper.setpet
	local petId = tonumber(petId) 

	local formationPetInfo = getFormationPetInfo()

	for i=1, table.count(formationPetInfo) do
		if( formationPetInfo[i].petid and petId ==  tonumber(formationPetInfo[i].petid) ) then
			return true
		end
	end
	return false
end


-- 判断阵上是否有相同类型的宠物
function isPetUpByPetTmpl ( petTmpl)

	local petTmpl = tonumber(petTmpl)

	local petData= DB_Pet.getDataById(petTmpl)

	local petResourceType=petData.petResourceType

	local formationPetInfo = getFormationPetInfo()

	for i=1, table.count(formationPetInfo) do
		if( formationPetInfo[i].pet_tmpl and petResourceType ==  tonumber(formationPetInfo[i].petDesc.petResourceType ) ) then
			return true
		end
	end
	return false
end

-- 得到出战宠物的petid, 函数名命名的不好，和上阵有重复，都用up了。
function getUpPetId(  )
	local petId= 0
	local setpet= _allPetInfo.keeperInfo.va_keeper.setpet
	for i=1, table.count(setpet) do
		if(tonumber(setpet[i].status )== 1 ) then
			petId= tonumber(setpet[i].petid )
		end
	end

	return petId
end

-- 判断天赋技能是否有效
-- 原来的天赋技能只有宠物出战才有效果，现在是只要宠物上阵便有效果
function isSkillEffect( petSkill,petId)

	local petSkill = tonumber(petSkill)
	local upPetId = getUpPetId()

	-- 原来是判断宠物是否上阵的。
	if( petSkill == 0 ) then -- or  tonumber(petId)~= upPetId
		return false
	end

	-- print("isPetUpByid(petId)  isPetUpByid(petId) ", isPetUpByid(petId))
	-- 如果宠物不上阵
	if( isPetUpByid(petId)== false) then
		return
	end

	local formationPetInfo = getFormationPetInfo()

	local skillData = DB_Pet_skill.getDataById(tonumber(petSkill))
	local isSpecial = skillData.isSpecial
	local specialCondition = lua_string_split(skillData.specialCondition,",")
	local petInfo= getPetInfoById(tonumber(petId))
	local setpet= _allPetInfo.keeperInfo.va_keeper.setpet

	-- print("specialCondition specialCondition specialCondition")
	-- print_t(specialCondition)
	-- print("setpet setpet setpet")
	-- print_t(setpet)

	local isEffect= true

	if( isSpecial==0 or isSpecial== nil) then
		isEffect =true
	elseif(isSpecial ==1) then

		isEffect = isEffectOnSpecial_1(petSkill, petId )
	elseif(isSpecial == 2) then
		local countTable= {}
		for i=1, #specialCondition do
			countTable[i]= false
		end

		for i=1,#specialCondition do
			for j=1, table.count(setpet) do
				if(tonumber(setpet[j].petid)~= 0 ) then
					local uppetInfo = getPetInfoById(tonumber(setpet[j].petid ))
					if( tonumber(specialCondition[i]) == tonumber(uppetInfo.pet_tmpl) ) then
						countTable[i]= true
					end
				end
			end
		end

		for i=1, table.count(countTable) do
			if(countTable[i]== false ) then
				isEffect= false
			end
		end

		-- print("countTable countTable countTable")
		-- print_t(countTable)

	end


	return isEffect
end


-- isSpecial== 1时，则该接口为 宠物技能ID1，宠物技能ID2，宠物技能ID3……的形式，表示需要同时拥有以上几个技能才可以激活该技能
function isEffectOnSpecial_1( petSkill,petId )

	local skillData = DB_Pet_skill.getDataById(tonumber(petSkill))
	local isSpecial = skillData.isSpecial
	local specialCondition = lua_string_split(skillData.specialCondition,",")
	local petInfo= getPetInfoById(tonumber(petId))

	local isEffect= true

	local hasSkill= {}

	for i=1,table.count(petInfo.va_pet.skillNormal ) do
		table.insert(hasSkill,  petInfo.va_pet.skillNormal[i] )
	end

	for i=1, table.count(petInfo.va_pet.skillProduct ) do
		table.insert(hasSkill,  petInfo.va_pet.skillProduct[i] )
	end

	local countTable = {}
	for i=1, #specialCondition do
		countTable[i]= false
	end

	-- print("hasSkill ............................................................ ")
	-- print_t(hasSkill)

	-- print("specialCondition specialCondition specialCondition")
	-- print_t(specialCondition)


	for i=1,#specialCondition do
		for j=1, table.count(hasSkill) do
			if(tonumber(hasSkill[j].id)~= 0 ) then
				if( tonumber(specialCondition[i]) == tonumber(hasSkill[j].id) ) then
					countTable[i]= true
				end
			end
		end
	end

	for i=1, table.count(countTable) do
		if(countTable[i]== false ) then
			isEffect= false
		end
	end


	-- print("countTable countTable countTable")
	-- print_t(countTable)

	return isEffect
end

-- 得到上阵宠物天赋技能的加成,
function getAddSkillByTalent(petId)


	local addSkill= {addNormalSkillLevel = 0, addSpecialSkillLevel=0 }
	local formationPetInfo = getFormationPetInfo()
	-- print("formationPetInfo ............................. ")
	-- print_t(formationPetInfo)
	local petId= tonumber(petId)

	local upPetId = getUpPetId()

	-- 判断宠物是否出战
	-- if( tonumber(petId)~= upPetId) then --
	-- 	return addSkill
	-- end

	-- print(" isPetUpByid(petId)  isPetUpByid(petId) " ,  isPetUpByid(petId))

	-- 判断宠物的天赋技能是否有效
	if( isPetUpByid(petId)== false) then
		return addSkill
	end

	local skillTalent = {}
	local upPetId= nil -- 上阵宠物的id

	-- for i=1, table.count(formationPetInfo) do
	-- 	local status=  formationPetInfo[i].setpet.status
		-- if(status and tonumber(status) ==1) then
			-- local petSkill,petId = formationPetInfo[i].va_pet.skillTalent[1].id, formationPetInfo[i].petid
			-- if( isSkillEffect(petSkill, petId) ) then

			-- 	print(" isSkillEffect(petSkill, petId)  is :")
			-- 	print_t(isSkillEffect(petSkill, petId))

			-- 	local skillData= DB_Pet_skill.getDataById(petSkill)

			-- 	if(skillData.addNormalSkillLevel ) then
			-- 		addSkill.addNormalSkillLevel= addSkill.addNormalSkillLevel+ skillData.addNormalSkillLevel
			-- 	end

			-- 	if(skillData.addSpecialSkillLevel ) then
			-- 		addSkill.addSpecialSkillLevel= addSkill.addSpecialSkillLevel+ skillData.addSpecialSkillLevel
			-- 	end  

			-- end
	local petInfo = getPetInfoById(tonumber(petId) )	
	skillTalent=  petInfo.va_pet.skillTalent

	for j =1, table.count(skillTalent) do

		local petSkill= tonumber(skillTalent[j].id)
		if(isSkillEffect(petSkill, petId ) ) then
			local skillData= DB_Pet_skill.getDataById(petSkill)
			if(skillData.addNormalSkillLevel ) then
				addSkill.addNormalSkillLevel= addSkill.addNormalSkillLevel+ tonumber(skillData.addNormalSkillLevel) 
			end

			if(skillData.addSpecialSkillLevel ) then
				addSkill.addSpecialSkillLevel= addSkill.addSpecialSkillLevel+ tonumber(skillData.addSpecialSkillLevel)
			end
		end

	end
	return addSkill
end

-- 获得宠物的技能等级，skillType=1,普通技能，2，特殊技能
function getPetSkillLevel( petId, skillTyoe )
	local petInfo = getPetInfoById(tonumber(petId))
	local skillTyoe= skillTyoe or 2

	-- print("in  getPetSkillLevel petId is :", petId)

	local skillLevel =0
	if( skillTyoe==1 ) then
		-- skillLevel= tonumber()

	elseif(skillTyoe ==2) then
		skillId = tonumber(petInfo.va_pet.skillProduct[1].id ) 

		
		skillLevel= petInfo.va_pet.skillProduct[1].level

		if(skillId == 0) then
			return 0
		end

		skillLevel = skillLevel+ getAddSkillByTalent(tonumber(petId)).addSpecialSkillLevel
	end	


	-- print(" getAddSkillByTalent(tonumber(petId)).addSpecialSkillLevel", getAddSkillByTalent(tonumber(petId)).addSpecialSkillLevel)
	-- print("skillLevel is :", skillLevel)
	return skillLevel
end

-- 得到宠物的战斗力，UI前端显示用
function getPetFightForceById( id )
	local petInfo = getPetInfoById(tonumber(id))
	local fightForceNumber = 0

	if(tonumber(id)==0 or table.isEmpty(petInfo)) then
		return 0
	end	

	local skillNormal = petInfo.va_pet.skillNormal
	local skillTalent = petInfo.va_pet.skillTalent
	local skillProduct= petInfo.va_pet.skillProduct

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

	-- print("================= getPetAppend getPetAppend getPetAppend ")
	-- local a =getPetAppend( )

	return fightForceNumber
end


-- 加玩家的战斗力
function getPetAppend( )

	local tRetValue = {}
	if( table.isEmpty(_allPetInfo)) then
		return tRetValue
	end
	
	local formationPetInfo = getFormationPetInfo()

	
	local skillNormal= {}

	for i=1, table.count( formationPetInfo) do
		local status = tonumber( formationPetInfo[i].setpet.status)
		if(status and tonumber(status) ==1) then
			skillNormal = formationPetInfo[i].va_pet.skillNormal 
			break
		end
	end
	local upPetId = getUpPetId()

	local addSkill= getAddSkillByTalent(tonumber(upPetId))
	local addNormalSkillLevel= addSkill.addNormalSkillLevel

	-- print("+===== addSkill getAddSkillByTalent")
	-- print_t(addSkill)

	for i=1, table.count(skillNormal) do
		local skillId, level = tonumber(skillNormal[i].id), tonumber(skillNormal[i].level)+addNormalSkillLevel

		if(skillId >0) then	
			local skillProperty= PetUtil.getNormalSkill(skillId, level ) 
			table.insert(tRetValue , skillProperty)
		end
	end

	print("==========tRetValue tRetValue tRetValue ")
	print_t(tRetValue)

	return tRetValue
end

function getPetAffixValue( ... )
	local tInfo = getPetAppend()

	local retTable = {}

	for i=1,#tInfo do
		for j=1,#tInfo[i] do
			local v = tInfo[i][j]
			if(retTable[tostring(v.affixDesc[1])] == nil) then
				retTable[tostring(v.affixDesc[1])] = tonumber(v.realNum)
			else
				retTable[tostring(v.affixDesc[1])] = tonumber(retTable[tostring(v.affixDesc[1])]) + tonumber(v.realNum)
			end
			
		end
	end
	return retTable
end


-- 通过宠物的id,获得宠物的加成属性
function getPetValueById( petId)
	local petInfo= getPetInfoById(tonumber(petId))
	local skillNormal = petInfo.va_pet.skillNormal
	local addNormalSkillLevel = getAddSkillByTalent( tonumber(petId) ).addNormalSkillLevel

	local retTable= {}
	local tInfo = {}
	local petProperty= {}

	for i=1, table.count(skillNormal) do
		local skillId, level = tonumber(skillNormal[i].id), tonumber(skillNormal[i].level)+addNormalSkillLevel

		if(skillId >0) then	
			local skillProperty= PetUtil.getNormalSkill(skillId, level ) 
			table.insert(tInfo , skillProperty)
		end
	end

	-- print(" tInfo is =================================== ")
	-- print_t(tInfo)

	-- tInfo: 
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

	-- print("retTable retTable--------------------------------------- ")
	-- print_t(retTable)

	for k,v in pairs( retTable) do
		table.insert(petProperty, v)
	end

	return petProperty

end


function getLockCost(petId)
	local haveLockNum = getLockSkillNum(tonumber(petId) )

	local idPetInfo = getPetInfoById(petId)
	require "db/DB_Pet_cost"
	local costTable = DB_Pet_cost.getDataById(1)
	local costString = costTable.lockSkillCost
	local tableOne = lua_string_split(costString,",")

	require "db/DB_Pet"
	local canLockNum = DB_Pet.getDataById(tonumber(idPetInfo.pet_tmpl)).lockSkillNum
	if tonumber(canLockNum) < haveLockNum+1 then
		--返回-1，则无法加锁
		return -1
	else
		local tableTwo = lua_string_split(tableOne[haveLockNum+1],"|")
		return tableTwo[2]
	end
end

--得到宠物的资质
function getPetQuality(petTempId)
	local petDB = DB_Pet.getDataById(petTempId)
	return tonumber(petDB.petQuality)
end

function isShowTip()
	require "script/ui/item/ItemUtil"
	local fragTemp = ItemUtil.getPetFragInfos()
	local isShow = false
	local fragNum = 0
	for i = 1,#fragTemp do
		if tonumber(fragTemp[i].item_num) >= tonumber(fragTemp[i].itemDesc.need_part_num) then
			isShow = true
			fragNum = fragNum+1
		end
	end

	return isShow,fragNum
end

--[[
	@des 	:通过宠物pid得到宠物名字和加锁次数
	@param 	:
	@return :宠物名字，加锁次数
--]]
function getPetName(petId)
	local idPetInfo = getPetInfoById(petId)
	require "db/DB_Pet"
	local petDBInfo = DB_Pet.getDataById(tonumber(idPetInfo.pet_tmpl))

	return petDBInfo.lockSkillNum,petDBInfo.roleName,petDBInfo.quality
end