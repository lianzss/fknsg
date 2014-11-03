--Filename:	TimerRequestCenter.lua
--Author:	chengliang
--Date:		2013/12/17
--Purpose:	通知的相关方法

module ("TimerRequestCenter", package.seeall)

require "script/utils/TimeUtil"


-------- 定时程序
local _updateTimeScheduler 	= nil	-- scheduler


-- 00:00 点调用
function startZeroRequest()
	-- 获取服务器时间
	local targetTime = TimeUtil.getIntervalByTime("000000") + UserModel.getSvrDayOffsetSec()
	local curTimeSec = TimeUtil.getSvrTimeByOffset()
	if(targetTime<=curTimeSec)then
		targetTime = targetTime + 86400
	end
	local leftTimeInterval = targetTime - TimeUtil.getSvrTimeByOffset() + 1
	print("leftTimeInterval==", leftTimeInterval)
	if(leftTimeInterval>0)then
		startScheduler(leftTimeInterval)
	end
end

-- 停止scheduler
function stopScheduler()
	if(_updateTimeScheduler ~= nil)then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(_updateTimeScheduler)
		_updateTimeScheduler = nil
	end
end

-- 启动scheduler
function startScheduler(timeInterval)
	if(_updateTimeScheduler == nil) then
		_updateTimeScheduler = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(updateTimeFunc, timeInterval, false)
	end
end

-- 
function updateTimeFunc()
	stopScheduler()
	startRequest()
	startZeroRequest()
end

-- 开始刷新各项数据
function startRequest( )
	if(DataCache.getSwitchNodeState(ksSwitchEliteCopy,false)) then
		-- 拉取精英副本
    	PreRequest.getEliteCopy_noLoading()
	end
	if(DataCache.getSwitchNodeState(ksSwitchActivityCopy,false)) then
		-- 活动副本
    	PreRequest.getActiveCopy_noLoading()
	end
	if(  UserModel.getHeroLevel() and UserModel.getHeroLevel()>=5 )then
		-- 普通副本
		PreRequest.getNormalCopy_noLoading()
	end
	if(DataCache.getSwitchNodeState(ksSwitchGuild , false)) then
		-- 军团副本
    	PreRequest.getGuildCopyInfo_noLoading()
	end
	if(DataCache.getSwitchNodeState(ksSwitchStar , false)) then
		-- 获得占星数据
    	PreRequest.preGetAstroInfo_noLoading()
	end
	if(DataCache.getSwitchNodeState(ksSwitchSignIn,false)) then
		-- 签到刷新
		PreRequest.getSignInfo_noLoading()
	end

end
