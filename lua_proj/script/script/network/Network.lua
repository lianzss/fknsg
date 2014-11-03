-- Filename: Network.lua
-- Author: fang
-- Date: 2013-05-28
-- Purpose: 该文件用于网络调用相关模块公用处理函数

module ("Network", package.seeall)

require "script/ui/tip/AlertTip"


require "script/ui/network/LoadingUI"

if(g_system_type == kBT_PLATFORM_IOS or g_system_type == kBT_PLATFORM_ANDROID) then

	-- 
	local tm_cbFuncs = {}
	local re_cbFuncs = {}
	local no_loading_cbFunc = {}
	local loadingUI = nil

	-- lua层主动调用网络连接接口
	-- phost: 服务器hostname或ip
	-- pport: 服务器端口
	function connect (phost, pport)
		local dhost = phost or g_host
		local dport = pport or g_port

		local client = BTNetClient:getInstance()

	    if (not client:connectWithAddr(dhost, dport)) then
	        CCLuaLog("The network is unavailable.")
	        return false
	    end
	    return true
	end

	----------------------------------------------- 推送 add by chengliang ----------------------------------------
	-- 推送
	function re_rpc( cbFunc, cbFlag, rpcName )
		local disp = BTEventDispatcher:getInstance()
	    disp:addLuaHandler(cbFlag, re_networkHandler, false)
	    re_cbFuncs[cbFlag] = cbFunc
	end
	-- 删除 推送
	function remove_re_rpc( cbFlag )
		re_cbFuncs[cbFlag] = nil
	end


	function re_networkHandler(cbFlag, dictData, bRet)
		if not bRet then
			-- 先调错误页面
			print ("Warning re_networkHandler, you need add ErrorPage showing here.")
		end
		-- 把网络结果传给UI
		if (re_cbFuncs[cbFlag] == nil) then
			return
		end
		re_cbFuncs[cbFlag](cbFlag, dictData, bRet)
	end

	----------------------------------------------- 无LoadingUI add by chengliang ----------------------------------------
	-- 
	function no_loading_rpc( cbFunc, cbFlag, rpcName, args )
		
		local disp = BTEventDispatcher:getInstance()
	    disp:addLuaHandler(cbFlag, no_loading_networkHandler, false)
	    disp:callRPC(cbFlag, rpcName, args)
	    no_loading_cbFunc[cbFlag] = cbFunc
	end
	-- 删除 
	function remove_no_loading_rpc( cbFlag )
		no_loading_cbFunc[cbFlag] = nil
	end

	-- 网络返回参数处理
	function no_loading_networkHandler(cbFlag, dictData, bRet)
		
		if not bRet and g_debug_mode then
		-- 调试模式先调错误页面
			require "script/ui/tip/AlertTip"
			AlertTip.showAlert(dictData.err, function ( ... )
				-- body
			end)
		end

		-- 把网络结果传给UI
		if (no_loading_cbFunc[cbFlag] == nil) then
			return
		end
		no_loading_cbFunc[cbFlag](cbFlag, dictData, bRet)
		no_loading_cbFunc[cbFlag] = nil
	end

	----------------------------------------------- 正常请求 有LoadingUI ----------------------------------------
	function fnRpcDebug(cbFunc)
		BTEventDispatcher:getInstance():addLuaHandler("failed", cbFunc, false)
		local cbFlag = "user.closeMe"
		local rpcName = "user.closeMe"
		local args = CCArray:createWithObject(CCString:create("fnRpcDebug")); 

		local disp = BTEventDispatcher:getInstance()

	    disp:addLuaHandler(cbFlag, cbFunc, true)
	    disp:callRPC(cbFlag, rpcName, nil)

	end
		--调用网络接口 
	--cbFunc: 回调的方法 type->lua function
	--cbFlag: 回调的标识名称, 用于区别其他回调 type->string
	--rpcName: 调用后端函数的名称 type->string
	--args: 调用函数需要的参数  type->CCArray
	--autoRelease: 调用完成后是否删除此回调方法
	--return:无
	function rpc(cbFunc, cbFlag, rpcName, args, autoRelease)
		local disp = BTEventDispatcher:getInstance()

	    disp:addLuaHandler(cbFlag, networkHandler, autoRelease)
	    disp:callRPC(cbFlag, rpcName, args)

	    tm_cbFuncs[cbFlag] = cbFunc

	    LoadingUI.addLoadingUI()
	    -- 网络请求 0.5秒后才出现
	    -- LoadingUI.setVisiable(false)
	    -- local runningScene = CCDirector:sharedDirector():getRunningScene()
	    -- local actionArray = CCArray:create()
	    -- actionArray:addObject(CCDelayTime:create(0.5))
	    -- actionArray:addObject(CCCallFunc:create(function ( ... )
	    -- 	if(tm_cbFuncs[cbFlag] ~= nil) then
	    -- 		LoadingUI.setVisiable(true)
	    -- 		local actions = CCArray:create()
	    -- 		actions:addObject(CCDelayTime:create(5))
	    -- 		actions:addObject(CCCallFunc:create(function ( ... )
	    -- 			if(LoadingUI.getVisiable() == true) then
	    -- 				LoadingUI.setVisiable(false)
	    -- 			end
	    -- 		end))
	    -- 		runningScene:runAction(CCSequence:create(actions))
	    -- 	end
	    -- end))
	    -- runningScene:runAction(CCSequence:create(actionArray))

	end
	-- 网络统一接口
	function networkHandler(cbFlag, dictData, bRet)
		LoadingUI.reduceLoadingUI()
		if not bRet and g_debug_mode then
		-- 调试模式先调错误页面
			require "script/ui/tip/AlertTip"
			AlertTip.showAlert(dictData.err, function ( ... )
				-- body
			end)
		end

		-- 把网络结果传给UI
		if (tm_cbFuncs[cbFlag] == nil) then
			return
		end
		tm_cbFuncs[cbFlag](cbFlag, dictData, bRet)
		tm_cbFuncs[cbFlag] = nil
	end
	-- 网络参数统一处理接口
	function argsHandler(...)
		local args = CCArray:create()
		for k, v in ipairs({...}) do
			if (type(v) == "number") then
				args:addObject(CCInteger:create(v))
			elseif(type(v) == "string") then
				args:addObject(CCString:create(v))
			elseif(type(v) == "table") then
				args:addObject(argsHandler(v))
			else
				print("Error: unexpected type.")
			end
		end
		return args
	end

	-- 上面的函数在处理参数为table类型时出现溢出的bug
	function argsHandlerOfTable(tParams)
		if not table.isEmpty(tParams) then
			return nil
		end
		local args = CCArray:create()
		for k, v in pairs(tParams) do
			if (type(v) == "number") then
				args:addObject(CCInteger:create(v))
			elseif(type(v) == "string") then
				args:addObject(CCString:create(v))
			elseif(type(v) == "table") then
				args:addObject(argsHandlerOfTable(v))
			else
				CCLuaLog("Error: unexpected type.")
			end
		end
		return args

	end

	function close(message)

	end
else

--[[

windows phone

]]
	--
	local tm_cbFuncs = {}
	local re_cbFuncs = {}
	local loadingUI = nil
	local mConn = nil
	local mToken = "0"
	local mContext = {}
	local mId = 1

	function getArgs(...)
		local length = select('#', ...)
		local args = {}
		for i = 1, length do
			args[i] = select(i, ...)
		end
		return args
	end

	local function onClosed(message)
		Logger.warning("socket closed:%s", message)
		mConn = nil
		local context = mContext["failed"]
		if context ~= nil then
		local callback = context[1]
			callback(message)
		end
	end

	local function onBodyData(body, head)
		local data = body
		local zipped, multi = string.byte(head, 6, 7);
		if zipped ~= 0 then
			data = GameUtil:unzipData(body)
		end

		data = amf3.decode(data)
		local rets = {}
		if multi ~= 0 then
			for i = 1, #data.ret do
				if type(data.ret[i]) == 'string' then
					data.ret[i] = amf3.decode(data.ret[i])
				end
				rets[i] = data.ret[i]
			end
		else
			rets[1] = data
		end

		Logger.trace("response:%s", rets)

		if data.token ~= nil then
			mToken = data.token
		end

		if data.time then
			BTUtil:syncTime(data.time)
		end

		for i = 1, #rets do
			local ret = rets[i]
			if ret.err ~= "ping" then
				local callbackName = ret.callback.callbackName
				local context = mContext[callbackName]
				local callback = nil
				local args = nil
				if context ~= nil then
					callback = context[1]
					args = context[2]
				end

				Logger.trace("call:%s", callbackName)
				networkHandler(callbackName, callback, ret, ret.err == "ok", args)
				if context ~= nil and context[3] == nil then
					mContext[callbackName] = nil
				end
			end
		end
	end

	-- lua层主动调用网络连接接口
	-- phost: 服务器hostname或ip
	-- pport: 服务器端口
	function connect (phost, pport)
		local dhost = phost or g_host
		local dport = pport or g_port

		if mConn == nil then
			mConn = CNetwork:sharedNetwork():newConnection()
			mConn:registerBodyFunc(function(body, head)
				onBodyData(body, head)
			end)

			mConn:registerCloseFunc(function()
				onClosed()
			end)
		end

		mToken = "0"
		mContext = {}

		return mConn:connect(dhost, dport)
	end


	-- 推送
	function re_rpc( cbFunc, cbFlag, rpcName )
		registerPushCallback(cbFlag, cbFunc)
	end
	-- 删除 推送
	function remove_re_rpc( cbFlag )
		mContext[cbFlag] = nil
	end

	function fnRpcDebug(cbFunc)

	end

	function toArgs(args)
		local stype = type(args)
		if stype == 'table' then
			return args
		elseif stype == 'nil' then
			return {}
		elseif stype == 'userdata' then
			return cppToLua(args)
		else
			Logger.fatal("unsupported type:%s", stype)
		end
	end

	function cppToLua(arg)
		local ret = nil
		if GameUtil:isCCArray(arg) then
			arg = tolua.cast(arg, "CCArray")
			ret = {}
			for i = 0, arg:count() - 1 do
				ret[i+1] = cppToLua(arg:objectAtIndex(i))
			end
		elseif GameUtil:isCCDictionary(arg) then
			arg = tolua.cast(arg, "CCDictionary")
			ret = {}
			local keys = arg:allKeys()
			if keys ~= nil then
				for i = 0, keys:count() -1 do
					local key = cppToLua(keys:objectAtIndex(i))
					ret[key] = cppToLua(arg:objectForKey(key))
				end
			end
		elseif GameUtil:isCCInteger(arg) then
			arg = tolua.cast(arg, "CCInteger")
			ret = arg:getValue()
		elseif GameUtil:isCCBool(arg) then
			arg = tolua.cast(arg, "CCBool")
			ret = arg:getValue()
		elseif GameUtil:isCCString(arg) then
			arg = tolua.cast(arg, "CCString")
			ret = arg:getCString()
		else
			Logger.trace("unsupported type:%s", tolua.type(arg))
		end
		return ret
	end

	function rpcCall(method, callback, ...)
		if mConn == nil then
			Logger.fatal("network do not connected")
			return
		end

		local callbackName = method
		if mContext[callbackName] ~= nil then
			callbackName = method .. '_' .. mId
			mId = mId + 1
		end

		local args = getArgs(...)
		local request = {
			method=method,
			args=args,
			token=mToken,
			callback={
				callbackName=callbackName
			}
		}

		Logger.trace("request:%s", request)

		if callback ~= nil then
			mContext[callbackName] = {callback, args}
		end

		local data = amf3.encode(request)
		mConn:send(data, true)
	end



	--调用网络接口
	--cbFunc: 回调的方法 type->lua function
	--cbFlag: 回调的标识名称, 用于区别其他回调 type->string
	--rpcName: 调用后端函数的名称 type->string
	--args: 调用函数需要的参数  type->CCArray
	--autoRelease: 调用完成后是否删除此回调方法
	--return:无
	function rpc(cbFunc, cbFlag, rpcName, args, autoRelease)
		args = toArgs(args)
		rpcCall(rpcName, cbFunc, unpack(args))
		LoadingUI.addLoadingUI()
	end

	local function numberToString(data)
		local stype = type(data)
		if stype == "number" then
			data = "" .. data
		elseif stype == "table" then
			for k, v in pairs(data) do
				data[k] = numberToString(v)
			end
		end

		return data
	end

	-- 网络统一接口
	function networkHandler(cbFlag, cbFunc, dictData, bRet, args)
		LoadingUI.reduceLoadingUI()
		if not bRet and g_debug_mode then
			-- 调试模式先调错误页面
			require "script/ui/tip/AlertTip"
			AlertTip.showAlert(dictData.err, function ( ... )
				-- body
				end)
		end

		-- 把网络结果传给UI
		if cbFunc ~= nil then
			cbFunc(cbFlag, numberToString(dictData), bRet, args)
		end
	end



	function registerPushCallback(callbackName, callbackFunc)
		if mContext[callbackName] ~= nil then
			--Logger.fatal("callback:%s already exits", callbackName)
			return
		end

		if callbackFunc == nil then
			Logger.fatal("callback:%s has nil func", callbackName)
			return
		end

		mContext[callbackName] = {callbackFunc, {}, true}
	end

	function argsHandler(...)
		local args = getArgs(...)
		function args:addObject(v)
			args[#args + 1] = cppToLua(v)
		end
		return args
	end

	function close(message)
		if mConn == nil then
			return
		end
		mConn:close(message)
		mConn = nil
	end


end


