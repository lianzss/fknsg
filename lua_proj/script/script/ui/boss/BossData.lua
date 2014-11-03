
-- Filename：	BossData.lua
-- Author：		Li Pan
-- Date：		2013-12-26
-- Purpose：		世界boss

require "RequestCenter"

module("BossData", package.seeall)

--基本信息
local bossInfo = nil
--特殊武将
local superHeroInfo = nil
--排行
local rankList = nil

--鼓舞消息	
local inspireInfo = nil

--攻击数据
local attackData = nil

--复活的数据
local rebirthData = nil 

-- 奖励
local prizeData = nil

-- 离开
local leaveBossData = nil

local _bossTimeOffset = 0 -- 世界boss开启时间的偏移 addBy chengliang

-- 排名消息
local rankInfo = nil 
--击杀boss的名字
local killName = nil

-- 获取世界boss开启时间的偏移 addBy chengliang
function getBossTimeOffset()
	return _bossTimeOffset
end

-- 设置世界boss开启时间的偏移  addBy chengliang
function setBossTimeOffset( bossTimeOffset )
	_bossTimeOffset = tonumber(bossTimeOffset)
end

