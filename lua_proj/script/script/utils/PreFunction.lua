-- Filename：	PreFunction.lua
-- Author：		Cheng Liang
-- Date：		2014-6-16
-- Purpose：		需要常驻内存或提前加载的方法和模块

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    
    printR("---------------PreFunction-------------------------")
    printR("LUA ERROR: " .. tostring(msg) .. "\n")
    printR(debug.traceback())
    printR("-------------------debug.getinfo---------------------")
    local debug_info = debug.getinfo(3, "Sln")
    print_t(debug_info)
    printR("-------------End----------------------")
    local file_name = "123"
    if( table.isEmpty(debug_info)==false and debug_info.what == "Lua")then
        local infoArr = string.split(debug_info.source, "/")
        file_name = infoArr[#infoArr] .. "_" .. debug_info.currentline
    end

    require "script/utils/ErrorReport"
    ErrorReport.luaErrorReport(msg, file_name)

    if not g_debug_mode then
        return
    end
    require "script/ui/tip/AlertTip"
    AlertTip.showAlert(tostring(msg), nil, false, nil)
   
end