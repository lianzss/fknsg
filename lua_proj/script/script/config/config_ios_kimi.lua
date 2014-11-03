-- Filename: Platform.lua
-- Author: baoxu
-- Date: 2014-02-21
-- Purpose: 


module("config", package.seeall)

loginInfoTable = {}
function getServerListUrl( ... )
 	return "http://mapifknsg.zuiyouxi.com/phone/serverlistnotice/?pl=kmphone&gn=sanguo&os=ios"
end 

function getPidUrl( sessionid )
	local url = "http://mapifknsg.zuiyouxi.com/phone/login/"
	if(sessionid == nil)then
        sessionid = Platform.getSdk():callStringFuncWithParam("getSessionId",nil)
    end
	local postString = url .. "?token=" .. sessionid .. "&gn=sanguo&pl=kmphone&os=ios&uid=" .. Platform.getSdk():callIntFuncWithParam("getUserId",nil) .. "&bind=" .. g_dev_udid
 	return postString
end 

function getHashUrl( )
 	return "http://mapifknsg.zuiyouxi.com/phone/getHash/"
end 

function getAppId( ... )
	return "131029"
end

function getAppKey( ... )
	return "qf5NaPn1J&Wj8wdSqfMBZO#1JWuj8FdS"
end

function getName( ... )
	return "奇米社区"
end

function getPayParam( coins )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create(coins),"coins")
	dict:setObject(CCString:create(loginInfoTable.uid),"uid")
	dict:setObject(CCString:create(BTUtil:getSvrTimeInterval()),"serverTime")
 	dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
	return dict
end

function getGroupParam( ... )
    local dict = CCDictionary:create()
    dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
    return dict
end

function setLoginInfo( xmlTable )
	print("setLoginInfo")
	loginInfoTable.uid = xmlTable:find("uid")[1]
end

--debug conifg

function getPidUrl_debug( sessionid )
	--local url = "http://124.205.151.82/phone/login"
    local url = "http://210.73.211.219/phone/login"
 	if(sessionid == nil)then
        sessionid = Platform.getSdk():callStringFuncWithParam("getSessionId",nil)
    end
	local postString = url .. "?klsso=" .. sessionid .. "&gn=sanguo&pl=kmphone&os=ios&uid=" .. Platform.getSdk():callStringFuncWithParam("getUserId",nil) .. "&userName=" .. Platform.getSdk():callStringFuncWithParam("getUserName",nil) .. "&bind=" .. g_dev_udid
    print("userid = ",Platform.getSdk():callStringFuncWithParam("getUserId",nil))
 	return postString
end 
function getServerListUrl_debug( ... )
    --return "http://124.205.151.82/phone/serverlistnotice/?pl=kmphone&gn=sanguo&os=ios"
    return "http://210.73.211.219/phone/serverlistnotice/?pl=kmphone&gn=sanguo&os=ios"
end 

function getAppId_debug( ... )
	return "131029"
end

function getAppKey_debug( ... )
	return "qf5NaPn1J&Wj8wdSqfMBZO#1JWuj8FdS"
end
