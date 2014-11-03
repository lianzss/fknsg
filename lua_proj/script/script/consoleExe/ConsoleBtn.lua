-- Filename：	ConsoleBtn.lua
-- Author：		zhz
-- Date：		2013-6-14
-- Purpose：		控制台按钮

module ("ConsoleBtn", package.seeall)
require("script/consoleExe/ConsoleLayer")

local IMG_PATH = "images/level_reward/"

 function ConsoleBtnCb(tag, itemBtn)
	local consoleLayer = ConsoleLayer.createLayer()
	MainScene.changeLayer(consoleLayer, "consoleLayer")
end


 function createConsoleBtn(bglayer)
 	local menu = CCMenu:create()
 	menu:setPosition(ccp(0,0))
 	bglayer:addChild(menu)

 	local ConsoleBtn = CCMenuItemImage:create("images/common/question_mask.png", "images/common/question_mask.png")
 	--position changed by zhang zihang
 	ConsoleBtn:setPosition(ccp(bglayer:getContentSize().width/2/g_fElementScaleRatio,bglayer:getContentSize().height/2/g_fElementScaleRatio))
 	ConsoleBtn:setAnchorPoint(ccp(0.5,0))
 	menu:addChild(ConsoleBtn)
 	ConsoleBtn:registerScriptTapHandler(ConsoleBtnCb)
    
    local relogin = CCMenuItemImage:create("images/common/question_mask.png", "images/common/question_mask.png")
 	relogin:setPosition(ccp(bglayer:getContentSize().width/2/g_fElementScaleRatio - 100, bglayer:getContentSize().height/2/g_fElementScaleRatio))
 	relogin:setAnchorPoint(ccp(0.5,0))
 	--menu:addChild(relogin)
 	relogin:registerScriptTapHandler(callbackRelogin)
 end

function callbackRelogin()
    -- require "script/utils/AutoLoadModule"
    -- AutoLoadModule.closeAutoLoadModule()
    print("删除modeule中")
    require "script/ModulePaths"
    local module_paths = ModulePaths.getModulePaths()
    for k, v in pairs(module_paths) do
        if _G[k] ~= nil then
            _G[k] = nil
            package.loaded[k] = nil
            package.loaded[v] = nil
            print(k, "=", v)
        end
    end
    print("删除完毕")
    -- require "script/utils/AutoLoadModule"
    -- AutoLoadModule.openAutoLoadModule()
    require "script/ui/login/LoginScene"
    LoginScene.enter()
end