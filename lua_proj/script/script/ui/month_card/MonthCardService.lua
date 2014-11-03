-- Filename：	MonthCardService.lua
-- Author：		zhz
-- Date：		2013-6-13
-- Purpose：		月卡功能的网络层

module("MonthCardService", package.seeall)

require "script/ui/month_card/MonthCardData"
require "script/ui/tip/AnimationTip"
require "script/ui/hero/HeroPublicUI"
require "script/ui/item/ItemUtil"


-- 得到活动卡包的信息
function getCardInfo( callbackFunc )

	local function requestFunc( cbFlag, dictData, bRet )
		if(bRet == true) then
			MonthCardData.setCardInfo(dictData.ret )
			if(callbackFunc ~= nil) then
				callbackFunc()
			end
		end
	end
	
	local args = CCArray:create()
	Network.rpc(requestFunc, "monthlycard.getCardInfo", "monthlycard.getCardInfo", nil, true)
end


-- 购买月卡
function buyCard( callbackFunc , productId, num, orderId)

	local function requestFunc( cbFlag, dictData, bRet )
		if(bRet == true) then
			
			if(callbackFunc ~= nil) then
				callbackFunc()
			end
		end
	end
	
	local args = CCArray:create()
	Network.rpc(requestFunc, "monthlycard.buyCard", "monthlycard.buyCard", nil, true)
end


-- 得到每日奖励
function getDailyReward( callbackFunc )

	if( table.isEmpty(MonthCardData.getCardInfo()) ) then
		AnimationTip.showTip(GetLocalizeStringBy("key_4020") )
		return 
	end
	if(MonthCardData.isMonthCardEffect() == false ) then
		AnimationTip.showTip(GetLocalizeStringBy("key_4021"))
		return
	end

	local function requestFunc( cbFlag, dictData, bRet )
		if(bRet == true) then
			if(callbackFunc ~= nil) then
				callbackFunc()
			end
		end
	end

	local items= MonthCardData.getCardReward()

	local hasHero= false
	local hasItem= false

	-- 判断是否有hero
	for i=1, #items do
		if(items[i].type== "hero" ) then
			hasHero=true
			break
		end
	end

	-- 判断是否有item
	for i=1, #items do
		if(items[i].type== "item" ) then
			hasItem=true
			break
		end
	end

	if( hasHero and HeroPublicUI.showHeroIsLimitedUI() ) then

	elseif( hasItem and ItemUtil.isBagFull() )then

	else
		local args = CCArray:create()
		Network.rpc(requestFunc, "monthlycard.getDailyReward", "monthlycard.getDailyReward", nil, true)
		
	end

	
end


function getGift( callbackFunc )

	if( table.isEmpty(MonthCardData.getCardInfo()) ) then
		AnimationTip.showTip(GetLocalizeStringBy("key_4020") )
		return 
	end
	if(MonthCardData.getGiftStatus() ~=2 ) then
		AnimationTip.showTip(GetLocalizeStringBy("key_4021"))
		return
	end

	
	local function requestFunc( cbFlag, dictData, bRet )
		if(dictData.err == "ok") then
			if(callbackFunc ~= nil) then
				MonthCardData.setGiftStatus(3)
				callbackFunc()
			end
		end
	end


	local items= MonthCardData.getFirstReward()

	local hasHero= false
	local hasItem= false

	-- 判断是否有hero
	for i=1, #items do
		if(items[i].type== "hero" ) then
			hasHero=true
			break
		end
	end

	-- 判断是否有item
	for i=1, #items do
		if(items[i].type== "item" ) then
			hasItem=true
			break
		end
	end


	if( hasHero and HeroPublicUI.showHeroIsLimitedUI() ) then

	elseif( hasItem and ItemUtil.isBagFull() )then

	else
		local args = CCArray:create()
		Network.rpc(requestFunc, "monthlycard.getGift", "monthlycard.getGift", nil, true)
	end


	
end





