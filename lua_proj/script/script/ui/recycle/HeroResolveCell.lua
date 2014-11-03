-- Filename: HeroResolveCell.lua
-- Author: zhang zihang
-- Date: 2014-2-11
-- Purpose: 该文件用于: 武将炼化选择cell

module ("HeroResolveCell", package.seeall)

require "script/ui/recycle/ResolveSelectLayer"

local _ksTagTableViewBg = 201

function getHeroList(_arrSelectedHeroes,tParam)
	require "script/model/hero/HeroModel"
	require "db/DB_Heroes"
	local hids = HeroModel.getAllHeroesHid()
	local heroesValue = {}

	-- scrollview内容cell中的按钮
	local _cell_menu_item_data = {
		{normal="images/common/checkbg.png", highlighted="images/common/checkbg.png", 
		pos_x=548, pos_y=46, tag=3001, 
		ccObj=nil, focus=true, cb=menu_item_tap_handler}
	}

	for i=1, #hids do
		-- 去除需要过滤的武将们
		local bIsFiltered = false
		if tParam.filters then
			for k=1, #tParam.filters do
				if tParam.filters[k] == hids[i] then
					bIsFiltered = true
					break
				end
			end 
		end
		--如果符合条件
		if not bIsFiltered then
			local value = {}
			value.hid = hids[i]
			value.isBusy=false
			local hero = HeroModel.getHeroByHid(value.hid)
			value.htid = hero.htid
			local thisHero = DB_Heroes.getDataById(value.htid)
			value.name = thisHero.name
			value.rebirth_gold = thisHero.rebirth_basegold
			value.level = hero.level
			value.evolve_level = hero.evolve_level

			print("##################################")
			print(value.level)

			local db_hero = DB_Heroes.getDataById(value.htid)
			value.country_icon = HeroModel.getCiconByCidAndlevel(db_hero.country, db_hero.star_lv)
			value.name = db_hero.name

			value.star_lv = db_hero.star_lv
			print(value.star_lv)
			value.head_icon = "images/base/hero/head_icon/" .. db_hero.head_icon_id
			value.quality_bg = "images/hero/quality/"..value.star_lv .. ".png"
			value.quality_h = "images/hero/quality/highlighted.png"
			value.heroQuality = db_hero.heroQuality
			value.withoutExp = true

			--添加选择按钮
			value.menu_items = {}
			table.hcopy(_cell_menu_item_data, value.menu_items)
			for j=1, #value.menu_items do
				value.menu_items[j].tag = value.menu_items[j].tag + #heroesValue
			end
			value.type = "HeroSelect"

			-- 判断是否默认为选中
			local bIsSelected = false
			if (not table.isEmpty(_arrSelectedHeroes)) then
				for p = 1,#_arrSelectedHeroes do
					if value.hid == _arrSelectedHeroes[p].hid then
						bIsSelected = true
						break
					end
				end
			end
			value.checkIsSelected = bIsSelected
			value.menu_tag = _ksTagTableViewMenu
			value.tag_bg = _ksTagTableViewBg
			--value.fight_value = HeroFightForce.getAllForceValues(value).fightForce
			heroesValue[#heroesValue+1] = value
		end
	end
	print("heroesValue = :")
	print_t(heroesValue)

	-- 按战斗力值排序
	-- local function sort(w1, w2)
	-- 	if tonumber(w1.star_lv) < tonumber(w2.star_lv) then
	-- 		return true
	-- 	elseif tonumber(w1.star_lv) == tonumber(w2.star_lv) then
	-- 		if tonumber(w1.level) < tonumber(w2.level) then
	-- 			return true
	-- 		else 
	-- 			return false 
	-- 		end
	-- 	else 
	-- 		return false
	-- 	end
	-- 	--return w1.star_lv < w2.star_lv
	-- end

	require "script/ui/hero/HeroSort"
	heroesValue = HeroSort.sortForHeroList(heroesValue)

	return heroesValue
end

function createHeroSellTableView(_arrSelectedHeroes,_tParentParam,layerWidth,_scrollview_height)
	local cellBg = CCSprite:create("images/hero/attr_bg.png")
	local cellSize = cellBg:getContentSize()
	cellSize.width = cellSize.width * g_fScaleX
	cellSize.height = cellSize.height * g_fScaleX
	cellBg = nil

	local _visiableCellNum = math.floor(_scrollview_height/(cellSize.height*g_fScaleX))
	local _arrHeroesValue = getHeroList(_arrSelectedHeroes,_tParentParam)

	ResolveSelectLayer.updateHeroValue(_arrHeroesValue)

	require "script/ui/hero/HeroLayerCell"
	require "script/ui/hero/HeroFightSimple"
	local handler = LuaEventHandler:create(function(fn, table, a1, a2)
		local r
		if (fn == "cellSize") then
			r = CCSizeMake(cellSize.width, cellSize.height)
		elseif (fn == "cellAtIndex") then
			local len = #_arrHeroesValue
			local value = _arrHeroesValue[len-a1]
			if value.fight_value == nil or value.fight_value==0 then
				value.force_values =  HeroFightSimple.getAllForceValues(value)
				value.fight_value = value.force_values.fightForce
			end
			a2 = HeroLayerCell.createCell(value)
			a2:setScale(g_fScaleX)
			_arrHeroesValue[len-a1].ccObj = a2
			r = a2
		elseif (fn == "numberOfCells") then
			r = #_arrHeroesValue
		elseif (fn == "cellTouched") then
			ResolveSelectLayer.fnHandlerOfCellTouched(a1:getIdx())
		end
		
		return r
	end)
	local tableView = LuaTableView:createWithHandler(handler, CCSizeMake(layerWidth, _scrollview_height))
	tableView:setAnchorPoint(ccp(0, 0))
	tableView:setBounceable(true)

	return tableView,cellSize.height
end
