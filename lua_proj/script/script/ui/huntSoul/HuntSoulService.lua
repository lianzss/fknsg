-- FileName: HuntSoulService.lua 
-- Author: Li Cong 
-- Date: 14-2-11 
-- Purpose: function description of module 


module("HuntSoulService", package.seeall)
require "script/ui/huntSoul/HuntSoulData"
require "script/model/user/UserModel"

-- 得到猎魂数据
-- callbackFunc:回调
function getHuntInfo( callbackFunc )
	local function requestFunc( cbFlag, dictData, bRet )
		print ("getHuntInfo---后端数据")
		if(bRet == true)then
			print_t(dictData.ret)
			local dataRet = dictData.ret
			-- 设置当前场景
			HuntSoulData.setHuntPlaceId(dataRet)
			-- 回调
			if(callbackFunc)then
				callbackFunc()
			end
		end
	end
	Network.rpc(requestFunc, "hunt.getHuntInfo", "hunt.getHuntInfo", nil, true)
end


-- 召唤神龙
-- type:类型:0物品,1金币,默认值0
-- callbackFunc:回调
function skip( type, callbackFunc )
	local function requestFunc( cbFlag, dictData, bRet )
		print ("skip---后端数据")
		if(bRet == true)then
			print_t(dictData.ret)
			local dataRet = dictData.ret
			-- 设置当前场景
			HuntSoulData.setHuntPlaceId(dataRet.place)
			-- 回调
			if(callbackFunc)then
				callbackFunc( dataRet.item,  dataRet.extra)
			end
		end
	end
	-- 参数
	local args = CCArray:create()
	args:addObject(CCInteger:create(type))
	Network.rpc(requestFunc, "hunt.skip", "hunt.skip", args, true)
end


-- 猎魂
-- num 次数：默认值1
-- callbackFunc:回调
function huntSoul( num, callbackFunc )
	local function requestFunc( cbFlag, dictData, bRet )
		print ("huntSoul---后端数据")
		if(bRet == true)then
			print_t(dictData.ret)
			local dataRet = dictData.ret
			-- 设置当前场景
			HuntSoulData.setHuntPlaceId(dataRet.place)
			-- 扣除花费的银币
			UserModel.addSilverNumber(-tonumber(dataRet.silver))
			-- 回调
			if(callbackFunc)then
				callbackFunc( dataRet.item )
			end

			-- added by zhz,给台湾版本的炫耀
			-- require "db/DB_Item_fightsoul"
			-- require "script/ui/showOff/ShowOffUtil"
			-- for item_id, item_temple_id in pairs( dataRet.item ) do
			-- 	local itemData= DB_Item_fightsoul.getDataById(tonumber(item_temple_id) )
			-- 	if( itemData.quality>=5 ) then
			-- 		ShowOffUtil.sendShowOffByType(7, tonumber(item_temple_id))
			-- 		break
			-- 	end
			-- end 

		end
	end
	-- 参数
	local args = CCArray:create()
	args:addObject(CCInteger:create(num))
	Network.rpc(requestFunc, "hunt.huntSoul", "hunt.huntSoul", args, true)
end


-- 升级战魂
-- itemId: 目标id
-- itemIds:被吃掉的战魂
-- callbackFunc:回调
function promote( itemId, itemIds, callbackFunc )
	local function requestFunc( cbFlag, dictData, bRet )
		print ("promote---后端数据")
		if(bRet == true)then
			print_t(dictData.ret)
			local dataRet = dictData.ret
			-- 回调
			if(callbackFunc)then
				callbackFunc(dataRet.va_item_text.fsLevel,dataRet.va_item_text.fsExp,dataRet.item_id)
			end
		end
	end
	-- 参数
	local args = CCArray:create()
	args:addObject(CCInteger:create(itemId))
	local idArray = CCArray:create()
	print("----itemIds---")
	for k,v in pairs(itemIds) do
		print(k,v)
		idArray:addObject(CCInteger:create(v))
	end
	args:addObject(idArray)
	Network.rpc(requestFunc, "forge.promote", "forge.promote", args, true)
end



-- /*
--  * 跳转猎魂
--  * 
--  * @param int $num 次数：默认值10
--  * @return array
--  * <code>
--  * {
--  * 		'item':战魂数组
--  * 		{
--  * 			{
--	*			 $itemId => $itemTplId
--	*			}
--  * 		}
--  * 		'place':下一个场景id
--  * 		'silver':花费银币
--  * }
--  * </code>
--  */
function skipHunt( callbackFunc )
	local function requestFunc( cbFlag, dictData, bRet )
		print ("skipHunt---后端数据")
		if(dictData.err == "ok")then
			print_t(dictData.ret)
			local dataRet = dictData.ret
			-- 设置当前场景
			HuntSoulData.setHuntPlaceId(dataRet.place)
			-- 扣除花费的银币
			UserModel.addSilverNumber(-tonumber(dataRet.silver))
			-- 回调
			if(callbackFunc)then
				callbackFunc(dataRet.item, dataRet.extra)
			end
		end
	end
	-- 参数
	-- local args = CCArray:create()
	-- args:addObject(CCInteger:create(p_num))
	Network.rpc(requestFunc, "hunt.skipHunt", "hunt.skipHunt", args, true)
end

















