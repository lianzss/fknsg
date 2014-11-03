-- Filename：	ActivityConfig.lua
-- Author：		lichenyang
-- Date：		2011-1-8
-- Purpose：		活动配置

module("ActivityConfig" , package.seeall)
require "db/DB_Xiaofei_leiji_kaifu"
require "db/DB_Ernie_kaifu"

--[[
	@des:取数据（eg:消费累积）
	--读取消费累积的第一行
	ActivityConfig.ConfigCache.spend.data[1].des
	ActivityConfig.ConfigCache.spend.start_time			--开启时间
	ActivityConfig.ConfigCache.spend.end_time			--关闭时间
	ActivityConfig.ConfigCache.spend.need_open_time`		--需要开启时间
--]]
ConfigCache 	= 	{}



keyConfig 		= 	{}
--消费累积
keyConfig.spend 			= {
	"id","des","expenseGold","reward",
}

--竞技场双倍奖励
keyConfig.arenaDoubleReward = {
	
}

--活动卡包
keyConfig.heroShop 			= {
	"id","icon","des","freeScore","goldScore","goldCost","freeCd","rewardId","freeTimeNum","tmp0","tavernId","showHeros","coseTime","first_reward_text","second_reward_text","third_reward_text","fourth_reward_text",
}

--活动卡包奖励
keyConfig.heroShopReward 	= {
	"id","tep0","scoreReward1","tmp1","scoreReward2","tmp2","scoreReward3","tmp3","scoreReward4","tmp4","scoreReward5","num","tmp5","rankingReward1","tmp6","tmp7","rankingReward2","tmp8","tmp9","rankingReward3","tmp10","tmp11","rankingReward4","tmp12","tmp13","rankingReward5","tmp14",
}

--挖宝活动配置
keyConfig.robTomb			= {
	"id","icon","des","showItems1","showItems2","showItems3","showItems4","showItems5","GoldCost","levelLimit","freeDropId","goldDropId","changeTimes","changeDropId","onceDrop",

}

-- 春节礼包活动配置
keyConfig.signActivity      = {
	"id", "des", "icon", "accumulateDay", "reward"
}

-- 充值回馈
keyConfig.topupFund			= {
	"id","des","expenseGold","reward"
}

-- 福利活动
keyConfig.weal				= {
	"id","openTime","endId","severTime","name","picPath","desc","expl","open_act","ac_double_num","nc_act","nc_soul","sc_drop","friend_stamina","guild_donate_act","guild_shop","hero_gift","g_box_drop","card_cost","score_lim","open_draw"
}

-- 兑换活动
keyConfig.actExchange 		= {
	"id", "name", "exchangeMaterialQuantity", "exchangeMaterial1", "exchangeMaterial2", "exchangeMaterial3", "exchangeMaterial4", "exchangeMaterial5", "targetItems", "changeTime", "refreshTime", "conversionFormula", "rewardNormal", "gold", "level", "goldTop", "itemView", "viewName", "isRefresh","tavernId","mysticalGoodsId","copymysticalGoodsId","soulDropId","act_icon1","act_icon2","title_bg","title","list_bg","act_bg","act_des",
}

-- 团购活动
keyConfig.groupon  			= {
	"id", "price", "vip", "oriprice", "icon", "name", "quality", "reward", "numtop", "num1", "reward1", "num2", "reward2", "num3", "reward3", "num4", "reward4", "num5", "reward5", "num6", "reward6", "num7", "reward7", "num8", "reward8", "num9", "reward9", "num10", "reward10", "num11", "reward11", "num12", "reward12", "num13", "reward13", "num14", "reward14", "num15", "reward15", "num16", "reward16", "num17", "reward17", "num18", "reward18", "num19", "reward19", "num20", "reward20", "goodsId", "changeTime", 
}

--抽奖活动
keyConfig.chargeRaffle  	= {
	"id", "limitDayNum", "activityExplain", "costNum", "firstReward", "dropId_1", "changeDropId_1", "dropShow_1", "dropId_2", "changeDropId_2", "dropShow_2", "dropId_3", "changeDropId_3", "dropShow_3", 
}

--充值大放送活动
--added by Zhang Zihang
keyConfig.topupReward		= {
	"id", "openId", "payNum", "payReward", "activityExplain",
}

--跨服赛活动配置
keyConfig.lordwar			= {
	"id", "level", "loseTime", "lastTimeArr", "applyTime", "championLastTime", "num", "massElectionGapTime", "kuafu_SroundGapTime", "cd", "refreshFightCdCost", "inScoreRewardId", "outScoreRewardId", "cheerCost", "cheerReward", "allServeGift", "wishReward", "wishCost", "rewardPreviewIn", "rewardPreviewOut", 
}

--计步活动
--id 	步数对应时长 		奖励步长 		奖励内容
keyConfig.stepCounter 		= {
	"id", "timeperstep", "steps", "rewards",
}


-------------------------------------[[ 开服活动配置 ]]---------------------------------------------------------

function getNewServerData( key )
	local data = nil
	if(key == "spend") then
		data = DB_Xiaofei_leiji_kaifu.Xiaofei_leiji_kaifu
	elseif(key == "robTomb") then
		data = DB_Ernie_kaifu.Ernie_kaifu
	end
	return data
end

