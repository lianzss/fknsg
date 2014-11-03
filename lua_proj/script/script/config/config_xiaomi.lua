-- Filename: config_xiaomi.lua
-- Author: chao he
-- Date: 2013-11-7
-- Purpose: android 小米 平台配置
module("config", package.seeall)

loginInfoTable = {}

function getFlag( ... )
	return "xmphone"
end


function getServerListUrl( ... )
 	return "http://mapifknsg.zuiyouxi.com/phone/serverlistnotice/?" .. Platform.getUrlParam()
end 

function getPidUrl( sessionid )
	local url = "http://mapifknsg.zuiyouxi.com/phone/login/"
 	if(sessionid == nil)then
        sessionid = Platform.getSdk():callStringFuncWithParam("getSessionId",nil)
    end
	local postString = url .. "?sid=" .. sessionid .. "&uid=".. Platform.getSdk():callStringFuncWithParam("getUid",nil) .. Platform.getUrlParam().."&bind=" .. g_dev_udid
 	return postString
end 

function getHashUrl( )
 	return "http://mapifknsg.zuiyouxi.com/phone/getHash/"
end 

function getAppId( ... )
	return "21123"
end

function getAppKey( ... )
	return "75ef5c90-f6f2-77b5-8a67-527a1b8223ae"
end

function getName( ... )
	return GetLocalizeStringBy("key_1100")
end

function getPayParam( coins )
	require "script/model/user/UserModel"
	require "script/ui/guild/GuildDataCache"

	local dict = CCDictionary:create()
	dict:setObject(CCString:create(coins),"coins")
	dict:setObject(CCString:create(BTUtil:getSvrTimeInterval()),"serverTime")
	dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
	dict:setObject(CCString:create(UserModel.getGoldNumber()),"gold_num")
	dict:setObject(CCString:create(UserModel.getVipLevel()),"vip")
	dict:setObject(CCString:create(UserModel.getUserUid()),"appUid")
    dict:setObject(CCString:create(UserModel.getUserName()),"appUname")
    dict:setObject(CCString:create(UserModel.getHeroLevel()),"appUlevel")

    print("appUlevel",UserModel.getHeroLevel())

	local guildName=""
	local  guildInfo= GuildDataCache.getGuildInfo()
	if( guildInfo~=nil ) then
		guildName= guildInfo.guild_name or ""
	end

	print("guild",guildName)
    dict:setObject(CCString:create(guildName),"guild")
    print("guild",guildName)
	return dict
end

--debug conifg
function getServerListUrl_debug( ... )
 	return "http://124.205.151.82/phone/serverlistnotice/?" .. Platform.getUrlParam()
end 

function getPidUrl_debug( sessionid )
	local url = "http://124.205.151.82/phone/login/"
 	if(sessionid == nil)then
        sessionid = Platform.getSdk():callStringFuncWithParam("getSessionId",nil)
    end
	local postString = url .. "?sid=" .. sessionid .. "&uid=".. Platform.getSdk():callStringFuncWithParam("getUid",nil) .. Platform.getUrlParam().."&bind=" .. g_dev_udid
 	return postString
end 

function getAppId_debug( ... )
	return "21123"
end

function getAppKey_debug( ... )
	return "75ef5c90-f6f2-77b5-8a67-527a1b8223ae"
end
