-- Filename: RegisterLayer.lua
-- Author: lichenyang
-- Date: 2013-12-18
-- Purpose: appstore 注册

module ("RegisterLayer", package.seeall)

require "script/ui/tip/AlertTip"

local registerUrl = Platform.getConfig().getRegisterUrl()



local function onTouchesHandler( eventType, x, y )
	if (eventType == "began") then
	    return true
	end
end

function showLoginLayer( ... )
	ininlize()
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	_mainLayer = CCLayerColor:create(ccc4(11,11,11,166))
	runningScene:addChild(_mainLayer,999)

	_mainLayer:registerScriptTouchHandler(onTouchesHandler, false, -128, true)
	_mainLayer:setTouchEnabled(true)
 
	-- 九宫格图片
	local fullRect = CCRectMake(0, 0, 213, 171)
	local insetRect = CCRectMake(84, 84, 2, 3)
	mainBg= CCScale9Sprite:create("images/common/viewbg1.png", fullRect, insetRect)
	require "script/ui/rewardCenter/AdaptTool"
	mainBg:setPreferredSize(CCSizeMake(640,496))
	mainBg:setPosition(ccp(g_winSize.width*0.5,g_winSize.height/2))
	mainBg:setAnchorPoint(ccp(0.5,0.5))
	AdaptTool.setAdaptNode(mainBg)
	_mainLayer:addChild(mainBg)

	--createBgAction(mainBg)

	local titleBg= CCSprite:create("images/common/viewtitle1.png")
	titleBg:setPosition(ccp(mainBg:getContentSize().width*0.5,mainBg:getContentSize().height-6))
	titleBg:setAnchorPoint(ccp(0.5, 0.5))
	mainBg:addChild(titleBg)

	--奖励的标题文本
	local labelTitle = CCRenderLabel:create(GetLocalizeStringBy("key_1285"), g_sFontPangWa,35,2,ccc3(0x0,0x00,0x0),type_stroke)
	labelTitle:setSourceAndTargetColor(ccc3( 0xff, 0xf0, 0x49), ccc3( 0xff, 0xa2, 0x00));
	labelTitle:setPosition(ccp(titleBg:getContentSize().width*0.5,titleBg:getContentSize().height*0.5+2 ))
	labelTitle:setAnchorPoint(ccp(0.5,0.5))
	titleBg:addChild(labelTitle)

	--内块
	local rect = CCRectMake(0,0,61,47)
	local insert = CCRectMake(18,18,1,1)
	_tableViewSp = CCScale9Sprite:create("images/copy/fort/textbg.png",rect,insert)
	_tableViewSp:setPreferredSize(CCSizeMake(554,310))
	_tableViewSp:setPosition(ccp(mainBg:getContentSize().width*0.5 - _tableViewSp:getContentSize().width*0.5,127))
	mainBg:addChild(_tableViewSp)

	local username = CCLabelTTF:create(GetLocalizeStringBy("key_2981"), g_sFontName, 21)
	username:setPosition(ccp(108, 33+76*3))
	username:setColor(ccc3(100, 25, 4))
	-- username:setAnchorPoint(ccp(0,0))
	_tableViewSp:addChild(username)

	local password = CCLabelTTF:create(GetLocalizeStringBy("key_1493"), g_sFontName, 21)
	password:setPosition(ccp(108, 33+76*2))
	password:setColor(ccc3(100, 25, 4))
	-- password:setAnchorPoint(ccp(0,0))
	_tableViewSp:addChild(password)

	-- local password = CCLabelTTF:create("que'ren:", g_sFontName, 21)
	-- password:setPosition(ccp(108, 63))
	-- password:setColor(ccc3(100, 25, 4))
	-- -- password:setAnchorPoint(ccp(0,0))
	-- _tableViewSp:addChild(password)

	local conformPassword = CCLabelTTF:create(GetLocalizeStringBy("key_3029"), g_sFontName, 21)
	conformPassword:setPosition(ccp(65, 33+76))
	conformPassword:setColor(ccc3(100, 25, 4))
	-- conformPassword:setAnchorPoint(ccp(0,0))
	_tableViewSp:addChild(conformPassword)

	local emailLabel = CCLabelTTF:create(GetLocalizeStringBy("key_2534"), g_sFontName, 21)
	emailLabel:setPosition(ccp(108, 33))
	emailLabel:setColor(ccc3(100, 25, 4))
	_tableViewSp:addChild(emailLabel)


	text_username = CCEditBox:create (CCSizeMake(278,45), CCScale9Sprite:create("images/login/login_text_bg.png"))
	text_username:setPosition(ccp(169, 43+76*3))
	text_username:setAnchorPoint(ccp(0, 0.5))
	text_username:setPlaceHolder(GetLocalizeStringBy("key_2621"))
	text_username:setPlaceholderFontColor(ccc3(177, 177, 177))
	-- text_username:setPlaceholderFontSize(17)
	text_username:setFont(g_sFontName,24)
	text_username:setFontColor(ccc3( 0x78, 0x25, 0x00))
	text_username:setMaxLength(24)
	text_username:setReturnType(kKeyboardReturnTypeDone)
	text_username:setInputFlag (kEditBoxInputFlagInitialCapsWord)
	text_username:setTouchPriority(-129)
	_tableViewSp:addChild(text_username)

	text_password = CCEditBox:create (CCSizeMake(278,45), CCScale9Sprite:create("images/login/login_text_bg.png"))
	text_password:setPosition(ccp(169, 43+76*2))
	text_password:setAnchorPoint(ccp(0, 0.5))
	text_password:setPlaceHolder(GetLocalizeStringBy("key_2413"))
	text_password:setPlaceholderFontColor(ccc3(177, 177, 177))
	-- text_password:setPlaceholderFontSize(17)
	text_password:setFont(g_sFontName,24)
	text_password:setFontColor(ccc3( 0x78, 0x25, 0x00))
	text_password:setMaxLength(24)
	text_password:setReturnType(kKeyboardReturnTypeDone)
	text_password:setInputFlag (kEditBoxInputFlagPassword)
	text_password:setTouchPriority(-129)
	_tableViewSp:addChild(text_password)


	text_confrom_password = CCEditBox:create (CCSizeMake(278,45), CCScale9Sprite:create("images/login/login_text_bg.png"))
	text_confrom_password:setPosition(ccp(169, 43+76))
	text_confrom_password:setAnchorPoint(ccp(0, 0.5))
	text_confrom_password:setPlaceHolder(GetLocalizeStringBy("key_2679"))
	text_confrom_password:setPlaceholderFontColor(ccc3(177, 177, 177))
	-- text_confrom_password:setPlaceholderFontSize(17)
	text_confrom_password:setFont(g_sFontName,24)
	text_confrom_password:setFontColor(ccc3( 0x78, 0x25, 0x00))
	text_confrom_password:setMaxLength(24)
	text_confrom_password:setReturnType(kKeyboardReturnTypeDone)
	text_confrom_password:setInputFlag (kEditBoxInputFlagPassword)
	text_confrom_password:setTouchPriority(-129)
	_tableViewSp:addChild(text_confrom_password)

	text_email = CCEditBox:create (CCSizeMake(278,45), CCScale9Sprite:create("images/login/login_text_bg.png"))
	text_email:setPosition(ccp(169, 43))
	text_email:setAnchorPoint(ccp(0, 0.5))
	text_email:setPlaceHolder(GetLocalizeStringBy("key_3144"))
	text_email:setPlaceholderFontColor(ccc3(177, 177, 177))
	-- text_email:setPlaceholderFontSize(17)
	text_email:setFont(g_sFontName,24)
	text_email:setFontColor(ccc3( 0x78, 0x25, 0x00))
	text_email:setMaxLength(24)
	text_email:setReturnType(kKeyboardReturnTypeDone)
	text_email:setInputFlag (kEditBoxInputFlagInitialCapsWord)
	text_email:setTouchPriority(-129)
	_tableViewSp:addChild(text_email)

	-- 关闭按钮
	local menu =CCMenu:create()
	menu:setPosition(ccp(0,0))
	menu:setTouchPriority(-551)
	mainBg:addChild(menu,1000)
	_cancelBtn = CCMenuItemImage:create("images/common/btn_close_n.png", "images/common/btn_close_h.png")
	_cancelBtn:setAnchorPoint(ccp(1, 1))
	_cancelBtn:setPosition(ccp(mainBg:getContentSize().width+1, mainBg:getContentSize().height+14))
	_cancelBtn:registerScriptTapHandler(layerCloseCallback)
	menu:addChild(_cancelBtn)

	--注册按钮
	require "script/libs/LuaCC"
	local btn_register = LuaCC.create9ScaleMenuItem("images/common/btn/btn1_d.png","images/common/btn/btn1_n.png",CCSizeMake(210,73),GetLocalizeStringBy("key_2500"),ccc3(255,222,0))
    btn_register:setAnchorPoint(ccp(0.5, 0.5))
    btn_register:setPosition(mainBg:getContentSize().width*0.5, 74)
	menu:addChild(btn_register)
	btn_register:registerScriptTapHandler(gotoRegister)

end
local _username = ""
local _password = ""
local _email = ""
function gotoRegister( ... )
	local username 		  = text_username:getText()
	local password 		  = text_password:getText()
	local conformPassword = text_confrom_password:getText()
	_username = username
	_password = password
	_email = text_email:getText()

	if(username == "" or password == "")then
		require "script/ui/tip/AlertTip"
    	AlertTip.showAlert(GetLocalizeStringBy("key_1901"), nil)
		return
	end
	if(string.len(username) > 20 and string.len(username) < 3) then
		AlertTip.showAlert(GetLocalizeStringBy("key_2929"), nil)
		return
	end
	if(string.len(password) < 6) then
		AlertTip.showAlert(GetLocalizeStringBy("key_2627"))
		return
	end

	if(password ~= conformPassword) then
		AlertTip.showAlert(GetLocalizeStringBy("key_1811"))
		return
	end

	if(_email ~= nil and _email ~= "" and isRightEmail(_email) == false)then
		AlertTip.showAlert(GetLocalizeStringBy("key_1802"))
		return
	end
	local url = registerUrl ..  "&username=" ..username
	url 	  = url .. "&password=" .. password
	url 	  = url .. "&email=" .. _email
	url 	  = url .. "&bind=" .. g_dev_udid
	print("register url", url)
	httpClent = CCHttpRequest:open(url, kHttpGet)
	httpClent:sendWithHandler(registerRequestCallback)
	LoadingUI.addLoadingUI()
end


function registerRequestCallback( res, hnd )
	-- require "script/ui/login/AppLoginLayer"
	-- AppLoginLayer.parseResponse( res, hnd,_password, _password)

	LoadingUI.reduceLoadingUI()

	if(res:getResponseCode()~=200)then
        require "script/ui/tip/AlertTip"
        AlertTip.showAlert( GetLocalizeStringBy("key_1810"), nil, false, nil)
        return
    end

	print("register date:", res:getResponseData())

	local xml = require "script/utils/LuaXml"
    local xmlTable = LuaXML.eval(res:getResponseData())
    --保存登陆数据
    
    if(xmlTable == nil or xmlTable:find("uid") == nil) then
      Platform.loginOut()
      -- AlertTip.showAlert(GetLocalizeStringBy("key_1889"), loginAgain)
      require "script/ui/tip/AlertTip"
      AlertTip.showAlert(GetLocalizeStringBy("key_3194"), nil)
      CCLuaLog("swap user info error -> uid is nill")
      return
    end
    
    local uid = xmlTable:find("uid")[1]
    local errornu = xmlTable:find("errornu")[1]
    local errordesc = xmlTable:find("errordesc")[1]
    local newuser = xmlTable:find("errordesc")[1]
    print("uid = ",uid)
    print("errornu=",errornu)
    print("errordesc=",errordesc)
    print("newuser=",newuser)
    Platform.setPid(uid)
    if(errornu == "0") then
      --登陆逻辑服务器
      	require "script/Platform"
        Platform.sendInformationToPlatform(Platform.kNewPlatformAccount,nil)
        require "script/ui/login/AppLoginLayer"
		AppLoginLayer.saveAndLogin( uid, _username,_password)

		layerCloseCallback()
    elseif(errornu == "3") then
      require "script/ui/tip/AlertTip"
      AlertTip.showAlert(GetLocalizeStringBy("key_1411"), nil)
      return
      
    else
      -- SDK91Share:shareSDK91():loginOut()
      require "script/ui/tip/AlertTip"
      AlertTip.showAlert(xmlTable:find("errordesc")[1], nil)
      return
    end

end

-- 初始化
function ininlize()

	_tableView = nil
	_tableViewSp = nil
	_cancelBtn = nil
	_mainLayer = nil
	mainBg = nil
end


function layerCloseCallback( ... )
	_mainLayer:removeFromParentAndCleanup(true)
end

function isRightEmail(str)
    if string.len(str or "") < 6 then return false end
    local b,e = string.find(str or "", '@')
    local bstr = ""
    local estr = ""
    if b then
        bstr = string.sub(str, 1, b-1)
        estr = string.sub(str, e+1, -1)
    else
        return false
    end

    -- check the string before '@'
    local p1,p2 = string.find(bstr, "[%w_]+")
    if (p1 ~= 1) or (p2 ~= string.len(bstr)) then return false end
    
    -- check the string after '@'
    if string.find(estr, "^[%.]+") then return false end
    if string.find(estr, "%.[%.]+") then return false end
    if string.find(estr, "@") then return false end
    if string.find(estr, "[%.]+$") then return false end

    _,count = string.gsub(estr, "%.", "")
    if (count < 1 ) or (count > 3) then
        return false
    end

    return true
end
