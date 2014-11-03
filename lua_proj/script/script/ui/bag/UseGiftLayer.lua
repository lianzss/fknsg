-- FileName: UseGiftLayer.lua 
-- Author: licong 
-- Date: 14-8-6 
-- Purpose: 使用后选择一个物品领取 


module("UseGiftLayer", package.seeall)

require "script/utils/BaseUI"
require "script/ui/item/ItemUtil"

local _bgLayer                  = nil
local _backGround 				= nil
local _second_bg  				= nil
local _giftInfo 				= nil
local _curMenuItem 				= nil
local _curMenuTag 				= nil
local _itemTab 					= nil

function init( ... )
	_bgLayer                    = nil
	_backGround 				= nil
	_second_bg  				= nil
	_giftInfo 					= nil
	_curMenuItem 				= nil
	_curMenuTag 				= nil
	_itemTab 					= nil
end

--[[
	@des 	:查看物品信息返回回调 为了显示上方和下方按钮
	@param 	:
	@return :
--]]
function showDownMenu( ... )
    MainScene.setMainSceneViewsVisible(true, true, true)
end

--[[
	@des 	:touch事件处理
	@param 	:
	@return :
--]]
local function layerTouch(eventType, x, y)
    return true
end

--[[
	@des 	:关闭按钮回调
	@param 	:
	@return :
--]]
function closeButtonCallback( tag, sender )
    -- 音效
    require "script/audio/AudioUtil"
    AudioUtil.playEffect("audio/effect/guanbi.mp3")
	if(_bgLayer)then
		_bgLayer:removeFromParentAndCleanup(true)
		_bgLayer = nil
	end
end

--[[
	@des 	:选择按钮回调
	@param 	:
	@return :
--]]
function menuItemCallBack( tag, itemBtn )
 	-- 音效
	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")

	itemBtn:selected()
	if(itemBtn ~= _curMenuItem) then
		if(tolua.cast(_curMenuItem,"CCMenuItemImage") ~= nil)then
			_curMenuItem:unselected()
		end
		_curMenuItem = itemBtn
		_curMenuTag = tag

		print("_curMenuTag == ",_curMenuTag)
	end
end

--[[
	@des 	:领取按钮回调
	@param 	:
	@return :
--]]
function yesCallBack( tag, itemBtn )
 	-- 音效
	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")

	if(_curMenuTag == nil)then
		require "script/ui/tip/AnimationTip"
		AnimationTip.showTip(GetLocalizeStringBy("lic_1197"))
	else
		-- 关闭
		closeButtonCallback()
		-- 使用回调
		local function useCallback( cbFlag, dictData, bRet )
			if( dictData.err == "ok" ) then
				if(dictData.ret == "ok")then

					local itemDataTab = {}
					table.insert(itemDataTab,_itemTab[_curMenuTag])
					-- 展示
					require "script/ui/item/ReceiveReward"
		    		ReceiveReward.showRewardWindow( itemDataTab, showDownMenu, 1000 )
		    		-- 修改本地数据
		    		ItemUtil.addRewardByTable(itemDataTab)
				end
			end
		end
		local args = Network.argsHandler(_giftInfo.gid, _giftInfo.item_id, _curMenuTag-1)
		Network.rpc(useCallback, "bag.useGift", "bag.useGift", args, true)
	end
end

--[[
	@des 	:创建展示tableView的cell
	@param 	:p_data cell数据, p_index 第几次召唤
	@return :
--]]
function createCell( p_data, p_index )
	print("p_data p_index",p_index)
	print_t(p_data)
	local iconSprite = ItemUtil.createGoodsIcon(p_data, -422, 1000, -450, showDownMenu ,true)

	local menu = CCMenu:create()
	menu:setTouchPriority(-422)
	menu:setAnchorPoint(ccp(0,0))
	menu:setPosition(ccp(0,0))
	iconSprite:addChild(menu,1,10)

	local menuItem = CCMenuItemImage:create("images/common/btn/radio_normal.png","images/common/btn/radio_selected.png")
	menuItem:setAnchorPoint(ccp(0.5, 1))
	menuItem:setPosition(ccp(iconSprite:getContentSize().width*0.5, -27))
	menu:addChild(menuItem, 1, tonumber(p_index))
	menuItem:registerScriptTapHandler(menuItemCallBack)

	return iconSprite
end

--[[
	@des 	:创建展示tableView
	@param 	:
	@return :
--]]
function createTableView( ... )
	_itemTab = ItemUtil.getItemsDataByStr(_giftInfo.itemDesc.choose_items)
	local cellSize = CCSizeMake(550, 212)
	local h = LuaEventHandler:create(function(fn, table, a1, a2) 	--创建
		local r
		if fn == "cellSize" then
			r = cellSize
		elseif fn == "cellAtIndex" then
			a2 = CCTableViewCell:create()
			local posArrX = {0.14,0.38,0.62,0.86}
			for i=1,4 do
				if(_itemTab[a1*4+i] ~= nil)then
					local item_sprite = createCell(_itemTab[a1*4+i],a1*4+i)
					item_sprite:setAnchorPoint(ccp(0.5,1))
					item_sprite:setPosition(ccp(550*posArrX[i],205))
					a2:addChild(item_sprite)
					if(a1*4+i == _curMenuTag)then
						tolua.cast(item_sprite:getChildByTag(10):getChildByTag(_curMenuTag),"CCMenuItemImage"):selected()
						_curMenuItem = item_sprite:getChildByTag(10):getChildByTag(_curMenuTag)
					end
				end
			end
			r = a2
		elseif fn == "numberOfCells" then
			local num = #_itemTab
			r = math.ceil(num/4)
		else
		end
		return r
	end)

	local tableView = LuaTableView:createWithHandler(h, CCSizeMake(550, 260))
	tableView:setBounceable(true)
	tableView:setTouchPriority(-423)
	tableView:ignoreAnchorPointForPosition(false)
	tableView:setAnchorPoint(ccp(0.5,0.5))
	tableView:setPosition(ccp(_second_bg:getContentSize().width*0.5,_second_bg:getContentSize().height*0.5))
	_second_bg:addChild(tableView)
		-- 设置单元格升序排列
	tableView:setVerticalFillOrder(kCCTableViewFillTopDown)
end


--[[
	@des 	:创建提示框
	@param 	:
	@return :
--]]
function createTipLayer( ... )

	_bgLayer = CCLayerColor:create(ccc4(11,11,11,200))
    _bgLayer:setTouchEnabled(true)
    _bgLayer:registerScriptTouchHandler(layerTouch,false,-420,true)
    local scene = CCDirector:sharedDirector():getRunningScene()
    scene:addChild(_bgLayer,1000,1)

	-- 创建背景
	_backGround = CCScale9Sprite:create(CCRectMake(100, 80, 10, 20),"images/common/viewbg1.png")
    _backGround:setContentSize(CCSizeMake(605, 478))
    _backGround:setAnchorPoint(ccp(0.5,0.5))
    _backGround:setPosition(ccp(_bgLayer:getContentSize().width*0.5,_bgLayer:getContentSize().height*0.5))
    _bgLayer:addChild(_backGround)
    -- 适配
    setAdaptNode(_backGround)

    -- 标题
    local titlePanel = CCSprite:create("images/common/viewtitle1.png")
	titlePanel:setAnchorPoint(ccp(0.5, 0.5))
	titlePanel:setPosition(ccp(_backGround:getContentSize().width/2, _backGround:getContentSize().height-6.6 ))
	_backGround:addChild(titlePanel)
	local titleLabel = CCLabelTTF:create(GetLocalizeStringBy("lic_1194"), g_sFontPangWa, 33)
	titleLabel:setColor(ccc3(0xff, 0xe4, 0x00))
	titleLabel:setAnchorPoint(ccp(0.5,0.5))
	titleLabel:setPosition(ccp(titlePanel:getContentSize().width*0.5, titlePanel:getContentSize().height*0.5))
	titlePanel:addChild(titleLabel)

	-- 关闭按钮
	local menu = CCMenu:create()
    menu:setTouchPriority(-420)
	menu:setPosition(ccp(0, 0))
	menu:setAnchorPoint(ccp(0, 0))
	_backGround:addChild(menu,3)
	local closeButton = CCMenuItemImage:create("images/common/btn_close_n.png", "images/common/btn_close_h.png")
	closeButton:setAnchorPoint(ccp(0.5, 0.5))
	closeButton:setPosition(ccp(_backGround:getContentSize().width * 0.955, _backGround:getContentSize().height*0.975 ))
	closeButton:registerScriptTapHandler(closeButtonCallback)
	menu:addChild(closeButton)

 	-- 提示
	local fontTip = CCLabelTTF:create(GetLocalizeStringBy("lic_1196"), g_sFontPangWa, 25)
    fontTip:setAnchorPoint(ccp(0.5,1))
    fontTip:setColor(ccc3(0x78, 0x25, 0x00))
    fontTip:setPosition(ccp(_backGround:getContentSize().width*0.5,_backGround:getContentSize().height-56))
    _backGround:addChild(fontTip)

	-- 二级背景
	_second_bg = BaseUI.createContentBg(CCSizeMake(556,270))
 	_second_bg:setAnchorPoint(ccp(0.5,1))
 	_second_bg:setPosition(ccp(_backGround:getContentSize().width*0.5,_backGround:getContentSize().height-98))
 	_backGround:addChild(_second_bg)

    -- 确定按钮
    local normalSprite  = CCScale9Sprite:create("images/common/btn/btn1_d.png")
    normalSprite:setContentSize(CCSizeMake(198,73))
    local selectSprite  = CCScale9Sprite:create("images/common/btn/btn1_n.png")
    selectSprite:setContentSize(CCSizeMake(198,73))
    local yesMenuItem = CCMenuItemSprite:create(normalSprite,selectSprite)
    yesMenuItem:setAnchorPoint(ccp(0.5,0))
    yesMenuItem:setPosition(ccp(_backGround:getContentSize().width*0.5, 35))
    yesMenuItem:registerScriptTapHandler(yesCallBack)
    menu:addChild(yesMenuItem)
    local  itemfont1 = CCRenderLabel:create( GetLocalizeStringBy("lic_1195"), g_sFontPangWa, 35, 1, ccc3(0x00,0x00,0x00), type_stroke)
    itemfont1:setAnchorPoint(ccp(0.5,0.5))
    itemfont1:setColor(ccc3(0xfe,0xdb,0x1c))
    itemfont1:setPosition(ccp(yesMenuItem:getContentSize().width*0.5,yesMenuItem:getContentSize().height*0.5))
    yesMenuItem:addChild(itemfont1)

    -- 创建tableView
    createTableView()
end


--[[
	@des 	:名将好感交换成功后提示框
	@param 	:p_giftInfo 使用的礼包信息
	@return :
--]]
function showTipLayer( p_giftInfo )
	-- 初始化
	init()
	
	-- gid
	_giftInfo = p_giftInfo

	print("_giftInfo==>")
	print_t(_giftInfo)
	-- 创建ui
	createTipLayer()
end






































