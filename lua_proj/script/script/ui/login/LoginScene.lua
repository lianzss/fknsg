-- Filename: LoginScene.lua
-- Author: fang
-- Date: 2013-05-28
-- Purpose: 该文件用于登陆模块

require "script/network/Network"
require "script/utils/BaseUI"
require "script/utils/LuaUtil"
require "script/ui/login/CheckVerionLogic"
require "script/localized/LocalizedUtil"

-- 登陆模块
module ("LoginScene", package.seeall)

local _username

local _server_ip = nil
local _server_port = nil

local _bReconnStatus=false

local _tPlatformUserTable

local _tVersionInfo
local _cmiEnterGame
-- 输入框CC控件
local _ccEditBox = nil

-- 进入游戏的index
_nIndexOfEnterGame=10001
-- 重新连接的index
_nIndexOfReconn=10002

local _curLoginStatus = nil

local _tagOfSelectServer=20001

local _NoticeOpenStatus
local _NoticeOpenDesc

local _bLoginStatus
local _bLoginInServerStatus = false
-- 记录游戏战斗状态
local _bBattleStatus = false

local _bAccountIsBanned = false


local _observersForNetBroken={}
_isLoginAgain = false
-- 为网络断开时增加观察者接口
function addObserverForNetBroken(pKey, pFn)
	if pKey == nil or _observersForNetBroken[pKey] then
		print("Error. ", pKey, " observer exists for net broken.")
		return
	end

	_observersForNetBroken[pKey] = pFn
end

function removeObserverForNetBroken(pKey)
	_observersForNetBroken[pKey] = nil
end

function notifyNetBrokenObservers( ... )
	for k, fn in pairs(_observersForNetBroken) do
		fn(1)
	end
end

-- 为网络连通时增加观察者回调接口
local _observersForNetConnected={}
-- 
function addObserverForNetConnected(pKey, pFn)
	if pKey == nil or _observersForNetConnected[pKey] then
		print("Error. ", pKey, " observer exists for net broken.")
		return
	end

	_observersForNetConnected[pKey] = pFn
end

function removeObserverForNetConnected(pKey)
	_observersForNetConnected[pKey] = nil
end

function notifyNetConnectedObservers( ... )
	for k, fn in pairs(_observersForNetConnected) do
		fn(1)
	end
end


local function getLoginNetworkArgs( ... )
	local args
	if not Platform.isPlatform() then
		args = CCArray:createWithObject(CCInteger:create(tonumber(_username)));
	else
		local userDic = CCDictionary:create()
		for k,v in pairs(_tPlatformUserTable) do
			userDic:setObject(CCString:create(tostring(v)),k)
		end
		args = CCArray:create()
		args:addObject(userDic)
	end
	local sKeyValue = "publish=" .. g_publish_version .. ", script=" .. g_game_version .. ", pl="..Platform.getPlatformFlag() .. ", fixversion=2"
	if(NSBundleInfo)then
		sKeyValue = sKeyValue .. ", sysName=" .. string.urlEncode(NSBundleInfo:getSysName()) .. ", sysVersion=" .. string.urlEncode(NSBundleInfo:getSysVersion()) .. ", deviceModel=" .. string.urlEncode(NSBundleInfo:getDeviceModel())
		if( string.checkScriptVersion(g_publish_version, "3.0.0") >= 0 and Platform.getPlatformFlag() == "appstore" )then
			sKeyValue = sKeyValue .. ", netstatus=" .. NSBundleInfo:getNetworkStatus()
		end
	end
	args:addObject(CCString:create(sKeyValue))

	return args
end

-- 版本号比较方法
function fnVersionCmp(pTv, pSv)
	require "script/utils/LuaUtil"
	local sv = string.splitByChar(pSv, ".")
	local sv1 = tonumber(sv[1])
	local sv2 = tonumber(sv[2])
	local sv3 = tonumber(sv[3])

	local tv = string.splitByChar(pTv, ".")
	local tv1 = tonumber(tv[1])
	local tv2 = tonumber(tv[2])
	local tv3 = tonumber(tv[3])

	local bIsLarger = false
	if tv1 > sv1 then
		bIsLarger = true
	elseif tv2 > sv2 and tv1 >= sv1 then
		bIsLarger = true
	elseif tv3 > sv3 and tv1 >= sv1 and tv2 >= sv2 then
		bIsLarger = true
	end

	return bIsLarger
end

local function gotoDownloadUI( ... )

	require "script/ui/login/UpdateResUI"
	UpdateResUI.showUI(_tVersionInfo.script, _curLoginStatus)
end

-- 检查版本信息的回调
function checkVersionDelegate( statusCode, versionInfos )

	print_t(versionInfos)
	if(statusCode == CheckVerionLogic.Code_Update_Base)then
		-- 更新底包
		require "script/ui/tip/AlertTip"

		local function tipFunc()
			local downloadUrl = "https://itunes.apple.com/cn/app/fang-kai-na-san-guo/id680465449?mt=8"
			if(versionInfos.base.package.packageUrl)then
				downloadUrl = versionInfos.base.package.packageUrl
			end
			print("downloadUrl == ",downloadUrl)
			Platform.openUrl(downloadUrl)
		end 
		AlertTip.showAlert(GetLocalizeStringBy("key_1223"),tipFunc, false, nil, GetLocalizeStringBy("key_1663"))
		return
	elseif(statusCode == CheckVerionLogic.Code_Update_Script)then
		-- 更新脚本
		_tVersionInfo = versionInfos
		handleAfterCheckVersion(true)
		
	elseif(statusCode == CheckVerionLogic.Code_Update_None)then
		-- 不更新
		handleAfterCheckVersion(false)
		
	else
		-- 出错脚本
		print("error: 请求出错或者 Web端出错，返回参数格式不对 error_id==", statusCode)
		local function tipFunc()
			fnCheckGameVersion(_curLoginStatus)
		end 
		require "script/ui/tip/AlertTip"
		AlertTip.showAlert(GetLocalizeStringBy("key_1376"),tipFunc, false, nil, GetLocalizeStringBy("key_1465"))
	end
end

-- https://itunes.apple.com/cn/app/fang-kai-na-san-guo/id680465449?mt=8
function fnCheckGameVersion( login_status)
	_curLoginStatus = login_status
	if(g_debug_mode == true)then
		-- 不更新
		handleAfterCheckVersion(false)
	else
		-- 检查版本信息
		CheckVerionLogic.startCheckVersion(checkVersionDelegate)
	end

end

local function handlerOfEnterGame( ... )
	-- if _bLoginStatus then
	-- 	return
	-- end

	print("handlerOfEnterGame begin:",_bLoginStatus)
	if _bLoginStatus==true then
		return
	end
	_bAccountIsBanned = false
	_bLoginStatus = true

	if _ccEditBox then
		_username = _ccEditBox:getText()
		Platform.setPid(tonumber(_username))
	end
	require "script/audio/AudioUtil"
    AudioUtil.playEffect("audio/effect/zhujiemian.mp3")


	fnCheckGameVersion(_nIndexOfEnterGame)

end

function handleAfterCheckVersion(pStatus)
	-- BTEventDispatcher:getInstance():addLuaHandler("failed", netWorkFailed, false)
	Network.re_rpc(netWorkFailed, "failed")	
	if pStatus then
		if _bReconnStatus then
			local curScene = CCDirector:sharedDirector():getRunningScene()
	    	curScene:removeAllChildrenWithCleanup(true) -- 删除当前场景的所有子节点
	    	CCTextureCache:sharedTextureCache():removeUnusedTextures() -- 清除所有不用的纹理资源
		end
		_bReconnStatus = false
		gotoDownloadUI()
	else
		if _bReconnStatus then
			if(Platform.getOS() ~= "wp")then
				BTEventDispatcher:getInstance():removeAll() -- 重置事件派发队列
				PackageHandler:setToken("0") -- 重置网络连接的 token
			end
			Network.re_rpc(netWorkFailed, "failed")

			if g_debug_mode then
				if Network.connect(_server_ip, _server_port) then
			       require "script/network/user/UserHandler"
			       local args = getLoginNetworkArgs()
			       Network.rpc (UserHandler.login, "user.login", "user.login", args, true)
				else
			    	local tArgs = {}
					tArgs.text = GetLocalizeStringBy("key_1359")
					tArgs.callback = loginAgain
					AlertTip.showNoticeDialog(tArgs)    
				end
			else
				loginLogicServer()
			end
		else
			loginGame()
		end
	end
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	local tmpNode = CCNode:create()
	tmpNode:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(1), CCCallFunc:create(function ( ... )
		--设置登陆状态
	_bLoginStatus = false
	end)))
	runningScene:addChild(tmpNode)
end

function loginAgain(pIndex)
	_G["g_network_status"] = g_network_connecting
	_bReconnStatus = false
	if pIndex == 1 then
	    require "script/ui/main/BulletinLayer"
	    BulletinLayer.release()
	    require "script/ui/main/MenuLayer"
	    MenuLayer.release()
	    require "script/ui/main/MainScene"
	    MainScene.release()
	    require "script/ui/main/MainBaseLayer"
	    MainBaseLayer.exit()
	    
	    enter()
	    _bLoginInServerStatus = false
	elseif pIndex == 2 then
		_bReconnStatus = true
		_isLoginAgain = true
		require "script/audio/AudioUtil"
		AudioUtil.initAudioInfo()
		fnCheckGameVersion(_nIndexOfReconn)
	end
    
    SimpleAudioEngine:sharedEngine():pauseAllEffects()
    SimpleAudioEngine:sharedEngine():resumeAllEffects()
end

-- 显示重新连接对话框
local function showReconnectDialog( message )
	if g_network_status ~= g_network_disconnected then
		return
	end

	require "script/ui/network/LoadingUI"
    LoadingUI.stopLoadingUI()
	--清理聊天特效
    require "script/ui/main/MainBaseLayer"
    MainBaseLayer.showChatAnimation(false)  
    local tArgs = {}
    tArgs.text = GetLocalizeStringBy("key_1359")
    if message ~= nil then
        tArgs.title = message
    end
    tArgs.callback = loginAgain
    require "script/ui/tip/AlertTip"
    AlertTip.showNoticeDialog(tArgs)
    
    SimpleAudioEngine:sharedEngine():pauseAllEffects()
    SimpleAudioEngine:sharedEngine():resumeAllEffects()
end

-- local _count = 0

function netWorkFailed(message)
	_G["g_network_status"] = g_network_disconnected
	if _bAccountIsBanned then
		-- BTEventDispatcher:getInstance():removeAll() -- 重置事件派发队列
		-- PackageHandler:setToken("0") -- 重置网络连接的 token
	else
		notifyNetBrokenObservers()
		local runningScene = CCDirector:sharedDirector():getRunningScene()
		local tmpNode = CCNode:create()

		tmpNode:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.03), CCCallFunc:create(function ( ... )
			if(Platform.getOS() ~= "wp")then
				BTEventDispatcher:getInstance():removeAll() -- 重置事件派发队列
				PackageHandler:setToken("0") -- 重置网络连接的 token
			end
		end)))
		runningScene:addChild(tmpNode)
		
	    if _bBattleStatus == false then
	    	showReconnectDialog(message)
	   	end
	end
end

local function createBgLayer( ... )
	local bg_layer = CCLayer:create()
	if(g_winSize.height == 2048 )then
		local bg = CCSprite:create("images/login/retina_bg.jpg")
		bg:setPosition(ccp(g_winSize.width/2, g_winSize.height/2))
		bg:setAnchorPoint(ccp(0.5, 0.5))
		bg_layer:addChild(bg)
		-- setAllScreenNode(bg)

		local bg2 = CCSprite:create("images/login/retina_bg2.png")
		bg2:setPosition(ccps(0.5, 0.5))
		bg2:setAnchorPoint(ccp(0.5, 0.5))
		bg_layer:addChild(bg2)
		-- setAdaptNode(bg2)
	else
		local bg = CCSprite:create("images/login/bg.jpg")
		bg:setPosition(ccp(g_winSize.width/2, g_winSize.height/2))
		bg:setAnchorPoint(ccp(0.5, 0.5))
		bg_layer:addChild(bg)
		setAllScreenNode(bg)

		local bg2 = CCSprite:create("images/login/bg2.png")
		bg2:setPosition(ccps(0.5, 0.5))
		bg2:setAnchorPoint(ccp(0.5, 0.5))
		bg_layer:addChild(bg2)
		setAdaptNode(bg2)
	end

	return bg_layer
end

local function init( ... )
	_bLoginStatus = false
	_bReconnStatus = false
	_G.g_network_status = g_network_disconnected
	_bAccountIsBanned = false
end


-- 进入模块
function enter( ... )
	init()
	local scene = CCDirector:sharedDirector():getRunningScene()
    if scene then
    	scene:removeAllChildrenWithCleanup(true)	-- 删除当前场景的所有子节点
    	CCTextureCache:sharedTextureCache():removeUnusedTextures()	-- 清除所有不用的纹理资源
    else
    	scene = CCScene:create()
    	CCDirector:sharedDirector():runWithScene(scene)
    end
	require "script/ui/login/DownloadUI"
	DownloadUI.fnReleaseLogicMods()
	if(Platform.getOS() ~= "wp")then
		BTEventDispatcher:getInstance():removeAll() -- 重置事件派发队列
		PackageHandler:setToken("0") -- 重置网络连接的 token
	end
	BTUtil:setGuideState(false)
	require "script/guide/NewGuide"
	NewGuide.guideClass = ksGuideClose

    require "script/Platform"
    local login_layer = CCLayer:create()
    if not Platform.isPlatform() then
    	_ccEditBox = CCEditBox:create (CCSizeMake(400*g_fElementScaleRatio,60*g_fElementScaleRatio), CCScale9Sprite:create("images/test/green_edit.png"))
		_ccEditBox:setPosition(ccp(g_winSize.width/2, 370*g_fScaleY))
		_ccEditBox:setAnchorPoint(ccp(0.5, 0.5))
		_ccEditBox:setPlaceHolder(GetLocalizeStringBy("key_2621"))
		_ccEditBox:setPlaceholderFontColor(ccc3(0xdd, 0xdd, 0xdd))
		_ccEditBox:setMaxLength(13)
		_ccEditBox:setReturnType(kKeyboardReturnTypeDone)
		_ccEditBox:setInputFlag (kEditBoxInputFlagInitialCapsWord)
		_ccEditBox:setText(CCUserDefault:sharedUserDefault():getStringForKey("uid"))
		login_layer:addChild(_ccEditBox)
	else
		require "script/ui/login/ServerList"
	end

    local menu = CCMenu:create()
    menu:setPosition(0,0)
    login_layer:addChild(menu)

    -- 进入游戏按钮
    _cmiEnterGame=CCMenuItemImage:create("images/login/enter_n.png", "images/login/enter_h.png")
    _cmiEnterGame:setScale(g_fElementScaleRatio)
    _cmiEnterGame:setPosition(ccps(0.5, 0.1))
    _cmiEnterGame:setAnchorPoint(ccp(0.5, 0.5))
    _cmiEnterGame:registerScriptTapHandler(handlerOfEnterGame)
    menu:addChild(_cmiEnterGame)
    local bg = createBgLayer()

    scene:addChild(bg)
    scene:addChild(login_layer)

    --增加返回键监听
    local backClickLayer = CCLayer:create()
	scene:addChild(backClickLayer)
    local function KeypadHandler(strEvent)
        if "backClicked" == strEvent then
        	require "script/Platform"
            Platform.exitSDK()
           	--CCDirector:sharedDirector():endToLua()
        elseif "menuClicked" == strEvent then
--            Platform.exit()
--            CCDirector:sharedDirector():endToLua()
        end
    end
    backClickLayer:setKeypadEnabled(true)
    backClickLayer:registerScriptKeypadHandler(KeypadHandler)
    
    --增加背景音乐
    require "script/audio/AudioUtil"
    AudioUtil.playBgm("audio/main.mp3")
    bg:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.03), CCCallFunc:create(Platform.getServerList)))

    if(Platform.isAppStore() == true or Platform.isZYXSdk() == true)then
    	-- if not g_debug_mode then
    	-- 	_G.g_dev_udid = UDID:getUDID()
    	-- end
    	createAppLoginButton(scene)
    elseif(Platform.getConfig().getFlag() == "huaqing")then
    	createHuaqingButton(scene)
    end
    -- if(Platform.isZuiyouxi() == true)then
    -- 	createAppLoginButton(scene)
    -- 	print("最游戏平台-----创建注册按钮")
    -- end
    --拉去服务器列表
end

function loginGame( ... )
	--记忆上次登录的服务器
	CCUserDefault:sharedUserDefault():setStringForKey("lastLoginGroup",selectServerInfo.group)
	CCUserDefault:sharedUserDefault():flush()
	print(GetLocalizeStringBy("key_2496"),selectServerInfo.group)
	ServerList.addRecentServerGroup(selectServerInfo.group)

	require "script/ui/main/GameNotice02"
	GameNotice02.fetchNotice02FromServer(selectServerInfo.group)

	require "script/GlobalVars"
	_G["g_network_status"] = g_network_connecting
	--设置为最近登陆的服务器
	require "script/Platform"
	if not Platform.isPlatform() then
		if (#_username == 0) then
			return
		end
		CCUserDefault:sharedUserDefault():setStringForKey("uid", tostring(_username))
		CCUserDefault:sharedUserDefault():flush()

		_server_ip 	= selectServerInfo["host"]
		_server_port = selectServerInfo["port"]
		require "script/network/Network"
		print("_server_ip: ", _server_ip, ", _server_port: ", _server_port)
		if Network.connect(_server_ip, _server_port) then
	    	require "script/network/user/UserHandler"

 	    	local args = CCArray:createWithObject(CCString:create(tostring(_username)));
 	    	local sKeyValue = "publish=" .. g_publish_version .. ", script=" .. g_game_version .. ", pl="..Platform.getPlatformFlag() .. ", fixversion=2"
 	    	if(NSBundleInfo)then
				sKeyValue = sKeyValue .. ", sysName=" .. string.urlEncode(NSBundleInfo:getSysName()) .. ", sysVersion=" .. string.urlEncode(NSBundleInfo:getSysVersion()) .. ", deviceModel=" .. string.urlEncode(NSBundleInfo:getDeviceModel())
				if( string.checkScriptVersion(g_publish_version, "3.0.0") >= 0 and Platform.getPlatformFlag() == "appstore" )then
					sKeyValue = sKeyValue .. ", netstatus=" .. NSBundleInfo:getNetworkStatus()
				end
			end
			args:addObject(CCString:create(sKeyValue))

	    	Network.rpc (UserHandler.login, "user.login", "user.login", args, true)
	    else
	    	require "script/ui/tip/AlertTip"
	    	AlertTip.showAlert(GetLocalizeStringBy("key_2847"), function ( ... )
	    		require "script/Platform"
	   			Platform.quit()
			end)
	    end
	else			
		local pid = Platform.getPid()
		print("pid=",pid)
		if(pid == nil)then
			Platform.login(loginGame)
			return
		end
		if(not Platform.isDebug())then
	        LoginScene.loginLogicServer(pid)
	     else
	        local serverInfo = ServerList.getSelectServerInfo()
	        serverInfo.pid=pid
	        LoginScene.loginInServer(serverInfo)
	     end
	end
end

function setReconnStatus(pStatus)
	_bReconnStatus = pStatus
end

function createUser()
	-- 1/2, man/female
	local args = CCArray:createWithObject(CCString:create("2"))
	args:addObject (CCString:create(tostring(_username)))
	print(_username)
	require "script/network/user/UserHandler"
	-- 调用“创建英雄”接口
	Network.rpc(UserHandler.createUser,"user.createUser", "user.createUser", args, true)
end

function setUserInfo(userInfo)
--    BTEventDispatcher:getInstance():addLuaHandler("failed", netWorkFailed, false)

    -- 在取得功能节点之后获得武将战斗力信息
    local function fnAfterGetSwitchInfo( ... )
        require "script/network/RequestCenter"
        RequestCenter.hero_getAllHeroes(function ( cbFlag, dictData, bRet )
        	-- 处理获取所有英雄回调
		    if (bRet == true and cbFlag == "hero.getAllHeroes") then
		        require "script/model/hero/HeroModel"
		        HeroModel.setAllHeroes(dictData.ret)
			    enterGame()
		    end
        end)
    end
    ---------- 开始拉数据 -------
    require "script/network/PreRequest"
    PreRequest.startPreRequest(fnAfterGetSwitchInfo)

end

local _bNotOvertureStatus = false
function enterGame( ... )
	_G["g_network_status"] = g_network_connected
	notifyNetConnectedObservers()
	-- added by zhz
    require "script/model/user/UserModel"
    require "script/ui/upgrade_tip/UpgradeLayer"
    UserModel.addObserverForLevelUp("UpgradeLayer", UpgradeLayer.createLayer)

	local runningScene = CCDirector:sharedDirector():getRunningScene()
	require "script/battle/BattleLayer"
	require "script/model/user/UserModel"
    if(UserHandler.isNewUser == true and not _bNotOvertureStatus) then
    	
--	if UserHandler.isNewUser then
    	function enterBattle( ... )
    		--通知Platfrorm层用户 跳过剧情,进入首个副本
    		require "script/Platform"
    		Platform.sendInformationToPlatform(Platform.kOutOfStoryLine)

    		runningScene:removeAllChildrenWithCleanup(true)
	    	local battleCallback = function ( ... )
	    		
	    		require "script/ui/main/MainScene"
	    		print(GetLocalizeStringBy("key_2747"))

				MainScene.enter()
	   	 	end
	    	BattleLayer.enterBattle(1, 1001, 0, battleCallback ,1)
    	end
    	runningScene:removeAllChildrenWithCleanup(true)

    	require "script/ui/create_user/SelectUserLayer"
    	local sexNumber = SelectUserLayer.getUserSex()
    	local sexBool   = true
    	if(tonumber(sexNumber) == 1) then
    		sexBool = false
    	elseif(sexNumber == 2) then
    		sexBool = true
    	end
    	print("enter overture layer")
    	require "script/guide/overture/BattleLayerLee"
    	BattleLayerLee.enterBattle(nil,1,0,function ( ... )
    		enterBattle()
    	end,1)
    	_bNotOvertureStatus = true
    else
    	if _bReconnStatus == false then
    		-- add by licong 2013.10.23
    		-- 判断是否通关第一个据点
    		require "script/guide/NewGuide"
    		NewGuide.getOneCopyStatus()
		else
			require "script/network/RequestCenter"
			RequestCenter.ncopy_getAtkInfoOnEnterGame(function ( ... )
				-- body
			end, nil)
		end
    end
end

function setNotice(pOpen, pDesc)
	_NoticeOpenStatus = pOpen
	_NoticeOpenDesc = pDesc
end

local function showNotice( ... )
	if _NoticeOpenDesc and _NoticeOpenStatus and tonumber(_NoticeOpenStatus) > 0 then
		require "script/ui/tip/AlertTip"
		AlertTip.showAlert(_NoticeOpenDesc, function ()
		            
	    end)
	end
end

local serverListPanel = nil
function createSelectServer( ... )

	require "script/ui/rewardCenter/AdaptTool"
	if(serverListPanel == nil) then
		-- 显示运营公告
		showNotice()
		local serverBg = CCScale9Sprite:create("images/login/ng_button_n.png")
		serverBg:setContentSize(CCSizeMake(368,50))
		serverBg:setAnchorPoint(ccp(0.5, 0.5))
		serverBg:setPosition(g_winSize.width/2, g_winSize.height * 0.2)
		AdaptTool.setAdaptNode(serverBg)

		serverBg:registerScriptHandler(function ( eventType )
			if(eventType == "exit") then
				serverListPanel = nil
			end
		end)

		serverListPanel = CCNode:create()
		serverListPanel:setContentSize(CCSizeMake(serverBg:getContentSize().width, serverBg:getContentSize().height))
		serverListPanel:setPosition(serverBg:getContentSize().width/2, serverBg:getContentSize().height/2)
		serverListPanel:setAnchorPoint(ccp(0.5, 0.5))
		serverBg:addChild(serverListPanel)

		local curScene = CCDirector:sharedDirector():getRunningScene()
		curScene:addChild(serverBg, 0, _tagOfSelectServer)
	end
	serverListPanel:removeAllChildrenWithCleanup(true)
	if(selectServerInfo == nil) then
		selectServerInfo = ServerList.getSelectServerInfo()
	end

	local serverNameLabel = CCLabelTTF:create(selectServerInfo.name, g_sFontName, 24)
	serverNameLabel:setAnchorPoint(ccp(0, 0.5))
	serverNameLabel:setPosition(10, serverListPanel:getContentSize().height * 0.5)
	serverListPanel:addChild(serverNameLabel)

	if(tonumber(selectServerInfo.hot) == 1) then
		local hotSprite = CCSprite:create("images/login/hot.png")
		hotSprite:setAnchorPoint(ccp(0, 1))
		hotSprite:setPosition(18 + serverNameLabel:getContentSize().width, serverListPanel:getContentSize().height )
		serverListPanel:addChild(hotSprite)	
	end

	if(tonumber(selectServerInfo.new) == 1) then
		local newSprite = CCSprite:create("images/login/new.png")
		newSprite:setAnchorPoint(ccp(0, 1))
		newSprite:setPosition(18+ serverNameLabel:getContentSize().width, serverListPanel:getContentSize().height )
		serverListPanel:addChild(newSprite)
	end

	local menu = CCMenu:create()
	menu:setPosition(ccp(0, 0))
	menu:setAnchorPoint(ccp(0, 0))
	serverListPanel:addChild(menu)

	local buttonLabel = CCLabelTTF:create(GetLocalizeStringBy("key_1320"), g_sFontName, 24)
	buttonLabel:setColor(ccc3(0xff, 0x95, 0x23))
	local selectServerButton = CCMenuItemLabel:create(buttonLabel)
	selectServerButton:setPosition(ccp(serverListPanel:getContentSize().width * 0.95, serverListPanel:getContentSize().height * 0.5))
	selectServerButton:setAnchorPoint(ccp(1,0.5))
	menu:addChild(selectServerButton)
	selectServerButton:registerScriptTapHandler(selectServerButtonCallback)

end

function setSelectInfo(server_info)
	selectServerInfo = server_info
	-- serverNameLabel:setString(selectServerInfo.name) 
	createSelectServer()

end

function selectServerButtonCallback( tag,sender )
	local curScene = CCDirector:sharedDirector():getRunningScene()
	local serverLayer = ServerList.create()
	curScene:addChild(serverLayer, 500)
end


-- 网络参数 CCArray类型
function loginInServer( user_table )
	-- Network.connect("122.49.42.78", 8301) 外网服务器
	--记忆上次登录的服务器
	CCUserDefault:sharedUserDefault():setStringForKey("lastLoginGroup",selectServerInfo.group)
	CCUserDefault:sharedUserDefault():flush()
	print("设置为最近登陆的服务器:",selectServerInfo.group)
	ServerList.addRecentServerGroup(selectServerInfo.group)
		
	_tPlatformUserTable = user_table

	print("user_table.host:", user_table.host)
	print("user_table.port:", user_table.port)
	_server_ip = user_table.host
	_server_port = user_table.port
	require "script/network/Network"
	if Network.connect(_server_ip, _server_port) then
		_bLoginInServerStatus = true
		local args = getLoginNetworkArgs()
		require "script/network/user/UserHandler"
		Network.rpc (UserHandler.login, "user.login", "user.login", args, true)
	else
		require "script/ui/tip/AlertTip"
		AlertTip.showAlert(GetLocalizeStringBy("key_1047"))
	end
	require "script/Platform"
	Platform.sendInformationToPlatform(Platform.kEnterGameServer)
    Platform.initPlGroup()
end
 
--登陆逻辑服务器
function loginLogicServer( pid )
	-- 从服务器拉去登陆数据
	pid = pid or Platform.getPid()
	local url = "http://mapifknsg.zuiyouxi.com/phone/getHash/?&group_id=" .. selectServerInfo["group"] .. "&pid=" .. pid
	print("getHash request url:" .. url)
	if(Platform.getPlatformUrlName() == "Android_zyx")then	
		local uuid = Platform.getSdk():callStringFuncWithParam("getUuid",nil)
	 	if(uuid ~= nil)then
	 	   url = url  .. "&uuid=" .. uuid
	    end
	end
	LoadingUI.addLoadingUI()
	local httpClent = CCHttpRequest:open(url, kHttpGet)
	httpClent:sendWithHandler(function(res, hnd)
		require "script/ui/network/LoadingUI"
		LoadingUI.reduceLoadingUI()
		if(res:getResponseCode()~=200)then
        	require "script/ui/tip/AlertTip"
        	AlertTip.showAlert( GetLocalizeStringBy("key_1810"), nil, false, nil)
        	return
    	end

		local loginJsonString = res:getResponseData()
		print("loginJsonString:" .. loginJsonString)
		local cjson = require "cjson"
        local loginInfo = cjson.decode(loginJsonString)
        print_t(loginInfo)
		loginInServer( loginInfo )
	end)
end

-- 设置游戏战斗状态
function setBattleStatus(pStatus)
	_bBattleStatus = pStatus
	if _bBattleStatus == false then
		showReconnectDialog()
	end
end

local function fnHanlderOfServer( ... )
	enter()
end

-- 服务器与平台链接无效了
function fnServerIsTimeout( ... )
	require "script/ui/tip/AlertTip"
	AlertTip.showAlert(GetLocalizeStringBy("key_3137"), fnHanlderOfServer, false)
end
-- 服务器已满
function fnServerIsFull( ... )
	require "script/ui/tip/AlertTip"
	AlertTip.showAlert(GetLocalizeStringBy("key_2944"), fnHanlderOfServer, false)
end

--appstore 登陆注册按钮
function createAppLoginButton( curScene )

	local menu =CCMenu:create()
	menu:setPosition(ccp(0,0))
	-- menu:setTouchPriority(-551)
	curScene:addChild(menu)

	local text = ""
	-- config = require "script/config/config_apple"
	print ("Platform.getConfig().getLoginState() ",Platform.getConfig().getLoginState() )
	print("Platform.getConfig().kLoginsStateNotLogin",Platform.getConfig().kLoginsStateNotLogin)
	if(Platform.getConfig().getLoginState() == Platform.getConfig().kLoginsStateNotLogin)then
		text = GetLocalizeStringBy("key_1023")
	elseif(Platform.getConfig().getLoginState() == Platform.getConfig().kLoginsStateUDIDLogin)then
		text = GetLocalizeStringBy("key_2439")
	elseif(Platform.getConfig().getLoginState() == Platform.getConfig().kLoginsStateZYXLogin)then
		-- require "script/ui/login/AppLoginLayer"
  --       local username = CCUserDefault:sharedUserDefault():getStringForKey("username")
  --       local password = CCUserDefault:sharedUserDefault():getStringForKey("password")
  --       AppLoginLayer.loginWithUserNameInfo(username, password, false);

		text = CCUserDefault:sharedUserDefault():getStringForKey("username")

	end

	local norSprite = CCScale9Sprite:create("images/login/ng_button_n.png")
	norSprite:setContentSize(CCSizeMake(368,50))
	local higSprite = CCScale9Sprite:create("images/login/ng_button_h.png")
	higSprite:setContentSize(CCSizeMake(368,50))

	btn_renewPass = CCMenuItemSprite:create(norSprite,higSprite)

	-- btn_renewPass = LuaCC.create9ScaleMenuItem("images/login/ng_button_n.png","images/login/ng_button_n.png",CCSizeMake(368,50),text,ccc3(255,255,255))
    btn_renewPass:setAnchorPoint(ccp(0.5, 0.5))
    btn_renewPass:setPosition(g_winSize.width*0.5, 76*2)
	menu:addChild(btn_renewPass)
	btn_renewPass:registerScriptTapHandler(gotoUserCenter)
	btn_renewPass:setPosition(g_winSize.width/2, g_winSize.height * 0.3)

	userNameLabel = CCLabelTTF:create(text, g_sFontName, 24)
	userNameLabel:setAnchorPoint(ccp(0.5, 0.5))
	userNameLabel:setPosition(norSprite:getContentSize().width*0.5, norSprite:getContentSize().height * 0.5)
	btn_renewPass:addChild(userNameLabel)
	btn_renewPass:setScale(g_fElementScaleRatio)
end

function createHuaqingButton( curScene )
	function clicked( ... )
		Platform.openUrl("http://a.wap.myapp.com/and2/s?aid=detail&appid=50801")
	end

	local menu =CCMenu:create()
	menu:setPosition(ccp(0,0))
	curScene:addChild(menu)

    _yyb=CCMenuItemImage:create("images/login/yyb.png", "images/login/yyb.png")
    _yyb:setScale(2.0)
    _yyb:setPosition(g_winSize.width/2, g_winSize.height * 0.95)
    _yyb:setAnchorPoint(ccp(0.5, 0.5))
    _yyb:registerScriptTapHandler(clicked)
    menu:addChild(_yyb)
end

function changeUserName( text )
	userNameLabel:setString(text)
end

function gotoUserCenter( )
	if(Platform.getConfig().getLoginState() == Platform.getConfig().kLoginsStateNotLogin)then
		-- local udid = UDID:getUDID()
		require "script/ui/login/AppLoginLayer"
    	AppLoginLayer.createLoginLayer();
	elseif(Platform.getConfig().getLoginState() == Platform.getConfig().kLoginsStateUDIDLogin)then
		require "script/ui/login/AppLoginLayer"
    	AppLoginLayer.createLoginLayer();
	elseif(Platform.getConfig().getLoginState() == Platform.getConfig().kLoginsStateZYXLogin)then
		require "script/ui/login/AppLoginLayer"
    	AppLoginLayer.createLoginLayer();
	end
end

function fnIsBanned(pBanInfo)
	print("fnIsBannedfnIsBannedfnIsBanned")
	_bAccountIsBanned = true
	if pBanInfo and pBanInfo.msg then
		require "script/ui/network/LoadingUI"
		require "script/utils/TimeUtil"
		LoadingUI.stopLoadingUI()
		local time_tip =  GetLocalizeStringBy("cl_1000", TimeUtil.getTimeFormatChnYMDHM(pBanInfo.time))
		print("time_tip==", time_tip)
		require "script/ui/tip/AlertTip"
		AlertTip.showAlert(pBanInfo.msg .. "\n" .. time_tip, fnHanlderOfServer, false)
	end
end
