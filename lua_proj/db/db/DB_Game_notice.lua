-- Filename: DB_Game_notice.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Game_notice", package.seeall)

keys = {
	"id", "content", 
}

Game_notice = {
	id_16 = {16, "恭喜|将武将|进阶到了|，战力得到大幅提升！", },
	id_17 = {17, "恭喜|在酒馆中使用|招将时招到了|，吞食天地指日可待！", },
	id_18 = {18, "恭喜|在神将十连抽时招到了|，吞食天地指日可待！", },
	id_26 = {26, "离活动：进击的魔神“|”挑战赛还剩5分钟，请大家做好挑战准备！", },
	id_27 = {27, "活动：进击的魔神“|”挑战赛已开启，请大家踊跃参与！击杀魔神会获得大量声望奖励哦~！", },
	id_28 = {28, "恭喜|成功击杀|，获得魔神击杀奖励！", },
	id_29 = {29, "本次进击的魔神活动已结束。伤害最高前三名：第一名|，伤害|；第二名|，伤害|；第三名|，伤害|。", },
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
	local id_data = Game_notice["id_" .. key_id]
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
	for k, v in pairs(Game_notice) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Game_notice"] = nil
	package.loaded["DB_Game_notice"] = nil
	package.loaded["db/DB_Game_notice"] = nil
end

