-- Filename: HeroPublicUI.lua
-- Author: fang
-- Date: 2013-10-31
-- Purpose: 该文件用于: 武将系统公用UI

module("HeroPublicUI", package.seeall)

-- 武将初始值上限
local _nHeroMaxLimit=100


-- 武将扩充
function showHeroExpandUI(tParam)
	local beginNumber=_nHeroMaxLimit
	local currentLimitNumber=UserModel.getHeroLimit()
	local function fnCaculateCost(times)
		if times <=0 then
			return 0
		end
		if times == 1 then
			return 25
		end
		return fnCaculateCost(times-1)+25
	end
	-- 需要花费金币
	local nGoldCost = fnCaculateCost((currentLimitNumber-_nHeroMaxLimit)/5 + 1)
	_nGoldCost = nGoldCost
	if nGoldCost > UserModel.getGoldNumber() then
		--添加金币不足提示 by zhang zihang
		--AnimationTip.showTip(GetLocalizeStringBy("key_3365"))
		require "script/ui/tip/LackGoldTip"
		LackGoldTip.showTip()
		return
	end
	-- 购买武将格子网络回调
	local function fnHandlerOfNetwork(cbFlag, dictData, bRet)
		if bRet then
			local nRetValue = tonumber(dictData.ret)
			local nAdded = nRetValue-UserModel.getHeroLimit()
			UserModel.addGoldNumber(-_nGoldCost)
			UserModel.setHeroLimit(nRetValue)
			AnimationTip.showTip(GetLocalizeStringBy("key_2343")..nAdded..GetLocalizeStringBy("key_2491"))
			if tParam and type(tParam.cb_expand) == "function" then
				tParam.cb_expand()
			end
		end
	end

	local function fnConfirm(bConfirm)
		if bConfirm then
			Network.rpc(fnHandlerOfNetwork, "user.openHeroGrid", "user.openHeroGrid", nil, true)
		end
	end
	AlertTip.showAlert(GetLocalizeStringBy("key_1371")..nGoldCost..GetLocalizeStringBy("key_1491"), fnConfirm, true)
end

-- 武将携带数量已达上限提示，如果武将数量未达上限则不弹出提示.
-- return: true表示已达上限, false表示未达上限，可继续操作.
function showHeroIsLimitedUI(tParam)
	require "script/model/hero/HeroModel"
	if not HeroModel.isLimitedCount() then
		return false
	end
	require "script/ui/tip/AlertTip"
	local function fnAlertCb(bParam)
		if bParam then
			showHeroExpandUI(tParam)
		else
			require "script/ui/hero/HeroSellLayer"
			require "script/ui/main/MainScene"
			MainScene.changeLayer(HeroSellLayer.createLayer(), "HeroSellLayer")
		end
	end
--	AlertTip.showAlert(GetLocalizeStringBy("key_1962"), fnAlertCb, true, nil, GetLocalizeStringBy("key_1158"), GetLocalizeStringBy("key_1401"))
	local tArgs = {}
	tArgs.text = GetLocalizeStringBy("key_1962")
	tArgs.items = {}
	tArgs.items[1] = {text=GetLocalizeStringBy("key_1158"), tag=1001, pos_x=20, pos_y=30}
	tArgs.items[2] = {text=GetLocalizeStringBy("key_1401"), tag=1002, pos_x=200, pos_y=30}
	tArgs.items[3] = {text=GetLocalizeStringBy("key_1269"), tag=1003, pos_x=370, pos_y=30}
	tArgs.callback = function (pTag)
		if pTag == 1002 then
			require "script/ui/hero/HeroSellLayer"
			require "script/ui/main/MainScene"
			MainScene.changeLayer(HeroSellLayer.createLayer(), "HeroSellLayer")
		elseif pTag == 1001 then
			showHeroExpandUI(tParam)
		elseif pTag == 1003 then
			require "script/ui/hero/HeroLayer"
			MainScene.changeLayer(HeroLayer.createLayer(), "HeroLayer")
		end
	end
	AlertTip.showNoramlDialog(tArgs)

	return true
end






