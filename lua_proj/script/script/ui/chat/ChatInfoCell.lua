-- Filename：	ChatInfoCell.lua
-- Author：		bzx
-- Date：		2014-05-14
-- Purpose：		聊天信息Cell

module("ChatInfoCell", package.seeall)
require "script/ui/chat/ChangeHeadLayer"
require "script/model/user/UserModel"
require "script/model/utils/HeroUtil"
require "script/ui/chat/ChatUtil"
require "script/libs/LuaCCLabel"

-- 消息类型
ChatInfoCellType = {
    normal         = 1,     -- 普通
    copyReport     = 2,     -- 副本战报
    playerReport   = 3,     -- PVP战报
}

-- 消息的方向
local Direction = {
    left      = 1,
    right     = 2
}

-- 发送者的性别
local Sex = {
    boy     = 1,
    girl    = 2
}

-- 消息条的触摸优先级
local _touch_priority = - 404

--[[
    @param cell_type            消息的类型
    @param data                 数据
    @param index                索引
    @param callback_head        点击头像的回调
    @param callback_look_report 点击查看战报的回调
--]]
function create(cell_type, data, index, callback_head, callback_look_report)
    --[[ test
    local cell = CCLayerColor:create(ccc4(0, 255, 0, 100), 568, 128)
    cell:ignoreAnchorPointForPosition(false)
    --]]
    local cell = CCNode:create()
    local cell_size = CCSizeMake(568, 140)
    cell:setContentSize(cell_size)
    cell:setAnchorPoint(ccp(0.5, 1))
    local head_id = tonumber(data.headpic)
    local head = nil
    if head_id == 0 then
        local sender_gender = nil
        if data.sender_gender == "1" then --男
            sender_gender = 1
        else   -- 女 “0”
            sender_gender = 2
        end
        head = HeroUtil.getHeroIconByHTID(tonumber(data.sender_tmpl), data.figure["1"], sender_gender)
    else
        head = HeroUtil.getHeroIconByHTID(head_id)
    end
    local menu = BTSensitiveMenu:create()
	if(menu:retainCount()>1)then
		menu:autorelease()
	end
    cell:addChild(menu)
    menu:setTouchPriority(_touch_priority)
    menu:setContentSize(cell_size)
    menu:setPosition(ccp(0, 0))
    
    local head_btn = CCMenuItemSprite:create(head, head)
    menu:addChild(head_btn)
    head_btn:registerScriptTapHandler(callback_head)
    head_btn:setAnchorPoint(ccp(0.5, 0.5))
    head_btn:setPosition(cell:getContentSize().width - 55, cell:getContentSize().height - 55)
    head_btn:setTag(index)
    
    
    local sender_info = {}
    sender_info.uid = tonumber(data.sender_uid)
    local direction = nil
    if sender_info.uid == UserModel.getUserUid() then
        direction = Direction.right
    else
        direction = Direction.left
    end
    sender_info.name =  direction == Direction.right and UserModel.getUserName() or data.sender_uname
    if data.sender_gender == "1" then
        sender_info.sex = Sex.boy
    else
        sender_info.sex = Sex.girl
    end
    
    
    
    local name_node = CCSprite:create()
    head_btn:addChild(name_node)
    name_node:setAnchorPoint(ccp(0.5, 1))
    name_node:setPosition(ccp(head:getContentSize().width * 0.5, 5))
    
    local name_node_width = 0
    local name_node_height = 30
    local status = nil
    -- 军团频道
    if data.channel == "101" and data.guild_status ~= nil then
        if tonumber(data.guild_status) == 1 then
            status = GetLocalizeStringBy("key_3322")
        elseif tonumber(data.guild_status) == 2 then
            status = GetLocalizeStringBy("key_2406")
        end
    end
    -- 如果有职位，显示职位名称
    if status ~= nil then
        local status_label = CCRenderLabel:create(status, g_sFontPangWa, 18, 1, ccc3(0x00, 0x00, 0x00), type_shadow)
        name_node:addChild(status_label)
        status_label:setColor(ccc3(0x70,0xff,0x18))
        status_label:setAnchorPoint(ccp(0, 0.5))
        status_label:setPosition(ccp(0, name_node_height * 0.5))
        name_node_width = name_node_width + status_label:getContentSize().width
    end
    -- 名字
    local name_label = CCRenderLabel:create(sender_info.name, g_sFontPangWa, 18, 1, ccc3(0x00,0x00,0x00), type_shadow)
    name_node:addChild(name_label)
    name_label:setAnchorPoint(ccp(0, 0.5))
    name_label:setPosition(ccp(name_node_width, name_node_height * 0.5))
    if sender_info.sex == Sex.boy then
        name_label:setColor(ccc3(0x00, 0xe4, 0xff))
    elseif sender_info.sex == Sex.girl then
        name_label:setColor(ccc3(0xf9, 0x59, 0xff))
    end
    name_node_width = name_node_width + name_label:getContentSize().width
    name_node:setContentSize(CCSizeMake(name_node_width, name_node_height))
    
    if direction == Direction.left then
        across(head_btn, cell_size.width * 0.5)
    end
    
    -- 如果是普通消息，要改变方向
    if cell_type == ChatInfoCellType.normal then
        local distance_x = 55
        local distance_y = 20
        local box = createBox(data, direction, index)
        cell:addChild(box)
        if direction == Direction.left then
            box:setAnchorPoint(ccp(0, 1))
            box:setPosition(ccp(head_btn:getPositionX() + distance_x, head_btn:getPositionY() + distance_y))
        elseif direction == Direction.right then
            box:setAnchorPoint(ccp(1, 1))
            box:setPosition(ccp(head_btn:getPositionX() - distance_x, head_btn:getPositionY() + distance_y))
        end
    end
    
    return cell
end

-- 根据x改变方向
function across(node, x)
    local anchor_point = node:getAnchorPoint()
    node:setAnchorPoint(ccp(1 - anchor_point.x, anchor_point.y))
    node:setPositionX(x * 2 - node:getPositionX())
end

function createBox(chat_info, direction, index)

    local is_vip = tonumber(chat_info.sender_vip) > 0
    local text = chat_info.message_text
    local bg_infos = {
        {
            file_name = "images/chat/box_boy.png",      -- 背景
            full_rect = CCRectMake(0, 0, 49, 62),
            insert_rect = CCRectMake(17, 47, 4, 1),
            text_color = ccc3(0x00, 0x00, 0x00),        -- 文字颜色
            bg_width_min = 50,                          -- 背景最小宽度
            single_line_height = 62,                    -- 只有一行时的高度
            lable_width_max = 390                       -- 文字最大宽度
        },
        {
            file_name = "images/chat/box_girl.png",
            full_rect = CCRectMake(0, 0, 49, 62),
            insert_rect = CCRectMake(17, 47, 4, 1),
            text_color = ccc3(0x00, 0x00, 0x00),
            bg_width_min = 50,
            single_line_height = 62,
            lable_width_max = 390
        },
        {
            file_name = "images/chat/vip_box_boy.png",
            full_rect  = CCRectMake(0, 0, 50, 70),
            insert_rect = CCRectMake(18, 51, 2, 1),
            text_color = ccc3(0xff, 0xff, 0xff),
            bg_width_min = 110,
            single_line_height = 70,
            lable_width_max = 390
        },
        {
            file_name = "images/chat/vip_box_girl.png",
            full_rect  = CCRectMake(0, 0, 50, 70),
            insert_rect = CCRectMake(18, 51, 2, 1),
            text_color = ccc3(0xff, 0xff, 0xff),
            bg_width_min = 110,
            single_line_height = 70,
            lable_width_max = 390
        }
    }
    local bg_index = nil
    if is_vip then
        if chat_info.sender_gender  == "1" then -- 男
            bg_index = 3
        else -- 女
            bg_index = 4
        end
    elseif chat_info.sender_uid == tostring(UserModel.getUserUid()) then
        bg_index = 1
    else
        bg_index = 2
    end
    local bg_info = bg_infos[bg_index]
    
    
    
    --[[ test
    local box = CCLayerColor:create(ccc4(255, 0, 0, 100), 466, 128)
    box:ignoreAnchorPointForPosition(false)
    --]]
    local box = CCNode:create()
    
    local bg = CCScale9Sprite:create(bg_info.file_name, bg_info.full_rect, bg_info.insert_rect)
    box:addChild(bg)
    bg:setAnchorPoint(ccp(0.5, 1))
    
    local direction_about = {} -- 可能会改变方向的节点的集合
    local is_battle_report = ChatUtil.isTable(text)
    local box_size = nil
    
    -- 如果是战报
    if is_battle_report then
        box_size = CCSizeMake(bg_info.lable_width_max + 50, 85)
        box:setContentSize(box_size)
        bg:setPreferredSize(box_size)
        bg:setPosition(ccp(box_size.width * 0.5, box_size.height))
        
        local battle_report_info = ChatUtil.getTable(text)
        local player_str = "【".. battle_report_info[1] .. " VS " .. battle_report_info[2] .."】"
        local player_label = CCLabelTTF:create(player_str, g_sFontName, 21)
        box:addChild(player_label)
        player_label:setAnchorPoint(ccp(0, 0))
        player_label:setColor(bg_info.text_color)
        player_label:setPosition(ccp(25, bg:getPositionY() - bg:getContentSize().height * 0.5))
        
        local menu = BTSensitiveMenu:create()
        if(menu:retainCount()>1)then
            menu:autorelease()
        end
        box:addChild(menu)
        menu:setTouchPriority(_touch_priority)
        menu:setContentSize(box_size)
        menu:setPosition(ccp(0, 0))
        
        local node_normal = CCNode:create()
        node_normal:setContentSize(box_size)
        local look_report = CCMenuItemSprite:create(node_normal, nil)
        menu:addChild(look_report)
        look_report:setAnchorPoint(ccp(0, 0))
        look_report:setPosition(ccp(0, 0))
        look_report:registerScriptTapHandler(callbackLookReport)
        look_report:setTag(index)
        --look_report:setTag(tonumber(battle_report_info[3]))
                
        local look_report_lable = CCLabelTTF:create(GetLocalizeStringBy("key_8026"), g_sFontName, 21)
        box:addChild(look_report_lable)
        look_report_lable:setColor(bg_info.text_color)
        look_report_lable:setAnchorPoint(ccp(0.5, 0.5))
        look_report_lable:setPosition(ccp(box_size.width - 105, 30))
    else
    
        local lable = CCLabelTTF:create(text, g_sFontName, 21)
        lable:setAnchorPoint(ccp(1, 0.5))
        lable:setColor(bg_info.text_color)
        direction_about[#direction_about + 1] = lable
        local bg_height = nil
        if lable:getContentSize().width > bg_info.lable_width_max then
            -- 文字单行过长要换行, 22.5为单行lable的高度
            local lable_height = math.ceil(lable:getContentSize().width / bg_info.lable_width_max) * 22.5
            lable:setDimensions(CCSizeMake(bg_info.lable_width_max, lable_height))
            lable:setHorizontalAlignment(kCCTextAlignmentLeft)
            bg_height = lable:getContentSize().height + 40 -- 加上上下边距之和40
        else
            bg_height = bg_info.single_line_height
        end
        local bg_width = lable:getContentSize().width + 50  -- 加上左右边距之和50
        if bg_width < bg_info.bg_width_min then
            bg_width = bg_info.bg_width_min
        end

        box_size = CCSizeMake(bg_width, bg_height)
        box:setContentSize(box_size)

        bg:setPreferredSize(box_size)
        bg:setPosition(ccp(box_size.width * 0.5, box_size.height))

        box:addChild(lable)
        lable:setPosition(ccp(bg:getContentSize().width - 35, bg:getContentSize().height * 0.5))
    end
    
    local vip = nil
    local star_right = nil
    
    if is_vip then
        vip = CCSprite:create("images/chat/vip.png")
        box:addChild(vip)
        vip:setAnchorPoint(ccp(0.5, 0))
        vip:setPosition(bg:getContentSize().width - 34, bg:getPositionY() - 10)
        
        local star_left = CCSprite:create("images/chat/star_2.png")
        bg:addChild(star_left)
        star_left:setPosition(ccp(-10, -5))
        
        star_right = CCSprite:create("images/chat/star_1.png")
        bg:addChild(star_right)
        star_right:setAnchorPoint(ccp(1, 0))
        star_right:setPosition(bg:getContentSize().width - 10, -5)
    end

    if direction == Direction.left then
        bg:setScaleX(-1)
        if is_vip then
            across(vip, box_size.width * 0.5)
        end
        for i = 1, #direction_about do
            local node = direction_about[i]
            across(node, box_size.width * 0.5)
        end
    end
    
    return box
end

function callbackLookReport(tag, menu_item)
    -- 音效
	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
    
    require "script/ui/guild/city/VisitorBattleLayer"
    
    local chat_info_index = tag
    require "script/ui/chat/ChatWorldLayer"
    local world_infoes = ChatWorldLayer.getChatInfoes()
    local chat_info = world_infoes[ chat_info_index]
    local battle_report_info = ChatUtil.getTable(chat_info.message_text)
    local handleGetRecord = nil
    local battle_report_type = tonumber(battle_report_info[4])
    if battle_report_type == ChatCache.ChatInfoType.battle_report_player then
        handleGetRecord = function( fightRet )
            -- 调用战斗接口 参数:atk 
            require "script/battle/BattleLayer"
            -- 调用结算面板
            require "script/battle/ChatBattleReportLayer"
            -- require "script/model/user/UserModel"
            -- local uid = UserModel.getUserUid()
            -- 解析战斗串获得战斗评价
            local amf3_obj = Base64.decodeWithZip(fightRet)
            local lua_obj = amf3.decode(amf3_obj)
            print(GetLocalizeStringBy("key_1606"))
            print_t(lua_obj)
            local appraisal = lua_obj.appraisal
            -- 敌人uid
            local uid1 = lua_obj.team1.uid
            local uid2 = lua_obj.team2.uid
            local enemyUid = 0
            if(tonumber(uid1) ==  UserModel.getUserUid() )then
                enemyUid = tonumber(uid2)
            end
            if(tonumber(uid2) ==  UserModel.getUserUid() )then
                enemyUid = tonumber(uid1)
            end
            local reportData = {}
            reportData.server = lua_obj
            local closeCallback = function()
                require "script/battle/GuildBattle"
                BattleLayer.closeLayer()
            end
            local afterBattleLayer =  VisitorBattleLayer.createAfterBattleLayer(reportData, false, closeCallback)
            BattleLayer.showBattleWithString(fightRet, nextCallFun, afterBattleLayer,nil,nil,nil,nil,nil,true)
        end
	elseif battle_report_type == ChatCache.ChatInfoType.battle_report_union then
        handleGetRecord = function(fight_fet)
            local base64Data = Base64.decodeWithZip(fight_fet)
            local data = amf3.decode(base64Data)
            print_t(data)
            require "script/ui/guild/copy/GuildBattleReportLayer"
            require "script/battle/GuildBattle"
            local reportData = {}
            reportData.server = data
            local closeCallback = function()
                require "script/battle/GuildBattle"
                GuildBattle.closeLayer()
            end
            local visitor_battle_layer = VisitorBattleLayer.createAfterBattleLayer(reportData, false, closeCallback)
            GuildBattle.createLayer(reportData, GuildBattle.BattleForGuild, visitor_battle_layer, true)
        end
    elseif battle_report_type == ChatCache.ChatInfoType.battle_report_city then
        handleGetRecord = function(fight_ret)
            local base64Data = Base64.decodeWithZip(fight_ret)
            local data = amf3.decode(base64Data)
            print_t(data)
            require "script/ui/guild/copy/GuildBattleReportLayer"
            require "script/battle/GuildBattle"
            local reportData = {}
            reportData.server = data
            local closeCallback = function()
                require "script/battle/GuildBattle"
                GuildBattle.closeLayer()
            end
            local visitor_battle_layer = VisitorBattleLayer.createAfterBattleLayer(reportData, false, closeCallback)
            GuildBattle.createLayer(reportData, GuildBattle.BattleForCity, visitor_battle_layer, true)
        end
    else
        print("战报类型有误")
    end
    require "script/ui/mail/MailService"
	MailService.getRecord(tonumber(battle_report_info[3]), handleGetRecord)
end

function lookReportEnd()
    --[[
    AudioUtil.playEffect("audio/effect/guanbi.mp3")
	require "script/ui/main/MainBaseLayer"
	local main_base_layer = MainBaseLayer.create()
	MainScene.changeLayer(main_base_layer, "main_base_layer", MainBaseLayer.exit)
    MainScene.setMainSceneViewsVisible(true,true,true)
    ChatMainLayer.showChatLayer()
    --]]
end

