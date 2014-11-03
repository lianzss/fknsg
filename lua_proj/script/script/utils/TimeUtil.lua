--Filename:timeUtil.lua
--Author：hechao
--Date：2013/4/18
--Purpose:公用方法集合
module("TimeUtil",package.seeall)

require "script/utils/LuaUtil"

function getStringTimeForInt(timeInt)
	if(tonumber(timeInt) <= 0)then
		return "00:00:00"
	elseif(timeInt/60 >= 60)then
		return string.format("%.2d:%.2d:%.2d",timeInt/3600,(timeInt/60)%60,timeInt%60)
	elseif(timeInt >= 60)then
		return string.format("00:%.2d:%.2d",(timeInt/60)%60,timeInt%60)
	else
		return string.format("00:00:%.2d",timeInt%60)
	end
end

-- 将一个时间数转换成"00:00:00"格式
function getTimeString(timeInt)
	if(tonumber(timeInt) <= 0)then
		return "00:00:00"
	else
		return string.format("%02d:%02d:%02d", math.floor(timeInt/(60*60)), math.floor((timeInt/60)%60), timeInt%60)
	end
end

function getTimeStringWords(timeInt)
    if(tonumber(timeInt) <= 0)then
		return string.format(GetLocalizeStringBy("key_8340"), 0, 0, 0)
	else
        local temp = os.date("*t", timeInt)
		return string.format(GetLocalizeStringBy("key_8340"), temp.hour, temp.min, temp.sec)
	end
end

-- 将一个时间数转换成GetLocalizeStringBy("key_3269")格式
function getTimeStringFont(timeInt)
	if(tonumber(timeInt) <= 0)then
		return GetLocalizeStringBy("key_3269")
	else
		return string.format(GetLocalizeStringBy("key_2047"), math.floor(timeInt/(60*60)), math.floor((timeInt/60)%60), timeInt%60)
	end
end

-- nGenTime: 产生时间戳（也可以是一个未来的时间，比如CD时间戳）
-- nDuration: 固定的有效期间，单位秒，计算某个未来时间的剩余时间时不需要指定
-- 返回3个结果，第一个是剩余到期时间的字符串，"HH:MM:SS", 不足2位自动补零；第二个是bool，标识nGenTime是否到期；第三个是剩余秒数
function expireTimeString( nGenTime, nDuration )
    local nNow = BTUtil:getSvrTimeInterval()
    --CCLuaLog("nGenTime = " .. nGenTime .. " nNow = " .. nNow)
    local nViewSec = (nDuration or 0) - (nNow - nGenTime)
    return getTimeString(nViewSec), nViewSec <= 0, nViewSec
end


--得到一个时间戳timeInt与当前时间的相隔天数
--offset是偏移量,例如凌晨4点:4*60*60
--return type is integer, 0--当天, n--不在同一天,相差n天
function getDifferDay(timeInt, offset)
	timeInt = tonumber(timeInt or 0)
	offset = tonumber(offset or 0)
    local curTime = tonumber(BTUtil:getSvrTimeInterval()) - offset
    if(os.date("%j",curTime) == 1 and os.date("%j",timeInt - offset) ~= 1)then
    	return os.date("%j",curTime) - (os.date("%j",timeInt - offset) - os.date("%j",curTime-24*60*60))
    else--if(os.date("%j",curTime) ~= os.date("%j",timeInt - offset))then
    	return os.date("%j",curTime) - os.date("%j",timeInt - offset)
    end
end

-- 指定一个日期时间字符串，返回与之对应的东八区（服务器时区）时间戳, zhangqi, 20130702
-- sTime: 格式 "2013-07-02 20:00:00"
function getIntervalByTimeString( sTime )
	local t = string.split(sTime, " ")
	local tDate = string.split(t[1], "-")
	local tTime = string.split(t[2], ":")

	local tt = os.time({year = tDate[1], month = tDate[2], day = tDate[3], hour = tTime[1], min = tTime[2], sec = tTime[3]})
	local ut = os.date("!*t", tt)
	local east8 = os.time(ut) + 8*60*60 -- UTC时间+8小时转为东八区北京时间
	return east8
end

-- 指定一个日期时间字符串，返回与之对应的东八区（服务器时区）时间戳, zhangqi, 20130702
-- sTime: 格式 "20140624235900"
function getIntervalByTimeDesString( sTime )
	
	local tt = os.time({year  = string.sub(sTime,1,4), 
						month = string.sub(sTime,5,6), 
						day   = string.sub(sTime,7,8), 
						hour  = string.sub(sTime,9,10), 
						min   = string.sub(sTime,11,12), 
						sec   = string.sub(sTime,13,14)})
	local ut = os.date("!*t", tt)
	local east8 = os.time(ut) + 8*60*60 -- UTC时间+8小时转为东八区北京时间
	return east8
end

--给一个时间如:153000,得到今天15:30:00的时间戳 
function getIntervalByTime( time )
	local curTime = BTUtil:getSvrTimeInterval()
	local temp = os.date("*t",curTime)
	time = string.format("%06d", time)

	local h,m,s = string.match(time, "(%d%d)(%d%d)(%d%d)" )
	local timeString = temp.year .."-".. temp.month .."-".. temp.day .." ".. h ..":".. m ..":".. s
    local timeInt = TimeUtil.getIntervalByTimeString(timeString)

    return timeInt
end



--把一个hh:mm:ss这样的时间段转换成时间戳
function getIntervalByTimeSegment( timeString )
	local timeInfo = string.split(timeString,":")
	return tonumber(timeInfo[1])*3600 + tonumber(timeInfo[2])*60 + tonumber(timeInfo[3])
end

-- 把一个时间戳转换为 ”n天n小时n分n秒“ 如果某一项为0则不显示这一项
-- timeInt:时间戳
function getTimeDesByInterval( timeInt )

	local result = ""
	local oh	 = math.floor(timeInt/3600)
	local om 	 = math.floor((timeInt - oh*3600)/60)
	local os 	 = math.floor(timeInt - oh*3600 - om*60)
	local hour = oh
	local day  = 0
	if(oh>=24) then
		day  = math.floor(hour/24)
		hour = oh - day*24
	end
	if(day ~= 0) then
		result = result .. day .. GetLocalizeStringBy("key_2825")
	end
	if(hour ~= 0) then
		result = result .. hour ..GetLocalizeStringBy("key_1769")
	end
	if(om ~= 0) then
		result = result .. om .. GetLocalizeStringBy("key_3249")
	end
	if(os ~= 0) then
		result = result .. os .. GetLocalizeStringBy("key_3240")
	end
	return result
end


-- 设备时间的东八区时间  zhangqi
function getDevCurTimeInterval()
	return (os.time(os.date("!*t", os.time()))+28800)
end

--给一个时间如:153000,得到今天15:30:00的时间戳 相对于设备的东八区时间
function getDevIntervalByTime( time )
	local curTime = getDevCurTimeInterval()
	local temp = os.date("*t",curTime)

	time = string.format("%06d", time)

	local h,m,s = string.match(time, "(%d%d)(%d%d)(%d%d)" )
	local timeString = temp.year .."-".. temp.month .."-".. temp.day .." ".. h ..":".. m ..":".. s
    local timeInt = TimeUtil.getIntervalByTimeString(timeString)

    return timeInt
end

--给一个时间如:153000,得到今天15:30:00的时间戳 相对于服务器的东八区时间 -- add by chengliang
function getSvrIntervalByTime( time )
	local curTime = getSvrTimeByOffset()
	local temp = os.date("*t",curTime)

	time = string.format("%06d", time)

	local h,m,s = string.match(time, "(%d%d)(%d%d)(%d%d)" )
	local timeString = temp.year .."-".. temp.month .."-".. temp.day .." ".. h ..":".. m ..":".. s
    local timeInt = TimeUtil.getIntervalByTimeString(timeString)

    return timeInt
end

-- 得到服务器时间
-- 参数second_num:偏移的秒数  负数：比服务器慢，正数：比服务器快，默认-1
function getSvrTimeByOffset( second_num )
	-- 当前服务器时间
    local curServerTime = BTUtil:getSvrTimeInterval()
    local offset = tonumber(second_num) or -1
    return curServerTime+offset
end

-- 给一个时间戳，得到类似：2012-12-12,得string，精确到分
function getTimeForDay( timeInt)
	local timeInt= tonumber(timeInt)
	local temp = os.date("*t",timeInt)

	time = string.format("%06d", timeInt)
	local h,m,s = string.match(time, "(%d%d)(%d%d)(%d%d)")
	
	local timeString=  temp.year .."-".. temp.month .."-".. temp.day..GetLocalizeStringBy("key_1557").. string.format("%02d", temp.hour) .. GetLocalizeStringBy("key_2132") .. string.format("%02d", temp.min) .. GetLocalizeStringBy("key_2164")
	return timeString
end

-- para：时间戳  return：时间格式：2014-06-01 01:01:01  add by chengliang
function getTimeFormatYMDHMS( m_time )
	local temp = os.date("*t",m_time)

	local m_month 	= string.format("%02d", temp.month)
	local m_day 	= string.format("%02d", temp.day)
	local m_hour 	= string.format("%02d", temp.hour)
	local m_min 	= string.format("%02d", temp.min)
	local m_sec 	= string.format("%02d", temp.sec)


	local timeString = temp.year .."-".. m_month .."-".. m_day .." ".. m_hour ..":".. m_min ..":".. m_sec


    return timeString
end

-- para：时间戳  return：时间格式 01:01:01  add by bzx
function getTimeFormatAtDay( m_time )
	local temp = os.date("*t",m_time)

	local m_month 	= string.format("%02d", temp.month)
	local m_day 	= string.format("%02d", temp.day)
	local m_hour 	= string.format("%02d", temp.hour)
	local m_min 	= string.format("%02d", temp.min)
	local m_sec 	= string.format("%02d", temp.sec)

	local timeString = m_hour ..":".. m_min ..":".. m_sec
    return timeString
end


-- para：时间戳  return：时间格式：2014年06月01日 01:01  add by zhang zihang
function getTimeFormatChnYMDHM( m_time )
	local temp = os.date("*t",m_time)

	local m_month 	= string.format("%02d", temp.month)
	local m_day 	= string.format("%02d", temp.day)
	local m_hour 	= string.format("%02d", temp.hour)
	local m_min 	= string.format("%02d", temp.min)


	local timeString = temp.year ..GetLocalizeStringBy("key_2695").. m_month ..GetLocalizeStringBy("key_1271").. m_day ..GetLocalizeStringBy("key_1557").. "" .. m_hour ..":".. m_min 


    return timeString
end

--added by Zhang Zihang
--[[
	@des 	:根据时间按戳得到转换后的日期string：格式2014-12-25日10点
	@param 	:时间戳
	@return :转换完成的string
--]]
function getTimeFormatYMDH(m_time)
	local temp = os.date("*t",m_time)

	local m_month 	= string.format("%02d", temp.month)
	local m_day 	= string.format("%02d", temp.day)

	local timeString = temp.year .. "-" .. m_month .. "-" .. m_day .. GetLocalizeStringBy("key_1557") .. temp.hour .. GetLocalizeStringBy("key_2132")

    return timeString
end

-- para：时间戳  return：时间格式：2014年06月01日 add by licong
function getTimeForDayTwo( m_time )
	local temp = os.date("*t",m_time)

	local m_month 	= string.format("%02d", temp.month)
	local m_day 	= string.format("%02d", temp.day)

	local timeString = temp.year ..GetLocalizeStringBy("key_2695").. m_month ..GetLocalizeStringBy("key_1271").. m_day ..GetLocalizeStringBy("key_1557")

    return timeString
end

-- para：时间戳  return：时间格式：2014-06-01 01:01  add by licong  精确到分钟
function getTimeToMin( m_time )
	local temp = os.date("*t",m_time)

	local m_month 	= string.format("%02d", temp.month)
	local m_day 	= string.format("%02d", temp.day)
	local m_hour 	= string.format("%02d", temp.hour)
	local m_min 	= string.format("%02d", temp.min)

	local timeString = temp.year .."-".. m_month .."-".. m_day .."  ".. m_hour ..":".. m_min 

    return timeString
end

-- para：时间戳  return：时间格式： 01:01  add by 李攀 只要 小时和分钟

function getTimeOnlyMin( m_time )
	local temp = os.date("*t",m_time)

	-- local m_month 	= string.format("%02d", temp.month)
	-- local m_day 	= string.format("%02d", temp.day)
	local m_hour 	= string.format("%02d", temp.hour)
	local m_min 	= string.format("%02d", temp.min)

	local timeString = m_hour ..":".. m_min 

    return timeString
end

-- para:时间段  X分钟、X小时、X天
function getTimeDisplayText( time_interval)
	time_interval = tonumber(time_interval)
	local d_text = ""
	if(time_interval<60*60)then
		-- 分钟
		d_text = math.ceil(time_interval/60) .. GetLocalizeStringBy("key_3249")
	elseif(time_interval<60*60*24)then
		-- 小时
		d_text = math.ceil(time_interval/(60*60)) .. GetLocalizeStringBy("key_1769")
	else
		-- 天
		d_text = math.ceil(time_interval/(60*60*24) ) .. GetLocalizeStringBy("key_2825")
	end

	return d_text
end


-- para：时间戳  return：时间格式：2014年06月01日 add by licong
function getTimeForDayMD( m_time )
	local temp = os.date("*t",m_time)

	local m_month 	= string.format("%02d", temp.month)
	local m_day 	= string.format("%02d", temp.day)

	local timeString = m_month ..GetLocalizeStringBy("key_1271").. m_day ..GetLocalizeStringBy("key_1557")

    return timeString
end


