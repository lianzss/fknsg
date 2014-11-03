-- Filename：	ActiveUtil.lua
-- Author：		zhz
-- Date：		2013-9-29
-- Purpose：		方法

module ("ActiveUtil", package.seeall)

require "script/ui/hero/HeroPublicLua"
require "script/ui/item/ItemSprite"
require "script/ui/item/ItemUtil"
require "db/DB_Heroes"	
require "script/utils/GoodTableView"


--------------------------- 神秘商店使用

--[[
    @des:       通过类型和 type 获得物品的 图标;   type = 1：物品ID ,type = 2：英雄ID , type=3 :宝物碎片
    @return:    icon
]]
function getItemIcon( itemType, item_temple_id, menu_priority )
    menu_priority = menu_priority or -665
	local itemSprite 
	if(itemType == 1) then
		-- 武魂的
		if(item_temple_id >= 400001 and item_temple_id <= 500000)then
			itemSprite= ItemSprite.getHeroFragIconByItemId(tonumber(item_temple_id), nil, menu_priority )
		else
			itemSprite= ItemSprite.getItemSpriteById(tonumber(item_temple_id), nil, nil, nil, menu_priority)
		end
	elseif(itemType== 2) then
		itemSprite= ItemSprite.getHeroIconItemByhtid( tonumber(item_temple_id),  menu_priority) --HeroPublicCC.getCMISHeadIconByHtid(tonumber(item_temple_id))
	elseif(itemType ==3) then
		itemSprite= ItemSprite.getItemSpriteById(tonumber(item_temple_id), nil, nil, nil, menu_priority)
	end

	return itemSprite
	
end

--[[
    @des:       通过类型和 type 获得物品的 名称
    @return:    Info
]]
function getItemInfo( itemType, item_temple_id )
	local itemInfo
	if(itemType == 1 or itemType== 3) then
		itemInfo=  ItemUtil.getItemById(item_temple_id)
	elseif(itemType == 2) then
		itemInfo= DB_Heroes.getDataById(item_temple_id)
		itemInfo.quality = itemInfo.star_lv
	end
	return itemInfo
end

--[[
    @des:      通过 itemTable 弹出奖励
    @return:   
]]
function showItemGift( item )
	local items = {}
	local itemTable= {}
	if(item.type==1 or item.type == 3) then
		itemTable.type = "item"
	elseif(item.type) then
		itemTable.type = "hero"
	end
	itemTable.tid = item.tid
	itemTable.num = item.num

	table.insert(items, itemTable)

	local layer = GoodTableView.ItemTableView:create(items)
	local alertContent = {}
	alertContent[1] = CCRenderLabel:create(GetLocalizeStringBy("key_1248") , g_sFontPangWa, 36,1, ccc3(0x00,0,0),type_stroke)
	alertContent[1]:setColor(ccc3(0xff, 0xc0, 0x00))
	local alert = BaseUI.createHorizontalNode(alertContent)
	layer:setContentTitle(alert)
	CCDirector:sharedDirector():getRunningScene():addChild(layer,1111)

end


