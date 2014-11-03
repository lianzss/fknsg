 
-- Filename：	LuaUtil.lua
-- Author：		Cheng Liang
-- Date：		2013-5-17
-- Purpose：		Lua的通用工具方法




-- 打印出tbl的所有(key, value)
-- 该函数主要功能是自动计算缩进层次打印出table内容
-- added by fang. 2013-05-30

local tab_indent_count = 0
function print_table (tname, tbl)
    if not g_debug_mode then
        return
    end
    if (tname == nil or tbl == nil) then
        print ("Error, in LuaUtil.lua file. You must pass \"table name\" and \"table`s data\" to print_table function.")
        return
    end
    local tabs = ""
    for i = 1, tab_indent_count do
        tabs = tabs .. "    "
    end
    local param_type = type(tbl)
    if param_type == "table" then
        for k, v in pairs(tbl) do
            -- 如果value还是一个table，则递归打印其内容
            if (type(v) == "table") then
                print (string.format("T %s.%s", tabs, k))
                -- 子table加一个tab缩进
                tab_indent_count = tab_indent_count + 1
                print_table (k, v)
                -- table结束，则退回一个缩进
                tab_indent_count = tab_indent_count - 1
            elseif (type(v) == "number") then
                print (string.format("N %s.%s: %d", tabs, k, v))
            elseif (type(v) == "string") then
                print (string.format("S %s.%s: \"%s\"", tabs, k, v))
            elseif (type(v) == "boolean") then
                print (string.format("B %s.%s: %s", tabs, k, tostring(v)))
            elseif (type(v) == "nil") then
                print (string.format("N %s.%s: nil", tabs, k))
            else 
                print (string.format("%s%s=%s: unexpected type value? type is %s", tabs, k, v, type(v)))
            end
        end
    end
end

function printTable(tname, tbl)
    if(tname) then
        print("----------------------------[ " .. tname .. " ]-------------------------")
    end
    print_table(tname, tbl)
end


---------------------------------------- table 方法 ---------------------------------------
-- added by fang. 2013.07.12
-- 增加一个表硬拷贝函数，把t_data表里的数据拷到t_dest中
-- 目的：确保数据拷贝成功（硬拷贝），防止函数返回指针，在指针引用计数为零时lua变量指向野指针引起异常
-- 建议：不建议使用，理论上是不应该出现这种问题的，由于组内个别成员提出了可能有这种灵异事件，因此写个函数确保，也可以测试。
---         有谁发现确实有这种情况，请告诉我一下。
-- @params, t_data: 数据表，t_dest：目标数据表
-- @return, 调用者可不接收返回值
table.hcopy = function(t_data, t_dest)
    if (type(t_dest) ~= "table") then
        print ("Error, t_dest table must be table type.")
        return nil
    end
    local mt = getmetatable(t_data)
    if mt then
        setmetatable(t_dest, mt)
    end
    for k, v in pairs(t_data) do
        if (type(v) == "table") then
            t_dest[k] = {}
            table.hcopy(v, t_dest[k])
        else
            t_dest[k] = v
        end
    end
    return t_dest
end

-- 判断一个table是否为空 是 nil 或者 长度为0 （非table 返回 true）
table.isEmpty = function (t_data)
    local isEmpty = false
    if(type(t_data) ~= "table") then
        isEmpty = true
    else
        local length = 0
        for k,v in pairs(t_data) do
            length = length + 1
            break
        end
        if (length == 0) then
            isEmpty = true
        end
    end
    return isEmpty
end

-- 获得所有的key
table.allKeys = function ( t_table )
    local tmplTable = {}
    if( not table.isEmpty(t_table)) then
        for k,v in pairs(t_table) do
            
            table.insert(tmplTable, k)
        end
    end

    return tmplTable
end

--得到table中所有元素的个数
-- added by lichengyang on 2013-08-13
table.count = function ( t_table )
    if type(t_table) ~= "table" then
        return 0
    end
    local tNum = 0
    for k,v in pairs(t_table) do
        tNum = tNum + 1
    end
    return tNum
end
-- added by fang. 2013.08.20
-- 颠倒一个数组类型的table
table.reverse = function (tArray)
    if tArray == nil or #tArray == 0 then
        return nil
    end
    local tArrayReversed = {}
    local nArrCount = #tArray
    for i=1, nArrCount do
        tArrayReversed[i] = tArray[nArrCount-i+1]
    end

    return tArrayReversed
end

--add by lichenyang
--把一个table序列号成一个字符串
table.serialize = function(obj)
    local lua = ""
    local t = type(obj)
    if t == "number" then
        lua = lua .. obj
    elseif t == "boolean" then
        lua = lua .. tostring(obj)
    elseif t == "string" then
        lua = lua .. string.format("%q", obj)
    elseif t == "table" then
        lua = lua .. "{\n"
    for k, v in pairs(obj) do
        lua = lua .. "[" .. table.serialize(k) .. "]=" .. table.serialize(v) .. ",\n"
    end
    local metatable = getmetatable(obj)
        if metatable ~= nil and type(metatable.__index) == "table" then
        for k, v in pairs(metatable.__index) do
            lua = lua .. "[" .. table.serialize(k) .. "]=" .. table.serialize(v) .. ",\n"
        end
    end
        lua = lua .. "}"
    elseif t == "nil" then
        return nil
    else
        error("can not serialize a " .. t .. " type.")
    end
    return lua
end

--add by lichenyang
--把一个序列化的字符串转换成一个lua table 此方法和table.serialize对应
table.unserialize = function (lua)
    local t = type(lua)
    if t == "nil" or lua == "" then
        return nil
    elseif t == "number" or t == "string" or t == "boolean" then
        lua = tostring(lua)
    else
        error("can not unserialize a " .. t .. " type.")
    end
    lua = "return " .. lua
    local func = loadstring(lua)
    if func == nil then
        return nil
    end
    return func()
end

-----------------------------------string 类方法增加-----------------------------

-- 参数:待分割的字符串,分割字符
-- 返回:子串表.(含有空串)
function lua_string_split(str, split_char)
    local sub_str_tab = {}
    while (true) do
        local pos = string.find(str, split_char)
        if (not pos) then
            sub_str_tab[#sub_str_tab + 1] = str
            break
        end
        local sub_str = string.sub(str, 1, pos - 1)
        sub_str_tab[#sub_str_tab + 1] = sub_str
        str = string.sub(str, pos + 1, #str)
    end
    return sub_str_tab
end
-- 按split_char分割字符串str
-- added by fang. 2013.07.17
string.split = function (str, split_char)
-- 以下3行代码做数据校检（在底端设备上尽量去掉）
    if type(str) ~= "string" or #str == 0 then
        return {}
    end
    local nSepLen = string.len(split_char)
    local sub_str_tab = {}
    while (true) do
        local pos = string.find(str, split_char)
        if (not pos) then
            sub_str_tab[#sub_str_tab + 1] = str
            break
        end
        local sub_str = string.sub(str, 1, pos - 1)
        sub_str_tab[#sub_str_tab + 1] = sub_str
        str = string.sub(str, pos + nSepLen, #str)
    end
    return sub_str_tab
end
-- 按splitByChar分割字符串str
-- added by fang. 2013.10.14
string.splitByChar = function (str, char)
    local sub_str_tab = {}

    local lastPos=1

    local bLeft = false 
    for i=1, #str do
        local curChar = string.char(string.byte(str, i))
        if curChar == char then
            local size = #sub_str_tab
            sub_str_tab[size+1] = string.sub(str, lastPos, i-1)
            lastPos = i+1
            bLeft = false 
        else
            bLeft = true
        end
    end
    if bLeft then
       local size = #sub_str_tab
       sub_str_tab[size+1] = string.sub(str, lastPos)
    end
        
    return sub_str_tab
end

table.dictFromTable = function ( t_table )
    local t_dict = CCDictionary:create()
    for k,v in pairs(t_table) do
        if( type(v) == "table" )then
            table.dictFromTable(v)
        else
            t_dict:setObject(CCString:create(v), tostring(k))
        end
    end

    return t_dict
end

function file_exists(path)
    --print("file_exists:",path)
    --[[
    local realPath = CCFileUtils:sharedFileUtils():fullPathForFilename(path)
    local file = io.open(realPath, "rb")
    if file then file:close() end
    return file ~= nil
     --]]

    if(Platform.getOS() == "wp")then
        if(path == nil) then return "" end
        path = string.gsub(path,".mp3",".wav")
    end
    
    local realPath = CCFileUtils:sharedFileUtils():fullPathForFilename(path)
    print("realPath:",realPath)
    if(realPath==path)then
        return false
    else
        return true
    end
    --return CCFileUtils:sharedFileUtils():isFileExist(path)
end


-- 判断一个字符串是否是整型数字
string.isIntergerByStr = function ( m_str )
    print("m_str===",m_str)
    if(type(m_str) ~= "string")then
        return false
    end

    local isInterger = true
    for i=1,string.len(m_str) do
        local char_num =  string.byte(m_str, i)
        print("char_num===",char_num, type(char_num))
        if(char_num<48 or char_num>57)then
            print("char_num<0 or char_num>9char_num<0 or char_num>9")
            isInterger = false
            break
        end
    end

    return isInterger
end

-- 比较版本号 格式必须是 1.2.0 <==> xx.xx.xx return 1/0/-1 <==> >/=/<
string.checkScriptVersion = function ( newVersion, oldVersion )
    
    local n_version_arr = {0,0,0}
    local o_version_arr = {0,0,0}
    local n_t_arr = string.splitByChar(newVersion, ".")
    local o_t_arr = string.splitByChar(oldVersion, ".")
    
    for k,v in pairs(n_t_arr) do
        n_version_arr[k] = v
    end
    for k,v in pairs(o_t_arr) do
        o_version_arr[k] = v
    end


    if( tonumber(n_version_arr[1]) > tonumber(o_version_arr[1]) )then
        return 1
    elseif( tonumber(n_version_arr[2]) > tonumber(o_version_arr[2]) and tonumber(n_version_arr[1]) == tonumber(o_version_arr[1]))then
        return 1
    elseif( tonumber(n_version_arr[3]) > tonumber(o_version_arr[3]) and tonumber(n_version_arr[2]) == tonumber(o_version_arr[2]) and  tonumber(n_version_arr[1]) == tonumber(o_version_arr[1]))then
        return 1
    elseif( tonumber(n_version_arr[3]) == tonumber(o_version_arr[3]) and tonumber(n_version_arr[2]) == tonumber(o_version_arr[2]) and  tonumber(n_version_arr[1]) == tonumber(o_version_arr[1]))then
        return 0
    else
        return -1
    end

end

---打印tab结构 lichenyang
function print_t(sth)
    if not g_debug_mode then
        return
    end
    if type(sth) ~= "table" then
        print(sth)
        return
    end

    local space, deep = string.rep(' ', 4), 0
    local function _dump(t)
        local temp = {}
        for k,v in pairs(t) do
            local key = tostring(k)

            if type(v) == "table" then
                deep = deep + 2
                print(string.format("%s[%s] => Table\n%s(",
                string.rep(space, deep - 1),
                key,
                string.rep(space, deep) ) ) --print.
                _dump(v)

                print(string.format("%s)",string.rep(space, deep)))
                deep = deep - 2
            else
                print(string.format("%s[%s] => %s",
                string.rep(space, deep + 1),
                key,
                tostring(v) ) ) --print.  change by zhangqi, 20130604, 加了tostring避免v是nil或其他值时的崩溃
            end 
        end 
    end
    print(string.format("Table\n("))
    _dump(sth)
    print(string.format(")"))
end

-- added by bzx
-- 把字符串转成table 类似“xxx|xxx|xxx,xxx|xxx|xxx”
function strToTable(str,types)
    local data_array1 = string.split(str, ",")
    local data = {}
    for i = 1, #data_array1 do
        local data_array2 = string.split(data_array1[i], "|")
        data[i] = strTableToTable(data_array2, types)
    end
    return data
end

-- added by bzx
-- 把字符串转成table类似 “xxx|xxx|xxx”
function strTableToTable(str_table, types)
    local data = {}
    for i = 1, #str_table do
        local str_element = str_table[i]
        if types ~= nil then
            local element_type = types[i]
            if element_type == "str" then
                data[i] = str_element
            elseif element_type == "n" then
                data[i] = tonumber(str_element)
            end
        else
            data[i] = tonumber(str_element) or str_element
        end
    end
    return data
end

-- added by bzx
-- 将单身条DB数据进行解析，使得string型的数字table转换成table
function parseDB(db)
    local new_db = {}
    for k, v in pairs(db) do
        local data = v
        local t = nil
        if type(data) == "string" then
           local position =  string.find(data, "|")
           if position ~= nil then
               local t1 = string.split(data, ",")
               if #t1 == 1 then
                    t = strTableToTable(string.split(data, "|"), nil)
               else
                    t = strToTable(data, nil)
               end
           else
            t = data
           end
        else
            t = data
        end
        new_db[k] = t
    end
    setmetatable(new_db, getmetatable(db))
    return new_db
end

-- added by bzx
-- 得到一个map的长度
function getMapSize(map)
    local size = 0
    for k, v in pairs(map) do
        size = size + 1
    end
    return size
end

-- added by bzx
-- 以array的结构得到一个map的value
function getValues(map)
    local values = {}
    for k, v in pairs(map) do
        table.insert(values, v)
    end
    return values
end

-- added by bzx
-- 得到VIP的最小需求等级
function getNecessaryVipLevel(field, tag, isOpen)
    local i = 1
    require "db/DB_Vip"
    local vip_db = DB_Vip.getDataById(i)
    local vip_level = nil
    while vip_db ~= nil and vip_db[field] == tag do
        if isOpen ~= nil and isOpen(vip_db[field]) == false then
            break
        end
        i = i + 1
        vip_db = DB_Vip.getDataById(i)
    end
    local vip_level = nil
    if i == 1 then
        vip_level = 0
    else
        vip_level = i - 1
    end
    return vip_level
end

-- add by chengliang
--------------------------- url_encode -------------------------
string.escape = function (w)  
    pattern="[^%w%d%._%-%* ]"  
    s=string.gsub(w,pattern,function(c)  
        local c=string.format("%%%02X",string.byte(c))  
        return c  
    end)  
    s=string.gsub(s," ","+")  
    return s  
end  
      
string.detail_escape = function(w)  
    local t={}  
    for i=1,#w do  
        c = string.sub(w,i,i)  
        b,e = string.find(c,"[%w%d%._%-'%* ]")  
        if not b then  
            t[#t+1]=string.format("%%%02X",string.byte(c))  
        else  
            t[#t+1]=c  
        end  
    end  
    s = table.concat(t)  
    s = string.gsub(s," ","+")  
    return s  
end  
      
string.unescape = function (w)  
    s=string.gsub(w,"+"," ")  
    s,n = string.gsub(s,"%%(%x%x)",function(c)  
        return string.char(tonumber(c,16))  
    end)  
    return s  
end

-- urlEncode
string.urlEncode = function (url)
    local aByte, zByte, AByte, ZByte, _Byte, dotByte, hypeByte, n0Byte, n9Byte = string.byte("azAZ_.-09", 1, 9)
    local ret = ""
    for i = 1, url:len() do
        local c = string.byte(url, i)
        if (c >= aByte and c <= zByte) or (c >= AByte and c <= ZByte) or (c>=n0Byte and  c<=n9Byte) or c == _Byte or c == dotByte or c == hypeByte then
            ret = ret .. string.char(c)
        else
            ret = ret .. '%'
            ret = ret .. string.format("%x", c)
        end
    end
    return ret
end

--android GC
local function getFreeMemory()

    local count = 0
    local result = {
        ["MemFree"] = 0,
        ["Buffers"] = 0,
        ["Cached"] = 0,
    }

    for line in io.lines('/proc/meminfo') do
        for key in string.gmatch(line, "%a+") do
            if result[key] == nil then
                break
            end

            for value in string.gmatch(line,"%d+") do
                result[key] = tonumber(value)
            end

            count = count + 1
            if count >= 3 then
                break
            end
        end
    end
    return result

end
local _iLastFree=0
local _iLastMemory=0
function checkMem(...)

    local meminfo = getFreeMemory()
    local memory = meminfo.MemFree + meminfo.Buffers + meminfo.Cached
    local free = meminfo.MemFree
    print("free memory [" .. free .. "," .. memory .. "], [" ..  _iLastFree .. "," .. _iLastMemory .. "]")
    
    if memory > _iLastMemory then
        _iLastMemory = memory
    end
    
    if free > _iLastFree then
        _iLastFree = free 
        return
    end

    if _iLastFree >= free * 2 or _iLastMemory >= memory * 2 then
        print("low memory, purge cached data now")
        CCDirector:sharedDirector():purgeCachedData()
        collectgarbage("collect", 100)
        _iLastFree = 0
        _iLastMemory = 0
    end
end


