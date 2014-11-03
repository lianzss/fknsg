-- Filename: config_PP.lua
-- Author: chao he
-- Date: 2013-09-22
-- Purpose: PP平台配置


module("config", package.seeall)

loginInfoTable = {}

function getFlag( ... )
	return "haima"
end


function getServerListUrl( ... )
 	return "http://mapifknsg.zuiyouxi.com/phone/serverlistnotice/?".. Platform.getUrlParam()
end 

function getPidUrl( sessionid )
	local url = "http://mapifknsg.zuiyouxi.com/phone/login/"
	if(sessionid == nil)then
        sessionid = Platform.getSdk():callStringFuncWithParam("getSessionId",nil)
    end
	local postString = url .. "?uid=" .. sessionid .. Platform.getUrlParam().. "&bind=" .. g_dev_udid
 	return postString
end 

function getHashUrl( )
 	return "http://mapifknsg.zuiyouxi.com/phone/getHash/"
end 

function getAppId( ... )
	return "300031439"
end

function getAppKey( ... )
	return "MEMyOEIxOEE2ODg2NThEMjRDQkVCODA3REY5NkZFNEMxNTExNjg3M01UVTNOVGs1TmpNek5EQXlORE14T0RreU9ETXJNVE14TWpFNE56TXdNemd3T0RRME56RXpOekU0T1RJMU1UVXpNakkyTVRVMk16WTBNamt4"
end

function getName( ... )
	return "海马社区"
end

function getPayParam( coins )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create(coins),"coins")
	dict:setObject(CCString:create(BTUtil:getSvrTimeInterval()),"serverTime")
	dict:setObject(CCString:create(loginInfoTable.uid),"pid")
	dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
	print("getPayParam",loginInfoTable.uid)
	return dict 
end

function setLoginInfo( xmlTable )
	print("setLoginInfo")
	loginInfoTable.uid = xmlTable:find("uid")[1]
	print_table("",loginInfoTable)
end
 
--debug conifg

function getPidUrl_debug( sessionid )
	local url = "http://124.205.151.82/phone/login/"
 	if(sessionid == nil)then
        sessionid = Platform.getSdk():callStringFuncWithParam("getSessionId",nil)
    end
	local postString = url .. "?uid=" .. sessionid .. Platform.getUrlParam().. "&bind=" .. g_dev_udid
 	return postString
end 
function getServerListUrl_debug( ... )
 	return "http://124.205.151.82/phone/serverlistnotice/?".. Platform.getUrlParam()
end 

function getAppId_debug( ... )
	return "300031439"
end

function getAppKey_debug( ... )
	return "MEMyOEIxOEE2ODg2NThEMjRDQkVCODA3REY5NkZFNEMxNTExNjg3M01UVTNOVGs1TmpNek5EQXlORE14T0RreU9ETXJNVE14TWpFNE56TXdNemd3T0RRME56RXpOekU0T1RJMU1UVXpNakkyTVRVMk16WTBNamt4"
end
