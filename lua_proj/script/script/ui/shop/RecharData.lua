-- Filename: RecharData.lua.
-- Author: zhz  
-- Date: 2014-06-16
-- Purpose: 该文件用于显示充值界面数据

module("RecharData",  package.seeall)

require "script/ui/item/ItemUtil"


local _chargeInfo= {} -- 玩家充值的一些信息:is_pay, can_buy_monthlycard 

function getChargeInfo( )
    return _chargeInfo
end

-- 
function setChargeInfo(chargeInfo )
    _chargeInfo = chargeInfo
end

-- 得到是否可以买月卡
function getCanBuyMonthCard( )
    local canBuyMonthCard= true
    if(_chargeInfo.can_buy_monthlycard== "false" or _chargeInfo.can_buy_monthlycard== false ) then
        canBuyMonthCard= false
    end    

    return canBuyMonthCard
end

function setCanBuyMonthCard(  canBuy)
    _chargeInfo.can_buy_monthlycard = tostring(canBuy) 
end


function setIsPay( isPay )
      _chargeInfo.is_pay = tostring(isPay) 
end

-- 得到是否冲过值
function getIsPay( )
    return _chargeInfo.is_pay
end

-- 得到首充礼包的数据
 function getFirstData(  )
    
    local firstGiftData={}
    local payData={}

    local platformName = Platform.getPlatformUrlName()

    -- 台湾android
    if(platformName == "Android_km") then
        firstGiftData= DB_First_gift.getArrDataByField("platform_type",4)[1]
        payData = getKiMiAndroidFirstPay(firstGiftData)
        return payData
    -- 台湾IOS
    elseif(platformName== "ios_kimi" ) then
        firstGiftData= DB_First_gift.getArrDataByField("platform_type",3)[1]

    -- IOS app     
    elseif(Platform.getCurrentPlatform() == kPlatform_AppStore) then
       firstGiftData = DB_First_gift.getArrDataByField("platform_type", 2)[1]
    else
        firstGiftData = DB_First_gift.getArrDataByField("platform_type", 1)[1]
    end

    local consume_money =  string.split(firstGiftData.money_nums, ",")
    local consume_grade = string.split(firstGiftData.gold_nums, ",")
    local gold_num = string.split(firstGiftData.return_gold, ",")
    local product_id = {}

    local  giftInfo = DB_First_gift.getDataById(2)
    print("giftInfo")
    print_t(giftInfo)
    if(giftInfo.product_id) then
        product_id= string.split(giftInfo.product_id, ",")
    end

    for i =1,#consume_money do
        local tempGiftData = {}
        tempGiftData.consume_money = consume_money[i]
        tempGiftData.consume_grade = consume_grade[i]
        tempGiftData.gold_num = gold_num[i]
        if(not table.isEmpty(product_id)) then
            tempGiftData.product_id = tonumber(product_id[i])
        else
            tempGiftData.product_id = tonumber(product_id)
        end
        print("product_id[i]", product_id[i])
        table.insert(payData,tempGiftData)
    end
    return payData
end

function getKiMiAndroidFirstPay( firstGiftData) 

    local payData= {}

    local consume_money =  string.split(firstGiftData.money_nums, ",")
    local consume_grade = string.split(firstGiftData.gold_nums, ",")
    local gold_num = string.split(firstGiftData.return_gold, ",")
    local isShow= lua_string_split(firstGiftData.is_show, ",")

    for i=1,#isShow do
        local tempGiftData= {}
        local showIndex= tonumber(isShow[i])
        tempGiftData.consume_money = tonumber(consume_money[showIndex])/100 
        tempGiftData.consume_grade = consume_grade[showIndex]
        tempGiftData.gold_num = gold_num[showIndex]
        table.insert(payData, tempGiftData)
    end
    return payData
end

-- 得到非首冲礼包的数据
function getPayListData(  )
    
    local payData = {}

    print("BTUtil:isAppStore()  is : ",BTUtil:isAppStore() )
    local platformName = Platform.getPlatformUrlName()
    if(platformName == "Android_km") then
        local allPayData= DB_Pay_list.getArrDataByField("platform_type",4)
        for id, data in pairs(allPayData) do
            if(data.is_show==1) then
                table.insert(payData, data)
            end
        end

    elseif(platformName== "ios_kimi" ) then
        payData= DB_Pay_list.getArrDataByField("platform_type",3)

    elseif(Platform.getCurrentPlatform() == kPlatform_AppStore) then
       payData = DB_Pay_list.getArrDataByField("platform_type", 2)
    else
        payData = DB_Pay_list.getArrDataByField("platform_type", 1)
    end

    local function keySort ( w1 , w2 )
        return tonumber(w1.id) < tonumber(w2.id)
    end
    table.sort( payData, keySort )

    return payData
end


-- 处理充值的数据
function getChargeData()

   local  payData ={}
    -- 没有首冲
    if(_chargeInfo.is_pay== "false" or _chargeInfo.is_pay== false)  then
        payData = RecharData.getFirstData()
    else
        payData = RecharData.getPayListData()
    end
    return payData
end



-- 得到月卡里面的数据
function getMonthCardData( )
    
    require "db/DB_Vip_card"
    local monthCardData= DB_Vip_card.getDataById(1)

    local items= ItemUtil.getItemsDataByStr( monthCardData.cardReward)
    -- monthCardData.product_id=monthCardData.productId
    monthCardData.items= items
    return monthCardData

end









