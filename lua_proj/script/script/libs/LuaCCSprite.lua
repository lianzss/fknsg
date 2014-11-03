-- Filename: LuaCCSprite.lua
-- Author: fang
-- Date: 2013-08-02
-- Purpose: 该文件用于在lua中封装cocos2d-x中CCSprite及CCScale9Sprite对象

module("LuaCCSprite", package.seeall)


-- 创建带标题的图片（标题在图片的中心）
function createSpriteWithRenderLabel(bgfile, tLabel)
	local ccSprite = CCSprite:create(bgfile)
	local spriteSize = ccSprite:getContentSize()
	local ccLabel = CCRenderLabel:create(tLabel.text, g_sFontName, tLabel.fontsize, tLabel.stroke_size, tLabel.stroke_color, type_stroke)
	ccLabel:setSourceAndTargetColor(tLabel.sourceColor, tLabel.targetColor)

	local x = spriteSize.width/2
	local y = spriteSize.height/2
	if tLabel.vOffset then
		y = y + tLabel.vOffset
	end
	if tLabel.hOffset then
		x = x + tLabel.hOffset
	end

	ccLabel:setPosition(ccp(x, y))
	if tLabel.tag then
		ccSprite:addChild(ccLabel, 0, tLabel.tag)
	else
		ccSprite:addChild(ccLabel)
	end
	-- 真奇怪！应该是CCRenderLabel类有bug，否则不该是ccp(1, 0)
	if tLabel.anchorPoint then
		ccLabel:setAnchorPoint(tLabel.anchorPoint)
	end
	return ccSprite
end
-- 创建带标题的图片（标题在图片的中心）
function createSpriteWithLabel(bgfile, tLabel)
	local ccSprite = CCSprite:create(bgfile)
	local spriteSize = ccSprite:getContentSize()
	local fontname = tLabel.fontname or g_sFontName
	local ccLabel = CCLabelTTF:create (tLabel.text, fontname, tLabel.fontsize)
	if (tLabel.color) then
		ccLabel:setColor(tLabel.color)
	end
	ccLabel:setAnchorPoint(ccp(0.5, 0.5))
	local x = spriteSize.width/2
	local y = spriteSize.height/2
	if tLabel.vOffset then
		y = y + tLabel.vOffset
	end
	if tLabel.hOffset then
		x = x + tLabel.hOffset
	end

	ccLabel:setPosition(ccp(x, y))
	if (tLabel.tag) then
		ccSprite:addChild(ccLabel, 0, tLabel.tag)
	else
		ccSprite:addChild(ccLabel)
	end

	return ccSprite
end

-- 创建统一标题栏（上面带有菜单按钮）
-- in: tParam, 输入参数，应该是个数组
-- out: 返回一个CCSprite对象。该对象上包含着menu(tag为10001)，
-- menu中包含着CCMenuItem对象数组(默认tag以1001为起始值，如果参数中带有tag的话则以参数为准)
function createTitleBar(tParam)
	local fullRect = CCRectMake(0,0,58,99)
	local insetRect = CCRectMake(20,20,18,59)
	--标题背景
	local cs9Bg = CCScale9Sprite:create("images/common/menubg.png", fullRect, insetRect)
	cs9Bg:setPreferredSize(CCSizeMake(640, 108))
	
	local menu = CCMenu:create()
	menu:setPosition(ccp(10, 10))
	cs9Bg:addChild(menu, 0, 10001)
	for i=1, #tParam do
		local item=tParam[i]
		-- 普通文本以默认
		local nFontsize = item.nFontsize or 36
		local nColor = item.nColor or ccc3(0xff, 0xe4, 0)
		local pFontname = item.fontname or g_sFontPangWa
		local vOffset = item.vOffset or -4
		local tNormalLabel = {text=item.text, color=nColor, fontsize=nFontsize, fontname=pFontname, vOffset=vOffset}
		local sNormalImage = item.normalN or "images/active/rob/btn_title_n.png"
		local csNormal = createSpriteWithLabel(sNormalImage, tNormalLabel)
		
		local hFontsize = item.hFontsize or 30
		local hColor = item.hColor or ccc3(0x48, 0x85, 0xb5)
		local tHighlightedLabel = {text=item.text, color=hColor, fontsize=hFontsize, fontname=pFontname, vOffset=vOffset}
		local sHighlightedImage = item.normalH or "images/active/rob/btn_title_h.png"
		local csHighlighted = createSpriteWithLabel(sHighlightedImage, tHighlightedLabel)
		local nTagOfItem = item.tag or 1000+i
		local cmis = CCMenuItemSprite:create(csNormal, csHighlighted)
		local x=item.x or 0
		local y=item.y or 0
		cmis:setPosition(x, y)
		if item.handler then
			cmis:registerScriptTapHandler(item.handler)
		end
		menu:addChild(cmis, 0, nTagOfItem)
	end

	return cs9Bg
end

function createTitleBarCpy(tParam)
	local fullRect = CCRectMake(0,0,58,99)
	local insetRect = CCRectMake(20,20,18,59)
	--标题背景
	local cs9Bg = CCScale9Sprite:create("images/common/menubg.png", fullRect, insetRect)
	cs9Bg:setPreferredSize(CCSizeMake(640, 108))
	
	local menu = CCMenu:create()
	menu:setPosition(ccp(10, 10))
	cs9Bg:addChild(menu, 0, 10001)
	return cs9Bg
end

--[[
dialog_info = {
    title 对话框标题
    callbackClose 关闭按钮的回调
    size 对话框尺寸
    priority 对话框优先级
    swallowTouch = false
    isRunning 
}
--]]
-- 创建一个对话框
function createDialog_1(dialog_info)
    local dialog = nil
    if dialog_info.swallowTouch == true then
        dialog = CCLayerColor:create(ccc4(0, 0, 0, 155))
        local onTouchesHandler = function( eventType, x, y )
            return true
        end
        local onNodeEvent = function( event )
            if (event == "enter") then
                dialog:registerScriptTouchHandler(onTouchesHandler, false, dialog_info.priority, true)
                dialog:setTouchEnabled(true)
                dialog_info.isRunning = true
            elseif (event == "exit") then
                dialog:unregisterScriptTouchHandler()
                dialog_info.isRunning = false
            end
        end
        dialog:registerScriptHandler(onNodeEvent)
    else
        dialog = CCNode:create()
        dialog:setContentSize(dialog_info.size)
    end
    local bg = CCScale9Sprite:create(CCRectMake(100, 80, 10, 20), "images/common/viewbg1.png")
    dialog_info.dialog = bg
    bg:setContentSize(dialog_info.size)
    bg:setAnchorPoint(ccp(0,0))
    bg:setPosition(0,0)
    dialog:addChild(bg)
    bg:setTag(1)


    -- 标题
    local title_bg = CCSprite:create("images/formation/changeformation/titlebg.png")
   	bg:addChild(title_bg)
	title_bg:setAnchorPoint(ccp(0.5,0.5))
	title_bg:setPosition(ccp(bg:getContentSize().width * 0.5, bg:getContentSize().height - 6))

	local title_label = CCLabelTTF:create(dialog_info.title, g_sFontPangWa, 33)
    title_bg:addChild(title_label)
	title_label:setColor(ccc3(0xff, 0xe4, 0x00))
	title_label:setAnchorPoint(ccp(0.5, 0.5))
	title_label:setPosition(ccp(title_bg:getContentSize().width * 0.5, title_bg:getContentSize().height * 0.5))
	
    -- 按钮Bar
    local menu = CCMenu:create()
    menu:setPosition(ccp(0,0))
    menu:setTouchPriority(dialog_info.priority - 1)
    bg:addChild(menu, 10)
    
    if dialog_info.callbackClose == nil then
        dialog_info.callbackClose = function()
            dialog:removeFromParentAndCleanup(true)
        end
    end
    -- 关闭按钮
    if dialog_info.callbackClose ~= nil then
        local close_btn = LuaMenuItem.createItemImage("images/common/btn_close_n.png", "images/common/btn_close_h.png" )
        close_btn:setAnchorPoint(ccp(1, 1))
        close_btn:setPosition(bg:getContentSize().width + 10, bg:getContentSize().height + 15)
        menu:addChild(close_btn)
        close_btn:registerScriptTapHandler(dialog_info.callbackClose)
    end

    return dialog
end


--[[
local radio_data = {
    touch_priority      -- 触摸优先级
    space               -- 按钮间距
    callback            -- 按钮回调
    direction           -- 方向 1为水平，2为竖直
    items = {
        {normal = "images/chat/wei_n.png", selected = "images/chat/wei_h.png"},
            ...
    }
}
--]]
-- 创建选项卡的按钮
function createRadioMenu(radio_data)
    local item_count = #radio_data.items
    local items = {}
    for i  = 1, item_count do
        local item_data = radio_data.items[i]
        local item = CCMenuItemImage:create(item_data.normal, item_data.selected, item_data.selected)
        table.insert(items, item)
    end
    radio_data.items = items
    local menu = createRadioMenuWithItems(radio_data)
    return menu
end


--[[
local radio_data = {
    touch_priority      -- 触摸优先级
    space               -- 按钮间距
    callback            -- 按钮回调
    direction           -- 方向 1为水平，2为竖直
    defaultIndex         -- 默认选择的index
    items = {
        CCMenuItem,
        CCMenuItem,
        ...
    }
}
--]]
-- 创建选项卡的按钮
function createRadioMenuWithItems(radio_data)
    radio_data.defaultIndex = radio_data.defaultIndex or 1
    local menu = CCMenu:create()
    menu:ignoreAnchorPointForPosition(false)
    menu:setTouchPriority(radio_data.touch_priority)
    local space = radio_data.space
    local item_count = #radio_data.items
    local last_item = nil
    local callback = function(tag, item)
        item:setEnabled(false)
        if last_item ~= nil then
            last_item:setEnabled(true)
        end
        last_item = item
        radio_data.callback(tag, item)
    end
    local item_size = nil
    for i = 1, item_count do
        local item = radio_data.items[i]
        menu:addChild(item)
        item:registerScriptTapHandler(callback)
        item:setTag(i)
        if i == radio_data.defaultIndex then
            callback(i, item)
        end
        if i == 1 then
            item_size = item:getContentSize()
            if radio_data.direction == 2 then
                menu:setContentSize(CCSizeMake(item_size.width, (item_size.height + space) * item_count - space))
            else
                menu:setContentSize(CCSizeMake((item_size.width + space) * item_count - space, item_size.height))
            end
        end
        item:setAnchorPoint(ccp(0.5, 0))
        if radio_data.direction == 2 then
            item:setPosition(ccp(item_size.width * 0.5, (item_count - i) * item_size.height + (1 - i + item_count) * space))
        else
            item:setPosition(ccp((i - 0.5) * item_size.width + (i - 1) * space, 0))
        end
    end
    return menu
end

--[[
data = {
    normal 正常状态的图片
    selected 按下状态的图片
    disabled 不可点击时的图片
    size = 按钮尺寸
    icon = 数字前的小图标
    text = 按钮上的文字
    text_size = 文字的尺寸
    number = 数字 string类型的
    number_size = 数字尺寸
}
--]]
-- 创建带数字的按钮
function createNumberMenuItem(data)
    if data.disabled == nil then
        data.disabled = data.selected
    end
    local menu_item = LuaCC.create9ScaleMenuItemWithoutLabel(data.normal, data.selected, data.disabled, data.size)
    local label = {}
    data.text_size = data.text_size or 35
    label[1] = CCRenderLabel:create(data.text, g_sFontPangWa, data.text_size, 1, ccc3(0x00, 0x00, 0x00), type_stroke)
    label[1]:setColor(ccc3(0xfe, 0xdb, 0x1c))
    if data.number ~= "0" then
        label[2] = CCSprite:create(data.icon)
        data.number_size = data.number_size or 25
        label[3] = CCLabelTTF:create(data.number, g_sFontPangWa, data.number_size)
        label[3]:setColor(ccc3(0xfe, 0xdb, 0x1c))
        data.number_label = label[3]
    end
    label_node = BaseUI.createHorizontalNode(label)
    label_node:setAnchorPoint(ccp(0.5, 0.5))
    label_node:setPosition(ccp(data.size.width * 0.5, data.size.height * 0.5))
    menu_item:addChild(label_node)
    return menu_item
end

-- 创建提示的小红点
function createTipSpriteWithNum(num)
	require "script/ui/rechargeActive/ActiveCache"
	local tip_sprite= CCSprite:create("images/common/tip_2.png")
	tip_sprite:setAnchorPoint(ccp(0.5, 0.5))
	if num > 0 then
        local num_label = CCLabelTTF:create(tostring(num), g_sFontName, 17)
        tip_sprite:addChild(num_label)
		num_label:setAnchorPoint(ccp(0.5, 0.5))
        num_label:setPosition(ccp(tip_sprite:getContentSize().width * 0.5, tip_sprite:getContentSize().height * 0.5))
	end
	return tip_sprite
end


-- 释放模块占用资源
function release()
	LuaCCSprite = nil
	for k, v in pairs(package.loaded) do
		local s, e = string.find(k, "/LuaCCSprite")
		if s and e == string.len(k) then
			package.loaded[k] = nil
		end
	end
end
