-- Filename: ReplaceSkillLayer.lua
-- Author: zhangqiang
-- Date: 2014-08-04
-- Purpose: 主将更换技能主界面

module("ReplaceSkillLayer",package.seeall)

require "script/ui/replaceSkill/CreateUI"
require "script/model/user/UserModel"
require "script/ui/replaceSkill/AttributePanel"
require "script/ui/replaceSkill/ReplaceSkillData"
require "script/model/DataCache"

local kUINodeContentSize = CCSizeMake(640, g_winSize.height/g_fScaleX-BulletinLayer.getLayerHeight()
	                                  -MenuLayer.getLayerContentSize().height)
local kBottomNodeContentSize = CCSizeMake(610,198)
local kMainLayerTouchPriority = -349
local kMenuNodeTouchPriority = -350
local kProgressWidth = 450
local kSkillInfoSpriteBigSize = CCSizeMake(427,198)
local kSkillInfoSpriteSmallSize = CCSizeMake(213,198)
local kSkillInfoLeftPosition = ccp(15,15)	--锚点(0,0)
local kSkillInfoRightPosition = ccp(235,15)	--锚点(0,0)
local kSkillInfoScrollBigSize = CCSizeMake(310,187)
local kSkillInfoScrollSmallSize = CCSizeMake(208,187)
--local kSkillInfoScrollViewPosition = ccp(106,99)	--锚点(0.5,0.5)

--锚点(0.5,0)
local kLeftMasterPosition = ccp(-320, 280)
local kMidMasterPosition = ccp(320, 280)
local kRightMasterPosition = ccp(960,280)
-- local kMasterPositionTable = {
-- 	ccp(-320, 280), ccp(320, 280), ccp(960,280),
-- }

local _mainLayer = nil
local _mainLayerBg = nil
local _uiNode = nil
local _goldNumLabel = nil
local _bottomNode = nil
local _skillNotOpenBgSprite = nil
local _menuNode = nil
local _masterSprite = nil
local _leftMasterSprite = nil
local _rightMasterSprite = nil
local _masterNameLabel = nil
local _progressBar = nil
local _progressLevelLabel = nil
local _progressLabel = nil
local _maxProgressLabel = nil
local _skillIconSprite = nil
local _skillLevelLabel = nil
local _skillNameLabel = nil
local _rightArrowSprite = nil
local _attributePanelNode = nil
local _attributePanelStartPosition = nil
local _attributePanelEndPosition = nil
local _leftSkillInfoSprite = nil
local _rightSkillInfoSprite = nil
local _learnSkillMenuItem = nil
local _upgradeSkillMenuItem = nil
--------add by DJN  决定“更换装备”中的返回按钮返回到哪个界面的参数
local _jumpTag 
----------------------------------------------------------
--[[

--]]
function init( ... )
	_mainLayer = nil
	_mainLayerBg = nil
	_uiNode = nil
	_goldNumLabel = nil
	_bottomNode = nil
	_skillNotOpenBgSprite = nil
	_menuNode = nil
	_masterSprite = nil
	_leftMasterSprite = nil
	_rightMasterSprite = nil
	_masterNameLabel = nil
	_progressBar = nil
	_progressLevelLabel = nil
	_progressLabel = nil
	_maxProgressLabel = nil
	_skillIconSprite = nil
	_skillLevelLabel = nil
	_skillNameLabel = nil
	_rightArrowSprite = nil
	_attributePanelNode = nil
	_attributePanelStartPosition = nil
	_attributePanelEndPosition = nil
	_leftSkillInfoSprite = nil
	_rightSkillInfoSprite = nil
	_learnSkillMenuItem = nil
	_upgradeSkillMenuItem = nil
end

--[[

--]]
function createLayer( ... )
	_mainLayer = CCLayer:create()
	_mainLayer:registerScriptHandler(onNodeEvent)
	_mainLayer:setContentSize(g_winSize)

	_mainLayerBg = CCSprite:create("images/replaceskill/main_bg.jpg")
	_mainLayerBg:setScale(MainScene.bgScale)
	_mainLayerBg:setAnchorPoint(ccp(0.5,0))
	_mainLayerBg:setPosition(g_winSize.width/2,0)
	_mainLayer:addChild(_mainLayerBg)

	createMenuNode()
	createUINode()
end

--[[

--]]
function createMenuNode( ... )
	_menuNode = CCMenu:create()
	_menuNode:setScale(g_fScaleX)
	_menuNode:setContentSize(kUINodeContentSize)
	_menuNode:setTouchPriority(kMenuNodeTouchPriority)
	_menuNode:setAnchorPoint(ccp(0,0))
	_menuNode:setPosition(0,MenuLayer.getLayerContentSize().height*g_fScaleX)
	_mainLayer:addChild(_menuNode,1)

	--宗师录
	local masterRecordMenuItem = CCMenuItemImage:create("images/replaceskill/master_btn_n.png","images/replaceskill/master_btn_h.png")
	masterRecordMenuItem:setAnchorPoint(ccp(0.5,0.5))
	masterRecordMenuItem:setPosition(350, kUINodeContentSize.height-100)
	masterRecordMenuItem:registerScriptTapHandler(tapMasterRecordMenuItemCb)
	_menuNode:addChild(masterRecordMenuItem)

	--说明
	local infoMenuItem = CCMenuItemImage:create("images/recycle/btn/btn_explanation_h.png","images/recycle/btn/btn_explanation_n.png")
	infoMenuItem:setAnchorPoint(ccp(0.5,0.5))
	infoMenuItem:setPosition(475, kUINodeContentSize.height-102)
	infoMenuItem:registerScriptTapHandler(tapInfoMenuItemCb)
	_menuNode:addChild(infoMenuItem)

	--返回
	local goBackMenuItem = CCMenuItemImage:create("images/common/close_btn_n.png","images/common/close_btn_h.png")
	goBackMenuItem:setAnchorPoint(ccp(0.5,0.5))
	goBackMenuItem:setPosition(590, kUINodeContentSize.height-100)
	goBackMenuItem:registerScriptTapHandler(tapGoBackMenuItemCb)
	_menuNode:addChild(goBackMenuItem)

	--技能装备入口
	--added by Zhang Zihang
	local loardSkillMenuItem = CCMenuItemImage:create("images/replaceskill/loard_skill_n.png","images/replaceskill/loard_skill_h.png")
	loardSkillMenuItem:setAnchorPoint(ccp(0.5,0.5))
	loardSkillMenuItem:setPosition(225, kUINodeContentSize.height-100)
	loardSkillMenuItem:registerScriptTapHandler(tapLoardSkillCb)
	_menuNode:addChild(loardSkillMenuItem)

	--主角属性
	-- local attributeMenuItem = CCMenuItemImage:create("images/star/btn_show_n.png","images/star/btn_show_h.png")
	-- attributeMenuItem:setAnchorPoint(ccp(1,0.5))
	-- attributeMenuItem:setPosition(640, kUINodeContentSize.height-330)
	-- attributeMenuItem:registerScriptTapHandler(tapAttributeMenuItemCb)
	-- _menuNode:addChild(attributeMenuItem)
	local attributeMenuItem = CreateUI.createPushLeftMenuItem(GetLocalizeStringBy("zz_38"),22)
	attributeMenuItem:setAnchorPoint(ccp(1,0.5))
	attributeMenuItem:setPosition(640, kUINodeContentSize.height-330)
	attributeMenuItem:registerScriptTapHandler(tapAttributeMenuItemCb)
	_menuNode:addChild(attributeMenuItem,1)

	--武艺切磋
	local fightMenuItem = CCMenuItemImage:create("images/replaceskill/fight_btn_n.png", "images/replaceskill/fight_btn_h.png")
	fightMenuItem:setAnchorPoint(ccp(0.5,0.5))
	fightMenuItem:setPosition(75,305)
	fightMenuItem:registerScriptTapHandler(tapFightMenuItemCb)
	_menuNode:addChild(fightMenuItem)

	--铜雀翻牌
	local flipCardMenuItem = CCMenuItemImage:create("images/replaceskill/flip_btn_n.png", "images/replaceskill/flip_btn_h.png")
	flipCardMenuItem:setAnchorPoint(ccp(0.5,0.5))
	flipCardMenuItem:setPosition(557,305)
	flipCardMenuItem:registerScriptTapHandler(tapFlipCardMenuItemCb)
	_menuNode:addChild(flipCardMenuItem)
end

--[[

--]]
function createMidMasterSprite(p_masterTid)
	local masterSprite = nil
	if p_masterTid == nil then
		masterSprite = CCSprite:create()
	else
		masterSprite = StarSprite.createStarSprite(tonumber(p_masterTid))
	end
	masterSprite:setAnchorPoint(ccp(0.5,0))
	masterSprite:setPosition(kMidMasterPosition)
	_uiNode:addChild(masterSprite)
	return masterSprite
end

--[[

--]]
function createLeftMasterSprite(p_masterTid)
	local masterSprite = nil
	if p_masterTid == nil then
		masterSprite = CCSprite:create()
	else
		masterSprite = StarSprite.createStarSprite(tonumber(p_masterTid))
	end
	masterSprite:setAnchorPoint(ccp(0.5,0))
	masterSprite:setPosition(kLeftMasterPosition)
	_uiNode:addChild(masterSprite)
	return masterSprite
end

--[[

--]]
function createRightMasterSprite(p_masterTid)
	local masterSprite = nil
	if p_masterTid == nil then
		masterSprite = CCSprite:create()
	else
		masterSprite = StarSprite.createStarSprite(tonumber(p_masterTid))
	end
	masterSprite:setAnchorPoint(ccp(0.5,0))
	masterSprite:setPosition(kRightMasterPosition)
	_uiNode:addChild(masterSprite)
	return masterSprite
end

--[[

--]]
function createUINode( ... )
	_uiNode = CCNode:create()
	_uiNode:setScale(g_fScaleX)
	_uiNode:setContentSize(kUINodeContentSize)
	_uiNode:setAnchorPoint(ccp(0,0))
	_uiNode:setPosition(0,MenuLayer.getLayerContentSize().height*g_fScaleX)
	_mainLayer:addChild(_uiNode)

	--属性栏
	local attributeSpriteTable = CreateUI.createAttributeBarFourSprite()
	local attributeBar = attributeSpriteTable.parent
	attributeBar:setAnchorPoint(ccp(0.5,1))
	attributeBar:setPosition(kUINodeContentSize.width/2,kUINodeContentSize.height)
	_uiNode:addChild(attributeBar, 1)

	--金币
	_goldNumLabel = attributeSpriteTable.children[3]

	--中间的宗师形象
	_masterSprite = createMidMasterSprite()

	_leftMasterSprite = createLeftMasterSprite()

	_rightMasterSprite = createRightMasterSprite()

	--宗师名字背景
	-- local masterNameBg = CCScale9Sprite:create("images/boss/namebg.png.png")
	-- masterNameBg:setPreferredSize(CCSizeMake(273,40))
	local masterNameBg = CCSprite:create("images/star/intimate/namebg.png")
	masterNameBg:setAnchorPoint(ccp(0.5,0))
	masterNameBg:setPosition(kUINodeContentSize.width/2, 266)
	_uiNode:addChild(masterNameBg,1)

	--修行等级
	_progressLevelLabel = CCRenderLabel:create("LV.1", g_sFontPangWa, 18, 1, ccc3(0x00,0x00,0x00), type_shadow)
	_progressLevelLabel:setColor(ccc3(0xff,0xf6,0x00))
	_progressLevelLabel:setAnchorPoint(ccp(1,0.5))
	_progressLevelLabel:setPosition(100,20)
	masterNameBg:addChild(_progressLevelLabel,1)

	--修行图标
	local feelSprite = CCSprite:create("images/replaceskill/awaken_icon.png")
	feelSprite:setAnchorPoint(ccp(0,0.5))
	feelSprite:setPosition(100,20)
	masterNameBg:addChild(feelSprite)

	--宗师名字
	_masterNameLabel = CCRenderLabel:create("巴别时代", g_sFontPangWa, 21, 1, ccc3(0x00,0x00,0x00), type_shadow)
	_masterNameLabel:setColor(ccc3(0xe4,0x00,0xff))
	_masterNameLabel:setAnchorPoint(ccp(0.5,0.5))
	_masterNameLabel:setPosition(170,20)
	masterNameBg:addChild(_masterNameLabel,1)

	--经验条
	local progressBarBg = CCScale9Sprite:create("images/common/exp_bg.png")
	progressBarBg:setPreferredSize(CCSizeMake(kProgressWidth,23))
	progressBarBg:setAnchorPoint(ccp(0.5,0.5))
	progressBarBg:setPosition(320, 232)
	_uiNode:addChild(progressBarBg)

	local fullRect = CCRectMake(0,0,46,23)
	local insetRect = CCRectMake(10,10,26,3)
	_progressBar = CCScale9Sprite:create("images/common/exp_progress.png", fullRect, insetRect)
	_progressBar:setPreferredSize(CCSizeMake(kProgressWidth,23))
	_progressBar:setAnchorPoint(ccp(0,0.5))
	_progressBar:setPosition(1,11)
	_progressBar:setContentSize(CCSizeMake(1000/3000*kProgressWidth,23))
	progressBarBg:addChild(_progressBar)

	--经验值
	_progressLabel = CCRenderLabel:create("1000/", g_sFontName, 18, 1, ccc3(0x00,0x00,0x00), type_shadow)
	_progressLabel:setColor(ccc3(0xff,0xff,0xff))
	_progressLabel:setAnchorPoint(ccp(1,0.5))
	_progressLabel:setPosition(225,12)
	progressBarBg:addChild(_progressLabel,1)

	_maxProgressLabel = CCRenderLabel:create("3000", g_sFontName, 18, 1, ccc3(0x00,0x00,0x00), type_shadow)
	_maxProgressLabel:setColor(ccc3(0xff,0xff,0xff))
	_maxProgressLabel:setAnchorPoint(ccp(0,0.5))
	_maxProgressLabel:setPosition(225,12)
	progressBarBg:addChild(_maxProgressLabel,1)

	--分隔线
	local separatorSprite = CCSprite:create("images/common/separator_bottom.png")
	separatorSprite:setAnchorPoint(ccp(0.5,0.5))
	separatorSprite:setPosition(320,260)
	_uiNode:addChild(separatorSprite)

	--宗师未开放技能底部显示的界面
	_skillNotOpenBgSprite = CCScale9Sprite:create("images/star/intimate/bottom9s.png")
	_skillNotOpenBgSprite:setPreferredSize(kBottomNodeContentSize)
	_skillNotOpenBgSprite:setAnchorPoint(ccp(0,0))
	_skillNotOpenBgSprite:setPosition(kSkillInfoLeftPosition)
	_uiNode:addChild(_skillNotOpenBgSprite)

	local tipLabel = CCRenderLabel:create(GetLocalizeStringBy("zz_50"), g_sFontPangWa, 25, 1, ccc3(0x00,0x00,0x00), type_shadow)
	tipLabel:setColor(ccc3(0xff,0xff,0xff))
	tipLabel:setAnchorPoint(ccp(0.5,0.5))
	tipLabel:setPosition(kBottomNodeContentSize.width/2,kBottomNodeContentSize.height/2)
	_skillNotOpenBgSprite:addChild(tipLabel)

	createBottomUI()

	-- refreshMasterSprite()
	-- refreshMasterName()
	-- refreshProgressBar()
	-- refreshBottomUI()
	refreshAllUI()
end

--[[

--]]
function createBottomUI( ... )
	_bottomNode = CCNode:create()
	_bottomNode:setContentSize(kBottomNodeContentSize)
	_bottomNode:setAnchorPoint(ccp(0,0))
	_bottomNode:setPosition(0,0)
	_uiNode:addChild(_bottomNode)

	--怒气技能图标
	_skillIconSprite = CCSprite:create("images/common/border.png")
	_skillIconSprite:setAnchorPoint(ccp(0.5,0.5))
	_skillIconSprite:setPosition(540,165)
	_bottomNode:addChild(_skillIconSprite)

	--怒气技能名字
	_skillNameLabel = CCRenderLabel:create("怒气技能", g_sFontPangWa, 18, 1, ccc3(0x00,0x00,0x00), type_shadow)
	_skillNameLabel:setColor(ccc3(0xff,0x00,0xe4))
	_skillNameLabel:setAnchorPoint(ccp(0.5,0.5))
	_skillNameLabel:setPosition(538,111)
	_bottomNode:addChild(_skillNameLabel)

	--LV图标
	local lvSprite = CCSprite:create("images/boss/LV.png")
	lvSprite:setAnchorPoint(ccp(1,0))
	lvSprite:setPosition(538,79)
	lvSprite:setScale(0.8)
	_bottomNode:addChild(lvSprite)

	--怒气技能等级
	_skillLevelLabel = CCRenderLabel:create("90", g_sFontPangWa, 18, 1, ccc3(0x00,0x00,0x00), type_shadow)
	_skillLevelLabel:setColor(ccc3(0xff,0xf6,0x00))
	_skillLevelLabel:setAnchorPoint(ccp(0,0))
	_skillLevelLabel:setPosition(538,77)
	_bottomNode:addChild(_skillLevelLabel)

	local menu = CCMenu:create()
	menu:setPosition(0,0)
	_bottomNode:addChild(menu)
	--学习技能
	_learnSkillMenuItem = LuaCC.create9ScaleMenuItem("images/common/btn/btn1_d.png", "images/common/btn/btn1_n.png",
		                                                  CCSizeMake(180,73), GetLocalizeStringBy("zz_48"), ccc3(255,222,0))
	_learnSkillMenuItem:setAnchorPoint(ccp(0.5,0.5))
	_learnSkillMenuItem:setPosition(538,45)
	_learnSkillMenuItem:registerScriptTapHandler(tapLearnSkillMenuItemCb)
	menu:addChild(_learnSkillMenuItem)

	--技能提升
	_upgradeSkillMenuItem = LuaCC.create9ScaleMenuItem("images/common/btn/btn1_d.png", "images/common/btn/btn1_n.png",
		                                                  CCSizeMake(180,73), GetLocalizeStringBy("zz_18"), ccc3(255,222,0))
	_upgradeSkillMenuItem:setAnchorPoint(ccp(0.5,0.5))
	_upgradeSkillMenuItem:setPosition(538,45)
	_upgradeSkillMenuItem:registerScriptTapHandler(tapUpgradeSkillMenuItemCb)
	menu:addChild(_upgradeSkillMenuItem)

	--绿色右箭头
	_rightArrowSprite = CCSprite:create("images/item/equipinfo/reinforce/arrow.png")
	_rightArrowSprite:setScale(1.5)
	_rightArrowSprite:setAnchorPoint(ccp(0.5,0.5))
	_rightArrowSprite:setPosition(227,115)
	_bottomNode:addChild(_rightArrowSprite,1)

	-- --创建技能信息描述面板
	-- local skillInfoTable = {
	-- 	name = "雄狮怒吼",
	-- 	level = 10,
	-- 	desc = "对敌方横排造成80%－100%攻击伤害并降低2点怒气",
	-- 	titleId = 0,
	-- }
	-- _leftSkillInfoSprite = createSkillInfoSprite(skillInfoTable)
	-- _leftSkillInfoSprite:setAnchorPoint(ccp(0,0))
	-- _leftSkillInfoSprite:setPosition(15,15)
	-- _bottomNode:addChild(_leftSkillInfoSprite)
	-- _leftSkillInfoSprite:setContentSize(CCSizeMake(213,198))
	-- _leftSkillInfoSprite:getChildByTag(1):setPosition(106,99)

	-- _rightSkillInfoSprite = createSkillInfoSprite(skillInfoTable)
	-- _rightSkillInfoSprite:setAnchorPoint(ccp(0,0))
	-- _rightSkillInfoSprite:setPosition(235,15)
	-- _bottomNode:addChild(_rightSkillInfoSprite)
	-- _rightSkillInfoSprite:setContentSize(CCSizeMake(213,198))
	-- _rightSkillInfoSprite:getChildByTag(1):setPosition(106,99)
end

--[[

--]]
function createSkillInfoSprite( p_skillLevel, p_titleStr, p_bottomTipStr)
	p_skillLevel = tonumber(p_skillLevel)
	local skillInfo = nil
	local infoBgContentSize = nil
	local infoScrollContentSize = nil
	local wordSize = 18
	local feelIconPositionX = nil
	if p_skillLevel == 0 then
		--还未学习技能
		skillInfo = ReplaceSkillData.getSkillInfoByLevel(1)
		wordSize = 25
		infoBgContentSize = kSkillInfoSpriteBigSize
		infoScrollContentSize = kSkillInfoScrollBigSize
		feelIconPositionX = 215
	elseif p_skillLevel > ReplaceSkillData.getCurSkillMaxLevel() then
		--技能超出最大等级
		infoBgContentSize = kSkillInfoSpriteSmallSize
	else
		--学习技能后
		skillInfo = ReplaceSkillData.getSkillInfoByLevel(p_skillLevel)
		wordSize = 18
		infoBgContentSize = kSkillInfoSpriteSmallSize
		infoScrollContentSize = kSkillInfoScrollSmallSize
		feelIconPositionX = 165
	end

	local infoBgSprite = CCScale9Sprite:create("images/star/intimate/bottom9s.png")
	infoBgSprite:setPreferredSize(infoBgContentSize)

	if p_skillLevel > ReplaceSkillData.getCurSkillMaxLevel() then
		local tipStr = GetLocalizeStringBy("zz_53")
		--local tipLabel = CCRenderLabel:create(tipStr, g_sFontPangWa, 25, 1, ccc3(0x00,0x00,0x00), type_shadow)
		local tipLabel = CCLabelTTF:create(tipStr, g_sFontPangWa, 25)
		tipLabel:setHorizontalAlignment(kCCTextAlignmentLeft)
		tipLabel:setColor(ccc3(0xff,0xe4,0x00))
		tipLabel:setAnchorPoint(ccp(0.5,0.5))
		tipLabel:setPosition(infoBgContentSize.width/2,infoBgContentSize.height/2)
		infoBgSprite:addChild(tipLabel)
		return infoBgSprite
	end

	local scrollView = CCScrollView:create()
	scrollView:setContentSize(infoScrollContentSize)
	scrollView:setViewSize(infoScrollContentSize)
	scrollView:setBounceable(true)
	scrollView:setDirection(kCCScrollViewDirectionVertical)
	scrollView:ignoreAnchorPointForPosition(false)
	scrollView:setAnchorPoint(ccp(0.5,0.5))
	scrollView:setPosition(infoBgContentSize.width/2, infoBgContentSize.height/2)
	infoBgSprite:addChild(scrollView,1,1)

	local container = CCLayer:create()
	scrollView:setContainer(container)
	local containerContentSize = CCSizeMake(infoScrollContentSize.width,0)
	container:setContentSize(containerContentSize)

	--技能描述和技能名称
	local tempStringTable = {
		[1] = nil,
		[2] = {width=infoScrollContentSize.width},
		[3] = {width=infoScrollContentSize.width, {content="[".. skillInfo.skillName .."]", ntype="label",
		                                           fontSize=wordSize, color=ccc3(0xff,0xe4,0x00)}},
	}
	local tempStringColorTable = {ccc3(0xff,0xff,0xff), ccc3(0xff,0xff,0xff), ccc3(0xff,0xff,0xff)}
	if p_bottomTipStr ~= nil then
		tempStringTable[1] = {width=infoScrollContentSize.width, {content=p_bottomTipStr, ntype="label",
		                      fontSize=wordSize, color=ccc3(0xff,0x00,0x00)}}
		tempStringColorTable[2] = ccc3(0x00,0xff,0x00)
	end
	tempStringTable[2][1] = {content=skillInfo.skillDesc[1], ntype="label", fontSize=wordSize, color=tempStringColorTable[1] }
	tempStringTable[2][2] = {content=skillInfo.skillDesc[2], ntype="label", fontSize=wordSize, color=tempStringColorTable[2] }
	tempStringTable[2][3] = {content=skillInfo.skillDesc[3], ntype="label", fontSize=wordSize, color=tempStringColorTable[3] }
	for i = 1,3 do
		print("createSkillInfoSprite",i,tempStringTable[i], p_bottomTipStr)
		if tempStringTable[i] ~= nil then
			local label = LuaCCLabel.createRichText(tempStringTable[i])
			local labelContentSize = label:getContentSize()
			containerContentSize.height = containerContentSize.height + labelContentSize.height
			--label:setAnchorPoint(ccp(0,0)) --设置无效，锚点始终为(0,1)
			label:setPosition(0,containerContentSize.height)
			container:addChild(label)

			if i == 1 then
				local feelSprite = CCSprite:create("images/replaceskill/awaken_icon.png")
				feelSprite:setAnchorPoint(ccp(0,0))
				feelSprite:setPosition(feelIconPositionX,containerContentSize.height-wordSize-3)
				container:addChild(feelSprite)
			end

			containerContentSize.height = containerContentSize.height + 5
		end
	end

	if p_skillLevel ~= 0 then
		--黄色横线
		containerContentSize.height = containerContentSize.height+2
		local lineSprite = CCSprite:create("images/replaceskill/horizontal_line.png")
		lineSprite:setAnchorPoint(ccp(0.5,0))
		lineSprite:setPosition(container:getContentSize().width/2, containerContentSize.height)
		container:addChild(lineSprite)

		--LV图标
		local lvSprite = CCSprite:create("images/boss/LV.png")
		lvSprite:setAnchorPoint(ccp(1,0.5))
		lvSprite:setPosition(140,19)
		lvSprite:setScale(0.7)
		lineSprite:addChild(lvSprite)

		local tempHeadStringTable = {p_titleStr, tostring(skillInfo.skillLevel)}
		print("refreshBottomUI", titleStr, tostring(skillInfo.skillLevel))
		local tempHeadLabelPosition = {ccp(22,19),ccp(140,19)}
		for i = 1,2 do
			local label = CCRenderLabel:create(tempHeadStringTable[i], g_sFontPangWa, wordSize, 1, ccc3(0x00,0x00,0x00), type_shadow)
			label:setColor(ccc3(0xff,0xe4,0x00))
			label:setAnchorPoint(ccp(0,0.5))
			label:setPosition(tempHeadLabelPosition[i])
			lineSprite:addChild(label)
		end

		containerContentSize.height = containerContentSize.height + lineSprite:getContentSize().height+8
	end

	container:setContentSize(containerContentSize)
	container:setPosition(0,scrollView:getViewSize().height-containerContentSize.height)

	return infoBgSprite
end

--[[

--]]
function refreshGoldNum( ... )
	_goldNumLabel:setString(tostring(UserModel.getGoldNumber()))
end

--[[

--]]
function refreshMasterSprite( ... )
	local curMasterInfo = ReplaceSkillData.getCurMasterInfo()
	if curMasterInfo == nil then return end

	-- local masterSprite = CCSprite:create("images/base/hero/body_img/quan_jiang_zhoutai.png")
	-- _masterSprite:setDisplayFrame(masterSprite:displayFrame())
	local masterSprite = StarSprite.createStarSprite( curMasterInfo.star_tid )
	_masterSprite:setDisplayFrame(masterSprite:displayFrame())
end

--[[

--]]
function refreshLeftMasterSprite()
	local leftMasterInfo = ReplaceSkillData.getLeftMasterInfo()
	if leftMasterInfo == nil then return end

	local masterSprite = StarSprite.createStarSprite( leftMasterInfo.star_tid )
	_leftMasterSprite:setDisplayFrame(masterSprite:displayFrame())
end

--[[

--]]
function refreshRightMasterSprite( ... )
	local rightMasterInfo = ReplaceSkillData.getRightMasterInfo()
	if rightMasterInfo == nil then return end

	local masterSprite = StarSprite.createStarSprite( rightMasterInfo.star_tid )
	_rightMasterSprite:setDisplayFrame(masterSprite:displayFrame())
end

--[[

--]]
function refreshMasterName( ... )
	local curMasterInfo = ReplaceSkillData.getCurMasterInfo()
	local masterNameColor = HeroPublicLua.getCCColorByStarLevel(curMasterInfo.starTemplate.quality)
	_masterNameLabel:setString(curMasterInfo.starTemplate.name)
	_masterNameLabel:setColor(masterNameColor)
end

--[[
	@desc :	刷新修行等级、经验条、多余修行值和下一等级还需经验值的显示
--]]
function refreshProgressBar( ... )
	if _progressBar == nil then
		return
	end

	local curMasterInfo = ReplaceSkillData.getCurMasterInfo()
	_progressLevelLabel:setString("LV." .. curMasterInfo.feel_level)
	print("refreshProgressBar..",curMasterInfo.feel_level,ReplaceSkillData.getMaxConfigFeelLevel())
	if tonumber(curMasterInfo.feel_level) == ReplaceSkillData.getMaxConfigFeelLevel() then
		_progressBar:setVisible(false)
		_maxProgressLabel:setString("Max Level")
		_maxProgressLabel:setPosition(185,12)
		_progressLabel:setVisible(false)
		return
	end

	local rightValue = ReplaceSkillData.getRightFeelValue()
	local leftValue = ReplaceSkillData.getLeftFeelValue()
	print("refreshProgressBar", leftValue, rightValue)
	_maxProgressLabel:setPosition(225,12)
	_maxProgressLabel:setString(tostring(rightValue))
	_progressLabel:setVisible(true)
	_progressLabel:setString(leftValue .. "/")
	_progressBar:setVisible(true)
	_progressBar:setContentSize(CCSizeMake(leftValue/rightValue*kProgressWidth,23))
end

--[[
	desc :	根据技能id创建技能图标
--]]
require "db/skill"
function createSkillIcon(p_skillId)
	p_skillId = tonumber(p_skillId)
	local skillIconBg = CCSprite:create("images/item/bg/itembg_4.png")
	local skillIconSize = skillIconBg:getContentSize()

	local skillTemplate = skill.getDataById(tonumber(p_skillId))
	print("createSkillIcon",p_skillId)
	local skillIconSprite = CCSprite:create("images/replaceskill/skillicon/" .. skillTemplate.roleSkillPic)
	skillIconSprite:setAnchorPoint(ccp(0.5,0.5))
	skillIconSprite:setPosition(skillIconSize.width/2, skillIconSize.height/2)
	skillIconBg:addChild(skillIconSprite)

	return skillIconBg
end

--[[

--]]
function refreshSkillIconById( p_skillId )
	if _skillIconSprite ~= nil then
		_skillIconSprite:removeFromParentAndCleanup(true)
		_skillIconSprite = nil
	end

	local skillInfo = ReplaceSkillData.getSkillInfoById(tonumber(p_skillId))

	_skillIconSprite = createSkillIcon(skillInfo.skillId)
	_skillIconSprite:setAnchorPoint(ccp(0.5,0.5))
	_skillIconSprite:setPosition(540,165)
	_bottomNode:addChild(_skillIconSprite)

	_skillNameLabel:setString(skillInfo.skillName)

	_skillLevelLabel:setString(skillInfo.skillLevel)
end

--[[
	@desc :	刷新技能按钮(学习技能和提升技能按钮间的转换)
--]]
function refreshSkillMenuItem()
	local curMasterInfo = ReplaceSkillData.getCurMasterInfo()
	if tonumber(curMasterInfo.feel_skill) == 0 then
		_learnSkillMenuItem:setVisible(true)
		_upgradeSkillMenuItem:setVisible(false)
	else
		_learnSkillMenuItem:setVisible(false)
		_upgradeSkillMenuItem:setVisible(true)
	end
end

--[[
	@desc :	刷新绿色右箭头
--]]
function refreshRightArrow( ... )
	local curMasterInfo = ReplaceSkillData.getCurMasterInfo()
	if tonumber(curMasterInfo.feel_skill) ~= 0 then
		_rightArrowSprite:setVisible(true)
	else
		_rightArrowSprite:setVisible(false)
	end
end

--[[
	@desc :	宗师未开放时底部的UI显示
--]]
function refreshBottomUI( ... )
	if _leftSkillInfoSprite ~= nil then
		_leftSkillInfoSprite:removeFromParentAndCleanup(true)
		_leftSkillInfoSprite = nil
	end

	if _rightSkillInfoSprite ~= nil then
		_rightSkillInfoSprite:removeFromParentAndCleanup(true)
		_rightSkillInfoSprite = nil
	end

	local curMasterInfo = ReplaceSkillData.getCurMasterInfo()
	--宗师怒气技能未开放
	if curMasterInfo.starTemplate.skillArr == nil then
		_bottomNode:setVisible(false)
		_skillNotOpenBgSprite:setVisible(true)
		return
	end

	--宗师怒气技能学习开放
	_bottomNode:setVisible(true)
	_skillNotOpenBgSprite:setVisible(false)
	refreshRightArrow()
	refreshSkillMenuItem()
	--还未学习技能
	if tonumber(curMasterInfo.feel_skill) == 0 then
		local skillInfo = ReplaceSkillData.getSkillInfoByLevel(1)
		_leftSkillInfoSprite = createSkillInfoSprite(0, nil, GetLocalizeStringBy("zz_49", skillInfo.needFeelLevel))
		_leftSkillInfoSprite:setAnchorPoint(ccp(0,0))
		_leftSkillInfoSprite:setPosition(kSkillInfoLeftPosition)
		_bottomNode:addChild(_leftSkillInfoSprite)

		-- refreshRightArrow()
		refreshSkillIconById(skillInfo.skillId)
		-- refreshSkillMenuItem()
		return
	end

	--已学习技能
	local curSkillInfo = ReplaceSkillData.getSkillInfoById(curMasterInfo.feel_skill)
	local skillLevelTable = {curSkillInfo.skillLevel, curSkillInfo.skillLevel + 1}
	local skillInfoPosition = {kSkillInfoLeftPosition, kSkillInfoRightPosition}
	local skillTitleTable = {GetLocalizeStringBy("zz_44"), GetLocalizeStringBy("zz_45")}
	local skillBottomTipTable = nil
	if curSkillInfo.skillLevel == ReplaceSkillData.getCurSkillMaxLevel() then
		skillBottomTipTable = { }
	else
		local nextSkillInfo = ReplaceSkillData.getSkillInfoByLevel(curSkillInfo.skillLevel + 1)
		skillBottomTipTable = {[1] = nil, [2] = GetLocalizeStringBy("zz_49", nextSkillInfo.needFeelLevel)} 
	end
	print("refreshBottomUI..")
	print_t(skillTitleTable)
	for i = 1,2 do
		local skillInfoSprite = createSkillInfoSprite(skillLevelTable[i], skillTitleTable[i], skillBottomTipTable[i])
		skillInfoSprite:setPosition(skillInfoPosition[i])
		_bottomNode:addChild(skillInfoSprite)

		if i == 1 then
			_leftSkillInfoSprite = skillInfoSprite
		else
			_rightSkillInfoSprite = skillInfoSprite
		end
	end

	-- refreshRightArrow()
	refreshSkillIconById(curSkillInfo.skillId)
	-- refreshSkillMenuItem()
end

--[[

--]]
function refreshAllUI( ... )
	refreshMasterSprite()
	refreshMasterName()
	refreshProgressBar()
	refreshBottomUI()
	refreshLeftMasterSprite()
	refreshRightMasterSprite()
end

--[[

--]]
function showLayer( ... )
	--ReplaceSkillData.setAllInfo(DataCache.getStarInfoFromCache())
	--ReplaceSkillData.setCurMasterInfo(9702)
	--ReplaceSkillData.setCurMasterInfo(9707)
	-- if ReplaceSkillData.getCurMasterInfo() == nil then
	-- 	ReplaceSkillData.setCurMasterInfo(ReplaceSkillData.getDefaultMasterId())
	-- end
	ReplaceSkillData.init()
	
	init()
	createLayer()
	print("dddddddd")
	print_t(ReplaceSkillData._attrPanelDataSrc)

	require "script/ui/main/MainScene"
	MainScene.changeLayer(_mainLayer,"ReplaceSkillInfoLayer")
	MainScene.setMainSceneViewsVisible(true,false,true)
end

---------------------------------------------------------[[ 回调函数 ]]----------------------------------------------
--[[

--]]
function onNodeEvent( p_eventType )
	if p_eventType == "enter" then
		print("主将更换技能 主界面 创建")
		_mainLayer:registerScriptTouchHandler(touchMainLayerCb,false,kMainLayerTouchPriority,true)
		_mainLayer:setTouchEnabled(true)
	elseif p_eventType == "exit" then
		print("主将更换技能 主界面 退出")
		_mainLayer:unregisterScriptTouchHandler()
	else

	end
end

--[[
	desc :	将某个节点移动到点(x,y)
--]]
function moveNodeBy(p_node, p_deltaX, p_deltaY )
	local curPositionX = p_node:getPositionX()
	local curPositionY = p_node:getPositionY()
	-- if type(curPosition) == "number" then
	-- 	print("curPositionttt",curPosition)
	-- else
	-- 	print("curPosition",curPosition.x,curPosition.y)
	-- end
	local nextPositionX = curPositionX + p_deltaX
	local nextPositionY = curPositionY + p_deltaY
	p_node:setPosition(nextPositionX,nextPositionY)
end

--[[

--]]
function moveRightAction( ... )
	local leftMasterInfo = ReplaceSkillData.getLeftMasterInfo()
	print("moveRightAction")
	print_t(leftMasterInfo)
	if leftMasterInfo == nil then
		moveBackAction()
		return
	end

	_leftMasterSprite:runAction(CCMoveTo:create(0.2,kMidMasterPosition))
	local moveRightEndCb = function ()
		_rightMasterSprite:removeFromParentAndCleanup(true)
		_masterSprite, _rightMasterSprite = _leftMasterSprite, _masterSprite
		_leftMasterSprite = createLeftMasterSprite()
		ReplaceSkillData.setCurMasterInfo(leftMasterInfo.star_id)
		refreshAllUI()
	end
	_masterSprite:runAction(CCSequence:createWithTwoActions(
		                    CCMoveTo:create(0.2,kRightMasterPosition),
		                    CCCallFunc:create(moveRightEndCb)
		                    ))
end

--[[

--]]
function moveLeftAction( ... )
	local rightMasterInfo = ReplaceSkillData.getRightMasterInfo()
	print("moveLeftAction")
	print_t(rightMasterInfo)
	if rightMasterInfo == nil then
		moveBackAction()
		return
	end

	_rightMasterSprite:runAction(CCMoveTo:create(0.2, kMidMasterPosition))
	local moveLeftEndCb = function ()
		_leftMasterSprite:removeFromParentAndCleanup(true)
		_leftMasterSprite, _masterSprite = _masterSprite, _rightMasterSprite
		_rightMasterSprite = createRightMasterSprite()
		ReplaceSkillData.setCurMasterInfo(rightMasterInfo.star_id)
		refreshAllUI()
	end
	_masterSprite:runAction(CCSequence:createWithTwoActions(
		                   CCMoveTo:create(0.2, kLeftMasterPosition),
		                   CCCallFunc:create(moveLeftEndCb)
		                   ))
end

--[[

--]]
function moveBackAction( ... )
	_leftMasterSprite:runAction(CCMoveTo:create(0.2, kLeftMasterPosition))
	_masterSprite:runAction(CCMoveTo:create(0.2, kMidMasterPosition))
	_rightMasterSprite:runAction(CCMoveTo:create(0.2, kRightMasterPosition))
end

--[[
	desc :	滑动切换宗师处理
--]]
local _beginPoint = nil
local _lastMovedPoint = nil
function touchMainLayerCb( p_eventType, p_touchX, p_touchY )
	if p_eventType == "began" then
		_beginPoint = ccp(p_touchX, p_touchY)
		_lastMovedPoint = ccp(p_touchX, p_touchY)
		local masterContentSize = _masterSprite:getContentSize()
		local masterBeginPoint = _masterSprite:convertToNodeSpace(_beginPoint)
		print("masterBeginPoint")
		if masterBeginPoint.x >= 0 and masterBeginPoint.x <= masterContentSize.width and
		   masterBeginPoint.y >= 0 and masterBeginPoint.y <= masterContentSize.height then
		    return true
		end
	elseif p_eventType == "moved" then
		print("主角更换技能 主界面 moved")
		local deltaX = p_touchX - _lastMovedPoint.x
		local deltaY = p_touchY - _lastMovedPoint.y

		moveNodeBy(_leftMasterSprite, deltaX, 0)
		moveNodeBy(_rightMasterSprite, deltaX, 0)
		moveNodeBy(_masterSprite, deltaX, 0)

		_lastMovedPoint = ccp(p_touchX, p_touchY)
	elseif p_eventType== "cancelled" then
		print("主角更换技能 主界面 cancelled")
	else
		print("主角更换技能 主界面 ended")
		local deltaX = p_touchX - _beginPoint.x
		local deltaY = p_touchY - _beginPoint.y
		local thresoldValue = 200
		if deltaX > thresoldValue then
			moveRightAction()
		elseif deltaX < -thresoldValue then
			moveLeftAction()
		else
			moveBackAction()
		end
	end
end

--[[

--]]
require "script/ui/replaceSkill/MasterRecord/MasterRecordLayer"
function tapMasterRecordMenuItemCb( p_itemTag, p_item )
	MasterRecordLayer.show()
end

--[[

--]]
require "script/ui/replaceSkill/TrainIntroductionLayer"
function tapInfoMenuItemCb( p_itemTag, p_item )
	TrainIntroductionLayer.showLayer()
end

--[[

--]]
function tapGoBackMenuItemCb( p_itemTag, p_item )
	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/guanbi.mp3")
	-- require "script/ui/main/MainBaseLayer"
	-- local main_base_layer = MainBaseLayer.create()
	-- MainScene.changeLayer(main_base_layer, "main_base_layer", nil)
	-- MainScene.setMainSceneViewsVisible(true,true,true)
	require "script/ui/star/StarLayer"
	local starLayer = StarLayer.createLayer()
	MainScene.changeLayer(starLayer, "starLayer")
end

--[[

--]]
function tapAttributeMenuItemCb( p_itemTag, p_item )
	local itemContentSize = p_item:getContentSize()

	local tapCloseBtnCb = function ()
		_attributePanelNode:runAction(CCMoveTo:create(0.3,_attributePanelStartPosition))
		p_item:setEnabled(true)
		--防止下次快速点击属性按钮时将收起按钮点到引起位置偏移
		AttributePanel.setCloseBtnEnabled(false)
	end

	if _attributePanelNode == nil then
		_attributePanelNode = AttributePanel.createPanel(tapCloseBtnCb)
		_attributePanelStartPosition = ccp(_attributePanelNode:getContentSize().width+itemContentSize.width,
			                               itemContentSize.height/2)
		_attributePanelEndPosition = ccp(itemContentSize.width, itemContentSize.height/2)
		_attributePanelNode:setAnchorPoint(ccp(1,0.5))
		_attributePanelNode:setPosition(_attributePanelStartPosition)
		p_item:addChild(_attributePanelNode)
	end
	print("tapAttributeMenuItemCb",ReplaceSkillData.isCurMasterAttrData())
	if not ReplaceSkillData.isCurMasterAttrData() then
		print("tapAttributeMenuItemCb.....")
		AttributePanel.refreshTableView()
	end

	local showSeq = CCSequence:createWithTwoActions(CCMoveTo:create(0.3,_attributePanelEndPosition),
						                            CCCallFunc:create(function ()
																		AttributePanel.setCloseBtnEnabled(true)
																	end)
					                            	)
	_attributePanelNode:runAction(showSeq)
	p_item:setEnabled(false)
end

--[[

--]]
require "script/ui/replaceSkill/ReplaceSkillService"
require "script/ui/tip/SingleTip"
function tapLearnSkillMenuItemCb( p_itemTag, p_item )
	local curMasterInfo = ReplaceSkillData.getCurMasterInfo()
	if tonumber(curMasterInfo.feel_skill) ~= 0 then
		error("skill has been learned!")
	end

	local skillInfo = ReplaceSkillData.getSkillInfoByLevel(1)
	if tonumber(curMasterInfo.feel_level) < skillInfo.needFeelLevel then
		SingleTip.showSingleTip(GetLocalizeStringBy("zz_52", skillInfo.needFeelLevel))
		return
	end

	local learnSkillCb = function ()
		--本地的curMasterInfo和data中的_curMasterInfo指向同一块内存
		curMasterInfo.feel_skill = tostring(skillInfo.skillId)
		refreshBottomUI()
	end
	ReplaceSkillService.upgradeSkill(curMasterInfo.star_id,learnSkillCb)
end

--[[

--]]
function tapUpgradeSkillMenuItemCb( p_itemTag, p_item )
	local curMasterInfo = ReplaceSkillData.getCurMasterInfo()
	if tonumber(curMasterInfo.feel_skill) == 0 then
		error("skill need be learned first!")
	end

	local curSkillInfo = ReplaceSkillData.getSkillInfoById(tonumber(curMasterInfo.feel_skill))
	if curSkillInfo.skillLevel == ReplaceSkillData.getCurSkillMaxLevel() then
		SingleTip.showSingleTip(GetLocalizeStringBy("zz_51", curSkillInfo.needFeelLevel))
		return
	end

	local nextSkillInfo = ReplaceSkillData.getSkillInfoByLevel(curSkillInfo.skillLevel + 1)
	if tonumber(curMasterInfo.feel_level) < nextSkillInfo.needFeelLevel then
		SingleTip.showSingleTip(GetLocalizeStringBy("zz_52", nextSkillInfo.needFeelLevel))
		return
	end

	local upgradeSkillCb = function ()
		--本地的curMasterInfo和data中的_curMasterInfo指向同一块内存
		curMasterInfo.feel_skill = tostring(nextSkillInfo.skillId)
		refreshBottomUI()
	end
	ReplaceSkillService.upgradeSkill(curMasterInfo.star_id,upgradeSkillCb)
end

--[[

--]]
require "script/ui/replaceSkill/ReplaceSkillFightPanel"
function tapFightMenuItemCb( p_itemTag, p_item )
	ReplaceSkillFightPanel.showLayer()
end

--[[

--]]
function tapFlipCardMenuItemCb( p_itemTag, p_item )
	if ReplaceSkillData.isFullExp() then
		AnimationTip.showTip(GetLocalizeStringBy("zzh_1086"))
	else
		require "script/ui/replaceSkill/BronzeFlipCardLayer"
		BronzeFlipCardLayer.showLayer()
	end
end

function tapLoardSkillCb()
	_jumpTag = 2
	require "script/ui/replaceSkill/EquipmentLayer"
	EquipmentLayer.showLayer(_jumpTag)
end