-- Filename: EquipmentTableView.lua
-- Author: DJN
-- Date: 2014-08-13
-- Purpose: 跨服赛膜拜奖励tableView

module("EquipmentTableView", package.seeall)

require "script/ui/item/ItemUtil"
require "script/ui/replaceSkill/ReplaceSkillData"
require "script/model/DataCache"
require "db/skill"
require "db/DB_Star"
require "db/DB_Heroes"
--require "script/ui/replaceSkill/EquipmentLayer"
--local _allInfo = DataCache.getStarInfoFromCache()  --从缓存中获取的全部武将信息
local _allInfo = nil
local _curSkill = nil       --当前装备的技能是属于哪个武将的，如果为空说明装备的是自己的技能
local _userTag = nil

--[[
    @des    :交换一个表中的两个位置的值
    @param  :
    @return :
--]]
function swap(table, indexA, indexB)
    local temp = table[indexA]
    table[indexA] = table[indexB]
    table[indexB] = temp
end

--[[
    @des    :获取已经学习的技能
    @param  :
    @return :
--]]
function getUsefulData(allInfo)
    local starList = {}
    -- print("输出获取的数据结构")
    -- print_t(allInfo)
    local count = 0
    if(allInfo ~= nil)then  
        for k,v in pairs(allInfo) do
            if(tonumber(v.feel_skill) ~= 0)then
                table.insert(starList,v)
                count = count + 1 
                --如果当前装备的技能属于别的武将，并找到了该武将的id
                if(v.star_id == _curSkill)then
                    --展示的时候需要已装备的在最上方
                    swap(starList, 1, count)
                end
            end
        end
    else
        print("名将列表为空")
    end
    --在列表中需要展示上自己的技能
    --if(_curSkill ~= nil)then
    local item = {}
    local db_hero = DB_Heroes.getDataById(UserModel.getAvatarHtid())
    --local skillId = skill.getDataById(db_hero.rage_skill_attack)
    local skillId = db_hero.rage_skill_attack
    item.feel_skill = skillId
    table.insert(starList,item)
   
    _userTag = table.count(starList)
    if(_curSkill == nil)then
        swap(starList, 1, _userTag)
        _userTag = 1
    end

    print("输出筛选后的结果",_curSkill)
    print_t(starList)
    return starList
end

local _curList = nil--供创建tableview用的信息
--[[
    @des    :创建tableView
    @param  :
    @return :创建好的tableView
--]]
function createTableView(sizeX,sizeY)
    _allInfo = ReplaceSkillData.getAllInfo()
    if(_allInfo ~= nil)then
        _curSkill = _allInfo.va_act_info.skill
        _curList = getUsefulData(_allInfo.star_list)
    else --当前没有名将，只展示自己的技能
  
        local item = {}
        _curList = {}
        local db_hero = DB_Heroes.getDataById(UserModel.getAvatarHtid())
        --local skillId = skill.getDataById(db_hero.rage_skill_attack)
        local skillId = db_hero.rage_skill_attack
        item.feel_skill = skillId
        table.insert(_curList,item)

        _userTag = table.count(_curList)
        -- if(_curSkill == nil)then
        --     swap(_curList, 1, _userTag)
        --     _userTag = 1
        -- end

    end
    local cellNum = table.count(_curList)
    local h = LuaEventHandler:create(function(fn,table,a1,a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(575*g_fScaleX, 205*g_fScaleX)
        elseif fn == "cellAtIndex" then
            --用a1+1做下标创建cell
            a2 = createCell(cellNum - a1)
            r = a2
        elseif fn == "numberOfCells" then
            r = cellNum
        else
            print("other function")
        end

        return r
    end)
   -- return LuaTableView:createWithHandler(h, CCSizeMake(635*g_fScaleX, 750*g_fScaleX))
   return LuaTableView:createWithHandler(h, CCSizeMake(sizeX, sizeY))
 end

--[[
    @des    :创建奖励预览cell
    @param  :奖励的位置，从1开始（即a1+1的值）
    @return :创建好的cell
--]]
function createCell(p_pos)
    --记录当前行的技能和名将信息，供装备技能时使用
    -- _selectSkill = _curList[p_pos].feel_skill
    -- _selectStar  = _curList[p_pos].stra_id

    local tCell = CCTableViewCell:create()
    tCell:setScale(g_fScaleX)
    --背景
    local cellBgSprite = CCScale9Sprite:create("images/reward/cell_back.png")
    cellBgSprite:setContentSize(CCSizeMake(635,200))
    cellBgSprite:setAnchorPoint(ccp(0,0))
    cellBgSprite:setPosition(ccp(1,5))
    tCell:addChild(cellBgSprite)

    --技能名称
    local nameStr = skill.getDataById(_curList[p_pos].feel_skill).name 
    local nameLabel  = CCRenderLabel:create(nameStr,g_sFontPangWa,25,1,ccc3(0x00,0x00,0x00),type_stroke)
    nameLabel:setColor(ccc3(0xe4,0x00,0xff))
    nameLabel:setAnchorPoint(ccp(0,0.5))
    nameLabel:setPosition(ccp(130,165))
    cellBgSprite:addChild(nameLabel)
    
    --头像
    require "script/ui/replaceSkill/ReplaceSkillLayer"
    print("打印创建头像的id")
    print(p_pos)
    print(_curList[p_pos].feel_skill)
    local iconSprite = ReplaceSkillLayer.createSkillIcon(_curList[p_pos].feel_skill)
    iconSprite:setAnchorPoint(ccp(0,0))
    iconSprite:setPosition(ccp(20,80))
    cellBgSprite:addChild(iconSprite)
    --对于不是主角的技能需要展示图标的等级，主角的技能无等级
    if(p_pos ~= _userTag)then
        --等级
        local lvImage = CCSprite:create("images/common/lv.png")
        lvImage:setPosition(ccp(35,50))
        cellBgSprite:addChild(lvImage)

        local skillList = ReplaceSkillData.getSkillInfoBySid(_curList[p_pos].star_id)
        local skillInfo = ReplaceSkillData.getSkillById(skillList,_curList[p_pos].feel_skill)
        local levelLabel = CCRenderLabel:create(skillInfo.skillLevel,g_sFontPangWa,18,1,ccc3(0x00,0x00,0x00),type_stroke)
        levelLabel:setColor(ccc3(0xff,0xf6,0x00))
        levelLabel:setAnchorPoint(ccp(0,0))
        levelLabel:setPosition(ccp(75,50))
        cellBgSprite:addChild(levelLabel)
    end
  
    if(p_pos ~= _userTag)then
        print("p_pos")
        print(p_pos)
        print("_userTag")
        print(_userTag)
    --技能属于武将信息
        local shuyuLabel = CCRenderLabel:create(GetLocalizeStringBy("djn_26"),g_sFontPangWa,21,1,ccc3(0x00,0x00,0x00),type_stroke)
        shuyuLabel:setColor(ccc3(0xfe, 0xdb, 0x1c))
        shuyuLabel:setAnchorPoint(ccp(0,0.5))
        shuyuLabel:setPosition(ccp(nameLabel:getContentSize().width + nameLabel:getPositionX()+10,165))
        cellBgSprite:addChild(shuyuLabel) 
        --武将名称
        --local starLabelStr
        -- if(_curSkill ~= nil )then
        -- if(p_pos == _userTag)then
        --     require "script/model/user/UserModel"
        --     starLabelStr = UserModel.getUserName()
            
        -- else
        local  starLabelStr = DB_Star.getDataById(_curList[p_pos].star_tid).name
        -- end
        local starLabel = CCRenderLabel:create(starLabelStr,g_sFontPangWa,21,1,ccc3(0x00,0x00,0x00),type_stroke)
        starLabel:setColor(ccc3(0xe4,0x00,0xff))
        starLabel:setAnchorPoint(ccp(0,0.5))
        starLabel:setPosition(ccp(shuyuLabel:getPositionX()+105,165))
        cellBgSprite:addChild(starLabel)

        local kuohao = CCRenderLabel:create(GetLocalizeStringBy("djn_36"),g_sFontPangWa,21,1,ccc3(0x00,0x00,0x00),type_stroke)
        kuohao:setColor(ccc3(0xfe, 0xdb, 0x1c))
        kuohao:setAnchorPoint(ccp(0,0.5))
        kuohao:setPosition(ccp(starLabel:getContentSize().width+starLabel:getPositionX()+1,165))
        cellBgSprite:addChild(kuohao)
    end

    --二级白色背景
    local whiteBgSprite = CCScale9Sprite:create("images/recycle/reward/rewardbg.png")
    whiteBgSprite:setContentSize(CCSizeMake(350,120))
    whiteBgSprite:setAnchorPoint(ccp(0,0))
    whiteBgSprite:setPosition(ccp(120,25))
    cellBgSprite:addChild(whiteBgSprite)
    -- --横线
    -- local lineSprite = CCScale9Sprite:create("images/common/line01.png")
    -- lineSprite:setContentSize(CCSizeMake(303,4))
    -- lineSprite:setAnchorPoint(ccp(0,0))
    -- lineSprite:setPosition(ccp(8,75))
    -- whiteBgSprite:addChild(lineSprite)

    --怒
    local nuSprite = CCSprite:create("images/hero/info/anger.png")
    nuSprite:setAnchorPoint(ccp(0,1))
    nuSprite:setPosition(ccp(9,100))
    whiteBgSprite:addChild(nuSprite)
    local nuStr = CCLabelTTF:create(GetLocalizeStringBy("key_2064"),g_sFontName,25)
    nuStr:setColor(ccc3(0xff,0xff,0xff))
    nuStr:setAnchorPoint(ccp(0.5,0.5))
    nuStr:setPosition(ccp(nuSprite:getContentSize().width*0.5,nuSprite:getContentSize().height*0.5))
    nuSprite:addChild(nuStr)
    
    --技能描述
    local desStr = skill.getDataById(_curList[p_pos].feel_skill).des
    --因为引擎把XXX%~XXX%算作一个字符，会发生无法换行的情况，所以拆分 XXX%~XXX% 中间加一个空格
    desStr = string.gsub(desStr,"~","~ ")
    local desLabel = CCLabelTTF:create(desStr,g_sFontName,21,CCSizeMake(275,100),kCCTextAlignmentLeft)
    desLabel:setAnchorPoint(ccp(0,1))
    desLabel:setColor(ccc3(0x78,0x25,0x00))
    desLabel:setPosition(ccp(47,100))
    whiteBgSprite:addChild(desLabel)

    --背景按钮层
    local bgMenu = CCMenu:create()
    bgMenu:setPosition(ccp(0,0))
    bgMenu:setTouchPriority(EquipmentLayer.getTouchPriority()-1)
    tCell:addChild(bgMenu)

    --无论是自己的还是别人的技能，总有一个是正在被装备的，永远将当前装备的技能放在数据数组的第一个位置
    if(p_pos == 1 )then 
        --已装备
            local equipedLabel = CCScale9Sprite:create("images/common/bg/seal_9s_bg.png")
            equipedLabel:setContentSize(CCSizeMake(120,64))
            equipedLabel:setAnchorPoint(ccp(0.5,0))
            equipedLabel:setPosition(545,50)
            cellBgSprite:addChild(equipedLabel)

            local equipedStr = CCRenderLabel:create(GetLocalizeStringBy("djn_28"),g_sFontPangWa,30,1,ccc3(0x00,0x00,0x00),type_stroke)
            equipedStr:setColor(ccc3(0xff,0xf6,0x00))
            equipedStr:setAnchorPoint(ccp(0.5,0.5))
            equipedStr:setPosition(ccp(equipedLabel:getContentSize().width*0.5,equipedLabel:getContentSize().height*0.5))
            equipedLabel:addChild(equipedStr)
    else
        --当前技能可以装备
        local equipButton = LuaCC.create9ScaleMenuItem("images/common/btn/btn_blue_n.png","images/common/btn/btn_blue_h.png",CCSizeMake(160, 83),
                                                        GetLocalizeStringBy("djn_27"),ccc3(0xfe, 0xdb, 0x1c),30,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00))
        
        equipButton:setAnchorPoint(ccp(0.5,0))
        equipButton:registerScriptTapHandler(equipButtonCallFunc)
        equipButton:setPosition(ccp(545,50))
        bgMenu:addChild(equipButton,1,p_pos)
        end
    return tCell
end
--[[
    @des    :更换技能按钮回调
    @param  :
    @return :
--]]
function equipButtonCallFunc( tag ,item)
    -- 音效
    require "script/audio/AudioUtil"
    AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
    --弹特效
    require "script/ui/replaceSkill/FlipCardLayer"
    FlipCardLayer.getSkillTip(skill.getDataById(_curList[tag].feel_skill).name)
    print("增加特效成功")
    --require "script/ui/replaceSkill/ReplaceSkillData"
    require "script/ui/replaceSkill/ReplaceSkillService"
    if(tag == _userTag)then
       --换回主角自己的技能
       --修改_curSkill 供replaceSkillLayer界面跳转时使用
        _curSkill = nil
        --修改userTag 供table:reoload使用
        -- _userTag = 1
        ReplaceSkillService.changeSkill(0,EquipmentLayer.jumpPage )
    else
        if(_curSkill == nil)then
            --由主角技能换成别人技能
            -- _userTag = tag
         end
         --由别人技能换成另一种别人技能
        _curSkill = _curList[tag].star_id
        ReplaceSkillService.changeSkill(_curList[tag].star_id, EquipmentLayer.jumpPage)
    end
    --将当前装备的技能放在数据数组的第一位，在展示的时候，第一个数据永远显示已装备,供table:reolad使用
    -- swap(_curList,1,tag)
   
    local table = tolua.cast(EquipmentLayer.getTableView(),"LuaTableView")
    --table:reloadData()
end


--[[
    @des    :返回当前的装备所属武将信息，装备自己的则返回nil
    @param  :
    @return :
--]]
function getCurSkill( ... )
    return _curSkill
end