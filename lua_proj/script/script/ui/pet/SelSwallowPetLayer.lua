-- Filename：	SelSwallowPetLayer.lua
-- Author：		zhz
-- Date：		2014-3-4
-- Purpose：		选择吞噬宠物UI

module("SelSwallowPetLayer", package.seeall)

require "script/audio/AudioUtil"
require "script/ui/pet/PetSelectCell"
require "script/ui/pet/PetData"
require "db/DB_Pet"


local _bgLayer
local _selCheckedArr
local _startItemId
local _bottomSprite
local _topTitleSprite
local _touchPriority
local _zOrder
local _petId				-- 吞噬宠物的ID
local _canSwaPetInfo		-- 可以吞噬的宠物信息
local _swallow_pet_id		-- 被吞噬的宠物id
local _preSwallow_id		-- 上次被选中的吞噬宠物


local function init( )
	_bgLayer			=nil
	_selCheckedArr		=nil
	_startItemId		=nil
	_bottomSprite		=nil
	_topTitleSprite		=nil
	_touchPriority		=nil
	_zOrder				=nil
	_petId				=nil
end



-- 创建标题面板
local function createTitleLayer( )

	-- 标题背景底图
	_topTitleSprite = CCSprite:create("images/hero/select/title_bg.png")
	_topTitleSprite:setScale(g_fScaleX)
	-- 加入背景标题底图进层
	-- 标题
	local ccSpriteTitle = CCSprite:create("images/pet/pet/choose_pet.png")
	ccSpriteTitle:setPosition(ccp(45, 50))
	_topTitleSprite:addChild(ccSpriteTitle)

	local tItems = {
		{normal="images/common/close_btn_n.png", highlighted="images/common/close_btn_h.png", pos_x=493, pos_y=40, cb=closeAction},
	}
	local menu = LuaCC.createMenuWithItems(tItems)
	menu:setPosition(ccp(0, 0))
	menu:setTouchPriority(_touchPriority-1 )
	_topTitleSprite:addChild(menu)

	_topTitleSprite:setPosition(0, _layerSize.height)
	_topTitleSprite:setAnchorPoint(ccp(0, 1))
	_bgLayer:addChild(_topTitleSprite)
end

-- 创建底部面板
local function createBottomSprite()

	_bottomSprite = CCSprite:create("images/common/sell_bottom.png")
	_bottomSprite:setScale(g_fScaleX)
	_bottomSprite:setPosition(ccp(0, 0))
	_bottomSprite:setAnchorPoint(ccp(0,0))
	_bgLayer:addChild(_bottomSprite, 10)

	-- 已选择装备
	local equipLabel = CCLabelTTF:create(GetLocalizeStringBy("key_3300"), g_sFontName, 25)
	equipLabel:setColor(ccc3(0xff, 0xff, 0xff))
	equipLabel:setAnchorPoint(ccp(0, 0.5))
	equipLabel:setPosition(ccp(8 ,_bottomSprite:getContentSize().height*0.4))
	_bottomSprite:addChild(equipLabel)

	-- 物品数量背景
	local fullRect = CCRectMake(0,0,34,32)
	local insetRect = CCRectMake(10,10,14,12)
	local itemNumSprite = CCScale9Sprite:create("images/common/checkbg.png", fullRect, insetRect)
	itemNumSprite:setPreferredSize(CCSizeMake(65, 38))
	itemNumSprite:setAnchorPoint(ccp(0,0.5))
	itemNumSprite:setPosition(ccp(144, _bottomSprite:getContentSize().height*0.4))
	_bottomSprite:addChild(itemNumSprite)

	-- -- 物品数量
	_itemNumLabel = CCLabelTTF:create("0", g_sFontName, 25)
	_itemNumLabel:setColor(ccc3(0xff, 0xff, 0xff))
	_itemNumLabel:setAnchorPoint(ccp(0.5, 0.5))
	_itemNumLabel:setPosition(ccp(itemNumSprite:getContentSize().width*0.5, itemNumSprite:getContentSize().height*0.4))
	itemNumSprite:addChild(_itemNumLabel)


	local pointLabel = CCLabelTTF:create(GetLocalizeStringBy("key_1342"), g_sFontName, 25)
	pointLabel:setColor(ccc3(0xff, 0xff, 0xff))
	pointLabel:setAnchorPoint(ccp(0, 0.5))
	pointLabel:setPosition(ccp(235 , _bottomSprite:getContentSize().height*0.4))
	_bottomSprite:addChild(pointLabel)

	-- 技能点数量背景
	local fullRect = CCRectMake(0,0,34,32)
	local insetRect = CCRectMake(10,10,14,12)
	local skillNumSprite = CCScale9Sprite:create("images/common/checkbg.png", fullRect, insetRect)
	skillNumSprite:setPreferredSize(CCSizeMake(65, 38))
	skillNumSprite:setAnchorPoint(ccp(0,0.5))
	skillNumSprite:setPosition(ccp(385 , _bottomSprite:getContentSize().height*0.4))
	_bottomSprite:addChild(skillNumSprite)

	-- -- 物品数量
	_skillNumLabel = CCLabelTTF:create("0", g_sFontName, 25)
	_skillNumLabel:setColor(ccc3(0xff, 0xff, 0xff))
	_skillNumLabel:setAnchorPoint(ccp(0.5, 0.5))
	_skillNumLabel:setPosition(ccp(skillNumSprite:getContentSize().width*0.5, skillNumSprite:getContentSize().height*0.4))
	skillNumSprite:addChild(_skillNumLabel)

	-- 出售按钮
	local sureMenuBar = CCMenu:create()
	sureMenuBar:setPosition(ccp(0,0))
	_bottomSprite:addChild(sureMenuBar)
	sureMenuBar:setTouchPriority(_touchPriority-5 )
	local sureBtn =  LuaMenuItem.createItemImage("images/tip/btn_confirm_n.png", "images/tip/btn_confirm_h.png" )
	sureBtn:setAnchorPoint(ccp(0.5, 0.5))
    sureBtn:setPosition(ccp(_bottomSprite:getContentSize().width*560/640, _bottomSprite:getContentSize().height*0.4))
    sureBtn:registerScriptTapHandler(sureBtnAction)

	sureMenuBar:addChild(sureBtn)
end


function refreshBottomSprite( )

	
	if(_swallow_pet_id== nil) then
		_itemNumLabel:setString("0")
	else
		_itemNumLabel:setString("1")
	end

	local swallowedPetInfo = PetData.getPetInfoById(tonumber(_swallow_pet_id))
	local petData = DB_Pet.getDataById( tonumber(swallowedPetInfo.pet_tmpl))

	local addPoint , level = PetData.getAddPoint(_petId, _swallow_pet_id)
	_skillNumLabel:setString(addPoint)
	print("curLv is ", level ," addPoint is", addPoint )
	-- local swallowNumber= tonumber(swallowedPetInfo.swallow )* 
	
end

-- 创建选择宠物的tableView
local function createTableView( )

	
	_canSwaPetInfo= PetData.getCanSwallowPetInfoByTid(_petId)
	print(" ------------------ _canSwaPetInfo --------------------------- ")
	print_t(_canSwaPetInfo)

	local cellSize = CCSizeMake(640*g_fScaleX,210*g_fScaleX)
    local h = LuaEventHandler:create(function(fn, table, a1, a2)    --创建
        local r
        if fn == "cellSize" then
            r = CCSizeMake(cellSize.width, cellSize.height)
        elseif fn == "cellAtIndex" then
            a2 = PetSelectCell.createCell(_canSwaPetInfo[a1 + 1], _touchPriority-1 )
            a2:setScale(g_fScaleX)
            r = a2
        elseif fn == "numberOfCells" then
            r = #_canSwaPetInfo
        elseif fn == "cellTouched" then
            
        elseif (fn == "scroll") then
            
        end
        return r
    end)
    local height = _layerSize.height- (_topTitleSprite:getContentSize().height - 12)*(_topTitleSprite:getScale()) - _bottomSprite:getContentSize().height* _bottomSprite:getScale()
    _myTableView = LuaTableView:createWithHandler(h, CCSizeMake(_layerSize.width,height))
    _myTableView:setAnchorPoint(ccp(0,0))
    _myTableView:setBounceable(true)
    -- _myTableView:setScale(g_fScaleX)
    _myTableView:setTouchPriority(_touchPriority-1)
    _myTableView:setPosition(ccp(0, _bottomSprite:getContentSize().height* _bottomSprite:getScale()))
    -- myTableView:setVerticalFillOrder(kCCTableViewFillTopDown)
    _bgLayer:addChild(_myTableView, 9)
	
end

function rfcTableView( )

	_canSwaPetInfo= PetData.getCanSwallowPetInfoByTid(_petId)

	local offset = _myTableView:getContentOffset()
	_myTableView:reloadData()
	_myTableView:setContentOffset(offset)
	
end


-- 得到被宠物吞噬的id
function getSwallowPetId(  )
	
	return _swallow_pet_id
end

function setSwalloePetId(swallowedId )
	_swallow_pet_id= swallowedId
end


local function onTouchesHandler( eventType, x, y )
	if (eventType == "began") then
	    return true
    elseif (eventType == "moved") then
    	
    else
       
	end
end

-- 注册触摸事件
local function onNodeEvent(event)
	if (event == "enter") then
		_bgLayer:registerScriptTouchHandler(onTouchesHandler, false, _touchPriority, true)
		_bgLayer:setTouchEnabled(true)
	elseif (event == "exit") then
		_bgLayer:unregisterScriptTouchHandler()
	end
end

-- petid:要吞噬别的宠物的petId， 要被吞噬的宠物swallow_pet_id
function showLayer( petid,swallow_pet_id )
	init()
	_touchPriority= touchPriority or -500
	_zOrder = zOrder or 600

	_petId =petid
	_swallow_pet_id = swallow_pet_id
	_preSwallow_id = swallow_pet_id
	print( "swallow_pet_id is in showLayer ", swallow_pet_id)

	_bgLayer = CCLayer:create()
	_bgLayer:registerScriptHandler(onNodeEvent)
   	local scene = CCDirector:sharedDirector():getRunningScene()
    scene:addChild(_bgLayer,_zOrder,2013)

	local bg = CCSprite:create("images/main/module_bg.png")
	bg:setScale(g_fBgScaleRatio)
	_bgLayer:addChild(bg)

	require "script/ui/main/BulletinLayer"
	require "script/ui/main/MainScene"
	require "script/ui/main/MenuLayer"
	local bulletinLayerSize = BulletinLayer.getLayerContentSize()
	
	MainScene.getAvatarLayerObj():setVisible(false)
	MenuLayer.getObject():setVisible(false)
	BulletinLayer.getLayer():setVisible(true)

	_layerSize = {width= 0, height=0}
	_layerSize.width= g_winSize.width 
	_layerSize.height =g_winSize.height - (bulletinLayerSize.height)*g_fScaleX

	createTitleLayer()
	createBottomSprite()
	createTableView()

	-- return _bgLayer
	
end


-----------------------------------------------[[ 按钮的回调事件]]-----------------------------------------------------

-- 关闭按钮的回调函数
function closeAction(tag , item)

	_bgLayer:removeFromParentAndCleanup(true)
	_bgLayer=nil

	require "script/ui/pet/PetMainLayer"
	PetMainLayer.rfcAftSelect( _preSwallow_id)
	-- require "script/ui/pet/PetMainLayer"
 --    local layer = PetMainLayer.createLayer(_pos)
 --    MainScene.changeLayer(layer,"PetMainLayer")
end

-- 确定按钮的回调函数
function sureBtnAction( tag, item)

	_bgLayer:removeFromParentAndCleanup(true)
	_bgLayer=nil

	require "script/ui/pet/PetMainLayer"
	print("_swallow_pet_id is : ,  ", _swallow_pet_id)
	PetMainLayer.rfcAftSelect(_swallow_pet_id)
	
end















