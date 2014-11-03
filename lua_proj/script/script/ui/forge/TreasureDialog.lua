-- Filename: TreasureDialog.lua
-- Author: bzx
-- Date: 2014-06-13
-- Purpose: 寻龙探宝各种事件的对话框

module("TreasureDialog", package.seeall)

require "script/libs/LuaCCSprite"
require "script/ui/forge/FindTreasureUtil"
require "script/libs/LuaCCSprite"
require "script/model/utils/HeroUtil"

local _layer
local _event
local _touch_priority   = -600
local _z                = 20
local _args
local _could_move       = false
function show(event, args)
    create(event, args)
    if _layer ~= nil then
        CCDirector:sharedDirector():getRunningScene():addChild(_layer, _z)
    end
end

function previewTreasure(event, could_move, args)
    createPreview(event, could_move, args)
    if _layer ~= nil then
        CCDirector:sharedDirector():getRunningScene():addChild(_layer, _z)
    end
end

function init(event, args)
    _event = event
    _args = args
    _layer = nil
end

function createPreview(event, could_move, args)
    init(event, args)
    _could_move = could_move
    local dialog_info = {
        title = "images/forge/sjts.png"
    }
    
    local dialog = createBaseDialog(dialog_info, true)
    dialog:setScale(MainScene.elementScale)
    dialog:setAnchorPoint(ccp(0.5, 0.5))
    dialog:setPosition(ccp(g_winSize.width * 0.5, g_winSize.height * 0.5))
    _layer = CCLayerColor:create(ccc4(0, 0, 0, 100))
    _layer:addChild(dialog)
    _layer:registerScriptHandler(onNodeEvent)
    
    
    
    local icon = CCSprite:create("images/forge/treasure_icon/" .. _event.isIcon)
    dialog:addChild(icon)
    icon:setAnchorPoint(ccp(0.5, 0.5))
    icon:setPosition(ccp(260, 210))
    
    
    local name_label = CCRenderLabel:create(_event.pointTips[1], g_sFontPangWa, 23, 1, ccc3(0x00,0x00,0x00), type_shadow)
    dialog:addChild(name_label)
    name_label:setColor(ccc3(0x00, 0xff, 0x18))
    name_label:setAnchorPoint(ccp(0, 1))
    name_label:setPosition(ccp(310, 260))
    local text = _event.pointTips[2]
    local desc = CCLabelTTF:create(text, g_sFontPangWa, 21)
    dialog:addChild(desc)
    desc:setAnchorPoint(ccp(0, 1))
    desc:setPosition(ccp(310, 225))
    desc:setDimensions(CCSizeMake(280, 300))
    desc:setHorizontalAlignment(kCCTextAlignmentLeft)
    desc:setColor(ccc3(0xff, 0xf6, 0x00))
    local menu = CCMenu:create()
    dialog:addChild(menu)
    menu:setTouchPriority(_touch_priority - 1)
    menu:setPosition(ccp(0, 0))
    if could_move then
        local confirm_btn = LuaCC.create9ScaleMenuItem("images/common/btn/btn1_d.png","images/common/btn/btn1_n.png",CCSizeMake(150, 73), GetLocalizeStringBy("key_8140"),ccc3(0xfe, 0xdb, 0x1c),30,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00))
        menu:addChild(confirm_btn)
        confirm_btn:setAnchorPoint(ccp(0.5, 0.5))
        confirm_btn:setPosition(ccp(384, 68))
        local goCallback = function()
            closeCallback()
            if _args.moveCallFunc ~= nil then
                _args.moveCallFunc()
            end
        end
        confirm_btn:registerScriptTapHandler(goCallback)
    else
         local confirm_btn = LuaCC.create9ScaleMenuItem("images/common/btn/btn1_d.png","images/common/btn/btn1_n.png",CCSizeMake(150, 73), GetLocalizeStringBy("key_8141"),ccc3(0xfe, 0xdb, 0x1c),30,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00))
        menu:addChild(confirm_btn)
        confirm_btn:setAnchorPoint(ccp(0.5, 0.5))
        confirm_btn:setPosition(ccp(384, 68))
        confirm_btn:registerScriptTapHandler(closeCallback)
    end
    return _layer
end

function create(event, args)
    init(event, args)
    local dialog = nil
    if event.exploreType == 1 then
        dialog = createDoubleDialog()
    elseif event.exploreType == 2 then
        dialog = createFightDialog()
    elseif event.exploreType == 3 or event.exploreType == 5 then
        dialog = createNormalDialog()
    elseif event.exploreType == 4 then
        dialog = createAnswerDialog()
    end
    if dialog ~= nil then
        dialog:setScale(MainScene.elementScale)
        dialog:setAnchorPoint(ccp(0.5, 0.5))
        dialog:setPosition(ccp(g_winSize.width * 0.5, g_winSize.height * 0.5))
        _layer = CCLayerColor:create(ccc4(0, 0, 0, 100))
        _layer:addChild(dialog)
        _layer:registerScriptHandler(onNodeEvent)
        return _layer
    else
        executeCallFunc()
    end
    return nil
end

function onTouchesHandler(event)
    return true
end

function onNodeEvent(event)
    if (event == "enter") then
		_layer:registerScriptTouchHandler(onTouchesHandler, false, _touch_priority, true)
        _layer:setTouchEnabled(true)
	elseif (event == "exit") then
		_layer:unregisterScriptTouchHandler()
	end
end

-- 普通
function createNormalDialog()
    local dialog_info = {
        title = "images/forge/sj.png",
    }
    dialog_info.tip_node = CCRenderLabel:create(GetLocalizeStringBy("key_8142"), g_sFontPangWa, 23, 1, ccc3(0x00,0x00,0x00), type_shadow)
    dialog_info.tip_node:setColor(ccc3(0xff, 0xf6, 0x00))
    local dialog = createBaseDialog(dialog_info)
    
    local icon = CCSprite:create("images/forge/treasure_icon/" .. _event.isIcon)
    dialog:addChild(icon)
    icon:setAnchorPoint(ccp(0.5, 0.5))
    icon:setPosition(ccp(295, 210))
    local name_label = CCRenderLabel:create(_event.exploreExplain[1], g_sFontPangWa, 23, 1, ccc3(0x00,0x00,0x00), type_shadow)
    dialog:addChild(name_label)
    name_label:setColor(ccc3(0xff, 0xf6, 0x00))
    name_label:setAnchorPoint(ccp(0, 1))
    name_label:setPosition(ccp(348, 260))
    local desc = CCLabelTTF:create(_event.exploreExplain[2], g_sFontPangWa, 21)
    dialog:addChild(desc)
    desc:setAnchorPoint(ccp(0, 0.5))
    desc:setPosition(ccp(348, 170))
    desc:setDimensions(CCSizeMake(240, 110))
    desc:setHorizontalAlignment(kCCTextAlignmentLeft)
    desc:setColor(ccc3(0xff, 0xf6, 0x00))
    local point_label = CCLabelTTF:create(string.format(GetLocalizeStringBy("key_8143"), _event.integralReward[2]), g_sFontPangWa, 21)
    dialog:addChild(point_label)
    point_label:setAnchorPoint(ccp(0, 0.5))
    point_label:setPosition(ccp(275, 140))
    point_label:setColor(ccc3(0x00, 0xff, 0x18))
    local menu = CCMenu:create()
    dialog:addChild(menu)
    menu:setTouchPriority(_touch_priority - 1)
    menu:setPosition(ccp(0, 0))
    local confirm_btn = LuaCC.create9ScaleMenuItem("images/common/btn/btn1_d.png","images/common/btn/btn1_n.png",CCSizeMake(150, 73), GetLocalizeStringBy("key_8144"),ccc3(0xfe, 0xdb, 0x1c),30,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00))
    menu:addChild(confirm_btn)
    confirm_btn:setAnchorPoint(ccp(0.5, 0.5))
    confirm_btn:setPosition(ccp(375, 68))
    confirm_btn:registerScriptTapHandler(closeCallback)
    return dialog
end

-- 战斗
function createFightDialog()
     local dialog_info = {
        title = "images/forge/zd.png",
    }
    local name = nil
    local enemy_head = nil
    local move_data = FindTreasureUtil.getMoveData()
    local enemy_data = move_data.other.fb
    enemy_data.dress = enemy_data.dress or {}
    require "db/DB_Army"
    require "script/ui/arena/ArenaData"
    require "db/DB_Monsters"
    require "db/DB_Team"
    if enemy_data == nil then
        print("fuck=", move_data.other.sj)
        local army_db = DB_Army.getDataById(tonumber(move_data.other.sj))
        local team_db = DB_Team.getDataById(army_db.monster_group)
        local monsters_id = string.split(team_db.monsterID, ',')[1]
        enemy_data = DB_Monsters.getDataById(monsters_id)
        enemy_head = HeroUtil.getHeroIconByHTID(enemy_data.htid, nil, tonumber(enemy_data.utid))
        name = army_db.display_name
    elseif enemy_data.isNpc == "true"then
        enemy_head =  ArenaData.getNpcIconByhid(tonumber(enemy_data.htid[1]))
        name = ArenaData.getNpcName(enemy_data.uid, enemy_data.utid)
    else
        enemy_head = HeroUtil.getHeroIconByHTID(enemy_data.htid, enemy_data.dress["1"] , tonumber(enemy_data.utid))
        name = enemy_data.uname
    end
    local tip = {}
    tip[1] = CCRenderLabel:create(GetLocalizeStringBy("key_8145"), g_sFontPangWa, 23, 1, ccc3(0x00,0x00,0x00), type_shadow)
    tip[1]:setColor(ccc3(0xff, 0xf6, 0x00))
    tip[2] = CCRenderLabel:create(name, g_sFontPangWa, 23, 1, ccc3(0x00,0x00,0x00), type_shadow)
    tip[2]:setColor(ccc3(0x00, 0xe4, 0xff))
    tip[3] =  CCRenderLabel:create("！", g_sFontPangWa, 23, 1, ccc3(0x00,0x00,0x00), type_shadow)
    tip[3]:setColor(ccc3(0xff, 0xf6, 0x00))
    dialog_info.tip_node = BaseUI.createHorizontalNode(tip)
    local dialog = createBaseDialog(dialog_info)--LuaCCSprite.createDialog_1(dialog_info)
    local player_head = HeroUtil.getHeroIconByHTID(UserModel.getAvatarHtid(), UserModel.getDressIdByPos("1"), UserModel.getUserSex())
    dialog:addChild(player_head)
    player_head:setAnchorPoint(ccp(0.5, 0.5))
    player_head:setPosition(ccp(268, 190))
    local player_name_label = CCRenderLabel:create(UserModel.getUserName(), g_sFontPangWa, 22, 1, ccc3(0x00,0x00,0x00), type_shadow)
    player_head:addChild(player_name_label)
    player_name_label:setAnchorPoint(ccp(0.5, 1))
    player_name_label:setPosition(ccp(player_head:getContentSize().width * 0.5, 2))
    player_name_label:setColor(ccc3(0xff, 0xf6, 0x00))
    
    local vs_sprite = CCSprite:create("images/arena/vs.png")
    dialog:addChild(vs_sprite)
    vs_sprite:setAnchorPoint(ccp(0.5, 0.5))
    vs_sprite:setPosition(ccp(379, 190))



    dialog:addChild(enemy_head)
    enemy_head:setAnchorPoint(ccp(0.5, 0.5))
    enemy_head:setPosition(ccp(490, 190))
    local enemy_name_label = CCRenderLabel:create(name, g_sFontPangWa, 22, 1, ccc3(0x00,0x00,0x00), type_shadow)
    enemy_head:addChild(enemy_name_label)
    enemy_name_label:setAnchorPoint(ccp(0.5, 1))
    enemy_name_label:setPosition(ccp(enemy_head:getContentSize().width * 0.5, 2))
    enemy_name_label:setColor(ccc3(0xff, 0xf6, 0x00))

    local menu = CCMenu:create()
    dialog:addChild(menu)
    menu:setTouchPriority(_touch_priority - 1)
    menu:setPosition(ccp(0, 0))
    local fight_btn = LuaCC.create9ScaleMenuItem("images/common/btn/btn1_d.png","images/common/btn/btn1_n.png",CCSizeMake(150, 73), GetLocalizeStringBy("key_8146"),ccc3(0xfe, 0xdb, 0x1c),30,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00))
    menu:addChild(fight_btn)
    fight_btn:setAnchorPoint(ccp(0.5, 0.5))
    fight_btn:setPosition(ccp(260, 68))
    local handleFight = function(cbFlag, dictData, bRet)
        if dictData.err ~= "ok" then
            return
        end
        FindTreasureUtil.setHpPool(tonumber(dictData.ret.hppool))
        FindTreasureLayer.refreshHp()
        FindTreasureLayer.refreAddtion(0)
        FindTreasureUtil.refreshFormationHp(dictData.ret.arrhp)
        closeCallback()
        require "script/ui/forge/FightResultLayer"
        local result_layer = FightResultLayer.create(dictData.ret.atkRet.server.appraisal, FindTreasureLayer.playBgm, _event)
        require "script/battle/BattleLayer"
        BattleLayer.showBattleWithString(dictData.ret.atkRet.client, nil, result_layer,nil,nil,nil,nil,nil,true)

        
    end
    local fightCallback = function()
        require "script/audio/AudioUtil"
        AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
    
        local args = Network.argsHandler(_event.id)
        RequestCenter.dragonFight(handleFight, args)
    end
    fight_btn:registerScriptTapHandler(fightCallback)
    local bribe_btn_data = {
        normal = "images/common/btn/btn1_d.png",
        selected = "images/common/btn/btn1_n.png",
        size = CCSizeMake(260, 73),
        icon = "images/common/gold.png",
        text = GetLocalizeStringBy("key_8147"),
        number = tostring(_event.completePay)
    }
    local bribe_btn = LuaCCSprite.createNumberMenuItem(bribe_btn_data)
    menu:addChild(bribe_btn)
    bribe_btn:setAnchorPoint(ccp(0.5, 0.5))
    bribe_btn:setPosition(ccp(490, 68))
    local handleBribe = function(cbFlag, dictData, bRet)
        if dictData.err ~= "ok" then
            return
        end
          SingleTip.showTip(string.format(GetLocalizeStringBy("key_8148"), _event.integralReward[8][2]))
          UserModel.addGoldNumber(-_event.completePay)
          FindTreasureUtil.addPoint(_event.integralReward[8][2])
          FindTreasureLayer.refreshPoint()
          closeCallback()
    end
    local bribeCallback = function()
        require "script/audio/AudioUtil"
        AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
    
        if _event.completePay > UserModel.getGoldNumber() then
            SingleTip.showTip(GetLocalizeStringBy("key_8130"))
            return
        end
        local args = Network.argsHandler(_event.id)
        RequestCenter.dragonBribe(handleBribe, args)
    end
    bribe_btn:registerScriptTapHandler(bribeCallback)
    return dialog
end

-- 宝物
function createDoubleDialog()
     local dialog_info = {
        title = "images/forge/bz.png",
    }
    dialog_info.tip_node = CCRenderLabel:create(GetLocalizeStringBy("key_8149"), g_sFontPangWa, 23, 1, ccc3(0x00,0x00,0x00), type_shadow)
    dialog_info.tip_node:setColor(ccc3(0xff, 0xf6, 0x00))

    require "db/DB_Item_normal"
    local dialog = createBaseDialog(dialog_info)
    local move_data = FindTreasureUtil.getMoveData()
    local item_id = nil
    local item_count = nil
    for k, v in pairs(move_data.other.drop.item) do
       item_id = tonumber(k)
       item_count = tonumber(v)
    end
    local item_normal = DB_Item_normal.getDataById(item_id)
    local goodsValues = {}
    goodsValues.type = "item"
    goodsValues.tid = item_id
    goodsValues.num = item_count
    local icon= ItemUtil.createGoodsIcon(goodsValues, -435, 1010, -450, nil)
    dialog:addChild(icon)
    icon:setAnchorPoint(ccp(0.5, 0.5))
    icon:setPosition(ccp(288, 190))
    
    local name_label = CCRenderLabel:create(item_normal.name, g_sFontPangWa, 23, 1, ccc3(0x00,0x00,0x00), type_shadow)
    name_label:setColor(ccc3(0xff, 0xf6, 0x00))
    name_label:setAnchorPoint(ccp(0.5, 1))
    name_label:setPosition(ccp(icon:getContentSize().width * 0.5, -8))
    local desc = CCLabelTTF:create(item_normal.desc, g_sFontPangWa, 21)
    dialog:addChild(desc)
    desc:setAnchorPoint(ccp(0, 0.5))
    desc:setPosition(ccp(348, 190))
    desc:setDimensions(CCSizeMake(240, 110))
    desc:setHorizontalAlignment(kCCTextAlignmentLeft)
    local point_label = CCLabelTTF:create(string.format(GetLocalizeStringBy("key_8143"), _event.integralReward[2]), g_sFontPangWa, 21)
    dialog:addChild(point_label)
    point_label:setAnchorPoint(ccp(0, 0.5))
    point_label:setPosition(ccp(348, 155))
    point_label:setColor(ccc3(0x00, 0xff, 0x18))
    
    local menu = CCMenu:create()
    dialog:addChild(menu)
    menu:setTouchPriority(_touch_priority - 1)
    menu:setPosition(ccp(0, 0))
    local continue_btn = LuaCC.create9ScaleMenuItem("images/common/btn/btn1_d.png","images/common/btn/btn1_n.png",CCSizeMake(175, 73), GetLocalizeStringBy("key_8150"),ccc3(0xfe, 0xdb, 0x1c),30,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00))
    menu:addChild(continue_btn)
    continue_btn:setAnchorPoint(ccp(0.5, 0.5))
    continue_btn:setPosition(ccp(375, 68))
    continue_btn:registerScriptTapHandler(skipCallback)

    return dialog
end

-- 答题
function createAnswerDialog()
     local dialog_info = {
        title = "images/forge/dt.png",
    }
    dialog_info.tip_node = CCRenderLabel:create(GetLocalizeStringBy("key_8151"), g_sFontPangWa, 23, 1, ccc3(0x00,0x00,0x00), type_shadow)
    dialog_info.tip_node:setColor(ccc3(0xff, 0xf6, 0x00))
    local dialog = createBaseDialog(dialog_info)
    local icon = CCSprite:create("images/forge/treasure_icon/" .. _event.isIcon)
    dialog:addChild(icon)
    icon:setAnchorPoint(ccp(0.5, 0.5))
    icon:setPosition(ccp(288, 210))
    local answer_id = _event.exploreConditions[2]
    require "db/DB_Explore_long_answer"
    answer_db = DB_Explore_long_answer.getDataById(answer_id)
    local sure_answer = ""
    if answer_db["true"] == "2" then
        sure_answer = answer_db.answerB
    elseif answer_db["true"] == "1" then
        sure_answer = answer_db.answerA
    else
        print("DB_Explore_long_answer表有误")
    end
    local questions_desc = answer_db.questions
    require "db/DB_Vip"
    local vip_db = DB_Vip.getDataById(UserModel.getVipLevel() + 1)
    if vip_db.treasure_answer == 1 then
        questions_desc = string.format("%s[%s]", questions_desc, sure_answer)
    end
    local desc = CCLabelTTF:create(questions_desc, g_sFontPangWa, 21)
    dialog:addChild(desc)
    desc:setAnchorPoint(ccp(0, 0.5))
    desc:setPosition(ccp(348, 200))
    desc:setDimensions(CCSizeMake(240, 110))
    desc:setHorizontalAlignment(kCCTextAlignmentLeft)
    local selected_answer_index = nil
    local radio_data = {
        touch_priority  = _touch_priority - 1,
        space           = 150,
        callback        = function(tag, menu_item)
            require "script/audio/AudioUtil"
            AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
            selected_answer_index = tag
        end,
        items           ={
            {normal = "images/common/btn/radio_normal.png", selected = "images/common/btn/radio_selected.png"},
            {normal = "images/common/btn/radio_normal.png", selected = "images/common/btn/radio_selected.png"},
        }
    }
    local radio_menu = LuaCCSprite.createRadioMenu(radio_data)
    dialog:addChild(radio_menu)
    radio_menu:setAnchorPoint(ccp(0, 0))
    radio_menu:setPosition(ccp(230, 115))
    local answer_A = CCLabelTTF:create(answer_db.answerA, g_sFontPangWa, 21)
    dialog:addChild(answer_A)
    answer_A:setAnchorPoint(ccp(0, 0.5))
    answer_A:setPosition(ccp(280, 140))
    answer_A:setColor(ccc3(0x00, 0xff, 0x18))
    local answer_B = CCLabelTTF:create(answer_db.answerB, g_sFontPangWa, 21)
    dialog:addChild(answer_B)
    answer_B:setAnchorPoint(ccp(0, 0.5))
    answer_B:setPosition(ccp(475, 140))
    answer_B:setColor(ccc3(0x00, 0xff, 0x18))
    
    local menu = CCMenu:create()
    dialog:addChild(menu)
    menu:setTouchPriority(_touch_priority - 1)
    menu:setPosition(ccp(0, 0))
    local confirm_btn = LuaCC.create9ScaleMenuItem("images/common/btn/btn1_d.png","images/common/btn/btn1_n.png",CCSizeMake(175, 73), GetLocalizeStringBy("key_8152"),ccc3(0xfe, 0xdb, 0x1c),30,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00))
    menu:addChild(confirm_btn)
    confirm_btn:setAnchorPoint(ccp(0.5, 0.5))
    confirm_btn:setPosition(ccp(247, 68))
    local handleConfirm = function(cbFlag, dictData, bRet)
        if dictData.err ~= "ok" then
            return
        end
        local add_point = 0
        if dictData.ret == "true" then
            add_point = _event.integralReward[1][2]
            SingleTip.showTip(string.format(GetLocalizeStringBy("key_8153"), add_point))
        elseif dictData.ret == "false" then
            add_point = _event.integralReward[2][2]
            SingleTip.showTip(string.format(GetLocalizeStringBy("key_8154"), add_point))
        end
        FindTreasureUtil.addPoint(add_point)
        FindTreasureLayer.refreshPoint()
        closeCallback()
    end
    local confirmCallback = function()
        require "script/audio/AudioUtil"
        AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
        local args = Network.argsHandler(_event.id, selected_answer_index)
         RequestCenter.dragonAnswer(handleConfirm, args)
    end
    confirm_btn:registerScriptTapHandler(confirmCallback)
    local item_info = {
        normal = "images/common/btn/btn1_d.png",
        selected = "images/common/btn/btn1_n.png",
        size = CCSizeMake(260, 73),
        icon = "images/common/gold.png",
        text = GetLocalizeStringBy("key_8155"),
        number = tostring(_event.completePay)
    }
    if vip_db.treasure_answer ~= 1 then
        local one_key_btn = LuaCCSprite.createNumberMenuItem(item_info)
        menu:addChild(one_key_btn)
        one_key_btn:setAnchorPoint(ccp(0.5, 0.5))
        one_key_btn:setPosition(ccp(475, 68))
        local handleOneKey = function(cbFlag, dictData, bRet)
            if dictData.err ~= "ok" then
                return
            end
            SingleTip.showTip(string.format(GetLocalizeStringBy("key_8153"), _event.integralReward[1][2]))
            closeCallback()
            UserModel.addGoldNumber(-_event.completePay)
            FindTreasureUtil.addPoint(_event.integralReward[1][2])
            FindTreasureLayer.refreshPoint()

        end
        local oneKeyCallback = function()
            require "script/audio/AudioUtil"
            AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
            if UserModel.getGoldNumber() < _event.completePay then
                require "script/ui/tip/LackGoldTip"
                LackGoldTip.showTip()
                return
            end

            local args = Network.argsHandler(_event.id)
             RequestCenter.dragonOnekey(handleOneKey, args)
        end
        one_key_btn:registerScriptTapHandler(oneKeyCallback)
    else
        confirm_btn:setPosition(ccp(384, 68))
    end
    return dialog
end

function createBaseDialog(dialog_info, close)
    local dialog = CCSprite:create("images/forge/dialog_bg.png")
    local center_bar = CCScale9Sprite:create("images/recharge/vip_benefit/desButtom.png")
    dialog:addChild(center_bar)
    center_bar:setPreferredSize(CCSizeMake(420, 164))
    center_bar:setAnchorPoint(ccp(1, 0))
    center_bar:setPosition(ccp(618, 105))
    local title = CCSprite:create(dialog_info.title)
    dialog:addChild(title)
    title:setAnchorPoint(ccp(0.5, 0))
    title:setPosition(ccp(375, 313))
    if dialog_info.tip_node ~= nil then
        local tip_node= dialog_info.tip_node
        dialog:addChild(tip_node)
        tip_node:setAnchorPoint(ccp(0, 0.5))
        tip_node:setPosition(ccp(222, 300))
    end
    if close == true then
        local menu = CCMenu:create()
        dialog:addChild(menu)
        menu:setContentSize(dialog:getContentSize())
        menu:setPosition(ccp(0, 0))
        menu:setTouchPriority(_touch_priority - 1)
        
        local close_btn = CCMenuItemImage:create("images/common/btn_close_n.png", "images/common/btn_close_h.png")
        menu:addChild(close_btn)
        close_btn:setAnchorPoint(ccp(0.5, 0.5))
        close_btn:setPosition(ccp(592, 335))
        close_btn:registerScriptTapHandler(closeCallback)
    end
    return dialog
end
-- 关闭
function closeCallback()
    require "script/audio/AudioUtil"
    AudioUtil.playEffect("audio/effect/guanbi.mp3")
       
    _layer:removeFromParentAndCleanup(true)
    executeCallFunc()
end

function executeCallFunc()
    if _args ~= nil then
        if _args.closeCallFunc~= nil then
            _args.closeCallFunc(_args.close_call_func_args)
        end
    end
end

function skipCallback()
    require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
    local args = Network.argsHandler(FindTreasureUtil.getMapInfo().posid - 1)
    RequestCenter.dragonSkip(handleSkip, args)
end


function handleSkip(cbFlag, dictData, bRet)
    if dictData.err ~= "ok" then
        return
    end
    closeCallback()
end