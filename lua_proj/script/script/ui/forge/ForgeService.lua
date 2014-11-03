-- FileName: ForgeService.lua 
-- Author: licong 
-- Date: 14-6-12 
-- Purpose: function description of module 


module("ForgeService", package.seeall)

--[[
	@des 	:橙装锻造
	@param 	: p_method:方法id,  p_itemId:物品id
	@return : 'ok'成功,'err'失败
]]
function compose( p_method, p_itemId, callbackFunc )
	local function requestFunc( cbFlag, dictData, bRet )
		print ("compose---后端数据")
		if(dictData.err == "ok")then
			local dataRet = dictData.ret
			print("dictData.ret")
			print_t(dataRet)
			if(dataRet == "ok")then
				if(callbackFunc ~= nil)then
					callbackFunc(true)
				end
			else
				if(callbackFunc ~= nil)then
					callbackFunc(false)
				end
			end
		end
	end
	local args = CCArray:create()
	args:addObject(CCString:create(p_method))
	args:addObject(CCString:create(p_itemId))
	Network.rpc(requestFunc, "forge.compose", "forge.compose", args, true)
end