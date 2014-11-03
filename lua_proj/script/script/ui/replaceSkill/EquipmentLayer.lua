-- Filename: EquipmentLayer.lua
-- Author: DJN
-- Date: 2014-08-08
-- Purpose: 武将更换装备技能展示

module ("EquipmentLayer", package.seeall)
require "script/ui/main/MainScene"
--require "script/ui/hero/HeroLayerCell"
require "script/model/hero/HeroModel"
require "script/ui/replaceSkill/EquipmentTableView"
require "script/audio/AudioUtil"
local _ksTagEquipment = 1001
local _cs9TitleBar
local _touchPriority    --触摸优先级
local _ZOrder           --Z轴
local _bgLayer
local _tableView
local _jumpTag          --从哪个界面跳过来（返回按钮跳回哪个界面）

local function init()
    _touchPriority = nil
    _ZOrder = nil
    _bgLayer = nil
    _tableView = nil
end
----------------------------------------触摸事件函数----------------------------------------

local function onNodeEvent(event)
    if event == "enter" then
        _bgLayer:setTouchEnabled(true)
    elseif event == "exit" then
        _bgLayer:unregisterScriptTouchHandler()
    end
end

--[[
    @des: 创建背景
--]]
function createLayer()
    _bgLayer = CCLayer:create()
    _bgLayer:registerScriptHandler(onNodeEvent)
    require "script/ui/main/BulletinLayer"
    require "script/ui/main/MainScene"
    require "script/ui/main/MenuLayer"

    local bulletinLayerSize = BulletinLayer.getLayerContentSize()
    local avatarLayerSize = MainScene.getAvatarLayerContentSize()
    local menuLayerSize = MenuLayer.getLayerContentSize()
    local layerSize = {}
    -- 层高等于设备总高减去“公告层”，“avatar层”，GetLocalizeStringBy("key_2785")高
    layerSize.height =  g_winSize.height - (bulletinLayerSize.height+avatarLayerSize.height+menuLayerSize.height)*g_fScaleX
    layerSize.width = g_winSize.width

    _bgLayer:setContentSize(CCSizeMake(layerSize.width, layerSize.height))
    _bgLayer:setPosition(ccp(0, menuLayerSize.height*g_fScaleX))
    --_bgLayer:setScale(g_fScaleX)

    local ccSpriteBg = CCSprite:create("images/main/module_bg.png")
    ccSpriteBg:setScale(g_fBgScaleRatio)
    ccSpriteBg:setAnchorPoint(ccp(0.5, 0.5))
    ccSpriteBg:setPosition(ccp(layerSize.width/2, layerSize.height/2))
    _bgLayer:addChild(ccSpriteBg)
    
    --设置显示公告层和avatar层，底部menu
    MainScene.getAvatarLayerObj():setVisible(true)
    MenuLayer.getObject():setVisible(true)
    BulletinLayer.getLayer():setVisible(true)
   

    --创建“技能装备”的tab
    local tArgs = {}
    tArgs[1] = {text=GetLocalizeStringBy("djn_21"), x=10, tag=_ksTagEquipment, handler=fnHandlerOfTitleButtons}
    require "script/libs/LuaCCSprite"
    local cs9TitleBar = LuaCCSprite.createTitleBar(tArgs)
    _cs9TitleBar = cs9TitleBar
    cs9TitleBar:setAnchorPoint(ccp(0, 1))
    --+19*g_fScaleX
    cs9TitleBar:setPosition(0, layerSize.height+19*g_fScaleX)
    cs9TitleBar:setScale(g_fScaleX)
    _bgLayer:addChild(cs9TitleBar)
    
    local menu = tolua.cast(_cs9TitleBar:getChildByTag(10001), "CCMenu")
    _cmiEquipment=tolua.cast(menu:getChildByTag(_ksTagEquipment), "CCMenuItem")
    _cmiEquipment:selected()
    tArgs[1].handler()

    --背景按钮层
    local bgMenu = CCMenu:create()
    bgMenu:setPosition(ccp(0,0))
    bgMenu:setTouchPriority(_touchPriority-1)
    cs9TitleBar:addChild(bgMenu)
    
    --关闭按钮
    local closeButton = CCMenuItemImage:create("images/common/close_btn_n.png","images/common/close_btn_h.png")
    closeButton:setAnchorPoint(ccp(0.5, 0.5))
    closeButton:registerScriptTapHandler(closeButtonCallFunc)
    closeButton:setPosition(ccp(587 ,50))
    bgMenu:addChild(closeButton)
   -- closeButton:setScale(g_fScaleX)

    return _bgLayer
end

--[[
    @des: 入口函数,第一个参数jumptag必须穿，决定了返回按钮返回到哪个界面  jumptag：1：从武将中进来  2：从修行中进来  3：从阵容中进来
--]]
function showLayer(jumptag,tParam,p_touchPriority,p_ZOrder)
    init()
    _jumpTag = jumptag
    _touchPriority = p_touchPriority or -550
    _ZOrder = p_ZOrder or 999999
    MainScene.changeLayer(EquipmentLayer.createLayer(), "EquipmentLayer")  
end

--[[
    @des: 关闭按钮回调事件
    、
--]]
function closeButtonCallFunc( ... )
    --音效
    AudioUtil.playEffect("audio/effect/guanbi.mp3")
    jumpPage()

end
--[[
    @des: 页面跳转
    _jumpTag:1：从时装中进来  2：从名将-修行中进来  3：从阵容中进来 4.从武将中进来 （决定了跳回哪个界面）
--]]
function jumpPage( ... )
    _bgLayer:removeFromParentAndCleanup(true)
    _bgLayer = nil
    if(_jumpTag == 1)then
        --回到时装
        MainScene.getAvatarLayerObj():setVisible(false)
        require "script/ui/fashion/FashionLayer"
        local fashionLayer = FashionLayer:createFashion()
        MainScene.changeLayer(fashionLayer, "FashionLayer")
    elseif (_jumpTag == 2)then
        --回到修行
        local curSkill = EquipmentTableView.getCurSkill()
        if(curSkill ~= nil)then
            require "script/ui/replaceSkill/ReplaceSkillData"
            ReplaceSkillData.setCurMasterInfo(curSkill)
        end
        require "script/ui/replaceSkill/ReplaceSkillLayer"
        ReplaceSkillLayer.showLayer()
    elseif (_jumpTag == 3)then
        --回到阵容
        require("script/ui/formation/FormationLayer")
        local formationLayer = FormationLayer.createLayer()
        MainScene.changeLayer(formationLayer, "formationLayer")
    elseif (_jumpTag == 4)then
        require "script/ui/hero/HeroLayer"
        MainScene.changeLayer(HeroLayer.createLayer(), "HeroLayer")
    end
end

--[[
    @des: tab回调事件
--]]
function fnHandlerOfTitleButtons(tag) 
    -- 音效
    AudioUtil.playEffect("audio/effect/zhujiemian.mp3")

    _cmiEquipment:selected()
    _tableView = EquipmentTableView.createTableView(_bgLayer:getContentSize().width,_bgLayer:getContentSize().height-85*g_fScaleX)
    _tableView:setAnchorPoint(ccp(0.5,0))
    _tableView:ignoreAnchorPointForPosition(false)

    _tableView:setPosition(ccp(_bgLayer:getContentSize().width/2,5*g_fScaleX))
    --table:setPosition(ccp(_bgLayer:getContentSize().width/2,_bgLayer:getContentSize().height/2))
    _bgLayer:addChild(_tableView,_ZOrder+100)
end
--[[
    @des: 返回table 供reload函数使用
--]]
function getTableView(...)
    return _tableView
end
--[[
    @des: 返回touchpriority
--]]
function getTouchPriority(...)
    return _touchPriority
end
