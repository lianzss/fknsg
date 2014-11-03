-- FileName: EverydayService.lua 
-- Author: Li Cong 
-- Date: 14-3-18 
-- Purpose: function description of module 


module("EverydayService", package.seeall)

require "script/ui/everyday/EverydayData"

-- 得到每日任务数据
-- callbackFunc:回调
function getActiveInfo( callbackFunc )
	local function requestFunc( cbFlag, dictData, bRet )
		print ("getActiveInfo---后端数据")
		if(bRet == true)then
			print_t(dictData.ret)
			local dataRet = dictData.ret
			EverydayData.setEverydayInfo(dataRet)
			-- 回调
			if(callbackFunc)then
				callbackFunc()
			end
		end
	end
	Network.rpc(requestFunc, "active.getActiveInfo", "active.getActiveInfo", nil, true)
end


-- 领取箱子
-- callbackFunc:回调
function getPrize( id, callbackFunc )
	local function requestFunc( cbFlag, dictData, bRet )
		print ("getPrize---后端数据")
		if(bRet == true)then
			print_t(dictData.ret)
			local dataRet = dictData.ret
			if(dataRet == "ok")then
				-- 修改领取的数据
				EverydayData.addGetBoxId(id)
				-- 回调
				if(callbackFunc)then
					callbackFunc()
				end
			end
		end
	end
	local args = CCArray:create()
	args:addObject(CCInteger:create(tonumber(id)))
	Network.rpc(requestFunc, "active.getPrize", "active.getPrize", args, true)
end










