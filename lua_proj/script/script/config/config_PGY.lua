-- Filename: config_PP.lua
-- Author: chao he
-- Date: 2013-09-22
-- Purpose: PP平台配置


module("config", package.seeall)

loginInfoTable = {}

function getFlag( ... )
	return "pgyphone"
	-- return "pgycopyphone"
end


function getServerListUrl( ... )
 	return "http://mapifknsg.zuiyouxi.com/phone/serverlistnotice/?".. Platform.getUrlParam()
end 

function getPidUrl( sessionid )
	local url = "http://mapifknsg.zuiyouxi.com/phone/login/"
	if(sessionid == nil)then
        sessionid = Platform.getSdk():callStringFuncWithParam("getSessionId",nil)
    end
	local postString = url .. "?token=" .. sessionid .. Platform.getUrlParam() .. "&bind=" .. g_dev_udid
 	return postString
end 

function getHashUrl( )
 	return "http://mapifknsg.zuiyouxi.com/phone/getHash/"
end 

function getAppId( ... )
	return "2455"
end

function getAppKey( ... )
	return "4ff83cc9bc80836dbafe9fd5930f989e"
end

function getName( ... )
	return GetLocalizeStringBy("key_2196")
end

-- function getPayParam( coins )
-- 	local dict = CCDictionary:create()
-- 	dict:setObject(CCString:create(coins),"coins")
-- 	dict:setObject(CCString:create(BTUtil:getSvrTimeInterval()),"serverTime")
-- 	dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
-- 	dict:setObject(CCString:create(loginInfoTable.uid),"uid")
-- 	dict:setObject(CCString:create(UserModel.getUserUid()),"appUid")
-- 	dict:setObject(CCString:create("金币"),"title")

-- 	return dict
-- end

function getPayParam( coins, payType, amount )
	-- 支付类型枚举(payType)
	kPay_GoldCoins  =  "00"
	kPay_MonthCard  =  "01"
	local dict = CCDictionary:create()
	dict:setObject(CCString:create(coins),"coins")
	dict:setObject(CCString:create(BTUtil:getSvrTimeInterval()),"serverTime")
	dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
	dict:setObject(CCString:create(loginInfoTable.uid),"uid")
	dict:setObject(CCString:create(UserModel.getUserUid()),"appUid")
	if( payType ~= nil and payType == kPay_MonthCard )then
	--月卡购买
		local m_amount = 1
	    if( amount ~= nil )then
      		m_amount = amount
    	end
		dict:setObject(CCString:create(m_amount.."月卡"),"title")
  	elseif ( payType ~= nil and payType == kPay_GoldCoins ) then
  	--金币充值
		dict:setObject(CCString:create(coins.."金币"),"title")
  	else
  	--金币充值
  		dict:setObject(CCString:create(coins.."金币"),"title")
  	end
	
	return dict
end

function setLoginInfo( xmlTable )
	loginInfoTable.uid = xmlTable:find("uid")[1]
	loginInfoTable.newuser = xmlTable:find("newuser")[1]
	print("loginInfoTable.uid:",loginInfoTable.uid)
end

--debug conifg

function getPidUrl_debug( sessionid )
	local url = "http://119.255.38.86/phone/login/"
	-- local url = "http://124.205.151.82/phone/login/"
 	if(sessionid == nil)then
        sessionid = Platform.getSdk():callStringFuncWithParam("getSessionId",nil)
    end
	local postString = url .. "?token=" .. sessionid .. Platform.getUrlParam() .. "&bind=" .. g_dev_udid
 	return postString
end 
function getServerListUrl_debug( ... )
 	return "http://119.255.38.86/phone/serverlistnotice/?".. Platform.getUrlParam()
 	-- return "http://124.205.151.82/phone/serverlistnotice/?".. Platform.getUrlParam()
end 

function getAppId_debug( ... )
	return "2099"
	--《主公去哪儿》
end

function getAppKey_debug( ... )
	return "f42c66137e2b28a79f5bc931ad831338"
end
