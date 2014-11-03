-- Filename：	DigCowryData.lua
-- Author：		Li Pan
-- Date：		2014-1-8
-- Purpose：		挖宝

module("DigCowryData", package.seeall)

--基本信息
local digInfo = nil

-- 挖宝得出的信息
local DigCowryInfo = nil

function isDigcowryOpen( )
	if(ActivityConfigUtil.isActivityOpen("robTomb")) then
		if( not table.isEmpty(ActivityConfigUtil.getDataByKey("robTomb").data) ) then
			return true
		end
		return false
	end
end
