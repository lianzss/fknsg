-- Filename：	TreasCardSprite.lua
-- Author：		Cheng Liang
-- Date：		2013-11-5
-- Purpose：		宝物信息的展示

module("TreasCardSprite", package.seeall)


require "script/ui/item/ItemUtil"

local scoreSprite   = nil 
local _item_id      = nil
local _item_tmpl_id = nil
local _cardSprite   = nil

local function init()
    scoreSprite   = nil 
    _item_id      = nil
    _item_tmpl_id = nil
    _cardSprite   = nil
end

-- 
local function create(item_tmpl_id, totalScore)
	

	local localData = ItemUtil.getItemById(item_tmpl_id)
    totalScore = totalScore or localData.base_score

	-- 卡牌背景	
	local _cardSprite = CCSprite:create("images/item/equipinfo/card/equip_" .. localData.quality .. ".png")

    -- icon
    local iconSprite = CCSprite:create("images/base/treas/big/" .. localData.icon_big)
    iconSprite:setAnchorPoint(ccp(0.5, 0.5))
    iconSprite:setPosition(ccp(_cardSprite:getContentSize().width/2, _cardSprite:getContentSize().height*0.55))
    _cardSprite:addChild(iconSprite)

    -- 星级
    for i=1, localData.quality do
    	local starSp = CCSprite:create("images/formation/star.png")
    	starSp:setAnchorPoint(ccp(0.5, 0.5))
    	starSp:setPosition(ccp( _cardSprite:getContentSize().width * 0.9 - _cardSprite:getContentSize().width* 27.0/300 * (i-1), _cardSprite:getContentSize().height * 410/440))
    	_cardSprite:addChild(starSp)
    end
    require "script/libs/LuaCC"
    scoreSprite = LuaCC.createSpriteOfNumbers("images/item/equipnum", totalScore, 17)
    if (scoreSprite ~= nil) then
        scoreSprite:setAnchorPoint(ccp(0, 0))
        scoreSprite:setPosition(_cardSprite:getContentSize().width*110.0/301, _cardSprite:getContentSize().height*0.05)
        _cardSprite:addChild(scoreSprite)
    end

    -- 平台相关装备名字显示兼容
    local plName = Platform.getPlatformFlag()
    if(Platform.getPlatformFlag() == "ios_thailand" or Platform.getPlatformFlag() == "Android_taiguo" ) then
        local nameLabel = CCRenderLabel:create(localData.name, g_sFontName, 24, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
        nameLabel:setAnchorPoint(ccp(0.5,0.5))
        nameLabel:setColor(ccc3(0xff, 0xff, 0xff))
        nameLabel:setPosition(ccp( _cardSprite:getContentSize().width*0.5, _cardSprite:getContentSize().height*0.18))
        _cardSprite:addChild(nameLabel,3)
    else
        local nameLabel = CCRenderLabel:createWithAlign(localData.name, g_sFontName, 24,
                                      1 , ccc3(0, 0, 0 ), type_stroke, CCSizeMake(25,180), kCCTextAlignmentCenter,
                                      kCCVerticalTextAlignmentCenter);
        -- nameLabel:setSourceAndTargetColor(ccc3( 0x36, 0xff, 0x00), ccc3( 0x36, 0xff, 0x00));
        nameLabel:setColor(ccc3(0xff, 0xff, 0xff))
        nameLabel:setPosition(ccp( _cardSprite:getContentSize().width*0.02, _cardSprite:getContentSize().height*0.98))
        _cardSprite:addChild(nameLabel,3)
    end

    return _cardSprite
end

-- createCardLayer
function createSprite( item_tmpl_id, totalScore)
    init()
    _item_tmpl_id = item_tmpl_id
	return create(item_tmpl_id, totalScore)
end

function refreshCardSprite( m_cardSprite, totalScore)
    if(scoreSprite) then
        scoreSprite:removeFromParentAndCleanup(true)
        scoreSprite=nil
    end
    totalScore = totalScore or 0
    require "script/libs/LuaCC"
    scoreSprite = LuaCC.createSpriteOfNumbers("images/item/equipnum", totalScore, 17)
    if (scoreSprite ~= nil) then
        scoreSprite:setAnchorPoint(ccp(0, 0))
        scoreSprite:setPosition(m_cardSprite:getContentSize().width*110.0/301, m_cardSprite:getContentSize().height*0.05)
        m_cardSprite:addChild(scoreSprite)
    end
end



