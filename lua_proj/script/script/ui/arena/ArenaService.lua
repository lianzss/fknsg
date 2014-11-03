-- FileName: ArenaService.lua 
-- Author: Li Cong 
-- Date: 13-8-12 
-- Purpose: function description of module 


module("ArenaService", package.seeall)


-- 得到竞技场数据
-- callbackFunc:回调
function getArenaInfo( callbackFunc )
	local function requestFunc( cbFlag, dictData, bRet )
		-- print ("getArenaInfo---后端数据")
		if(bRet == true)then
			-- print_t(dictData.ret)
			local dataRet = dictData.ret
			if(dataRet.ret == "lock")then
				-- 竞技场业务忙
				require "script/ui/tip/AnimationTip"
				local str = GetLocalizeStringBy("key_2152")
				AnimationTip.showTip(str)
				return
			end
			if(dataRet.ret == "ok")then
				ArenaData.arenaInfo = dataRet.res
				-- 设置挑战列表数据
				ArenaData.setOpponentsData( dataRet.res.opponents )
				callbackFunc()
			end
		end
	end
	Network.rpc(requestFunc, "arena.getArenaInfo", "arena.getArenaInfo", nil, true)
end


-- 得到幸运排名数据
-- callbackFunc:回调
function getLuckyList( callbackFunc )
	local function requestFunc( cbFlag, dictData, bRet )
		-- print ("getLuckyList---后端数据")
		if(bRet == true)then
			-- print_t(dictData.ret)
			ArenaData.luckyListData = dictData.ret
			callbackFunc()
		end
	end
	Network.rpc(requestFunc, "arena.getLuckyList", "arena.getLuckyList", nil, true)
end


-- 领取奖励数据
-- callbackFunc:回调
function hasReward( callbackFunc )
	local function requestFunc( cbFlag, dictData, bRet )
		-- print ("hasReward---后端数据")
		if(bRet == true)then
			-- print_t(dictData.ret)
			ArenaData.rewardData = dictData.ret
			callbackFunc()
		end
	end
	Network.rpc(requestFunc, "arena.hasReward", "arena.hasReward", nil, true)
end


-- 得到前十排行榜数据
-- callbackFunc:回调
function getRankList( callbackFunc )
	local function requestFunc( cbFlag, dictData, bRet )
		-- print ("getRankList---后端数据")
		if(bRet == true)then
			-- print_t(dictData.ret)
			ArenaData.rankListData = dictData.ret
			callbackFunc()
		end
	end
	Network.rpc(requestFunc, "arena.getRankList", "arena.getRankList", nil, true)
end


-- 挑战数据
-- position: 排名	
-- atkedUid: 排名对应的用户uid, 等于0的时候攻击这个位置的人	
-- callbackFunc:回调
function challenge(position, atkedUid, callbackFunc )
	if(ItemUtil.isBagFull() == true )then
		-- AnimationTip.showTip(GetLocalizeStringBy("key_2094"))
		return
	end
	-- 判断武将满了
	require "script/ui/hero/HeroPublicUI"
    if HeroPublicUI.showHeroIsLimitedUI() then
    	return
    end
	-- 当前剩余次数为0不能挑战
	print(GetLocalizeStringBy("key_2252"),UserModel.getStaminaNumber())
	if( (UserModel.getStaminaNumber()-2)  < 0 )then
		-- 挑战次数已用完
		-- require "script/ui/tip/AnimationTip"
		-- local str = GetLocalizeStringBy("key_3157")
		-- AnimationTip.showTip(str)
		require "script/ui/item/StaminaAlertTip"
		StaminaAlertTip.showTip( ArenaLayer.upDateStamina )
		return
	end
	-- 正在发奖中不能挑战
	if(ArenaData.getAwardTime() <= 0)then
		require "script/ui/tip/AnimationTip"
		local str = GetLocalizeStringBy("key_2290")
		AnimationTip.showTip(str)
		return
	end

	local function requestFunc( cbFlag, dictData, bRet )
		print ("challenge---后端数据")
		if(bRet == true)then
			print_t(dictData.ret)
			-- ArenaData.challengeData = dictData.ret
			local dataRet = dictData.ret
			if(dataRet.ret == "ok")then
				-- 设置消耗耐力值
				UserModel.addStaminaNumber(-2)
				-- 是否需要更新列表
				local isNeedReload = false
				-- 名次是否上升
				local isUp = false
				-- 判断玩家名次是否上升
				if( tonumber(position) < ArenaData.getSelfRanking() )then
					-- 判断战斗是否胜利
					if(dataRet.atk.appraisal ~= "E" and dataRet.atk.appraisal ~= "F")then
						-- 胜利  改变名次
						ArenaData.setSelfRanking( position )
						-- 设置挑战列表数据
						ArenaData.setOpponentsData( dataRet.opponents )
						isNeedReload = true
						isUp = true
					end
				end
				-- UI回调 参数:战斗串
				-- print("position",position)
				callbackFunc( dataRet.atk, isNeedReload, isUp, position, dataRet.flop)
			end
			-- 对手位置发生变化，此时对方已经不在自己的挑战列表 
			if(dataRet.ret == "opponents_err")then
				print("here is opponents_err")
				require "script/ui/tip/AnimationTip"
				local str = GetLocalizeStringBy("key_1938")
				AnimationTip.showTip(str)
				-- 设置挑战列表数据
				ArenaData.setOpponentsData( dataRet.opponents )
				-- 更新玩家列表UI
				ArenaData.allUserData = ArenaData.getOpponentsData()
				ArenaChallenge.challengeTableView:reloadData()
				-- 设置偏移量 让自己居中
				local cellBg = CCSprite:create( ArenaLayer.IMG_PATH .. "arena_cellbg.png")
				local cellSize = cellBg:getContentSize() 
				local index = nil
				for k,v in pairs(ArenaData.allUserData) do
					if( tonumber(v.uid) == UserModel.getUserUid() )then
						-- 如果是主角
						index = tonumber(k)
					end
				end
				-- 1默认显示在顶部,2名正常显示,11名显示底部,其他显示中间
				if(index ~= 1 and index ~= 2 and index ~= 11)then
					-- 设置偏移量 把自己显示在中间
					ArenaChallenge.challengeTableView:setContentOffset( ccp(0, (index-10)*(cellSize.height+10)-18 ))
				end
				-- 如果是最后一名 
				if(index == 11)then
					-- 设置偏移量 把自己显示在最底部
					ArenaChallenge.challengeTableView:setContentOffset( ccp(0, (index-11)*(cellSize.height+10)+15 ))
				end
				callbackFunc( nil )
			end
		end
	end
	-- 参数
	local args = CCArray:create()
	args:addObject(CCInteger:create(position))
	args:addObject(CCInteger:create(atkedUid))
	Network.rpc(requestFunc, "arena.challenge", "arena.challenge", args, true)
end



-- 得到购买数据数据
-- goodsId:商品id
-- num:数量
-- callbackFunc:回调
function buy( goodsId, num, callbackFunc )
	local function requestFunc( cbFlag, dictData, bRet )
		print ("buy---后端数据")
		if(bRet == true)then
			print_t(dictData.ret)
			local dataRet = dictData.ret
			if(dataRet == "ok")then
				callbackFunc()
			end
		end
	end
	-- 参数
	local args = CCArray:create()
	args:addObject(CCInteger:create(tonumber(goodsId)))
	args:addObject(CCInteger:create(tonumber(num)))
	Network.rpc(requestFunc, "arena.buy", "arena.buy", args, true)
end





















