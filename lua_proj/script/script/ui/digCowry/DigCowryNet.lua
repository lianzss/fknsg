-- Filename：	DigCowryNet.lua
-- Author：		Li Pan
-- Date：		2014-1-8
-- Purpose：		挖宝

module("DigCowryNet", package.seeall)

require "script/network/Network"
require "script/ui/digCowry/DigCowryData"

function getDigInfo(uiCallBack)
	local function callback(flag,dictData,err)
		print("the DigCowryData.digInfo is :")
		print_t(dictData)
		DigCowryData.digInfo = dictData.ret
		print_t(dictData.ret)
		-- print("the dictData is :" .. dictData.ret.boss_time)
		uiCallBack()
	end 
	local args = CCArray:create()
	args:addObject(CCString:create(tostring(1)))
	Network.rpc(callback, "robtomb.getMyRobInfo", "robtomb.getMyRobInfo", args, true)
end


function digCowry(uiCallBack, times ,type)
	local function callback(flag,dictData,err)
		local ret = dictData.err
		if(ret ~= "ok") then
			return
		end
		print("the digCowry.digInfo is :")
		print_t(dictData)
		DigCowryData.DigCowryInfo = dictData.ret
		print_t(dictData.ret)
		-- print("the dictData is :" .. dictData.ret.boss_time)
		uiCallBack()
	end 
	local args = CCArray:create()
	args:addObject(CCString:create(tostring(times)))
	args:addObject(CCString:create(tostring(type)))

	Network.rpc(callback, "robtomb.rob", "robtomb.rob", args, true)
end
