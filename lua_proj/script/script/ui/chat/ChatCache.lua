-- Filename: ChatCache.lua
-- Author: bzx
-- Date: 2014-05-19
-- Purpose: 聊天缓存

module("ChatCache", package.seeall)

local _shield_players = {}
local _key_shield_players = "key_shield_players"

-- 聊天消息类型
ChatInfoType = {
    normal                  = 1,    -- 普通
    battle_report_player    = 2,    -- 玩家战报
    battle_report_union     = 3,    -- 军团战报
    battle_report_city      = 4     -- 城池战报
}

-- 频道类型
ChannelType = {
    world   = 1,    -- 世界
    union   = 2,    -- 军团
    pm      = 3,    -- 私聊
}

function handleGetBlackUids(cbFlag, dictData, bRet)
    if dictData.err ~= "ok" then
        return
    end
    _shield_players = {}
    for i = 1, #dictData.ret do
        local uid = dictData.ret[i]
        _shield_players[uid] = uid
    end
end

-- 是否被屏蔽
function isShieldedPlayer(uid)
    if _shield_players[uid] ~= nil then
        return true
    end
    return false
end

-- 屏蔽
function addShieldedPlayer(uid)
    _shield_players[tostring(uid)] = uid
end

-- 删除屏蔽
function deleteShieldedPlayer(uid)
    _shield_players[tostring(uid)] = nil
end
