-- Filename：	GuildDataCache.lua
-- Author：		Cheng Liang
-- Date：		2013-12-21
-- Purpose：		缓存军团的数据


module("GuildDataCache", package.seeall)

local _isInGuild 			= false -- 是否在军团的相关界面

local va_hall_index 		= 1 	-- 军团大厅的下标
local va_zhongyitang_index 	= 2 	-- 忠义堂的下标
local va_guanyu_index 		= 3 	-- 关公殿的下标
local va_shop_index			= 4		-- 军团商店的下标
local va_copy_index			= 5		-- 军机大厅（也就是军团副本）的下标
local va_book_index 		= 6 	-- 军团任务（也是就军团任务）的下标

local _mineSigleGuildInfo 	= nil	-- 我自己个人在联盟中的信息
local _guildInfo 			= nil	-- 我所在的军团的信息
local _memberInfoList 		= nil 	-- 成员列表

local _requestMemberDelegate = nil 	-- 拉取成员信息列表

local _recordList = nil -- record 信息

local _guildShopInfo		= nil	-- 军团商店的信息 added by zhz


-- 是否在军团界面
function isInGuildFunc()
	return _isInGuild
end

-- 设置是否在军团界面
function setIsInGuildFunc(isInGuild)
	_isInGuild = isInGuild
end

-- 清理缓存
function cleanCache()
	_mineSigleGuildInfo 	= nil
	_guildInfo 				= nil
	_memberInfoList 		= nil

	_requestMemberDelegate = nil
end

-- 设置个人军团信息
function setMineSigleGuildInfo( mineSigleGuildInfo)
	_mineSigleGuildInfo = mineSigleGuildInfo
end

-- 获取个人军团信息
function getMineSigleGuildInfo()
	return _mineSigleGuildInfo
end

-- 增减切磋次数
function addPlayDefeautNum( add_times )
	_mineSigleGuildInfo.playwith_num = tonumber(_mineSigleGuildInfo.playwith_num) + add_times
end

-- 设置军团信息
function setGuildInfo( guildInfo)
	_guildInfo = guildInfo
end

-- 获取军团信息
function getGuildInfo()
	return _guildInfo
end

-- 获取军团名称
function getGildName( ... )
	if( not table.isEmpty(_guildInfo) ) then
		return _guildInfo.guild_name
	else
		return nil
	end	
end

-- 获取军团战斗力 没有返回nil
function getGildFightForce( ... )
	if( not table.isEmpty(_guildInfo) ) then
		return _guildInfo.fight_force
	else
		return nil
	end	
end

-- 获得个人信息中的军团id
function getMineSigleGuildId( ... )
	local guild_id = 0
	if( (not table.isEmpty(_mineSigleGuildInfo)) and _mineSigleGuildInfo.guild_id ~= nil  and tonumber(_mineSigleGuildInfo.guild_id) > 0 ) then
		guild_id = tonumber(_mineSigleGuildInfo.guild_id)
	end
	return guild_id
end

-- 获得军团id, guild_id
function getGuildId( ... )
	local guild_id = 0
	if( (not table.isEmpty(_guildInfo))  and tonumber(_guildInfo.guild_id) > 0 ) then
		guild_id = tonumber(_guildInfo.guild_id)
	end
	return guild_id
end

--增加军团副团长个数
function addGuildVPNum(addVPNum)
	_guildInfo.vp_num = tonumber(_guildInfo.vp_num) + tonumber(addVPNum)
end

-- 获取军团的宣言
function getSlogan()
	return _guildInfo.va_info[va_hall_index].slogan
end

-- 修改军团的宣言
function setSlogan(slogan)
	_guildInfo.va_info[va_hall_index].slogan = slogan
end

-- 获取军团的公告
function getPost()
	return _guildInfo.va_info[va_hall_index].post
end

-- 修改军团的公告
function setPost(post)
	_guildInfo.va_info[va_hall_index].post = post
end

-- 得到军团成员个数
function getGuildMemberNum()
	return tonumber(_guildInfo.member_num)
end

-- 我今天的捐献次数
function getMineDonateTimes()
	return tonumber(_mineSigleGuildInfo.contri_num)
end

-- 增减我今天的捐献次数
function addMineDonateTimes(addLv)
	_mineSigleGuildInfo.contri_num = tonumber(_mineSigleGuildInfo.contri_num) + tonumber(addLv)
end

-- 修改我的权限信息
function changeMineMemberType(m_type)
	_mineSigleGuildInfo.member_type = m_type
end

-- 增减军团成员个数
function addGuildMemberNum( addLv )
	_guildInfo.member_num = tonumber(_guildInfo.member_num) + addLv
end

-- 增加建筑物等级
function addGuildLevelBy( b_type, addLv, addDonate )
	if(b_type == 2)then
		-- 是军团大厅
		_guildInfo.guild_level = tostring( tonumber(_guildInfo.guild_level) + tonumber(addLv) ) 
	end
	_guildInfo.va_info[b_type].level = tostring( tonumber(_guildInfo.va_info[b_type].level) + tonumber(addLv) )
	_guildInfo.va_info[b_type].allExp = tostring( tonumber(_guildInfo.va_info[b_type].allExp) + tonumber(addDonate) )
end

-- 军团大厅的等级
function getGuildHallLevel()
	
	return tonumber(_guildInfo.guild_level )
end

-- 获得个人总贡献
function getSigleDoante()
	return tonumber(_mineSigleGuildInfo.contri_point)
end

-- 增减个人总贡献
function addSigleDonate(addDonate)
	_mineSigleGuildInfo.contri_point = tonumber(_mineSigleGuildInfo.contri_point) + tonumber(addDonate)
end

-- 增减军团建设度
function addGuildDonate( addDonate )
	_guildInfo.curr_exp = tonumber(_guildInfo.curr_exp) +  tonumber(addDonate)
end

--获得军团建设度
function getGuildDonate()
	return _guildInfo.curr_exp
end

-- 获得关公殿的等级
function getGuanyuTempleLevel()
	return tonumber(_guildInfo.va_info[va_guanyu_index].level)
end

-- 修改关公殿的等级
function addGuanyuTempleLevel( addLv)
	_guildInfo.va_info[va_guanyu_index].level = tonumber(_guildInfo.va_info[va_guanyu_index].level) + tonumber(addLv)
end

-- 获得军团商店的等级
function getShopLevel( )
	return tonumber(_guildInfo.va_info[va_shop_index].level) 
end

-- 获得军机大厅的等级
function getCopyHallLevel( ... )
	return tonumber(_guildInfo.va_info[va_copy_index].level) 
end

-- 
function getGuildBookLevel( ... )
	return tonumber(_guildInfo.va_info[va_book_index].level )
end

--军团总参拜次数
function getGuildRewardTimes()
	return tonumber(_guildInfo.reward_num)
end

--增减军团总参拜次数
function addGuildRewardTimes(addTimes)
	_guildInfo.reward_num = tonumber(_guildInfo.reward_num) + tonumber(addTimes)
end

-- 剩余拜关公次数
function getBaiGuangongTimes()
	return tonumber(_mineSigleGuildInfo.reward_num)
end

-- 增减拜关公次数
function addBaiGuangongTimes( addTimes )
	_mineSigleGuildInfo.reward_num = tonumber(_mineSigleGuildInfo.reward_num) + tonumber(addTimes)
end

--金币参拜关公殿次数
function getCoinBaiTimes()
	return tonumber(_mineSigleGuildInfo.reward_buy_num)
end

--增减金币拜关公次数
function addCoinBaiTimes(addTimes)
	_mineSigleGuildInfo.reward_buy_num = tonumber(_mineSigleGuildInfo.reward_buy_num) + tonumber(addTimes)
end

-- 设置成员列表
function setMemberInfoList(memberInfoList)
	_memberInfoList = memberInfoList
end

-- 获取成员列表
function getMemberInfoList()
	return _memberInfoList
end

-- 军团请求回调
function sendRequestMemberCallback(  cbFlag, dictData, bRet  )
	if(dictData.err == "ok")then
		_memberInfoList = dictData.ret
		if(_requestMemberDelegate)then
			_requestMemberDelegate()
		end
	end
end

--- 获取成员列表
function sendRequestForMemberList(requestMemberDelegate)
	_requestMemberDelegate = requestMemberDelegate
	local args = Network.argsHandler(0, 99)
	RequestCenter.guild_getMemberList(sendRequestMemberCallback, args)
end

-- 获取某个成员的信息
function getMemberInfoBy( uid )
	uid = tonumber(uid)
	local m_info = {}
	for k,v in pairs(_memberInfoList.data) do
		if(tonumber(v.uid) == uid )then
			m_info = v
			break
		end
	end

	return m_info
end

--获得军团人数上限
function getMemberLimit()
	return tonumber(_guildInfo.member_limit)
end


-- 设置军团商店 added by zhz
function setShopInfo( shopInfo )
	_guildShopInfo = shopInfo
end

-- 获得军团商店信息
function getShopInfo( )
	return _guildShopInfo
end

-- 获得军团商店珍品信息
function getSpecialGoodsInfo( )
	return _guildShopInfo.special_goods
end

-- 获得军团商店刷新刷新时间
function getShopRefreshCd()
	-- return  tonumber(_guildShopInfo.refresh_cd) - BTUtil:getSvrTimeInterval()
	require "script/utils/TimeUtil"
	local endShieldTime = tonumber(_guildShopInfo.refresh_cd)
	-- print(" time  is : ")
	-- print_t(os.date("*t",tonumber(_guildShopInfo.refresh_cd)))
    local havaTime = endShieldTime - TimeUtil.getSvrTimeByOffset()--BTUtil:getSvrTimeInterval()+1
    if(havaTime > 0) then
        return havaTime
    else
        return 0
    end
end

-- 设置军团商店珍品信息和刷新时间
function setSpecialGoodsInfo( special_goods,refreshCd )
	_guildShopInfo.special_goods= special_goods
	_guildShopInfo.refresh_cd= refreshCd
end


--[[
    @des:       通过DB_Legion_goods的id来获得道具中已经购买的次数v{sum ,num}
    @return:    sum: 军团购买次数 
    			num: 个人购买次数
    			若无则 sum 和num都为 0
]]
function getNorBuyNumById( id)
	local normal_goods= _guildShopInfo.normal_goods
	for goodId,v  in pairs(normal_goods) do
		if(tonumber(goodId) == tonumber(id)) then
			return v 
		end
	end
	return {num=0,sum=0 }
end

--[[
    @des:       通过DB_Legion_goods的id来获得珍品已经购买的次数v{sum ,num}
    @return:    sum: 军团购买次数 
    			num: 个人购买次数
    			若无则 sum 和num都为 0
]]
function getSpecialBuyNumById( id)
	local special_goods= _guildShopInfo.special_goods
	for goodId,v  in pairs(special_goods) do
		if(tonumber(goodId) == tonumber(id) and not table.isEmpty(v) ) then
			return v 
		end
	end
	return {num=0,sum=0 }
end

--通过ID，设置guildShopInfo 中珍品的
function addSpecialBuyNumById(id,addSum, addNum )
	for goodId,v  in pairs(_guildShopInfo.special_goods) do
		if(tonumber(goodId) == tonumber(id)) then
			if(_guildShopInfo.special_goods[tostring(goodId)].sum) then
				_guildShopInfo.special_goods[tostring(goodId)].sum= _guildShopInfo.special_goods[tostring(goodId)].sum+ addSum
			else
				_guildShopInfo.special_goods[tostring(goodId)].sum= addSum
			end
			if(	_guildShopInfo.special_goods[tostring(goodId)].num) then
				_guildShopInfo.special_goods[tostring(goodId)].num= _guildShopInfo.special_goods[tostring(goodId)].num+ addNum
			else
				_guildShopInfo.special_goods[tostring(goodId)].num= addNum
			end
			ishas = true
		end
	end
end

-- 通过id, 设置
function addNorBuyNumById(id,addSum, addNum )
	
	local ishas= false
	
	for goodId,v  in pairs(_guildShopInfo.normal_goods) do
		if(tonumber(goodId) == tonumber(id)) then
			_guildShopInfo.normal_goods[tostring(goodId)].num= _guildShopInfo.normal_goods[tostring(goodId)].num+ addNum
			if(_guildShopInfo.normal_goods[tostring(goodId)].sum) then
				_guildShopInfo.normal_goods[tostring(goodId)].sum= _guildShopInfo.normal_goods[tostring(goodId)].sum+ addSum
			end
			ishas = true
		end
	end

	if(ishas==false) then
		_guildShopInfo.normal_goods[tostring(id)]= {sum= addSum, num = addNum}
	end
end

-- 后端推送商品信息的处理
function addPushGoodsInfo( goodInfo)
	
	-- 道具处理
	local normal_goods= _guildShopInfo.normal_goods
	for id , v in pairs(goodInfo) do
		-- 判断id是否为道具
		local goodData= DB_Legion_goods.getDataById(id)
		if(goodData.goodType == 2 ) then

			local ishas= false
			for goodId, values in pairs(normal_goods) do
				if(tonumber(id) == tonumber(goodId)) then
					normal_goods[tostring(goodId)].sum = v.sum
					ishas = true
				end
			end
			if(ishas== false) then
				normal_goods[tostring(id)]= { sum = v.sum, num= 0}
			end
		end
	end

	-- 珍品处理
	local special_goods =  _guildShopInfo.special_goods
	for id , v in pairs(goodInfo) do
		-- local ishas= false
		local goodData= DB_Legion_goods.getDataById(id)
		if(goodData.goodType == 1 ) then
			for goodId, values in pairs(special_goods) do
				if(tonumber(id) == tonumber(goodId)) then
					special_goods[tostring(goodId)].sum = v.sum
					-- ishas = true
				end
			end
		end
		-- if(ishas== false) then
		-- 	special_goods[tostring(id)]= { sum = v.sum, num= 0}
		-- end
	end

end

function isCanBaiGuangong()
	require "script/utils/TimeUtil"
	local curTime = TimeUtil.getSvrTimeByOffset()
	local date = os.date("*t", curTime)
	local nowHour = date.hour
	local nowMin = date.min
	local nowSec = date.sec

	local nowTime = tonumber(nowHour)*10000 + tonumber(nowMin)*100 + tonumber(nowSec)

	local canBai = false
	local mineData = getMineSigleGuildInfo()
	if ((not table.isEmpty(mineData))  and tonumber(mineData.guild_id) > 0 ) then
		--在军团
		require "db/DB_Legion_feast"
		if (tonumber(nowTime) >= tonumber(DB_Legion_feast.getDataById(1).beginTime)) and (tonumber(nowHour) <= tonumber(DB_Legion_feast.getDataById(1).endTime))then
			if tonumber(getBaiGuangongTimes()) > 0 then
				canBai = true
			end
		end
	end

	return canBai
end

function isShowTip()
	require "script/ui/guild/copy/GuildTeamData"
	local isShow = false
	--因为军机大厅没有判断是否在军团里，所以又加了一层
	if ((not table.isEmpty(getMineSigleGuildInfo()))  and tonumber(getMineSigleGuildInfo().guild_id) > 0 ) then
		if (isCanBaiGuangong()) or (GuildTeamData.getLeftGuildAtkNum() > 0) then
			isShow = true
		end
	end

	return isShow
end


-- 城池加成只有该玩家所在军团占领的城池有相应加成的时候 才会进行加成
--- added by zhz 
--[[ 
	rewardType: 
	1.军团组队银币奖励
	2.试练塔银币奖励
	3.摇钱树银币奖励
	4.普通副本银币奖励
	5.精英副本银币奖励
	6.资源矿银币奖励
--]]
--[[
	@des 	:得到城池对其他模块的银币加成，首先判断玩家是否有军团，是否占领的城池，并且
	@param 	: 加成类型rewardType: 同上
	@return : rewardTab= {
			isHas: 		是否有加成
			rate：		加成比例 (< 1, 需要加成)
			rewardType:	同上
			name:		加成类型的名字
		}
]]
function getGuildCityRewardRate( rewardType )

	require "script/ui/guild/city/CityData"
	local rewardTab =  { isHas= false , rate= 0, reardType=0 }
	local rewardType = tonumber(rewardType)

	-- print("_mineSigleGuildInfo.city_id ", _mineSigleGuildInfo.city_id)
	-- _mineSigleGuildInfo.city_id = 5

	if( table.isEmpty(_mineSigleGuildInfo) or _mineSigleGuildInfo.city_id== nil or tonumber(_mineSigleGuildInfo.city_id)== 0) then
		return rewardTab
	end

	local city_id = tonumber(_mineSigleGuildInfo.city_id)
	local dataTab=  CityData.getExtraRewardByCityId(city_id)

	if(dataTab.rewardType== rewardType ) then
		rewardTab= dataTab
		rewardTab.isHas = true 
	end
	return rewardTab

end

------------------------------------------ 主界面军团按钮小红圈优化 ---------------------
-- 每次登陆就显示一次，点击后消失
local _isShowTip 			= nil   -- 小红圈

function setIsShowRedTip( p_isShow )
	_isShowTip = p_isShow
end

function getIsShowRedTip( ... )
	return _isShowTip
end

-- 是否显示主界面军团上小红点
function isShowRedTip( ... )
	local retData = false
	require "script/ui/guild/GuildDataCache"
	require "script/ui/guild/city/CityData"
	if( GuildDataCache.isShowTip() or CityData.getIsShowTip() )then
		retData = true
	end
	return retData
end


