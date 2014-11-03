-- Filename：	MonthCardData.lua
-- Author：		zhz
-- Date：		2013-6-12
-- Purpose：		月卡功能的数据层，还有方法层

module("MonthCardData", package.seeall)

require "db/DB_Vip_card"
require "script/ui/item/ItemUtil"
require "script/ui/login/ServerList"
require "script/ui/rechargeActive/ActiveCache"
require "script/utils/TimeUtil"
require "script/model/utils/ActivityConfigUtil"

local _vipCardData= DB_Vip_card.getDataById(1)

local _vipCardInfo 			-- 月卡后端传来的数据

function getCardInfo( )
	return _vipCardInfo
end

function getVipCardData( ... )
	return _vipCardData
end

function setCardInfo(cardInfo )
	_vipCardInfo = cardInfo
end


-- 得到月卡的截止时间，
function getDeadLineTime( )
	if( table.isEmpty(_vipCardInfo) ) then
		print("error, have not buy monthCard!")
		return false
	end
	local dueTime = tonumber(_vipCardInfo.due_time) 
	return dueTime

end

-- 得到是否已经领取过了每日奖励， 如果没有买，就认为 false
function getCanReceive( )

	-- 还没有买
	if(table.isEmpty(_vipCardInfo)) then
		return true
	end
	
	if( ActiveCache.isToday( tonumber(_vipCardInfo.va_card_info.monthly_card.reward_time))) then
		return false
	else
		return true
	end
end

-- 判断是否购买了月卡，并且月卡是否有效
function isMonthCardEffect( )

	if( not table.isEmpty(_vipCardInfo) and  tonumber(_vipCardInfo.due_time)> BTUtil:getSvrTimeInterval() ) then
		return true
	else
		return false	
	end
end


-- 得到每日领取的奖励
function getCardReward( ... )
	-- local cardReward= lua_string_split(_vipCardData.cardReward,",") 

	local items= ItemUtil.getItemsDataByStr( _vipCardData.cardReward)
	return items
end

-- 得到月卡礼包的奖励
function getFirstReward( )
	if(_vipCardData.firstReward == nil) then

		print(" error ! firstReward为 空")
		return {}
	end

	local items= ItemUtil.getItemsDataByStr( _vipCardData.firstReward)
	return items
end

--
--得到月卡剩余天数
function getLeftDay( )
	
	if( table.isEmpty( _vipCardInfo ) or tonumber(_vipCardInfo.due_time)< BTUtil:getSvrTimeInterval() ) then
		return 0;
	end

	--_VipCardInfo.due_time记录的是活动结束的时间，减去当前的服务器时间，得到还剩余的时间
	local lastTime= _vipCardInfo.due_time- BTUtil:getSvrTimeInterval()
	local leftDay= math.ceil( lastTime/(24*3600))
	return leftDay 
end

--[[
	@desc:  判断当前在开服第几天，开服当天为第一天。开服7天内有礼包, 7天后没有礼包。so，7天后（第8天）以后都是8天

	@param: 
--]]
function getOpenServerDay( )
	-- 开服时间
	local openDateTime= tonumber(ServerList.getSelectServerInfo().openDateTime)
	print("openDateTime is ", openDateTime)

	local day=1

	local lastTime= BTUtil:getSvrTimeInterval() - openDateTime
	local lastDay= math.ceil(lastTime/(24*60*60)) 

	-- while ActiveCache.isToday(openDateTime)==false  do
 --        openDateTime= openDateTime+ 24*60*60
 --        day=day+1
 --    end

    print("lastDay is ", lastDay)

    return lastDay
end

--[[
	@des 	:判断是否是15天内开的服
	@param 	:
	@return :true or false
--]]
function isNewServer( )
	if(table.isEmpty(_vipCardInfo) and getOpenServerDay()<=15 ) then
		return true
	else
		return false
	end	 

	-- if(getOpenServerDay()>7) then
	-- 	return false
	-- end

	-- if(not table.isEmpty(_vipCardInfo) and tonumber(_vipCardInfo.va_card_info.gift_status)==2) then
	-- 	return true
	-- else
	-- 	return false
	-- end	

end

--[[
	@des 	:判断是否是15天后开的服
	@param 	:
	@return :true or false
--]]
function isOldServer()
	if (table.isEmpty(_vipCardInfo) and (getOpenServerDay() > 15)) and ActivityConfigUtil.isActivityOpen("monthlyCardGift") then
		return true
	else
		return false
	end
end

--[[
	@des 	:是否有礼包
	@param 	:
	@return :true or false
--]]
function wetherHaveBag()
	--有奖励没有领，显示图标
	if(not table.isEmpty(_vipCardInfo) and tonumber(_vipCardInfo.va_card_info.monthly_card.gift_status)==2) then
		return true
	--没有奖励，但活动正在进行中，显示图标
	elseif isNewServer() or isOldServer() then
		return true
	else
		return false
	end
end

-- 得到月卡的按钮
function getGiftStatus( )
	
	--没买过月卡，没有礼包
	if table.isEmpty(_vipCardInfo) then
		return 1
	else
		return tonumber( _vipCardInfo.va_card_info.monthly_card.gift_status)
	end
end

function setGiftStatus( status )
	_vipCardInfo.va_card_info.monthly_card.gift_status= status
end

--[[
	@des 	:获得活动结束时间
	@param 	:15天的活动开始时间 => 1 		3天的活动开始时间 => 2
	@return :活动开始时间戳
--]]
function getBeginTime(kind)
	returnTime = 0
	if kind == 1 then
		returnTime = tonumber(ServerList.getSelectServerInfo().openDateTime)
	elseif kind == 2 then
		returnTime = tonumber(ActivityConfigUtil.getDataByKey("monthlyCardGift").start_time)
	else
		returnTime = 0
	end

	return returnTime
end

--[[
	@des 	:获得活动结束时间
	@param 	:15天的活动结束时间 => 1 		3天的活动结束时间 => 2
	@return :活动结束时间戳
--]]
function getEndTime(kind)
	returnTime = 0
	if kind == 1 then
		returnTime = tonumber(ServerList.getSelectServerInfo().openDateTime) + 15*3600*24
	elseif kind == 2 then
		returnTime = tonumber(ActivityConfigUtil.getDataByKey("monthlyCardGift").end_time)
	else
		returnTime = 0
	end

	return returnTime
end

--[[
	@des 	:获得倒计时
	@param 	:15天的活动剩余时间 => 1 		3天的活动剩余时间 => 2
	@return :活动剩余时间戳
--]]
function minusTime(kind)
	local currentTime = TimeUtil.getSvrTimeByOffset()
	returnTime = 0
	if kind == 1 then
		returnTime = getEndTime(1) - tonumber(currentTime)
	elseif kind == 2 then
		returnTime = getEndTime(2) - tonumber(currentTime)
	else
		returnTime = 0
	end

	return returnTime
end

--[[
	@des 	:倒计时格式
	@param 	:15天的活动剩余时间 => 1 	3天的活动剩余时间 => 2
	@return :格式后的倒计时
--]]
function remainTimeFormat(kind)
	local remainTime = minusTime(kind)

	--天数
	local DNum = math.floor(remainTime/(3600*24))
	remainTime = remainTime - DNum*3600*24
	--小时数
	local HNum = math.floor(remainTime/3600)
	remainTime = remainTime - HNum*3600
	--分数
	local MNum = math.floor(remainTime/60)
	remainTime = remainTime - MNum*60
	--秒数
	local SNum = remainTime

	--用于存储时间格式
	local timeString = ""

	--如果够一天
	if DNum > 0 then
		timeString = DNum .. "天" .. HNum .. "小时" .. MNum .. "分" .. SNum .. "秒"
	--如果够一小时
	elseif HNum > 0 then
		timeString = HNum .. "小时" .. MNum .. "分" .. SNum .. "秒"
	--如果够一分钟
	elseif MNum > 0 then
		timeString = MNum .. "分" .. SNum .. "秒"
	--如果够一秒
	else
		timeString = SNum .. "秒"
	end

	return timeString
end

--[[
	@des 	:得到活动的种类
	@param 	:
	@return :活动种类 1 => 15分钟 	2 => 3分钟 	0 => 没有活动
--]]
function getTypeNumber()
	local gameType = 0
	if getOpenServerDay() <= 15 then
		gameType = 1
	elseif ActivityConfigUtil.isActivityOpen("monthlyCardGift") then
		gameType = 2
	else
		gameType = 0
	end

	return gameType
end