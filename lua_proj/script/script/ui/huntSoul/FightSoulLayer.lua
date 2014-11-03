-- FileName: FightSoulLayer.lua 
-- Author: Li Cong 
-- Date: 14-2-11 
-- Purpose: function description of module 


module("FightSoulLayer", package.seeall)

local _bgLayer 				= nil
local _bgSprite 			= nil
_fightSoulData 				= nil
m_soulTableView				= nil
local itemNumbersSprite  	= nil

-- 初始化
function init( ... )
	_bgLayer 				= nil
	_bgSprite 				= nil
	_fightSoulData 			= nil
	m_soulTableView			= nil
	itemNumbersSprite  		= nil
end

-- 增加GetLocalizeStringBy("key_2314")提示
function addBringSprite()
	-- 物品个数背景
    itemNumbersSprite = CCScale9Sprite:create("images/common/bgng_lefttimes.png", CCRectMake(0,0,33,33), CCRectMake(20,8,5,1))
    
    itemNumbersSprite:setAnchorPoint(ccp(0.5, 0))
    itemNumbersSprite:setPosition(_bgLayer:getContentSize().width/2, _bgLayer:getContentSize().height*0.015)
    itemNumbersSprite:setScale(g_fScaleX)
    _bgLayer:addChild(itemNumbersSprite, 2)

    -- 携带数标题：
    local bringNumLabel = CCRenderLabel:create(GetLocalizeStringBy("key_1838"), g_sFontName, 24, 1, ccc3(0, 0, 0), type_stroke)
    bringNumLabel:setAnchorPoint(ccp(0.5, 0.5))
    local hOffset = 6
    local tSizeOfText = bringNumLabel:getContentSize()
    bringNumLabel:setPosition(tSizeOfText.width/2+hOffset, itemNumbersSprite:getContentSize().height/2-1)
    itemNumbersSprite:addChild(bringNumLabel)

 	local allBagInfo = DataCache.getRemoteBagInfo()
 	local bagInfo = DataCache.getBagInfo()
	local displayNum = table.count(bagInfo.fightSoul) .. "/" .. allBagInfo.gridMaxNum.fightSoul
    -- 携带数数据：
    local numLabel = CCRenderLabel:create(displayNum, g_sFontName, 24, 1, ccc3(0, 0, 0), type_stroke)
    numLabel:setColor(ccc3(0x36, 255, 0))
    numLabel:setAnchorPoint(ccp(0.5, 0.5))
    local tSizeOfNum = numLabel:getContentSize()
    local x = tSizeOfText.width + hOffset + tSizeOfNum.width/2
    numLabel:setPosition(x-10, itemNumbersSprite:getContentSize().height/2-2)
    itemNumbersSprite:addChild(numLabel)

    local nWidth = x + tSizeOfNum.width/2
	
    itemNumbersSprite:setPreferredSize(CCSizeMake(nWidth, 33))
end

-- 物品个数
function createItemNumbersSprite( ... )
	if(itemNumbersSprite)then
		itemNumbersSprite:removeFromParentAndCleanup(true)
		itemNumbersSprite = nil
	end
	addBringSprite()
end 


-- 创建战魂tableView
function createFightSoulTableView( ... )

	local cellBg = CCSprite:create("images/bag/item/item_cellbg.png")
	local cellSize = cellBg:getContentSize()			--计算cell大小

	require "script/ui/huntSoul/FightSoulCell"
	local handler = LuaEventHandler:create(function(fn, table, a1, a2)
		local r
		if (fn == "cellSize") then
			r = CCSizeMake(cellSize.width*g_fScaleX, cellSize.height*g_fScaleX)
		elseif (fn == "cellAtIndex") then
			r = FightSoulCell.createCell( _fightSoulData[a1+1], true )
			r:setScale(g_fScaleX)
		elseif (fn == "numberOfCells") then
			r = #_fightSoulData
		elseif (fn == "cellTouched") then
			-- print ("a1: ", a1, ", a2: ", a2)
			-- print ("cellTouched, index is: ", a1:getIdx())
		else
			-- print (fn, " event is not handled.")
		end
		return r
	end)
	print("_bgLayer:getContentSize().height",_bgLayer:getContentSize().height)
	local t_height = _bgLayer:getContentSize().height
	m_soulTableView  = LuaTableView:createWithHandler(handler, CCSizeMake(_bgLayer:getContentSize().width,t_height))
	m_soulTableView:setBounceable(true)
	m_soulTableView:setAnchorPoint(ccp(0, 0))
	m_soulTableView:setPosition(ccp(0, 10*g_fScaleX))
	_bgLayer:addChild(m_soulTableView,2)

end

-- 初始化界面
function initFightSoulLayer( ... )
    -- 大背景
	_bgSprite = CCScale9Sprite:create("images/main/module_bg.png")
    _bgSprite:setAnchorPoint(ccp(0.5,0.5))
    _bgSprite:setPosition(ccp(_bgLayer:getContentSize().width*0.5,_bgLayer:getContentSize().height*0.5))
    _bgLayer:addChild(_bgSprite)
    _bgSprite:setScale(g_fScaleX)

    -- 创建列表
    createFightSoulTableView()
    -- 显示携带数
    createItemNumbersSprite()
end

-- 创建战魂layer
function createFightSoulLayer( layerSize )
	print("layerSize.height",layerSize.height)
	init()
	_bgLayer = CCLayer:create()
	_bgLayer:setContentSize(layerSize)

	-- 战魂背包数据
	_fightSoulData = HuntSoulData.getFSBagShowData() or {}
	print(GetLocalizeStringBy("key_2143"))
	print_t(_fightSoulData)

	-- 初始化战魂界面
	initFightSoulLayer()

	return _bgLayer
end



