
-- Filename: BattleUtil.lua
-- Author: k
-- Date: 2013-05-27
-- Purpose: 战斗场景

module("BattleUtil", package.seeall)

function playerBattleReportById( p_reportId, sender ,callFunc)

   local reportId = p_reportId or tolua.cast(sender:getUserObject(), "CCInteger"):getValue()
	if(reportId == nil) then
      print("p_reportId", p_reportId)
      print("userobject", tolua.cast(sender:getUserObject(), "CCInteger"):getValue())
      error("error in function playerBattleReportById p_reportId = nil")
		return
	end

	local requestCallback =  function( fightRet )
		-- 调用战斗接口 参数:atk 
		require "script/battle/BattleLayer"
		-- 调用结算面板
		local amf3_obj = Base64.decodeWithZip(fightRet)
		local lua_obj = amf3.decode(amf3_obj)
		require "script/ui/guild/city/VisitorBattleLayer"
      local fightDate = {}
      fightDate.server = lua_obj
      local visitor_battle_layer = VisitorBattleLayer.createAfterBattleLayer(fightDate,nil,callFunc)
	   BattleLayer.showBattleWithString(fightRet, nil, visitor_battle_layer,nil,nil,nil,nil,nil,true)
	end
    require "script/ui/mail/MailService"
	MailService.getRecord(reportId, requestCallback)
end
