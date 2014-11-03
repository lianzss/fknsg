-- Filename：	CheckBoxItem.lua
-- Author：		Cheng Liang
-- Date：		2013-7-13
-- Purpose：		复选框

module("CheckBoxItem", package.seeall)



function create( ... )

	local fullRect = CCRectMake(0,0,34,32)
	local insetRect = CCRectMake(10,10,14,12)
	local normalSprite = CCScale9Sprite:create("images/common/checkbg.png", fullRect, insetRect)
	normalSprite:setPreferredSize(CCSizeMake(45, 45))
	

	-- local normalSprite = CCSprite:create("images/common/checkbg.png")
	local selectedSprite = CCScale9Sprite:create("images/common/checkbg.png", fullRect, insetRect)
	selectedSprite:setPreferredSize(CCSizeMake(45, 45))
	local checkedSprite = CCSprite:create("images/common/checked.png")
	selectedSprite:addChild(checkedSprite)
	local menuItem = CCMenuItemSprite:create(normalSprite, selectedSprite)

	return menuItem
end
