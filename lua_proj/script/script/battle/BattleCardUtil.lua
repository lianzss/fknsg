-- Filename: BattleLayer.lua
-- Author: k
-- Date: 2013-05-27
-- Purpose: 战斗场景


require "script/utils/extern"
require "script/utils/LuaUtil"
--require "amf3"
-- 主城场景模块声明
module("BattleCardUtil", package.seeall)


HeroNameLabelTag      =   10

local IMG_PATH        = "images/battle/"				-- 图片主路径
local _nameLabelArray = {}
local _battleData     = nil
local _isNameVisble   = true
function getDifferenceYByImageName(imageFile,isBoss)
    if(isBoss==nil)then
        isBoss = false;
    end
    
    local changeY = 0
    if("zhan_jiang_dingyuan.png"==imageFile) then
            changeY = -37
        elseif("zhan_jiang_guanyinping.png"==imageFile) then
            changeY = -25
        elseif("zhan_jiang_zhegeliang.png"==imageFile) then
            changeY = -44
        elseif("zhan_jiang_zhenji.png"==imageFile) then
            changeY = -8
        elseif("zhan_jiang_ganning.png"==imageFile and isBoss==false) then
            changeY = -17
        elseif("zhan_jiang_xiahoudun.png"==imageFile and isBoss==false) then
            changeY = -17
        elseif("zhan_jiang_zhangfei.png"==imageFile and isBoss==false) then
            changeY = -6
        elseif("zhan_jiang_nvzhu.png"==imageFile) then
            changeY = -23
        elseif("zhan_jiang_wenguan6.png"==imageFile) then
            changeY = -61
        elseif("zhan_jiang_zhugeliang.png"==imageFile and isBoss==false) then
            changeY = -40
        elseif("zhan_jiang_sunjian.png"==imageFile and isBoss==false) then
            changeY = -10
        elseif("zhan_jiang_taishici.png"==imageFile and isBoss==false) then
            changeY = -30
        elseif("zhan_jiang_zhangbao.png"==imageFile) then
            changeY = -47
        elseif("zhan_jiang_dongzhuo.png"==imageFile) then
            changeY = -15
        elseif("zhan_jiang_simayi.png"==imageFile) then
            changeY = -12
        elseif("zhan_jiang_wujiang9.png"==imageFile) then
            changeY = -38
        elseif("zhan_jiang_yujin.png"==imageFile) then
            changeY = -44
        elseif("zhan_jiang_zhaoyun.png"==imageFile and isBoss==false) then
            changeY = -32
        elseif("zhan_jiang_zhaoyun.png"==imageFile) then
            changeY = -49
        elseif("zhan_jiang_zhurong.png"==imageFile) then
            changeY = -17
        elseif("zhan_jiang_xuchu.png"==imageFile and isBoss == false) then
            changeY = -10
        elseif("zhan_jiang_xuchu.png"==imageFile) then
            changeY = -12
        elseif("zhan_jiang_xuhuang.png"==imageFile and isBoss == false) then
            changeY = -32
        elseif("zhan_jiang_xuhuang.png"==imageFile) then
            changeY = -68
        elseif("zhan_jiang_xunyou.png"==imageFile) then
            changeY = -35
        elseif("zhan_jiang_guanping.png"==imageFile) then
            changeY = -22
        elseif("zhan_jiang_chengpu.png"==imageFile) then
            changeY = -21
        elseif("zhan_jiang_lvbu.png"==imageFile and isBoss==false) then
            changeY = -45
        elseif("zhan_jiang_molvbu.png"==imageFile and isBoss==false) then
            changeY = -102
        elseif("zhan_jiang_mozhangjiao.png"==imageFile and isBoss==false) then
            changeY = -78
        elseif("zhan_jiang_molvbu.png"==imageFile) then
            changeY = -138
        elseif("zhan_jiang_mozhangjiao.png"==imageFile) then
            changeY = -144
        elseif("zhan_jiang_mowang.png"==imageFile) then
            changeY = -41
        elseif("zhan_jiang_mowang_1.png"==imageFile) then
            changeY = -41
        elseif("zhan_jiang_sunjian.png"==imageFile) then
            changeY = -32
        elseif("zhan_jiang_lvbu.png"==imageFile) then
            changeY = -63
        elseif("zhan_jiang_fazheng.png"==imageFile) then
            changeY = -20
        elseif("zhan_jiang_caoren.png"==imageFile and isBoss==false) then
            changeY = -42
        elseif("zhan_jiang_handang.png"==imageFile and isBoss==false) then
            changeY = -27
        elseif("zhan_jiang_huatuo.png"==imageFile and isBoss==false) then
            changeY = -38
        elseif("zhan_jiang_sunquan.png"==imageFile and isBoss==false) then
            changeY = -46
        elseif("zhan_jiang_zhuhuan.png"==imageFile and isBoss==false) then
            changeY = -14
        elseif("zhan_jiang_nanzhu2.png"==imageFile and isBoss==false) then
            changeY = -29
        elseif("zhan_jiang_nvzhu2.png"==imageFile and isBoss==false) then
            changeY = -16
        elseif("zhan_jiang_yinma.png"==imageFile and isBoss==false) then
            changeY = -25
        elseif("zhan_jiang_jinma.png"==imageFile and isBoss==false) then
            changeY = -23
        elseif("zhan_jiang_zhuyi.png"==imageFile and isBoss==false) then
            changeY = -43
        elseif("zhan_jiang_masu.png"==imageFile and isBoss== false) then
            changeY = -59
        elseif("zhan_jiang_zhuyi.png"==imageFile ) then
            changeY = -52
        elseif("zhan_jiang_yinma.png"==imageFile ) then
            changeY = -18
        elseif("zhan_jiang_jinma.png"==imageFile ) then
            changeY = -16
        elseif("zhan_jiang_caoren.png"==imageFile ) then
            changeY = -66
        elseif("zhan_jiang_ganning.png"==imageFile) then
            changeY = -32
        elseif("zhan_jiang_handang.png"==imageFile ) then
            changeY = -26
        elseif("zhan_jiang_sunquan.png"==imageFile ) then
            changeY = -81
        elseif("zhan_jiang_zhugeliang.png"==imageFile ) then
            changeY = -56
        elseif("zhan_jiang_taishici.png"==imageFile ) then
            changeY = -77
        elseif("zhan_jiang_feiyi.png"==imageFile ) then
            changeY = -38
        elseif("zhan_jiang_guansuo.png"==imageFile ) then
            changeY = -41
        elseif("zhan_jiang_masu.png"==imageFile ) then
            changeY = -110
        elseif("zhan_jiang_simazhao.png"==imageFile ) then
            changeY = -36
        elseif("zhan_jiang_yangxiu.png"==imageFile ) then
            changeY = -45
        elseif("zhan_jiang_xiahouyuan.png"==imageFile and isBoss==false) then
            changeY = -29
        elseif("zhan_jiang_xiahouyuan.png"==imageFile ) then
            changeY = -37
        elseif("zhan_jiang_nanzhu_shizhuang1.png"==imageFile ) then
            changeY = -21
        elseif("zhan_jiang_nvzhu_shizhuang1.png"==imageFile ) then
            changeY = -32
        elseif("zhan_jiang_weiyan.png"==imageFile and isBoss==false) then
            changeY = -7
        elseif("zhan_jiang_jiangwei.png"==imageFile and isBoss==false) then
            changeY = -0
        elseif("zhan_jiang_jiangwei.png"==imageFile ) then
            changeY = -47
        elseif("zhan_jiang_weiyan.png"==imageFile ) then
            changeY = -66
        elseif("zhan_jiang_xushu.png"==imageFile and isBoss==false) then
            changeY = -6 
        elseif("zhan_jiang_xushu.png"==imageFile ) then
            changeY = -66
        elseif("zhan_jiang_yuji.png"==imageFile and isBoss==false) then
            changeY = -20    
        elseif("zhan_jiang_yuji.png"==imageFile ) then
            changeY = -8

        elseif("zhan_jiang_caocao_1.png"==imageFile and isBoss==false) then
            changeY = -18    
        elseif("zhan_jiang_diaochan_1.png"==imageFile and isBoss==false) then
            changeY = -28    
        elseif("zhan_jiang_ganning_1.png"==imageFile and isBoss==false) then
            changeY = -57
        elseif("zhan_jiang_guanyu_1.png"==imageFile and isBoss==false) then
            changeY = -12                
        elseif("zhan_jiang_guojia_1.png"==imageFile and isBoss==false) then
            changeY = -24
        elseif("zhan_jiang_huatuo_1.png"==imageFile and isBoss==false) then
            changeY = -47    
        elseif("zhan_jiang_jiaxu_1.png"==imageFile and isBoss==false) then
            changeY = -26    
        elseif("zhan_jiang_luxun_1.png"==imageFile and isBoss==false) then
            changeY = -34
        elseif("zhan_jiang_lvmeng_1.png"==imageFile and isBoss==false) then
            changeY = -30                
        elseif("zhan_jiang_machao_1.png"==imageFile and isBoss==false) then
            changeY = -35
        elseif("zhan_jiang_sunce_1.png"==imageFile and isBoss==false) then
            changeY = -76    
        elseif("zhan_jiang_taishici_1.png"==imageFile and isBoss==false) then
            changeY = -34    
        elseif("zhan_jiang_weiyan_1.png"==imageFile and isBoss==false) then
            changeY = -28
        elseif("zhan_jiang_xiahoudun_1.png"==imageFile and isBoss==false) then
            changeY = -64                
        elseif("zhan_jiang_zhangfei_.png"==imageFile and isBoss==false) then
            changeY = -8
        elseif("zhan_jiang_zhanghe_1.png"==imageFile and isBoss==false) then
            changeY = -31    
        elseif("zhan_jiang_zhangjiao_1.png"==imageFile and isBoss==false) then
            changeY = -23    
        elseif("zhan_jiang_zhangliao_1.png"==imageFile and isBoss==false) then
            changeY = -46
        elseif("zhan_jiang_zhugeliang_1.png"==imageFile and isBoss==false) then
            changeY = -40                
        elseif("zhan_jiang_zuoci_1.png"==imageFile and isBoss==false) then
            changeY = -29
        elseif("zhan_jiang_zhangfei_1.png"==imageFile and isBoss==false) then
            changeY = -11

        --add by lichenyang
        elseif("zhan_jiang_weiyan.png"==imageFile and isBoss==false) then
            changeY = -7
               
        elseif("zhan_jiang_dengai.png"==imageFile and isBoss==false) then
            changeY = -71
        elseif("zhan_jiang_jianggan.png"==imageFile and isBoss==false) then
            changeY = -34
        elseif("zhan_jiang_pangtong.png"==imageFile and isBoss==false) then
            changeY = -75
        elseif("zhan_jiang_sunce.png"==imageFile and isBoss==false) then
            changeY = -57
        elseif("zhan_jiang_yanyan.png"==imageFile and isBoss==false) then
            changeY = -25
        elseif("zhan_jiang_chengyu.png"==imageFile and isBoss==false) then
            changeY = -25
        elseif("zhan_jiang_gongsunzan.png"==imageFile and isBoss==false) then
            changeY = -42
        elseif("zhan_jiang_maliang.png"==imageFile and isBoss==false) then
            changeY = -21
        elseif("zhan_jiang_wenyang.png"==imageFile and isBoss==false) then
            changeY = -22
        elseif("zhan_jiang_zhangzhongjing.png"==imageFile and isBoss==false) then
            changeY = -44
        elseif("zhan_jiang_zhugeke.png"==imageFile and isBoss==false) then
            changeY = -38
        elseif("zhan_jiang_zhangjiao.png"==imageFile and isBoss==false) then
            changeY = -0

        elseif("zhan_jiang_baosanniang.png"==imageFile and isBoss==false) then
            changeY = -28
        elseif("zhan_jiang_liaohua.png"==imageFile and isBoss==false) then
            changeY = -13
        elseif("zhan_jiang_liuxie.png"==imageFile and isBoss==false) then
            changeY = -10
        elseif("zhan_jiang_nanhualaoxian.png"==imageFile and isBoss==false) then
            changeY = -36
        elseif("zhan_jiang_xunyu.png"==imageFile and isBoss==false) then
            changeY = -34
        elseif("zhan_jiang_machao.png"==imageFile and isBoss==false) then
            changeY = 0
        elseif("zhan_jiang_caopei.png"==imageFile and isBoss==false) then
            changeY = 0
        elseif("zhan_jiang_liubei.png"==imageFile and isBoss==false) then
            changeY = 0
        elseif("zhan_jiang_menghuo.png"==imageFile and isBoss==false) then
            changeY = 0
        elseif("zhan_jiang_dianwei.png"==imageFile and isBoss==false) then
            changeY = -31
        elseif("zhan_jiang_diaochan.png"==imageFile and isBoss==false) then
            changeY = -15
        elseif("zhan_jiang_guanyu.png"==imageFile and isBoss == false) then
            changeY = -32
        elseif("zhan_jiang_zhangliao.png"==imageFile and isBoss == false) then
            changeY = -23
        elseif("zhan_jiang_pangde.png"==imageFile and isBoss == false) then
            changeY = -42
        elseif("zhan_jiang_nanzhu_shizhuang4.png"==imageFile and isBoss == false) then
            changeY = -33
        elseif("zhan_jiang_nvzhu_shizhuang4.png"==imageFile and isBoss == false) then
            changeY = -26
        --add by lichenyang
        elseif("zhan_jiang_zhuhuan.png"==imageFile) then
            changeY = -35
        elseif("zhan_jiang_pangde.png"==imageFile) then
            changeY = -62
        elseif("zhan_jiang_dengai.png"==imageFile ) then
            changeY = -71
        elseif("zhan_jiang_guyong.png"==imageFile ) then
            changeY = -4
        elseif("zhan_jiang_jianggan.png"==imageFile ) then
            changeY = -27
        elseif("zhan_jiang_mateng.png"==imageFile ) then
            changeY = -25
        elseif("zhan_jiang_pangtong.png"==imageFile ) then
            changeY = -94
        elseif("zhan_jiang_sunce.png"==imageFile ) then
            changeY = -96
        elseif("zhan_jiang_yanyan.png"==imageFile ) then
            changeY = -53
        elseif("zhan_jiang_nanzhu_shizhuang3.png"==imageFile ) then
            changeY = -26
        elseif("zhan_jiang_chengyu_37px.png"==imageFile ) then
            changeY = -25
        elseif("zhan_jiang_nvzhu_shizhuang3.png"==imageFile ) then
            changeY = -25
        elseif("zhan_jiang_chengyu.png"==imageFile ) then
            changeY = -25
        elseif("zhan_jiang_gongsunzan.png"==imageFile ) then
            changeY = -89
        elseif("zhan_jiang_maliang.png"==imageFile ) then
            changeY = -21
        elseif("zhan_jiang_wenyang.png"==imageFile ) then
            changeY = -22
        elseif("zhan_jiang_zhangzhongjing.png"==imageFile ) then
            changeY = -44
        elseif("zhan_jiang_zhugeke.png"==imageFile ) then
            changeY = -38
        elseif("zhan_jiang_zhangjiao.png"==imageFile) then
            changeY = -17

        elseif("zhan_jiang_baosanniang.png"==imageFile) then
            changeY = -36
        elseif("zhan_jiang_liaohua.png"==imageFile) then
            changeY = -6
        elseif("zhan_jiang_xunyu.png"==imageFile) then
            changeY = -70
        elseif("zhan_jiang_caopei.png"==imageFile) then
            changeY = -28
        elseif("zhan_jiang_dianwei.png"==imageFile) then
            changeY = -43
        elseif("zhan_jiang_diaochan.png"==imageFile) then
            changeY = -60
        elseif("zhan_jiang_guanyu.png"==imageFile) then
            changeY = -17
        elseif("zhan_jiang_liubei.png"==imageFile) then
            changeY = -55
        elseif("zhan_jiang_machao.png"==imageFile) then
            changeY = -60
        elseif("zhan_jiang_menghuo.png"==imageFile) then
            changeY = -36
        elseif("zhan_jiang_zhangfei.png"==imageFile) then
            changeY = -32


    end
    
    return changeY
end

function getBattlePlayerCard(hid,isBoss,htid,isdemonLoad,replaceImage)
    
    --hid = (hid == nil) and 0 or hid
    --print("=============  getBattlePlayerCard hid:",hid)
    hid = tonumber(hid)
    --isBoss = isBoss==nil and false or isBoss
    if(isBoss==nil)then
        isBoss = false
    end
    isdemonLoad = isdemonLoad==nil and false or isdemonLoad
    
    local cardPath = isBoss==true and IMG_PATH .. "bigcard/" or IMG_PATH .. "card/"
    local cardName = "nil"
    local imageFile
    local grade
    local myHtid   = htid
    local heroInfo = nil
    if(htid~=nil)then
        
        require "db/DB_Heroes"
        local hero = DB_Heroes.getDataById(htid)
        
        if(hero==nil)then
            require "db/DB_Monsters_tmpl"
            hero = DB_Monsters_tmpl.getDataById(htid)
        end
        
        grade = hero.star_lv
        imageFile = hero.action_module_id
        cardName  = hero.name
        heroInfo  = hero
    elseif(hid<10000000) then
        require "db/DB_Monsters"
        print("hahahahaha!!!!",hid)
        local monster = DB_Monsters.getDataById(hid)
        
        if(monster==nil) then
           monster = DB_Monsters.getDataById(3014201)
        end
        
        require "db/DB_Monsters_tmpl"
        local monsterTmpl = DB_Monsters_tmpl.getDataById(monster.htid)
        
        grade     = monsterTmpl.star_lv
        imageFile = monsterTmpl.action_module_id
        cardName  = monsterTmpl.name
        myHtid    = monster.htid
        heroInfo  = monsterTmpl
    else
        require "script/model/hero/HeroModel"
        require "script/utils/LuaUtil"
        local allHeros = HeroModel.getAllHeroes()
        if(allHeros==nil or allHeros[hid..""] == nil)then
            
            grade = hid%6+1
            imageFile = "zhan_jiang_guojia.png"
            --[[
        end
        --print_table("tb",allHeros)
        --print("----------- allHeros[hid].htid",allHeros[hid..""])
        --print("----------- allHeros[hid].htid",allHeros[hid])
        if(allHeros[hid..""] == nil) then
            
            grade = hid%6+1
            imageFile = "zhan_jiang_guojia.png"
             --]]
        else
            local htid = allHeros[hid..""].htid
            myHtid = htid
            require "db/DB_Heroes"
            local hero = DB_Heroes.getDataById(htid)
            
            grade = hero.star_lv
            imageFile = hero.action_module_id
            cardName  = hero.name
            myHtid = htid
            heroInfo  = hero
        end
    end
    
    if(replaceImage~=nil)then
        imageFile = replaceImage
    end
    
    if(isdemonLoad==true)then
        grade = 99
        cardPath = IMG_PATH .. "bigcard/"
        isBoss = true
    end
    
    local card = CCXMLSprite:create(cardPath .. "card_" .. (grade) .. ".png")
    card:initXMLSprite(CCString:create(cardPath .. "card_" .. (grade) .. ".png"));
    card:setAnchorPoint(ccp(0.5,0.5))
    card:setCascadeOpacityEnabled(true)
    card:setCascadeColorEnabled(true)
    
    --print("============= imageFile:",imageFile,isBoss,isBoss==nil)
    local heroSprite = nil
    if((isBoss==true or isdemonLoad==true) and file_exists("images/base/hero/action_module_b/" .. imageFile)==true)then
        heroSprite = CCSprite:create("images/base/hero/action_module_b/" .. imageFile);
    else
        heroSprite = CCSprite:create("images/base/hero/action_module/" .. imageFile);
    end
    heroSprite:setAnchorPoint(ccp(0.5,0))
    

    local changeY = getDifferenceYByImageName(imageFile,isBoss)

    if(isdemonLoad==true)then
        changeY = changeY - card:getContentSize().height*0.027
    end
    
    --local changeY = ("jiang_xinxianying.png"==imageFile) and -16 or 0
    heroSprite:setPosition(card:getContentSize().width/2,card:getContentSize().height*0.17+changeY)
    card:addChild(heroSprite,2,1)
    
    local topSprint = CCSprite:create(cardPath .. "card_" .. (grade) .. "_top.png")
    topSprint:setAnchorPoint(ccp(0,1))
    topSprint:setPosition(0,card:getContentSize().height)
    card:addChild(topSprint,1,2)
    
    --取消职业现实
    --[[
    local bottomSprint = CCSprite:create(cardPath .. "card_" .. (grade) .. "_bottom.png")
    bottomSprint:setAnchorPoint(ccp(1,0))
    bottomSprint:setPosition(card:getContentSize().width,card:getContentSize().height*0.17)
    card:addChild(bottomSprint,3,3)
    bottomSprint:setCascadeOpacityEnabled(true)
    bottomSprint:setCascadeColorEnabled(true)
    
    local occupationSprite = CCSprite:create(IMG_PATH .. "occupation/occupation_" .. (grade) .. ".png")
    occupationSprite:setAnchorPoint(ccp(0,1))
    occupationSprite:setPosition(bottomSprint:getContentSize().width*0,bottomSprint:getContentSize().height*1)
    bottomSprint:addChild(occupationSprite,4,4)
    --]]
    local shadowSprint = CCSprite:create(cardPath .. "card_shadow.png")
    shadowSprint:setAnchorPoint(ccp(0,1))
    shadowSprint:setPosition(-6,card:getContentSize().height+5)
    card:addChild(shadowSprint,-1,5)
    
    local hpLineBg = CCSprite:create(cardPath .. "hpline_bg.png")
    hpLineBg:setAnchorPoint(ccp(0.5,0.5))
    hpLineBg:setPosition(card:getContentSize().width*0.5,card:getContentSize().height*-0.05)
    card:addChild(hpLineBg,1,6)
    hpLineBg:setCascadeOpacityEnabled(true)
    hpLineBg:setCascadeColorEnabled(true)
    
    local hpLine = CCSprite:create(cardPath .. "hpline.png")
    hpLine:setAnchorPoint(ccp(0,0.5))
    hpLine:setPosition(0,hpLineBg:getContentSize().height*0.5)
    hpLineBg:addChild(hpLine,1,7)
    ---[[
    local heroBgSprite = CCSprite:create(cardPath .. "card_hero_bg.png");
    heroBgSprite:setAnchorPoint(ccp(0.5,0))
    heroBgSprite:setPosition(card:getContentSize().width/2,card:getContentSize().height*0.17)
    card:addChild(heroBgSprite,0,8)
     --]]
    
    if(myHtid~=nil and HeroModel.isNecessaryHero(myHtid)) then
        cardName = getNecessaryName(hid)
        print("398 cardName:", cardName, hid)
        if(cardName == nil) then
            require "script/model/user/UserModel"
            cardName = UserModel.getUserName()
        end
    end

    print("create card htid = ", myHtid, cardName)
    local nameColor = HeroPublicLua.getCCColorByStarLevel(heroInfo.potential)
    local heroName  = CCRenderLabel:create(cardName, g_sFontPangWa, 18, 1, ccc3( 0x00, 0x00, 0x00), type_shadow)
    heroName:setPosition(ccp(card:getContentSize().width/2, card:getContentSize().height))
    heroName:setAnchorPoint(ccp(0.5, 0))
    heroName:setColor(nameColor)
    card:addChild(heroName, 1000, HeroNameLabelTag)
    heroName:setVisible(_isNameVisble)
    
    table.insert(_nameLabelArray, heroName)
    heroName:registerScriptHandler(function ( eventType )
        if(eventType == "exit") then
            for k,v in pairs(_nameLabelArray) do
                if(v == heroName) then
                    _nameLabelArray[k] = nil
                end
            end
        end
    end)

    return card
end

function setCardHp(card,scale)
    --判断是否为标准卡牌
    if(card~=nil and card:getChildByTag(6)~=nil and card:getChildByTag(6):getChildByTag(7)~=nil)then
        local hpLine = tolua.cast(card:getChildByTag(6):getChildByTag(7), "CCSprite")
        local textureSize = hpLine:getTexture():getContentSize()
        scale = scale>1 and 1 or scale
        scale = scale<0 and 0 or scale
        hpLine:setTextureRect(CCRectMake(0,0,textureSize.width*scale,textureSize.height))
    end
end

function setCardAnger(card,angerPoint)
    --判断是否为标准卡牌
    if(card~=nil and card:getChildByTag(6)~=nil and card:getChildByTag(6):getChildByTag(7)~=nil)then
        local angerPerPoint = 1
        
        if(card==nil)then
            return
        end
        
        local angerNumber = math.floor( angerPoint/angerPerPoint)
        --angerNumber = angerNumber>4 and 4 or angerNumber
        
        if(angerNumber>4)then
            if(card:getChildByTag(8881)==nil or card:getChildByTag(8881):getChildByTag(1290)==nil)then
                
                if(card:getContentSize().width>150)then
                    local angerSprite = CCSprite:create(IMG_PATH .. "anger/big.png")
                    angerSprite:setAnchorPoint(ccp(0.5,0.5))
                    angerSprite:setPosition(card:getContentSize().width*0.7,21)
                    card:addChild(angerSprite,10,8881)
                    angerSprite:setCascadeOpacityEnabled(true)
                    angerSprite:setCascadeColorEnabled(true)
                    
                    local xSprite = CCSprite:create(IMG_PATH .. "anger/X.png")
                    xSprite:setAnchorPoint(ccp(0,0))
                    xSprite:setPosition(angerSprite:getContentSize().width,0)
                    angerSprite:addChild(xSprite,1,1299)
                    
                    local numberSprite = LuaCC.createNumberSprite02(IMG_PATH .. "anger","" .. angerNumber,0)
                    numberSprite:setAnchorPoint(ccp(0,0))
                    numberSprite:setPosition(angerSprite:getContentSize().width+xSprite:getContentSize().width,-13)
                    angerSprite:addChild(numberSprite,1,1290)
                    
                else
                    
                    local angerSprite = CCSprite:create(IMG_PATH .. "anger/nomal.png")
                    angerSprite:setAnchorPoint(ccp(0.5,0.5))
                    angerSprite:setPosition(card:getContentSize().width*0.7,12)
                    card:addChild(angerSprite,10,8881)
                    angerSprite:setCascadeOpacityEnabled(true)
                    angerSprite:setCascadeColorEnabled(true)
                    
                    local xSprite = CCSprite:create(IMG_PATH .. "anger/X.png")
                    xSprite:setAnchorPoint(ccp(0,0))
                    xSprite:setPosition(angerSprite:getContentSize().width,0)
                    angerSprite:addChild(xSprite,1,1299)
                    
                    local numberSprite = LuaCC.createNumberSprite02(IMG_PATH .. "anger","" .. angerNumber,0)
                    numberSprite:setAnchorPoint(ccp(0,0))
                    numberSprite:setPosition(angerSprite:getContentSize().width+xSprite:getContentSize().width,-13)
                    angerSprite:addChild(numberSprite,1,1290)
                end
            else
                
                local angerSprite = card:getChildByTag(8881)
                angerSprite:removeChildByTag(1290,true)
                
                if(card:getContentSize().width>150)then
                    
                    local numberSprite = LuaCC.createNumberSprite02(IMG_PATH .. "anger","" .. angerNumber,20)
                    numberSprite:setAnchorPoint(ccp(0,0))
                    numberSprite:setPosition(angerSprite:getContentSize().width+angerSprite:getChildByTag(1299):getContentSize().width,-13)
                    angerSprite:addChild(numberSprite,1,1290)
                else
                    
                    local numberSprite = LuaCC.createNumberSprite02(IMG_PATH .. "anger","" .. angerNumber,20)
                    numberSprite:setAnchorPoint(ccp(0,0))
                    numberSprite:setPosition(angerSprite:getContentSize().width+angerSprite:getChildByTag(1299):getContentSize().width,-13)
                    angerSprite:addChild(numberSprite,1,1290)
                end
            end
        else
            
            if(card:getChildByTag(8881)==nil or card:getChildByTag(8881):getChildByTag(1290)==nil)then
                
            else
                
                local angerSprite = card:getChildByTag(8881)
                angerSprite:setVisible(false)
            end
        end
            
        for j=1,4 do
            local sp = tolua.cast(card:getChildByTag(10+j),"CCSprite")
            if(angerNumber>=j)then
                if(sp==nil)then
                    if(card:getContentSize().width>150)then
                        
                        local angerStar = CCSprite:create(IMG_PATH .. "bigcard/anger.png")
                        --替换为动画
                        --local angerStar = CCLayerSprite:layerSpriteWithName(CCString:create("images/battle/effect/nuqi"), -1,CCString:create(""))
                        angerStar:setAnchorPoint(ccp(0.5,0.5))
                        angerStar:setPosition(22+(j-1)*20,21)
                        card:addChild(angerStar,3,10+j)
                    else
                        local angerStar = CCSprite:create(IMG_PATH .. "card/anger.png")
                        --替换为动画
                        --local angerStar = CCLayerSprite:layerSpriteWithName(CCString:create("images/battle/effect/nuqi"), -1,CCString:create(""))
                        angerStar:setAnchorPoint(ccp(0.5,0.5))
                        --angerStar:setPosition(17+(j-1)*14,13.5)
                        
                        angerStar:setPosition(14+(j-1)*14,12)
                        card:addChild(angerStar,3,10+j)
                    end
                end
            else
                if(sp~=nil)then
                    sp:removeFromParentAndCleanup(true)
                end
            end
        end
        
        if(angerNumber>=4 and g_system_type == kBT_PLATFORM_IOS)then
            local spellEffectSprite = card:getChildByTag(131)
            if(spellEffectSprite==nil)then
                
                for j=1,4 do
                    local angerStar = CCLayerSprite:layerSpriteWithName(CCString:create("images/battle/effect/lvdou"), -1,CCString:create(""))
                    angerStar:setAnchorPoint(ccp(0.5,0.5))
                    --angerStar:setPosition(17+(j-1)*14,13.5)
                    --print("pos:",j,14+(j-1)*14,12)
                    
                    if(card:getContentSize().width>150)then
                        angerStar:setPosition(22+(j-1)*20,19)
                        angerStar:setScale(1.5)
                    else
                        angerStar:setPosition(14+(j-1)*14,12)
                    end
                    card:addChild(angerStar,3,130+j)
                    
                    local redSprite = card:getChildByTag(10+j)
                    if(redSprite~=nil)then
                        redSprite:setVisible(false)
                    end
                end
            end
        else
            for j=1,4 do
                
                local tpSprite = card:getChildByTag(130+j)
                if(tpSprite~=nil)then
                    card:removeChildByTag(130+j,true)
                end
                
                local redSprite = card:getChildByTag(10+j)
                if(redSprite~=nil)then
                    redSprite:setVisible(true)
                end
            end
        end
        
        if(angerNumber>=999)then
            local spellEffectSprite = card:getChildByTag(131)
            if(spellEffectSprite==nil)then
                local originalFormat = CCTexture2D:defaultAlphaPixelFormat()
                CCTexture2D:setDefaultAlphaPixelFormat(kCCTexture2DPixelFormat_RGBA4444)
                local spellEffectSprite = CCLayerSprite:layerSpriteWithName(CCString:create("images/battle/effect/" .. "heffect_12"), -1,CCString:create(""))
                
                spellEffectSprite:setPosition(ccp(card:getContentSize().width/2,card:getContentSize().height*0.55))
                spellEffectSprite:setAnchorPoint(ccp(0.5, 0.5));
                card:addChild(spellEffectSprite,12,131);
                CCTexture2D:setDefaultAlphaPixelFormat(originalFormat)
            end
            --[[
            --delegate
            local animationEnd = function(actionName,xmlSprite)
                spellEffectSprite:removeFromParentAndCleanup(true)
            end
            
            local animationFrameChanged = function(frameIndex,xmlSprite)
            end

            --增加动画监听
            local delegate = BTAnimationEventDelegate:create()
            delegate:registerLayerEndedHandler(animationEnd)
            delegate:registerLayerChangedHandler(animationFrameChanged)
            spellEffectSprite:setDelegate(delegate)
             --]]
        else
            --card:removeChildByTag(131,true)
            
            local bSprite = card:getChildByTag(131)
            if(bSprite~=nil)then
                --bSprite:removeFromParentAndCleanup(true)
            end
        end
    end
    --[[
    for i=1,angerNumber do
        local angerStar = CCSprite:create(IMG_PATH .. "card/anger.png")
        angerStar:setAnchorPoint(ccp(0.5,0.5))
        angerStar:setPosition(14+(i-1)*14,12)
        card:addChild(angerStar,3,10+i)
    end
     --]]
end

-- 退出场景，释放不必要资源
function release (...) 

end

function getBattleOutLinePlayerCard(hid)
    
    --hid = (hid == nil) and 0 or hid
    --print("=============  getBattlePlayerCard hid:",hid)
    hid = tonumber(hid)

    local cardPath = isBoss==true and IMG_PATH .. "bigcard/" or IMG_PATH .. "card/"
    
    local imageFile
    local grade
    if(htid~=nil)then
        
        require "db/DB_Heroes"
        local hero = DB_Heroes.getDataById(htid)
        
        grade = hero.star_lv
        imageFile = hero.boss_icon_id
    elseif(hid<10000000) then
        require "db/DB_Monsters"
        local monster = DB_Monsters.getDataById(hid)
        
        if(monster==nil) then
            monster = DB_Monsters.getDataById(1002011)
        end
        
        require "db/DB_Monsters_tmpl"
        local monsterTmpl = DB_Monsters_tmpl.getDataById(monster.htid)
        
        grade = monsterTmpl.star_lv
        imageFile = monsterTmpl.boss_icon_id
    else
        require "script/model/hero/HeroModel"
        require "script/utils/LuaUtil"
        local allHeros = HeroModel.getAllHeroes()
        if(allHeros==nil or allHeros[hid..""] == nil)then
            
            grade = hid%6+1
            imageFile = "zhan_jiang_guojia.png"
            --[[
             end
             --print_table("tb",allHeros)
             --print("----------- allHeros[hid].htid",allHeros[hid..""])
             --print("----------- allHeros[hid].htid",allHeros[hid])
             if(allHeros[hid..""] == nil) then
             
             grade = hid%6+1
             imageFile = "zhan_jiang_guojia.png"
             --]]
            else
            local htid = allHeros[hid..""].htid
            
            require "db/DB_Heroes"
            local hero = DB_Heroes.getDataById(htid)
            
            grade = hero.star_lv
            imageFile = hero.boss_icon_id
        end
    end
    
    local blankSprite = CCXMLSprite:create(IMG_PATH .. "card/blankcard.png")
    blankSprite:initXMLSprite(CCString:create(IMG_PATH .. "card/blankcard.png"));
    blankSprite:setAnchorPoint(ccp(0.5,0.5))
    blankSprite:setCascadeOpacityEnabled(true)
    blankSprite:setCascadeColorEnabled(true)
    
    
    local card = CCSprite:create("images/base/hero/body_img/" .. imageFile)
    --local card = CCXMLSprite:create("images/base/hero/body_img/" .. imageFile)
    --card:initXMLSprite(CCString:create("images/base/hero/body_img/" .. imageFile));
    card:setAnchorPoint(ccp(0.5,0))
    card:setPosition(ccp(blankSprite:getContentSize().width*0.5,0))
    card:setCascadeOpacityEnabled(true)
    card:setCascadeColorEnabled(true)
    
    blankSprite:addChild(card)
    
    --return card
    return blankSprite
end

function getFormationPlayerCard(hid,isBoss,htid,dressId)
    
    require "script/battle/BattleLayer"
    BattleLayer.initPlayerCardHidMap()
    local hidMap = BattleLayer.m_playerCardHidMap
    
    if(dressId~=nil and tonumber(dressId)~=nil)then
        
        require "db/DB_Item_dress"
        local dress = DB_Item_dress.getDataById(tonumber(dressId))

        if(dress.changeModel) then
            local modelArray = lua_string_split(dress.changeModel,",")
            for modelIndex=1,#modelArray do
                local baseHtid = lua_string_split(modelArray[modelIndex],"|")[1]
                local dressFile = lua_string_split(modelArray[modelIndex],"|")[2]
                
                require "db/DB_Heroes"
                local heroTmpl = DB_Heroes.getDataById(tonumber(htid))
                if(heroTmpl.model_id == tonumber(baseHtid))then
                    print("m_playerCardHidMap[cardInfo.hid]:",hid,baseHtid)
                    hidMap[hid .. ""] = {}
                    hidMap[hid .. ""].actionFile = dressFile
                end
            end
        end
        
    end
    
    --hid = (hid == nil) and 0 or hid
    --print("=============  getBattlePlayerCard hid:",hid)
    if(hid == nil)then
        hid = 0
    end
    hid = tonumber(hid)
    if(isBoss==nil)then
        isBoss = false
    end
    htid = tonumber(htid)
    
    local imageFile
    local grade
    
    if(htid~=nil)then
        
        require "db/DB_Heroes"
        local hero = DB_Heroes.getDataById(htid)
        
        grade = hero.star_lv
        imageFile = hero.action_module_id
        
    else
        
        if(hid<10000000) then
            require "db/DB_Monsters"
            local monster = DB_Monsters.getDataById(hid)
            
            if(monster==nil) then
                monster = DB_Monsters.getDataById(1002011)
            end
            
            require "db/DB_Monsters_tmpl"
            local monsterTmpl = DB_Monsters_tmpl.getDataById(monster.htid)
            
            grade = monsterTmpl.star_lv
            imageFile = monsterTmpl.action_module_id
        else
            require "script/model/hero/HeroModel"
            local allHeros = HeroModel.getAllHeroes()
            require "script/utils/LuaUtil"
            --print_table("tb",allHeros)
            --print("----------- allHeros[hid].htid",allHeros[hid..""])
            --print("----------- allHeros[hid].htid",allHeros[hid])
            if(allHeros[hid..""] == nil) then
                
                grade = hid%6+1
                imageFile = "zhu_nanxing.png"
            else
                local htid = allHeros[hid..""].htid
                
                require "db/DB_Heroes"
                local hero = DB_Heroes.getDataById(htid)
                
                grade = hero.star_lv
                imageFile = hero.action_module_id
                
            end
            
        end
    end
    
    if(hidMap[hid .. ""]~=nil and hidMap[hid .. ""].actionFile~=nil)then
        imageFile = hidMap[hid .. ""].actionFile
    end
    
    local card = CCXMLSprite:create(IMG_PATH .. "card/card_" .. (grade) .. ".png")
    card:initXMLSprite(CCString:create(IMG_PATH .. "card/card_" .. (grade) .. ".png"));
    card:setAnchorPoint(ccp(0.5,0.5))
    card:setCascadeOpacityEnabled(true)
    card:setCascadeColorEnabled(true)
    
    --print("============= imageFile",imageFile)
    local heroSprite = CCSprite:create("images/base/hero/action_module/" .. imageFile);
    heroSprite:setAnchorPoint(ccp(0.5,0))
    
    
    local changeY = getDifferenceYByImageName(imageFile,false)
    
    
    --local changeY = ("jiang_xinxianying.png"==imageFile) and -16 or 0
    heroSprite:setPosition(card:getContentSize().width/2,card:getContentSize().height*0.17+changeY)
    card:addChild(heroSprite,2,1)
    
    local topSprint = CCSprite:create(IMG_PATH .. "card/card_" .. (grade) .. "_top.png")
    topSprint:setAnchorPoint(ccp(0,1))
    topSprint:setPosition(0,card:getContentSize().height)
    card:addChild(topSprint,1,2)
    
    --取消职业现实
    --[[
     local bottomSprint = CCSprite:create(IMG_PATH .. "card/card_" .. (grade) .. "_bottom.png")
     bottomSprint:setAnchorPoint(ccp(1,0))
     bottomSprint:setPosition(card:getContentSize().width,card:getContentSize().height*0.17)
     card:addChild(bottomSprint,3,3)
     bottomSprint:setCascadeOpacityEnabled(true)
     bottomSprint:setCascadeColorEnabled(true)
     
     local occupationSprite = CCSprite:create(IMG_PATH .. "occupation/occupation_" .. (grade) .. ".png")
     occupationSprite:setAnchorPoint(ccp(0,1))
     occupationSprite:setPosition(bottomSprint:getContentSize().width*0,bottomSprint:getContentSize().height*1)
     bottomSprint:addChild(occupationSprite,4,4)
     
    local shadowSprint = CCSprite:create(IMG_PATH .. "card/card_shadow.png")
    shadowSprint:setAnchorPoint(ccp(0,1))
    shadowSprint:setPosition(-6,card:getContentSize().height+5)
    card:addChild(shadowSprint,-1,5)
     
     --]]
    --[[
    local hpLineBg = CCSprite:create(IMG_PATH .. "card/hpline_bg.png")
    hpLineBg:setAnchorPoint(ccp(0.5,0.5))
    hpLineBg:setPosition(card:getContentSize().width*0.5,card:getContentSize().height*-0.05)
    card:addChild(hpLineBg,1,6)
    hpLineBg:setCascadeOpacityEnabled(true)
    hpLineBg:setCascadeColorEnabled(true)
    
    local hpLine = CCSprite:create(IMG_PATH .. "card/hpline.png")
    hpLine:setAnchorPoint(ccp(0,0.5))
    hpLine:setPosition(0,hpLineBg:getContentSize().height*0.5)
    hpLineBg:addChild(hpLine,1,7)
     --]]
    ---[[
    local heroBgSprite = CCSprite:create(IMG_PATH .. "card/card_hero_bg.png");
    heroBgSprite:setAnchorPoint(ccp(0.5,0))
    heroBgSprite:setPosition(card:getContentSize().width/2,card:getContentSize().height*0.17)
    card:addChild(heroBgSprite,0,8)
    --]]
    
    if(isBoss)then
        card:setScale(1.5)
    end
    
    return card
end

function getCardByArmyId(armyId)
    
    armyId = tonumber(armyId)
    
    require "db/DB_Army"
    local army = DB_Army.getDataById(armyId)
    require "db/DB_Team"
    local team = DB_Team.getDataById(army.monster_group)
    
    local monsterHtid = team.copyTeamShowId
    print("monsterHtid:",monsterHtid)
    
    return getBattlePlayerCard(0,nil,monsterHtid,nil)
end

--设置战斗中卡牌是否显示武将名称
function setNameVisible( isVisible )
    _isNameVisble = isVisible

    for k,v in pairs(_nameLabelArray) do
        local nameLabel = tolua.cast(v,"CCRenderLabel")
        if(nameLabel) then
            nameLabel:setVisible(isVisible)
            print("nameLabel:setVisible(isVisible)", isVisible)
        else
            _nameLabelArray[k] = nil
            print("nameLabel:setVisible(isVisible)", k)
        end
    end
end


--设置当前战斗数据
function setBattleData( battleData )
    _battleData = battleData
end


function getNecessaryName( hid )
    if(_battleData == nil) then
        return
    end

    for i,v in ipairs(_battleData.team1.arrHero) do
        print("team1: hid , v.hid",hid , v.hid)
        if(tonumber(hid) == tonumber(v.hid)) then
            return _battleData.team1.name
        end
    end

    for i,v in ipairs(_battleData.team2.arrHero) do
        print("team2:hid , v.hid",hid , v.hid)
        if(tonumber(hid) == tonumber(v.hid)) then
            return _battleData.team2.name
        end
    end   

end







