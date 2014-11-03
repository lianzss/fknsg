-- FileName: EverydayData.lua 
-- Author: Li Cong 
-- Date: 14-3-18 
-- Purpose: function description of module 

module("EverydayData", package.seeall)

require "script/ui/item/ItemSprite"
require "script/ui/item/ItemUtil"
require "db/DB_Daytask"
require "db/DB_Daytask_reward"

local _totalInfo = nil

-- 设置每日任务数据
function setEverydayInfo( data )
	_totalInfo = data
end

-- 得到每日任务数据
function getEverydayInfo( ... )
	return _totalInfo
end

-- 得到当前积分
function getCurScore( ... )
	local data = getEverydayInfo()
	return tonumber(data.point) or 0
end

-- 得到最大积分 只有三个箱子
function getMaxScore( ... )
	local data = DB_Daytask_reward.getDataById(3)
	return tonumber(data.needScore) or 0
end

-- 得到任务数据
function getTaskInfo( ... )
	local retTab = {}
	local data = getEverydayInfo()
	if(data == nil)then
		return retTab
	end
	if(data.va_active.task)then
		for i=1,table.count(DB_Daytask.Daytask) do
			retTab[#retTab+1] = {}
			retTab[#retTab].taskId = i
			retTab[#retTab].dbData = DB_Daytask.getDataById(i)
			print("data.va_active.task[tostring(i)]",data.va_active.task[tostring(i)])
			if(data.va_active.task[tostring(i)])then
				retTab[#retTab].curNum = data.va_active.task[tostring(i)]
			else
				retTab[#retTab].curNum = 0
			end
		end
	else
		for i=1,table.count(DB_Daytask.Daytask) do
			retTab[#retTab+1] = {}
			print("********")
			print_t(retTab)
			retTab[#retTab].taskId = i
			retTab[#retTab].curNum = 0
			retTab[#retTab].dbData = DB_Daytask.getDataById(i)
		end
	end
    -- 排序 sortId从大到小
	local function fnSortFun( a, b )
        return tonumber(a.dbData.sortId) > tonumber(b.dbData.sortId)
    end 
    table.sort( retTab, fnSortFun )
    -- 已完成的排在最前边
    local arr1 = {}
    local arr2 = {}
    for k,v in pairs(retTab) do
    	if(tonumber(v.curNum) >= tonumber(v.dbData.needNum))then
    		-- 完成
    		table.insert(arr1,v)
    	else
    		table.insert(arr2,v)
    	end
    end
    for k,v in pairs(arr2) do
    	table.insert(arr1,v)
    end
	return arr1
end


-- 得到箱子的状态 
-- 1铜  2银  3金
function getBoxStateInfoById( id )
	local retState = 1
	local retNeedScore = 0
	local data = getEverydayInfo()
	if(data == nil)then
		return retState,retNeedScore
	end
	local boxData = DB_Daytask_reward.getDataById(id)
	retNeedScore = tonumber(boxData.needScore)
	local isGet = isGetThisBoxById(id)
	if(isGet)then
		-- 已领取状态 3
		retState = 3
	else
		local curScore = getCurScore()
		if(curScore >= retNeedScore)then
			-- 可领取状态 2
			retState = 2
		else
			-- 不可领取状态 1
			retState = 1
		end
	end
	return retState,retNeedScore
end


-- 是否已经领取
function isGetThisBoxById( id )
	local isHave = false
	local data = getEverydayInfo()
	if(data == nil)then
		return isHave
	end
	if(data.va_active.prize)then
		for k,v in pairs(data.va_active.prize) do
			if(tonumber(id) == tonumber(v))then
				isHave = true
				break
			end
		end
	end
	return isHave
end

-- 添加已领取的箱子id
function addGetBoxId( id )
	if(_totalInfo == nil)then
		return
	end
	if(_totalInfo.va_active.prize)then
		local isIn = isGetThisBoxById(id)
		if(isIn == false)then
			table.insert(_totalInfo.va_active.prize,id)
		end
	else
		_totalInfo.va_active.prize = {}
		table.insert(_totalInfo.va_active.prize,id)
	end
end


-- 是否提示红圈
function getIsShowTipSprite( ... )
	local ret = true
	local data = getEverydayInfo()
	if(data == nil)then
		return ret
	end
	if(data.va_active.prize)then
		if(table.count(data.va_active.prize) >= 3)then
			ret = false
		end
	end
	return ret
end











