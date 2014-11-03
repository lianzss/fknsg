-- Filename: DB_Help_tips.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Help_tips", package.seeall)

keys = {
	"id", "tips", 
}

Help_tips = {
	id_1 = {1, "每天可获得一次免费重置迷宫的机会；|迷宫共有四层，移动到下一层处即可进入下一层，达到第四层终点就完成本轮探宝；|点击可见格子，会弹出事件提示。如果该位置可移动，点击移动即可移动到该位置，移动消耗1点行动力，行动力为0时不能再进行移动；|迷宫中会固定出现4个增加行动力、4个恢复血槽生命的特殊事件，获得后会对整轮探宝起到很大的帮助作用；|在探险的路上会遇到各类随机事件，每触发一个事件可获得一定探宝积分，探宝积分可以在兑换界面兑换铸造材料；|首次进入或重置探宝后，会根据主公阵型确定当前探宝阵型，阵型一旦确定，在本轮探宝中就不可更改；|探宝中会遭遇其他玩家发生战斗，战斗结束后血槽会自动为主公恢复损失的生命，如果血槽血量和生命值全为0，主公就不能再继续探宝了；|初始血槽为探宝阵型所有武将血量之和的三倍；", },
	id_2 = {2, "自动探宝每天有免费的行动力，免费行动力可以在自动探宝中抵消所需消耗的行动力，VIP等级越高每天免费行动力越多；|每天的免费行动力在每天凌晨0点刷新；|在任意层数的迷宫起点可以选择自动探宝，自动探宝时可选择探索当前迷宫中的宝箱事件；|探宝结束后根据自动探宝时选择的探宝层数及宝箱事件奖励相应的积分和升级紫装材料。", },
	id_3 = {3, "在系统规定的时间内，军团长和副军团长可以挑选城池进行报名，最多可报名两个城池且报名后不可取消。|报名时间结束后将根据报名的军团中成员周贡献前3的军团作为报名成功军团来参与攻打城池，若该城池已有军团占领则只有前2的军团可参与夺城。|攻打城池阶段由报名成功的3个军团依次对战，如报名成功了a、b、c三个军团，则第一场a先同守城军团作战，第二场由第一场的胜方同b作战，第三场由第二场的胜方同c作战，最后胜利的军团将成功夺得城池。|军团作战需要军团成员上线进入对应城池的准备场景，在准备场景中可以鼓舞增加自己的战力，也可以增加自己的连胜次数。准备时间过后将自动开战，战斗过程类似军团组队战，进入准备场景的玩家将依次上场进行作战，剩余人数不为0的军团将取得胜利。|最后占领城池的军团将会获得这个城池的特殊奖励，不同成员职位获得的奖励也不同。另外，在占领期间内，不同城池还分别有攻打副本、攻打试练塔等获得收益的特殊加成。|发奖后，城池城防将自动降低，城防对应的是守城军团在城池争夺战中的战斗力，若一个军团连续占领某个城池，则城防每次发奖后都会降低一定数值，直到更换占领军团，城防才会恢复。", },
}

local mt = {}
mt.__index = function (table, key)
	for i = 1, #keys do
		if (keys[i] == key) then
			return table[i]
		end
	end
end

function getDataById(key_id)
	local id_data = Help_tips["id_" .. key_id]
	if id_data == nil then
		print("don't find data by id " .. key_id)
		return nil
	end
	if getmetatable(id_data) ~= nil then
		return id_data
	end
	setmetatable(id_data, mt)

	return id_data
end

function getArrDataByField(fieldName, fieldValue)
	local arrData = {}
	local fieldNo = 1
	for i=1, #keys do
		if keys[i] == fieldName then
			fieldNo = i
			break
		end
	end
	for k, v in pairs(Help_tips) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Help_tips"] = nil
	package.loaded["DB_Help_tips"] = nil
	package.loaded["db/DB_Help_tips"] = nil
end

