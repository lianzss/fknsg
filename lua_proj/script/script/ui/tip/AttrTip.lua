-- FileName: AttrTip.lua 
-- Author: licong 
-- Date: 14-9-15 
-- Purpose: 套装属性激活提示


module("AttrTip", package.seeall)

--[[ 
	@des 	:套装激活提示 换装备时候 
	@param 	:p_newSuitInfo:套装激活新的信息，p_oldSuitInfo套装激活前的信息
	@return :
--]]
function showAtrrTipCallBack( p_newSuitInfo, p_oldSuitInfo )
	if(p_newSuitInfo == nil)then
		return
	end
	-- node
	local showNode = CCSprite:create()
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	showNode:setAnchorPoint(ccp(0.5,0.5))
	runningScene:addChild(showNode,2013)
	setAdaptNode(showNode)

	-- 子节点tab
	local oneNodeTab = {}
	-- 内容
	for n_sid,n_sData in pairs(p_newSuitInfo) do
		local isInOld = false
		for o_sid,o_sData in pairs(p_oldSuitInfo) do
			if(tonumber(o_sid) == tonumber(n_sid))then
				isInOld = true
				if(tonumber(o_sData.had_count) < tonumber(n_sData.had_count))then
					-- 子节点
					local oneNode, suit_quality = createSpriteNode(n_sData)
					showNode:addChild(oneNode)
				    local tab = {}
				    tab.suit_quality = suit_quality
				    tab.oneNode = oneNode
				    table.insert(oneNodeTab,tab)
				end
				break
			end
		end
		-- 新增的
		if(isInOld == false)then
			if(n_sData.isShow == true)then
				-- 子节点
				local oneNode, suit_quality = createSpriteNode(n_sData)
				showNode:addChild(oneNode)
			    local tab = {}
			    tab.suit_quality = suit_quality
			    tab.oneNode = oneNode
			    table.insert(oneNodeTab,tab)
			end
		end
	end

	-- 排序 品质高的显示在最上边
	local function fnSortFun( a, b )
        return tonumber(a.suit_quality) > tonumber(b.suit_quality)
    end 
	table.sort( oneNodeTab, fnSortFun )

	-- 设置位置
	showNode:setContentSize(CCSizeMake(450,150 * #oneNodeTab))
	local height = showNode:getContentSize().height
	for i=1,#oneNodeTab do
		oneNodeTab[i].oneNode:setAnchorPoint(ccp(0.5,1))
		oneNodeTab[i].oneNode:setPosition(ccp(showNode:getContentSize().width*0.5,height))
		height = height - oneNodeTab[i].oneNode:getContentSize().height - 20
	end

	-- 动画action
	showNode:setPosition(ccp(runningScene:getContentSize().width*0.5,runningScene:getContentSize().height*0.5))
    local nextMoveToP = ccp(runningScene:getContentSize().width*0.5, runningScene:getContentSize().height*0.58)
    -- 设置遍历子节点  透明度
    showNode:setCascadeOpacityEnabled(true)
    local actionArr = CCArray:create()
	actionArr:addObject(CCDelayTime:create(1.5))
	actionArr:addObject(CCEaseOut:create(CCMoveTo:create(1.3, nextMoveToP),2))
	actionArr:addObject(CCFadeOut:create(0.8))
	actionArr:addObject(CCCallFuncN:create(function ( ... )
		showNode:removeFromParentAndCleanup(true)
		showNode = nil
	end))
	showNode:runAction(CCSequence:create(actionArr))
end



--[[ 
	@des 	:套装激活提示 换装备时候 
	@param 	:p_suitInfo:套装激活的信息
	@return :node, 套装品质
--]]
function createSpriteNode( p_suitInfo )
	-- 子节点
	local oneNode = CCSprite:create()
	oneNode:setCascadeOpacityEnabled(true)
	oneNode:setContentSize(CCSizeMake(450,150))
	-- 激活xx装备x件效果:
	local tipFont1 = {}
    tipFont1[1] = CCRenderLabel:create(GetLocalizeStringBy("lic_1233") ,g_sFontPangWa,35,1, ccc3(0x00,0x00,0x00), type_stroke)
    tipFont1[1]:setColor(ccc3(0x76,0xfc,0x06))
    tipFont1[2] = CCRenderLabel:create(p_suitInfo.suit_name ,g_sFontPangWa,35,1, ccc3(0x00,0x00,0x00), type_stroke)
    -- 获取套装数据
	require "db/DB_Suit"
	local suit_desc = DB_Suit.getDataById(p_suitInfo.suit_id)
	-- 套装的各个装备
	local suit_equip_ids = string.split(suit_desc.suit_items, "," )
	local equipData = ItemUtil.getItemById(suit_equip_ids[1])
    local color = HeroPublicLua.getCCColorByStarLevel(equipData.quality)
    tipFont1[2]:setColor(color)
	tipFont1[3] = CCRenderLabel:create(GetLocalizeStringBy("lic_1234"),g_sFontPangWa,35,1, ccc3(0x00,0x00,0x00), type_stroke)
	tipFont1[3]:setColor(ccc3(0x76,0xfc,0x06))
    tipFont1[4] = CCRenderLabel:create(p_suitInfo.had_count,g_sFontPangWa,35,1, ccc3(0x00,0x00,0x00), type_stroke)
    tipFont1[4]:setColor(ccc3(0x76,0xfc,0x06))
    tipFont1[5] = CCRenderLabel:create(GetLocalizeStringBy("lic_1235"),g_sFontPangWa,35,1, ccc3(0x00,0x00,0x00), type_stroke)
	tipFont1[5]:setColor(ccc3(0x76,0xfc,0x06))
	require "script/utils/BaseUI"
    local tipFontNode1 = BaseUI.createHorizontalNode(tipFont1)
    -- 设置遍历子节点 透明度
    tipFontNode1:setCascadeOpacityEnabled(true)
    tipFontNode1:setAnchorPoint(ccp(0.5,1))
    tipFontNode1:setPosition(ccp(oneNode:getContentSize().width*0.5,oneNode:getContentSize().height))
    oneNode:addChild(tipFontNode1)
    -- 激活的属性显示
    local suit_position_x = {0.2, 0.8, 0.2, 0.8, 0.2, 0.8}
		local suit_position_y_add = {0, 0, 40, 0, 40, 0}
    local a_index = 0
    local s_height = oneNode:getContentSize().height - tipFontNode1:getContentSize().height - 5
    if(p_suitInfo.suit_attr_infos.astAttr ~= nil)then
	    for attr_id, attr_num in pairs(p_suitInfo.suit_attr_infos.astAttr) do
	    	a_index = a_index + 1
	    	s_height = s_height-suit_position_y_add[a_index]
	    	local affixDesc, displayNum = ItemUtil.getAtrrNameAndNum(attr_id, attr_num)
	    	-- 属性名称
	    	local attr_name_num_label = CCRenderLabel:create( affixDesc.sigleName .. ": +" .. displayNum, g_sFontPangWa, 35,1, ccc3(0x00,0x00,0x00), type_stroke)
			attr_name_num_label:setColor(ccc3(0x76,0xfc,0x06))
			attr_name_num_label:setAnchorPoint(ccp(0.5, 1))
			attr_name_num_label:setPosition(ccp(suit_position_x[a_index]*oneNode:getContentSize().width, s_height))
			oneNode:addChild(attr_name_num_label)
	    end
	end
    return oneNode, equipData.quality
end














































