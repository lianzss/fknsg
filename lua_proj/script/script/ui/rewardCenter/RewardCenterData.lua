-- Filename: RewardCenterData.lua
-- Author: lichenyang
-- Date: 2013-08-12
-- Purpose: 奖励中心业务层

module("RewardCenterData", package.seeall)
--rewardList 数据结构: 
-- {
--          [
--              rid int:奖励的唯一ID
--              source int:类型，系统补偿、首充奖励等...(前后端预先约定好)
--              send_time int:发奖时间
--              va_reward: 具体的奖励。
--              {
--                  item:    奖励物品
--                  [
--                      {
--                          tplId int: 物品模板ID
--                          num int: 物品个数
--                      }
--                  ]
--                  gold:  金币
--                  silver： 银币
--                  soul: 将魂
--                  extra:
--                  {
--                      //不同的奖励不同。如：竞技场中有rank(排名)
--                  }
--              }
--         ]
--  }
rewardList = {}

--奖励类型
local rewardClass = {
GetLocalizeStringBy("key_3050"),						--1
GetLocalizeStringBy("key_2828"),					--2
GetLocalizeStringBy("key_1020"),						--3
GetLocalizeStringBy("key_3314"),						--4
GetLocalizeStringBy("key_3206"),					--5
GetLocalizeStringBy("key_2054"),				--6
GetLocalizeStringBy("key_2077"),						--7
{GetLocalizeStringBy("key_2282"),GetLocalizeStringBy("key_2833"),GetLocalizeStringBy("lcy_50076")},		--8
GetLocalizeStringBy("key_2015"),					--9
GetLocalizeStringBy("key_3352"),					--10
GetLocalizeStringBy("key_2831"),						--11
"",								--2013-08-12
GetLocalizeStringBy("key_1630"),				--13
GetLocalizeStringBy("key_1812"),				--14
GetLocalizeStringBy("key_1151"),						--15
GetLocalizeStringBy("key_2205")	,					--16
GetLocalizeStringBy("key_1057")	,				-- 17
GetLocalizeStringBy("groupBuyAlert"),			--18
GetLocalizeStringBy("lcy_10033"),			--19 公会任务奖励
GetLocalizeStringBy("lcy_10034"),			--20 月卡每日奖励
GetLocalizeStringBy("lcy_10035"),			--21 充值抽奖每日首冲奖励
GetLocalizeStringBy("lcy_30001"),			--22 充值放送奖励
GetLocalizeStringBy("lcy_21138"),			--23 擂台争霸32强-4强奖励
GetLocalizeStringBy("lcy_21139"),			--24 擂台争霸亚军奖励
GetLocalizeStringBy("lcy_21140"),			--25 擂台争霸冠军奖励
GetLocalizeStringBy("lcy_21141"),			--26 擂台争霸助威奖励
GetLocalizeStringBy("lcy_21142"),			--27 擂台争霸幸运奖
GetLocalizeStringBy("lcy_21143"),			--28 擂台争霸超级幸运奖
GetLocalizeStringBy("lcy_21144"),			--29 擂台赛奖池奖励
GetLocalizeStringBy("lcy_50048"),			--30 群雄争霸服内奖励
GetLocalizeStringBy("lcy_50049"),			--31 群雄争霸服内奖励
GetLocalizeStringBy("lcy_50050"),			--32 群雄争霸服内奖励
GetLocalizeStringBy("lcy_50051"),			--33 群雄争霸服内奖励
GetLocalizeStringBy("lcy_50052"),			--34 群雄争霸服内奖励
GetLocalizeStringBy("lcy_50053"),			--35 群雄争霸服内奖励
GetLocalizeStringBy("lcy_50054"),			--36 群雄争霸跨服奖励
GetLocalizeStringBy("lcy_50055"),			--37 群雄争霸跨服奖励
GetLocalizeStringBy("lcy_50056"),			--38 群雄争霸跨服奖励
GetLocalizeStringBy("lcy_50057"),			--39 群雄争霸跨服奖励
GetLocalizeStringBy("lcy_50058"),			--40 群雄争霸跨服奖励
GetLocalizeStringBy("lcy_50059"),			--41 群雄争霸跨服奖励
GetLocalizeStringBy("lcy_50060"),			--42 群雄争霸助威奖励
GetLocalizeStringBy("lcy_50061"),			--43 群雄争霸助威奖励
"",
GetLocalizeStringBy("lcy_50103"),			--45 精英回归奖励
GetLocalizeStringBy("lcy_50105"),			--46 坚守战场奖励
}

local rewardContent = {
	GetLocalizeStringBy("key_1622"),
	GetLocalizeStringBy("key_1333"),
	GetLocalizeStringBy("key_2778"),
	GetLocalizeStringBy("key_1472"),
	GetLocalizeStringBy("key_1405"),
	GetLocalizeStringBy("key_1015"),
	GetLocalizeStringBy("key_1445"),
	{GetLocalizeStringBy("key_3306"),GetLocalizeStringBy("key_1749"),GetLocalizeStringBy("lcy_50077")},
	GetLocalizeStringBy("key_3069"),
	GetLocalizeStringBy("key_2922"),
	GetLocalizeStringBy("key_3129"),
	"",
	GetLocalizeStringBy("key_1144"),
	GetLocalizeStringBy("key_2725"),
	GetLocalizeStringBy("key_2631"),
	GetLocalizeStringBy("key_3197"),
	GetLocalizeStringBy("key_3057"), -- added by zhz
	GetLocalizeStringBy("groupBuyContent"),
	GetLocalizeStringBy("lcy_10036"),			--19 公会任务奖励
	GetLocalizeStringBy("lcy_10037"),			--20 月卡每日奖励
	GetLocalizeStringBy("lcy_10038"),			--21 充值抽奖每日首冲奖励
	GetLocalizeStringBy("lcy_22345"),			--22 当前您有充值放送奖励在更新前没有领取，请领取充值放送奖励，奖励如下：
	GetLocalizeStringBy("lcy_31139"),			--23 很遗憾，您在擂台争霸赛中止步X强，奖励如下：
	GetLocalizeStringBy("lcy_31140"),			--24 恭喜您，您在擂台争霸赛中一人之下万人之上，获得亚军奖励，奖励如下：
	GetLocalizeStringBy("lcy_31141"),			--25 恭喜您，您在擂台争霸赛中击败了所有对手，获得冠军奖励：
	GetLocalizeStringBy("lcy_31142"),			--26 您助威的选手在擂台争霸赛中获得X，获得助威奖励：
	GetLocalizeStringBy("lcy_31143"),			--27 恭喜您在本轮的擂台幸运奖中被抽中，获得奖励如下：
	GetLocalizeStringBy("lcy_31144"),			--28 恭喜您在本轮的擂台超级幸运奖中被抽中，获得奖励如下：
	GetLocalizeStringBy("lcy_31145"),			--29 恭喜您获得擂台争霸赛的奖池奖励，获得奖励如下：
	GetLocalizeStringBy("lcy_50062"),			--30 恭喜您在群雄争霸服内赛的傲视群雄组中获得X强，奖励如下:
	GetLocalizeStringBy("lcy_50063"),			--31 恭喜您在群雄争霸服内赛的初出茅庐组中获得X强，奖励如下:
	GetLocalizeStringBy("lcy_50064"),			--32 恭喜您在群雄争霸服内赛的傲视群雄组中获得亚军，奖励如下：
	GetLocalizeStringBy("lcy_50065"),			--33 恭喜您在群雄争霸服内赛的初出茅庐组中获得亚军，奖励如下：
	GetLocalizeStringBy("lcy_50066"),			--34 恭喜您在群雄争霸服内赛的傲视群雄组中获得冠军，奖励如下：
	GetLocalizeStringBy("lcy_50067"),			--35 恭喜您在群雄争霸服内赛的初出茅庐组中获得冠军，奖励如下：
	GetLocalizeStringBy("lcy_50068"),			--36 恭喜您在群雄争霸跨服赛的傲视群雄组中获得X强，奖励如下:
	GetLocalizeStringBy("lcy_50069"),			--37 恭喜您在群雄争霸跨服赛的初出茅庐组中获得X强，奖励如下:
	GetLocalizeStringBy("lcy_50070"),			--38 恭喜您在群雄争霸跨服赛的傲视群雄组中获得亚军，奖励如下：
	GetLocalizeStringBy("lcy_50071"),			--39 恭喜您在群雄争霸跨服赛的初出茅庐组中获得亚军，奖励如下：
	GetLocalizeStringBy("lcy_50072"),			--40 恭喜您在群雄争霸跨服赛的傲视群雄组中获得冠军，奖励如下：
	GetLocalizeStringBy("lcy_50073"),			--41 恭喜您在群雄争霸跨服赛的初出茅庐组中获得冠军，奖励如下：
	GetLocalizeStringBy("lcy_50074"),			--42 恭喜您助威的选手在群雄争霸服内赛中获胜，您获得助威奖励：
	GetLocalizeStringBy("lcy_50075"),			--43 恭喜您助威的选手在群雄争霸跨服赛中获胜，您获得助威奖励：
	"",
	GetLocalizeStringBy("lcy_50104"), 			--45 "感谢您的回归，我们为您准备了精英回归奖励，奖励如下：",
	GetLocalizeStringBy("lcy_50106"), 			--46 "感谢您一直的陪伴，我们为您准备了坚守战场奖励，奖励如下：",
}
local rewardContentKey = {
	"","rank","rank","","","","","","rank","","","","","","rank","",""
}



-- {
--	rid		奖励id
-- 	title	奖励类型
-- 	time  	发奖时间
-- 	havaTime  	发奖时间梭
--  expireTime	过期时间
-- 	content 奖励内容
-- 	items{
-- 			bgPath 		物品模板id
--			iconPath	物品图标
-- 			num			数量
-- 			name    	名称
-- 		}
-- 	gold	金币
-- 	silver  银币
-- 	soul	将魂
-- }
---------------------------[[查询数据]]-------------------------
function getRewardList()
	local rewardViewArray = {}
	for k,v in pairs(rewardList) do
		print("start reward data by rid = ", v.rid)

		local rewardInfo = {}
		rewardInfo.rid	 = v.rid
		rewardInfo.title = rewardClass[tonumber(v.source)]		
		rewardInfo.time  = tostring(os.date(GetLocalizeStringBy("key_2732"),tonumber(v.send_time)))
		--内容描述
		local sourceString = rewardContent[tonumber(v.source)]
		if(tonumber(v.source) == 2 or tonumber(v.source) == 23) then
			rewardInfo.content = string.gsub(sourceString, "{0}", v.va_reward.extra["rank"])
		elseif(tonumber(v.source) == 3) then
			if(v.va_reward.extra["time"] ~= nil) then
				local timeInterval = tonumber(v.va_reward.extra["time"])
				local timeDes 	   = TimeUtil.getTimeForDayMD(timeInterval)
				rewardInfo.content = string.gsub(sourceString, "{0}", timeDes)
			end
			rewardInfo.content = string.gsub(rewardInfo.content or sourceString, "{1}", v.va_reward.extra["rank"])
			print("rewardInfo.content",rewardInfo.content)
		elseif(tonumber(v.source) == 4)	then
			rewardInfo.content = sourceString .. v.va_reward.silver
		elseif(tonumber(v.source) == 9 
			or tonumber(v.source) == 14
			or tonumber(v.source) == 30
			or tonumber(v.source) == 31
			or tonumber(v.source) == 36
			or tonumber(v.source) == 37) then
			rewardInfo.content = string.gsub(sourceString, "{0}", v.va_reward.extra["rank"])
		elseif(tonumber(v.source) == 8) then
			if(v.va_reward.type ~= nil) then
				rewardInfo.content  = sourceString[tonumber(v.va_reward.type)]
				rewardInfo.title = rewardClass[tonumber(v.source)][tonumber(v.va_reward.type)]	
			else
				rewardInfo.content  = sourceString[1]
				rewardInfo.title = rewardClass[tonumber(v.source)][1]
			end
		elseif(tonumber(v.source) == 12) then
			--自定义消息体
			rewardInfo.title = v.va_reward.title or GetLocalizeStringBy("key_1942")
			rewardInfo.content  = v.va_reward.msg or GetLocalizeStringBy("key_1942")
		elseif(tonumber(v.source) == 13) then
			rewardInfo.content = string.gsub(sourceString, "{0}", v.va_reward.extra["score"])
		elseif(tonumber(v.source) == 16) then
			require "script/model/user/UserModel"
			local vipLevel = v.va_reward.extra["vip"] or 0
			rewardInfo.content = string.gsub(sourceString, "{0}", vipLevel)
		else
			rewardInfo.content = sourceString
		end
		print("rewardInfo.content = ", rewardInfo.content)
		--剩余过期时间
		rewardInfo.haveTime = tonumber(v.expire_time) - BTUtil:getSvrTimeInterval()
		--过期时间
		rewardInfo.expireTime = tonumber(v.expire_time)
		--物品信息
		rewardInfo.items = {}
		--金币图标
        if(v.va_reward.gold ~= nil) then
            local goldInfo = {}
            goldInfo.bgPath = "images/base/potential/props_5.png"
            goldInfo.iconPath = "images/common/gold_big.png"
            goldInfo.num  = v.va_reward.gold
            goldInfo.name = GetLocalizeStringBy("key_1491")
            table.insert(rewardInfo.items, goldInfo)
        end
		--银币图标
        if(v.va_reward.silver ~= nil) then
            silverInfo ={}
            silverInfo.bgPath = "images/base/potential/props_4.png"
            silverInfo.iconPath = "images/common/siliver_big.png"
            silverInfo.num  = v.va_reward.silver
            silverInfo.name = GetLocalizeStringBy("key_1687")
            table.insert(rewardInfo.items, silverInfo)
        end
		--将魂图标
        if(v.va_reward.soul ~= nil) then
            soulInfo ={}
            soulInfo.bgPath = "images/base/potential/props_4.png"
            soulInfo.iconPath = "images/common/soul_big.png"
            soulInfo.num  = v.va_reward.soul
            soulInfo.name = GetLocalizeStringBy("key_1616")
            table.insert(rewardInfo.items, soulInfo)
        end
        if(v.va_reward.prestige ~= nil) then
        	soulInfo ={}
            soulInfo.bgPath = "images/base/potential/props_3.png"
            soulInfo.iconPath = "images/base/props/shengwang.png"
            soulInfo.num  = v.va_reward.prestige
            soulInfo.name = GetLocalizeStringBy("key_2231")
            table.insert(rewardInfo.items, soulInfo)
        end
        if(v.va_reward.jewel ~= nil) then
        	jewelInfo ={}
            jewelInfo.bgPath = "images/base/potential/props_5.png"
            jewelInfo.iconPath = "images/base/props/dahunyu.png"
            jewelInfo.num  = v.va_reward.jewel
            jewelInfo.name = GetLocalizeStringBy("key_1510")
            table.insert(rewardInfo.items, jewelInfo)
        end
        --比武的荣誉
        if(v.va_reward.honor ~= nil) then
        	jewelInfo ={}
            jewelInfo.bgPath = "images/base/potential/props_5.png"
            jewelInfo.iconPath = "images/common/honor.png"
            jewelInfo.num  = v.va_reward.honor
            jewelInfo.name = GetLocalizeStringBy("lcy_10040")
            table.insert(rewardInfo.items, jewelInfo)
        end
        --contri 军团贡献
        if(v.va_reward.contri ~= nil) then
        	jewelInfo ={}
            jewelInfo.bgPath = "images/base/potential/props_5.png"
            jewelInfo.iconPath = "images/common/contribution.png"
            jewelInfo.num  = v.va_reward.contri
            jewelInfo.name = GetLocalizeStringBy("lcy_10041")
            table.insert(rewardInfo.items, jewelInfo)
        end
        --卡牌
        if(v.va_reward.hero ~= nil) then
	        for key,heroInfo in pairs(v.va_reward.hero) do
	    		require "db/DB_Heroes"
				local db_hero = DB_Heroes.getDataById(heroInfo.tplId)
				card ={}
	            card.bgPath = "images/hero/quality/"..db_hero.star_lv .. ".png"
	            card.iconPath = "images/base/hero/head_icon/" .. db_hero.head_icon_id
	            card.num  = heroInfo.num
	            card.name = db_hero.name
	            table.insert(rewardInfo.items, card)
	        end
        end
       	if(v.va_reward.treasfrag~= nil) then
	        	for k,v in pairs(v.va_reward.treasfrag) do
	        		print("treasure fragment id = :", v.tplId)

	        		require "db/DB_Item_treasure_fragment"
	        		local db_treaFrag = DB_Item_treasure_fragment.getDataById(v.tplId)
	        		print("db_treaFrag:")
	        		print_t(db_treaFrag)

					local itemDic = {}
					itemDic.bgPath = "images/base/potential/props_" .. db_treaFrag.quality .. ".png"
					itemDic.iconPath = "images/base/treas_frag/" .. db_treaFrag.icon_small
					itemDic.num  = v.num
	           	 	itemDic.name = db_treaFrag.name
	           	 	itemDic.tid  = v.tplId
					table.insert(rewardInfo.items, itemDic)
				end
	        end
        --物品
		for key,itemInfo in pairs(v.va_reward.item) do
			local rewardItem = {}
			--查询物品信息	
			require "script/ui/item/ItemUtil"		
			local i_data = ItemUtil.getItemById(tonumber(itemInfo.tplId))
			-- require "db/DB_Item_arm"
			-- local i_data = DB_Item_arm.getDataById(tonumber(itemInfo.tplId))
			rewardItem.num 		= itemInfo.num
			rewardItem.tid  	= itemInfo.tplId	
			rewardItem.name 	= i_data.name
			table.insert(rewardInfo.items,rewardItem)
		end
		print(GetLocalizeStringBy("key_2472"), v.rid)
		print_t(rewardInfo)
		table.insert(rewardViewArray, rewardInfo)
	end
	return rewardViewArray
end

--得到奖励条数
function getRewardCount()
	return table.count(rewardList)
end

--得到奖励内容信息（领取成功后的提示内容）
function getRewardInfo( t_rid )
	for k,v in pairs(rewardList) do
		if(tonumber(v.rid) == tonumber(t_rid)) then
			--查询物品信息
			local rContent = GetLocalizeStringBy("key_2425")
			if(v.va_reward.gold ~= nil) then
				rContent = rContent .. GetLocalizeStringBy("key_1443") .. v.va_reward.gold .. "\n"
			end
			if(v.va_reward.silver ~= nil) then
				rContent = rContent .. GetLocalizeStringBy("key_2889") .. v.va_reward.silver .. "\n"
			end
			if(v.va_reward.soul ~= nil) then
				rContent = rContent .. GetLocalizeStringBy("key_1603") .. v.va_reward.soul .. "\n"
			end
			if(v.va_reward.prestige ~= nil) then
				rContent = rContent .. GetLocalizeStringBy("key_2919") .. v.va_reward.prestige .. "\n"
			end
			if(v.va_reward.honor ~= nil) then
				rContent = rContent .. GetLocalizeStringBy("lcy_10040") .. v.va_reward.honor .. "\n"
			end
			if(v.va_reward.contri ~= nil) then
				rContent = rContent .. GetLocalizeStringBy("lcy_10041") .. v.va_reward.contri .. "\n"
			end
			for k,v in pairs(v.va_reward.item) do
				require "script/ui/item/ItemUtil"		
				local itemTableInfo = ItemUtil.getItemById(tonumber(v.tplId))
				rContent = rContent .. "" .. itemTableInfo.name .. "*" .. v.num .. "\n"
			end
			return rContent
		end
	end
end

--得到奖励列表数据
function getRewardListInfo( t_rid )

	local listDic = {}

	for k,v in pairs(rewardList) do
		
		if(tonumber(v.rid) == tonumber(t_rid)) then
			--查询物品信息
			print(GetLocalizeStringBy("key_2200"))
			print_t(v)
			if(v.va_reward.gold ~= nil) then
				local goldInfo = {}
				goldInfo.type = "gold"
				goldInfo.num  = v.va_reward.gold
				table.insert(listDic, goldInfo)
			end
			if(v.va_reward.silver ~= nil) then
				local silverleInfo = {}
				silverleInfo.type = "silver"
				silverleInfo.num  = v.va_reward.silver
				table.insert(listDic, silverleInfo)
			end
			if(v.va_reward.soul ~= nil) then
				local soulInfo = {}
				soulInfo.type = "soul"
				soulInfo.num  = v.va_reward.soul
				table.insert(listDic, soulInfo)
			end
			if(v.va_reward.prestige ~= nil) then
				local prestigeInfo = {}
				prestigeInfo.type = "prestige"
				prestigeInfo.num  = v.va_reward.prestige
				table.insert(listDic, prestigeInfo)
			end
			if(v.va_reward.jewel ~= nil) then
				local jewelInfo = {}
				jewelInfo.type = "jewel"
				jewelInfo.num   = v.va_reward.jewel
				table.insert(listDic, jewelInfo)
        	end
        	
			if(v.va_reward.hero ~= nil) then
		        for key,heroInfo in pairs(v.va_reward.hero) do
		        	local heroDic = {}
					heroDic.type = "hero"
					heroDic.tid  = heroInfo.tplId
					heroDic.num  = 	heroInfo.num
					table.insert(listDic, heroDic)
		        end
	        end
	        if(v.va_reward.item ~= nil) then
				for k,v in pairs(v.va_reward.item) do
					local itemDic = {}
					itemDic.type = "item"
					itemDic.tid = v.tplId
					itemDic.num  = v.num
					table.insert(listDic, itemDic)
					print("添加物品。。。。。。。。。。。。。。。。。。。。")
				end
	        end
	        --比武的荣誉
	        if(v.va_reward.honor ~= nil) then
				local jewelInfo = {}
				jewelInfo.type = "honor"
				jewelInfo.num   = v.va_reward.honor
				table.insert(listDic, jewelInfo)
	        end
	        --contri 军团贡献
	        if(v.va_reward.contri ~= nil) then
				local jewelInfo = {}
				jewelInfo.type = "contri"
				jewelInfo.num   = v.va_reward.contri
				table.insert(listDic, jewelInfo)
	        end
	        -- added by zhz 宝物碎片单独传
	        if(v.va_reward.treasfrag~= nil) then
	        	for k,v in pairs(v.va_reward.treasfrag) do
					local itemDic = {}
					itemDic.type = "item"
					itemDic.tid = v.tplId
					itemDic.num  = v.num
					table.insert(listDic, itemDic)
				end
	        end

			break
		end
	end
	print("getRewardListInfo:")
	print_t(listDic)
	return listDic
end


--得到单条奖励信息
function getSingleRewardInfo( t_rid )
	for k,v in pairs(rewardList) do
		if(tonumber(v.rid) == tonumber(t_rid)) then
			--查询物品信息
			return v
		end
	end
end


--判断奖励是否过期
function isTimeOut( rid )
	for k,v in pairs(rewardList) do
		if(tonumber(rid) == tonumber(v.rid)) then
			local haveTime = tonumber(v.send_time) + 15*24*3600 - BTUtil:getSvrTimeInterval()
			if(haveTime < 0) then
				return true
			else
				return false
			end
		end
	end
end

--------------------------[[修改数据]]--------------------------
--rid :奖励id
function deleteReward( rid )
	for k,v in pairs(rewardList) do
		if(tonumber(v.rid) == tonumber(rid)) then
			rewardList[k] = nil
		end
	end
end

