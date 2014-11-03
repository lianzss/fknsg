-- Filename: FindTreasureDescLayer.lua
-- Author: bzx
-- Date: 2014-06-12
-- Purpose: 寻龙探宝说明

module("FindTreasureDescLayer", package.seeall)

require "script/libs/LuaCCSprite"
require "db/DB_Explore_long"
require "db/DB_Help_tips"

local _layer
local _dialog
local _touch_priority = -600

function show()
    create()
    CCDirector:sharedDirector():getRunningScene():addChild(_layer, 100)
end

function create()
    _layer = CCLayerColor:create(ccc4(0, 0, 0, 100))
    _layer:registerScriptHandler(onNodeEvent)
    local dialog_info = {}
    dialog_info.title = GetLocalizeStringBy("key_8101")
    dialog_info.callbackClose = closeCallback
    dialog_info.size = CCSizeMake(630, 830)
    dialog_info.priority = _touch_priority - 1
    _dialog = LuaCCSprite.createDialog_1(dialog_info)
    _layer:addChild(_dialog)
    _dialog:setAnchorPoint(ccp(0.5, 0.5))
    _dialog:setPosition(ccp(g_winSize.width * 0.5, g_winSize.height * 0.5))
    _dialog:setScale(MainScene.elementScale)
    loadTips()
    loadTableView()
    return _layer
end

function onTouchesHandler(event)
    return true
end

-- 显示文字
function loadTips()
    local texts = string.split(DB_Help_tips.getDataById(1).tips, "|")
    local height = _dialog:getContentSize().height - 55
    for i = 1, #texts do
        local text = texts[i]
        local text_label = CCLabelTTF:create(text, g_sFontName, 21)
        _dialog:addChild(text_label)
        text_label:setAnchorPoint(ccp(0, 1))
        text_label:setPosition(50, height)
        text_label:setColor(ccc3(0x78, 0x25, 0x00))
        local dimensions_width = 540
        local dimensions_height = math.ceil(text_label:getContentSize().width / dimensions_width) * 24
        text_label:setDimensions(CCSizeMake(dimensions_width, dimensions_height))
        text_label:setHorizontalAlignment(kCCTextAlignmentLeft)
        local text_number_label = CCLabelTTF:create(tostring(i) .. ".", g_sFontName, 21)
        text_label:addChild(text_number_label)
        text_number_label:setAnchorPoint(ccp(1, 1))
        text_number_label:setPosition(-text_number_label:getContentSize().width + 10, text_label:getContentSize().height)
        text_number_label:setColor(ccc3(0x78, 0x25, 0x00))
        height = height - dimensions_height - 5
    end
end

-- 宝物一览
function loadTableView()
    local full_rect = CCRectMake(0,0,75, 75)
	local inset_rect = CCRectMake(30,30,15,15)
	local table_view_bg = CCScale9Sprite:create("images/common/bg/bg_ng_attr.png", full_rect, inset_rect)
	table_view_bg:setPreferredSize(CCSizeMake(580, 280))
    _dialog:addChild(table_view_bg)
    table_view_bg:setAnchorPoint(ccp(0.5, 0))
	table_view_bg:setPosition(ccp(_dialog:getContentSize().width * 0.5, 45))
    local cell_icon_count = 4
	local cell_size = CCSizeMake(479, 125)
    local items = parseDB(DB_Explore_long.getDataById(1)).itemPandect
	local h = LuaEventHandler:create(function(function_name, table_t, a1, cell)
		if function_name == "cellSize" then
			return cell_size
		elseif function_name == "cellAtIndex" then
			cell = CCTableViewCell:create()
			local start = a1 * cell_icon_count
			for i=1, 4 do
                local index = start + i
				if index <= #items then
                    local goodsValues = {}
                    goodsValues.type = "item"
                    goodsValues.tid = items[index][1]
                    goodsValues.num = 0
					local iconSprite = ItemUtil.createGoodsIcon(goodsValues, -435, 1010, -450, itemClickedCallback)
		            iconSprite:setAnchorPoint(ccp(0.5, 0.5))
		            iconSprite:setPosition(ccp(cell_size.width/cell_icon_count /2 + (i-1) * cell_size.width/cell_icon_count, cell_size.height * 0.5))
		            cell:addChild(iconSprite)
                end
			end
			return cell
		elseif function_name == "numberOfCells" then
			local count = #items
			return math.ceil(count / cell_icon_count )
		elseif function_name == "cellTouched" then
		elseif (function_name == "scroll") then
		end
	end)
	local item_table_view = LuaTableView:createWithHandler(h, CCSizeMake(500, 250))
    item_table_view:ignoreAnchorPointForPosition(false)
    item_table_view:setAnchorPoint(ccp(0.5, 1))
	item_table_view:setBounceable(true)
	item_table_view:setPosition(ccp(table_view_bg:getContentSize().width * 0.5, table_view_bg:getContentSize().height - 15))
	item_table_view:setVerticalFillOrder(kCCTableViewFillTopDown)
    item_table_view:setTouchPriority(_touch_priority - 2)
	table_view_bg:addChild(item_table_view)
    
    local title_bg = CCSprite:create("images/forge/floor_title_bg.png")
    table_view_bg:addChild(title_bg)
    title_bg:setAnchorPoint(ccp(0.5, 0.5))
    title_bg:setPosition(ccp(table_view_bg:getContentSize().width * 0.5, table_view_bg:getContentSize().height))
    
    local title_label = CCLabelTTF:create(GetLocalizeStringBy("key_8102"), g_sFontPangWa, 21)
    title_bg:addChild(title_label)
    title_label:setAnchorPoint(ccp(0.5, 0.5))
    title_label:setPosition(ccp(title_bg:getContentSize().width * 0.5, title_bg:getContentSize().height * 0.5))
    title_label:setColor(ccc3(0xff, 0xf6, 0x00))
    return table_view_bg
end

function itemClickedCallback()
end

function onNodeEvent(event)
    if (event == "enter") then
		_layer:registerScriptTouchHandler(onTouchesHandler, false, _touch_priority, true)
        _layer:setTouchEnabled(true)
	elseif (event == "exit") then
		_layer:unregisterScriptTouchHandler()
	end
end

function closeCallback()
    require "script/audio/AudioUtil"
    AudioUtil.playEffect("audio/effect/guanbi.mp3")
    _layer:removeFromParentAndCleanup(true)
end